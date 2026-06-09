import 'package:quantane/data/database/app_database.dart';

class FuelEntry {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double fuelCost;
  final double fuelLiters;
  final double odometer;
  final String? station;
  final String? notes;
  final double? mileage; // Computed
  final double? costPerKm; // Computed

  FuelEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.fuelCost,
    required this.fuelLiters,
    required this.odometer,
    this.station,
    this.notes,
    this.mileage,
    this.costPerKm,
  });

  factory FuelEntry.fromDrift(FuelEntryData data, {double? previousOdometer}) {
    double? mileage;
    double? costPerKm;

    if (previousOdometer != null && data.odometer > previousOdometer) {
      final distance = data.odometer - previousOdometer;
      if (distance > 0 && data.fuelLiters > 0) {
        mileage = distance / data.fuelLiters;
        costPerKm = data.fuelCost / distance;
      }
    }

    return FuelEntry(
      id: data.id,
      vehicleId: data.vehicleId,
      date: DateTime.parse(data.date),
      fuelCost: data.fuelCost,
      fuelLiters: data.fuelLiters,
      odometer: data.odometer,
      station: data.station,
      notes: data.notes,
      mileage: mileage,
      costPerKm: costPerKm,
    );
  }
}
