import 'package:flutter/material.dart';
import 'package:quantane/core/theme/colors.dart';

class TripMapStyle {
  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const double routeStrokeWidth = 4;
  static const Color routeColor = AppColors.primaryColor;
  static const Color startMarkerColor = Color(0xFF22C55E);
  static const Color endMarkerColor = Color(0xFFEF4444);
  static const double markerSize = 28;
  static const double snapshotWidth = 360;
  static const double snapshotHeight = 180;
  static const Duration snapshotRenderDelay = Duration(milliseconds: 1200);
  static const Duration snapshotTimeout = Duration(seconds: 10);

  static const String attribution = '© OpenStreetMap contributors';
}
