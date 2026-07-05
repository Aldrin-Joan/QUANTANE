// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:quantane/data/repositories/vehicle_repository.dart';

part 'active_vehicle_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveVehicle extends _$ActiveVehicle {
  static const _key = 'active_vehicle_id';

  @override
  String? build() {
    _init();
    return null;
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString(_key);

    if (storedId != null) {
      state = storedId;
      return;
    }

    // If no stored ID, try to find the first available vehicle
    final vehicles = await ref.read(vehicleRepositoryProvider).watchAll().first;
    if (vehicles.isNotEmpty) {
      final firstId = vehicles.first.id;
      await prefs.setString(_key, firstId);
      state = firstId;
    }
  }

  Future<void> setVehicle(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, id);
    state = id;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = null;
  }
}
