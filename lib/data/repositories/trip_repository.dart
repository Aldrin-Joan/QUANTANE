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
    final directory = Directory(
      '${documentsDir.path}/$snapshotsFolderName',
    );
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

  Future<void> insert(Trip trip) async {
    await _db.into(_db.trips).insert(
      TripsCompanion.insert(
        id: trip.id,
        vehicleId: trip.vehicleId,
        startTime: trip.startTime.toIso8601String(),
        endTime: Value(trip.endTime?.toIso8601String()),
        distance: Value(trip.distance),
        avgSpeed: Value(trip.avgSpeed),
        maxSpeed: Value(trip.maxSpeed),
        minSpeed: Value(trip.minSpeed),
        startAddress: Value(trip.startAddress),
        endAddress: Value(trip.endAddress),
        minLatitude: Value(trip.minLatitude),
        maxLatitude: Value(trip.maxLatitude),
        minLongitude: Value(trip.minLongitude),
        maxLongitude: Value(trip.maxLongitude),
        routeSnapshotPath: Value(trip.routeSnapshotPath),
        routePointsJson: Value(Trip.encodeRoutePoints(trip.routePoints)),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> delete(String id) async {
    final existing = await getById(id);
    await (_db.delete(_db.trips)..where((t) => t.id.equals(id))).go();
    await TripSnapshotStorage.deleteSnapshot(existing?.routeSnapshotPath);
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
