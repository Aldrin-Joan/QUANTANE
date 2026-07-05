// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:quantane/features/group_ride/domain/entities/group_chat_message.dart';

class GroupChatRepository {
  GroupChatRepository(this._client) {
    _initConnectivityListener();
  }

  final SupabaseClient _client;
  final _uuid = const Uuid();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = true;
  final _pendingMessagesController = StreamController<void>.broadcast();
  final _messageUpdatesController = StreamController<String>.broadcast();

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final wasOnline = _isOnline;
      _isOnline =
          results.isNotEmpty && results.first != ConnectivityResult.none;
      if (_isOnline && !wasOnline) {
        _syncPendingMessages();
      }
    });
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _pendingMessagesController.close();
    _messageUpdatesController.close();
  }

  Future<File> _getOutboxFile() async {
    final docDir = await getApplicationDocumentsDirectory();
    final outboxFile = File('${docDir.path}/group_chat_outbox.json');
    if (!await outboxFile.exists()) {
      await outboxFile.writeAsString(jsonEncode([]));
    }
    return outboxFile;
  }

  Future<List<GroupChatMessage>> _loadPendingMessages() async {
    try {
      final file = await _getOutboxFile();
      final content = await file.readAsString();
      final list = jsonDecode(content) as List<dynamic>;
      return list
          .map(
            (json) => GroupChatMessage.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _savePendingMessages(List<GroupChatMessage> messages) async {
    try {
      final file = await _getOutboxFile();
      final content = jsonEncode(messages.map((m) => m.toJson()).toList());
      await file.writeAsString(content);
      _pendingMessagesController.add(null);
    } catch (_) {}
  }

  Future<void> _syncPendingMessages() async {
    if (!_isOnline) return;

    final pending = await _loadPendingMessages();
    if (pending.isEmpty) return;

    final remaining = List<GroupChatMessage>.from(pending);
    final syncedGroupIds = <String>{};

    for (final msg in pending) {
      try {
        await _client.from('group_messages').insert({
          'group_id': msg.groupId,
          'sender_id': msg.senderId,
          'content': msg.content,
          'message_type': msg.messageType,
          'offline_id': msg.offlineId,
          'created_at': msg.createdAt.toIso8601String(),
        });
        remaining.removeWhere((item) => item.offlineId == msg.offlineId);
        syncedGroupIds.add(msg.groupId);
      } catch (e) {
        // If unique constraint violation, remove it from queue as it is already on server
        if (e.toString().contains('duplicate key') ||
            e.toString().contains('409') ||
            e.toString().contains('23505')) {
          remaining.removeWhere((item) => item.offlineId == msg.offlineId);
          syncedGroupIds.add(msg.groupId);
        } else {
          // General connection failure, pause sync
          break;
        }
      }
    }
    await _savePendingMessages(remaining);
    for (final groupId in syncedGroupIds) {
      _messageUpdatesController.add(groupId);
    }
  }

  Future<GroupChatMessage> sendMessage(
    String groupId,
    String senderId,
    String senderName,
    String content,
  ) async {
    final offlineId = _uuid.v4();
    final message = GroupChatMessage(
      id: offlineId, // local temporary ID
      groupId: groupId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      createdAt: DateTime.now().toUtc(),
      status: 'pending',
      offlineId: offlineId,
    );

    // 1. Save to local outbox cache
    final pending = await _loadPendingMessages();
    pending.add(message);
    await _savePendingMessages(pending);

    // 2. Attempt sync in background
    if (_isOnline) {
      unawaited(_syncPendingMessages());
    }

    return message;
  }

  Future<List<GroupChatMessage>> getMessages(String groupId) async {
    final List<dynamic> response = await _client
        .from('group_messages')
        .select()
        .eq('group_id', groupId)
        .order('created_at', ascending: true);

    return response.map((data) {
      return GroupChatMessage(
        id: data['id'] as String,
        groupId: data['group_id'] as String,
        senderId: data['sender_id'] as String,
        senderName:
            'Rider', // Fallback, will show dynamic in UI or join with profile
        content: data['content'] as String,
        messageType: data['message_type'] as String? ?? 'text',
        createdAt: DateTime.parse(data['created_at'] as String),
        status: 'sent',
        offlineId: data['offline_id'] as String,
      );
    }).toList();
  }

  Stream<List<GroupChatMessage>> watchMessages(String groupId) {
    final controller = StreamController<List<GroupChatMessage>>();
    var serverMessages = <GroupChatMessage>[];

    Future<void> emitMerged() async {
      final pending = await _loadPendingMessages();
      final pendingForGroup = pending
          .where((m) => m.groupId == groupId)
          .toList();
      final merged = [...serverMessages, ...pendingForGroup];
      // Sort by creation time
      merged.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      if (!controller.isClosed) {
        controller.add(merged);
      }
    }

    Future<void> refreshServer() async {
      try {
        serverMessages = await getMessages(groupId);
        await emitMerged();
      } catch (e) {
        if (!controller.isClosed) {
          controller.addError(e);
        }
      }
    }

    refreshServer();

    // Listen to local changes (outbox queue updates)
    final pendingSubscription = _pendingMessagesController.stream.listen((_) {
      emitMerged();
    });

    // Listen to message updates/syncs
    final syncSubscription = _messageUpdatesController.stream.listen((id) {
      if (id == groupId) {
        refreshServer();
      }
    });

    // Listen to realtime Postgres changes in group_messages table
    final supabaseSubscription = _client
        .channel('public:group_messages:$groupId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'group_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'group_id',
            value: groupId,
          ),
          callback: (payload) {
            refreshServer();
          },
        )
        .subscribe();

    controller.onCancel = () {
      pendingSubscription.cancel();
      syncSubscription.cancel();
      supabaseSubscription.unsubscribe();
      controller.close();
    };

    return controller.stream;
  }
}
