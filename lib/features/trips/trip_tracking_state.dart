import 'package:quantane/features/trips/trip_session_models.dart';
import 'package:quantane/features/trips/trip_providers.dart';

class TripTrackingState {
  final TripState? session;
  final TripTrackingStatus status;

  const TripTrackingState({required this.session, required this.status});

  TripTrackingState copyWith({
    TripState? session,
    bool clearSession = false,
    TripTrackingStatus? status,
  }) {
    return TripTrackingState(
      session: clearSession ? null : (session ?? this.session),
      status: status ?? this.status,
    );
  }
}
