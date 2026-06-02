import 'package:quantane/data/database/app_database.dart';

class Trip {
  final String id;
  final String vehicleId;
  final DateTime startTime;
  final DateTime? endTime;
  final double distance;
  final double? avgSpeed;
  final double? maxSpeed;
  final double? minSpeed;

  Trip({
    required this.id,
    required this.vehicleId,
    required this.startTime,
    this.endTime,
    required this.distance,
    this.avgSpeed,
    this.maxSpeed,
    this.minSpeed,
  });

  factory Trip.fromDrift(TripData data) {
    return Trip(
      id: data.id,
      vehicleId: data.vehicleId,
      startTime: DateTime.parse(data.startTime),
      endTime: data.endTime != null ? DateTime.parse(data.endTime!) : null,
      distance: data.distance,
      avgSpeed: data.avgSpeed,
      maxSpeed: data.maxSpeed,
      minSpeed: data.minSpeed,
    );
  }
}
