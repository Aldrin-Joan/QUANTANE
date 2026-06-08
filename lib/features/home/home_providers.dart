import 'package:quantane/data/repositories/fuel_repository.dart';
import 'package:quantane/domain/models/analytics_summary.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

@riverpod
Stream<HomeSummary?> homeSummary(Ref ref) {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return Stream.value(null);

  final fuelRepo = ref.watch(fuelRepositoryProvider);

  return fuelRepo.watchAll(vehicleId).asyncMap((fuelEntries) async {
    final now = DateTime.now();

    final totalDistance = _totalDistanceFromFuelEntries(fuelEntries);
    final totalLiters = _totalLitersFromFuelEntries(fuelEntries);
    final avgMileage = totalLiters > 0 ? totalDistance / totalLiters : 0.0;

    final spend = await fuelRepo.getMonthlySpend(vehicleId, now);

    return HomeSummary(
      totalSpendMonth: spend,
      totalDistanceMonth: totalDistance,
      avgMileageMonth: avgMileage,
    );
  });
}

@riverpod
Stream<QuickStats?> quickStats(Ref ref) {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return Stream.value(null);

  final fuelRepo = ref.watch(fuelRepositoryProvider);

  return fuelRepo.watchAll(vehicleId).map((fuelEntries) {
    final totalDistance = _totalDistanceFromFuelEntries(fuelEntries);
    final totalLiters = _totalLitersFromFuelEntries(fuelEntries);
    final avgMileage = totalLiters > 0 ? totalDistance / totalLiters : 0.0;
    final totalSpend = _totalSpendFromFuelEntries(fuelEntries);
    final costPerKm = totalDistance > 0 ? totalSpend / totalDistance : 0.0;

    return QuickStats(
      avgMileage: avgMileage,
      totalDistance: totalDistance,
      avgSpeed: 0.0,
      costPerKm: costPerKm,
    );
  });
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
