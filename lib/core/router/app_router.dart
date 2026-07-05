import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quantane/features/auth/auth_screen.dart';
import 'package:quantane/features/fuel/fuel_history_screen.dart';
import 'package:quantane/features/home/home_screen.dart';
import 'package:quantane/features/settings/settings_screen.dart';
import 'package:quantane/features/shared/widgets/quantane_bottom_nav.dart';
import 'package:quantane/features/trips/live_trip_screen.dart';
import 'package:quantane/features/trips/trip_detail_screen.dart';
import 'package:quantane/features/trips/trips_screen.dart';
import 'package:quantane/features/vehicles/vehicles_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorTripsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellTrips',
);
final _shellNavigatorFuelKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellFuel',
);
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSettings',
);

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return QuantaneBottomNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFuelKey,
            routes: [
              GoRoute(
                path: '/fuel',
                builder: (context, state) => const FuelHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTripsKey,
            routes: [
              GoRoute(
                path: '/trips',
                builder: (context, state) => const TripsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/vehicles',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VehiclesScreen(),
      ),
      GoRoute(
        path: '/live-trip',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LiveTripScreen(),
      ),
      GoRoute(
        path: '/trips/:tripId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final tripId = state.pathParameters['tripId']!;
          return TripDetailScreen(tripId: tripId);
        },
      ),
      GoRoute(
        path: '/auth',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final isUpgrade = state.uri.queryParameters['upgrade'] == 'true';
          return AuthScreen(isUpgrade: isUpgrade);
        },
      ),
    ],
  );
}
