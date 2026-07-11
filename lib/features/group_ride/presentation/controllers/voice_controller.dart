// Dart imports:
import 'dart:async';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:quantane/features/group_ride/data/datasources/supabase_provider.dart';
import 'package:quantane/features/shared/providers/auth_service.dart';

part 'voice_controller.g.dart';

class VoiceState {
  VoiceState({
    this.isConnected = false,
    this.isMuted = false,
    this.isConnecting = false,
    this.room,
    this.error,
    this.participants = const [],
  });

  final bool isConnected;
  final bool isMuted;
  final bool isConnecting;
  final Room? room;
  final String? error;
  final List<Participant> participants;

  VoiceState copyWith({
    bool? isConnected,
    bool? isMuted,
    bool? isConnecting,
    Room? room,
    String? error,
    List<Participant>? participants,
    bool clearRoom = false,
    bool clearError = false,
  }) {
    return VoiceState(
      isConnected: isConnected ?? this.isConnected,
      isMuted: isMuted ?? this.isMuted,
      isConnecting: isConnecting ?? this.isConnecting,
      room: clearRoom ? null : (room ?? this.room),
      error: clearError ? null : (error ?? this.error),
      participants: participants ?? this.participants,
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
      // 0. Request Microphone Permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        throw Exception(
          'Microphone permission is required to join voice chat.',
        );
      }

      final supabase = ref.read(supabaseClientProvider);
      final authState = ref.read(authServiceProvider);
      final userId =
          authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
      final displayName = authState.user?.displayName ?? 'Rider';

      // 1. Fetch voice room token from Supabase Edge Function
      final customUrl = dotenv.get('SUPERBASE_LIVE_TOKEN', fallback: '');
      final functionName =
          customUrl.isNotEmpty && Uri.parse(customUrl).pathSegments.isNotEmpty
          ? Uri.parse(customUrl).pathSegments.last
          : 'livekit-token-generator';

      final response = await supabase.functions.invoke(
        functionName,
        body: {
          'groupId': groupId,
          'userId': userId,
          'displayName': displayName,
        },
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
        participants: [
          if (room.localParticipant != null) room.localParticipant!,
          ...room.remoteParticipants.values,
        ],
      );

      // Listen to room events (disconnect, track updates)
      final listener = room.createListener();

      void updateParticipants() {
        if (state.room == null) return;
        final list = <Participant>[];
        if (room.localParticipant != null) {
          list.add(room.localParticipant!);
        }
        list.addAll(room.remoteParticipants.values);
        state = state.copyWith(participants: list);
      }

      listener.on<RoomDisconnectedEvent>((event) {
        state = VoiceState();
      });

      listener.on<ParticipantConnectedEvent>((event) {
        updateParticipants();
      });

      listener.on<ParticipantDisconnectedEvent>((event) {
        updateParticipants();
      });

      listener.on<TrackPublishedEvent>((event) {
        updateParticipants();
      });

      listener.on<TrackUnpublishedEvent>((event) {
        updateParticipants();
      });

      listener.on<ActiveSpeakersChangedEvent>((event) {
        updateParticipants();
      });

      listener.on<TrackMutedEvent>((event) {
        updateParticipants();
      });

      listener.on<TrackUnmutedEvent>((event) {
        updateParticipants();
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
