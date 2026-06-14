import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/domain/models/analytics_summary.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/fuel/fuel_history_screen.dart';
import 'package:quantane/features/fuel/fuel_providers.dart';
import 'package:quantane/features/home/home_screen.dart';
import 'package:quantane/features/home/home_providers.dart';
import 'package:quantane/features/trips/live_trip_screen.dart';
import 'package:quantane/features/trips/trip_providers.dart';
import 'package:quantane/data/repositories/active_trip_session_repository.dart';
import 'package:quantane/features/trips/trip_session_models.dart';
import 'package:quantane/features/trips/trips_screen.dart';
import 'package:quantane/features/trips/widgets/trip_history_card.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/features/trips/widgets/speed_gauge.dart';
import 'package:quantane/features/trips/trip_tracking_state.dart';

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
  Future<Trip?> getById(String id) async => insertedTrip?.id == id
      ? insertedTrip
      : null;

  @override
  Future<void> delete(String id) async {
    deletedTripId = id;
  }
}

class _FakeTripTracking extends TripTracking {
  _FakeTripTracking(this.sessionToReturn, {this.onStop});

  final TripState? sessionToReturn;
  final Future<void> Function()? onStop;
  bool stopCalled = false;

  @override
  TripTrackingState build() => TripTrackingState(
        session: sessionToReturn,
        status: sessionToReturn != null ? TripTrackingStatus.live : TripTrackingStatus.idle,
      );

  @override
  Future<void> stop() async {
    stopCalled = true;
    if (onStop != null) {
      await onStop!();
    }
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

  testWidgets('Fuel history uses weighted mileage math per entry and summary', (
    WidgetTester tester,
  ) async {
    final entries = [
      FuelEntry(
        id: 'fuel-2',
        vehicleId: 'vehicle-1',
        date: DateTime(2026, 6, 9),
        fuelCost: 100,
        fuelLiters: 0.8,
        odometer: 80,
        mileage: 100,
        costPerKm: 1.25,
      ),
      FuelEntry(
        id: 'fuel-1',
        vehicleId: 'vehicle-1',
        date: DateTime(2026, 6, 8),
        fuelCost: 200,
        fuelLiters: 2.0,
        odometer: 60,
        mileage: 30,
        costPerKm: 3.33,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeVehicleProvider.overrideWithValue('vehicle-1'),
          fuelHistoryProvider.overrideWith((ref) => Stream.value(entries)),
        ],
        child: const MaterialApp(home: FuelHistoryScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('50.0 KM/L'), findsOneWidget);
    expect(find.text('100.0 KM/L'), findsOneWidget);
    expect(find.text('233.3%'), findsOneWidget);
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

    final tripCard = find.byType(TripHistoryCard);
    await tester.ensureVisible(tripCard);
    await tester.pumpAndSettle();

    await tester.longPress(tripCard);
    await tester.pumpAndSettle();

    expect(find.text('Delete trip?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(repo.deletedTripId, 'trip-1');
  });

  testWidgets('Home screen reflects trip data after a trip ends', (
    WidgetTester tester,
  ) async {
    final trip = Trip(
      id: 'trip-1',
      vehicleId: 'vehicle-1',
      startTime: DateTime(2026, 6, 8, 10, 0, 0),
      endTime: DateTime(2026, 6, 8, 10, 11, 0),
      distance: 11.2,
      avgSpeed: 60,
      maxSpeed: 72,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeVehicleProvider.overrideWithValue('vehicle-1'),
          homeSummaryProvider.overrideWith(
            (ref) => HomeSummary(
              totalSpendMonth: 0,
              totalDistanceMonth: trip.distance,
              avgMileageMonth: 25.0,
            ),
          ),
          quickStatsProvider.overrideWith(
            (ref) => QuickStats(
              avgMileage: 25.0,
              totalDistance: trip.distance,
              avgSpeed: trip.avgSpeed!,
              costPerKm: 40,
            ),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('11 KM'), findsWidgets);
    expect(find.text('60 KM/H'), findsOneWidget);
  });

  testWidgets('live trip stop uses the active session and clears state', (
    WidgetTester tester,
  ) async {
    final repo = _FakeTripRepository();
    final now = DateTime(2026, 6, 8, 7, 0, 0);
    final tracking = _FakeTripTracking(
      TripState(
        sessionId: 'session-1',
        vehicleId: 'vehicle-1',
        currentSpeed: 45,
        maxSpeed: 65,
        distance: 18,
        startTime: now,
        updatedAt: now.add(const Duration(minutes: 20)),
        positions: const [],
      ),
      onStop: () async {
        await repo.insert(
          TripState(
            sessionId: 'session-1',
            vehicleId: 'vehicle-1',
            currentSpeed: 45,
            maxSpeed: 65,
            distance: 18,
            startTime: now,
            updatedAt: now.add(const Duration(minutes: 20)),
            positions: const [],
          ).toTrip(),
        );
      },
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
    expect(repo.insertedTrip!.id, 'session-1');
    expect(repo.insertedTrip!.distance, 18);
    expect(repo.insertedTrip!.maxSpeed, 65);
    expect(repo.insertedTrip!.avgSpeed, isNotNull);
    expect(repo.insertedTrip!.avgSpeed!, greaterThanOrEqualTo(0));
    expect(tracking.stopCalled, isTrue);
  });

  testWidgets('active session restores on provider bootstrap', (
    WidgetTester tester,
  ) async {
    final tracking = _FakeTripTracking(
      TripState(
        sessionId: 'session-2',
        vehicleId: 'vehicle-1',
        currentSpeed: 0,
        maxSpeed: 0,
        distance: 0,
        startTime: DateTime(2026, 6, 8, 7, 0, 0),
        updatedAt: DateTime(2026, 6, 8, 7, 1, 0),
        positions: const [],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeVehicleProvider.overrideWithValue('vehicle-1'),
          tripTrackingProvider.overrideWith(() => tracking),
        ],
        child: const MaterialApp(home: LiveTripScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Starting trip...'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('speed gauge switches modes and shows warning at high speed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SpeedGauge(speed: 102, mode: SpeedDisplayMode.digital),
                const SizedBox(height: 24),
                SpeedGauge(speed: 102, mode: SpeedDisplayMode.analog),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('102'), findsWidgets);
    expect(find.textContaining('Exceeding speed limit'), findsWidgets);
    expect(
      tester.widgetList(find.byType(CustomPaint)).length,
      greaterThanOrEqualTo(2),
    );
  });

  testWidgets('live trip mode switch toggles digital and analog speed views', (
    WidgetTester tester,
  ) async {
    final tracking = _FakeTripTracking(
      TripState(
        sessionId: 'session-5',
        vehicleId: 'vehicle-1',
        currentSpeed: 42,
        maxSpeed: 65,
        distance: 18,
        startTime: DateTime(2026, 6, 8, 7, 0, 0),
        updatedAt: DateTime(2026, 6, 8, 7, 11, 0),
        positions: const [],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeVehicleProvider.overrideWithValue('vehicle-1'),
          tripTrackingProvider.overrideWith(() => tracking),
        ],
        child: const MaterialApp(home: Scaffold(body: LiveTripScreen())),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Digital'), findsOneWidget);
    expect(find.text('Analog'), findsOneWidget);
    expect(find.byKey(const ValueKey('digital-speed-gauge')), findsOneWidget);

    await tester.tap(find.text('Analog'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analog-speed-gauge')), findsOneWidget);
  });

  test('TripState serialization round-trips active session data', () async {
    final state = TripState(
      sessionId: 'session-3',
      vehicleId: 'vehicle-1',
      startTime: DateTime(2026, 6, 8, 7, 0, 0),
      updatedAt: DateTime(2026, 6, 8, 7, 12, 0),
      currentSpeed: 45,
      maxSpeed: 65,
      distance: 18,
      positions: const [],
    );

    final roundTrip = TripState.fromJson(state.toJson());

    expect(roundTrip.sessionId, state.sessionId);
    expect(roundTrip.vehicleId, state.vehicleId);
    expect(roundTrip.distance, state.distance);
    expect(roundTrip.maxSpeed, state.maxSpeed);
  });

  test('Active session repository persists and clears state', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'quantane-trip-session-',
    );
    final repository = ActiveTripSessionRepository(
      directoryResolver: () async => tempDir,
    );
    final state = TripState(
      sessionId: 'session-4',
      vehicleId: 'vehicle-1',
      startTime: DateTime.utc(2026, 6, 8, 7),
      updatedAt: DateTime.utc(2026, 6, 8, 7, 15),
      currentSpeed: 55,
      maxSpeed: 70,
      distance: 10.2,
      positions: const [],
    );

    await repository.save(state);

    final loaded = await repository.load();
    expect(loaded, isNotNull);
    expect(loaded!.sessionId, state.sessionId);
    expect(loaded.distance, state.distance);

    await repository.clear();
    expect(await repository.load(), isNull);
    await tempDir.delete(recursive: true);
  });
}
