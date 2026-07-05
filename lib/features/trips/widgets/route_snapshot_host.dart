// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:screenshot/screenshot.dart';

// Project imports:
import 'package:quantane/features/trips/services/route_processing_service.dart';
import 'package:quantane/features/trips/widgets/trip_map_style.dart';
import 'package:quantane/features/trips/widgets/trip_route_map.dart';

final routeSnapshotHostKey = GlobalKey<RouteSnapshotHostState>();

class RouteSnapshotHost extends StatefulWidget {
  const RouteSnapshotHost({super.key});

  @override
  RouteSnapshotHostState createState() => RouteSnapshotHostState();
}

class RouteSnapshotHostState extends State<RouteSnapshotHost> {
  final ScreenshotController _screenshotController = ScreenshotController();
  ProcessedRoute? _route;

  Future<Uint8List?> capture(ProcessedRoute route) async {
    setState(() => _route = route);
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(TripMapStyle.snapshotRenderDelay);
    if (!mounted) {
      return null;
    }

    return _screenshotController.capture(
      pixelRatio: 2,
      delay: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final route = _route;
    return SizedBox(
      width: TripMapStyle.snapshotWidth,
      height: TripMapStyle.snapshotHeight,
      child: route == null
          ? const ColoredBox(color: Color(0xFF1A1F2B))
          : Screenshot(
              controller: _screenshotController,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: mapFromProcessedRoute(
                  route,
                  interactive: false,
                  height: TripMapStyle.snapshotHeight,
                ),
              ),
            ),
    );
  }
}
