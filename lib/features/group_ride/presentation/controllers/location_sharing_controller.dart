// Dart imports:
import 'dart:async';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:quantane/features/group_ride/data/datasources/supabase_provider.dart';
import 'package:quantane/features/group_ride/domain/entities/rider_telemetry.dart';
import 'package:quantane/features/shared/providers/auth_service.dart';

part 'location_sharing_controller.g.dart';

@Riverpod(keepAlive: true)
class LocationSharingController extends _$LocationSharingController {
  StreamSubscription<Position>? _positionSub;
  String? _activeGroupId;

  @override
  void build() {
    ref.onDispose(() {
      _positionSub?.cancel();
    });
  }

  void startSharing(String groupId) {
    _activeGroupId = groupId;
    _positionSub?.cancel();

    // 1. Join Supabase Broadcast channel
    final authState = ref.read(authServiceProvider);
    final userId = authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final repo = ref.read(locationSharingRepositoryProvider);
    repo.startSharing(groupId, userId, {
      'status': 'online',
    });

    // 2. Start listening to Geolocator stream
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Send every 5 meters
    );

    _positionSub = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen(_broadcast);
  }

  void stopSharing() {
    _activeGroupId = null;
    _positionSub?.cancel();
    _positionSub = null;
    ref.read(locationSharingRepositoryProvider).stopSharing();
  }

  void _broadcast(Position pos) {
    final groupId = _activeGroupId;
    final authState = ref.read(authServiceProvider);
    final userId = authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (groupId == null || userId == null) return;

    final speedKmh = pos.speed * 3.6;
    final status = speedKmh > 2 ? 'moving' : 'stationary';

    final telemetry = RiderTelemetry(
      riderId: userId,
      latitude: pos.latitude,
      longitude: pos.longitude,
      speed: speedKmh,
      heading: pos.heading,
      accuracy: pos.accuracy,
      batteryLevel: 100, // Fallback battery level since battery_plus is not in pubspec
      status: status,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    ref.read(locationSharingRepositoryProvider).broadcastLocation(telemetry);
  }
}
