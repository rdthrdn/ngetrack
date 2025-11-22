import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ngetrack/core/providers/habit_provider.dart';
import 'package:ngetrack/core/theme/app_theme.dart';
import 'package:ngetrack/core/widgets/dots_day_row.dart';
import 'package:ngetrack/core/widgets/glass_card.dart';
import 'package:ngetrack/core/widgets/soft_button.dart';
import 'package:ngetrack/features/detail/widgets/pulsing_streak.dart';
import 'package:ngetrack/core/services/feedback_service.dart';

class DetailSheet extends ConsumerWidget {
  final String? habitId;

  const DetailSheet({super.key, this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final habit = habits.firstWhere(
      (h) => h.id == habitId,
      orElse: () => habits.first, // Fallback or handle empty
    );

    if (habitId != null && !habits.any((h) => h.id == habitId)) {
      // Habit deleted or not found
      return const SizedBox.shrink();
    }

    final today = DateTime.now();
    final currentProgress = habit.getProgress(today);
    final isCompletedToday = habit.isCompleted(today);

    // Calculate weekly completion
    final weekDates = List.generate(7, (i) {
      // Start from Monday of current week? Or last 7 days?
      // Let's do last 7 days ending today for simplicity, or fixed Mon-Sun.
      // Design shows M T W T F S S. Let's assume fixed week starting Monday.
      final now = DateTime.now();
      final currentWeekday = now.weekday;
      final monday = now.subtract(Duration(days: currentWeekday - 1));
      return monday.add(Duration(days: i));
    });

    final weeklyCompletion = weekDates
        .map((date) => habit.isCompleted(date))
        .toList()
        .cast<bool>();

    // Calculate streak
    int streak = habit.currentStreak;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.pink50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Header
            Text(habit.name, style: AppTheme.textTheme.headlineSmall),
            const SizedBox(height: 16),

            // Streak & History
            Row(
              children: [
                PulsingStreak(streak: streak, isCompleted: isCompletedToday),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Lihat Riwayat",
                    style: AppTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.pink900,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weekly Progress
            Text("Progres Mingguan", style: AppTheme.textTheme.titleLarge),
            const SizedBox(height: 12),
            DotsDayRow(completion: weeklyCompletion),
            const SizedBox(height: 24),

            // Goals Stepper
            Text("Goals Per Hari", style: AppTheme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    FeedbackService().selection();
                    ref
                        .read(habitProvider.notifier)
                        .updateProgress(habit.id, today, -1);
                  },
                  child: _buildStepperButton(Icons.remove),
                ),
                const SizedBox(width: 24),
                Text(
                  "$currentProgress / ${habit.targetPerDay}",
                  style: AppTheme.textTheme.headlineSmall,
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {
                    FeedbackService().light();
                    ref
                        .read(habitProvider.notifier)
                        .updateProgress(habit.id, today, 1);
                  },
                  child: _buildStepperButton(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Reminder
            Text("Jam Pengingat", style: AppTheme.textTheme.titleLarge),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("19:00", style: AppTheme.textTheme.bodyLarge),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.onGlass,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Adaptive Reminder Switch
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pengingat Adaptif",
                          style: AppTheme.textTheme.labelLarge,
                        ),
                        Text(
                          "Sesuaikan waktu berdasarkan rutinitas",
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (val) {},
                    activeThumbColor: AppTheme.pink900,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Actions
            SoftButton(
              label: "Arsipkan Habit",
              style: SoftButtonStyle.outline,
              onTap: () {
                ref.read(habitProvider.notifier).deleteHabit(habit.id);
                context.pop();
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SoftButton(
                    label: "Batal",
                    style: SoftButtonStyle.outline,
                    onTap: () => context.pop(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SoftButton(
                    label: "Simpan",
                    onTap: () => context.pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.glassBorder),
        color: AppTheme.white90,
      ),
      child: Icon(icon, color: AppTheme.onGlass),
    );
  }
}
