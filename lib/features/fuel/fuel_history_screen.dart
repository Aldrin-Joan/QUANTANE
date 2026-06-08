import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/features/fuel/fuel_providers.dart';
import 'package:quantane/features/fuel/widgets/fuel_entry_card.dart';
import 'package:quantane/features/fuel/widgets/add_fuel_sheet.dart';
import 'package:quantane/features/shared/widgets/vehicle_selector_chip.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class FuelHistoryScreen extends ConsumerWidget {
  const FuelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(fuelHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Log'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: VehicleSelectorChip(),
          ),
        ],
      ),
      body: historyAsync.when(
        data: (entries) => entries.isEmpty
            ? const Center(child: Text('No fuel entries yet'))
            : ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) =>
                    FuelEntryCard(entry: entries[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddFuelSheet(),
          );
        },
        child: const Icon(LucideIcons.plus),
      ),
    );
  }
}
