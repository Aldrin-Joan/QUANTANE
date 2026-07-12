// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:quantane/features/group_ride/data/repositories/group_ride_repository.dart';
import 'package:quantane/features/group_ride/data/repositories/location_sharing_repository.dart';

part 'supabase_provider.g.dart';

@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

@Riverpod(keepAlive: true)
GroupRideRepository groupRideRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return GroupRideRepository(client);
}

@Riverpod(keepAlive: true)
LocationSharingRepository locationSharingRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final repo = LocationSharingRepository(client);
  ref.onDispose(repo.dispose);
  return repo;
}
