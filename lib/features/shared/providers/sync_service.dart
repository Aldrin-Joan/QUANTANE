import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/database/database_provider.dart';
import 'package:quantane/data/repositories/fuel_repository.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/data/repositories/vehicle_repository.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/domain/models/vehicle.dart';
import 'package:quantane/features/shared/providers/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sync_service.g.dart';

enum SyncStateStatus { idle, syncing, success, error }

class SyncProgress {
  final SyncStateStatus status;
  final String? lastSyncTime;
  final int pendingOpsCount;
  final String? errorMessage;

  SyncProgress({
    required this.status,
    this.lastSyncTime,
    this.pendingOpsCount = 0,
    this.errorMessage,
  });

  SyncProgress copyWith({
    SyncStateStatus? status,
    String? lastSyncTime,
    int? pendingOpsCount,
    String? errorMessage,
  }) {
    return SyncProgress(
      status: status ?? this.status,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      pendingOpsCount: pendingOpsCount ?? this.pendingOpsCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@Riverpod(keepAlive: true)
class SyncService extends _$SyncService with WidgetsBindingObserver {
  late final FirebaseFirestore _firestore;
  late final AppDatabase _db;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<List<SyncQueueEntry>>? _syncQueueSubscription;
  Timer? _debounceTimer;
  Timer? _periodicSyncTimer;
  bool _isSyncing = false;
  int _lastQueueCount = 0;

  @override
  SyncProgress build() {
    _firestore = FirebaseFirestore.instance;
    _db = ref.watch(appDatabaseProvider);

    _init();

    ref.onDispose(() {
      _connectivitySubscription?.cancel();
      _syncQueueSubscription?.cancel();
      _debounceTimer?.cancel();
      _periodicSyncTimer?.cancel();
      WidgetsBinding.instance.removeObserver(this);
    });

    return SyncProgress(status: SyncStateStatus.idle);
  }

  Future<void> _init() async {
    WidgetsBinding.instance.addObserver(this);

    // Watch connectivity to trigger sync on reconnection
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );
      if (hasConnection && ref.read(authServiceProvider).isSyncEnabled) {
        syncNow();
      }
    });

    // Sync whenever auth status is updated
    ref.listen(authServiceProvider, (previous, next) {
      if (next.isSyncEnabled && next.user != null) {
        syncNow();
      }
    });

    // Reactive local mutation sync (when queue size increases)
    _syncQueueSubscription = _db.select(_db.syncQueue).watch().listen((items) {
      final newCount = items.length;
      if (newCount > _lastQueueCount && !_isSyncing) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 2), () {
          syncNow();
        });
      }
      _lastQueueCount = newCount;
    });

    // Periodic sync timer (every 5 minutes)
    _periodicSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (ref.read(authServiceProvider).isSyncEnabled) {
        syncNow();
      }
    });

    // Check initially for pending operations count
    _updatePendingCount();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (ref.read(authServiceProvider).isSyncEnabled) {
        syncNow();
      }
    }
  }

  Future<void> _updatePendingCount() async {
    final auth = ref.read(authServiceProvider);
    if (auth.user == null) {
      state = state.copyWith(pendingOpsCount: 0);
      return;
    }

    final items = await (_db.select(
      _db.syncQueue,
    )..where((t) => t.userId.equals(auth.user!.uid))).get();
    final count = items.length;

    final prefs = await SharedPreferences.getInstance();
    final lastTime = prefs.getString('last_sync_time_${auth.user!.uid}');

    state = state.copyWith(pendingOpsCount: count, lastSyncTime: lastTime);
  }

  Future<void> syncNow() async {
    if (_isSyncing) return;
    final auth = ref.read(authServiceProvider);
    if (!auth.isSyncEnabled || auth.user == null) return;

    _isSyncing = true;
    state = state.copyWith(status: SyncStateStatus.syncing);

    try {
      final connectivity = await Connectivity().checkConnectivity();
      final hasConnection = connectivity.any(
        (result) => result != ConnectivityResult.none,
      );
      if (!hasConnection) {
        throw Exception('No internet connection.');
      }

      final uid = auth.user!.uid;

      // 1. Process local mutations (Outbox upload)
      await _uploadOutbox(uid);

      // 2. Fetch remote modifications (Inbox download)
      await _downloadInbox(uid);

      final now = DateTime.now();
      final lastSyncTimeStr =
          '${now.day}/${now.month} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_sync_time_$uid', lastSyncTimeStr);

      state = SyncProgress(
        status: SyncStateStatus.success,
        lastSyncTime: lastSyncTimeStr,
        pendingOpsCount: 0,
      );
    } catch (e) {
      debugPrint('Sync failed: $e');
      state = state.copyWith(
        status: SyncStateStatus.error,
        errorMessage: e.toString(),
      );
    } finally {
      _isSyncing = false;
      _updatePendingCount();
    }
  }

  Future<void> _uploadOutbox(String uid) async {
    // Read all pending items in chronological order
    final queueItems =
        await (_db.select(_db.syncQueue)
              ..where((t) => t.userId.equals(uid))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();

    for (final item in queueItems) {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection(item.entityType)
          .doc(item.entityId);

      if (item.action == 'DELETE') {
        // Delete document from Firestore
        await docRef.delete();

        // Write a deletion tombstone to let other clients know to delete it locally
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('deletions')
            .doc(item.entityId)
            .set({
              'entityType': item.entityType,
              'entityId': item.entityId,
              'deletedAt': FieldValue.serverTimestamp(),
            });
      } else {
        // INSERT or UPDATE
        // Query local DB for the entity
        Map<String, dynamic>? dataToUpload;

        if (item.entityType == 'vehicles') {
          var row = await ref
              .read(vehicleRepositoryProvider)
              .getById(item.entityId);
          if (row != null) {
            if (row.lastUpdated == null) {
              final now = DateTime.now().toUtc();
              row = row.copyWith(lastUpdated: now);
              await ref
                  .read(vehicleRepositoryProvider)
                  .insert(row, syncToFirebase: false);
            }
            dataToUpload = row.toJson();
          }
        } else if (item.entityType == 'fuel_entries') {
          // Find the fuel entry
          final rowQuery = _db.select(_db.fuelEntries)
            ..where((t) => t.id.equals(item.entityId));
          final data = await rowQuery.getSingleOrNull();
          if (data != null) {
            var entryData = data;
            if (entryData.lastUpdated == null) {
              final now = DateTime.now().toUtc();
              await (_db.update(_db.fuelEntries)
                    ..where((t) => t.id.equals(entryData.id)))
                  .write(FuelEntriesCompanion(lastUpdated: Value(now)));
              final updatedRow = await (_db.select(_db.fuelEntries)
                    ..where((t) => t.id.equals(entryData.id)))
                  .getSingle();
              entryData = updatedRow;
            }

            // Need to get previous odometer to build FuelEntry model
            final allForVehicle =
                await (_db.select(_db.fuelEntries)
                      ..where((t) => t.vehicleId.equals(entryData.vehicleId))
                      ..orderBy([(t) => OrderingTerm.asc(t.odometer)]))
                    .get();
            final idx = allForVehicle.indexWhere((e) => e.id == entryData.id);
            final prevOdom = idx > 0 ? allForVehicle[idx - 1].odometer : null;
            dataToUpload = FuelEntry.fromDrift(
              entryData,
              previousOdometer: prevOdom,
            ).toJson();
          }
        } else if (item.entityType == 'trips') {
          var row = await ref
              .read(tripRepositoryProvider)
              .getById(item.entityId);
          if (row != null) {
            if (row.lastUpdated == null) {
              final now = DateTime.now().toUtc();
              row = row.copyWith(lastUpdated: now);
              await ref
                  .read(tripRepositoryProvider)
                  .insert(row, syncToFirebase: false);
            }
            dataToUpload = row.toJson();
          }
        }

        if (dataToUpload != null) {
          // Add/merge to Firestore
          await docRef.set(dataToUpload, SetOptions(merge: true));
        }
      }

      // Dequeue locally
      await (_db.delete(
        _db.syncQueue,
      )..where((t) => t.id.equals(item.id))).go();
    }
  }

  Future<void> _downloadInbox(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncTimePrefKey = 'last_sync_timestamp_$uid';
    final lastSyncMs = prefs.getInt(lastSyncTimePrefKey) ?? 0;
    
    // Apply a safety buffer of 5 minutes to account for clock skew/drift between devices and Firestore server
    final lastSyncTime = lastSyncMs > 0
        ? DateTime.fromMillisecondsSinceEpoch(lastSyncMs).subtract(const Duration(minutes: 5))
        : DateTime.fromMillisecondsSinceEpoch(0);

    final newSyncTime = DateTime.now();

    // 1. Fetch remote deletions
    final deletionsSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('deletions')
        .where('deletedAt', isGreaterThan: Timestamp.fromDate(lastSyncTime))
        .get();

    for (final doc in deletionsSnapshot.docs) {
      final deletionData = doc.data();
      final entityType = deletionData['entityType'] as String;
      final entityId = deletionData['entityId'] as String;

      if (entityType == 'vehicles') {
        await ref
            .read(vehicleRepositoryProvider)
            .delete(entityId, syncToFirebase: false);
      } else if (entityType == 'fuel_entries') {
        await ref
            .read(fuelRepositoryProvider)
            .delete(entityId, syncToFirebase: false);
      } else if (entityType == 'trips') {
        await ref
            .read(tripRepositoryProvider)
            .delete(entityId, syncToFirebase: false);
      }
    }

    // 2. Sync Vehicles
    final vehiclesSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('vehicles')
        .where('lastUpdated', isGreaterThan: lastSyncTime.toUtc().toIso8601String())
        .get();

    for (final doc in vehiclesSnapshot.docs) {
      final vehicle = Vehicle.fromJson(doc.data());
      // Conflict Resolution: compare with local vehicle
      final local = await ref
          .read(vehicleRepositoryProvider)
          .getById(vehicle.id);
      if (local == null ||
          vehicle.lastUpdated == null ||
          local.lastUpdated == null ||
          vehicle.lastUpdated!.isAfter(local.lastUpdated!)) {
        await ref
            .read(vehicleRepositoryProvider)
            .insert(vehicle, syncToFirebase: false);
      }
    }

    // 3. Sync Fuel Entries
    final fuelSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('fuel_entries')
        .where('lastUpdated', isGreaterThan: lastSyncTime.toUtc().toIso8601String())
        .get();

    for (final doc in fuelSnapshot.docs) {
      final entry = FuelEntry.fromJson(doc.data());
      final localRows = await (_db.select(
        _db.fuelEntries,
      )..where((t) => t.id.equals(entry.id))).get();
      final localData = localRows.isNotEmpty ? localRows.first : null;

      if (localData == null ||
          entry.lastUpdated == null ||
          localData.lastUpdated == null ||
          entry.lastUpdated!.isAfter(localData.lastUpdated!)) {
        await ref
            .read(fuelRepositoryProvider)
            .insert(entry, syncToFirebase: false);
      }
    }

    // 4. Sync Trips
    final tripsSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('trips')
        .where('lastUpdated', isGreaterThan: lastSyncTime.toUtc().toIso8601String())
        .get();

    for (final doc in tripsSnapshot.docs) {
      final trip = Trip.fromJson(doc.data());
      final local = await ref.read(tripRepositoryProvider).getById(trip.id);

      if (local == null ||
          trip.lastUpdated == null ||
          local.lastUpdated == null ||
          trip.lastUpdated!.isAfter(local.lastUpdated!)) {
        await ref
            .read(tripRepositoryProvider)
            .insert(trip, syncToFirebase: false);
      }
    }

    // Save download timestamp
    await prefs.setInt(lastSyncTimePrefKey, newSyncTime.millisecondsSinceEpoch);
  }
}
