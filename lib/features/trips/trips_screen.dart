import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:quantane/features/trips/trip_providers.dart';

import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeVehicleId = ref.watch(activeVehicleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trips')),
      body: const Center(child: Text('Trip History coming soon')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (activeVehicleId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please add and select a vehicle first in Settings.')),
            );
            return;
          }
          ref.read(tripTrackingProvider.notifier).start();
          context.push('/live-trip');
        },
        child: const Icon(LucideIcons.play),
      ),
    );
  }
}
