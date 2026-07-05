import 'package:flutter_test/flutter_test.dart';
import 'package:quantane/features/trips/trip_permissions.dart';

void main() {
  test('location denied is blocking while notification denied is advisory', () {
    const state = TripPermissionState(
      location: const TripLocationPermission(TripPermissionStatus.denied),
      notification: const TripNotificationPermission(
        TripPermissionStatus.denied,
      ),
      isRefreshing: false,
    );

    expect(state.canStartTrip, isFalse);
    expect(state.hasBlockingLocationIssue, isTrue);
    expect(state.blockingLocationMessage, isNotNull);
    expect(state.shouldWarnAboutNotifications, isTrue);
    expect(state.notificationMessage, contains('Trip tracking still works'));
  });

  test('gps disabled blocks trip start', () {
    const state = TripPermissionState(
      location: const TripLocationPermission(
        TripPermissionStatus.serviceDisabled,
      ),
      notification: const TripNotificationPermission(
        TripPermissionStatus.granted,
      ),
      isRefreshing: false,
    );

    expect(state.canStartTrip, isFalse);
    expect(
      state.blockingLocationMessage,
      contains('Location services are turned off'),
    );
    expect(state.location.actionLabel, 'Open location settings');
  });

  test('notification denied remains non-blocking', () {
    const state = TripPermissionState(
      location: const TripLocationPermission(TripPermissionStatus.granted),
      notification: const TripNotificationPermission(
        TripPermissionStatus.denied,
      ),
      isRefreshing: false,
    );

    expect(state.canStartTrip, isTrue);
    expect(state.shouldWarnAboutNotifications, isTrue);
    expect(state.notification.actionLabel, 'Allow notifications');
  });

  test('granted location allows trip start', () {
    const state = TripPermissionState(
      location: const TripLocationPermission(TripPermissionStatus.granted),
      notification: const TripNotificationPermission(
        TripPermissionStatus.granted,
      ),
      isRefreshing: false,
    );

    expect(state.canStartTrip, isTrue);
    expect(state.hasBlockingLocationIssue, isFalse);
    expect(state.shouldWarnAboutNotifications, isFalse);
  });
}
