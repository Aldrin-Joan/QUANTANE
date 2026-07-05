import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/data/database/database_provider.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/features/shared/providers/auth_service.dart';
import 'package:quantane/features/shared/providers/sync_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authServiceProvider);
    final syncProgress = ref.watch(syncServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSection(context, 'Vehicle', [
            ListTile(
              leading: const Icon(LucideIcons.car),
              title: const Text('Manage Vehicles'),
              trailing: const Icon(LucideIcons.chevron_right, size: 20),
              onTap: () => context.push('/vehicles'),
            ),
          ]),
          _buildSyncSection(context, ref, authState, syncProgress),
          _buildSection(context, 'Preferences', [
            const ListTile(
              leading: Icon(LucideIcons.indian_rupee),
              title: Text('Currency'),
              trailing: Text(
                'INR (₹)',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const ListTile(
              leading: Icon(LucideIcons.map_pin),
              title: Text('Distance Unit'),
              trailing: Text(
                'Kilometers (KM)',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ]),
          _buildSection(context, 'Data', [
            ListTile(
              leading: const Icon(LucideIcons.download),
              title: const Text('Export Data'),
              onTap: () {
                // Implementation for share_plus
              },
            ),
            ListTile(
              leading: const Icon(
                LucideIcons.trash_2,
                color: AppColors.dangerColor,
              ),
              title: const Text(
                'Clear All Data',
                style: TextStyle(color: AppColors.dangerColor),
              ),
              onTap: () => _showClearDataDialog(context, ref),
            ),
          ]),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Quantane v1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncSection(
    BuildContext context,
    WidgetRef ref,
    AuthState auth,
    SyncProgress syncProgress,
  ) {
    return _buildSection(context, 'Cloud Backup & Sync', [
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: AppColors.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!auth.isSyncEnabled) ...[
                Row(
                  children: [
                    const Icon(
                      LucideIcons.cloud_off,
                      size: 28,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cloud Sync Disabled',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Backup vehicle history, trips, and logs securely to the cloud.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            _showLoginSignUpDialog(context, ref, isLogin: true),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryColor),
                        ),
                        child: const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            ref.read(authServiceProvider.notifier).enableSync(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Enable Sync'),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    _getSyncIcon(syncProgress.status),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getSyncStatusText(syncProgress.status),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Last synced: ${syncProgress.lastSyncTime ?? 'Never'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (syncProgress.pendingOpsCount > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${syncProgress.pendingOpsCount} change(s) pending sync',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.warningColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: syncProgress.status == SyncStateStatus.syncing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            )
                          : const Icon(
                              LucideIcons.refresh_cw,
                              size: 20,
                              color: AppColors.textPrimary,
                            ),
                      onPressed: syncProgress.status == SyncStateStatus.syncing
                          ? null
                          : () => ref
                                .read(syncServiceProvider.notifier)
                                .syncNow(),
                    ),
                  ],
                ),
                const Divider(height: 24, color: AppColors.dividerColor),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.user,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.user?.isAnonymous == true
                                ? 'Account Mode: Guest'
                                : 'Account Mode: Secured',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            auth.user?.isAnonymous == true
                                ? 'Syncing to a transient guest ID. Upgrade to save data.'
                                : auth.user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (auth.user?.isAnonymous == true)
                      TextButton(
                        onPressed: () => _showLinkAccountDialog(context, ref),
                        child: const Text('Upgrade'),
                      )
                    else
                      TextButton(
                        onPressed: () =>
                            ref.read(authServiceProvider.notifier).logout(),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.dangerColor,
                        ),
                        child: const Text('Logout'),
                      ),
                  ],
                ),
                const Divider(height: 24, color: AppColors.dividerColor),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Cloud Sync Enabled',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: const Text(
                    'Allows automatic background sync.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  value: true,
                  activeTrackColor: AppColors.primaryMuted,
                  activeThumbColor: AppColors.primaryColor,
                  onChanged: (val) {
                    if (!val) {
                      ref.read(authServiceProvider.notifier).disableSync();
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _getSyncIcon(SyncStateStatus status) {
    switch (status) {
      case SyncStateStatus.syncing:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryColor,
          ),
        );
      case SyncStateStatus.success:
        return const Icon(
          LucideIcons.cloud_lightning,
          size: 28,
          color: AppColors.accentColor,
        );
      case SyncStateStatus.error:
        return const Icon(
          LucideIcons.cloud_alert,
          size: 28,
          color: AppColors.dangerColor,
        );
      case SyncStateStatus.idle:
        return const Icon(
          LucideIcons.cloud,
          size: 28,
          color: AppColors.primaryColor,
        );
    }
  }

  String _getSyncStatusText(SyncStateStatus status) {
    switch (status) {
      case SyncStateStatus.syncing:
        return 'Syncing changes...';
      case SyncStateStatus.success:
        return 'Synced & Secured';
      case SyncStateStatus.error:
        return 'Sync Failed';
      case SyncStateStatus.idle:
        return 'Cloud Sync Active';
    }
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  void _showLinkAccountDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.cardElevated,
              title: const Text(
                'Upgrade Guest Account',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.dividerColor),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                      validator: (val) {
                        if (val == null || val.isEmpty || !val.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password (min 6 chars)',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.dividerColor),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                      validator: (val) {
                        if (val == null || val.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await ref
                            .read(authServiceProvider.notifier)
                            .linkEmail(
                              emailController.text.trim(),
                              passwordController.text,
                            );
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account successfully upgraded!'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: AppColors.dangerColor,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('Link Account'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLoginSignUpDialog(
    BuildContext context,
    WidgetRef ref, {
    required bool isLogin,
  }) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool localIsLogin = isLogin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.cardElevated,
              title: Text(
                localIsLogin ? 'Sign In' : 'Create Account',
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.dividerColor),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                      validator: (val) {
                        if (val == null || val.isEmpty || !val.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.dividerColor),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                      validator: (val) {
                        if (val == null || val.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          localIsLogin = !localIsLogin;
                        });
                      },
                      child: Text(
                        localIsLogin
                            ? 'Don\'t have an account? Sign Up'
                            : 'Already have an account? Sign In',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        if (localIsLogin) {
                          await ref
                              .read(authServiceProvider.notifier)
                              .signInWithEmail(
                                emailController.text.trim(),
                                passwordController.text,
                              );
                        } else {
                          await ref
                              .read(authServiceProvider.notifier)
                              .signUpWithEmail(
                                emailController.text.trim(),
                                passwordController.text,
                              );
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                localIsLogin
                                    ? 'Logged in successfully!'
                                    : 'Account registered successfully!',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: AppColors.dangerColor,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(localIsLogin ? 'Login' : 'Register'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardElevated,
        title: const Text(
          'Clear All Data?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This action cannot be undone. All your vehicles, trips, and fuel logs will be permanently deleted.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(appDatabaseProvider).clearAllData();
              await ref.read(activeVehicleProvider.notifier).clear();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Clear Everything',
              style: TextStyle(color: AppColors.dangerColor),
            ),
          ),
        ],
      ),
    );
  }
}
