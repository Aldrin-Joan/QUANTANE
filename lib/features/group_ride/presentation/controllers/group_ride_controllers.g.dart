// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_ride_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveGroupId)
final activeGroupIdProvider = ActiveGroupIdProvider._();

final class ActiveGroupIdProvider
    extends $NotifierProvider<ActiveGroupId, String?> {
  ActiveGroupIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeGroupIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeGroupIdHash();

  @$internal
  @override
  ActiveGroupId create() => ActiveGroupId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$activeGroupIdHash() => r'9cf6feaeb02fed069ecd00b69c3a1a987fd8ddf5';

abstract class _$ActiveGroupId extends $Notifier<String?> {
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

@ProviderFor(TransientActiveGroup)
final transientActiveGroupProvider = TransientActiveGroupProvider._();

final class TransientActiveGroupProvider
    extends $NotifierProvider<TransientActiveGroup, GroupRideSession?> {
  TransientActiveGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transientActiveGroupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transientActiveGroupHash();

  @$internal
  @override
  TransientActiveGroup create() => TransientActiveGroup();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupRideSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupRideSession?>(value),
    );
  }
}

String _$transientActiveGroupHash() =>
    r'a2bf9ff4a00cc54fba8d03dddb5e238066ec3401';

abstract class _$TransientActiveGroup extends $Notifier<GroupRideSession?> {
  GroupRideSession? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GroupRideSession?, GroupRideSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GroupRideSession?, GroupRideSession?>,
              GroupRideSession?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(groupList)
final groupListProvider = GroupListProvider._();

final class GroupListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroupRideSession>>,
          List<GroupRideSession>,
          Stream<List<GroupRideSession>>
        >
    with
        $FutureModifier<List<GroupRideSession>>,
        $StreamProvider<List<GroupRideSession>> {
  GroupListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupListHash();

  @$internal
  @override
  $StreamProviderElement<List<GroupRideSession>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GroupRideSession>> create(Ref ref) {
    return groupList(ref);
  }
}

String _$groupListHash() => r'a9c6fa813bc402631ee792b72bcadc949c3f4696';

@ProviderFor(activeGroup)
final activeGroupProvider = ActiveGroupProvider._();

final class ActiveGroupProvider
    extends
        $FunctionalProvider<
          GroupRideSession?,
          GroupRideSession?,
          GroupRideSession?
        >
    with $Provider<GroupRideSession?> {
  ActiveGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeGroupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeGroupHash();

  @$internal
  @override
  $ProviderElement<GroupRideSession?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GroupRideSession? create(Ref ref) {
    return activeGroup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupRideSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupRideSession?>(value),
    );
  }
}

String _$activeGroupHash() => r'f28dd4ce08e98ef0567486e3ebb59c0bca4f5fd3';

@ProviderFor(groupPresence)
final groupPresenceProvider = GroupPresenceFamily._();

final class GroupPresenceProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Map<String, dynamic>>>,
          Map<String, Map<String, dynamic>>,
          Stream<Map<String, Map<String, dynamic>>>
        >
    with
        $FutureModifier<Map<String, Map<String, dynamic>>>,
        $StreamProvider<Map<String, Map<String, dynamic>>> {
  GroupPresenceProvider._({
    required GroupPresenceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupPresenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupPresenceHash();

  @override
  String toString() {
    return r'groupPresenceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as String;
    return groupPresence(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupPresenceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupPresenceHash() => r'8b908afa9ee1b362f4e696ceda23e4208ee93d70';

final class GroupPresenceFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Map<String, Map<String, dynamic>>>,
          String
        > {
  GroupPresenceFamily._()
    : super(
        retry: null,
        name: r'groupPresenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupPresenceProvider call(String groupId) =>
      GroupPresenceProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupPresenceProvider';
}

@ProviderFor(groupTelemetry)
final groupTelemetryProvider = GroupTelemetryFamily._();

final class GroupTelemetryProvider
    extends
        $FunctionalProvider<
          AsyncValue<RiderTelemetry>,
          RiderTelemetry,
          Stream<RiderTelemetry>
        >
    with $FutureModifier<RiderTelemetry>, $StreamProvider<RiderTelemetry> {
  GroupTelemetryProvider._({
    required GroupTelemetryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupTelemetryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupTelemetryHash();

  @override
  String toString() {
    return r'groupTelemetryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<RiderTelemetry> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RiderTelemetry> create(Ref ref) {
    final argument = this.argument as String;
    return groupTelemetry(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupTelemetryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupTelemetryHash() => r'e41bcc7f21678710b63c085d05db83da858d73d7';

final class GroupTelemetryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<RiderTelemetry>, String> {
  GroupTelemetryFamily._()
    : super(
        retry: null,
        name: r'groupTelemetryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupTelemetryProvider call(String groupId) =>
      GroupTelemetryProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupTelemetryProvider';
}

@ProviderFor(GroupLobbyTab)
final groupLobbyTabProvider = GroupLobbyTabProvider._();

final class GroupLobbyTabProvider
    extends $NotifierProvider<GroupLobbyTab, int> {
  GroupLobbyTabProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupLobbyTabProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupLobbyTabHash();

  @$internal
  @override
  GroupLobbyTab create() => GroupLobbyTab();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$groupLobbyTabHash() => r'5e4f4d6cba728dbf2a96c04d40dfe3d7e97a9422';

abstract class _$GroupLobbyTab extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MapNavigationTarget)
final mapNavigationTargetProvider = MapNavigationTargetProvider._();

final class MapNavigationTargetProvider
    extends $NotifierProvider<MapNavigationTarget, LatLng?> {
  MapNavigationTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapNavigationTargetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapNavigationTargetHash();

  @$internal
  @override
  MapNavigationTarget create() => MapNavigationTarget();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LatLng? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LatLng?>(value),
    );
  }
}

String _$mapNavigationTargetHash() =>
    r'377dc02de72aa159c3d6756758f2611c400fb277';

abstract class _$MapNavigationTarget extends $Notifier<LatLng?> {
  LatLng? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LatLng?, LatLng?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LatLng?, LatLng?>,
              LatLng?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(groupMemberNames)
final groupMemberNamesProvider = GroupMemberNamesFamily._();

final class GroupMemberNamesProvider
    extends
        $FunctionalProvider<
          Map<String, String>,
          Map<String, String>,
          Map<String, String>
        >
    with $Provider<Map<String, String>> {
  GroupMemberNamesProvider._({
    required GroupMemberNamesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupMemberNamesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupMemberNamesHash();

  @override
  String toString() {
    return r'groupMemberNamesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, String> create(Ref ref) {
    final argument = this.argument as String;
    return groupMemberNames(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMemberNamesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupMemberNamesHash() => r'6d949a6bb52b9504f9c1797db8e71ff433bdafe0';

final class GroupMemberNamesFamily extends $Family
    with $FunctionalFamilyOverride<Map<String, String>, String> {
  GroupMemberNamesFamily._()
    : super(
        retry: null,
        name: r'groupMemberNamesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupMemberNamesProvider call(String groupId) =>
      GroupMemberNamesProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupMemberNamesProvider';
}

@ProviderFor(GroupTelemetries)
final groupTelemetriesProvider = GroupTelemetriesFamily._();

final class GroupTelemetriesProvider
    extends $NotifierProvider<GroupTelemetries, Map<String, RiderTelemetry>> {
  GroupTelemetriesProvider._({
    required GroupTelemetriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupTelemetriesProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupTelemetriesHash();

  @override
  String toString() {
    return r'groupTelemetriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GroupTelemetries create() => GroupTelemetries();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, RiderTelemetry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, RiderTelemetry>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GroupTelemetriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupTelemetriesHash() => r'b43f14d9754d64b86b086a3ad4832853aed37b82';

final class GroupTelemetriesFamily extends $Family
    with
        $ClassFamilyOverride<
          GroupTelemetries,
          Map<String, RiderTelemetry>,
          Map<String, RiderTelemetry>,
          Map<String, RiderTelemetry>,
          String
        > {
  GroupTelemetriesFamily._()
    : super(
        retry: null,
        name: r'groupTelemetriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GroupTelemetriesProvider call(String groupId) =>
      GroupTelemetriesProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupTelemetriesProvider';
}

abstract class _$GroupTelemetries
    extends $Notifier<Map<String, RiderTelemetry>> {
  late final _$args = ref.$arg as String;
  String get groupId => _$args;

  Map<String, RiderTelemetry> build(String groupId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, RiderTelemetry>, Map<String, RiderTelemetry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, RiderTelemetry>,
                Map<String, RiderTelemetry>
              >,
              Map<String, RiderTelemetry>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
