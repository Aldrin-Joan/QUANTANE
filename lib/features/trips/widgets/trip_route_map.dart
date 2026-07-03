import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:quantane/features/trips/services/route_processing_service.dart';
import 'package:quantane/features/trips/trip_session_models.dart';
import 'package:quantane/features/trips/widgets/trip_map_style.dart';

class TripRouteMap extends StatefulWidget {
  final List<TripPoint> routePoints;
  final double minLatitude;
  final double maxLatitude;
  final double minLongitude;
  final double maxLongitude;
  final bool interactive;
  final double? height;
  final bool showTileLayer;

  const TripRouteMap({
    super.key,
    required this.routePoints,
    required this.minLatitude,
    required this.maxLatitude,
    required this.minLongitude,
    required this.maxLongitude,
    this.interactive = true,
    this.height,
    this.showTileLayer = true,
  });

  @override
  State<TripRouteMap> createState() => _TripRouteMapState();
}

class _TripRouteMapState extends State<TripRouteMap> {
  final MapController _mapController = MapController();
  var _hasFittedCamera = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TripRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routePoints != widget.routePoints ||
        oldWidget.minLatitude != widget.minLatitude ||
        oldWidget.maxLatitude != widget.maxLatitude ||
        oldWidget.minLongitude != widget.minLongitude ||
        oldWidget.maxLongitude != widget.maxLongitude) {
      _hasFittedCamera = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitCamera());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.routePoints.length < 2 || !_hasBoundingBox) {
      return _RouteUnavailable(height: widget.height);
    }

    final polylinePoints = widget.routePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList(growable: false);
    final start = polylinePoints.first;
    final end = polylinePoints.last;

    WidgetsBinding.instance.addPostFrameCallback((_) => _fitCamera());

    final loadTileLayer = widget.showTileLayer && !_isRunningWidgetTest;

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          if (!loadTileLayer)
            const Positioned.fill(child: ColoredBox(color: Color(0xFF1A1F2B))),
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                (widget.minLatitude + widget.maxLatitude) / 2,
                (widget.minLongitude + widget.maxLongitude) / 2,
              ),
              initialZoom: 13,
              interactionOptions: InteractionOptions(
                flags: widget.interactive
                    ? InteractiveFlag.all
                    : InteractiveFlag.none,
              ),
            ),
            children: [
              if (loadTileLayer)
                TileLayer(
                  urlTemplate: TripMapStyle.tileUrlTemplate,
                  subdomains: TripMapStyle.subdomains,
                  userAgentPackageName: 'com.quantane.app.quantane',
                ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: polylinePoints,
                    color: TripMapStyle.routeColor,
                    strokeWidth: TripMapStyle.routeStrokeWidth,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: start,
                    width: TripMapStyle.markerSize,
                    height: TripMapStyle.markerSize,
                    child: const _RouteMarker(
                      color: TripMapStyle.startMarkerColor,
                    ),
                  ),
                  Marker(
                    point: end,
                    width: TripMapStyle.markerSize,
                    height: TripMapStyle.markerSize,
                    child: const _RouteMarker(
                      color: TripMapStyle.endMarkerColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Positioned(right: 8, bottom: 8, child: _AttributionLabel()),
        ],
      ),
    );
  }

  void _fitCamera() {
    if (_hasFittedCamera || !_hasBoundingBox) {
      return;
    }

    final southWest = LatLng(widget.minLatitude, widget.minLongitude);
    final northEast = LatLng(widget.maxLatitude, widget.maxLongitude);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(southWest, northEast),
        padding: const EdgeInsets.all(28),
      ),
    );
    _hasFittedCamera = true;
  }

  bool get _hasBoundingBox =>
      widget.minLatitude != widget.maxLatitude ||
      widget.minLongitude != widget.maxLongitude;

  bool get _isRunningWidgetTest =>
      WidgetsBinding.instance.runtimeType.toString() ==
      'AutomatedTestWidgetsFlutterBinding';
}

class _RouteMarker extends StatelessWidget {
  final Color color;

  const _RouteMarker({required this.color});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
    );
  }
}

class _AttributionLabel extends StatelessWidget {
  const _AttributionLabel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          TripMapStyle.attribution,
          style: TextStyle(color: Colors.white, fontSize: 9),
        ),
      ),
    );
  }
}

class _RouteUnavailable extends StatelessWidget {
  final double? height;

  const _RouteUnavailable({this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 220,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text('Route unavailable for this trip')),
      ),
    );
  }
}

TripRouteMap mapFromProcessedRoute(
  ProcessedRoute route, {
  bool interactive = true,
  double? height,
}) {
  return TripRouteMap(
    routePoints: route.simplifiedPoints,
    minLatitude: route.boundingBox.minLatitude,
    maxLatitude: route.boundingBox.maxLatitude,
    minLongitude: route.boundingBox.minLongitude,
    maxLongitude: route.boundingBox.maxLongitude,
    interactive: interactive,
    height: height,
  );
}
