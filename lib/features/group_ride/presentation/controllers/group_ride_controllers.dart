// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:quantane/features/group_ride/data/datasources/supabase_provider.dart';
import 'package:quantane/features/group_ride/domain/entities/group_ride.dart';
import 'package:quantane/features/group_ride/domain/entities/rider_telemetry.dart';
import 'package:quantane/features/shared/providers/auth_service.dart';

part 'group_ride_controllers.g.dart';

@Riverpod(keepAlive: true)
class ActiveGroupId extends _$ActiveGroupId {
  static const _storageKey = 'active_group_ride_id';

  @override
  String? build() {
    // Initial build returns null immediately, then we load from storage.
    // We use a microtask or a simple future to update the state after the build is complete.
    _loadPersisted();
    return null;
  }

  Future<void> _loadPersisted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(_storageKey);
      // Only update if the provider is still active and the value is actually different.
      if (id != null && state == null) {
        state = id;
      }
    } catch (_) {}
  }

  Future<void> select(String? id) async {
    if (state != id) {
      state = id;
      try {
        final prefs = await SharedPreferences.getInstance();
        if (id == null) {
          await prefs.remove(_storageKey);
        } else {
          await prefs.setString(_storageKey, id);
        }
      } catch (_) {}
    }
  }
}

@Riverpod(keepAlive: true)
class TransientActiveGroup extends _$TransientActiveGroup {
  @override
  GroupRideSession? build() => null;

  void setTransientGroup(GroupRideSession group) {
    if (state != group) {
      state = group;
    }
  }

  void clearTransientGroup() {
    if (state != null) {
      state = null;
    }
  }
}

@Riverpod(keepAlive: true)
Stream<List<GroupRideSession>> groupList(Ref ref) {
  final authState = ref.watch(authServiceProvider);
  final userId = authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return Stream.value(const []);

  final repo = ref.watch(groupRideRepositoryProvider);
  return repo.watchGroups(userId);
}

@Riverpod(keepAlive: true)
GroupRideSession? activeGroup(Ref ref) {
  final activeId = ref.watch(activeGroupIdProvider);
  if (activeId == null) return null;

  // 1. Check transient state first (optimistic/immediate after creation)
  final transient = ref.watch(transientActiveGroupProvider);
  if (transient != null && transient.id == activeId) {
    return transient;
  }

  // 2. Check the synced list
  final groupsAsync = ref.watch(groupListProvider);
  return groupsAsync.whenOrNull(
    data: (list) {
      for (final g in list) {
        if (g.id == activeId) {
          // Once found in synced list, we can clear transient if it matches
          if (transient?.id == activeId) {
            Future.microtask(
              () => ref
                  .read(transientActiveGroupProvider.notifier)
                  .clearTransientGroup(),
            );
          }
          return g;
        }
      }
      return null;
    },
  );
}

@riverpod
Stream<Map<String, Map<String, dynamic>>> groupPresence(
  Ref ref,
  String groupId,
) {
  final repo = ref.watch(locationSharingRepositoryProvider);
  return repo.presenceStream;
}

@riverpod
Stream<RiderTelemetry> groupTelemetry(Ref ref, String groupId) {
  final repo = ref.watch(locationSharingRepositoryProvider);
  return repo.telemetryStream;
}

@Riverpod(keepAlive: true)
class GroupLobbyTab extends _$GroupLobbyTab {
  @override
  int build() => 0;

  int get tabIndex => state;

  void setTabIndex(int index) {
    if (state != index) {
      state = index;
    }
  }
}

@Riverpod(keepAlive: true)
class MapNavigationTarget extends _$MapNavigationTarget {
  @override
  LatLng? build() => null;

  LatLng? get target => state;

  void setTarget(LatLng? target) {
    if (state != target) {
      state = target;
    }
  }
}

@riverpod
Map<String, String> groupMemberNames(Ref ref, String groupId) {
  final names = <String, String>{};

  // 1. Resolve from Presence (Most accurate for live names)
  final presenceAsync = ref.watch(groupPresenceProvider(groupId));
  presenceAsync.whenData((presenceMap) {
    for (final entry in presenceMap.entries) {
      final payload = entry.value;
      final displayName = payload['display_name'] as String?;
      if (displayName != null && displayName.isNotEmpty) {
        names[entry.key] = displayName;
      }
    }
  });

  // 2. Resolve from Telemetry (Fallback)
  final telemetries = ref.watch(groupTelemetriesProvider(groupId));
  for (final telemetry in telemetries.values) {
    if (telemetry.displayName != null && telemetry.displayName!.isNotEmpty) {
      names[telemetry.riderId] = telemetry.displayName!;
    }
  }

  // 3. Resolve from Static Member List (Initial/Offline fallback)
  final group = ref.watch(activeGroupProvider);
  if (group != null && group.id == groupId) {
    for (final member in group.members) {
      if (member.displayName.isNotEmpty &&
          !names.containsKey(member.userId) &&
          member.displayName != 'Owner') {
        names[member.userId] = member.displayName;
      }
    }
  }

  return names;
}

@Riverpod(keepAlive: true)
class GroupTelemetries extends _$GroupTelemetries {
  @override
  Map<String, RiderTelemetry> build(String groupId) {
    ref.listen<AsyncValue<RiderTelemetry>>(groupTelemetryProvider(groupId), (
      previous,
      next,
    ) {
      final telemetry = next.value;
      if (telemetry != null) {
        state = Map<String, RiderTelemetry>.from(state)
          ..[telemetry.riderId] = telemetry;
      }
    });
    return const {};
  }
}
