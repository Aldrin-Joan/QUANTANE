import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/features/trips/trip_session_models.dart';
import 'package:quantane/features/trips/trip_tracking_service.dart';
import 'package:quantane/features/trips/trip_tracking_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_providers.g.dart';

enum TripTrackingStatus { idle, bootstrapping, waitingForLocation, live }

@riverpod
Stream<List<Trip>> tripHistory(Ref ref) {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return Stream.value([]);

  final tripRepo = ref.watch(tripRepositoryProvider);
  return tripRepo.watchAll(vehicleId);
}

@Riverpod(keepAlive: true)
class TripTracking extends _$TripTracking {
  final TripTrackingService _service = TripTrackingService();
  StreamSubscription<TripState?>? _sub;
  Future<void>? _bootstrapFuture;

  @override
  TripTrackingState build() {
    unawaited(_bootstrapOnce());
    ref.onDispose(() {
      unawaited(_sub?.cancel());
      unawaited(_service.dispose());
    });
    return TripTrackingState(
      session: _service.currentState,
      status: TripTrackingStatus.bootstrapping,
    );
  }

  Future<void> _bootstrapOnce() {
    return _bootstrapFuture ??= _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _service.initialize();
    _sub ??= _service.watchState().listen((tripState) {
      if (tripState != null && !tripState.isActive) {
        unawaited(_persistAndClearSession(tripState));
        return;
      }

      state = state.copyWith(
        session: tripState,
        clearSession: tripState == null,
        status: tripState == null
            ? TripTrackingStatus.idle
            : TripTrackingStatus.live,
      );
    });

    final restored = await _service.restorePersistedSession();
    if (restored != null) {
      if (restored.isActive) {
        state = state.copyWith(
          session: restored,
          status: TripTrackingStatus.live,
        );
      } else {
        // Recovered a finalized trip that was never saved to DB.
        await _persistAndClearSession(restored);
      }
    } else {
      state = state.copyWith(status: TripTrackingStatus.idle);
    }
  }

  Future<void> _persistAndClearSession(TripState finalizedSession) async {
    try {
      await ref.read(tripRepositoryProvider).insert(finalizedSession.toTrip());
      await _service.clearPersistedSession();
      state = state.copyWith(clearSession: true, status: TripTrackingStatus.idle);
    } catch (e, stack) {
      // Log error but allow UI to continue.
      debugPrint('Error persisting trip session: $e\n$stack');
      state = state.copyWith(status: TripTrackingStatus.idle);
    }
  }

  Future<void> start({required String vehicleId}) async {
    state = state.copyWith(status: TripTrackingStatus.waitingForLocation);
    final session = await _service.startTrip(vehicleId: vehicleId);
    state = state.copyWith(session: session, status: TripTrackingStatus.live);
  }

  Future<void> stop() async {
    state = state.copyWith(status: TripTrackingStatus.waitingForLocation);
    final finalizedSession = await _service.stopTrip();
    if (finalizedSession == null) {
      state = state.copyWith(clearSession: true, status: TripTrackingStatus.idle);
      return;
    }

    await _persistAndClearSession(finalizedSession);
  }

  Future<void> restore() async {
    await _bootstrapOnce();
  }
}
