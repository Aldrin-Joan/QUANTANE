// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:quantane/features/trips/services/route_processing_service.dart';
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
  group('RouteProcessingService', () {
    final service = RouteProcessingService();

    test('returns null for fewer than two points', () async {
      expect(await service.process([_point(13.08, 80.27)]), isNull);
      expect(await service.process(const []), isNull);
    });

    test('computes bounding box from simplified route', () async {
      final processed = await service.process([
        _point(13.0800, 80.2700),
        _point(13.0900, 80.2800),
        _point(13.1000, 80.2900),
      ]);

      expect(processed, isNotNull);
      expect(processed!.boundingBox.minLatitude, 13.0800);
      expect(processed.boundingBox.maxLatitude, 13.1000);
      expect(processed.boundingBox.minLongitude, 80.2700);
      expect(processed.boundingBox.maxLongitude, 80.2900);
      expect(processed.hasRenderableRoute, isTrue);
    });

    test('computeBoundingBox handles single point', () {
      final bbox = service.computeBoundingBox([_point(12.5, 77.5)]);
      expect(bbox.minLatitude, 12.5);
      expect(bbox.maxLatitude, 12.5);
      expect(bbox.minLongitude, 77.5);
      expect(bbox.maxLongitude, 77.5);
    });
  });
}
