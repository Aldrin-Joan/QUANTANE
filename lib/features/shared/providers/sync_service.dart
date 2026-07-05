// Dart imports:
import 'dart:async';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_service.g.dart';

enum SyncStateStatus { idle, syncing, success, error }

class SyncProgress {

  SyncProgress({
    required this.status,
    this.lastSyncTime,
    this.pendingOpsCount = 0,
    this.errorMessage,
  });
  final SyncStateStatus status;
  final String? lastSyncTime;
  final int pendingOpsCount;
  final String? errorMessage;

  SyncProgress copyWith({
    SyncStateStatus? status,
    String? lastSyncTime,
    int? pendingOpsCount,
    String? errorMessage,
  }) {
    return SyncProgress(
      status: status ?? this.status,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      pendingOpsCount: pendingOpsCount ?? this.pendingOpsCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@Riverpod(keepAlive: true)
class SyncService extends _$SyncService {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  SyncProgress build() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.isNotEmpty && results.first != ConnectivityResult.none;
      if (hasConnection) {
        state = SyncProgress(
          status: SyncStateStatus.success,
          lastSyncTime: 'Just now',
        );
      } else {
        state = SyncProgress(
          status: SyncStateStatus.idle,
          lastSyncTime: 'Offline (cached)',
        );
      }
    });

    ref.onDispose(() {
      _connectivitySubscription?.cancel();
    });

    return SyncProgress(
      status: SyncStateStatus.success,
      lastSyncTime: 'Just now',
    );
  }

  Future<void> syncNow() async {
    state = state.copyWith(status: SyncStateStatus.syncing);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(
      status: SyncStateStatus.success,
      lastSyncTime: 'Just now',
    );
  }
}
