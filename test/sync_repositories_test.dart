import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/repositories/vehicle_repository.dart';
import 'package:quantane/data/repositories/fuel_repository.dart';
import 'package:quantane/domain/models/vehicle.dart';
import 'package:quantane/domain/models/fuel_entry.dart';

void main() {
  group('Sync Repositories Conflict Resolution and Timezone Tests', () {
    late AppDatabase database;
    late VehicleRepository vehicleRepository;
    late FuelRepository fuelRepository;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      vehicleRepository = VehicleRepository(database);
      fuelRepository = FuelRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('VehicleRepository.insert uses insertOrReplace to resolve primary key conflict', () async {
      final vehicle = Vehicle(
        id: 'v-1',
        name: 'Guest Bike',
        type: VehicleType.bike,
        fuelType: FuelType.petrol,
        tankCapacity: 15.0,
        initialOdometer: 100.0,
        createdAt: DateTime(2026, 7, 5, 10).toLocal(),
      );

      // Insert once
      await vehicleRepository.insert(vehicle, syncToFirebase: false);

      // Re-inserting the same ID with modified values should replace it without collision
      final updatedVehicle = vehicle.copyWith(
        name: 'Merged Bike',
        tankCapacity: 16.0,
      );

      await vehicleRepository.insert(updatedVehicle, syncToFirebase: false);

      final loaded = await vehicleRepository.getById('v-1');
      expect(loaded, isNotNull);
      expect(loaded!.name, 'Merged Bike');
      expect(loaded.tankCapacity, 16.0);
    });

    test('FuelRepository.insert uses insertOrReplace to resolve primary key conflict', () async {
      final entry = FuelEntry(
        id: 'f-1',
        vehicleId: 'v-1',
        date: DateTime(2026, 7, 5, 10).toLocal(),
        fuelCost: 10.0,
        fuelLiters: 5.0,
        odometer: 150.0,
      );

      // Insert once
      await fuelRepository.insert(entry, syncToFirebase: false);

      // Re-inserting the same ID with modified cost/liters should replace it without collision
      final updatedEntry = entry.copyWith(
        fuelCost: 12.0,
        fuelLiters: 6.0,
      );

      await fuelRepository.insert(updatedEntry, syncToFirebase: false);

      final loadedRows = await (database.select(database.fuelEntries)
            ..where((t) => t.id.equals('f-1')))
          .get();
      expect(loadedRows.length, 1);
      expect(loadedRows.first.fuelCost, 12.0);
      expect(loadedRows.first.fuelLiters, 6.0);
    });

    test('Repositories store and return DateTime fields converted to UTC', () async {
      final localTime = DateTime(2026, 7, 5, 10, 30, 0); // local timezone
      final vehicle = Vehicle(
        id: 'v-2',
        name: 'Test Vehicle',
        type: VehicleType.car,
        fuelType: FuelType.diesel,
        initialOdometer: 0.0,
        createdAt: localTime,
      );

      await vehicleRepository.insert(vehicle, syncToFirebase: false);

      final loaded = await vehicleRepository.getById('v-2');
      expect(loaded, isNotNull);
      expect(loaded!.createdAt.isUtc, isTrue);
      expect(loaded.createdAt, localTime.toUtc());
      expect(loaded.lastUpdated, isNotNull);
      expect(loaded.lastUpdated!.isUtc, isTrue);
    });
  });
}
