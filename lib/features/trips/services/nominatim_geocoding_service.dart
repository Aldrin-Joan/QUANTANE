import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quantane/data/repositories/geocoding_cache_repository.dart';

abstract class ReverseGeocodingService {
  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  });
}

class NominatimGeocodingService implements ReverseGeocodingService {
  static const String userAgent = 'Quantane/1.0 (vehicle trip tracker)';
  static const Duration requestTimeout = Duration(seconds: 10);
  static const Duration throttleDelay = Duration(seconds: 1);

  final GeocodingCacheRepository _cacheRepository;
  final http.Client _client;
  final Uri Function(double latitude, double longitude)
  _reverseGeocodeUriBuilder;
  DateTime? _lastRequestAt;

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
             '?format=jsonv2&lat=$latitude&lon=$longitude&zoom=14&addressdetails=1',
           ));

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
      final neighbourhood =
          address['neighbourhood'] ??
          address['suburb'] ??
          address['quarter'] ??
          address['hamlet'];
      final city =
          address['city'] ??
          address['town'] ??
          address['village'] ??
          address['county'];
      final state = address['state'];

      if (neighbourhood is String && city is String) {
        return '$neighbourhood, $city';
      }
      if (city is String && state is String) {
        return '$city, $state';
      }
      if (city is String) {
        return city;
      }
      if (neighbourhood is String) {
        return neighbourhood;
      }
    }

    final displayName = payload['display_name'];
    if (displayName is String && displayName.isNotEmpty) {
      final parts = displayName.split(',');
      if (parts.length >= 2) {
        return '${parts.first.trim()}, ${parts[1].trim()}';
      }
      return displayName.trim();
    }

    return null;
  }

  void dispose() {
    _client.close();
  }
}
