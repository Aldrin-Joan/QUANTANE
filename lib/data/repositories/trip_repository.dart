import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/database/database_provider.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_repository.g.dart';

class TripSnapshotStorage {
  static const String snapshotsFolderName = 'trip_snapshots';

  static Future<Directory> Function()? documentsDirectoryOverride;

  static Future<Directory> _documentsDirectory() {
    return documentsDirectoryOverride?.call() ??
        getApplicationDocumentsDirectory();
  }

  static Future<Directory> snapshotsDirectory() async {
    final documentsDir = await _documentsDirectory();
    final directory = Directory('${documentsDir.path}/$snapshotsFolderName');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  static String relativeSnapshotPath(String tripId) {
    return '$snapshotsFolderName/$tripId.png';
  }

  static Future<File> snapshotFile(String tripId) async {
    final directory = await snapshotsDirectory();
    return File('${directory.path}/$tripId.png');
  }

  static Future<void> deleteSnapshot(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) {
      return;
    }

    try {
      final documentsDir = await _documentsDirectory();
      final file = File('${documentsDir.path}/$relativePath');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Best-effort cleanup.
    }
  }
}

class TripRepository {
  final AppDatabase _db;

  TripRepository(this._db);

  Stream<List<Trip>> watchAll(String vehicleId) {
    return (_db.select(_db.trips)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .watch()
        .map((rows) => rows.map((row) => Trip.fromDrift(row)).toList());
  }

  Future<Trip?> getById(String id) async {
    final row = await (_db.select(
      _db.trips,
    )..where((trip) => trip.id.equals(id))).getSingleOrNull();
    return row == null ? null : Trip.fromDrift(row);
  }

  Future<void> insert(Trip trip, {bool syncToFirebase = true}) async {
    final now = DateTime.now().toUtc();
    final updatedTrip = trip.lastUpdated == null
        ? trip.copyWith(lastUpdated: now, startTime: trip.startTime.toUtc(), endTime: trip.endTime?.toUtc())
        : trip.copyWith(startTime: trip.startTime.toUtc(), endTime: trip.endTime?.toUtc(), lastUpdated: trip.lastUpdated?.toUtc());

    await _db.transaction(() async {
      await _db
          .into(_db.trips)
          .insert(
            TripsCompanion.insert(
              id: updatedTrip.id,
              vehicleId: updatedTrip.vehicleId,
              startTime: updatedTrip.startTime.toIso8601String(),
              endTime: Value(updatedTrip.endTime?.toIso8601String()),
              distance: Value(updatedTrip.distance),
              avgSpeed: Value(updatedTrip.avgSpeed),
              maxSpeed: Value(updatedTrip.maxSpeed),
              minSpeed: Value(updatedTrip.minSpeed),
              startAddress: Value(updatedTrip.startAddress),
              endAddress: Value(updatedTrip.endAddress),
              minLatitude: Value(updatedTrip.minLatitude),
              maxLatitude: Value(updatedTrip.maxLatitude),
              minLongitude: Value(updatedTrip.minLongitude),
              maxLongitude: Value(updatedTrip.maxLongitude),
              routeSnapshotPath: Value(updatedTrip.routeSnapshotPath),
              routePointsJson: Value(
                Trip.encodeRoutePoints(updatedTrip.routePoints),
              ),
              lastUpdated: Value(updatedTrip.lastUpdated),
            ),
            mode: InsertMode.insertOrReplace,
          );

      if (syncToFirebase) {
        await _db.queueSync(
          action: 'INSERT',
          entityType: 'trips',
          entityId: updatedTrip.id,
          payload: jsonEncode(updatedTrip.toJson()),
        );
      }
    });
  }

  Future<void> delete(String id, {bool syncToFirebase = true}) async {
    await _db.transaction(() async {
      final existing = await getById(id);
      await (_db.delete(_db.trips)..where((t) => t.id.equals(id))).go();
      await TripSnapshotStorage.deleteSnapshot(existing?.routeSnapshotPath);

      if (syncToFirebase) {
        await _db.queueSync(
          action: 'DELETE',
          entityType: 'trips',
          entityId: id,
        );
      }
    });
  }
}

@Riverpod(keepAlive: true)
TripRepository tripRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TripRepository(db);
}

@riverpod
Future<Trip?> tripById(Ref ref, String tripId) {
  return ref.watch(tripRepositoryProvider).getById(tripId);
}
