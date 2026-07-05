// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/features/shared/widgets/delta_badge.dart';

class StatTile extends StatelessWidget {

  const StatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.delta,
    this.iconColor,
  });
  final IconData icon;
  final String label;
  final String value;
  final double? delta;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
          ),
          if (delta != null) ...[
            const SizedBox(height: 8),
            DeltaBadge(value: delta!),
          ],
        ],
      ),
    );
  }
}
