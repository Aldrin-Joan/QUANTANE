import 'package:flutter/material.dart';
import 'package:quantane/core/theme/colors.dart';

enum QuantaneCardVariant { flat, glass, colored }

class QuantaneCard extends StatelessWidget {
  final Widget child;
  final QuantaneCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final double borderRadius;

  const QuantaneCard({
    super.key,
    required this.child,
    this.variant = QuantaneCardVariant.flat,
    this.padding,
    this.gradient,
    this.borderRadius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;

    switch (variant) {
      case QuantaneCardVariant.glass:
        decoration = BoxDecoration(
          gradient: AppColors.cardGlassGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        );
        break;
      case QuantaneCardVariant.colored:
        decoration = BoxDecoration(
          gradient: gradient ?? AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        );
        break;
      case QuantaneCardVariant.flat:
      default:
        decoration = BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        );
        break;
    }

    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: decoration,
      child: child,
    );
  }
}
