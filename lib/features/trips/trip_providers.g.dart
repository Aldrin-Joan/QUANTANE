// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tripHistory)
final tripHistoryProvider = TripHistoryProvider._();

final class TripHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Trip>>,
          List<Trip>,
          Stream<List<Trip>>
        >
    with $FutureModifier<List<Trip>>, $StreamProvider<List<Trip>> {
  TripHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<Trip>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Trip>> create(Ref ref) {
    return tripHistory(ref);
  }
}

String _$tripHistoryHash() => r'846280c199ec1a8f1fc4e33693f2bcf75ce617f2';

@ProviderFor(TripTracking)
final tripTrackingProvider = TripTrackingProvider._();

final class TripTrackingProvider
    extends $NotifierProvider<TripTracking, TripTrackingState> {
  TripTrackingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripTrackingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripTrackingHash();

  @$internal
  @override
  TripTracking create() => TripTracking();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripTrackingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripTrackingState>(value),
    );
  }
}

String _$tripTrackingHash() => r'0feee1aa828226bb9dcb016219582cf27bf67f2c';

abstract class _$TripTracking extends $Notifier<TripTrackingState> {
  TripTrackingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TripTrackingState, TripTrackingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TripTrackingState, TripTrackingState>,
              TripTrackingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
