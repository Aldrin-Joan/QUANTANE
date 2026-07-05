// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/group_ride/presentation/screens/group_ride_screen.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/features/shared/widgets/quantane_card.dart';
import 'package:quantane/features/shared/widgets/section_header.dart';
import 'package:quantane/features/shared/widgets/vehicle_selector_chip.dart';
import 'package:quantane/features/trips/trip_finalization_providers.dart';
import 'package:quantane/features/trips/trip_permissions.dart';
import 'package:quantane/features/trips/trip_providers.dart';
import 'package:quantane/features/trips/widgets/trip_history_card.dart';

class TripsScreen extends ConsumerStatefulWidget {
  const TripsScreen({super.key});

  @override
  ConsumerState<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends ConsumerState<TripsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeVehicleId = ref.watch(activeVehicleProvider);
    final permissionsAsync = ref.watch(tripPermissionsProvider);
    final permissions = permissionsAsync.value ?? TripPermissionState.loading();
    final tripHistoryAsync = ref.watch(tripHistoryProvider);

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.cardColor,
            padding: const EdgeInsets.only(top: 48),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'My Trips'),
                Tab(text: 'Group Ride'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(tripPermissionsProvider);

                    final trips = tripHistoryAsync.value ?? [];
                    final tripRepo = ref.read(tripRepositoryProvider);
                    final geocoder = ref.read(nominatimGeocodingServiceProvider);
                    final routeProcessing = ref.read(routeProcessingServiceProvider);
                    final snapshotWriter = ref.read(routeSnapshotWriterProvider);
                    final docDir = await getApplicationDocumentsDirectory();

                    for (final trip in trips) {
                      var updated = false;
                      var startAddress = trip.startAddress;
                      var endAddress = trip.endAddress;
                      var snapshotPath = trip.routeSnapshotPath;

                      if ((startAddress == null || startAddress == 'Unknown location') &&
                          trip.routePoints.isNotEmpty) {
                        try {
                          final resolved = await geocoder.reverseGeocode(
                            latitude: trip.routePoints.first.latitude,
                            longitude: trip.routePoints.first.longitude,
                          );
                          if (resolved != null && resolved.isNotEmpty) {
                            startAddress = resolved;
                            updated = true;
                          }
                        } catch (_) {}
                      }

                      if ((endAddress == null || endAddress == 'Unknown location') &&
                          trip.routePoints.isNotEmpty) {
                        try {
                          final resolved = await geocoder.reverseGeocode(
                            latitude: trip.routePoints.last.latitude,
                            longitude: trip.routePoints.last.longitude,
                          );
                          if (resolved != null && resolved.isNotEmpty) {
                            endAddress = resolved;
                            updated = true;
                          }
                        } catch (_) {}
                      }

                      final snapshotMissing =
                          snapshotPath == null ||
                          !File('${docDir.path}/$snapshotPath').existsSync();

                      if (snapshotMissing && trip.routePoints.length >= 2) {
                        try {
                          final processed = await routeProcessing.process(
                            trip.routePoints,
                          );
                          if (processed != null) {
                            final newPath = await snapshotWriter.writeSnapshot(
                              tripId: trip.id,
                              route: processed,
                            );
                            if (newPath != null) {
                              snapshotPath = newPath;
                              updated = true;
                            }
                          }
                        } catch (_) {}
                      }

                      if (updated) {
                        final newTrip = trip.copyWith(
                          startAddress: startAddress,
                          endAddress: endAddress,
                          routeSnapshotPath: snapshotPath,
                        );
                        await tripRepo.insert(newTrip);
                      }
                    }
                  },
                  child: CustomScrollView(
                    slivers: [
                      if (permissions.isRefreshing)
                        const SliverPadding(
                          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                          sliver: SliverToBoxAdapter(child: _PermissionCard.loading()),
                        )
                      else if (permissions.hasBlockingLocationIssue ||
                          permissions.shouldWarnAboutNotifications)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          sliver: SliverToBoxAdapter(
                            child: _PermissionStack(
                              permissions: permissions,
                              onFixLocation: () async {
                                final locationStatus = permissions.location.status;
                                if (locationStatus == TripPermissionStatus.denied) {
                                  await ref
                                      .read(tripPermissionsControllerProvider)
                                      .requestLocationAccess();
                                  return;
                                }

                                if (locationStatus ==
                                    TripPermissionStatus.serviceDisabled) {
                                  await ref
                                      .read(tripPermissionsControllerProvider)
                                      .openLocationSettings();
                                  return;
                                }

                                await ref
                                    .read(tripPermissionsControllerProvider)
                                    .openAppSettings();
                              },
                              onEnableNotifications: () async {
                                await ref
                                    .read(tripPermissionsControllerProvider)
                                    .requestNotificationAccess();
                              },
                            ),
                          ),
                        ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        sliver: SliverToBoxAdapter(
                          child: _TripsHero(
                            activeVehicleId: activeVehicleId,
                            tripsAsync: tripHistoryAsync,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SectionHeader(title: 'Recent Trips')),
                      _buildTripSliver(context, ref, activeVehicleId, tripHistoryAsync),
                    ],
                  ),
                ),
                const GroupRideScreen(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              heroTag: null,
              onPressed:
                  permissions.canStartTrip ||
                      ref.read(tripTrackingProvider).session != null
                  ? () {
                      final trackingState = ref.read(tripTrackingProvider);
                      if (trackingState.session != null) {
                        context.push('/live-trip');
                        return;
                      }

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

                      _startTrip(context, ref, activeVehicleId);
                    }
                  : null,
              tooltip: permissions.canStartTrip
                  ? 'Start Trip'
                  : permissions.blockingLocationMessage ?? 'Location required',
              child: Icon(
                ref.watch(tripTrackingProvider).session != null
                    ? LucideIcons.eye
                    : LucideIcons.route,
              ),
            )
          : null,
    );
  }

  Future<void> _startTrip(
    BuildContext context,
    WidgetRef ref,
    String? activeVehicleId,
  ) async {
    if (activeVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add and select a vehicle first in Settings.'),
        ),
      );
      return;
    }

    try {
      await ref
          .read(tripTrackingProvider.notifier)
          .start(vehicleId: activeVehicleId);
    } on StateError catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
      return;
    }
    if (!context.mounted) {
      return;
    }
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
          return const SliverFillRemaining(
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
          return const SliverFillRemaining(
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
            itemBuilder: (context, index) => TripHistoryCard(
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

class _PermissionStack extends StatelessWidget {

  const _PermissionStack({
    required this.permissions,
    required this.onFixLocation,
    required this.onEnableNotifications,
  });
  final TripPermissionState permissions;
  final Future<void> Function() onFixLocation;
  final Future<void> Function() onEnableNotifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (permissions.hasBlockingLocationIssue)
          _PermissionCard(
            icon: LucideIcons.locate,
            title: 'Location required',
            message:
                permissions.blockingLocationMessage ??
                'Location access is required to start trip tracking.',
            actionLabel: permissions.location.actionLabel,
            onAction: onFixLocation,
            accentColor: AppColors.dangerColor,
          ),
        if (permissions.shouldWarnAboutNotifications) ...[
          const SizedBox(height: 12),
          _PermissionCard(
            icon: LucideIcons.bell,
            title: 'Notifications are off',
            message:
                permissions.notificationMessage ??
                'Trip tracking still works, but notifications make it easier to follow progress.',
            actionLabel: permissions.notification.actionLabel,
            onAction: onEnableNotifications,
            accentColor: AppColors.warningColor,
            compact: true,
          ),
        ],
      ],
    );
  }
}

class _PermissionCard extends StatelessWidget {

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.accentColor,
    this.compact = false,
  });

  const _PermissionCard.loading()
    : icon = LucideIcons.loader_circle,
      title = 'Checking permissions',
      message =
          'Verifying location and notification access before trip tracking starts.',
      actionLabel = null,
      onAction = null,
      accentColor = AppColors.textSecondary,
      compact = false;
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final Future<void> Function()? onAction;
  final Color accentColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return QuantaneCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: compact ? 40 : 48,
            height: compact ? 40 : 48,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accentColor, size: compact ? 20 : 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => onAction!(),
                      child: Text(actionLabel!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripsHero extends StatelessWidget {

  const _TripsHero({required this.activeVehicleId, required this.tripsAsync});
  final String? activeVehicleId;
  final AsyncValue<List<Trip>> tripsAsync;

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
                  const VehicleSelectorChip(),
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
      loading: () => const QuantaneCard(
        variant: QuantaneCardVariant.colored,
        padding: EdgeInsets.all(20),
        child: SizedBox(
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

  const _TripsHeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

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

  const _TripsEmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: QuantaneCard(
            padding: const EdgeInsets.all(20),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(icon, size: 26, color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
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
      ),
    );
  }
}
