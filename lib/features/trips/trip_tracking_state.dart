// Project imports:
import 'package:quantane/features/trips/trip_providers.dart';
import 'package:quantane/features/trips/trip_session_models.dart';

class TripTrackingState {
  const TripTrackingState({required this.session, required this.status});
  final TripState? session;
  final TripTrackingStatus status;

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
