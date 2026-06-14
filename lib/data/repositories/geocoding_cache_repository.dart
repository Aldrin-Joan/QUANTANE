import 'package:drift/drift.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/database/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'geocoding_cache_repository.g.dart';

class GeocodingCacheRepository {
  final AppDatabase _db;

  GeocodingCacheRepository(this._db);

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
    final cacheKey = cacheKeyForCoordinate(
      latitude: latitude,
      longitude: longitude,
    );
    final row = await (_db.select(
      _db.geocodingCache,
    )..where((entry) => entry.cacheKey.equals(cacheKey))).getSingleOrNull();
    return row?.address;
  }

  Future<void> saveAddress({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final cacheKey = cacheKeyForCoordinate(
      latitude: latitude,
      longitude: longitude,
    );
    await _db.into(_db.geocodingCache).insert(
      GeocodingCacheCompanion.insert(
        cacheKey: cacheKey,
        address: address,
        cachedAt: DateTime.now().toIso8601String(),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
}

@Riverpod(keepAlive: true)
GeocodingCacheRepository geocodingCacheRepository(Ref ref) {
  return GeocodingCacheRepository(ref.watch(appDatabaseProvider));
}
