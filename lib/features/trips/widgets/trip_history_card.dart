import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/shared/widgets/quantane_card.dart';
import 'package:quantane/features/trips/trip_formatters.dart';
import 'package:quantane/features/trips/widgets/trip_route_map.dart';

class TripHistoryCard extends StatelessWidget {

  const TripHistoryCard({
    super.key,
    required this.trip,
    required this.onDelete,
  });
  final Trip trip;
  final Future<void> Function() onDelete;

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

    if (shouldDelete ?? false) {
      await onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = trip.endTime?.difference(trip.startTime) ?? Duration.zero;

    return QuantaneCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push('/trips/${trip.id}'),
        onLongPress: () => _confirmDelete(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RoutePreview(trip: trip),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          TripFormatters.routeLabel(
                            startAddress: trip.startAddress,
                            endAddress: trip.endAddress,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
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
                  const SizedBox(height: 8),
                  Text(
                    '${trip.distance.toStringAsFixed(1)} km · ${TripFormatters.formatShortDuration(duration)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    TripFormatters.formatDate(trip.startTime),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutePreview extends StatelessWidget {

  const _RoutePreview({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SizedBox(
        height: 148,
        width: double.infinity,
        child: trip.routePoints.length < 2
            ? const _RoutePreviewFallback()
            : TripRouteMap(
                routePoints: trip.routePoints,
                minLatitude: trip.minLatitude,
                maxLatitude: trip.maxLatitude,
                minLongitude: trip.minLongitude,
                maxLongitude: trip.maxLongitude,
                interactive: false,
                height: 148,
              ),
      ),
    );
  }
}

class _RoutePreviewFallback extends StatelessWidget {
  const _RoutePreviewFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.35),
            AppColors.cardElevated,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(LucideIcons.map, color: AppColors.textSecondary, size: 36),
      ),
    );
  }
}
