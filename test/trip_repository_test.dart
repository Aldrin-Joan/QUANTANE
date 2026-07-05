// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/trips/trip_session_models.dart';

class FakeTripRepository implements TripRepository {
  final Map<String, Trip> _trips = {};

  @override
  Future<Trip?> getById(String id) async => _trips[id];

  @override
  Future<void> insert(Trip trip, {bool syncToFirebase = true}) async {
    _trips[trip.id] = trip;
  }

  @override
  Future<void> delete(String id, {bool syncToFirebase = true}) async {
    _trips.remove(id);
  }

  @override
  Stream<List<Trip>> watchAll(String vehicleId) {
    return Stream.value(
      _trips.values.where((t) => t.vehicleId == vehicleId).toList(),
    );
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
  group('TripRepository (Fake Integration)', () {
    late FakeTripRepository repository;

    setUp(() {
      repository = FakeTripRepository();
    });

    test('inserts and reads enriched trip fields', () async {
      final trip = Trip(
        id: 'trip-1',
        vehicleId: 'vehicle-1',
        startTime: DateTime(2026, 6, 14, 8),
        endTime: DateTime(2026, 6, 14, 8, 30),
        distance: 15.2,
        avgSpeed: 38,
        maxSpeed: 62,
        startAddress: 'Anna Nagar, Chennai',
        endAddress: 'T Nagar, Chennai',
        minLatitude: 13.08,
        maxLatitude: 13.1,
        minLongitude: 80.27,
        maxLongitude: 80.29,
        routeSnapshotPath: 'trip_snapshots/trip-1.png',
        routePoints: [
          _point(13.08, 80.27),
          _point(13.09, 80.28),
          _point(13.1, 80.29),
        ],
      );

      await repository.insert(trip);
      final loaded = await repository.getById('trip-1');

      expect(loaded, isNotNull);
      expect(loaded!.startAddress, 'Anna Nagar, Chennai');
      expect(loaded.endAddress, 'T Nagar, Chennai');
      expect(loaded.routePoints.length, 3);
      expect(loaded.routeSnapshotPath, 'trip_snapshots/trip-1.png');
      expect(loaded.minLatitude, 13.08);
      expect(loaded.maxLongitude, 80.29);
    });

    test('delete removes trip entry', () async {
      await repository.insert(
        Trip(
          id: 'trip-2',
          vehicleId: 'vehicle-1',
          startTime: DateTime(2026, 6, 14, 8),
          endTime: DateTime(2026, 6, 14, 8, 30),
          distance: 5,
          routeSnapshotPath: 'trip_snapshots/trip-2.png',
        ),
      );

      await repository.delete('trip-2');
      expect(await repository.getById('trip-2'), isNull);
    });
  });
}
