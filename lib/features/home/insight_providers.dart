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

  final now = DateTime.now();
  final currentMonthEntries = _entriesForMonth(fuelEntries, now);
  final previousMonthEntries = _entriesForMonth(
    fuelEntries,
    DateTime(now.year, now.month - 1),
  );

  final currentMileage = _averageMileageFromFuelEntries(currentMonthEntries);
  final previousMileage = _averageMileageFromFuelEntries(previousMonthEntries);
  final totalSpend = _totalSpendFromFuelEntries(currentMonthEntries);

  return InsightEngine.generateInsights(
    currentMileage: currentMileage,
    lastMileage: previousMileage,
    totalSpend: totalSpend,
  );
}

double _totalDistanceFromFuelEntries(List<FuelEntry> entries) {
  if (entries.length < 2) {
    return 0;
  }

  final ordered = [...entries]
    ..sort((left, right) => left.date.compareTo(right.date));
  final distance = ordered.last.odometer - ordered.first.odometer;
  return distance > 0 ? distance : 0.0;
}

List<FuelEntry> _entriesForMonth(List<FuelEntry> entries, DateTime month) {
  return entries
      .where(
        (entry) =>
            entry.date.year == month.year && entry.date.month == month.month,
      )
      .toList();
}

double _averageMileageFromFuelEntries(List<FuelEntry> entries) {
  final totalDistance = _totalDistanceFromFuelEntries(entries);
  final totalLiters = _totalLitersFromFuelEntries(entries);
  return totalLiters > 0 ? totalDistance / totalLiters : 0.0;
}

double _totalLitersFromFuelEntries(List<FuelEntry> entries) {
  return entries.fold<double>(0, (sum, entry) => sum + entry.fuelLiters);
}

double _totalSpendFromFuelEntries(List<FuelEntry> entries) {
  return entries.fold<double>(0, (sum, entry) => sum + entry.fuelCost);
}
