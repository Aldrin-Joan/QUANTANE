import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/fuel/fuel_providers.dart';
import 'package:quantane/features/home/home_screen.dart';
import 'package:quantane/features/trips/live_trip_screen.dart';
import 'package:quantane/features/trips/trip_providers.dart';
import 'package:quantane/features/trips/trips_screen.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/features/trips/trip_tracking_service.dart';

class _FakeTripRepository extends TripRepository {
  _FakeTripRepository() : super(AppDatabase());

  Trip? insertedTrip;

  @override
  Future<void> insert(Trip trip) async {
    insertedTrip = trip;
  }

  @override
  Stream<List<Trip>> watchAll(String vehicleId) {
    return Stream.value(const <Trip>[]);
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
}
