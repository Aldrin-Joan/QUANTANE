import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/fuel/fuel_providers.dart';
import 'package:quantane/features/home/home_screen.dart';
import 'package:quantane/features/trips/live_trip_screen.dart';
import 'package:quantane/features/trips/trip_providers.dart';
import 'package:quantane/features/trips/trips_screen.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/features/trips/trip_tracking_service.dart';

class _FakeTripRepository implements TripRepository {
  Trip? insertedTrip;
  String? deletedTripId;

  @override
  Future<void> insert(Trip trip) async {
    insertedTrip = trip;
  }

  @override
  Stream<List<Trip>> watchAll(String vehicleId) {
    return Stream.value(const <Trip>[]);
  }

  @override
  Future<void> delete(String id) async {
    deletedTripId = id;
  }
}

class _FakeTripTracking extends TripTracking {
  _FakeTripTracking(this.stateToReturn);

  final TripState stateToReturn;
  bool stopCalled = false;

  @override
  TripState? build() => stateToReturn;

  @override
  void stop() {
    stopCalled = true;
    super.stop();
  }
}

void main() {
  testWidgets('home metric carousel swipes between mileage and speed', (
    WidgetTester tester,
  ) async {
    final now = DateTime(2026, 6, 8);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fuelHistoryProvider.overrideWith((ref) {
            return Stream.value([
              FuelEntry(
                id: 'fuel-1',
                vehicleId: 'vehicle-1',
                date: now,
                fuelCost: 1000,
                fuelLiters: 40,
                odometer: 1200,
                mileage: 25,
                costPerKm: 40,
              ),
            ]);
          }),
          tripHistoryProvider.overrideWith((ref) {
            return Stream.value([
              Trip(
                id: 'trip-1',
                vehicleId: 'vehicle-1',
                startTime: now,
                distance: 42,
                avgSpeed: 42,
                maxSpeed: 80,
              ),
            ]);
          }),
        ],
        child: const MaterialApp(home: Scaffold(body: HomeScreen())),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Mileage'), findsOneWidget);
    expect(find.text('25.0 KM/L'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('Speed'), findsOneWidget);
    expect(find.text('42.0 KM/H'), findsOneWidget);
  });

  testWidgets('Trips screen shows an empty state when no trips exist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeVehicleProvider.overrideWithValue('vehicle-1'),
          tripHistoryProvider.overrideWith(
            (ref) => Stream.value(const <Trip>[]),
          ),
        ],
        child: const MaterialApp(home: TripsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No trips yet'), findsOneWidget);
    expect(
      find.textContaining('Start a trip from this screen'),
      findsOneWidget,
    );
  });

  testWidgets('Trips screen long press deletes a trip after confirmation', (
    WidgetTester tester,
  ) async {
    final repo = _FakeTripRepository();
    final trip = Trip(
      id: 'trip-1',
      vehicleId: 'vehicle-1',
      startTime: DateTime(2026, 6, 8),
      endTime: DateTime(2026, 6, 8, 1),
      distance: 12.5,
      avgSpeed: 25,
      maxSpeed: 40,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeVehicleProvider.overrideWithValue('vehicle-1'),
          tripRepositoryProvider.overrideWithValue(repo),
          tripHistoryProvider.overrideWith((ref) => Stream.value([trip])),
        ],
        child: const MaterialApp(home: TripsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.longPress(find.text('12.5 KM'));
    await tester.pumpAndSettle();

    expect(find.text('Delete trip?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(repo.deletedTripId, 'trip-1');
  });

  testWidgets('live trip stop saves a trip with safe average speed math', (
    WidgetTester tester,
  ) async {
    final repo = _FakeTripRepository();
    final now = DateTime(2026, 6, 8, 7, 0, 0);
    final tracking = _FakeTripTracking(
      TripState(
        currentSpeed: 45,
        maxSpeed: 65,
        distance: 18,
        startTime: now,
        positions: const [],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeVehicleProvider.overrideWithValue('vehicle-1'),
          tripTrackingProvider.overrideWith(() => tracking),
          tripRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(home: LiveTripScreen()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Stop Trip'));
    await tester.pumpAndSettle();

    expect(repo.insertedTrip, isNotNull);
    expect(repo.insertedTrip!.distance, 18);
    expect(repo.insertedTrip!.maxSpeed, 65);
    expect(repo.insertedTrip!.avgSpeed, isNotNull);
    expect(repo.insertedTrip!.avgSpeed!, greaterThanOrEqualTo(0));
    expect(tracking.stopCalled, isTrue);
  });

  test(
    'TripTrackingService computes speed and distance from a fake GPS stream',
    () async {
      final controller = StreamController<Position>();
      final service = TripTrackingService(
        positionStreamFactory: ({LocationSettings? locationSettings}) =>
            controller.stream,
      );

      final updates = <TripState>[];
      final subscription = service.startTracking().listen(updates.add);

      controller.add(
        Position(
          latitude: 37.4219983,
          longitude: -122.084,
          timestamp: DateTime(2026, 6, 8, 7, 0, 0),
          accuracy: 5,
          altitude: 0,
          altitudeAccuracy: 1,
          heading: 0,
          headingAccuracy: 1,
          speed: 10,
          speedAccuracy: 1,
          isMocked: true,
        ),
      );
      controller.add(
        Position(
          latitude: 37.4225,
          longitude: -122.0835,
          timestamp: DateTime(2026, 6, 8, 7, 0, 10),
          accuracy: 5,
          altitude: 0,
          altitudeAccuracy: 1,
          heading: 0,
          headingAccuracy: 1,
          speed: 15,
          speedAccuracy: 1,
          isMocked: true,
        ),
      );

      await Future<void>.delayed(Duration.zero);
      await controller.close();
      await subscription.cancel();

      expect(updates, isNotEmpty);
      expect(updates.last.currentSpeed, closeTo(15 * 3.6, 0.01));
      expect(updates.last.maxSpeed, closeTo(15 * 3.6, 0.01));
      expect(updates.last.distance, greaterThan(0));
    },
  );
}
