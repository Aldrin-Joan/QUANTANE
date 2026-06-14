import 'package:geolocator/geolocator.dart';
import 'package:quantane/domain/models/trip.dart';

class TripPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double speedKmh;
  final double accuracyMeters;
  final double? heading;

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

  Map<String, Object?> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
    'speedKmh': speedKmh,
    'accuracyMeters': accuracyMeters,
    'heading': heading,
  };

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
}

class TripState {
  final String sessionId;
  final String vehicleId;
  final DateTime startTime;
  final DateTime updatedAt;
  final double currentSpeed;
  final double maxSpeed;
  final double distance;
  final DateTime? endTime;
  final List<TripPoint> positions;

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
}

class TripMetricsCalculator {
  static const double minUsefulStepMeters = 3.0;
  static const double maxReasonableStepMeters = 5000.0;

  TripState update(TripState current, Position position) {
    final previousPoint = current.positions.isEmpty
        ? null
        : current.positions.last;
    final derivedSpeed = _deriveSpeedKmh(
      position: position,
      previous: previousPoint,
    );
    final currentSpeed = _estimateCurrentSpeed(
      position: position,
      derivedSpeed: derivedSpeed,
    );
    final updatedPositions = List<TripPoint>.of(current.positions)
      ..add(TripPoint.fromPosition(position, currentSpeed));

    var distanceKm = current.distance;
    if (previousPoint != null) {
      final stepMeters = Geolocator.distanceBetween(
        previousPoint.latitude,
        previousPoint.longitude,
        position.latitude,
        position.longitude,
      );

      if (stepMeters >= minUsefulStepMeters &&
          stepMeters <= maxReasonableStepMeters) {
        distanceKm += stepMeters / 1000.0;
      }
    }

    return current.copyWith(
      currentSpeed: currentSpeed,
      maxSpeed: currentSpeed > current.maxSpeed
          ? currentSpeed
          : current.maxSpeed,
      distance: distanceKm,
      updatedAt: position.timestamp,
      positions: List<TripPoint>.unmodifiable(updatedPositions),
    );
  }

  double _estimateCurrentSpeed({
    required Position position,
    required double derivedSpeed,
  }) {
    final reportedSpeed = position.speed.isFinite ? position.speed * 3.6 : 0.0;
    if (reportedSpeed <= 0) {
      return derivedSpeed;
    }

    if (derivedSpeed <= 0) {
      return reportedSpeed;
    }

    return reportedSpeed > derivedSpeed ? reportedSpeed : derivedSpeed;
  }

  double _deriveSpeedKmh({required Position position, TripPoint? previous}) {
    if (previous == null) {
      return 0.0;
    }

    final elapsedSeconds =
        position.timestamp.difference(previous.timestamp).inMilliseconds /
        1000.0;
    if (elapsedSeconds <= 0) {
      return 0.0;
    }

    final distanceMeters = Geolocator.distanceBetween(
      previous.latitude,
      previous.longitude,
      position.latitude,
      position.longitude,
    );

    if (distanceMeters < minUsefulStepMeters) {
      return 0.0;
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
    return 0.0;
  }

  return distanceKm / hours;
}
