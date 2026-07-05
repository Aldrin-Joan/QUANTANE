// Dart imports:
import 'dart:io';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:quantane/domain/models/trip.dart';

part 'trip_repository.g.dart';

class TripSnapshotStorage {
  static const String snapshotsFolderName = 'trip_snapshots';

  static Future<Directory> Function()? documentsDirectoryOverride;

  static Future<Directory> _documentsDirectory() {
    return documentsDirectoryOverride?.call() ??
        getApplicationDocumentsDirectory();
  }

  static Future<Directory> snapshotsDirectory() async {
    final documentsDir = await _documentsDirectory();
    final directory = Directory('${documentsDir.path}/$snapshotsFolderName');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  static String relativeSnapshotPath(String tripId) {
    return '$snapshotsFolderName/$tripId.png';
  }

  static Future<File> snapshotFile(String tripId) async {
    final directory = await snapshotsDirectory();
    return File('${directory.path}/$tripId.png');
  }

  static Future<void> deleteSnapshot(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) {
      return;
    }

    try {
      final documentsDir = await _documentsDirectory();
      final file = File('${documentsDir.path}/$relativePath');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Best-effort cleanup.
    }
  }
}

class TripRepository {

  TripRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore,
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
    return fs.collection('users').doc(uid).collection('trips');
  }

  Stream<List<Trip>> watchAll(String vehicleId) {
    final col = _collection;
    if (col == null) return Stream.value(const []);

    return col
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Trip.fromJson(doc.data())).toList());
  }

  Future<Trip?> getById(String id) async {
    final col = _collection;
    if (col == null) return null;
    final doc = await col.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return Trip.fromJson(doc.data()!);
  }

  Future<void> insert(Trip trip, {bool syncToFirebase = true}) async {
    final col = _collection;
    if (col == null) return;

    final now = DateTime.now().toUtc();
    final updatedTrip = trip.lastUpdated == null
        ? trip.copyWith(lastUpdated: now, startTime: trip.startTime.toUtc(), endTime: trip.endTime?.toUtc())
        : trip.copyWith(startTime: trip.startTime.toUtc(), endTime: trip.endTime?.toUtc(), lastUpdated: trip.lastUpdated?.toUtc());

    await col.doc(updatedTrip.id).set(
          updatedTrip.toJson(),
          SetOptions(merge: true),
        );
  }

  Future<void> delete(String id, {bool syncToFirebase = true}) async {
    final col = _collection;
    if (col == null) return;

    final existing = await getById(id);
    await col.doc(id).delete();
    await TripSnapshotStorage.deleteSnapshot(existing?.routeSnapshotPath);
  }
}

@Riverpod(keepAlive: true)
TripRepository tripRepository(Ref ref) {
  return TripRepository();
}

@riverpod
Future<Trip?> tripById(Ref ref, String tripId) {
  return ref.watch(tripRepositoryProvider).getById(tripId);
}
