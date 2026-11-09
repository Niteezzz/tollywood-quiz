import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class TimerPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0 (1.0 = full)
  final Color backgroundColor;

  const TimerPainter({
    required this.progress,
    this.backgroundColor = const Color(0xFF16213E),
  });

  Color get _arcColor {
    if (progress > 0.6) return AppColors.green;
    if (progress > 0.3) return AppColors.orange;
    return AppColors.red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    const strokeWidth = 8.0;

    // Background track
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Track ring
    final trackPaint = Paint()
      ..color = AppColors.darkCard
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Arc
    final arcPaint = Paint()
      ..color = _arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Add glow effect
    final glowPaint = Paint()
      ..color = _arcColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, arcPaint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class AnimatedTimerWidget extends StatelessWidget {
  final int timeLeft;
  final int maxTime;
  final double size;

  const AnimatedTimerWidget({
    super.key,
    required this.timeLeft,
    required this.maxTime,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxTime > 0 ? timeLeft / maxTime : 0.0;
    final Color textColor = progress > 0.6
        ? AppColors.green
        : progress > 0.3
            ? AppColors.orange
            : AppColors.red;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: TimerPainter(progress: progress),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: textColor,
                  fontSize: size * 0.28,
                  fontWeight: FontWeight.bold,
                ),
                child: Text('$timeLeft'),
              ),
              Text(
                'sec',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: size * 0.14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
