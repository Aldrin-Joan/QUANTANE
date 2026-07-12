// Dart imports:
import 'dart:async';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:quantane/features/group_ride/domain/entities/rider_telemetry.dart';

class LocationSharingRepository {
  LocationSharingRepository(this._client);

  final SupabaseClient _client;
  RealtimeChannel? _channel;
  final _telemetryController = StreamController<RiderTelemetry>.broadcast();
  final _presenceController =
      StreamController<Map<String, Map<String, dynamic>>>.broadcast();

  Stream<RiderTelemetry> get telemetryStream => _telemetryController.stream;
  Stream<Map<String, Map<String, dynamic>>> get presenceStream =>
      _presenceController.stream;

  void startSharing(
    String groupId,
    String userId,
    Map<String, dynamic> initialPresence,
  ) {
    stopSharing();

    _channel = _client.channel('room:group_ride:$groupId');

    // 1. Listen to Broadcast location updates
    _channel!.onBroadcast(
      event: 'location_update',
      callback: (payload) {
        try {
          final telemetry = RiderTelemetry.fromJson(payload);
          // Only emit coordinates from OTHER riders
          if (telemetry.riderId != userId) {
            _telemetryController.add(telemetry);
          }
        } catch (_) {}
      },
    );

    // 2. Listen to Presence state changes
    _channel!.onPresenceSync((_) {
      final state = _channel!.presenceState();
      final presenceData = <String, Map<String, dynamic>>{};
      for (final singleState in state) {
        for (final presence in singleState.presences) {
          final payload = presence.payload;
          if (payload['user_id'] != null) {
            presenceData[payload['user_id'] as String] = payload;
          }
        }
      }
      _presenceController.add(presenceData);
    });

    // 3. Subscribe to Channel & join presence
    _channel!.subscribe((status, error) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        _channel!.track({
          'user_id': userId,
          ...initialPresence,
        });
      }
    });
  }

  Future<void> broadcastLocation(RiderTelemetry telemetry) async {
    final chan = _channel;
    if (chan == null) return;

    try {
      await chan.sendBroadcastMessage(
        event: 'location_update',
        payload: telemetry.toJson(),
      );
    } catch (_) {}
  }

  void stopSharing() {
    final chan = _channel;
    if (chan != null) {
      chan.unsubscribe();
      _client.removeChannel(chan);
      _channel = null;
    }
  }

  void dispose() {
    stopSharing();
    _telemetryController.close();
    _presenceController.close();
  }
}
