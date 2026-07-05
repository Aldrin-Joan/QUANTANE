// Flutter imports:
import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const bgColor = Color(
    0xFF0B0F14,
  ); // App background â€” near black with blue undertone
  static const cardColor = Color(0xFF121821); // Card surface
  static const cardElevated = Color(
    0xFF1A2232,
  ); // Slightly elevated card (modals, sheets)
  static const dividerColor = Color(0xFF1E2A3A); // Subtle dividers

  // Brand
  static const primaryColor = Color(
    0xFF3B82F6,
  ); // Blue â€” interactive elements, active state
  static const primaryMuted = Color(
    0x263B82F6,
  ); // Blue at 15% opacity â€” chart fills, badge bg

  // Semantic
  static const accentColor = Color(
    0xFF22C55E,
  ); // Green â€” positive delta, success, mileage up
  static const warningColor = Color(
    0xFFF59E0B,
  ); // Amber â€” caution, moderate spend
  static const dangerColor = Color(
    0xFFEF4444,
  ); // Red â€” negative delta, errors, delete

  static const accentMuted = Color(0x1A22C55E); // Green at 10% opacity
  static const dangerMuted = Color(0x1AEF4444); // Red at 10% opacity

  // Typography
  static const textPrimary = Color(0xFFF1F5F9); // Headings, primary values
  static const textSecondary = Color(0xFF94A3B8); // Labels, supporting text
  static const textTertiary = Color(0xFF64748B); // Timestamps, metadata

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const successGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF15803D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardGlassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
