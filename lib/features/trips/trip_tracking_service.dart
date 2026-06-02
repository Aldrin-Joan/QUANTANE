import 'dart:async';
import 'package:geolocator/geolocator.dart';

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
  StreamSubscription<Position>? _subscription;
  
  Stream<TripState> startTracking() {
    final startTime = DateTime.now();
    var maxSpeed = 0.0;
    var totalDistance = 0.0;
    Position? lastPosition;
    final positions = <Position>[];

    final controller = StreamController<TripState>();

    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      positions.add(position);
      
      final speedKmh = position.speed * 3.6;
      if (speedKmh > maxSpeed) maxSpeed = speedKmh;

      if (lastPosition != null) {
        totalDistance += Geolocator.distanceBetween(
          lastPosition!.latitude,
          lastPosition!.longitude,
          position.latitude,
          position.longitude,
        ) / 1000.0; // KM
      }
      lastPosition = position;

      controller.add(TripState(
        currentSpeed: speedKmh,
        maxSpeed: maxSpeed,
        distance: totalDistance,
        startTime: startTime,
        positions: positions,
      ));
    });

    return controller.stream;
  }

  void stopTracking() {
    _subscription?.cancel();
    _subscription = null;
  }
}
