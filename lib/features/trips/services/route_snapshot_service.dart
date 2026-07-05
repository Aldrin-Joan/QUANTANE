// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/features/trips/services/route_processing_service.dart';
import 'package:quantane/features/trips/widgets/route_snapshot_host.dart';
import 'package:quantane/features/trips/widgets/trip_map_style.dart';

abstract class RouteSnapshotWriter {
  Future<String?> writeSnapshot({
    required String tripId,
    required ProcessedRoute route,
  });
}

class RouteSnapshotService implements RouteSnapshotWriter {
  RouteSnapshotService({GlobalKey<RouteSnapshotHostState>? hostKey})
    : hostKey = hostKey ?? routeSnapshotHostKey;
  final GlobalKey<RouteSnapshotHostState> hostKey;

  @override
  Future<String?> writeSnapshot({
    required String tripId,
    required ProcessedRoute route,
  }) async {
    try {
      final hostState = hostKey.currentState;
      if (hostState == null) {
        debugPrint('Route snapshot host is not mounted.');
        return null;
      }

      final bytes = await hostState
          .capture(route)
          .timeout(
            TripMapStyle.snapshotTimeout,
            onTimeout: () {
              debugPrint('Route snapshot capture timed out for $tripId.');
              return null;
            },
          );
      if (bytes == null || bytes.isEmpty) {
        return null;
      }

      final file = await TripSnapshotStorage.snapshotFile(tripId);
      await file.writeAsBytes(bytes, flush: true);
      return TripSnapshotStorage.relativeSnapshotPath(tripId);
    } catch (error, stack) {
      debugPrint('Route snapshot generation failed: $error\n$stack');
      return null;
    }
  }
}

class FakeRouteSnapshotWriter implements RouteSnapshotWriter {
  FakeRouteSnapshotWriter({this.onWrite});
  final Future<String?> Function({
    required String tripId,
    required ProcessedRoute route,
  })?
  onWrite;

  @override
  Future<String?> writeSnapshot({
    required String tripId,
    required ProcessedRoute route,
  }) {
    if (onWrite != null) {
      return onWrite!(tripId: tripId, route: route);
    }
    return Future.value('trip_snapshots/$tripId.png');
  }
}
