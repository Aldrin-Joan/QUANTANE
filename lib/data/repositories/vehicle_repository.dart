// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:quantane/domain/models/vehicle.dart';

part 'vehicle_repository.g.dart';

class VehicleRepository {
  VehicleRepository({
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
    return fs.collection('users').doc(uid).collection('vehicles');
  }

  Stream<List<Vehicle>> watchAll() {
    final col = _collection;
    if (col == null) return Stream.value(const []);
    return col
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Vehicle.fromJson(doc.data())).toList(),
        );
  }

  Future<Vehicle?> getById(String id) async {
    final col = _collection;
    if (col == null) return null;
    final doc = await col.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return Vehicle.fromJson(doc.data()!);
  }

  Future<void> insert(Vehicle vehicle, {bool syncToFirebase = true}) async {
    final col = _collection;
    if (col == null) return;

    final now = DateTime.now().toUtc();
    final updatedVehicle = vehicle.lastUpdated == null
        ? vehicle.copyWith(
            lastUpdated: now,
            createdAt: vehicle.createdAt.toUtc(),
          )
        : vehicle.copyWith(
            createdAt: vehicle.createdAt.toUtc(),
            lastUpdated: vehicle.lastUpdated?.toUtc(),
          );

    await col
        .doc(updatedVehicle.id)
        .set(
          updatedVehicle.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> update(Vehicle vehicle, {bool syncToFirebase = true}) async {
    final col = _collection;
    if (col == null) return;

    final now = DateTime.now().toUtc();
    final updatedVehicle = vehicle.copyWith(
      lastUpdated: now,
      createdAt: vehicle.createdAt.toUtc(),
    );

    await col
        .doc(updatedVehicle.id)
        .set(
          updatedVehicle.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> delete(String id, {bool syncToFirebase = true}) async {
    final col = _collection;
    if (col == null) return;
    await col.doc(id).delete();
  }

  Future<void> clearAllData() async {
    final uid = _currentUid;
    final fs = _firestoreInstance;
    if (uid == null || fs == null) return;

    final vehicles = await fs
        .collection('users')
        .doc(uid)
        .collection('vehicles')
        .get();
    for (final doc in vehicles.docs) {
      await doc.reference.delete();
    }

    final fuel = await fs
        .collection('users')
        .doc(uid)
        .collection('fuel_entries')
        .get();
    for (final doc in fuel.docs) {
      await doc.reference.delete();
    }

    final trips = await fs
        .collection('users')
        .doc(uid)
        .collection('trips')
        .get();
    for (final doc in trips.docs) {
      await doc.reference.delete();
    }
  }
}

@Riverpod(keepAlive: true)
VehicleRepository vehicleRepository(Ref ref) {
  return VehicleRepository();
}
