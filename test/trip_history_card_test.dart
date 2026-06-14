import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/trips/widgets/trip_history_card.dart';

void main() {
  testWidgets('trip history card shows route label and metrics', (
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
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TripHistoryCard(
              trip: trip,
              onDelete: () async {},
            ),
          ),
        ),
        GoRoute(
          path: '/trips/:tripId',
          builder: (context, state) =>
              const Scaffold(body: Text('Trip detail opened')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Anna Nagar, Chennai → T Nagar, Chennai'), findsOneWidget);
    expect(find.text('15.2 km · 23 mins'), findsOneWidget);
    expect(find.text('14 Jun 2026'), findsOneWidget);

    await tester.tap(find.byType(TripHistoryCard));
    await tester.pumpAndSettle();

    expect(find.text('Trip detail opened'), findsOneWidget);
  });
}
