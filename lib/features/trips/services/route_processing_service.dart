import 'package:latlong2/latlong.dart';
import 'package:quantane/features/trips/services/route_simplifier.dart';
import 'package:quantane/features/trips/trip_session_models.dart';

class RouteBoundingBox {

  const RouteBoundingBox({
    required this.minLatitude,
    required this.maxLatitude,
    required this.minLongitude,
    required this.maxLongitude,
  });
  final double minLatitude;
  final double maxLatitude;
  final double minLongitude;
  final double maxLongitude;

  bool get isValid =>
      minLatitude != maxLatitude || minLongitude != maxLongitude;

  LatLng get center => LatLng(
    (minLatitude + maxLatitude) / 2,
    (minLongitude + maxLongitude) / 2,
  );
}

class ProcessedRoute {

  const ProcessedRoute({
    required this.simplifiedPoints,
    required this.boundingBox,
  });
  final List<TripPoint> simplifiedPoints;
  final RouteBoundingBox boundingBox;

  bool get hasRenderableRoute => simplifiedPoints.length >= 2;

  List<LatLng> get polylinePoints => simplifiedPoints
      .map((point) => LatLng(point.latitude, point.longitude))
      .toList(growable: false);

  TripPoint? get startPoint =>
      simplifiedPoints.isEmpty ? null : simplifiedPoints.first;

  TripPoint? get endPoint =>
      simplifiedPoints.isEmpty ? null : simplifiedPoints.last;
}

class RouteProcessingService {

  RouteProcessingService({RouteSimplifier? simplifier})
    : _simplifier = simplifier ?? RouteSimplifier();
  final RouteSimplifier _simplifier;

  Future<ProcessedRoute?> process(List<TripPoint> points) async {
    if (points.length < 2) {
      return null;
    }

    final simplifiedPoints = await _simplifier.simplify(points);
    if (simplifiedPoints.length < 2) {
      return null;
    }

    return ProcessedRoute(
      simplifiedPoints: simplifiedPoints,
      boundingBox: computeBoundingBox(simplifiedPoints),
    );
  }

  RouteBoundingBox computeBoundingBox(List<TripPoint> points) {
    if (points.isEmpty) {
      return const RouteBoundingBox(
        minLatitude: 0,
        maxLatitude: 0,
        minLongitude: 0,
        maxLongitude: 0,
      );
    }

    var minLatitude = points.first.latitude;
    var maxLatitude = points.first.latitude;
    var minLongitude = points.first.longitude;
    var maxLongitude = points.first.longitude;

    for (final point in points.skip(1)) {
      minLatitude = minLatitude < point.latitude ? minLatitude : point.latitude;
      maxLatitude = maxLatitude > point.latitude ? maxLatitude : point.latitude;
      minLongitude = minLongitude < point.longitude
          ? minLongitude
          : point.longitude;
      maxLongitude = maxLongitude > point.longitude
          ? maxLongitude
          : point.longitude;
    }

    return RouteBoundingBox(
      minLatitude: minLatitude,
      maxLatitude: maxLatitude,
      minLongitude: minLongitude,
      maxLongitude: maxLongitude,
    );
  }
}
