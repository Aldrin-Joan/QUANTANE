import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/data/repositories/vehicle_repository.dart';
import 'package:quantane/domain/models/vehicle.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';

class VehicleSelectorChip extends ConsumerWidget {
  const VehicleSelectorChip({super.key});

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

        return PopupMenuButton<String>(
          tooltip: 'Switch vehicle',
          onSelected: (vehicleId) =>
              ref.read(activeVehicleProvider.notifier).setVehicle(vehicleId),
          itemBuilder: (context) => vehicles
              .map(
                (vehicle) => PopupMenuItem<String>(
                  value: vehicle.id,
                  child: Row(
                    children: [
                      Expanded(child: Text(vehicle.name)),
                      if (vehicle.id == selectedVehicle.id)
                        const Icon(
                          Icons.check,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                    ],
                  ),
                ),
              )
              .toList(),
          child: Chip(
            label: Text(selectedVehicle.name),
            backgroundColor: AppColors.primaryMuted,
            side: BorderSide.none,
            labelStyle: const TextStyle(
              fontSize: 12,
              color: AppColors.primaryColor,
            ),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        );
      },
    );
  }
}
