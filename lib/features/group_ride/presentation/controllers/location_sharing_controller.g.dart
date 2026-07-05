// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_sharing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocationSharingController)
final locationSharingControllerProvider = LocationSharingControllerProvider._();

final class LocationSharingControllerProvider
    extends $NotifierProvider<LocationSharingController, void> {
  LocationSharingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationSharingControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationSharingControllerHash();

  @$internal
  @override
  LocationSharingController create() => LocationSharingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$locationSharingControllerHash() =>
    r'81e07ec66f133fcce36636c0126ebf074b43bbac';

abstract class _$LocationSharingController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
