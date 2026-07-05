// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Project imports:
import 'package:quantane/data/repositories/geocoding_cache_repository.dart';
import 'package:quantane/features/trips/services/nominatim_geocoding_service.dart';

void main() {
  group('NominatimGeocodingService', () {
    late GeocodingCacheRepository cacheRepository;

    setUp(() {
      cacheRepository = GeocodingCacheRepository();
    });

    test('parses neighbourhood and city from response', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'display_name': 'Anna Nagar, Chennai, Tamil Nadu, India',
            'address': {
              'neighbourhood': 'Anna Nagar',
              'city': 'Chennai',
              'state': 'Tamil Nadu',
              'country': 'India',
            },
          }),
          200,
        );
      });

      final service = NominatimGeocodingService(
        cacheRepository: cacheRepository,
        client: client,
      );

      final address = await service.reverseGeocode(
        latitude: 13.0827,
        longitude: 80.2707,
      );

      expect(address, 'Anna Nagar, Chennai, Tamil Nadu, India');
      service.dispose();
    });

    test('uses cache and avoids duplicate HTTP requests', () async {
      var requestCount = 0;
      final client = MockClient((request) async {
        requestCount++;
        return http.Response(
          jsonEncode({
            'display_name': 'T Nagar, Chennai, Tamil Nadu, India',
            'address': {
              'suburb': 'T Nagar',
              'city': 'Chennai',
              'state': 'Tamil Nadu',
              'country': 'India',
            },
          }),
          200,
        );
      });

      final service = NominatimGeocodingService(
        cacheRepository: cacheRepository,
        client: client,
      );

      final first = await service.reverseGeocode(
        latitude: 13.0400,
        longitude: 80.2400,
      );
      final second = await service.reverseGeocode(
        latitude: 13.0400,
        longitude: 80.2400,
      );

      expect(first, 'T Nagar, Chennai, Tamil Nadu, India');
      expect(second, 'T Nagar, Chennai, Tamil Nadu, India');
      expect(requestCount, 1);
      service.dispose();
    });

    test('returns null when request fails', () async {
      final client = MockClient((request) async {
        return http.Response('error', 500);
      });

      final service = NominatimGeocodingService(
        cacheRepository: cacheRepository,
        client: client,
      );

      final address = await service.reverseGeocode(latitude: 10, longitude: 20);
      expect(address, isNull);
      service.dispose();
    });
  });
}
