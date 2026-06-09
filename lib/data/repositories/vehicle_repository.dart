import 'package:drift/drift.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/database/database_provider.dart';
import 'package:quantane/domain/models/vehicle.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vehicle_repository.g.dart';

class VehicleRepository {
  final AppDatabase _db;

  VehicleRepository(this._db);

  Stream<List<Vehicle>> watchAll() {
    return _db
        .select(_db.vehicles)
        .watch()
        .map((rows) => rows.map((row) => Vehicle.fromDrift(row)).toList());
  }

  Future<Vehicle?> getById(String id) async {
    final query = _db.select(_db.vehicles)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? Vehicle.fromDrift(row) : null;
  }

  Future<void> insert(Vehicle vehicle) async {
    await _db
        .into(_db.vehicles)
        .insert(
          VehiclesCompanion.insert(
            id: vehicle.id,
            name: vehicle.name,
            type: vehicle.type.name,
            fuelType: vehicle.fuelType.name,
            tankCapacity: Value(vehicle.tankCapacity),
            initialOdometer: Value(vehicle.initialOdometer),
            createdAt: vehicle.createdAt.toIso8601String(),
          ),
        );
  }

  Future<void> update(Vehicle vehicle) async {
    await (_db.update(
      _db.vehicles,
    )..where((t) => t.id.equals(vehicle.id))).write(
      VehiclesCompanion(
        name: Value(vehicle.name),
        type: Value(vehicle.type.name),
        fuelType: Value(vehicle.fuelType.name),
        tankCapacity: Value(vehicle.tankCapacity),
        initialOdometer: Value(vehicle.initialOdometer),
      ),
    );
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.vehicles)..where((t) => t.id.equals(id))).go();
  }
}

@Riverpod(keepAlive: true)
VehicleRepository vehicleRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return VehicleRepository(db);
}
