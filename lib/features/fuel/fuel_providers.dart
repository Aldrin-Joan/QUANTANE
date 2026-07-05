// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:quantane/data/repositories/fuel_repository.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';

part 'fuel_providers.g.dart';

@riverpod
Stream<List<FuelEntry>> fuelHistory(Ref ref) {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return Stream.value([]);

  final fuelRepo = ref.watch(fuelRepositoryProvider);
  return fuelRepo.watchAll(vehicleId);
}
