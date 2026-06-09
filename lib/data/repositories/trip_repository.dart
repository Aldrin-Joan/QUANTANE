import 'package:drift/drift.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/database/database_provider.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_repository.g.dart';

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

  Future<void> insert(Trip trip) async {
    await _db
        .into(_db.trips)
        .insert(
          TripsCompanion.insert(
            id: trip.id,
            vehicleId: trip.vehicleId,
            startTime: trip.startTime.toIso8601String(),
            endTime: Value(trip.endTime?.toIso8601String()),
            distance: Value(trip.distance),
            avgSpeed: Value(trip.avgSpeed),
            maxSpeed: Value(trip.maxSpeed),
            minSpeed: Value(trip.minSpeed),
          ),
        );
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.trips)..where((t) => t.id.equals(id))).go();
  }
}

@Riverpod(keepAlive: true)
TripRepository tripRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TripRepository(db);
}
