// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:quantane/features/group_ride/domain/entities/group_chat_message.dart';

void main() {
  // This is a placeholder for a more comprehensive integration test
  // Since we cannot easily mock the entire Supabase Realtime/Postgres flow here without complex setup,
  // we will focus on the logic parts we can verify.

  test('GroupChatMessage serialization', () {
    final msg = GroupChatMessage(
      id: '1',
      groupId: 'g1',
      senderId: 'u1',
      senderName: 'User 1',
      content: 'Hello',
      createdAt: DateTime.now().toUtc(),
      offlineId: 'off1',
    );

    final json = msg.toJson();
    final fromJson = GroupChatMessage.fromJson(json);

    expect(fromJson.id, msg.id);
    expect(fromJson.content, msg.content);
    expect(fromJson.messageType, MessageType.text);
  });
}
