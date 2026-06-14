import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:quantane/features/shared/widgets/quantane_card.dart';
import 'package:quantane/features/trips/trip_formatters.dart';

class TripHistoryCard extends StatelessWidget {
  final Trip trip;
  final Future<void> Function() onDelete;

  const TripHistoryCard({
    super.key,
    required this.trip,
    required this.onDelete,
  });

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

    return QuantaneCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push('/trips/${trip.id}'),
        onLongPress: () => _confirmDelete(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RoutePreview(snapshotPath: trip.routeSnapshotPath),
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
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
  final String? snapshotPath;

  const _RoutePreview({required this.snapshotPath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SizedBox(
        height: 148,
        width: double.infinity,
        child: FutureBuilder<File?>(
          future: _resolveSnapshotFile(snapshotPath),
          builder: (context, snapshot) {
            final file = snapshot.data;
            if (file != null) {
              return Image.file(
                file,
                fit: BoxFit.cover,
                cacheWidth: 720,
                errorBuilder: (context, error, stackTrace) {
                  return const _RoutePreviewFallback();
                },
              );
            }

            return const _RoutePreviewFallback();
          },
        ),
      ),
    );
  }

  static Future<File?> _resolveSnapshotFile(String? snapshotPath) async {
    if (snapshotPath == null || snapshotPath.isEmpty) {
      return null;
    }

    final documentsDir = await getApplicationDocumentsDirectory();
    final file = File('${documentsDir.path}/$snapshotPath');
    return file.existsSync() ? file : null;
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
        child: Icon(
          LucideIcons.map,
          color: AppColors.textSecondary,
          size: 36,
        ),
      ),
    );
  }
}
