import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/data/repositories/fuel_repository.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/features/fuel/fuel_providers.dart';
import 'package:quantane/features/home/home_providers.dart';
import 'package:quantane/features/home/insight_providers.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:uuid/uuid.dart';

class AddFuelSheet extends ConsumerStatefulWidget {
  const AddFuelSheet({super.key});

  @override
  ConsumerState<AddFuelSheet> createState() => _AddFuelSheetState();
}

class _AddFuelSheetState extends ConsumerState<AddFuelSheet> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  final _litersController = TextEditingController();
  final _odoController = TextEditingController();
  final _stationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _costController.dispose();
    _litersController.dispose();
    _odoController.dispose();
    _stationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final vehicleId = ref.read(activeVehicleProvider);
    final messenger = ScaffoldMessenger.of(context);
    if (vehicleId == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please add and select a vehicle first in Settings.'),
        ),
      );
      return;
    }

    try {
      final entry = FuelEntry(
        id: const Uuid().v4(),
        vehicleId: vehicleId,
        date: DateTime.now(),
        fuelCost: double.parse(_costController.text),
        fuelLiters: double.parse(_litersController.text),
        odometer: double.parse(_odoController.text),
        station: _stationController.text.isNotEmpty
            ? _stationController.text
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      await ref.read(fuelRepositoryProvider).insert(entry);
      ref.invalidate(fuelHistoryProvider);
      ref.invalidate(homeSummaryProvider);
      ref.invalidate(quickStatsProvider);
      ref.invalidate(insightsProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error saving fuel fill: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Add Fuel Fill',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _costController,
                    decoration: const InputDecoration(labelText: 'Cost (₹)'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _litersController,
                    decoration: const InputDecoration(labelText: 'Liters'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _odoController,
              decoration: const InputDecoration(labelText: 'Odometer (KM)'),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stationController,
              decoration: const InputDecoration(
                labelText: 'Station (Optional)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (Optional)'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Fill'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
