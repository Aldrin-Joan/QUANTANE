// Project imports:
import 'package:quantane/features/trips/trip_session_models.dart';

class Trip {

  Trip({
    required this.id,
    required this.vehicleId,
    required this.startTime,
    this.endTime,
    required this.distance,
    this.avgSpeed,
    this.maxSpeed,
    this.minSpeed,
    this.startAddress,
    this.endAddress,
    this.minLatitude = 0,
    this.maxLatitude = 0,
    this.minLongitude = 0,
    this.maxLongitude = 0,
    this.routeSnapshotPath,
    this.routePoints = const [],
    this.lastUpdated,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      startTime: DateTime.parse(json['startTime'] as String).toUtc(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String).toUtc()
          : null,
      distance: (json['distance'] as num).toDouble(),
      avgSpeed: (json['avgSpeed'] as num?)?.toDouble(),
      maxSpeed: (json['maxSpeed'] as num?)?.toDouble(),
      minSpeed: (json['minSpeed'] as num?)?.toDouble(),
      startAddress: json['startAddress'] as String?,
      endAddress: json['endAddress'] as String?,
      minLatitude: (json['minLatitude'] as num).toDouble(),
      maxLatitude: (json['maxLatitude'] as num).toDouble(),
      minLongitude: (json['minLongitude'] as num).toDouble(),
      maxLongitude: (json['maxLongitude'] as num).toDouble(),
      routeSnapshotPath: json['routeSnapshotPath'] as String?,
      routePoints:
          (json['routePoints'] as List<dynamic>?)
              ?.cast<Map<String, Object?>>()
              .map(TripPoint.fromJson)
              .toList() ??
          const [],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String).toUtc()
          : null,
    );
  }
  final String id;
  final String vehicleId;
  final DateTime startTime;
  final DateTime? endTime;
  final double distance;
  final double? avgSpeed;
  final double? maxSpeed;
  final double? minSpeed;
  final String? startAddress;
  final String? endAddress;
  final double minLatitude;
  final double maxLatitude;
  final double minLongitude;
  final double maxLongitude;
  final String? routeSnapshotPath;
  final List<TripPoint> routePoints;
  final DateTime? lastUpdated;

  Trip copyWith({
    String? id,
    String? vehicleId,
    DateTime? startTime,
    DateTime? endTime,
    double? distance,
    double? avgSpeed,
    double? maxSpeed,
    double? minSpeed,
    String? startAddress,
    String? endAddress,
    double? minLatitude,
    double? maxLatitude,
    double? minLongitude,
    double? maxLongitude,
    String? routeSnapshotPath,
    List<TripPoint>? routePoints,
    DateTime? lastUpdated,
  }) {
    return Trip(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      minSpeed: minSpeed ?? this.minSpeed,
      startAddress: startAddress ?? this.startAddress,
      endAddress: endAddress ?? this.endAddress,
      minLatitude: minLatitude ?? this.minLatitude,
      maxLatitude: maxLatitude ?? this.maxLatitude,
      minLongitude: minLongitude ?? this.minLongitude,
      maxLongitude: maxLongitude ?? this.maxLongitude,
      routeSnapshotPath: routeSnapshotPath ?? this.routeSnapshotPath,
      routePoints: routePoints ?? this.routePoints,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get hasRoute => routePoints.length >= 2;

  bool get hasBoundingBox =>
      minLatitude != maxLatitude || minLongitude != maxLongitude;


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime?.toUtc().toIso8601String(),
      'distance': distance,
      'avgSpeed': avgSpeed,
      'maxSpeed': maxSpeed,
      'minSpeed': minSpeed,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'minLatitude': minLatitude,
      'maxLatitude': maxLatitude,
      'minLongitude': minLongitude,
      'maxLongitude': maxLongitude,
      'routeSnapshotPath': routeSnapshotPath,
      'routePoints': routePoints.map((point) => point.toJson()).toList(),
      'lastUpdated': lastUpdated?.toUtc().toIso8601String(),
    };
  }
}
