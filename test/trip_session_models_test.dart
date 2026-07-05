// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

// Project imports:
import 'package:quantane/features/trips/trip_session_models.dart';

Position _position({
  required double latitude,
  required double longitude,
  required DateTime timestamp,
  required double accuracy,
  required double speed,
  required double speedAccuracy,
  bool isMocked = false,
}) {
  return Position(
    longitude: longitude,
    latitude: latitude,
    timestamp: timestamp,
    accuracy: accuracy,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: speed,
    speedAccuracy: speedAccuracy,
    isMocked: isMocked,
  );
}

TripState _initialState() {
  final now = DateTime(2026, 6, 14, 11, 0);
  return TripState(
    sessionId: 'session-1',
    vehicleId: 'vehicle-1',
    startTime: now,
    updatedAt: now,
    currentSpeed: 0,
    maxSpeed: 0,
    distance: 0,
    positions: const [],
  );
}

void main() {
  test('stationary noisy GPS speed is suppressed at trip start', () {
    final calculator = TripMetricsCalculator();
    final state = _initialState();
    final position = _position(
      latitude: 11.01219,
      longitude: 76.98770,
      timestamp: DateTime(2026, 6, 14, 11, 0, 1),
      accuracy: 5,
      speed: 2.5,
      speedAccuracy: 4,
    );

    final updated = calculator.update(state, position);

    expect(updated.currentSpeed, 0);
    expect(updated.maxSpeed, 0);
    expect(updated.positions, hasLength(1));
  });

  test('moving positions still produce a filtered speed', () {
    final calculator = TripMetricsCalculator();
    final now = DateTime(2026, 6, 14, 11, 0);
    final state = TripState(
      sessionId: 'session-1',
      vehicleId: 'vehicle-1',
      startTime: now,
      updatedAt: now,
      currentSpeed: 0,
      maxSpeed: 0,
      distance: 0,
      positions: [
        TripPoint(
          latitude: 11,
          longitude: 76.98000,
          timestamp: now,
          speedKmh: 0,
          accuracyMeters: 5,
          heading: null,
        ),
      ],
    );

    final position = _position(
      latitude: 11.00045,
      longitude: 76.98045,
      timestamp: now.add(const Duration(seconds: 5)),
      accuracy: 5,
      speed: 9.1 / 3.6,
      speedAccuracy: 1,
    );

    final updated = calculator.update(state, position);

    expect(updated.currentSpeed, greaterThan(0));
    expect(updated.maxSpeed, greaterThan(0));
    expect(updated.positions, hasLength(2));
  });
}
