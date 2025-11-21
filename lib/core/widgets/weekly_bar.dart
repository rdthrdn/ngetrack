import 'package:flutter/material.dart';
import 'package:ngetrack/core/theme/app_theme.dart';

class WeeklyBar extends StatelessWidget {
  final List<double> values; // 7 values, 0.0 to 1.0
  final double height;

  const WeeklyBar({
    super.key,
    required this.values,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _BarPainter(values: values),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<double> values;

  _BarPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final barWidth = (size.width / values.length) * 0.6;
    final spacing = (size.width - (barWidth * values.length)) / (values.length + 1);

    final paint = Paint()
      ..color = AppTheme.pink900
      ..style = PaintingStyle.fill;

    final bgPaint = Paint()
      ..color = AppTheme.white90.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < values.length; i++) {
      final x = spacing + (i * (barWidth + spacing));
      final barHeight = size.height * values[i];
      
      // Background bar
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 0, barWidth, size.height),
        const Radius.circular(8),
      );
      canvas.drawRRect(bgRect, bgPaint);

      // Active bar
      final activeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
        const Radius.circular(8),
      );
      canvas.drawRRect(activeRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
