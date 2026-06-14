// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocoding_cache_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(geocodingCacheRepository)
final geocodingCacheRepositoryProvider = GeocodingCacheRepositoryProvider._();

final class GeocodingCacheRepositoryProvider
    extends
        $FunctionalProvider<
          GeocodingCacheRepository,
          GeocodingCacheRepository,
          GeocodingCacheRepository
        >
    with $Provider<GeocodingCacheRepository> {
  GeocodingCacheRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geocodingCacheRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geocodingCacheRepositoryHash();

  @$internal
  @override
  $ProviderElement<GeocodingCacheRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GeocodingCacheRepository create(Ref ref) {
    return geocodingCacheRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeocodingCacheRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeocodingCacheRepository>(value),
    );
  }
}

String _$geocodingCacheRepositoryHash() =>
    r'377681b81be790e507df1fb6cefdb2cfeae7393a';
