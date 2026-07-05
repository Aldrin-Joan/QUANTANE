// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:quantane/features/group_ride/data/datasources/supabase_provider.dart';

part 'voice_controller.g.dart';

class VoiceState {
  VoiceState({
    this.isConnected = false,
    this.isMuted = false,
    this.isConnecting = false,
    this.room,
    this.error,
  });

  final bool isConnected;
  final bool isMuted;
  final bool isConnecting;
  final Room? room;
  final String? error;

  VoiceState copyWith({
    bool? isConnected,
    bool? isMuted,
    bool? isConnecting,
    Room? room,
    String? error,
    bool clearRoom = false,
    bool clearError = false,
  }) {
    return VoiceState(
      isConnected: isConnected ?? this.isConnected,
      isMuted: isMuted ?? this.isMuted,
      isConnecting: isConnecting ?? this.isConnecting,
      room: clearRoom ? null : (room ?? this.room),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@Riverpod(keepAlive: true)
class VoiceController extends _$VoiceController {
  @override
  VoiceState build() {
    ref.onDispose(() {
      unawaited(leaveVoice());
    });
    return VoiceState();
  }

  Future<void> joinVoice(String groupId) async {
    if (state.isConnected || state.isConnecting) return;

    state = state.copyWith(isConnecting: true, clearError: true);

    try {
      final supabase = ref.read(supabaseClientProvider);

      // 1. Fetch voice room token from Supabase Edge Function
      final customUrl = dotenv.get('SUPERBASE_LIVE_TOKEN', fallback: '');
      final functionName = customUrl.isNotEmpty && Uri.parse(customUrl).pathSegments.isNotEmpty
          ? Uri.parse(customUrl).pathSegments.last
          : 'livekit-token-generator';

      final response = await supabase.functions.invoke(
        functionName,
        body: {'groupId': groupId},
      );

      final token = response.data['token'] as String?;
      if (token == null) {
        throw Exception('Failed to obtain Voice Room Token from backend.');
      }

      final livekitUrl = dotenv.get(
        'LIVEKIT_URL',
        fallback: 'wss://quantane.livekit.cloud',
      );

      // 2. Initialize and connect LiveKit Room
      final room = Room();
      await room.connect(livekitUrl, token);

      // 3. Enable Local Microphone Track
      await room.localParticipant?.setMicrophoneEnabled(true);

      state = state.copyWith(
        isConnected: true,
        isConnecting: false,
        room: room,
        isMuted: false,
      );

      // Listen to room events (disconnect, track updates)
      final listener = room.createListener();
      listener.on<RoomDisconnectedEvent>((event) {
        state = VoiceState();
      });
    } on FunctionException catch (e) {
      final errorMessage = e.status == 404
          ? 'Failed to join voice session: Edge Function "livekit-token-generator" was not found (404).\n\nPlease deploy it using the Supabase CLI: "supabase functions deploy livekit-token-generator".'
          : 'Failed to join voice session: FunctionException (${e.status}) ${e.details ?? e.reasonPhrase}';
      state = state.copyWith(
        isConnecting: false,
        error: errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isConnecting: false,
        error: 'Failed to join voice session: $e',
      );
    }
  }

  Future<void> toggleMute() async {
    final room = state.room;
    if (room == null || !state.isConnected) return;

    final newMuteState = !state.isMuted;
    try {
      await room.localParticipant?.setMicrophoneEnabled(!newMuteState);
      state = state.copyWith(isMuted: newMuteState);
    } catch (_) {}
  }

  Future<void> leaveVoice() async {
    final room = state.room;
    if (room != null) {
      await room.disconnect();
    }
    state = VoiceState();
  }
}
