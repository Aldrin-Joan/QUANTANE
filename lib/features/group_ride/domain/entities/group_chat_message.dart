class GroupChatMessage {
  const GroupChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.messageType = 'text', // 'text' | 'image' | 'file'
    required this.createdAt,
    this.status = 'sent', // 'pending' | 'sent' | 'delivered' | 'read'
    required this.offlineId,
  });

  factory GroupChatMessage.fromJson(Map<String, dynamic> json) {
    return GroupChatMessage(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String? ?? 'Rider',
      content: json['content'] as String,
      messageType: json['messageType'] as String? ?? 'text',
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      status: json['status'] as String? ?? 'sent',
      offlineId: json['offlineId'] as String,
    );
  }

  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String content;
  final String messageType;
  final DateTime createdAt;
  final String status;
  final String offlineId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'messageType': messageType,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'offlineId': offlineId,
    };
  }

  GroupChatMessage copyWith({
    String? id,
    String? groupId,
    String? senderId,
    String? senderName,
    String? content,
    String? messageType,
    DateTime? createdAt,
    String? status,
    String? offlineId,
  }) {
    return GroupChatMessage(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      offlineId: offlineId ?? this.offlineId,
    );
  }
}
