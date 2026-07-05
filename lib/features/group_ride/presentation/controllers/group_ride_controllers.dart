// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:quantane/features/group_ride/data/datasources/supabase_provider.dart';
import 'package:quantane/features/group_ride/domain/entities/group_chat_message.dart';
import 'package:quantane/features/group_ride/domain/entities/group_ride.dart';
import 'package:quantane/features/group_ride/domain/entities/rider_telemetry.dart';
import 'package:quantane/features/shared/providers/auth_service.dart';

part 'group_ride_controllers.g.dart';

@riverpod
class ActiveGroupId extends _$ActiveGroupId {
  static const _storageKey = 'active_group_ride_id';

  @override
  String? build() {
    _loadPersisted();
    return null;
  }

  Future<void> _loadPersisted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(_storageKey);
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

@riverpod
Stream<List<GroupRideSession>> groupList(Ref ref) {
  final authState = ref.watch(authServiceProvider);
  final userId = authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return Stream.value(const []);

  final repo = ref.watch(groupRideRepositoryProvider);
  return repo.watchGroups(userId);
}

@riverpod
GroupRideSession? activeGroup(Ref ref) {
  final activeId = ref.watch(activeGroupIdProvider);
  if (activeId == null) return null;

  final groupsAsync = ref.watch(groupListProvider);
  return groupsAsync.whenOrNull(
    data: (list) {
      for (final g in list) {
        if (g.id == activeId) return g;
      }
      return null;
    },
  );
}

@riverpod
Stream<List<GroupChatMessage>> groupChatMessages(Ref ref, String groupId) {
  final repo = ref.watch(groupChatRepositoryProvider);
  return repo.watchMessages(groupId);
}

@riverpod
Stream<List<String>> groupPresence(Ref ref, String groupId) {
  final repo = ref.watch(locationSharingRepositoryProvider);
  return repo.presenceStream;
}

@riverpod
Stream<RiderTelemetry> groupTelemetry(Ref ref, String groupId) {
  final repo = ref.watch(locationSharingRepositoryProvider);
  return repo.telemetryStream;
}
