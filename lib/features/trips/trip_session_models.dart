// Dart imports:
import 'dart:math';

// Package imports:
import 'package:geolocator/geolocator.dart';

// Project imports:
import 'package:quantane/domain/models/trip.dart';

class TripPoint {

  const TripPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.speedKmh,
    required this.accuracyMeters,
    required this.heading,
  });

  factory TripPoint.fromPosition(Position position, double speedKmh) {
    return TripPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
      speedKmh: speedKmh,
      accuracyMeters: position.accuracy,
      heading: position.heading.isFinite ? position.heading : null,
    );
  }

  factory TripPoint.fromJson(Map<String, Object?> json) {
    return TripPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      speedKmh: (json['speedKmh'] as num).toDouble(),
      accuracyMeters: (json['accuracyMeters'] as num).toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
    );
  }
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double speedKmh;
  final double accuracyMeters;
  final double? heading;

  Map<String, Object?> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
    'speedKmh': speedKmh,
    'accuracyMeters': accuracyMeters,
    'heading': heading,
  };
}

class TripState {

  const TripState({
    required this.sessionId,
    required this.vehicleId,
    required this.startTime,
    required this.updatedAt,
    required this.currentSpeed,
    required this.maxSpeed,
    required this.distance,
    required this.positions,
    this.endTime,
  });

  factory TripState.fromJson(Map<String, Object?> json) {
    return TripState(
      sessionId: json['sessionId'] as String,
      vehicleId: json['vehicleId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      currentSpeed: (json['currentSpeed'] as num).toDouble(),
      maxSpeed: (json['maxSpeed'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      positions: (json['positions'] as List<dynamic>)
          .cast<Map<String, Object?>>()
          .map(TripPoint.fromJson)
          .toList(growable: false),
    );
  }
  final String sessionId;
  final String vehicleId;
  final DateTime startTime;
  final DateTime updatedAt;
  final double currentSpeed;
  final double maxSpeed;
  final double distance;
  final DateTime? endTime;
  final List<TripPoint> positions;

  bool get isActive => endTime == null;

  TripState copyWith({
    String? sessionId,
    String? vehicleId,
    DateTime? startTime,
    DateTime? updatedAt,
    double? currentSpeed,
    double? maxSpeed,
    double? distance,
    DateTime? endTime,
    List<TripPoint>? positions,
  }) {
    return TripState(
      sessionId: sessionId ?? this.sessionId,
      vehicleId: vehicleId ?? this.vehicleId,
      startTime: startTime ?? this.startTime,
      updatedAt: updatedAt ?? this.updatedAt,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      distance: distance ?? this.distance,
      endTime: endTime ?? this.endTime,
      positions: positions ?? this.positions,
    );
  }

  Trip toTrip() {
    final stoppedAt = endTime ?? updatedAt;
    return Trip(
      id: sessionId,
      vehicleId: vehicleId,
      startTime: startTime,
      endTime: stoppedAt,
      distance: distance,
      avgSpeed: _averageSpeedKmh(
        distanceKm: distance,
        duration: stoppedAt.difference(startTime),
      ),
      maxSpeed: maxSpeed,
    );
  }

  Map<String, Object?> toJson() => {
    'sessionId': sessionId,
    'vehicleId': vehicleId,
    'startTime': startTime.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'currentSpeed': currentSpeed,
    'maxSpeed': maxSpeed,
    'distance': distance,
    'endTime': endTime?.toIso8601String(),
    'positions': positions.map((point) => point.toJson()).toList(),
  };
}

class TripMetricsCalculator {
  /// GPS horizontal accuracy must be better than this (lower is better).
  static const double maxAccuracyMeters = 30;

  /// Minimum distance between points to consider it a "move".
  static const double minUsefulStepMeters = 3;

  /// Minimum derived speed needed before we trust a motion reading.
  static const double minReliableSpeedKmh = 3;

  /// Maximum speed for a road vehicle (km/h). Anything above is likely noise.
  static const double maxRealisticSpeedKmh = 250;

  TripState update(TripState current, Position position) {
    // 1. Accuracy Filter: Discard noisy GPS points immediately.
    if (position.accuracy > maxAccuracyMeters) {
      return current;
    }

    final previousPoint = current.positions.isEmpty
        ? null
        : current.positions.last;

    // 2. Temporal Filter: Prevent division by zero or negative time.
    if (previousPoint != null &&
        position.timestamp.isBefore(previousPoint.timestamp)) {
      return current;
    }

    final derivedSpeed = _deriveSpeedKmh(
      position: position,
      previous: previousPoint,
    );

    // 3. Realistic Speed Filter: If derived speed is physically impossible, ignore point.
    if (derivedSpeed > maxRealisticSpeedKmh) {
      return current;
    }

    final currentSpeed = _estimateCurrentSpeed(
      position: position,
      derivedSpeed: derivedSpeed,
      previousPoint: previousPoint,
    );

    // Final sanity check on total speed used for display/max tracking.
    final verifiedSpeed = currentSpeed > maxRealisticSpeedKmh
        ? 0.0
        : currentSpeed;

    final updatedPositions = List<TripPoint>.of(current.positions)
      ..add(TripPoint.fromPosition(position, verifiedSpeed));

    var distanceKm = current.distance;
    if (previousPoint != null) {
      final stepMeters = Geolocator.distanceBetween(
        previousPoint.latitude,
        previousPoint.longitude,
        position.latitude,
        position.longitude,
      );

      // Only add distance if it's significant but realistic.
      if (stepMeters >= minUsefulStepMeters && (stepMeters / 1000.0) < 5.0) {
        // Max 5km jump per poll (approx poll is 1s)
        distanceKm += stepMeters / 1000.0;
      }
    }

    return current.copyWith(
      currentSpeed: verifiedSpeed,
      maxSpeed: verifiedSpeed > current.maxSpeed
          ? verifiedSpeed
          : current.maxSpeed,
      distance: distanceKm,
      updatedAt: position.timestamp,
      positions: List<TripPoint>.unmodifiable(updatedPositions),
    );
  }

  double _estimateCurrentSpeed({
    required Position position,
    required double derivedSpeed,
    required TripPoint? previousPoint,
  }) {
    if (position.isMocked) {
      return 0;
    }

    final reportedSpeed = position.speed.isFinite && position.speed > 0
        ? position.speed * 3.6
        : 0.0;

    // Require actual position movement before accepting a speed reading.
    // GPS speed alone is noisy at trip start and while the device is idle.
    if (previousPoint == null || derivedSpeed < minReliableSpeedKmh) {
      return 0;
    }

    final speedAccuracy =
        position.speedAccuracy.isFinite && position.speedAccuracy > 0
        ? position.speedAccuracy * 3.6
        : 0.0;

    // When the reported speed is less reliable than the coordinate-derived
    // movement, prefer the derived value.
    if (reportedSpeed > 0 &&
        speedAccuracy > 0 &&
        reportedSpeed < speedAccuracy) {
      return derivedSpeed;
    }

    if (reportedSpeed > 0) {
      return max(reportedSpeed, derivedSpeed);
    }

    return derivedSpeed;
  }

  double _deriveSpeedKmh({required Position position, TripPoint? previous}) {
    if (previous == null) {
      return 0;
    }

    final elapsedSeconds =
        position.timestamp.difference(previous.timestamp).inMilliseconds /
        1000.0;
    if (elapsedSeconds <= 0) {
      return 0;
    }

    final distanceMeters = Geolocator.distanceBetween(
      previous.latitude,
      previous.longitude,
      position.latitude,
      position.longitude,
    );

    if (distanceMeters < minUsefulStepMeters) {
      return 0;
    }

    return (distanceMeters / elapsedSeconds) * 3.6;
  }
}

double _averageSpeedKmh({
  required double distanceKm,
  required Duration duration,
}) {
  final hours = duration.inSeconds / 3600.0;
  if (hours <= 0) {
    return 0;
  }

  return distanceKm / hours;
}
