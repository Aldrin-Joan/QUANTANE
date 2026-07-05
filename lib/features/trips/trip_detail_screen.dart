// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/shared/widgets/quantane_card.dart';
import 'package:quantane/features/trips/trip_formatters.dart';
import 'package:quantane/features/trips/widgets/trip_route_map.dart';

class TripDetailScreen extends ConsumerWidget {

  const TripDetailScreen({super.key, required this.tripId});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripByIdProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: tripAsync.when(
        data: (trip) {
          if (trip == null) {
            return const Center(child: Text('Trip not found'));
          }
          return _TripDetailBody(trip: trip);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Unable to load trip: $error'),
          ),
        ),
      ),
    );
  }
}

class _TripDetailBody extends StatelessWidget {

  const _TripDetailBody({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final duration = trip.endTime?.difference(trip.startTime) ?? Duration.zero;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: TripRouteMap(
            routePoints: trip.routePoints,
            minLatitude: trip.minLatitude,
            maxLatitude: trip.maxLatitude,
            minLongitude: trip.minLongitude,
            maxLongitude: trip.maxLongitude,
            height: 280,
          ),
        ),
        const SizedBox(height: 16),
        QuantaneCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LocationRow(
                label: 'Start',
                value:
                    trip.startAddress ??
                    TripFormatters.coordinateLabel(trip, isStart: true),
                icon: LucideIcons.map_pin,
                iconColor: const Color(0xFF22C55E),
              ),
              const SizedBox(height: 14),
              _LocationRow(
                label: 'End',
                value:
                    trip.endAddress ??
                    TripFormatters.coordinateLabel(trip, isStart: false),
                icon: LucideIcons.map_pin,
                iconColor: const Color(0xFFEF4444),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        QuantaneCard(
          child: Column(
            children: [
              _StatRow(
                label: 'Distance',
                value: '${trip.distance.toStringAsFixed(1)} km',
              ),
              const Divider(height: 24),
              _StatRow(
                label: 'Duration',
                value: TripFormatters.formatLongDuration(duration),
              ),
              const Divider(height: 24),
              _StatRow(
                label: 'Average Speed',
                value: '${(trip.avgSpeed ?? 0).toStringAsFixed(0)} km/h',
              ),
              const Divider(height: 24),
              _StatRow(
                label: 'Maximum Speed',
                value: '${(trip.maxSpeed ?? 0).toStringAsFixed(0)} km/h',
              ),
              const Divider(height: 24),
              _StatRow(
                label: 'Start Time',
                value: TripFormatters.formatDateTime(trip.startTime),
              ),
              if (trip.endTime != null) ...[
                const Divider(height: 24),
                _StatRow(
                  label: 'End Time',
                  value: TripFormatters.formatDateTime(trip.endTime!),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {

  const _LocationRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {

  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
