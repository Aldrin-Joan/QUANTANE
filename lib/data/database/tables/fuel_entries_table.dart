import 'package:drift/drift.dart';
import 'package:quantane/data/database/tables/vehicles_table.dart';

@DataClassName('FuelEntryData')
class FuelEntries extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId =>
      text().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get date => text()();
  RealColumn get fuelCost => real()();
  RealColumn get fuelLiters => real()();
  RealColumn get odometer => real()();
  TextColumn get station => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
