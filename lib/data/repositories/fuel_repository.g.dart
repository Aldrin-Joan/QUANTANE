// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fuelRepository)
final fuelRepositoryProvider = FuelRepositoryProvider._();

final class FuelRepositoryProvider
    extends $FunctionalProvider<FuelRepository, FuelRepository, FuelRepository>
    with $Provider<FuelRepository> {
  FuelRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fuelRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fuelRepositoryHash();

  @$internal
  @override
  $ProviderElement<FuelRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FuelRepository create(Ref ref) {
    return fuelRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FuelRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FuelRepository>(value),
    );
  }
}

String _$fuelRepositoryHash() => r'f2e2268c523a965cda98b96a9955600cbc0a046e';
