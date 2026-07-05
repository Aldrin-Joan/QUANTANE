// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

enum TripPermissionStatus {
  unknown,
  granted,
  denied,
  permanentlyDenied,
  restricted,
  serviceDisabled,
  unavailable,
}

class TripLocationPermission {

  const TripLocationPermission(this.status);
  final TripPermissionStatus status;

  bool get canTrack => status == TripPermissionStatus.granted;

  bool get needsUserAction => status != TripPermissionStatus.granted;

  String get message {
    switch (status) {
      case TripPermissionStatus.unknown:
        return 'Checking location access...';
      case TripPermissionStatus.granted:
        return 'Location access is available.';
      case TripPermissionStatus.denied:
        return 'Location permission is required to start trip tracking.';
      case TripPermissionStatus.permanentlyDenied:
        return 'Location permission is permanently denied. Open app settings to enable it.';
      case TripPermissionStatus.restricted:
        return 'Location access is restricted on this device.';
      case TripPermissionStatus.serviceDisabled:
        return 'Location services are turned off on this device.';
      case TripPermissionStatus.unavailable:
        return 'Location access is unavailable on this platform.';
    }
  }

  String? get actionLabel {
    switch (status) {
      case TripPermissionStatus.denied:
        return 'Allow location';
      case TripPermissionStatus.permanentlyDenied:
      case TripPermissionStatus.restricted:
        return 'Open app settings';
      case TripPermissionStatus.serviceDisabled:
        return 'Open location settings';
      case TripPermissionStatus.unavailable:
        return 'Open app settings';
      case TripPermissionStatus.unknown:
      case TripPermissionStatus.granted:
        return null;
    }
  }
}

class TripNotificationPermission {

  const TripNotificationPermission(this.status);
  final TripPermissionStatus status;

  bool get isGranted => status == TripPermissionStatus.granted;

  bool get needsUserAction => status != TripPermissionStatus.granted;

  String get message {
    switch (status) {
      case TripPermissionStatus.unknown:
        return 'Checking notification access...';
      case TripPermissionStatus.granted:
        return 'Notifications are enabled.';
      case TripPermissionStatus.denied:
        return 'Notifications are off. Trip tracking still works, but notifications make it easier to follow progress.';
      case TripPermissionStatus.permanentlyDenied:
        return 'Notifications are permanently denied. Open app settings if you want trip updates.';
      case TripPermissionStatus.restricted:
        return 'Notifications are restricted on this device.';
      case TripPermissionStatus.serviceDisabled:
        return 'Notifications are unavailable on this device.';
      case TripPermissionStatus.unavailable:
        return 'Notifications are unavailable on this platform.';
    }
  }

  String? get actionLabel {
    switch (status) {
      case TripPermissionStatus.denied:
        return 'Allow notifications';
      case TripPermissionStatus.permanentlyDenied:
      case TripPermissionStatus.restricted:
      case TripPermissionStatus.serviceDisabled:
      case TripPermissionStatus.unavailable:
        return 'Open app settings';
      case TripPermissionStatus.unknown:
      case TripPermissionStatus.granted:
        return null;
    }
  }
}

class TripPermissionState {

  const TripPermissionState({
    required this.location,
    required this.notification,
    required this.isRefreshing,
  });

  factory TripPermissionState.loading() => const TripPermissionState(
    location: TripLocationPermission(TripPermissionStatus.unknown),
    notification: TripNotificationPermission(TripPermissionStatus.unknown),
    isRefreshing: true,
  );
  final TripLocationPermission location;
  final TripNotificationPermission notification;
  final bool isRefreshing;

  bool get canStartTrip => !isRefreshing && location.canTrack;

  bool get hasBlockingLocationIssue => !isRefreshing && !location.canTrack;

  bool get shouldWarnAboutNotifications =>
      !isRefreshing && notification.needsUserAction;

  String? get blockingLocationMessage =>
      hasBlockingLocationIssue ? location.message : null;

  String? get notificationMessage =>
      shouldWarnAboutNotifications ? notification.message : null;

  TripPermissionState copyWith({
    TripLocationPermission? location,
    TripNotificationPermission? notification,
    bool? isRefreshing,
  }) {
    return TripPermissionState(
      location: location ?? this.location,
      notification: notification ?? this.notification,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class TripPermissionEvaluator {
  static Future<TripPermissionState> loadCurrent() async {
    final location = await _loadLocationPermission();
    final notification = await _loadNotificationPermission();
    return TripPermissionState(
      location: location,
      notification: notification,
      isRefreshing: false,
    );
  }

  static Future<TripLocationPermission> _loadLocationPermission() async {
    final servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      return const TripLocationPermission(TripPermissionStatus.serviceDisabled);
    }

    final permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return const TripLocationPermission(TripPermissionStatus.granted);
      case LocationPermission.denied:
        return const TripLocationPermission(TripPermissionStatus.denied);
      case LocationPermission.deniedForever:
        return const TripLocationPermission(
          TripPermissionStatus.permanentlyDenied,
        );
      case LocationPermission.unableToDetermine:
        return const TripLocationPermission(TripPermissionStatus.unavailable);
    }
  }

  static Future<TripNotificationPermission>
  _loadNotificationPermission() async {
    final permission =
        await FlutterForegroundTask.checkNotificationPermission();
    switch (permission) {
      case NotificationPermission.granted:
        return const TripNotificationPermission(TripPermissionStatus.granted);
      case NotificationPermission.denied:
        return const TripNotificationPermission(TripPermissionStatus.denied);
      case NotificationPermission.permanently_denied:
        return const TripNotificationPermission(
          TripPermissionStatus.permanentlyDenied,
        );
    }
  }

  static Future<void> openLocationSettings() =>
      Geolocator.openLocationSettings();

  static Future<void> openAppSettings() => Geolocator.openAppSettings();

  static Future<void> requestLocationPermission() async {
    final current = await _loadLocationPermission();
    switch (current.status) {
      case TripPermissionStatus.serviceDisabled:
        await Geolocator.openLocationSettings();
        return;
      case TripPermissionStatus.permanentlyDenied:
      case TripPermissionStatus.restricted:
      case TripPermissionStatus.unavailable:
        await Geolocator.openAppSettings();
        return;
      case TripPermissionStatus.denied:
        await Geolocator.requestPermission();
        return;
      case TripPermissionStatus.unknown:
      case TripPermissionStatus.granted:
        return;
    }
  }

  static Future<void> requestNotificationPermission() async {
    await FlutterForegroundTask.requestNotificationPermission();
  }
}

class TripPermissionsController with WidgetsBindingObserver {
  TripPermissionsController({TripPermissionState? initialState})
    : _state = initialState ?? TripPermissionState.loading() {
    WidgetsBinding.instance.addObserver(this);
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((
      _,
    ) {
      unawaited(refresh());
    });
    unawaited(refresh());
  }

  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;
  Future<TripPermissionState>? _refreshFuture;
  TripPermissionState _state;
  final StreamController<TripPermissionState> _stateController =
      StreamController<TripPermissionState>.broadcast();

  TripPermissionState get state => _state;

  set state(TripPermissionState value) {
    _state = value;
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }

  Stream<TripPermissionState> get stream {
    return Stream<TripPermissionState>.multi((controller) {
      controller.add(_state);
      final subscription = _stateController.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller.onCancel = subscription.cancel;
    });
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_serviceStatusSubscription?.cancel());
    _serviceStatusSubscription = null;
    unawaited(_stateController.close());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(refresh());
    }
  }

  Future<TripPermissionState> refresh() {
    return _refreshFuture ??= _refresh().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<TripPermissionState> _refresh() async {
    final snapshot = await TripPermissionEvaluator.loadCurrent();
    state = snapshot;
    return snapshot;
  }

  Future<void> requestLocationAccess() async {
    await TripPermissionEvaluator.requestLocationPermission();
    await refresh();
  }

  Future<void> requestNotificationAccess() async {
    await TripPermissionEvaluator.requestNotificationPermission();
    await refresh();
  }

  Future<void> openLocationSettings() =>
      TripPermissionEvaluator.openLocationSettings();

  Future<void> openAppSettings() => TripPermissionEvaluator.openAppSettings();
}

final tripPermissionsControllerProvider = Provider<TripPermissionsController>((
  ref,
) {
  final controller = TripPermissionsController();
  ref.onDispose(controller.dispose);
  return controller;
});

final tripPermissionsProvider = StreamProvider<TripPermissionState>((ref) {
  final controller = ref.watch(tripPermissionsControllerProvider);
  return controller.stream;
});
