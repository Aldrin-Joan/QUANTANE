import 'package:quantane/data/repositories/fuel_repository.dart';
import 'package:quantane/domain/models/analytics_summary.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

@riverpod
Future<HomeSummary?> homeSummary(Ref ref) async {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return null;

  final fuelRepo = ref.watch(fuelRepositoryProvider);
  final now = DateTime.now();
  
  final spend = await fuelRepo.getMonthlySpend(vehicleId, now);
  
  // For simplicity in this step, Mocking distance and mileage 
  // until we have more DB helpers. 
  // In a real app, I'd add more SQL queries to repositories.
  
  return HomeSummary(
    totalSpendMonth: spend,
    totalDistanceMonth: 245.0, // Mock
    avgMileageMonth: 28.7, // Mock
  );
}

@riverpod
Future<QuickStats?> quickStats(Ref ref) async {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return null;
  
  return QuickStats(
    avgMileage: 28.5,
    totalDistance: 1240.0,
    avgSpeed: 42.0,
    costPerKm: 3.5,
  );
}
