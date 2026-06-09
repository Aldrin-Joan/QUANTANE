import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/features/shared/widgets/quantane_card.dart';
import 'package:quantane/features/shared/widgets/section_header.dart';
import 'package:quantane/features/trips/trip_providers.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeVehicleId = ref.watch(activeVehicleProvider);
    final tripHistoryAsync = ref.watch(tripHistoryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(floating: true, title: const Text('Trips')),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverToBoxAdapter(
              child: _TripsHero(
                activeVehicleId: activeVehicleId,
                tripsAsync: tripHistoryAsync,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'Recent Trips')),
          _buildTripSliver(context, ref, activeVehicleId, tripHistoryAsync),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startTrip(context, ref, activeVehicleId),
        child: const Icon(LucideIcons.route),
      ),
    );
  }

  void _startTrip(
    BuildContext context,
    WidgetRef ref,
    String? activeVehicleId,
  ) {
    if (activeVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add and select a vehicle first in Settings.'),
        ),
      );
      return;
    }

    ref.read(tripTrackingProvider.notifier).start();
    context.push('/live-trip');
  }

  Widget _buildTripSliver(
    BuildContext context,
    WidgetRef ref,
    String? activeVehicleId,
    AsyncValue<List<Trip>> tripHistoryAsync,
  ) {
    return tripHistoryAsync.when(
      data: (trips) {
        if (activeVehicleId == null) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _TripsEmptyState(
              icon: LucideIcons.car,
              title: 'No vehicle selected',
              message:
                  'Select a vehicle in Settings to start tracking and viewing trip history.',
            ),
          );
        }

        if (trips.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _TripsEmptyState(
              icon: LucideIcons.route,
              title: 'No trips yet',
              message:
                  'Start a trip from this screen to capture speed, distance, and trip history.',
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList.separated(
            itemCount: trips.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _TripTile(
              trip: trips[index],
              onDelete: () async {
                await ref.read(tripRepositoryProvider).delete(trips[index].id);
                if (!context.mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Trip deleted')));
              },
            ),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(child: Text('Unable to load trip history: $e')),
        ),
      ),
    );
  }
}

class _TripsHero extends StatelessWidget {
  final String? activeVehicleId;
  final AsyncValue<List<Trip>> tripsAsync;

  const _TripsHero({required this.activeVehicleId, required this.tripsAsync});

  @override
  Widget build(BuildContext context) {
    return tripsAsync.when(
      data: (trips) {
        final totalDistance = trips.fold<double>(
          0,
          (sum, trip) => sum + trip.distance,
        );
        final totalDuration = trips.fold<Duration>(
          Duration.zero,
          (sum, trip) =>
              sum + (trip.endTime?.difference(trip.startTime) ?? Duration.zero),
        );
        final completedTrips = trips
            .where((trip) => trip.endTime != null)
            .length;
        final averageSpeed = trips.isEmpty
            ? 0.0
            : trips.fold<double>(0, (sum, trip) => sum + (trip.avgSpeed ?? 0)) /
                  trips.length;

        return QuantaneCard(
          variant: QuantaneCardVariant.colored,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      LucideIcons.route,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trip history',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.72),
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activeVehicleId == null
                              ? 'Select a vehicle first'
                              : 'Active vehicle',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${averageSpeed.toStringAsFixed(0)} KM/H',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        'avg speed',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 18),
              Text(
                trips.isEmpty
                    ? 'Start your first trip to capture distance, duration, and speed.'
                    : '$completedTrips completed trips • ${totalDistance.toStringAsFixed(0)} KM total • ${_formatDuration(totalDuration)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _TripsHeroStat(
                      icon: LucideIcons.route,
                      label: 'Distance',
                      value: '${totalDistance.toStringAsFixed(0)} KM',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TripsHeroStat(
                      icon: LucideIcons.clock,
                      label: 'Duration',
                      value: _formatDuration(totalDuration),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TripsHeroStat(
                      icon: LucideIcons.route,
                      label: 'Trips',
                      value: '${trips.length}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => QuantaneCard(
        variant: QuantaneCardVariant.colored,
        padding: const EdgeInsets.all(20),
        child: const SizedBox(
          height: 108,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ),
      error: (e, s) => QuantaneCard(
        variant: QuantaneCardVariant.colored,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Unable to load trip history',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(Duration duration) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }
}

class _TripsHeroStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TripsHeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripsEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _TripsEmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: QuantaneCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, size: 30, color: AppColors.primaryColor),
                ),
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
      ),
    );
  }
}

class _TripTile extends StatelessWidget {
  final Trip trip;
  final Future<void> Function() onDelete;

  const _TripTile({required this.trip, required this.onDelete});

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.cardColor,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Delete trip?',
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This removes the trip history entry permanently.',
                  style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(sheetContext).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.dangerColor.withValues(
                      alpha: 0.16,
                    ),
                    foregroundColor: AppColors.dangerColor,
                  ),
                  child: const Text('Delete'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(false),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldDelete == true) {
      await onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = trip.endTime?.difference(trip.startTime) ?? Duration.zero;
    final averageSpeed = trip.avgSpeed ?? 0;
    final maximumSpeed = trip.maxSpeed ?? 0;

    return QuantaneCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onLongPress: () => _confirmDelete(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 12,
                  height: 76,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${trip.distance.toStringAsFixed(1)} KM',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete trip',
                            onPressed: () => _confirmDelete(context),
                            icon: const Icon(LucideIcons.trash, size: 18),
                            visualDensity: VisualDensity.compact,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(trip.startTime),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TripStatChip(
                  icon: LucideIcons.timer,
                  label: 'Duration',
                  value: _formatDuration(duration),
                ),
                _TripStatChip(
                  icon: LucideIcons.gauge,
                  label: 'Average',
                  value: '${averageSpeed.toStringAsFixed(0)} KM/H',
                ),
                _TripStatChip(
                  icon: Icons.trending_up,
                  label: 'Max',
                  value: '${maximumSpeed.toStringAsFixed(0)} KM/H',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
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

  static String _formatDuration(Duration duration) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }
}

class _TripStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TripStatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
