import 'package:drift/drift.dart';

@DataClassName('SyncQueueEntry')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get action => text()(); // INSERT | UPDATE | DELETE
  TextColumn get entityType => text()(); // vehicles | fuel_entries | trips
  TextColumn get entityId => text()(); // UUID of the entity
  TextColumn get payload => text().nullable()(); // JSON string representation
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
