// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:quantane/features/trips/services/nominatim_geocoding_service.dart';
import 'package:quantane/features/trips/services/route_processing_service.dart';
import 'package:quantane/features/trips/services/route_snapshot_service.dart';
import 'package:quantane/features/trips/services/trip_finalization_service.dart';
import 'package:quantane/features/trips/trip_session_models.dart';

class _FakeGeocodingService implements ReverseGeocodingService {

  _FakeGeocodingService(this.addresses);
  final Map<String, String> addresses;

  @override
  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    return addresses['$latitude:$longitude'];
  }
}

TripPoint _point(double lat, double lng) {
  return TripPoint(
    latitude: lat,
    longitude: lng,
    timestamp: DateTime(2026, 6, 14),
    speedKmh: 35,
    accuracyMeters: 8,
    heading: null,
  );
}

TripState _session({required List<TripPoint> positions}) {
  return TripState(
    sessionId: 'trip-1',
    vehicleId: 'vehicle-1',
    startTime: DateTime(2026, 6, 14, 8),
    updatedAt: DateTime(2026, 6, 14, 8, 30),
    currentSpeed: 0,
    maxSpeed: 62,
    distance: 15.2,
    endTime: DateTime(2026, 6, 14, 8, 30),
    positions: positions,
  );
}

void main() {
  group('TripFinalizationService', () {
    test('persists base trip when route has fewer than two points', () async {
      final service = TripFinalizationService(
        routeProcessingService: RouteProcessingService(),
        geocodingService: _FakeGeocodingService({}),
        snapshotWriter: FakeRouteSnapshotWriter(),
      );

      final trip = await service.finalize(
        _session(positions: [_point(13.08, 80.27)]),
      );

      expect(trip.id, 'trip-1');
      expect(trip.distance, 15.2);
      expect(trip.routePoints, isEmpty);
      expect(trip.startAddress, isNull);
      expect(trip.routeSnapshotPath, isNull);
    });

    test(
      'enriches trip with route metadata, addresses, and snapshot',
      () async {
        final service = TripFinalizationService(
          routeProcessingService: RouteProcessingService(),
          geocodingService: _FakeGeocodingService({
            '13.08:80.27': 'Anna Nagar, Chennai',
            '13.1:80.29': 'T Nagar, Chennai',
          }),
          snapshotWriter: FakeRouteSnapshotWriter(),
        );

        final trip = await service.finalize(
          _session(
            positions: [
              _point(13.0800, 80.2700),
              _point(13.0850, 80.2750),
              _point(13.0900, 80.2800),
              _point(13.1000, 80.2900),
            ],
          ),
        );

        expect(trip.routePoints.length, greaterThanOrEqualTo(2));
        expect(trip.startAddress, 'Anna Nagar, Chennai');
        expect(trip.endAddress, 'T Nagar, Chennai');
        expect(trip.minLatitude, lessThanOrEqualTo(trip.maxLatitude));
        expect(trip.routeSnapshotPath, 'trip_snapshots/trip-1.png');
        expect(trip.avgSpeed, isNotNull);
        expect(trip.maxSpeed, 62);
      },
    );

    test('still returns trip when geocoding and snapshot fail', () async {
      final service = TripFinalizationService(
        routeProcessingService: RouteProcessingService(),
        geocodingService: _FailingGeocoder(),
        snapshotWriter: _FailingSnapshotWriter(),
      );

      final trip = await service.finalize(
        _session(
          positions: [
            _point(13.0800, 80.2700),
            _point(13.0900, 80.2800),
            _point(13.1000, 80.2900),
          ],
        ),
      );

      expect(trip.id, 'trip-1');
      expect(trip.routePoints, isNotEmpty);
      expect(trip.startAddress, isNull);
      expect(trip.routeSnapshotPath, isNull);
    });

    test('handles large routes through simplification pipeline', () async {
      final positions = List<TripPoint>.generate(
        10000,
        (index) =>
            _point(13.08 + (index * 0.000005), 80.27 + (index * 0.000005)),
      );

      final service = TripFinalizationService(
        routeProcessingService: RouteProcessingService(),
        geocodingService: _FakeGeocodingService({}),
        snapshotWriter: FakeRouteSnapshotWriter(),
      );

      final trip = await service.finalize(_session(positions: positions));
      expect(trip.routePoints.length, lessThan(positions.length));
      expect(trip.hasRoute, isTrue);
    });
  });
}

class _FailingGeocoder implements ReverseGeocodingService {
  @override
  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    throw StateError('geocoding failed');
  }
}

class _FailingSnapshotWriter implements RouteSnapshotWriter {
  @override
  Future<String?> writeSnapshot({
    required String tripId,
    required ProcessedRoute route,
  }) async {
    throw StateError('snapshot failed');
  }
}
