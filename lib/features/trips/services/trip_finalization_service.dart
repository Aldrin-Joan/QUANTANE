import 'package:flutter/foundation.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/trips/services/nominatim_geocoding_service.dart';
import 'package:quantane/features/trips/services/route_processing_service.dart';
import 'package:quantane/features/trips/services/route_snapshot_service.dart';
import 'package:quantane/features/trips/trip_session_models.dart';

class TripFinalizationService {
  final RouteProcessingService _routeProcessingService;
  final ReverseGeocodingService _geocodingService;
  final RouteSnapshotWriter _snapshotWriter;

  TripFinalizationService({
    required RouteProcessingService routeProcessingService,
    required ReverseGeocodingService geocodingService,
    required RouteSnapshotWriter snapshotWriter,
  }) : _routeProcessingService = routeProcessingService,
       _geocodingService = geocodingService,
       _snapshotWriter = snapshotWriter;

  Future<Trip> finalize(TripState session) async {
    final baseTrip = session.toTrip();

    if (session.positions.length < 2) {
      return baseTrip;
    }

    ProcessedRoute? processedRoute;
    try {
      processedRoute = await _routeProcessingService.process(session.positions);
    } catch (error, stack) {
      debugPrint('Route processing failed: $error\n$stack');
    }

    if (processedRoute == null || !processedRoute.hasRenderableRoute) {
      return baseTrip;
    }

    final bbox = processedRoute.boundingBox;
    var startAddress = await _safeReverseGeocode(processedRoute.startPoint);
    var endAddress = await _safeReverseGeocode(processedRoute.endPoint);

    final snapshotPath = await _safeGenerateSnapshot(
      tripId: session.sessionId,
      route: processedRoute,
    );

    return Trip(
      id: baseTrip.id,
      vehicleId: baseTrip.vehicleId,
      startTime: baseTrip.startTime,
      endTime: baseTrip.endTime,
      distance: baseTrip.distance,
      avgSpeed: baseTrip.avgSpeed,
      maxSpeed: baseTrip.maxSpeed,
      minSpeed: baseTrip.minSpeed,
      startAddress: startAddress,
      endAddress: endAddress,
      minLatitude: bbox.minLatitude,
      maxLatitude: bbox.maxLatitude,
      minLongitude: bbox.minLongitude,
      maxLongitude: bbox.maxLongitude,
      routeSnapshotPath: snapshotPath,
      routePoints: processedRoute.simplifiedPoints,
    );
  }

  Future<String?> _safeReverseGeocode(TripPoint? point) async {
    if (point == null) {
      return null;
    }

    try {
      return await _geocodingService.reverseGeocode(
        latitude: point.latitude,
        longitude: point.longitude,
      );
    } catch (error, stack) {
      debugPrint('Reverse geocoding failed: $error\n$stack');
      return null;
    }
  }

  Future<String?> _safeGenerateSnapshot({
    required String tripId,
    required ProcessedRoute route,
  }) async {
    try {
      return await _snapshotWriter.writeSnapshot(tripId: tripId, route: route);
    } catch (error, stack) {
      debugPrint('Snapshot generation failed: $error\n$stack');
      return null;
    }
  }
}
