// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:quantane/data/repositories/geocoding_cache_repository.dart';
import 'package:quantane/features/trips/services/nominatim_geocoding_service.dart';
import 'package:quantane/features/trips/services/route_processing_service.dart';
import 'package:quantane/features/trips/services/route_simplifier.dart';
import 'package:quantane/features/trips/services/route_snapshot_service.dart';
import 'package:quantane/features/trips/services/trip_finalization_service.dart';
import 'package:quantane/features/trips/widgets/route_snapshot_host.dart';

part 'trip_finalization_providers.g.dart';

@Riverpod(keepAlive: true)
RouteSimplifier routeSimplifier(Ref ref) => RouteSimplifier();

@Riverpod(keepAlive: true)
RouteProcessingService routeProcessingService(Ref ref) {
  return RouteProcessingService(simplifier: ref.watch(routeSimplifierProvider));
}

@Riverpod(keepAlive: true)
NominatimGeocodingService nominatimGeocodingService(Ref ref) {
  final service = NominatimGeocodingService(
    cacheRepository: ref.watch(geocodingCacheRepositoryProvider),
  );
  ref.onDispose(service.dispose);
  return service;
}

@Riverpod(keepAlive: true)
RouteSnapshotWriter routeSnapshotWriter(Ref ref) {
  return RouteSnapshotService(hostKey: routeSnapshotHostKey);
}

@Riverpod(keepAlive: true)
TripFinalizationService tripFinalizationService(Ref ref) {
  return TripFinalizationService(
    routeProcessingService: ref.watch(routeProcessingServiceProvider),
    geocodingService: ref.watch(nominatimGeocodingServiceProvider),
    snapshotWriter: ref.watch(routeSnapshotWriterProvider),
  );
}
