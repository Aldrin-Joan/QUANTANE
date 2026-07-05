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
  final DateTime? lastUpdated;

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
    this.lastUpdated,
  });

  FuelEntry copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    double? fuelCost,
    double? fuelLiters,
    double? odometer,
    String? station,
    String? notes,
    double? mileage,
    double? costPerKm,
    DateTime? lastUpdated,
  }) {
    return FuelEntry(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      fuelCost: fuelCost ?? this.fuelCost,
      fuelLiters: fuelLiters ?? this.fuelLiters,
      odometer: odometer ?? this.odometer,
      station: station ?? this.station,
      notes: notes ?? this.notes,
      mileage: mileage ?? this.mileage,
      costPerKm: costPerKm ?? this.costPerKm,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

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
      date: DateTime.parse(data.date).toUtc(),
      fuelCost: data.fuelCost,
      fuelLiters: data.fuelLiters,
      odometer: data.odometer,
      station: data.station,
      notes: data.notes,
      mileage: mileage,
      costPerKm: costPerKm,
      lastUpdated: data.lastUpdated?.toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'date': date.toUtc().toIso8601String(),
      'fuelCost': fuelCost,
      'fuelLiters': fuelLiters,
      'odometer': odometer,
      'station': station,
      'notes': notes,
      'lastUpdated': lastUpdated?.toUtc().toIso8601String(),
    };
  }

  factory FuelEntry.fromJson(Map<String, dynamic> json) {
    return FuelEntry(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      date: DateTime.parse(json['date'] as String).toUtc(),
      fuelCost: (json['fuelCost'] as num).toDouble(),
      fuelLiters: (json['fuelLiters'] as num).toDouble(),
      odometer: (json['odometer'] as num).toDouble(),
      station: json['station'] as String?,
      notes: json['notes'] as String?,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String).toUtc()
          : null,
    );
  }
}
