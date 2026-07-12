// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/features/group_ride/data/datasources/supabase_provider.dart';
import 'package:quantane/features/group_ride/domain/entities/group_chat_message.dart';
import 'package:quantane/features/group_ride/domain/entities/group_ride.dart';
import 'package:quantane/features/group_ride/presentation/controllers/group_ride_controllers.dart';
import 'package:quantane/features/group_ride/presentation/widgets/chat/message_widgets.dart';
import 'package:quantane/features/shared/providers/auth_service.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({required this.group, super.key});

  final GroupRideSession group;

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final authState = ref.read(authServiceProvider);
    final userId =
        authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _messageController.clear();

    final chatRepo = ref.read(groupChatRepositoryProvider);
    final displayName =
        authState.user?.displayName ??
        'Rider ${userId.substring(0, min(4, userId.length))}';

    try {
      await chatRepo.sendMessage(
        groupId: widget.group.id,
        senderId: userId,
        senderName: displayName,
        content: text,
      );
      _scrollToBottom();
    } catch (_) {}
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(groupChatMessagesProvider(widget.group.id));
    final presenceAsync = ref.watch(groupPresenceProvider(widget.group.id));
    final resolvedNames = ref.watch(groupMemberNamesProvider(widget.group.id));
    final authState = ref.watch(authServiceProvider);
    final currentUserId =
        authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;

    return Column(
      children: [
        presenceAsync.when(
          data: (onlineIds) => _buildMembersHeader(onlineIds, resolvedNames),
          loading: () => const SizedBox.shrink(),
          error: (_, stackTrace) => const SizedBox.shrink(),
        ),
        Expanded(
          child: messagesAsync.when(
            data: (messages) {
              if (messages.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.message_square,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No messages yet.\nSay hello to start the ride chat!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              // Scroll to bottom whenever messages are loaded
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _scrollToBottom(),
              );

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  if (message.messageType == MessageType.system) {
                    return SystemMessageBubble(message: message);
                  }

                  final isMe = message.senderId == currentUserId;

                  // Message grouping logic
                  var showSenderName = true;
                  if (index > 0) {
                    final prevMessage = messages[index - 1];
                    if (prevMessage.messageType != MessageType.system &&
                        prevMessage.senderId == message.senderId) {
                      showSenderName = false;
                    }
                  }

                  return UserMessageBubble(
                    message: message,
                    isMe: isMe,
                    showSenderName: showSenderName,
                    onTap: () {
                      if (!isMe) {
                        final telemetries = ref.read(
                          groupTelemetriesProvider(widget.group.id),
                        );
                        final telemetry = telemetries[message.senderId];
                        if (telemetry != null) {
                          ref
                              .read(mapNavigationTargetProvider.notifier)
                              .target = LatLng(
                            telemetry.latitude,
                            telemetry.longitude,
                          );
                          ref.read(groupLobbyTabProvider.notifier).tabIndex =
                              0; // Switch to Map
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Rider location not available yet'),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(
                'Failed to load messages: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
        _buildInputRow(),
      ],
    );
  }

  Widget _buildMembersHeader(
    List<String> onlineUserIds,
    Map<String, String> resolvedNames,
  ) {
    final members = widget.group.members;
    if (members.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        border: Border(
          bottom: BorderSide(color: AppColors.dividerColor),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          final name = resolvedNames[member.userId] ?? member.displayName;
          final isOnline = onlineUserIds.contains(member.userId);

          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        name.isNotEmpty
                            ? name.substring(0, 1).toUpperCase()
                            : 'R',
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.cardColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.bgColor,
        border: Border(
          top: BorderSide(color: AppColors.dividerColor),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
