import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/data/repositories/vehicle_repository.dart';
import 'package:quantane/domain/models/vehicle.dart';
import 'package:uuid/uuid.dart';

class AddVehicleSheet extends ConsumerStatefulWidget {
  const AddVehicleSheet({super.key});

  @override
  ConsumerState<AddVehicleSheet> createState() => _AddVehicleSheetState();
}

class _AddVehicleSheetState extends ConsumerState<AddVehicleSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _odoController = TextEditingController();
  final _tankController = TextEditingController();
  VehicleType _type = VehicleType.car;
  FuelType _fuelType = FuelType.petrol;

  @override
  void dispose() {
    _nameController.dispose();
    _odoController.dispose();
    _tankController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final vehicle = Vehicle(
      id: const Uuid().v4(),
      name: _nameController.text,
      type: _type,
      fuelType: _fuelType,
      tankCapacity: double.tryParse(_tankController.text),
      initialOdometer: double.parse(_odoController.text),
      createdAt: DateTime.now(),
    );

    await ref.read(vehicleRepositoryProvider).insert(vehicle);
    if (mounted) Navigator.pop(context);
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
            Text('Add Vehicle', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Vehicle Name'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<VehicleType>(
                    initialValue: _type,
                    items: VehicleType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                    onChanged: (v) => setState(() => _type = v!),
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<FuelType>(
                    initialValue: _fuelType,
                    items: FuelType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                    onChanged: (v) => setState(() => _fuelType = v!),
                    decoration: const InputDecoration(labelText: 'Fuel'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _odoController,
                    decoration: const InputDecoration(labelText: 'Initial Odo'),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _tankController,
                    decoration: const InputDecoration(labelText: 'Tank (L)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Vehicle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
