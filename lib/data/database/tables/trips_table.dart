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
  TextColumn get startAddress => text().nullable()();
  TextColumn get endAddress => text().nullable()();
  RealColumn get minLatitude => real().withDefault(const Constant(0.0))();
  RealColumn get maxLatitude => real().withDefault(const Constant(0.0))();
  RealColumn get minLongitude => real().withDefault(const Constant(0.0))();
  RealColumn get maxLongitude => real().withDefault(const Constant(0.0))();
  TextColumn get routeSnapshotPath => text().nullable()();
  TextColumn get routePointsJson => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
