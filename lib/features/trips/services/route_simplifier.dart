// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:geolocator/geolocator.dart';

// Project imports:
import 'package:quantane/features/trips/trip_session_models.dart';

class RouteSimplifier {
  static const double defaultEpsilonMeters = 8;

  Future<List<TripPoint>> simplify(
    List<TripPoint> points, {
    double epsilonMeters = defaultEpsilonMeters,
  }) async {
    if (points.length <= 2) {
      return List<TripPoint>.from(points);
    }

    return compute(_simplifyInIsolate, _SimplifyRequest(points, epsilonMeters));
  }

  static List<TripPoint> simplifySync(
    List<TripPoint> points, {
    double epsilonMeters = defaultEpsilonMeters,
  }) {
    if (points.length <= 2) {
      return List<TripPoint>.from(points);
    }

    return _douglasPeucker(points, epsilonMeters);
  }
}

class _SimplifyRequest {

  const _SimplifyRequest(this.points, this.epsilonMeters);
  final List<TripPoint> points;
  final double epsilonMeters;
}

List<TripPoint> _simplifyInIsolate(_SimplifyRequest request) {
  return RouteSimplifier.simplifySync(
    request.points,
    epsilonMeters: request.epsilonMeters,
  );
}

List<TripPoint> _douglasPeucker(List<TripPoint> points, double epsilonMeters) {
  if (points.length < 3) {
    return List<TripPoint>.from(points);
  }

  var maxDistance = 0.0;
  var index = 0;

  final start = points.first;
  final end = points.last;

  for (var i = 1; i < points.length - 1; i++) {
    final distance = _perpendicularDistanceMeters(
      point: points[i],
      lineStart: start,
      lineEnd: end,
    );
    if (distance > maxDistance) {
      maxDistance = distance;
      index = i;
    }
  }

  if (maxDistance > epsilonMeters) {
    final left = _douglasPeucker(points.sublist(0, index + 1), epsilonMeters);
    final right = _douglasPeucker(points.sublist(index), epsilonMeters);
    return [...left.sublist(0, left.length - 1), ...right];
  }

  return [start, end];
}

double _perpendicularDistanceMeters({
  required TripPoint point,
  required TripPoint lineStart,
  required TripPoint lineEnd,
}) {
  final startLat = lineStart.latitude;
  final startLng = lineStart.longitude;
  final endLat = lineEnd.latitude;
  final endLng = lineEnd.longitude;
  final pointLat = point.latitude;
  final pointLng = point.longitude;

  if (startLat == endLat && startLng == endLng) {
    return Geolocator.distanceBetween(startLat, startLng, pointLat, pointLng);
  }

  final dx = endLng - startLng;
  final dy = endLat - startLat;
  final lengthSquared = dx * dx + dy * dy;
  final projection =
      ((pointLng - startLng) * dx + (pointLat - startLat) * dy) / lengthSquared;
  final clampedProjection = projection.clamp(0.0, 1.0);
  final projectedLat = startLat + clampedProjection * dy;
  final projectedLng = startLng + clampedProjection * dx;

  return Geolocator.distanceBetween(
    pointLat,
    pointLng,
    projectedLat,
    projectedLng,
  );
}
