// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_vehicle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveVehicle)
final activeVehicleProvider = ActiveVehicleProvider._();

final class ActiveVehicleProvider
    extends $NotifierProvider<ActiveVehicle, String?> {
  ActiveVehicleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeVehicleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeVehicleHash();

  @$internal
  @override
  ActiveVehicle create() => ActiveVehicle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$activeVehicleHash() => r'ad52c2429182c939e5d6b336f425d3ccabe72edf';

abstract class _$ActiveVehicle extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
