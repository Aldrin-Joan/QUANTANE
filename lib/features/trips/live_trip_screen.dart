import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/features/trips/trip_providers.dart';
import 'package:quantane/features/trips/widgets/speed_gauge.dart';
import 'package:quantane/features/trips/trip_tracking_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:quantane/data/repositories/trip_repository.dart';
import 'package:quantane/domain/models/trip.dart';
import 'package:uuid/uuid.dart';
import 'package:quantane/features/shared/providers/active_vehicle_provider.dart';

class LiveTripScreen extends ConsumerStatefulWidget {
  const LiveTripScreen({super.key});

  @override
  ConsumerState<LiveTripScreen> createState() => _LiveTripScreenState();
}

class _LiveTripScreenState extends ConsumerState<LiveTripScreen> {
  late final Timer _durationTicker;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _durationTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _durationTicker.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  void _stopTrip() async {
    final state = ref.read(tripTrackingProvider);
    if (state == null) return;

    final vehicleId = ref.read(activeVehicleProvider);
    if (vehicleId == null) return;

    final trip = Trip(
      id: const Uuid().v4(),
      vehicleId: vehicleId,
      startTime: state.startTime,
      endTime: DateTime.now(),
      distance: state.distance,
      avgSpeed: _averageSpeedKmh(
        distanceKm: state.distance,
        duration: DateTime.now().difference(state.startTime),
      ),
      maxSpeed: state.maxSpeed,
    );

    await ref.read(tripRepositoryProvider).insert(trip);
    ref.read(tripTrackingProvider.notifier).stop();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripTrackingProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(child: _buildBody(tripState)),
    );
  }

  Widget _buildBody(TripState? state) {
    if (state == null) {
      return const Center(child: Text('Starting trip...'));
    }
    return Column(
      children: [
        const Spacer(),
        SpeedGauge(speed: state.currentSpeed, maxSpeed: 200),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(
                'Max Speed',
                '${state.maxSpeed.toStringAsFixed(0)} KM/H',
              ),
              _buildStat('Distance', '${state.distance.toStringAsFixed(1)} KM'),
              _buildStat(
                'Duration',
                _formatDuration(DateTime.now().difference(state.startTime)),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Trip in progress'),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _stopTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dangerColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Stop Trip'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _averageSpeedKmh({
    required double distanceKm,
    required Duration duration,
  }) {
    final hours = duration.inSeconds / 3600.0;
    if (hours <= 0) {
      return 0.0;
    }

    return distanceKm / hours;
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
