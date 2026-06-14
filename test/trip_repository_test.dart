import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/trips/trip_session_models.dart';

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
  group('TripRepository', () {
    late Directory tempDir;
    late AppDatabase database;
    late TripRepository repository;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('quantane_trip_repo_');
      TripSnapshotStorage.documentsDirectoryOverride = () async => tempDir;
      database = AppDatabase.forTesting(NativeDatabase.memory());
      repository = TripRepository(database);
    });

    tearDown(() async {
      TripSnapshotStorage.documentsDirectoryOverride = null;
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
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

    test('delete removes snapshot file when present', () async {
      final snapshotsDir = Directory('${tempDir.path}/trip_snapshots');
      await snapshotsDir.create(recursive: true);
      final snapshotFile = File('${snapshotsDir.path}/trip-2.png');
      await snapshotFile.writeAsString('snapshot');

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
      expect(await snapshotFile.exists(), isFalse);
    });
  });
}
