import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/trips/trip_providers.dart';

import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeVehicleId = ref.watch(activeVehicleProvider);
    final tripHistoryAsync = ref.watch(tripHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trips')),
      body: tripHistoryAsync.when(
        data: (trips) {
          if (activeVehicleId == null) {
            return const _TripsEmptyState(
              title: 'No vehicle selected',
              message:
                  'Select a vehicle in Settings to start tracking and viewing trip history.',
            );
          }

          if (trips.isEmpty) {
            return const _TripsEmptyState(
              title: 'No trips yet',
              message:
                  'Start a trip from this screen to capture speed, distance, and trip history.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _TripTile(trip: trips[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Unable to load trip history: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (activeVehicleId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Please add and select a vehicle first in Settings.',
                ),
              ),
            );
            return;
          }
          ref.read(tripTrackingProvider.notifier).start();
          context.push('/live-trip');
        },
        child: const Icon(LucideIcons.play),
      ),
    );
  }
}

class _TripsEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const _TripsEmptyState({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.route, size: 48),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripTile extends StatelessWidget {
  final Trip trip;

  const _TripTile({required this.trip});

  @override
  Widget build(BuildContext context) {
    final duration = trip.endTime?.difference(trip.startTime) ?? Duration.zero;

    return Card(
      child: ListTile(
        title: Text('${trip.distance.toStringAsFixed(1)} KM'),
        subtitle: Text(
          '${_formatDate(trip.startTime)} • ${_formatDuration(duration)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${(trip.avgSpeed ?? 0).toStringAsFixed(0)} KM/H'),
            Text('${(trip.maxSpeed ?? 0).toStringAsFixed(0)} MAX'),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }
}
