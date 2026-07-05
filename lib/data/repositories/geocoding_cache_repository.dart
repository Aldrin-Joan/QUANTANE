// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'geocoding_cache_repository.g.dart';

class GeocodingCacheRepository {
  GeocodingCacheRepository() {
    _initFuture = _initCache();
  }
  final Map<String, String> _memoryCache = {};
  File? _cacheFile;
  bool _initialized = false;
  Future<void>? _initFuture;

  Future<void> _initCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _cacheFile = File('${directory.path}/geocoding_cache.json');
      if (await _cacheFile!.exists()) {
        final content = await _cacheFile!.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        json.forEach((key, value) {
          _memoryCache[key] = value.toString();
        });
      }
    } catch (_) {}
    _initialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized && _initFuture != null) {
      await _initFuture;
    }
  }

  static String cacheKeyForCoordinate({
    required double latitude,
    required double longitude,
  }) {
    return '${latitude.toStringAsFixed(4)}:${longitude.toStringAsFixed(4)}';
  }

  Future<String?> getAddress({
    required double latitude,
    required double longitude,
  }) async {
    await _ensureInitialized();
    final cacheKey = cacheKeyForCoordinate(
      latitude: latitude,
      longitude: longitude,
    );
    return _memoryCache[cacheKey];
  }

  Future<void> saveAddress({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    await _ensureInitialized();
    final cacheKey = cacheKeyForCoordinate(
      latitude: latitude,
      longitude: longitude,
    );
    _memoryCache[cacheKey] = address;
    try {
      if (_cacheFile != null) {
        await _cacheFile!.writeAsString(jsonEncode(_memoryCache));
      }
    } catch (_) {}
  }
}

@Riverpod(keepAlive: true)
GeocodingCacheRepository geocodingCacheRepository(Ref ref) {
  return GeocodingCacheRepository();
}
