enum VehicleType { bike, car, truck }

enum FuelType { petrol, diesel, ev, cng }

class Vehicle {
  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.fuelType,
    this.tankCapacity,
    required this.initialOdometer,
    required this.createdAt,
    this.lastUpdated,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      name: json['name'] as String,
      type: VehicleType.values.firstWhere((e) => e.name == json['type']),
      fuelType: FuelType.values.firstWhere((e) => e.name == json['fuelType']),
      tankCapacity: (json['tankCapacity'] as num?)?.toDouble(),
      initialOdometer: (json['initialOdometer'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String).toUtc()
          : null,
    );
  }
  final String id;
  final String name;
  final VehicleType type;
  final FuelType fuelType;
  final double? tankCapacity;
  final double initialOdometer;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  Vehicle copyWith({
    String? id,
    String? name,
    VehicleType? type,
    FuelType? fuelType,
    double? tankCapacity,
    double? initialOdometer,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      fuelType: fuelType ?? this.fuelType,
      tankCapacity: tankCapacity ?? this.tankCapacity,
      initialOdometer: initialOdometer ?? this.initialOdometer,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'fuelType': fuelType.name,
      'tankCapacity': tankCapacity,
      'initialOdometer': initialOdometer,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'lastUpdated': lastUpdated?.toUtc().toIso8601String(),
    };
  }
}
