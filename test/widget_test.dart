import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/fuel/fuel_providers.dart';
import 'package:quantane/features/home/home_screen.dart';
import 'package:quantane/features/trips/trip_providers.dart';

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
}
