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
  StreamSubscription<Map<String, Map<String, dynamic>>>? _presenceSub;
  String? _activeGroupId;
  Timer? _heartbeatTimer;
  Position? _lastKnownPosition;

  @override
  void build() {
    ref.onDispose(() {
      _positionSub?.cancel();
      _presenceSub?.cancel();
      _heartbeatTimer?.cancel();
    });
  }

  void startSharing(String groupId) {
    _activeGroupId = groupId;
    _positionSub?.cancel();
    _presenceSub?.cancel();
    _heartbeatTimer?.cancel();

    // 1. Join Supabase Broadcast channel
    final authState = ref.read(authServiceProvider);
    final userId =
        authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final name = authState.user?.displayName ?? 'Rider';

    final repo = ref.read(locationSharingRepositoryProvider);
    repo.startSharing(groupId, userId, {
      'status': 'online',
      'display_name': name,
    });

    // 2. Fetch initial position immediately
    Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5),
        )
        .then((pos) {
          _lastKnownPosition = pos;
          _broadcast(pos);
        })
        .catchError((_) {});

    // 3. Start listening to Geolocator stream
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Send every 5 meters
    );

    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((pos) {
          _lastKnownPosition = pos;
          _broadcast(pos);
        });

    // 4. Periodically broadcast current location (heartbeat keepalive)
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      final pos = _lastKnownPosition;
      if (pos != null) {
        _broadcast(pos);
      }
    });

    // 5. Trigger immediate broadcast when presence list updates (e.g. other riders join)
    _presenceSub = repo.presenceStream.listen((_) {
      final pos = _lastKnownPosition;
      if (pos != null) {
        _broadcast(pos);
      }
    });
  }

  void stopSharing() {
    _activeGroupId = null;
    _positionSub?.cancel();
    _positionSub = null;
    _presenceSub?.cancel();
    _presenceSub = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _lastKnownPosition = null;
    ref.read(locationSharingRepositoryProvider).stopSharing();
  }

  void _broadcast(Position pos) {
    final groupId = _activeGroupId;
    final authState = ref.read(authServiceProvider);
    final userId =
        authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (groupId == null || userId == null) return;

    final speedKmh = pos.speed * 3.6;
    final status = speedKmh > 2 ? 'moving' : 'stationary';
    final name = authState.user?.displayName ?? 'Rider';

    final telemetry = RiderTelemetry(
      riderId: userId,
      latitude: pos.latitude,
      longitude: pos.longitude,
      speed: speedKmh,
      heading: pos.heading,
      accuracy: pos.accuracy,
      batteryLevel:
          100, // Fallback battery level since battery_plus is not in pubspec
      status: status,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      displayName: name,
    );

    ref.read(locationSharingRepositoryProvider).broadcastLocation(telemetry);
  }
}
