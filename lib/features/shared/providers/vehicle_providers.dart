import 'package:quantane/data/repositories/vehicle_repository.dart';
import 'package:quantane/domain/models/vehicle.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vehicle_providers.g.dart';

@riverpod
Future<Vehicle?> activeVehicleDetails(Ref ref) async {
  final vehicleId = ref.watch(activeVehicleProvider);
  if (vehicleId == null) return null;

  final repo = ref.watch(vehicleRepositoryProvider);
  return repo.getById(vehicleId);
}
