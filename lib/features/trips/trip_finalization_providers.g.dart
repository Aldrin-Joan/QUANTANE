// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_finalization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(routeSimplifier)
final routeSimplifierProvider = RouteSimplifierProvider._();

final class RouteSimplifierProvider
    extends
        $FunctionalProvider<RouteSimplifier, RouteSimplifier, RouteSimplifier>
    with $Provider<RouteSimplifier> {
  RouteSimplifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routeSimplifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routeSimplifierHash();

  @$internal
  @override
  $ProviderElement<RouteSimplifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RouteSimplifier create(Ref ref) {
    return routeSimplifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RouteSimplifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RouteSimplifier>(value),
    );
  }
}

String _$routeSimplifierHash() => r'ad9228ce5188b996f6469d682be4408ad5228f57';

@ProviderFor(routeProcessingService)
final routeProcessingServiceProvider = RouteProcessingServiceProvider._();

final class RouteProcessingServiceProvider
    extends
        $FunctionalProvider<
          RouteProcessingService,
          RouteProcessingService,
          RouteProcessingService
        >
    with $Provider<RouteProcessingService> {
  RouteProcessingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routeProcessingServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routeProcessingServiceHash();

  @$internal
  @override
  $ProviderElement<RouteProcessingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RouteProcessingService create(Ref ref) {
    return routeProcessingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RouteProcessingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RouteProcessingService>(value),
    );
  }
}

String _$routeProcessingServiceHash() =>
    r'c08f4db9f4ec6fd0d631cbbd3befbd462a23ac6c';

@ProviderFor(nominatimGeocodingService)
final nominatimGeocodingServiceProvider = NominatimGeocodingServiceProvider._();

final class NominatimGeocodingServiceProvider
    extends
        $FunctionalProvider<
          NominatimGeocodingService,
          NominatimGeocodingService,
          NominatimGeocodingService
        >
    with $Provider<NominatimGeocodingService> {
  NominatimGeocodingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nominatimGeocodingServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nominatimGeocodingServiceHash();

  @$internal
  @override
  $ProviderElement<NominatimGeocodingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NominatimGeocodingService create(Ref ref) {
    return nominatimGeocodingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NominatimGeocodingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NominatimGeocodingService>(value),
    );
  }
}

String _$nominatimGeocodingServiceHash() =>
    r'7847d75b52fc96572d1a5583c667e23b80337e5b';

@ProviderFor(routeSnapshotWriter)
final routeSnapshotWriterProvider = RouteSnapshotWriterProvider._();

final class RouteSnapshotWriterProvider
    extends
        $FunctionalProvider<
          RouteSnapshotWriter,
          RouteSnapshotWriter,
          RouteSnapshotWriter
        >
    with $Provider<RouteSnapshotWriter> {
  RouteSnapshotWriterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routeSnapshotWriterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routeSnapshotWriterHash();

  @$internal
  @override
  $ProviderElement<RouteSnapshotWriter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RouteSnapshotWriter create(Ref ref) {
    return routeSnapshotWriter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RouteSnapshotWriter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RouteSnapshotWriter>(value),
    );
  }
}

String _$routeSnapshotWriterHash() =>
    r'8c969e0f5d0ed8d6450182d2a8921db8bff5164b';

@ProviderFor(tripFinalizationService)
final tripFinalizationServiceProvider = TripFinalizationServiceProvider._();

final class TripFinalizationServiceProvider
    extends
        $FunctionalProvider<
          TripFinalizationService,
          TripFinalizationService,
          TripFinalizationService
        >
    with $Provider<TripFinalizationService> {
  TripFinalizationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripFinalizationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripFinalizationServiceHash();

  @$internal
  @override
  $ProviderElement<TripFinalizationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TripFinalizationService create(Ref ref) {
    return tripFinalizationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripFinalizationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripFinalizationService>(value),
    );
  }
}

String _$tripFinalizationServiceHash() =>
    r'a8891d94e5c209c1f4b8c9c317606cb7acb832fb';
