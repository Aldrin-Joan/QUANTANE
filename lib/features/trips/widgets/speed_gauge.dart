import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quantane/core/theme/colors.dart';

class SpeedGauge extends StatelessWidget {
  final double speed;
  final double maxSpeed;

  const SpeedGauge({super.key, required this.speed, this.maxSpeed = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: CustomPaint(
        painter: _SpeedGaugePainter(speed, maxSpeed),
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
    );
  }
}

class _SpeedGaugePainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  _SpeedGaugePainter(this.speed, this.maxSpeed);

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
      ..shader = AppColors.primaryGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
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
    return oldDelegate.speed != speed;
  }
}
