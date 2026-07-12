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
    _init();
  }

  final SupabaseClient _client;
  final _uuid = const Uuid();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = true;
  bool _isSyncing = false;
  
  // Controllers for broadcasting updates
  final _pendingMessagesController = StreamController<void>.broadcast();
  final _messageUpdatesController = StreamController<String>.broadcast();

  void _init() {
    _initConnectivityListener();
    // Initial sync attempt
    _syncPendingMessages();
  }

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
    if (!_isOnline || _isSyncing) return;
    _isSyncing = true;

    try {
      final pending = await _loadPendingMessages();
      if (pending.isEmpty) return;

      final remaining = List<GroupChatMessage>.from(pending);
      final syncedGroupIds = <String>{};

      for (final msg in pending) {
        try {
          final dbPayload = {
            'group_id': msg.groupId,
            'sender_id': msg.senderId,
            'content': msg.content,
            'message_type': msg.messageType.name,
            'offline_id': msg.offlineId,
            'created_at': msg.createdAt.toIso8601String(),
          };

          if (msg.messageType == MessageType.text || msg.messageType == MessageType.system) {
            dbPayload['content'] = jsonEncode({
              'text': msg.content,
              'sender_name': msg.senderName,
              if (msg.metadata != null) 'metadata': msg.metadata,
            });
          }

          await _client.from('group_messages').insert(dbPayload);

          // Broadcast the message immediately to the room channel for active users
          try {
            final broadcastChan = _client.channel(
              'room:group_chat:${msg.groupId}',
            );
            await broadcastChan.sendBroadcastMessage(
              event: 'new_message',
              payload: msg.copyWith(status: MessageStatus.sent).toJson(),
            );
          } catch (_) {}

          remaining.removeWhere((item) => item.offlineId == msg.offlineId);
          syncedGroupIds.add(msg.groupId);
        } catch (e) {
          final errorStr = e.toString();
          // If unique constraint violation, remove it from queue as it is already on server
          if (errorStr.contains('duplicate key') ||
              errorStr.contains('409') ||
              errorStr.contains('23505')) {
            remaining.removeWhere((item) => item.offlineId == msg.offlineId);
            syncedGroupIds.add(msg.groupId);
          } else {
            // General connection failure or other error, stop syncing this batch
            break;
          }
        }
      }
      
      await _savePendingMessages(remaining);
      for (final groupId in syncedGroupIds) {
        _messageUpdatesController.add(groupId);
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<GroupChatMessage> sendMessage({
    required String groupId,
    required String senderId,
    required String senderName,
    required String content,
    MessageType messageType = MessageType.text,
    Map<String, dynamic>? metadata,
  }) async {
    final offlineId = _uuid.v4();
    final message = GroupChatMessage(
      id: offlineId, // local temporary ID
      groupId: groupId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      messageType: messageType,
      createdAt: DateTime.now().toUtc(),
      status: MessageStatus.pending,
      offlineId: offlineId,
      metadata: metadata,
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

  Future<GroupChatMessage> sendSystemMessage({
    required String groupId,
    required String senderId,
    required String content,
    Map<String, dynamic>? metadata,
  }) async {
    return sendMessage(
      groupId: groupId,
      senderId: senderId,
      senderName: 'System',
      content: content,
      messageType: MessageType.system,
      metadata: metadata,
    );
  }

  Future<List<GroupChatMessage>> getMessages(String groupId) async {
    try {
      final response = await _client
          .from('group_messages')
          .select()
          .eq('group_id', groupId)
          .order('created_at', ascending: true);

      final dataList = response as List<dynamic>;

      return dataList.map((data) {
        final rawContent = data['content'] as String;
        var contentText = rawContent;
        var senderName = 'Rider';
        Map<String, dynamic>? metadata;
        
        try {
          if (rawContent.startsWith('{')) {
            final decoded = jsonDecode(rawContent) as Map<String, dynamic>;
            if (decoded.containsKey('text')) {
              contentText = decoded['text'] as String;
              senderName = decoded['sender_name'] as String? ?? 'Rider';
              metadata = decoded['metadata'] as Map<String, dynamic>?;
            }
          }
        } catch (_) {}

        return GroupChatMessage(
          id: data['id']?.toString() ?? data['offline_id'] as String,
          groupId: data['group_id'] as String,
          senderId: data['sender_id'] as String,
          senderName: senderName,
          content: contentText,
          messageType: MessageType.fromString(data['message_type'] as String? ?? 'text'),
          createdAt: DateTime.parse(data['created_at'] as String),
          status: MessageStatus.sent,
          offlineId: data['offline_id'] as String,
          metadata: metadata,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<GroupChatMessage>> watchMessages(String groupId) {
    final controller = StreamController<List<GroupChatMessage>>();
    var serverMessages = <GroupChatMessage>[];
    final broadcastMessages = <String, GroupChatMessage>{};

    Future<void> emitMerged() async {
      if (controller.isClosed) return;

      final pending = await _loadPendingMessages();
      final pendingForGroup = pending
          .where((m) => m.groupId == groupId)
          .toList();

      final allMessages = <String, GroupChatMessage>{};
      
      // 1. Start with server messages
      for (final m in serverMessages) {
        allMessages[m.offlineId] = m;
      }
      
      // 2. Layer broadcast messages (might be more recent than last server fetch)
      for (final m in broadcastMessages.values) {
        allMessages[m.offlineId] = m;
      }
      
      // 3. Layer pending messages (most authoritative for local user)
      for (final m in pendingForGroup) {
        allMessages[m.offlineId] = m;
      }

      final merged = allMessages.values.toList();
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

    // Initial fetch
    refreshServer();

    // Listen to local changes
    final pendingSub = _pendingMessagesController.stream.listen((_) => emitMerged());

    // Listen to sync completions
    final syncSub = _messageUpdatesController.stream.listen((id) {
      if (id == groupId) refreshServer();
    });

    // Postgres Realtime
    final supabaseSub = _client
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
          callback: (payload) => refreshServer(),
        )
        .subscribe();

    // Broadcast Realtime
    final broadcastChan = _client.channel('room:group_chat:$groupId');
    broadcastChan
        .onBroadcast(
          event: 'new_message',
          callback: (payload) {
            try {
              final msg = GroupChatMessage.fromJson(payload);
              broadcastMessages[msg.offlineId] = msg;
              emitMerged();
            } catch (_) {}
          },
        )
        .subscribe();

    controller.onCancel = () {
      pendingSub.cancel();
      syncSub.cancel();
      supabaseSub.unsubscribe();
      broadcastChan.unsubscribe();
      _client.removeChannel(broadcastChan);
      controller.close();
    };

    return controller.stream;
  }
}
