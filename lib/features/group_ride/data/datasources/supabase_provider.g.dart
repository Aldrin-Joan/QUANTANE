// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supabaseClient)
final supabaseClientProvider = SupabaseClientProvider._();

final class SupabaseClientProvider
    extends $FunctionalProvider<SupabaseClient, SupabaseClient, SupabaseClient>
    with $Provider<SupabaseClient> {
  SupabaseClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseClientHash();

  @$internal
  @override
  $ProviderElement<SupabaseClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseClient create(Ref ref) {
    return supabaseClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseClient>(value),
    );
  }
}

String _$supabaseClientHash() => r'2df5a38617329a3bb0a7e149189bea875722d7b8';

@ProviderFor(groupRideRepository)
final groupRideRepositoryProvider = GroupRideRepositoryProvider._();

final class GroupRideRepositoryProvider
    extends
        $FunctionalProvider<
          GroupRideRepository,
          GroupRideRepository,
          GroupRideRepository
        >
    with $Provider<GroupRideRepository> {
  GroupRideRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupRideRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupRideRepositoryHash();

  @$internal
  @override
  $ProviderElement<GroupRideRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GroupRideRepository create(Ref ref) {
    return groupRideRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupRideRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupRideRepository>(value),
    );
  }
}

String _$groupRideRepositoryHash() =>
    r'05db4311c4908062cf4968b0912d6c7bcc5fd4fc';

@ProviderFor(locationSharingRepository)
final locationSharingRepositoryProvider = LocationSharingRepositoryProvider._();

final class LocationSharingRepositoryProvider
    extends
        $FunctionalProvider<
          LocationSharingRepository,
          LocationSharingRepository,
          LocationSharingRepository
        >
    with $Provider<LocationSharingRepository> {
  LocationSharingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationSharingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationSharingRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocationSharingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationSharingRepository create(Ref ref) {
    return locationSharingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationSharingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationSharingRepository>(value),
    );
  }
}

String _$locationSharingRepositoryHash() =>
    r'ba0075e3c888b8ce7a3859ca87f4c8d12d3493fd';
