import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/features/trips/services/nominatim_geocoding_service.dart';
import 'package:quantane/features/trips/services/route_processing_service.dart';
import 'package:quantane/features/trips/services/route_snapshot_service.dart';
import 'package:quantane/features/trips/services/trip_finalization_service.dart';
import 'package:quantane/features/trips/trip_session_models.dart';

class _IntegrationGeocoder implements ReverseGeocodingService {
  @override
  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    if (latitude < 13.09) {
      return 'Anna Nagar, Chennai';
    }
    return 'T Nagar, Chennai';
  }
}

TripPoint _point(double lat, double lng) {
  return TripPoint(
    latitude: lat,
    longitude: lng,
    timestamp: DateTime(2026, 6, 14),
    speedKmh: 30,
    accuracyMeters: 8,
    heading: null,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('trip finalization persists enriched trip into sqlite', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = TripRepository(database);
    final service = TripFinalizationService(
      routeProcessingService: RouteProcessingService(),
      geocodingService: _IntegrationGeocoder(),
      snapshotWriter: FakeRouteSnapshotWriter(),
    );

    final session = TripState(
      sessionId: 'integration-trip',
      vehicleId: 'vehicle-1',
      startTime: DateTime(2026, 6, 14, 8),
      updatedAt: DateTime(2026, 6, 14, 8, 25),
      currentSpeed: 0,
      maxSpeed: 58,
      distance: 12.4,
      endTime: DateTime(2026, 6, 14, 8, 25),
      positions: [
        _point(13.0800, 80.2700),
        _point(13.0850, 80.2750),
        _point(13.0900, 80.2800),
        _point(13.1000, 80.2900),
      ],
    );

    final finalizedTrip = await service.finalize(session);
    await repository.insert(finalizedTrip);

    final loaded = await repository.getById('integration-trip');
    expect(loaded, isNotNull);
    expect(loaded!.routePoints, isNotEmpty);
    expect(loaded.startAddress, 'Anna Nagar, Chennai');
    expect(loaded.endAddress, 'T Nagar, Chennai');
    expect(loaded.maxLatitude, greaterThan(loaded.minLatitude));
    expect(loaded.routeSnapshotPath, isNotNull);

    await database.close();
  });

  test('geocoding failure still persists trip record', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = TripRepository(database);
    final service = TripFinalizationService(
      routeProcessingService: RouteProcessingService(),
      geocodingService: _FailingIntegrationGeocoder(),
      snapshotWriter: FakeRouteSnapshotWriter(),
    );

    final session = TripState(
      sessionId: 'failure-trip',
      vehicleId: 'vehicle-1',
      startTime: DateTime(2026, 6, 14, 8),
      updatedAt: DateTime(2026, 6, 14, 8, 25),
      currentSpeed: 0,
      maxSpeed: 40,
      distance: 6.2,
      endTime: DateTime(2026, 6, 14, 8, 25),
      positions: [
        _point(13.0800, 80.2700),
        _point(13.0900, 80.2800),
      ],
    );

    final finalizedTrip = await service.finalize(session);
    await repository.insert(finalizedTrip);

    final loaded = await repository.getById('failure-trip');
    expect(loaded, isNotNull);
    expect(loaded!.distance, 6.2);
    expect(loaded.startAddress, isNull);
    expect(loaded.routePoints.length, greaterThanOrEqualTo(2));

    await database.close();
  });
}

class _FailingIntegrationGeocoder implements ReverseGeocodingService {
  @override
  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    throw StateError('offline');
  }
}
