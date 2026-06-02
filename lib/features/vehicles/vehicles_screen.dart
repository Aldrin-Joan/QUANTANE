import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/data/repositories/vehicle_repository.dart';
import 'package:quantane/domain/models/vehicle.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:quantane/features/vehicles/widgets/add_vehicle_sheet.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:quantane/core/theme/colors.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleRepo = ref.watch(vehicleRepositoryProvider);
    final activeVehicleId = ref.watch(activeVehicleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Vehicles')),
      body: StreamBuilder<List<Vehicle>>(
        stream: vehicleRepo.watchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final vehicles = snapshot.data ?? [];
          if (vehicles.isEmpty) {
            return const Center(child: Text('No vehicles added yet'));
          }
          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final isActive = vehicle.id == activeVehicleId;
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    vehicle.type == VehicleType.bike ? LucideIcons.bike : LucideIcons.car,
                    color: AppColors.primaryColor,
                  ),
                ),
                title: Text(vehicle.name),
                subtitle: Text('${vehicle.fuelType.name} | ${vehicle.type.name}'),
                trailing: isActive 
                    ? const Icon(Icons.check_circle, color: AppColors.accentColor)
                    : null,
                onTap: () => ref.read(activeVehicleProvider.notifier).setVehicle(vehicle.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddVehicleSheet(),
          );
        },
        child: const Icon(LucideIcons.plus),
      ),
    );
  }
}
