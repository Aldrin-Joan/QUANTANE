import 'package:drift/drift.dart';
import 'package:quantane/data/database/tables/vehicles_table.dart';

@DataClassName('TripData')
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId =>
      text().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get startTime => text()();
  TextColumn get endTime => text().nullable()();
  RealColumn get distance => real().withDefault(const Constant(0.0))();
  RealColumn get avgSpeed => real().nullable()();
  RealColumn get maxSpeed => real().nullable()();
  RealColumn get minSpeed => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
