// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/features/trips/trip_providers.dart';
import 'package:quantane/features/trips/trip_session_models.dart';
import 'package:quantane/features/trips/trip_tracking_state.dart';
import 'package:quantane/features/trips/widgets/speed_gauge.dart';

class LiveTripScreen extends ConsumerStatefulWidget {
  const LiveTripScreen({super.key});

  @override
  ConsumerState<LiveTripScreen> createState() => _LiveTripScreenState();
}

class _LiveTripScreenState extends ConsumerState<LiveTripScreen>
    with WidgetsBindingObserver {
  SpeedDisplayMode _displayMode = SpeedDisplayMode.digital;
  Timer? _durationTicker;
  ProviderSubscription<TripTrackingState>? _tripStateSubscription;
  bool _hasRedirectedToTrips = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tripStateSubscription = ref.listenManual<TripTrackingState>(
      tripTrackingProvider,
      _handleTripStateChange,
    );
    _startDurationTicker();
    WakelockPlus.enable();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirectIfTripStopped(ref.read(tripTrackingProvider));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tripStateSubscription?.close();
    _stopDurationTicker();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        _startDurationTicker();
        setState(() {});
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _stopDurationTicker();
    }
  }

  Future<void> _stopTrip() async {
    await ref.read(tripTrackingProvider.notifier).stop();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleTripStateChange(
    TripTrackingState? previous,
    TripTrackingState next,
  ) {
    _redirectIfTripStopped(next);
  }

  void _redirectIfTripStopped(TripTrackingState state) {
    if (_hasRedirectedToTrips || !mounted) {
      return;
    }

    if (state.session != null || state.status != TripTrackingStatus.idle) {
      return;
    }

    _hasRedirectedToTrips = true;
    context.go('/trips');
  }

  void _startDurationTicker() {
    _durationTicker ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _stopDurationTicker() {
    _durationTicker?.cancel();
    _durationTicker = null;
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(tripTrackingProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: _buildBody(trackingState.session, trackingState.status),
      ),
    );
  }

  Widget _buildBody(TripState? state, TripTrackingStatus status) {
    if (state == null) {
      String message;
      String subMessage;

      switch (status) {
        case TripTrackingStatus.bootstrapping:
          message = 'Restoring session...';
          subMessage = 'Checking for active trips.';
        case TripTrackingStatus.waitingForLocation:
          message = 'Waiting for GPS signal...';
          subMessage = 'Check location permissions and route playback.';
        case TripTrackingStatus.idle:
          message = 'Trip stopped';
          subMessage = 'Redirecting to history.';
        case TripTrackingStatus.live:
          message = 'Starting trip...';
          subMessage = 'Preparing trip tracking.';
      }

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                subMessage,
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

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DecoratedBox(
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
                        selected: _displayMode == SpeedDisplayMode.digital,
                        onTap: () => setState(() {
                          _displayMode = SpeedDisplayMode.digital;
                        }),
                      ),
                    ),
                    Expanded(
                      child: _ModeButton(
                        label: 'Analog',
                        selected: _displayMode == SpeedDisplayMode.analog,
                        onTap: () => setState(() {
                          _displayMode = SpeedDisplayMode.analog;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SpeedGauge(
              speed: state.currentSpeed,
              mode: _displayMode,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  'Max Speed',
                  '${state.maxSpeed.toStringAsFixed(0)} KM/H',
                ),
                _buildStat(
                  'Distance',
                  '${state.distance.toStringAsFixed(1)} KM',
                ),
                _buildStat(
                  'Duration',
                  _formatDuration(_elapsedDuration(state)),
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
      ),
    );
  }

  Duration _elapsedDuration(TripState state) {
    return DateTime.now().difference(state.startTime);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
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
}

class _ModeButton extends StatelessWidget {

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

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
