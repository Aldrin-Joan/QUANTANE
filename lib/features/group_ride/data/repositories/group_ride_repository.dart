// Dart imports:
import 'dart:async';
import 'dart:math';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:quantane/features/group_ride/domain/entities/group_member.dart';
import 'package:quantane/features/group_ride/domain/entities/group_ride.dart';

class GroupRideRepository {
  GroupRideRepository(this._client);

  final SupabaseClient _client;

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  Future<GroupRideSession> createGroup(String name, String userId) async {
    final inviteCode = _generateInviteCode();

    // 1. Insert Group
    final groupData = await _client.from('groups').insert({
      'name': name,
      'owner_id': userId,
      'invite_code': inviteCode,
      'encryption_salt': _generateInviteCode(), // simplified salt for coding structure
    }).select().single();

    final groupId = groupData['id'] as String;

    // 2. Add creator as Owner in group_members
    await _client.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
      'role': 'owner',
    });

    return GroupRideSession(
      id: groupId,
      name: name,
      ownerId: userId,
      inviteCode: inviteCode,
      createdAt: DateTime.parse(groupData['created_at'] as String),
      members: [
        GroupMember(
          userId: userId,
          displayName: 'Owner', // UI will fetch actual displayName
          role: 'owner',
          joinedAt: DateTime.now(),
          isOnline: true,
        )
      ],
    );
  }

  Future<void> deleteGroup(String groupId) async {
    // Soft delete by setting deleted_at (or hard delete if preferred, here soft delete)
    await _client.from('groups').update({
      'deleted_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', groupId);
  }

  Future<GroupRideSession> joinGroup(String inviteCode, String userId) async {
    // 1. Find group by invite code
    final groupData = await _client
        .from('groups')
        .select()
        .eq('invite_code', inviteCode.toUpperCase().trim())
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (groupData == null) {
      throw Exception('Group not found or invite code invalid.');
    }

    final groupId = groupData['id'] as String;

    // 2. Check if already member
    final existingMember = await _client
        .from('group_members')
        .select()
        .eq('group_id', groupId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existingMember == null) {
      // 3. Add to members
      await _client.from('group_members').insert({
        'group_id': groupId,
        'user_id': userId,
        'role': 'member',
      });
    }

    final members = await getGroupMembers(groupId);

    return GroupRideSession(
      id: groupId,
      name: groupData['name'] as String,
      ownerId: groupData['owner_id'] as String,
      inviteCode: inviteCode,
      createdAt: DateTime.parse(groupData['created_at'] as String),
      isPrivate: groupData['is_private'] as bool? ?? false,
      members: members,
    );
  }

  Future<void> leaveGroup(String groupId, String userId) async {
    await _client
        .from('group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId);
  }

  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    final List<dynamic> response = await _client
        .from('group_members')
        .select()
        .eq('group_id', groupId);

    return response.map((data) {
      return GroupMember(
        userId: data['user_id'] as String,
        displayName: (data['user_id'] as String).substring(0, min(6, (data['user_id'] as String).length)), // fallback identifier
        role: data['role'] as String? ?? 'member',
        joinedAt: DateTime.parse(data['joined_at'] as String),
        isOnline: false,
      );
    }).toList();
  }

  Stream<List<GroupRideSession>> watchGroups(String userId) {
    // Watches the group_members table and maps it to group list
    // In supabase_flutter, we can query it and listen to realtime updates.
    // For production-grade, we fetch and merge realtime streams.
    
    final controller = StreamController<List<GroupRideSession>>();

    Future<void> fetchAndEmit() async {
      try {
        final List<dynamic> memberRelations = await _client
            .from('group_members')
            .select('group_id, groups(*)')
            .eq('user_id', userId);

        final groups = <GroupRideSession>[];
        for (final item in memberRelations) {
          final gMap = item['groups'] as Map<String, dynamic>?;
          if (gMap != null && gMap['deleted_at'] == null) {
            final groupId = gMap['id'] as String;
            final members = await getGroupMembers(groupId);
            groups.add(GroupRideSession(
              id: groupId,
              name: gMap['name'] as String,
              ownerId: gMap['owner_id'] as String,
              inviteCode: gMap['invite_code'] as String,
              createdAt: DateTime.parse(gMap['created_at'] as String),
              isPrivate: gMap['is_private'] as bool? ?? false,
              members: members,
            ));
          }
        }
        if (!controller.isClosed) {
          controller.add(groups);
        }
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }

    fetchAndEmit();

    // Subscribe to realtime database changes on group_members table for the user
    final subscription = _client
        .channel('public:group_members')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'group_members',
          callback: (payload) {
            fetchAndEmit();
          },
        )
        .subscribe();

    controller.onCancel = () {
      subscription.unsubscribe();
      controller.close();
    };

    return controller.stream;
  }
}
