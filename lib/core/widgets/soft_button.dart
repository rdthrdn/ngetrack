import 'package:flutter/material.dart';
import 'package:ngetrack/core/theme/app_theme.dart';

enum SoftButtonStyle { filled, outline }

class SoftButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final SoftButtonStyle style;
  final double? width;

  const SoftButton({
    super.key,
    required this.label,
    this.onTap,
    this.style = SoftButtonStyle.filled,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = style == SoftButtonStyle.filled;

    return SizedBox(
      width: width,
      height: 52,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: isFilled ? AppTheme.pink900.withValues(alpha: 0.8) : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.pink900,
                width: isFilled ? 0 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTheme.textTheme.labelLarge?.copyWith(
                color: isFilled ? Colors.white : AppTheme.pink900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
