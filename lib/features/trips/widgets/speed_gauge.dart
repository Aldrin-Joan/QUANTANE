import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quantane/core/theme/colors.dart';

enum SpeedDisplayMode { digital, analog }

class SpeedGauge extends StatelessWidget {

  const SpeedGauge({
    super.key,
    required this.speed,
    this.maxSpeed = 200,
    this.mode = SpeedDisplayMode.digital,
  });
  final double speed;
  final double maxSpeed;
  final SpeedDisplayMode mode;

  @override
  Widget build(BuildContext context) {
    final gaugeColor = _speedColor(speed);
    final warning = _speedWarning(speed);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: mode == SpeedDisplayMode.digital
              ? _DigitalSpeedGauge(
                  key: const ValueKey('digital-speed-gauge'),
                  speed: speed,
                  gaugeColor: gaugeColor,
                  warning: warning,
                )
              : _AnalogSpeedGauge(
                  key: const ValueKey('analog-speed-gauge'),
                  speed: speed,
                  maxSpeed: maxSpeed,
                  gaugeColor: gaugeColor,
                  warning: warning,
                ),
        ),
      ],
    );
  }
}

class _DigitalSpeedGauge extends StatelessWidget {

  const _DigitalSpeedGauge({
    super.key,
    required this.speed,
    required this.gaugeColor,
    required this.warning,
  });
  final double speed;
  final Color gaugeColor;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        children: [
          SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(
              painter: _SpeedGaugePainter(
                speed: speed,
                maxSpeed: 200,
                activeColor: gaugeColor,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      speed.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 56,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'KM/H',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (warning != null) ...[
            const SizedBox(height: 16),
            _SpeedWarningBanner(message: warning!, color: gaugeColor),
          ],
        ],
      ),
    );
  }
}

class _AnalogSpeedGauge extends StatelessWidget {

  const _AnalogSpeedGauge({
    super.key,
    required this.speed,
    required this.maxSpeed,
    required this.gaugeColor,
    required this.warning,
  });
  final double speed;
  final double maxSpeed;
  final Color gaugeColor;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 320.0,
          320,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _AnalogSpeedGaugePainter(
                  speed: speed,
                  maxSpeed: maxSpeed,
                  activeColor: gaugeColor,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              speed.toStringAsFixed(0),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 48,
                color: Colors.white,
              ),
            ),
            Text(
              'KM/H',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
            ),
            if (warning != null) ...[
              const SizedBox(height: 16),
              _SpeedWarningBanner(message: warning!, color: gaugeColor),
            ],
          ],
        );
      },
    );
  }
}

class _SpeedWarningBanner extends StatelessWidget {

  const _SpeedWarningBanner({required this.message, required this.color});
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _speedColor(double speed) {
  if (speed <= 50) return AppColors.accentColor;
  if (speed <= 80) return AppColors.warningColor;
  return AppColors.dangerColor;
}

String? _speedWarning(double speed) {
  if (speed <= 80) return null;
  if (speed <= 100) return 'Slow down. You are exceeding the speed limit.';
  return 'Exceeding speed limit. Reduce speed immediately.';
}

class _SpeedGaugePainter extends CustomPainter {

  _SpeedGaugePainter({
    required this.speed,
    required this.maxSpeed,
    required this.activeColor,
  });
  final double speed;
  final double maxSpeed;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const startAngle = 225 * pi / 180;
    const sweepAngle = 270 * pi / 180;

    final trackPaint = Paint()
      ..color = AppColors.dividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    final progress = (speed / maxSpeed).clamp(0.0, 1.0);
    final progressPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpeedGaugePainter oldDelegate) {
    return oldDelegate.speed != speed || oldDelegate.activeColor != activeColor;
  }
}

class _AnalogSpeedGaugePainter extends CustomPainter {

  _AnalogSpeedGaugePainter({
    required this.speed,
    required this.maxSpeed,
    required this.activeColor,
  });
  final double speed;
  final double maxSpeed;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const startAngle = 220 * pi / 180;
    const sweepAngle = 280 * pi / 180;
    final dialRect = Rect.fromCircle(center: center, radius: radius - 10);

    _drawTrack(canvas, dialRect, startAngle, sweepAngle);
    _drawThresholdBand(
      canvas,
      dialRect,
      startAngle,
      sweepAngle,
      0,
      50 / maxSpeed,
      AppColors.accentColor,
    );
    _drawThresholdBand(
      canvas,
      dialRect,
      startAngle,
      sweepAngle,
      50 / maxSpeed,
      80 / maxSpeed,
      AppColors.warningColor,
    );
    _drawThresholdBand(
      canvas,
      dialRect,
      startAngle,
      sweepAngle,
      80 / maxSpeed,
      1,
      AppColors.dangerColor,
    );
    _drawTicks(canvas, center, radius - 26, startAngle, sweepAngle);
    _drawNeedle(canvas, center, radius - 38, startAngle, sweepAngle);
    _drawHub(canvas, center);
  }

  void _drawTrack(
    Canvas canvas,
    Rect dialRect,
    double startAngle,
    double sweepAngle,
  ) {
    final trackPaint = Paint()
      ..color = AppColors.dividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(dialRect, startAngle, sweepAngle, false, trackPaint);
  }

  void _drawThresholdBand(
    Canvas canvas,
    Rect dialRect,
    double startAngle,
    double sweepAngle,
    double startFraction,
    double endFraction,
    Color color,
  ) {
    final bandPaint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final clampedStart = startFraction.clamp(0.0, 1.0);
    final clampedEnd = endFraction.clamp(0.0, 1.0);
    if (clampedEnd <= clampedStart) {
      return;
    }

    canvas.drawArc(
      dialRect,
      startAngle + (sweepAngle * clampedStart),
      sweepAngle * (clampedEnd - clampedStart),
      false,
      bandPaint,
    );
  }

  void _drawTicks(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
  ) {
    final majorTickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final minorTickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.24)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    const majorStep = 20;
    const minorStep = 10;

    for (var value = 0; value <= maxSpeed; value += minorStep) {
      final isMajor = value % majorStep == 0;
      final angle = startAngle + (sweepAngle * (value / maxSpeed));
      final inner = radius - (isMajor ? 18 : 12);
      final outer = radius;
      canvas.drawLine(
        Offset(center.dx + cos(angle) * inner, center.dy + sin(angle) * inner),
        Offset(center.dx + cos(angle) * outer, center.dy + sin(angle) * outer),
        isMajor ? majorTickPaint : minorTickPaint,
      );
    }
  }

  void _drawNeedle(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
  ) {
    final progress = (speed / maxSpeed).clamp(0.0, 1.0);
    final angle = startAngle + (sweepAngle * progress);
    final needlePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final tip = Offset(
      center.dx + cos(angle) * radius,
      center.dy + sin(angle) * radius,
    );

    canvas.drawLine(center, tip, needlePaint);
    canvas.drawLine(
      center,
      Offset(
        center.dx + cos(angle + pi) * 12,
        center.dy + sin(angle + pi) * 12,
      ),
      Paint()
        ..color = activeColor.withValues(alpha: 0.35)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawHub(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 12, Paint()..color = Colors.white);
    canvas.drawCircle(center, 5, Paint()..color = activeColor);
  }

  @override
  bool shouldRepaint(covariant _AnalogSpeedGaugePainter oldDelegate) {
    return oldDelegate.speed != speed || oldDelegate.activeColor != activeColor;
  }
}
