// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_lucide/flutter_lucide.dart';

// Project imports:
import 'package:quantane/domain/models/analytics_summary.dart';
import 'package:quantane/features/shared/widgets/stat_tile.dart';

class QuickStatsGrid extends StatelessWidget {

  const QuickStatsGrid({super.key, required this.stats});
  final QuickStats stats;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      childAspectRatio: 1.1,
      children: [
        StatTile(
          icon: LucideIcons.gauge,
          label: 'Avg Mileage',
          value: '${stats.avgMileage.toStringAsFixed(1)} KM/L',
          delta: stats.avgMileageDeltaPercent,
        ),
        StatTile(
          icon: LucideIcons.map_pin,
          label: 'Total Distance',
          value: '${stats.totalDistance.toStringAsFixed(0)} KM',
        ),
        StatTile(
          icon: LucideIcons.zap,
          label: 'Avg Speed',
          value: '${stats.avgSpeed.toStringAsFixed(0)} KM/H',
        ),
        StatTile(
          icon: LucideIcons.indian_rupee,
          label: 'Cost / KM',
          value: '₹ ${stats.costPerKm.toStringAsFixed(2)}',
        ),
      ],
    );
  }
}
