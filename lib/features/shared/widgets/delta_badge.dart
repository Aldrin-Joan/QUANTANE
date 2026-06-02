import 'package:flutter/material.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class DeltaBadge extends StatelessWidget {
  final double value;
  final bool isPercentage;

  const DeltaBadge({
    super.key,
    required this.value,
    this.isPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value > 0;
    final isNeutral = value == 0;
    
    final Color bgColor = isNeutral 
        ? AppColors.textTertiary.withOpacity(0.1)
        : isPositive ? AppColors.accentMuted : AppColors.dangerMuted;
    
    final Color textColor = isNeutral
        ? AppColors.textTertiary
        : isPositive ? AppColors.accentColor : AppColors.dangerColor;

    final icon = isNeutral
        ? null
        : isPositive ? LucideIcons.arrow_up : LucideIcons.arrow_down;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            '${value.abs().toStringAsFixed(1)}${isPercentage ? '%' : ''}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
