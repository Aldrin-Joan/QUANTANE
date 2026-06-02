import 'dart:async';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/features/trips/trip_tracking_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_providers.g.dart';

@riverpod
Stream<List<Trip>> tripHistory(Ref ref) {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return Stream.value([]);

  final tripRepo = ref.watch(tripRepositoryProvider);
  return tripRepo.watchAll(vehicleId);
}

@Riverpod(keepAlive: true)
class TripTracking extends _$TripTracking {
  final _service = TripTrackingService();
  StreamSubscription<TripState>? _sub;

  @override
  TripState? build() {
    ref.onDispose(() => _sub?.cancel());
    return null;
  }

  void start() {
    _sub?.cancel();
    _sub = _service.startTracking().listen((tripState) {
      state = tripState;
    });
  }

  void stop() {
    _service.stopTracking();
    _sub?.cancel();
    _sub = null;
    state = null;
  }
}
