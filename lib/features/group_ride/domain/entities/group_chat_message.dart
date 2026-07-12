enum MessageType {
  text,
  image,
  file,
  system;

  static MessageType fromString(String value) {
    return MessageType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MessageType.text,
    );
  }
}

enum MessageStatus {
  pending,
  sent,
  delivered,
  read;

  static MessageStatus fromString(String value) {
    return MessageStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MessageStatus.sent,
    );
  }
}

class GroupChatMessage {
  const GroupChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.messageType = MessageType.text,
    required this.createdAt,
    this.status = MessageStatus.sent,
    required this.offlineId,
    this.metadata,
  });

  factory GroupChatMessage.fromJson(Map<String, dynamic> json) {
    return GroupChatMessage(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String? ?? 'Rider',
      content: json['content'] as String,
      messageType: MessageType.fromString(json['messageType'] as String? ?? 'text'),
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      status: MessageStatus.fromString(json['status'] as String? ?? 'sent'),
      offlineId: json['offlineId'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String content;
  final MessageType messageType;
  final DateTime createdAt;
  final MessageStatus status;
  final String offlineId;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'messageType': messageType.name,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'offlineId': offlineId,
      if (metadata != null) 'metadata': metadata,
    };
  }

  GroupChatMessage copyWith({
    String? id,
    String? groupId,
    String? senderId,
    String? senderName,
    String? content,
    MessageType? messageType,
    DateTime? createdAt,
    MessageStatus? status,
    String? offlineId,
    Map<String, dynamic>? metadata,
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
      metadata: metadata ?? this.metadata,
    );
  }
}
