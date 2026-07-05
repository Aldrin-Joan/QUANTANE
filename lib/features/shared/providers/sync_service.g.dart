// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncService)
final syncServiceProvider = SyncServiceProvider._();

final class SyncServiceProvider
    extends $NotifierProvider<SyncService, SyncProgress> {
  SyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  SyncService create() => SyncService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncProgress value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncProgress>(value),
    );
  }
}

String _$syncServiceHash() => r'cdea27e0f7eebedb18ef91095cf7b82fcfb8dfe1';

abstract class _$SyncService extends $Notifier<SyncProgress> {
  SyncProgress build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncProgress, SyncProgress>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncProgress, SyncProgress>,
              SyncProgress,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
