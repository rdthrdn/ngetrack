import 'package:flutter/material.dart';
import 'package:ngetrack/core/theme/app_theme.dart';

class PulsingStreak extends StatefulWidget {
  final int streak;
  final bool isCompleted;

  const PulsingStreak({
    super.key,
    required this.streak,
    required this.isCompleted,
  });

  @override
  State<PulsingStreak> createState() => _PulsingStreakState();
}

class _PulsingStreakState extends State<PulsingStreak>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isCompleted) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant PulsingStreak oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted != oldWidget.isCompleted) {
      if (widget.isCompleted) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.isCompleted
            ? AppTheme.pink900.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isCompleted
              ? AppTheme.pink900.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isCompleted ? _scaleAnimation.value : 1.0,
                child: child,
              );
            },
            child: Text(
              "🔥",
              style: TextStyle(
                fontSize: 16,
                color: widget.isCompleted
                    ? null
                    : Colors.grey, // Grayscale if not done
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Streak ${widget.streak}d",
            style: AppTheme.textTheme.labelLarge?.copyWith(
              color: widget.isCompleted
                  ? AppTheme.pink900
                  : AppTheme.onGlass.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
