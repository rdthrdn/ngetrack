import 'package:flutter/material.dart';
import 'package:ngetrack/core/theme/app_theme.dart';

class DotsDayRow extends StatelessWidget {
  final List<bool> completion; // 7 days, true/false

  const DotsDayRow({
    super.key,
    required this.completion,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isCompleted = index < completion.length ? completion[index] : false;
        return Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? AppTheme.pink900 : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppTheme.pink900 : AppTheme.glassBorder,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              days[index],
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: AppTheme.onGlass.withValues(alpha: 0.6),
              ),
            ),
          ],
        );
      }),
    );
  }
}
