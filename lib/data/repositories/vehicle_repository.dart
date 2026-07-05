import 'dart:convert';
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

  Future<void> insert(Vehicle vehicle, {bool syncToFirebase = true}) async {
    final now = DateTime.now().toUtc();
    final updatedVehicle = vehicle.lastUpdated == null
        ? vehicle.copyWith(lastUpdated: now, createdAt: vehicle.createdAt.toUtc())
        : vehicle.copyWith(createdAt: vehicle.createdAt.toUtc(), lastUpdated: vehicle.lastUpdated?.toUtc());

    await _db.transaction(() async {
      await _db
          .into(_db.vehicles)
          .insert(
            VehiclesCompanion.insert(
              id: updatedVehicle.id,
              name: updatedVehicle.name,
              type: updatedVehicle.type.name,
              fuelType: updatedVehicle.fuelType.name,
              tankCapacity: Value(updatedVehicle.tankCapacity),
              initialOdometer: Value(updatedVehicle.initialOdometer),
              createdAt: updatedVehicle.createdAt.toIso8601String(),
              lastUpdated: Value(updatedVehicle.lastUpdated),
            ),
            mode: InsertMode.insertOrReplace,
          );

      if (syncToFirebase) {
        await _db.queueSync(
          action: 'INSERT',
          entityType: 'vehicles',
          entityId: updatedVehicle.id,
          payload: jsonEncode(updatedVehicle.toJson()),
        );
      }
    });
  }

  Future<void> update(Vehicle vehicle, {bool syncToFirebase = true}) async {
    final now = DateTime.now().toUtc();
    final updatedVehicle = vehicle.copyWith(
      lastUpdated: now,
      createdAt: vehicle.createdAt.toUtc(),
    );

    await _db.transaction(() async {
      await (_db.update(
        _db.vehicles,
      )..where((t) => t.id.equals(updatedVehicle.id))).write(
        VehiclesCompanion(
          name: Value(updatedVehicle.name),
          type: Value(updatedVehicle.type.name),
          fuelType: Value(updatedVehicle.fuelType.name),
          tankCapacity: Value(updatedVehicle.tankCapacity),
          initialOdometer: Value(updatedVehicle.initialOdometer),
          lastUpdated: Value(updatedVehicle.lastUpdated),
        ),
      );

      if (syncToFirebase) {
        await _db.queueSync(
          action: 'UPDATE',
          entityType: 'vehicles',
          entityId: updatedVehicle.id,
          payload: jsonEncode(updatedVehicle.toJson()),
        );
      }
    });
  }

  Future<void> delete(String id, {bool syncToFirebase = true}) async {
    await _db.transaction(() async {
      await (_db.delete(_db.vehicles)..where((t) => t.id.equals(id))).go();

      if (syncToFirebase) {
        await _db.queueSync(
          action: 'DELETE',
          entityType: 'vehicles',
          entityId: id,
        );
      }
    });
  }
}

@Riverpod(keepAlive: true)
VehicleRepository vehicleRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return VehicleRepository(db);
}
