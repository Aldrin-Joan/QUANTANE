import 'dart:async';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/features/trips/trip_session_models.dart';
import 'package:quantane/features/trips/trip_tracking_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_providers.g.dart';

enum TripTrackingStatus { idle, waitingForLocation, live }

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
  TripTrackingStatus _status = TripTrackingStatus.idle;
  Future<void>? _bootstrapFuture;

  @override
  TripState? build() {
    unawaited(_bootstrapOnce());
    ref.onDispose(() {
      unawaited(_sub?.cancel());
      unawaited(_service.dispose());
    });
    return _service.currentState;
  }

  TripTrackingStatus get status => _status;

  Future<void> _bootstrapOnce() {
    return _bootstrapFuture ??= _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _service.initialize();
    _sub ??= _service.watchState().listen((tripState) {
      state = tripState;
      _status = tripState == null
          ? TripTrackingStatus.idle
          : TripTrackingStatus.live;
    });

    final restored = await _service.restorePersistedSession();
    if (restored != null) {
      state = restored;
      _status = TripTrackingStatus.live;
    }
  }

  Future<void> start({required String vehicleId}) async {
    _status = TripTrackingStatus.waitingForLocation;
    final session = await _service.startTrip(vehicleId: vehicleId);
    state = session;
    _status = TripTrackingStatus.live;
  }

  Future<void> stop() async {
    _status = TripTrackingStatus.waitingForLocation;
    final finalizedSession = await _service.stopTrip();
    if (finalizedSession == null) {
      _status = TripTrackingStatus.idle;
      state = null;
      return;
    }

    state = finalizedSession;
    await ref.read(tripRepositoryProvider).insert(finalizedSession.toTrip());
    await _service.restorePersistedSession();
    _status = TripTrackingStatus.idle;
    state = null;
  }

  Future<void> restore() async {
    await _bootstrapOnce();
  }
}
