// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:quantane/data/repositories/geocoding_cache_repository.dart';

abstract class ReverseGeocodingService {
  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  });
}

class NominatimGeocodingService implements ReverseGeocodingService {
  NominatimGeocodingService({
    required GeocodingCacheRepository cacheRepository,
    http.Client? client,
    Uri Function(double latitude, double longitude)? reverseGeocodeUriBuilder,
  }) : _cacheRepository = cacheRepository,
       _client = client ?? http.Client(),
       _reverseGeocodeUriBuilder =
           reverseGeocodeUriBuilder ??
           ((latitude, longitude) => Uri.parse(
             'https://nominatim.openstreetmap.org/reverse'
             '?format=jsonv2&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1',
           ));
  static const String userAgent = 'Quantane/1.0 (vehicle trip tracker)';
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration throttleDelay = Duration(seconds: 1);

  final GeocodingCacheRepository _cacheRepository;
  final http.Client _client;
  final Uri Function(double latitude, double longitude)
  _reverseGeocodeUriBuilder;
  DateTime? _lastRequestAt;

  @override
  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final cached = await _cacheRepository.getAddress(
      latitude: latitude,
      longitude: longitude,
    );
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    await _respectThrottle();

    try {
      final response = await _client
          .get(
            _reverseGeocodeUriBuilder(latitude, longitude),
            headers: const {'User-Agent': userAgent},
          )
          .timeout(requestTimeout);

      if (response.statusCode != 200) {
        return null;
      }

      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final address = _formatAddress(payload);
      if (address == null || address.isEmpty) {
        return null;
      }

      await _cacheRepository.saveAddress(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      return address;
    } catch (_) {
      return null;
    }
  }

  Future<void> _respectThrottle() async {
    final lastRequestAt = _lastRequestAt;
    if (lastRequestAt == null) {
      _lastRequestAt = DateTime.now();
      return;
    }

    final elapsed = DateTime.now().difference(lastRequestAt);
    if (elapsed < throttleDelay) {
      await Future<void>.delayed(throttleDelay - elapsed);
    }
    _lastRequestAt = DateTime.now();
  }

  String? _formatAddress(Map<String, dynamic> payload) {
    final address = payload['address'];
    if (address is Map<String, dynamic>) {
      final parts = <String>[];
      final seen = <String>{};

      void addPart(dynamic value) {
        if (value == null) return;
        final trimmed = value.toString().trim();
        if (trimmed.isEmpty) return;
        final lowercase = trimmed.toLowerCase();
        if (!seen.contains(lowercase)) {
          parts.add(trimmed);
          seen.add(lowercase);
        }
      }

      // 1. Building / House details
      final houseNumber =
          address['house_number'] ??
          address['building'] ??
          address['public_building'] ??
          address['office'];
      addPart(houseNumber);

      // 2. Road / Street details
      final road =
          address['road'] ??
          address['street'] ??
          address['footway'] ??
          address['path'] ??
          address['pedestrian'];
      addPart(road);

      // 3. Local area / Neighbourhood / Suburb / Wards
      addPart(address['neighbourhood']);
      addPart(address['residential']);
      addPart(address['suburb']);
      addPart(address['quarter']);
      addPart(address['ward']);
      addPart(address['subdistrict']);

      // 4. District / County / City District (avoid adding if it duplicates city)
      final city =
          address['city'] ??
          address['town'] ??
          address['village'] ??
          address['municipality'];
      final county =
          address['county'] ??
          address['district'] ??
          address['city_district'] ??
          address['state_district'];

      if (county != null) {
        final countyStr = county.toString().trim();
        final cityStr = city?.toString().trim();
        if (cityStr == null ||
            !countyStr.toLowerCase().contains(cityStr.toLowerCase())) {
          addPart(countyStr);
        }
      }

      // 5. City / Town
      addPart(city);

      // 6. State & Postcode
      final state =
          address['state'] ?? address['province'] ?? address['region'];
      final postcode = address['postcode'];
      if (state != null && postcode != null) {
        addPart('$state $postcode');
      } else {
        addPart(state);
        addPart(postcode);
      }

      // 7. Country
      final country = address['country'];
      addPart(country);

      if (parts.isNotEmpty) {
        return parts.join(', ');
      }
    }

    final displayName = payload['display_name'];
    if (displayName is String && displayName.isNotEmpty) {
      return displayName.trim();
    }

    return null;
  }

  void dispose() {
    _client.close();
  }
}
