// Project imports:
import 'package:quantane/features/group_ride/domain/entities/group_member.dart';

class GroupRideSession {
  const GroupRideSession({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.inviteCode,
    this.isPrivate = false,
    required this.createdAt,
    this.members = const [],
  });

  factory GroupRideSession.fromJson(Map<String, dynamic> json) {
    return GroupRideSession(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      inviteCode: json['inviteCode'] as String,
      isPrivate: json['isPrivate'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      members: (json['members'] as List<dynamic>?)
              ?.map((m) => GroupMember.fromJson(m as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  final String id;
  final String name;
  final String ownerId;
  final String inviteCode;
  final bool isPrivate;
  final DateTime createdAt;
  final List<GroupMember> members;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'inviteCode': inviteCode,
      'isPrivate': isPrivate,
      'createdAt': createdAt.toIso8601String(),
      'members': members.map((m) => m.toJson()).toList(),
    };
  }

  GroupRideSession copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? inviteCode,
    bool? isPrivate,
    DateTime? createdAt,
    List<GroupMember>? members,
  }) {
    return GroupRideSession(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      inviteCode: inviteCode ?? this.inviteCode,
      isPrivate: isPrivate ?? this.isPrivate,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
    );
  }
}
