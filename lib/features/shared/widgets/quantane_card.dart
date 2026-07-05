import 'package:flutter/material.dart';
import 'package:quantane/core/theme/colors.dart';

enum QuantaneCardVariant { flat, glass, colored }

class QuantaneCard extends StatelessWidget {

  const QuantaneCard({
    super.key,
    required this.child,
    this.variant = QuantaneCardVariant.flat,
    this.padding,
    this.gradient,
    this.borderRadius = 24.0,
  });
  final Widget child;
  final QuantaneCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;

    switch (variant) {
      case QuantaneCardVariant.glass:
        decoration = BoxDecoration(
          gradient: AppColors.cardGlassGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        );
      case QuantaneCardVariant.colored:
        decoration = BoxDecoration(
          gradient: gradient ?? AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        );
      case QuantaneCardVariant.flat:
        decoration = BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        );
    }

    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: decoration,
      child: child,
    );
  }
}
