import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:quantane/data/database/tables/vehicles_table.dart';
import 'package:quantane/data/database/tables/fuel_entries_table.dart' as fuel;
import 'package:quantane/data/database/tables/trips_table.dart' as trip;
import 'package:shared_preferences/shared_preferences.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Vehicles, fuel.FuelEntries, trip.Trips])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'quantane_db');
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();

    await transaction(() async {
      await delete(trips).go();
      await delete(fuelEntries).go();
      await delete(vehicles).go();
    });

    await prefs.remove('active_vehicle_id');
  }
}
