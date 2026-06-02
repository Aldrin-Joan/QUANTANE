import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:quantane/core/theme/colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSection(context, 'Vehicle', [
            ListTile(
              leading: const Icon(LucideIcons.car),
              title: const Text('Manage Vehicles'),
              trailing: const Icon(LucideIcons.chevron_right, size: 20),
              onTap: () => context.push('/vehicles'), // Need to add this route
            ),
          ]),
          _buildSection(context, 'Preferences', [
            const ListTile(
              leading: Icon(LucideIcons.indian_rupee),
              title: Text('Currency'),
              trailing: Text('INR (₹)', style: TextStyle(color: AppColors.textSecondary)),
            ),
            const ListTile(
              leading: Icon(LucideIcons.map_pin),
              title: Text('Distance Unit'),
              trailing: Text('Kilometers (KM)', style: TextStyle(color: AppColors.textSecondary)),
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
              leading: const Icon(LucideIcons.trash_2, color: AppColors.dangerColor),
              title: const Text('Clear All Data', style: TextStyle(color: AppColors.dangerColor)),
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

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
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

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text('This action cannot be undone. All your vehicles, trips, and fuel logs will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Implementation to clear DB
              Navigator.pop(context);
            },
            child: const Text('Clear Everything', style: TextStyle(color: AppColors.dangerColor)),
          ),
        ],
      ),
    );
  }
}
