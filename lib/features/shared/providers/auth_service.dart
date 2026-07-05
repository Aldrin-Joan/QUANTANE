import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quantane/data/database/database_provider.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_service.g.dart';

class AuthState {
  final User? user;
  final bool isSyncEnabled;
  final String? errorMessage;
  final bool isLoading;

  AuthState({
    this.user,
    this.isSyncEnabled = false,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    User? user,
    bool? isSyncEnabled,
    String? errorMessage,
    bool? isLoading,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isSyncEnabled: isSyncEnabled ?? this.isSyncEnabled,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@Riverpod(keepAlive: true)
class AuthService extends _$AuthService {
  static const _syncKey = 'cloud_sync_enabled';
  late final FirebaseAuth _auth;
  StreamSubscription<User?>? _authSubscription;

  @override
  AuthState build() {
    _auth = FirebaseAuth.instance;
    _init();
    ref.onDispose(() {
      _authSubscription?.cancel();
    });
    return AuthState(isLoading: true);
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final isSyncEnabled = prefs.getBool(_syncKey) ?? false;

    _authSubscription?.cancel();
    _authSubscription = _auth.authStateChanges().listen((User? user) async {
      state = AuthState(
        user: user,
        isSyncEnabled: isSyncEnabled,
        isLoading: false,
      );

      // Auto sign-in anonymously if sync is enabled but no current user is authenticated
      if (isSyncEnabled && user == null) {
        await enableSync();
      }
    });
  }

  Future<void> enableSync() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_syncKey, true);

      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        final credential = await _auth.signInAnonymously();
        currentUser = credential.user;
      }

      state = AuthState(
        user: currentUser,
        isSyncEnabled: true,
        isLoading: false,
      );

      // Trigger initial migration of offline data to Firestore
      await _triggerInitialBulkUpload();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to enable sync: ${e.toString()}',
      );
    }
  }

  Future<void> disableSync() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_syncKey, false);

      await _auth.signOut();
      state = AuthState(user: null, isSyncEnabled: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to disable sync: ${e.toString()}',
      );
    }
  }

  Future<void> linkEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No logged-in guest account found to link.');
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      try {
        final authResult = await user.linkWithCredential(credential);
        state = state.copyWith(user: authResult.user, isLoading: false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use' || e.code == 'credential-already-in-use') {
          // Fallback: Sign in directly and merge guest data
          final authResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(_syncKey, true);

          state = AuthState(
            user: authResult.user,
            isSyncEnabled: true,
            isLoading: false,
          );

          // Trigger initial migration of guest data to the existing account
          await _triggerInitialBulkUpload();
        } else {
          rethrow;
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Linking account failed: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentUserBefore = _auth.currentUser;
      final isGuest = currentUserBefore == null || currentUserBefore.isAnonymous;

      if (!isGuest) {
        // Clear local database to isolate user accounts, preventing data contamination
        await _clearLocalDatabaseAndPreferences();
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await _auth.signInWithCredential(credential);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_syncKey, true);

      state = AuthState(
        user: authResult.user,
        isSyncEnabled: true,
        isLoading: false,
      );

      // Merge guest data into the newly logged in account
      if (isGuest) {
        await _triggerInitialBulkUpload();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Google Sign-in failed: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<void> linkGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No logged-in guest account found to link.');
      }

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final authResult = await user.linkWithCredential(credential);
        state = state.copyWith(user: authResult.user, isLoading: false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use' || e.code == 'credential-already-in-use') {
          // Fallback: Sign in directly and merge guest data
          final authResult = await _auth.signInWithCredential(credential);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(_syncKey, true);

          state = AuthState(
            user: authResult.user,
            isSyncEnabled: true,
            isLoading: false,
          );

          await _triggerInitialBulkUpload();
        } else {
          rethrow;
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Linking Google account failed: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentUserBefore = _auth.currentUser;
      final isGuest = currentUserBefore == null || currentUserBefore.isAnonymous;

      if (!isGuest) {
        // Clear local database to isolate user accounts, preventing data contamination
        await _clearLocalDatabaseAndPreferences();
      }

      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_syncKey, true);

      state = AuthState(
        user: authResult.user,
        isSyncEnabled: true,
        isLoading: false,
      );

      // Merge guest data into the newly logged in account
      if (isGuest) {
        await _triggerInitialBulkUpload();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Sign-in failed: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentUserBefore = _auth.currentUser;
      final isGuest = currentUserBefore == null || currentUserBefore.isAnonymous;

      if (!isGuest) {
        // Clear local database to isolate user accounts, preventing data contamination
        await _clearLocalDatabaseAndPreferences();
      }

      // Create account
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_syncKey, true);

      state = AuthState(
        user: authResult.user,
        isSyncEnabled: true,
        isLoading: false,
      );

      // Perform initial upload if we had guest data (signed up directly)
      if (isGuest) {
        await _triggerInitialBulkUpload();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Registration failed: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _clearLocalDatabaseAndPreferences();
      await _auth.signOut();

      state = AuthState(user: null, isSyncEnabled: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Logout failed: ${e.toString()}',
      );
    }
  }

  Future<void> _clearLocalDatabaseAndPreferences() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_sync_timestamp_$uid');
      await prefs.remove('last_sync_time_$uid');
    }

    final db = ref.read(appDatabaseProvider);
    await db.clearAllData();
    await ref.read(activeVehicleProvider.notifier).clear();
  }

  Future<void> _triggerInitialBulkUpload() async {
    // This helper maps existing offline items to the SyncQueue for immediate sync
    final db = ref.read(appDatabaseProvider);
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    // Run in transaction to maintain database consistency
    await db.transaction(() async {
      // 1. Queue all local Vehicles
      final localVehicles = await db.select(db.vehicles).get();
      for (final vehicle in localVehicles) {
        // Only queue if not already synced or needs syncing
        await db.queueSync(
          action: 'INSERT',
          entityType: 'vehicles',
          entityId: vehicle.id,
          payload:
              null, // SyncService will read the state directly from database when processing
        );
      }

      // 2. Queue all Fuel Entries
      final localFuel = await db.select(db.fuelEntries).get();
      for (final fuel in localFuel) {
        await db.queueSync(
          action: 'INSERT',
          entityType: 'fuel_entries',
          entityId: fuel.id,
          payload: null,
        );
      }

      // 3. Queue all Trips
      final localTrips = await db.select(db.trips).get();
      for (final trip in localTrips) {
        await db.queueSync(
          action: 'INSERT',
          entityType: 'trips',
          entityId: trip.id,
          payload: null,
        );
      }
    });
  }
}
