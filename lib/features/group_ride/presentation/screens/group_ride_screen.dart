// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/features/group_ride/data/datasources/supabase_provider.dart';
import 'package:quantane/features/group_ride/domain/entities/group_ride.dart';
import 'package:quantane/features/group_ride/presentation/controllers/group_ride_controllers.dart';
import 'package:quantane/features/group_ride/presentation/controllers/location_sharing_controller.dart';
import 'package:quantane/features/group_ride/presentation/controllers/voice_controller.dart';
import 'package:quantane/features/group_ride/presentation/screens/chat_view.dart';
import 'package:quantane/features/group_ride/presentation/screens/live_map_view.dart';
import 'package:quantane/features/shared/providers/auth_service.dart';
import 'package:quantane/features/shared/widgets/quantane_card.dart';

class GroupRideScreen extends ConsumerWidget {
  const GroupRideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGroup = ref.watch(activeGroupProvider);

    return Scaffold(
      body: activeGroup == null
          ? const _WelcomeLobby()
          : _GroupLobby(group: activeGroup),
    );
  }
}

class _WelcomeLobby extends ConsumerStatefulWidget {
  const _WelcomeLobby();

  @override
  ConsumerState<_WelcomeLobby> createState() => _WelcomeLobbyState();
}

class _WelcomeLobbyState extends ConsumerState<_WelcomeLobby> {
  final _groupNameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    final name = _groupNameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    final authState = ref.read(authServiceProvider);
    final userId = authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to create a group.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final repo = ref.read(groupRideRepositoryProvider);
      final group = await repo.createGroup(name, userId);
      ref.read(activeGroupIdProvider.notifier).select(group.id);
      ref.read(locationSharingControllerProvider.notifier).startSharing(group.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create group: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _joinGroup() async {
    final code = _inviteCodeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);
    final authState = ref.read(authServiceProvider);
    final userId = authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to join a group.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final repo = ref.read(groupRideRepositoryProvider);
      final group = await repo.joinGroup(code, userId);
      ref.read(activeGroupIdProvider.notifier).select(group.id);
      ref.read(locationSharingControllerProvider.notifier).startSharing(group.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join group: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.users, size: 64, color: AppColors.primaryColor),
              ),
              const SizedBox(height: 32),
              const Text(
                'Group Ride',
                style: TextStyle(fontSize: 28, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Coordinate routes, track speeds, share locations, and voice chat with your crew in real-time.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 48),
              QuantaneCard(
                variant: QuantaneCardVariant.flat,
                child: Column(
                  children: [
                    const Text(
                      'Create a New Crew',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _groupNameController,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Enter group name...',
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.bgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _createGroup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Create Group'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              QuantaneCard(
                variant: QuantaneCardVariant.flat,
                child: Column(
                  children: [
                    const Text(
                      'Join via Invite Code',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _inviteCodeController,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Enter 6-digit Invite Code...',
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.bgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _joinGroup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Join Group'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupLobby extends ConsumerStatefulWidget {
  const _GroupLobby({required this.group});

  final GroupRideSession group;

  @override
  ConsumerState<_GroupLobby> createState() => _GroupLobbyState();
}

class _GroupLobbyState extends ConsumerState<_GroupLobby> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _leaveGroup() async {
    final authState = ref.read(authServiceProvider);
    final userId = authState.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final repo = ref.read(groupRideRepositoryProvider);
    ref.read(locationSharingControllerProvider.notifier).stopSharing();
    ref.read(voiceControllerProvider.notifier).leaveVoice();
    
    try {
      await repo.leaveGroup(widget.group.id, userId);
      ref.read(activeGroupIdProvider.notifier).select(null);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryColor,
          tabs: const [
            Tab(icon: Icon(LucideIcons.map), text: 'Map'),
            Tab(icon: Icon(LucideIcons.message_square), text: 'Chat'),
            Tab(icon: Icon(LucideIcons.phone), text: 'Voice'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(), // Map needs gestures
            children: [
              LiveMapView(group: widget.group),
              ChatView(group: widget.group),
              _VoiceTab(group: widget.group),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 54, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.group.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.group.inviteCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invite code copied to clipboard!'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'ID: ${widget.group.inviteCode}',
                        style: const TextStyle(fontSize: 12, color: AppColors.accentColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.copy, size: 10, color: AppColors.accentColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _leaveGroup,
            icon: const Icon(LucideIcons.log_out, color: AppColors.dangerColor),
            tooltip: 'Leave Group',
          ),
        ],
      ),
    );
  }
}

class _VoiceTab extends ConsumerWidget {
  const _VoiceTab({required this.group});

  final GroupRideSession group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceState = ref.watch(voiceControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: voiceState.isConnected
                    ? AppColors.accentColor.withValues(alpha: 0.1)
                    : AppColors.textSecondary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                voiceState.isConnected ? LucideIcons.phone : LucideIcons.phone,
                size: 64,
                color: voiceState.isConnected ? AppColors.accentColor : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              voiceState.isConnected ? 'Voice Connected' : 'Voice Disconnected',
              style: const TextStyle(fontSize: 20, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              voiceState.isConnected
                  ? 'Talk with other riders in the crew. Low-latency WebRTC routing active.'
                  : 'Join the voice channel to discuss navigation and riding conditions.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 48),
            if (!voiceState.isConnected)
              ElevatedButton.icon(
                onPressed: voiceState.isConnecting
                    ? null
                    : () => ref.read(voiceControllerProvider.notifier).joinVoice(group.id),
                icon: voiceState.isConnecting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(LucideIcons.phone),
                label: Text(voiceState.isConnecting ? 'Connecting...' : 'Join Voice Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              )
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => ref.read(voiceControllerProvider.notifier).toggleMute(),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: voiceState.isMuted
                            ? AppColors.dangerColor.withValues(alpha: 0.2)
                            : AppColors.cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: voiceState.isMuted ? AppColors.dangerColor : Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Icon(
                        voiceState.isMuted ? LucideIcons.mic_off : LucideIcons.mic,
                        color: voiceState.isMuted ? AppColors.dangerColor : Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref.read(voiceControllerProvider.notifier).leaveVoice(),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.dangerColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.phone,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (voiceState.error != null) ...[
              const SizedBox(height: 16),
              Text(
                voiceState.error!,
                style: const TextStyle(color: AppColors.dangerColor, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
