import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ngetrack/core/theme/app_theme.dart';

class SpeechBubble extends StatelessWidget {
  final String text;

  const SpeechBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubbleBorderPainter(),
      child: ClipPath(
        clipper: _BubbleClipper(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 60), // Extra bottom padding for tail
            color: Colors.white.withValues(alpha: 0.2),
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: AppTheme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontSize: 32, // Larger font as per image
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Path _getBubblePath(Size size) {
  final path = Path();
  const radius = 32.0;
  const tailHeight = 30.0;
  
  final w = size.width;
  final h = size.height - tailHeight; // Body height

  // Main bubble body
  path.moveTo(radius, 0);
  path.lineTo(w - radius, 0);
  path.quadraticBezierTo(w, 0, w, radius);
  path.lineTo(w, h - radius);
  path.quadraticBezierTo(w, h, w - radius, h);
  
  // Bottom edge to tail start
  // Tail position: left side
  path.lineTo(60, h);
  
  // Tail
  path.quadraticBezierTo(
    40, h + tailHeight, // Control point
    20, h + tailHeight + 10, // Tip
  );
  path.quadraticBezierTo(
    35, h + 10,
    50, h,
  );

  path.lineTo(radius, h);
  path.quadraticBezierTo(0, h, 0, h - radius);
  path.lineTo(0, radius);
  path.quadraticBezierTo(0, 0, radius, 0);

  path.close();
  return path;
}

class _BubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => _getBubblePath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BubbleBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(_getBubblePath(size), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
