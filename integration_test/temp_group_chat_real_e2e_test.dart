import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class _Participant {
  _Participant({
    required this.label,
    required this.userId,
    required this.client,
  });

  final String label;
  final String userId;
  final SupabaseClient client;
}

class _DeliverySample {
  _DeliverySample({
    required this.messageId,
    required this.senderLabel,
    required this.sentAt,
    required this.firstSeenAt,
    required this.allSeenAt,
  });

  final String messageId;
  final String senderLabel;
  final DateTime sentAt;
  final DateTime firstSeenAt;
  final DateTime allSeenAt;

  Duration get firstReceiptLatency => firstSeenAt.difference(sentAt);
  Duration get fullFanOutLatency => allSeenAt.difference(sentAt);
}

class _ReplySample {
  _ReplySample({
    required this.originalSender,
    required this.replier,
    required this.messageId,
    required this.sentAt,
    required this.seenAt,
  });

  final String originalSender;
  final String replier;
  final String messageId;
  final DateTime sentAt;
  final DateTime seenAt;

  Duration get replyLatency => seenAt.difference(sentAt);
}

Future<({String url, String key})> _loadSupabaseConfig() async {
  String? url;
  String? key;

  try {
    await dotenv.load(fileName: '.env');
    url = dotenv.maybeGet('SUPERBASE_URL') ?? dotenv.maybeGet('SUPABASE_URL');
    key = dotenv.maybeGet('SUPERBASE_KEY') ?? dotenv.maybeGet('SUPABASE_KEY');
  } catch (_) {}

  url ??=
      Platform.environment['SUPERBASE_URL'] ??
      Platform.environment['SUPABASE_URL'];
  key ??=
      Platform.environment['SUPERBASE_KEY'] ??
      Platform.environment['SUPABASE_KEY'];

  if (url == null || url.isEmpty || key == null || key.isEmpty) {
    throw StateError(
      'Supabase config not found. Set SUPERBASE_URL/SUPERBASE_KEY or SUPABASE_URL/SUPABASE_KEY.',
    );
  }

  return (url: url, key: key);
}

SupabaseClient _newClient(String url, String key) {
  return SupabaseClient(url, key);
}

String _inviteCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = math.Random();
  return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
}

Future<Map<String, dynamic>> _createGroup({
  required SupabaseClient client,
  required String ownerId,
  required String label,
}) async {
  final inviteCode = _inviteCode();
  final response = await client
      .from('groups')
      .insert({
        'name': label,
        'owner_id': ownerId,
        'invite_code': inviteCode,
        'encryption_salt': 'probe-salt-${const Uuid().v4()}',
      })
      .select()
      .single();

  final group = response;
  await client.from('group_members').insert({
    'group_id': group['id'],
    'user_id': ownerId,
    'role': 'owner',
  });

  return group;
}

Future<void> _addMember({
  required SupabaseClient client,
  required String groupId,
  required String userId,
}) async {
  await client.from('group_members').insert({
    'group_id': groupId,
    'user_id': userId,
    'role': 'member',
  });
}

Future<Map<String, dynamic>> _sendMessage({
  required SupabaseClient client,
  required String groupId,
  required String senderId,
  required String senderLabel,
  required String text,
}) async {
  final payload = {
    'group_id': groupId,
    'sender_id': senderId,
    'content': jsonEncode({
      'text': text,
      'sender_name': senderLabel,
    }),
    'message_type': 'text',
    'offline_id': const Uuid().v4(),
    'created_at': DateTime.now().toUtc().toIso8601String(),
  };

  final response = await client
      .from('group_messages')
      .insert(payload)
      .select()
      .single();
  return response;
}

Future<DateTime> _waitForMessageVisible({
  required SupabaseClient client,
  required String groupId,
  required String messageId,
  Duration timeout = const Duration(seconds: 60),
  Duration pollInterval = const Duration(milliseconds: 300),
}) async {
  final deadline = DateTime.now().toUtc().add(timeout);

  while (true) {
    final rows = await client
        .from('group_messages')
        .select('id')
        .eq(
          'group_id',
          groupId,
        );
    final match = (rows as List).any(
      (row) => row['id']?.toString() == messageId,
    );
    if (match) {
      return DateTime.now().toUtc();
    }

    if (DateTime.now().toUtc().isAfter(deadline)) {
      throw TimeoutException(
        'Timed out waiting for $messageId to become visible.',
      );
    }

    await Future<void>.delayed(pollInterval);
  }
}

Future<void> _cleanupGroup({
  required SupabaseClient client,
  required String groupId,
}) async {
  try {
    await client.from('group_messages').delete().eq('group_id', groupId);
  } catch (_) {}
  try {
    await client.from('group_members').delete().eq('group_id', groupId);
  } catch (_) {}
  try {
    await client.from('groups').delete().eq('id', groupId);
  } catch (_) {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test(
    'temp real-backend 4-person group chat probe',
    () async {
      final config = await _loadSupabaseConfig();
      final clients = List.generate(
        4,
        (index) => _Participant(
          label: 'P${index + 1}',
          userId: 'probe-user-${index + 1}-${const Uuid().v4()}',
          client: _newClient(config.url, config.key),
        ),
      );

      final createdGroups = <String>[];
      final deliverySamples = <_DeliverySample>[];
      final replySamples = <_ReplySample>[];

      try {
        final group = await _createGroup(
          client: clients.first.client,
          ownerId: clients.first.userId,
          label: 'probe-group-${const Uuid().v4().substring(0, 8)}',
        );
        final groupId = group['id'].toString();
        createdGroups.add(groupId);

        for (final participant in clients.skip(1)) {
          await _addMember(
            client: participant.client,
            groupId: groupId,
            userId: participant.userId,
          );
        }

        final allParticipants = clients.toList(growable: false);

        for (final sender in allParticipants) {
          final sentAt = DateTime.now().toUtc();

          final inserted = await _sendMessage(
            client: sender.client,
            groupId: groupId,
            senderId: sender.userId,
            senderLabel: sender.label,
            text: 'probe text from ${sender.label}',
          );

          final messageId = inserted['id'].toString();

          final receiptTimes = await Future.wait(
            allParticipants
                .map(
                  (participant) => _waitForMessageVisible(
                    client: participant.client,
                    groupId: groupId,
                    messageId: messageId,
                  ),
                )
                .toList(),
          );

          receiptTimes.sort();

          final deliverySample = _DeliverySample(
            messageId: messageId,
            senderLabel: sender.label,
            sentAt: sentAt,
            firstSeenAt: receiptTimes.first,
            allSeenAt: receiptTimes.last,
          );
          deliverySamples.add(deliverySample);

          expect(
            deliverySample.fullFanOutLatency.inSeconds,
            lessThan(45),
            reason:
                'Message ${deliverySample.messageId} from ${deliverySample.senderLabel} did not reach all 4 participants quickly enough.',
          );

          for (final replier in allParticipants.where((p) => p != sender)) {
            final replySentAt = DateTime.now().toUtc();
            final reply = await _sendMessage(
              client: replier.client,
              groupId: groupId,
              senderId: replier.userId,
              senderLabel: replier.label,
              text: 'reply from ${replier.label} to ${sender.label}',
            );

            final replySeenAt = await _waitForMessageVisible(
              client: sender.client,
              groupId: groupId,
              messageId: reply['id'].toString(),
            );

            replySamples.add(
              _ReplySample(
                originalSender: sender.label,
                replier: replier.label,
                messageId: reply['id'].toString(),
                sentAt: replySentAt,
                seenAt: replySeenAt,
              ),
            );

            expect(
              replySeenAt.difference(replySentAt).inSeconds,
              lessThan(45),
              reason:
                  'Reply from ${replier.label} to ${sender.label} was not observed by the sender in time.',
            );
          }
        }

        debugPrint('--- Group chat probe results ---');
        for (final sample in deliverySamples) {
          debugPrint(
            'message=${sample.messageId} sender=${sample.senderLabel} first=${sample.firstReceiptLatency.inMilliseconds}ms full=${sample.fullFanOutLatency.inMilliseconds}ms',
          );
        }
        for (final sample in replySamples) {
          debugPrint(
            'reply=${sample.messageId} original=${sample.originalSender} replier=${sample.replier} latency=${sample.replyLatency.inMilliseconds}ms',
          );
        }
        debugPrint('--- End probe results ---');

        expect(deliverySamples.length, 4);
        expect(replySamples.length, 12);
      } finally {
        for (final groupId in createdGroups) {
          await _cleanupGroup(client: clients.first.client, groupId: groupId);
        }
        for (final participant in clients) {
          unawaited(participant.client.auth.signOut());
        }
      }
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
