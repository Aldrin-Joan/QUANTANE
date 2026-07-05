// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Project imports:
import 'package:quantane/core/theme/colors.dart';
import 'package:quantane/features/group_ride/domain/entities/group_ride.dart';
import 'package:quantane/features/group_ride/domain/entities/rider_telemetry.dart';
import 'package:quantane/features/group_ride/presentation/controllers/group_ride_controllers.dart';

class LiveMapView extends ConsumerStatefulWidget {
  const LiveMapView({required this.group, super.key});

  final GroupRideSession group;

  @override
  ConsumerState<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends ConsumerState<LiveMapView> with TickerProviderStateMixin {
  late final AnimatedMapController _mapController;
  final Map<String, RiderTelemetry> _telemetries = {};
  Position? _myPosition;
  StreamSubscription<Position>? _myPosSub;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);

    // Listen to local position
    _myPosSub = Geolocator.getPositionStream().listen((pos) {
      if (mounted) {
        setState(() {
          _myPosition = pos;
        });
      }
    });
  }

  @override
  void dispose() {
    _myPosSub?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
          cos(lat1 * p) * cos(lat2 * p) *
          (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  Future<void> _navigateToRider(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<RiderTelemetry>>(groupTelemetryProvider(widget.group.id), (previous, next) {
      final telemetry = next.value;
      if (telemetry != null && mounted) {
        setState(() {
          _telemetries[telemetry.riderId] = telemetry;
        });
      }
    });

    final activeRiders = _telemetries.values.toList();
    final center = _myPosition != null
        ? LatLng(_myPosition!.latitude, _myPosition!.longitude)
        : const LatLng(12.9716, 77.5946); // default Bangalore

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController.mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 14.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.quantane.app',
            ),
            MarkerLayer(
              markers: [
                // Me Marker
                if (_myPosition != null)
                  Marker(
                    point: LatLng(_myPosition!.latitude, _myPosition!.longitude),
                    width: 45,
                    height: 45,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.navigation, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                // Peer Markers
                ...activeRiders.map((telemetry) {
                  return Marker(
                    point: LatLng(telemetry.latitude, telemetry.longitude),
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        _mapController.animateTo(
                          dest: LatLng(telemetry.latitude, telemetry.longitude),
                          zoom: 15.0,
                        );
                        _showRiderDetail(context, telemetry);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.accentColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentColor.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(LucideIcons.user, size: 18, color: Colors.white),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                telemetry.speed.toStringAsFixed(0),
                                style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
        // Position buttons overlay
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (activeRiders.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.satellite, size: 16, color: AppColors.textSecondary),
                      SizedBox(width: 8),
                      Text(
                        'Waiting for other riders...',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: activeRiders.length,
                    itemBuilder: (context, index) {
                      final rider = activeRiders[index];
                      var dist = 0.0;
                      if (_myPosition != null) {
                        dist = _calculateDistance(
                          _myPosition!.latitude,
                          _myPosition!.longitude,
                          rider.latitude,
                          rider.longitude,
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          _mapController.animateTo(
                            dest: LatLng(rider.latitude, rider.longitude),
                            zoom: 15.0,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cardColor.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: AppColors.accentColor.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.accentColor,
                                child: Icon(LucideIcons.user, size: 12, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Rider ${rider.riderId.substring(0, min(4, rider.riderId.length))}',
                                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${dist.toStringAsFixed(1)} km · ${rider.speed.toStringAsFixed(0)} km/h',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRiderDetail(BuildContext context, RiderTelemetry rider) {
    var dist = 0.0;
    if (_myPosition != null) {
      dist = _calculateDistance(
        _myPosition!.latitude,
        _myPosition!.longitude,
        rider.latitude,
        rider.longitude,
      );
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.accentColor,
                        child: Icon(LucideIcons.user, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rider ${rider.riderId.substring(0, min(6, rider.riderId.length))}',
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            rider.status.toUpperCase(),
                            style: TextStyle(
                              color: rider.status == 'moving' ? AppColors.accentColor : AppColors.warningColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatTile('Distance', '${dist.toStringAsFixed(1)} KM'),
                  _buildStatTile('Current Speed', '${rider.speed.toStringAsFixed(0)} KM/H'),
                  _buildStatTile('Heading', '${rider.heading.toStringAsFixed(0)}°'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToRider(rider.latitude, rider.longitude);
                },
                icon: const Icon(LucideIcons.map_pin),
                label: const Text('Navigate with Google Maps'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
