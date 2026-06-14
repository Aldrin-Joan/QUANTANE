import 'package:drift/drift.dart';
import 'package:quantane/data/database/app_database.dart';
import 'package:quantane/data/database/database_provider.dart';
import 'package:quantane/domain/models/fuel_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fuel_repository.g.dart';

class FuelRepository {
  final AppDatabase _db;

  FuelRepository(this._db);

  Stream<List<FuelEntry>> watchAll(String vehicleId) {
    return (_db.select(_db.fuelEntries)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .asyncMap((rows) async {
          // Sort rows chronologically by odometer to calculate mileage correctly
          final sortedRows = List<FuelEntryData>.from(rows)
            ..sort((a, b) => a.odometer.compareTo(b.odometer));

          final entryMap = <String, FuelEntry>{};
          for (var i = 0; i < sortedRows.length; i++) {
            final current = sortedRows[i];
            final previousOdometer = i > 0 ? sortedRows[i - 1].odometer : null;
            entryMap[current.id] = FuelEntry.fromDrift(
              current,
              previousOdometer: previousOdometer,
            );
          }

          // Return entries in the original date desc order
          return rows.map((row) => entryMap[row.id]!).toList();
        });
  }

  Future<void> insert(FuelEntry entry) async {
    await _db
        .into(_db.fuelEntries)
        .insert(
          FuelEntriesCompanion.insert(
            id: entry.id,
            vehicleId: entry.vehicleId,
            date: entry.date.toIso8601String(),
            fuelCost: entry.fuelCost,
            fuelLiters: entry.fuelLiters,
            odometer: entry.odometer,
            station: Value(entry.station),
            notes: Value(entry.notes),
          ),
        );
  }

  Future<void> update(FuelEntry entry) async {
    await (_db.update(
      _db.fuelEntries,
    )..where((t) => t.id.equals(entry.id))).write(
      FuelEntriesCompanion(
        vehicleId: Value(entry.vehicleId),
        date: Value(entry.date.toIso8601String()),
        fuelCost: Value(entry.fuelCost),
        fuelLiters: Value(entry.fuelLiters),
        odometer: Value(entry.odometer),
        station: Value(entry.station),
        notes: Value(entry.notes),
      ),
    );
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.fuelEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<double> getMonthlySpend(String vehicleId, DateTime month) async {
    final start = DateTime(month.year, month.month, 1).toIso8601String();
    final nextMonth = month.month == 12 ? 1 : month.month + 1;
    final nextYear = month.month == 12 ? month.year + 1 : month.year;
    final end = DateTime(nextYear, nextMonth, 0, 23, 59, 59).toIso8601String();

    final query = _db.selectOnly(_db.fuelEntries)
      ..addColumns([_db.fuelEntries.fuelCost.sum()])
      ..where(
        _db.fuelEntries.vehicleId.equals(vehicleId) &
            _db.fuelEntries.date.isBetweenValues(start, end),
      );

    final result = await query.getSingle();
    return result.read(_db.fuelEntries.fuelCost.sum()) ?? 0.0;
  }

  Future<List<Map<String, double>>> getDailySpend(
    String vehicleId,
    int days,
  ) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days)).toIso8601String();

    final query = _db.selectOnly(_db.fuelEntries)
      ..addColumns([_db.fuelEntries.date, _db.fuelEntries.fuelCost.sum()])
      ..where(
        _db.fuelEntries.vehicleId.equals(vehicleId) &
            _db.fuelEntries.date.isBiggerOrEqualValue(start),
      )
      ..groupBy([_db.fuelEntries.date]);

    final rows = await query.get();
    return rows
        .map(
          (row) => {
            'date': DateTime.parse(
              row.read(_db.fuelEntries.date) as String,
            ).millisecondsSinceEpoch.toDouble(),
            'cost': row.read(_db.fuelEntries.fuelCost.sum()) ?? 0.0,
          },
        )
        .toList();
  }
}

@Riverpod(keepAlive: true)
FuelRepository fuelRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return FuelRepository(db);
}
