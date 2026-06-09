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

  TripTrackingService({
    PositionStreamFactory positionStreamFactory = Geolocator.getPositionStream,
  }) : _positionStreamFactory = positionStreamFactory;

  Stream<TripState> startTracking() {
    final startTime = DateTime.now();
    final controller = StreamController<TripState>();
    var maxSpeed = 0.0;
    var totalDistance = 0.0;
    Position? lastPosition;
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

            final speedKmh = position.speed * 3.6;
            if (speedKmh > maxSpeed) maxSpeed = speedKmh;

            if (lastPosition != null) {
              totalDistance +=
                  Geolocator.distanceBetween(
                    lastPosition!.latitude,
                    lastPosition!.longitude,
                    position.latitude,
                    position.longitude,
                  ) /
                  1000.0;
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

    return controller.stream;
  }

  void stopTracking() {
    _subscription?.cancel();
    _subscription = null;
  }
}
