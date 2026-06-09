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
  SpeedDisplayMode _displayMode = SpeedDisplayMode.digital;
  Duration _elapsedDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _durationTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        final state = ref.read(tripTrackingProvider);
        if (state != null) {
          setState(() {
            _elapsedDuration = DateTime.now().difference(state.startTime);
          });
        }
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
    final trackingStatus = ref.watch(tripTrackingProvider.notifier).status;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(child: _buildBody(tripState, trackingStatus)),
    );
  }

  Widget _buildBody(TripState? state, TripTrackingStatus status) {
    if (state == null) {
      _elapsedDuration = Duration.zero;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                status == TripTrackingStatus.waitingForLocation
                    ? 'Waiting for GPS signal...'
                    : 'Starting trip...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                status == TripTrackingStatus.waitingForLocation
                    ? 'Check emulator location permissions and route playback.'
                    : 'Preparing trip tracking.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _SpeedModeSwitcher(
            mode: _displayMode,
            onChanged: (mode) {
              setState(() {
                _displayMode = mode;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SpeedGauge(
            speed: state.currentSpeed,
            maxSpeed: 200,
            mode: _displayMode,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                isElapsedDurationVisible
                    ? _formatDuration(_elapsedDuration)
                    : _formatDuration(
                        DateTime.now().difference(state.startTime),
                      ),
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
                    decoration: BoxDecoration(
                      color: state.currentSpeed > 80
                          ? AppColors.dangerColor
                          : state.currentSpeed > 50
                          ? AppColors.warningColor
                          : AppColors.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.currentSpeed > 80
                        ? 'Exceeding speed limit'
                        : state.currentSpeed > 50
                        ? 'Slow down'
                        : 'Trip in progress',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: state.currentSpeed > 80
                          ? AppColors.dangerColor
                          : state.currentSpeed > 50
                          ? AppColors.warningColor
                          : AppColors.accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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

  bool get isElapsedDurationVisible => _elapsedDuration > Duration.zero;

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

class _SpeedModeSwitcher extends StatelessWidget {
  final SpeedDisplayMode mode;
  final ValueChanged<SpeedDisplayMode> onChanged;

  const _SpeedModeSwitcher({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _ModeButton(
                label: 'Digital',
                selected: mode == SpeedDisplayMode.digital,
                onTap: () => onChanged(SpeedDisplayMode.digital),
              ),
            ),
            Expanded(
              child: _ModeButton(
                label: 'Analog',
                selected: mode == SpeedDisplayMode.analog,
                onTap: () => onChanged(SpeedDisplayMode.analog),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
