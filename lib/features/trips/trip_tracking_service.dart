import 'dart:async';
import 'package:geolocator/geolocator.dart';

typedef PositionStreamFactory =
    Stream<Position> Function({LocationSettings? locationSettings});

class TripState {
  final double currentSpeed;
  final double maxSpeed;
  final double distance;
  final DateTime startTime;
  final List<Position> positions;

  TripState({
    required this.currentSpeed,
    required this.maxSpeed,
    required this.distance,
    required this.startTime,
    required this.positions,
  });

  TripState copyWith({
    double? currentSpeed,
    double? maxSpeed,
    double? distance,
    List<Position>? positions,
  }) {
    return TripState(
      currentSpeed: currentSpeed ?? this.currentSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      distance: distance ?? this.distance,
      startTime: startTime,
      positions: positions ?? this.positions,
    );
  }
}

class TripTrackingService {
  final PositionStreamFactory _positionStreamFactory;
  StreamSubscription<Position>? _subscription;
  static const double _maxReasonableStepMeters = 5000.0;

  TripTrackingService({
    PositionStreamFactory positionStreamFactory = Geolocator.getPositionStream,
  }) : _positionStreamFactory = positionStreamFactory;

  Stream<TripState> startTracking() {
    final startTime = DateTime.now();
    final controller = StreamController<TripState>();
    var maxSpeed = 0.0;
    var totalDistance = 0.0;
    Position? lastPosition;
    Position? baselinePosition;
    final positions = <Position>[];

    controller.add(
      TripState(
        currentSpeed: 0,
        maxSpeed: 0,
        distance: 0,
        startTime: startTime,
        positions: const [],
      ),
    );

    () async {
      final locationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!locationEnabled) {
        await controller.close();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await controller.close();
        return;
      }

      _subscription?.cancel();
      _subscription =
          _positionStreamFactory(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen(
            (position) {
              positions.add(position);

              final speedKmh = _deriveSpeedKmh(
                current: position,
                previous: lastPosition,
              );
              if (speedKmh > maxSpeed) maxSpeed = speedKmh;

              if (baselinePosition == null) {
                baselinePosition = position;
              } else if (lastPosition != null) {
                final stepMeters = Geolocator.distanceBetween(
                  lastPosition!.latitude,
                  lastPosition!.longitude,
                  position.latitude,
                  position.longitude,
                );

                if (stepMeters <= _maxReasonableStepMeters) {
                  totalDistance += stepMeters / 1000.0;
                }
              }
              lastPosition = position;

              controller.add(
                TripState(
                  currentSpeed: speedKmh,
                  maxSpeed: maxSpeed,
                  distance: totalDistance,
                  startTime: startTime,
                  positions: List.unmodifiable(positions),
                ),
              );
            },
            onError: controller.addError,
            onDone: controller.close,
            cancelOnError: false,
          );
    }();

    return controller.stream;
  }

  void stopTracking() {
    _subscription?.cancel();
    _subscription = null;
  }

  double _deriveSpeedKmh({required Position current, Position? previous}) {
    final platformSpeedKmh = current.speed * 3.6;
    if (platformSpeedKmh > 0) {
      return platformSpeedKmh;
    }

    if (previous == null) {
      return 0.0;
    }

    final elapsedSeconds =
        current.timestamp.difference(previous.timestamp).inMilliseconds /
        1000.0;
    if (elapsedSeconds <= 0) {
      return 0.0;
    }

    final distanceMeters = Geolocator.distanceBetween(
      previous.latitude,
      previous.longitude,
      current.latitude,
      current.longitude,
    );

    return (distanceMeters / elapsedSeconds) * 3.6;
  }
}
