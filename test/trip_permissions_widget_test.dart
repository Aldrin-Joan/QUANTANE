import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/features/trips/trip_permissions.dart';
import 'package:quantane/features/trips/trip_providers.dart';
import 'package:quantane/features/trips/trips_screen.dart';

void main() {
  testWidgets('Trips screen shows blocked state when location is denied', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeVehicleProvider.overrideWithValue('vehicle-1'),
          tripPermissionsControllerProvider.overrideWith((ref) {
            final controller = TripPermissionsController();
            controller.state = const TripPermissionState(
              location: TripLocationPermission(TripPermissionStatus.denied),
              notification: TripNotificationPermission(
                TripPermissionStatus.granted,
              ),
              isRefreshing: false,
            );
            return controller;
          }),
          tripHistoryProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const MaterialApp(home: TripsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Location required'), findsOneWidget);
    expect(
      find.textContaining('Location permission is required'),
      findsOneWidget,
    );
    expect(find.text('Allow location'), findsOneWidget);
  });
}
