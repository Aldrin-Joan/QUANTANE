import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/repositories/geocoding_cache_repository.dart';

void main() {
  test('schema v2 exposes geocoding cache table', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final cacheRepository = GeocodingCacheRepository(database);

    await cacheRepository.saveAddress(
      latitude: 13.0827,
      longitude: 80.2707,
      address: 'Anna Nagar, Chennai',
    );

    final cached = await cacheRepository.getAddress(
      latitude: 13.0827,
      longitude: 80.2707,
    );

    expect(cached, 'Anna Nagar, Chennai');
    expect(database.schemaVersion, 2);
    await database.close();
  });
}
