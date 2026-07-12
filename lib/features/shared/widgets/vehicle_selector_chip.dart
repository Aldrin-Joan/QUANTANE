// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/data/repositories/vehicle_repository.dart';
import 'package:quantane/domain/models/vehicle.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';

enum VehicleSelectorVariant {
  standard, // Muted blue background (default)
  transparent, // Integrated look for colored backgrounds
}

class VehicleSelectorChip extends ConsumerWidget {
  const VehicleSelectorChip({
    this.variant = VehicleSelectorVariant.standard,
    super.key,
  });

  final VehicleSelectorVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeVehicleId = ref.watch(activeVehicleProvider);
    final vehicleRepo = ref.watch(vehicleRepositoryProvider);

    return StreamBuilder<List<Vehicle>>(
      stream: vehicleRepo.watchAll(),
      builder: (context, snapshot) {
        final vehicles = snapshot.data ?? const <Vehicle>[];
        if (vehicles.isEmpty) {
          return const SizedBox.shrink();
        }

        final selectedVehicle = vehicles.firstWhere(
          (vehicle) => vehicle.id == activeVehicleId,
          orElse: () => vehicles.first,
        );

        final isTransparent = variant == VehicleSelectorVariant.transparent;
        final headerColor = isTransparent ? Colors.white : AppColors.primaryColor;
        final headerBg = isTransparent
            ? Colors.white.withValues(alpha: 0.15)
            : AppColors.primaryMuted;

        return SizedBox(
          width: 145, // Optimized width
          child: CustomDropdown<Vehicle>(
            items: vehicles,
            initialItem: selectedVehicle,
            onChanged: (vehicle) {
              if (vehicle != null) {
                ref.read(activeVehicleProvider.notifier).setVehicle(vehicle.id);
              }
            },
            headerBuilder: (context, selectedItem, enabled) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: headerBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.bike,
                      size: 14,
                      color: headerColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        selectedItem.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: headerColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.bike,
                      size: 16,
                      color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        LucideIcons.check,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                  ],
                ),
              );
            },
            decoration: CustomDropdownDecoration(
              closedFillColor: Colors.transparent,
              expandedFillColor: AppColors.cardElevated,
              closedSuffixIcon: Icon(
                LucideIcons.chevron_down,
                size: 14,
                color: headerColor,
              ),
              expandedSuffixIcon: Icon(
                LucideIcons.chevron_up,
                size: 14,
                color: headerColor,
              ),
              headerStyle: TextStyle(
                fontSize: 12,
                color: headerColor,
                fontWeight: FontWeight.w600,
              ),
              listItemStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }
}
