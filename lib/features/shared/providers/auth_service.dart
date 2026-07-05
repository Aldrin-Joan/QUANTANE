// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';

part 'auth_service.g.dart';

class AuthState {
  AuthState({
    this.user,
    this.isSyncEnabled = true,
    this.errorMessage,
    this.isLoading = false,
  });
  final User? user;
  final bool isSyncEnabled;
  final String? errorMessage;
  final bool isLoading;

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
    final isSyncEnabled = prefs.getBool(_syncKey) ?? true;

    try {
      if (isSyncEnabled) {
        await FirebaseFirestore.instance.enableNetwork();
      } else {
        await FirebaseFirestore.instance.disableNetwork();
      }
    } catch (_) {}

    _authSubscription?.cancel();
    _authSubscription = _auth.authStateChanges().listen((User? user) async {
      final freshPrefs = await SharedPreferences.getInstance();
      final currentSyncEnabled = freshPrefs.getBool(_syncKey) ?? true;

      var currentUser = user;
      if (currentUser == null) {
        try {
          final credential = await _auth.signInAnonymously();
          currentUser = credential.user;
        } catch (_) {}
      }

      state = AuthState(
        user: currentUser,
        isSyncEnabled: currentSyncEnabled,
        isLoading: false,
      );
    });
  }

  Future<void> enableSync() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_syncKey, true);
      try {
        await FirebaseFirestore.instance.enableNetwork();
      } catch (_) {}

      state = state.copyWith(
        isSyncEnabled: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to enable sync: $e',
      );
    }
  }

  Future<void> disableSync() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_syncKey, false);
      try {
        await FirebaseFirestore.instance.disableNetwork();
      } catch (_) {}

      state = state.copyWith(
        isSyncEnabled: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to disable sync: $e',
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
        if (e.code == 'email-already-in-use' ||
            e.code == 'credential-already-in-use') {
          // Fallback: Sign in directly to merge or load existing cloud data
          final authResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(_syncKey, true);

          state = AuthState(
            user: authResult.user,
          );
        } else {
          rethrow;
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Linking account failed: $e',
      );
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentUserBefore = _auth.currentUser;
      final isGuest =
          currentUserBefore == null || currentUserBefore.isAnonymous;

      if (!isGuest) {
        await _clearLocalDatabaseAndPreferences();
      }

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return; // User cancelled
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await _auth.signInWithCredential(credential);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_syncKey, true);

      state = AuthState(
        user: authResult.user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Google Sign-in failed: $e',
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

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return; // User cancelled
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final authResult = await user.linkWithCredential(credential);
        state = state.copyWith(user: authResult.user, isLoading: false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use' ||
            e.code == 'credential-already-in-use') {
          // Fallback: Sign in directly to load existing cloud data
          final authResult = await _auth.signInWithCredential(credential);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(_syncKey, true);

          state = AuthState(
            user: authResult.user,
          );
        } else {
          rethrow;
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Linking Google account failed: $e',
      );
      rethrow;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentUserBefore = _auth.currentUser;
      final isGuest =
          currentUserBefore == null || currentUserBefore.isAnonymous;

      if (!isGuest) {
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
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Sign-in failed: $e',
      );
      rethrow;
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final currentUserBefore = _auth.currentUser;
      final isGuest =
          currentUserBefore == null || currentUserBefore.isAnonymous;

      if (!isGuest) {
        await _clearLocalDatabaseAndPreferences();
      }

      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_syncKey, true);

      state = AuthState(
        user: authResult.user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Registration failed: $e',
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _clearLocalDatabaseAndPreferences();
      await _auth.signOut();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Logout failed: $e',
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
    await ref.read(activeVehicleProvider.notifier).clear();
  }
}
