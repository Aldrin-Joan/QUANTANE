// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:quantane/domain/models/fuel_entry.dart';

part 'fuel_repository.g.dart';

class FuelRepository {
  FuelRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore,
       _auth = auth;
  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;

  FirebaseFirestore? get _firestoreInstance {
    if (_firestore != null) return _firestore;
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  FirebaseAuth? get _authInstance {
    if (_auth != null) return _auth;
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  String? get _currentUid => _authInstance?.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _collection {
    final uid = _currentUid;
    final fs = _firestoreInstance;
    if (uid == null || fs == null) return null;
    return fs.collection('users').doc(uid).collection('fuel_entries');
  }

  Stream<List<FuelEntry>> watchAll(String vehicleId) {
    final col = _collection;
    if (col == null) return Stream.value(const []);

    return col.where('vehicleId', isEqualTo: vehicleId).snapshots().map((
      snapshot,
    ) {
      final entries = snapshot.docs
          .map((doc) => FuelEntry.fromJson(doc.data()))
          .toList();

      // Sort chronologically by date and odometer to calculate previousOdometer
      final sortedEntries = List<FuelEntry>.from(entries)
        ..sort((a, b) {
          final dateCompare = a.date.compareTo(b.date);
          if (dateCompare != 0) return dateCompare;
          return a.odometer.compareTo(b.odometer);
        });

      final entryMap = <String, FuelEntry>{};
      for (var i = 0; i < sortedEntries.length; i++) {
        final current = sortedEntries[i];
        final previousOdometer = i > 0 ? sortedEntries[i - 1].odometer : null;
        entryMap[current.id] = current.calculateMetrics(previousOdometer);
      }

      // Return entries in descending order of date (newest first)
      final result = entries.map((e) => entryMap[e.id]!).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return result;
    });
  }

  Future<void> insert(FuelEntry entry, {bool syncToFirebase = true}) async {
    final col = _collection;
    if (col == null) return;

    final now = DateTime.now().toUtc();
    final updatedEntry = entry.lastUpdated == null
        ? entry.copyWith(lastUpdated: now, date: entry.date.toUtc())
        : entry.copyWith(
            date: entry.date.toUtc(),
            lastUpdated: entry.lastUpdated?.toUtc(),
          );

    await col
        .doc(updatedEntry.id)
        .set(
          updatedEntry.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> update(FuelEntry entry, {bool syncToFirebase = true}) async {
    final col = _collection;
    if (col == null) return;

    final now = DateTime.now().toUtc();
    final updatedEntry = entry.copyWith(
      lastUpdated: now,
      date: entry.date.toUtc(),
    );

    await col
        .doc(updatedEntry.id)
        .set(
          updatedEntry.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> delete(String id, {bool syncToFirebase = true}) async {
    final col = _collection;
    if (col == null) return;
    await col.doc(id).delete();
  }

  Future<double> getMonthlySpend(String vehicleId, DateTime month) async {
    final col = _collection;
    if (col == null) return 0.0;

    final start = DateTime(month.year, month.month);
    final nextMonth = month.month == 12 ? 1 : month.month + 1;
    final nextYear = month.month == 12 ? month.year + 1 : month.year;
    final end = DateTime(nextYear, nextMonth, 0, 23, 59, 59);

    final snapshot = await col
        .where('vehicleId', isEqualTo: vehicleId)
        .where('date', isGreaterThanOrEqualTo: start.toUtc().toIso8601String())
        .where('date', isLessThanOrEqualTo: end.toUtc().toIso8601String())
        .get();

    var total = 0.0;
    for (final doc in snapshot.docs) {
      final cost = (doc.data()['fuelCost'] as num?)?.toDouble() ?? 0.0;
      total += cost;
    }
    return total;
  }

  Future<List<Map<String, double>>> getDailySpend(
    String vehicleId,
    int days,
  ) async {
    final col = _collection;
    if (col == null) return [];

    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));

    final snapshot = await col
        .where('vehicleId', isEqualTo: vehicleId)
        .where('date', isGreaterThanOrEqualTo: start.toUtc().toIso8601String())
        .get();

    final spendMap = <String, double>{};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final dateStr = data['date'] as String?;
      if (dateStr == null) continue;

      final date = DateTime.parse(dateStr).toLocal();
      final dateKey = DateTime(
        date.year,
        date.month,
        date.day,
      ).toIso8601String();
      final cost = (data['fuelCost'] as num?)?.toDouble() ?? 0.0;
      spendMap[dateKey] = (spendMap[dateKey] ?? 0.0) + cost;
    }

    final sortedList = spendMap.entries
        .map(
          (e) => {
            'date': DateTime.parse(e.key).millisecondsSinceEpoch.toDouble(),
            'cost': e.value,
          },
        )
        .toList();
    sortedList.sort((a, b) => a['date']!.compareTo(b['date']!));
    return sortedList;
  }
}

@Riverpod(keepAlive: true)
FuelRepository fuelRepository(Ref ref) {
  return FuelRepository();
}
