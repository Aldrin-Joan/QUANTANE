// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:quantane/features/trips/services/route_simplifier.dart';
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
  group('RouteSimplifier', () {
    test('returns original points when there are two or fewer', () {
      final points = [_point(13.08, 80.27), _point(13.09, 80.28)];
      final simplified = RouteSimplifier.simplifySync(points);
      expect(simplified.length, 2);
      expect(simplified.first.latitude, 13.08);
      expect(simplified.last.latitude, 13.09);
    });

    test('reduces collinear points while preserving endpoints', () {
      final points = [
        _point(13.0800, 80.2700),
        _point(13.0805, 80.2705),
        _point(13.0810, 80.2710),
        _point(13.0815, 80.2715),
        _point(13.0820, 80.2720),
      ];

      final simplified = RouteSimplifier.simplifySync(points, epsilonMeters: 5);
      expect(simplified.length, lessThan(points.length));
      expect(simplified.first.latitude, points.first.latitude);
      expect(simplified.last.latitude, points.last.latitude);
    });

    test('handles large routes without throwing', () async {
      final points = List<TripPoint>.generate(
        5000,
        (index) => _point(
          13.08 + (index * 0.00001) + (index.isEven ? 0.000002 : 0),
          80.27 + (index * 0.00001) + (index.isOdd ? 0.000002 : 0),
        ),
      );

      final simplified = await RouteSimplifier().simplify(points);
      expect(simplified.length, lessThan(points.length));
      expect(simplified.length, greaterThanOrEqualTo(2));
      expect(simplified.first.latitude, points.first.latitude);
      expect(simplified.last.latitude, points.last.latitude);
    });
  });
}
