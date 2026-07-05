class GroupMember {
  const GroupMember({
    required this.userId,
    required this.displayName,
    required this.role,
    required this.joinedAt,
    this.isOnline = false,
    this.avatarUrl,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String).toUtc(),
      isOnline: json['isOnline'] as bool? ?? false,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  final String userId;
  final String displayName;
  final String role; // 'owner' | 'admin' | 'member'
  final DateTime joinedAt;
  final bool isOnline;
  final String? avatarUrl;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'role': role,
      'joinedAt': joinedAt.toIso8601String(),
      'isOnline': isOnline,
      'avatarUrl': avatarUrl,
    };
  }

  GroupMember copyWith({
    String? userId,
    String? displayName,
    String? role,
    DateTime? joinedAt,
    bool? isOnline,
    String? avatarUrl,
  }) {
    return GroupMember(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      isOnline: isOnline ?? this.isOnline,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
