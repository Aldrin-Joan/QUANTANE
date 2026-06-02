import 'package:quantane/data/database/app_database.dart';

enum VehicleType { bike, car, truck }

enum FuelType { petrol, diesel, ev, cng }

class Vehicle {
  final String id;
  final String name;
  final VehicleType type;
  final FuelType fuelType;
  final double? tankCapacity;
  final double initialOdometer;
  final DateTime createdAt;

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.fuelType,
    this.tankCapacity,
    required this.initialOdometer,
    required this.createdAt,
  });

  factory Vehicle.fromDrift(VehicleEntry entry) {
    return Vehicle(
      id: entry.id,
      name: entry.name,
      type: VehicleType.values.firstWhere((e) => e.name == entry.type),
      fuelType: FuelType.values.firstWhere((e) => e.name == entry.fuelType),
      tankCapacity: entry.tankCapacity,
      initialOdometer: entry.initialOdometer,
      createdAt: DateTime.parse(entry.createdAt),
    );
  }
}
