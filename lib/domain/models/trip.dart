import 'dart:convert';

import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/features/trips/trip_session_models.dart';

class Trip {
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
  });

  bool get hasRoute => routePoints.length >= 2;

  bool get hasBoundingBox =>
      minLatitude != maxLatitude || minLongitude != maxLongitude;

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
      startAddress: data.startAddress,
      endAddress: data.endAddress,
      minLatitude: data.minLatitude,
      maxLatitude: data.maxLatitude,
      minLongitude: data.minLongitude,
      maxLongitude: data.maxLongitude,
      routeSnapshotPath: data.routeSnapshotPath,
      routePoints: _decodeRoutePoints(data.routePointsJson),
    );
  }

  static List<TripPoint> _decodeRoutePoints(String? json) {
    if (json == null || json.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .cast<Map<String, Object?>>()
        .map(TripPoint.fromJson)
        .toList(growable: false);
  }

  static String? encodeRoutePoints(List<TripPoint> points) {
    if (points.isEmpty) {
      return null;
    }

    return jsonEncode(points.map((point) => point.toJson()).toList());
  }
}
