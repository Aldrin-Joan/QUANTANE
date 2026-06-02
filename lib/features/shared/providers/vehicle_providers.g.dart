// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeVehicleDetails)
final activeVehicleDetailsProvider = ActiveVehicleDetailsProvider._();

final class ActiveVehicleDetailsProvider
    extends
        $FunctionalProvider<AsyncValue<Vehicle?>, Vehicle?, FutureOr<Vehicle?>>
    with $FutureModifier<Vehicle?>, $FutureProvider<Vehicle?> {
  ActiveVehicleDetailsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeVehicleDetailsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeVehicleDetailsHash();

  @$internal
  @override
  $FutureProviderElement<Vehicle?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Vehicle?> create(Ref ref) {
    return activeVehicleDetails(ref);
  }
}

String _$activeVehicleDetailsHash() =>
    r'53ae8d5971d5374b65daaae5c3108ad19ba95631';
