import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quantane/data/repositories/active_trip_session_repository.dart';
import 'package:quantane/features/trips/trip_permissions.dart';
import 'package:quantane/features/trips/trip_session_models.dart';
import 'package:uuid/uuid.dart';

typedef PositionStreamFactory =
    Stream<Position> Function({LocationSettings? locationSettings});

const String _tripUpdateEvent = 'quantane.trip.update';
const String _tripStopEvent = 'quantane.trip.stop';
const String _tripSpeedEvent = 'quantane.trip.speed';

@pragma('vm:entry-point')
void tripTrackingTaskEntryPoint() {
  FlutterForegroundTask.setTaskHandler(_TripTaskHandler());
}

class TripTrackingService {
  TripTrackingService({ActiveTripSessionRepository? sessionRepository})
    : _sessionRepository = sessionRepository ?? ActiveTripSessionRepository();

  final ActiveTripSessionRepository _sessionRepository;
  final StreamController<TripState?> _stateController =
      StreamController<TripState?>.broadcast();

  TripState? _currentState;
  bool _initialized = false;

  Stream<TripState?> watchState() => _stateController.stream;

  TripState? get currentState => _currentState;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    if (kIsWeb || const bool.fromEnvironment('FLUTTER_TEST')) {
      _initialized = true;
      await restorePersistedSession();
      return;
    }

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'quantane_trip_tracking',
        channelName: 'Trip tracking',
        channelDescription: 'Persistent trip tracking notifications',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
      ),
    );

    FlutterForegroundTask.addTaskDataCallback(_onTaskDataReceived);
    _initialized = true;
    await restorePersistedSession();
  }

  Future<TripState?> restorePersistedSession() async {
    final persisted = await _sessionRepository.load();
    if (persisted == null) {
      _currentState = null;
      _stateController.add(null);
      return null;
    }

    _currentState = persisted;
    _stateController.add(persisted);
    return persisted;
  }

  Future<TripState> startTrip({required String vehicleId}) async {
    await initialize();
    await _ensureTrackingPermissions();

    final existing = await _sessionRepository.load();
    if (existing != null && existing.isActive) {
      _currentState = existing;
      _stateController.add(existing);
      await _startForegroundService(existing);
      return existing;
    }

    final now = DateTime.now();
    final session = TripState(
      sessionId: const Uuid().v4(),
      vehicleId: vehicleId,
      startTime: now,
      updatedAt: now,
      currentSpeed: 0,
      maxSpeed: 0,
      distance: 0,
      positions: const [],
    );

    await _sessionRepository.save(session);
    _currentState = session;
    _stateController.add(session);
    await _startForegroundService(session);
    return session;
  }

  Future<void> _ensureTrackingPermissions() async {
    final permissions = await TripPermissionEvaluator.loadCurrent();
    if (!permissions.location.canTrack) {
      throw StateError(permissions.location.message);
    }
  }

  Future<TripState?> stopTrip() async {
    await initialize();

    if (await FlutterForegroundTask.isRunningService) {
      final activeSession = _currentState ?? await _sessionRepository.load();
      if (activeSession == null) {
        return null;
      }

      final finalized = activeSession.copyWith(
        endTime: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      FlutterForegroundTask.sendDataToTask({
        'method': _tripStopEvent,
        'session': finalized.toJson(),
      });
      return finalized;
    }

    final activeSession = _currentState ?? await _sessionRepository.load();
    if (activeSession == null) {
      return null;
    }

    final finalized = activeSession.copyWith(
      endTime: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _currentState = finalized;
    _stateController.add(finalized);
    return finalized;
  }

  Future<void> dispose() async {
    FlutterForegroundTask.removeTaskDataCallback(_onTaskDataReceived);
    await _stateController.close();
  }

  Future<void> clearPersistedSession() async {
    await _sessionRepository.clear();
    _currentState = null;
    _stateController.add(null);
  }

  Future<void> _startForegroundService(TripState session) async {
    FlutterForegroundTask.startService(
      serviceId: 2042,
      notificationTitle: 'Trip tracking',
      notificationText: '${session.currentSpeed.toStringAsFixed(0)} km/h',
      notificationButtons: const [
        NotificationButton(id: _tripStopEvent, text: 'Stop Trip'),
        NotificationButton(id: _tripSpeedEvent, text: '0 km/h'),
      ],
      callback: tripTrackingTaskEntryPoint,
    );
  }

  void _onTaskDataReceived(Object data) {
    if (data is! Map) {
      return;
    }

    final payload = data.cast<String, Object?>();
    final method = payload['method'] as String?;
    if (method == _tripUpdateEvent) {
      final sessionMap = payload['session'] as Map<dynamic, dynamic>?;
      if (sessionMap == null) {
        return;
      }

      final session = TripState.fromJson(sessionMap.cast<String, Object?>());
      _currentState = session;

      // We don't want to unawaited save here if we can help it,
      // but TripTrackingService doesn't have a good way to wait.
      // The session is already saved by the background task if stopped there.
      unawaited(_sessionRepository.save(session));
      _stateController.add(session);
      return;
    }
  }
}

@pragma('vm:entry-point')
class _TripTaskHandler extends TaskHandler {
  final ActiveTripSessionRepository _sessionRepository =
      ActiveTripSessionRepository();
  final TripMetricsCalculator _metricsCalculator = TripMetricsCalculator();
  StreamSubscription<Position>? _subscription;
  TripState? _currentState;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _currentState = await _sessionRepository.load();
    if (_currentState == null) {
      await FlutterForegroundTask.stopService();
      return;
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );

    _subscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(_handlePosition, onError: _handleError);
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _subscription?.cancel();
    _subscription = null;
  }

  @override
  void onReceiveData(Object data) {
    if (data is! Map) {
      return;
    }

    final payload = data.cast<String, Object?>();
    if (payload['method'] == _tripStopEvent) {
      unawaited(_stopAndFinalize());
    }
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == _tripStopEvent) {
      unawaited(_stopAndFinalize());
    }
  }

  Future<void> _handlePosition(Position position) async {
    final current = _currentState;
    if (current == null) {
      await _stopAndFinalize();
      return;
    }

    final updated = _metricsCalculator.update(current, position);
    _currentState = updated;

    // DEBUG LOGGING
    debugPrint(
      '[TRIP_DEBUG] Lat: ${position.latitude}, Lon: ${position.longitude}, '
      'SensorSpeed: ${(position.speed * 3.6).toStringAsFixed(1)} KM/H, '
      'Accuracy: ${position.accuracy}m, '
      'FinalCalcSpeed: ${updated.currentSpeed.toStringAsFixed(1)} KM/H',
    );

    await _sessionRepository.save(updated);
    await FlutterForegroundTask.updateService(
      notificationTitle: 'Trip tracking',
      notificationText: '${updated.currentSpeed.toStringAsFixed(0)} km/h',
      notificationButtons: [
        const NotificationButton(id: _tripStopEvent, text: 'Stop Trip'),
        NotificationButton(
          id: _tripSpeedEvent,
          text: '${updated.currentSpeed.toStringAsFixed(0)} km/h',
        ),
      ],
    );
    FlutterForegroundTask.sendDataToMain({
      'method': _tripUpdateEvent,
      'session': updated.toJson(),
    });
  }

  void _handleError(Object error) {
    FlutterForegroundTask.sendDataToMain({
      'method': 'quantane.trip.error',
      'message': error.toString(),
    });
  }

  Future<void> _stopAndFinalize() async {
    final current = _currentState ?? await _sessionRepository.load();
    await _subscription?.cancel();
    _subscription = null;

    if (current != null) {
      final finalized = current.copyWith(
        endTime: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // CRITICAL: Save the finalized session so it can be recovered if main process is dead.
      await _sessionRepository.save(finalized);

      FlutterForegroundTask.sendDataToMain({
        'method': _tripUpdateEvent,
        'session': finalized.toJson(),
      });
    }

    await FlutterForegroundTask.stopService();
  }
}
