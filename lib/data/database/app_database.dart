import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quantane/data/database/tables/geocoding_cache_table.dart';
import 'package:quantane/data/database/tables/vehicles_table.dart';
import 'package:quantane/data/database/tables/fuel_entries_table.dart' as fuel;
import 'package:quantane/data/database/tables/trips_table.dart' as trip;
import 'package:quantane/data/database/tables/sync_queue_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Vehicles, fuel.FuelEntries, trip.Trips, GeocodingCache, SyncQueue],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(trips, trips.startAddress);
        await migrator.addColumn(trips, trips.endAddress);
        await migrator.addColumn(trips, trips.minLatitude);
        await migrator.addColumn(trips, trips.maxLatitude);
        await migrator.addColumn(trips, trips.minLongitude);
        await migrator.addColumn(trips, trips.maxLongitude);
        await migrator.addColumn(trips, trips.routeSnapshotPath);
        await migrator.addColumn(trips, trips.routePointsJson);
        await migrator.createTable(geocodingCache);
      }
      if (from < 3) {
        await delete(geocodingCache).go();
      }
      if (from < 4) {
        await migrator.addColumn(vehicles, vehicles.lastUpdated);
        await migrator.addColumn(fuelEntries, fuelEntries.lastUpdated);
        await migrator.addColumn(trips, trips.lastUpdated);
        await migrator.createTable(syncQueue);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'quantane_db');
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();

    await transaction(() async {
      await delete(syncQueue).go();
      await delete(trips).go();
      await delete(fuelEntries).go();
      await delete(vehicles).go();
      await delete(geocodingCache).go();
    });

    await prefs.remove('active_vehicle_id');
    await _deleteTripSnapshotsDirectory();
  }

  static Future<void> _deleteTripSnapshotsDirectory() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final snapshotsDir = Directory('${documentsDir.path}/trip_snapshots');
      if (await snapshotsDir.exists()) {
        await snapshotsDir.delete(recursive: true);
      }
    } catch (_) {
      // Best-effort cleanup during reset.
    }
  }

  Future<void> queueSync({
    required String action,
    required String entityType,
    required String entityId,
    String? payload,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      await into(syncQueue).insert(
        SyncQueueCompanion.insert(
          userId: currentUser.uid,
          action: action,
          entityType: entityType,
          entityId: entityId,
          payload: Value(payload),
          createdAt: Value(DateTime.now()),
        ),
      );
    } catch (_) {
      // Firebase is not initialized (e.g. in unit tests), skip sync queue logging.
    }
  }
}
