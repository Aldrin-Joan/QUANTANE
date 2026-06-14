import 'package:drift/drift.dart';

@DataClassName('GeocodingCacheEntry')
class GeocodingCache extends Table {
  TextColumn get cacheKey => text()();
  TextColumn get address => text()();
  TextColumn get cachedAt => text()();

  @override
  Set<Column> get primaryKey => {cacheKey};
}
