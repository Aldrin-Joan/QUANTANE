// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tripRepository)
final tripRepositoryProvider = TripRepositoryProvider._();

final class TripRepositoryProvider
    extends $FunctionalProvider<TripRepository, TripRepository, TripRepository>
    with $Provider<TripRepository> {
  TripRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tripRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tripRepositoryHash();

  @$internal
  @override
  $ProviderElement<TripRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TripRepository create(Ref ref) {
    return tripRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TripRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TripRepository>(value),
    );
  }
}

String _$tripRepositoryHash() => r'4c713bfcbbb91666f362ed7ac45989eb8aa52db4';

@ProviderFor(tripById)
final tripByIdProvider = TripByIdFamily._();

final class TripByIdProvider
    extends $FunctionalProvider<AsyncValue<Trip?>, Trip?, FutureOr<Trip?>>
    with $FutureModifier<Trip?>, $FutureProvider<Trip?> {
  TripByIdProvider._({
    required TripByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tripByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tripByIdHash();

  @override
  String toString() {
    return r'tripByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Trip?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Trip?> create(Ref ref) {
    final argument = this.argument as String;
    return tripById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TripByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tripByIdHash() => r'2c8b178f633918d171e53e1c316cc1662a71a4e8';

final class TripByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Trip?>, String> {
  TripByIdFamily._()
    : super(
        retry: null,
        name: r'tripByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TripByIdProvider call(String tripId) =>
      TripByIdProvider._(argument: tripId, from: this);

  @override
  String toString() => r'tripByIdProvider';
}
