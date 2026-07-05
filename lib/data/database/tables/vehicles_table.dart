import 'package:drift/drift.dart';

@DataClassName('VehicleEntry')
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // bike | car | truck
  TextColumn get fuelType => text()(); // petrol | diesel | ev | cng
  RealColumn get tankCapacity => real().nullable()();
  RealColumn get initialOdometer => real().withDefault(const Constant(0.0))();
  TextColumn get createdAt => text()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
