// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/trips/trip_detail_screen.dart';
import 'package:quantane/features/trips/trip_session_models.dart';

class _FakeTripRepository implements TripRepository {
  _FakeTripRepository(this.trip);
  final Trip? trip;

  @override
  Future<Trip?> getById(String id) async => trip?.id == id ? trip : null;

  @override
  Future<void> insert(Trip trip, {bool syncToFirebase = true}) async {}

  @override
  Stream<List<Trip>> watchAll(String vehicleId) => Stream.value(const []);

  @override
  Future<void> delete(String id, {bool syncToFirebase = true}) async {}
}

TripPoint _point(double lat, double lng) {
  return TripPoint(
    latitude: lat,
    longitude: lng,
    timestamp: DateTime(2026, 6, 14, 8),
    speedKmh: 30,
    accuracyMeters: 8,
    heading: null,
  );
}

void main() {
  testWidgets('trip detail shows persisted stats without recalculation', (
    tester,
  ) async {
    final trip = Trip(
      id: 'trip-1',
      vehicleId: 'vehicle-1',
      startTime: DateTime(2026, 6, 14, 8),
      endTime: DateTime(2026, 6, 14, 8, 23),
      distance: 15.2,
      avgSpeed: 38,
      maxSpeed: 62,
      startAddress: 'Anna Nagar, Chennai',
      endAddress: 'T Nagar, Chennai',
      minLatitude: 13.08,
      maxLatitude: 13.1,
      minLongitude: 80.27,
      maxLongitude: 80.29,
      routePoints: [
        _point(13.08, 80.27),
        _point(13.09, 80.28),
        _point(13.1, 80.29),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripRepositoryProvider.overrideWithValue(_FakeTripRepository(trip)),
        ],
        child: const MaterialApp(home: TripDetailScreen(tripId: 'trip-1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('15.2 km'), findsOneWidget);
    expect(find.text('38 km/h'), findsOneWidget);
    expect(find.text('62 km/h'), findsOneWidget);
    expect(find.text('Anna Nagar, Chennai'), findsOneWidget);
    expect(find.text('T Nagar, Chennai'), findsOneWidget);
  });

  testWidgets('legacy trip without route shows unavailable state', (
    tester,
  ) async {
    final trip = Trip(
      id: 'legacy-trip',
      vehicleId: 'vehicle-1',
      startTime: DateTime(2026, 6, 14, 8),
      endTime: DateTime(2026, 6, 14, 8, 23),
      distance: 8.4,
      avgSpeed: 30,
      maxSpeed: 45,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripRepositoryProvider.overrideWithValue(_FakeTripRepository(trip)),
        ],
        child: const MaterialApp(home: TripDetailScreen(tripId: 'legacy-trip')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Route unavailable for this trip'), findsOneWidget);
    expect(find.text('8.4 km'), findsOneWidget);
  });
}
