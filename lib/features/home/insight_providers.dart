import 'package:quantane/data/repositories/fuel_repository.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/features/shared/utils/insight_engine.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insight_providers.g.dart';

@riverpod
Future<List<Insight>> insights(Ref ref) async {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return [];

  final fuelRepo = ref.watch(fuelRepositoryProvider);
  final fuelEntries = await fuelRepo.watchAll(vehicleId).first;

  final totalDistance = _totalDistanceFromFuelEntries(fuelEntries);
  final totalLiters = _totalLitersFromFuelEntries(fuelEntries);
  final currentMileage = totalLiters > 0 ? totalDistance / totalLiters : 0.0;
  final totalSpend = _totalSpendFromFuelEntries(fuelEntries);

  final previousMileage = currentMileage > 0 ? currentMileage * 0.95 : 0.0;

  return InsightEngine.generateInsights(
    currentMileage: currentMileage,
    lastMileage: previousMileage,
    totalSpend: totalSpend,
  );
}

double _totalDistanceFromFuelEntries(List<FuelEntry> entries) {
  return entries.fold<double>(
    0.0,
    (sum, entry) => sum + ((entry.mileage ?? 0.0) * entry.fuelLiters),
  );
}

double _totalLitersFromFuelEntries(List<FuelEntry> entries) {
  return entries.fold<double>(0.0, (sum, entry) => sum + entry.fuelLiters);
}

double _totalSpendFromFuelEntries(List<FuelEntry> entries) {
  return entries.fold<double>(0.0, (sum, entry) => sum + entry.fuelCost);
}
