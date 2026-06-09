import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/features/shared/widgets/delta_badge.dart';
import 'package:quantane/features/shared/widgets/quantane_card.dart';

class FuelEntryCard extends StatelessWidget {
  final FuelEntry entry;
  final double? previousMileage;
  final VoidCallback? onLongPress;

  const FuelEntryCard({
    super.key,
    required this.entry,
    this.previousMileage,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: QuantaneCard(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onLongPress: onLongPress,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy').format(entry.date),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (entry.station != null)
                        Text(
                          entry.station!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹ ${entry.fuelCost.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.primaryColor,
                              fontFeatures: [
                                const FontFeature.tabularFigures(),
                              ],
                            ),
                      ),
                      Text(
                        '${entry.fuelLiters.toStringAsFixed(2)} L @ ${entry.odometer.toStringAsFixed(0)} KM',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              if (entry.mileage != null) ...[
                const SizedBox(height: 12),
                const Divider(color: AppColors.dividerColor, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${entry.mileage!.toStringAsFixed(1)} KM/L',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (previousMileage != null && previousMileage! > 0)
                      DeltaBadge(
                        value:
                            ((entry.mileage! - previousMileage!) /
                                previousMileage!) *
                            100,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
