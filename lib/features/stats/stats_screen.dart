import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ngetrack/core/providers/habit_provider.dart';
import 'package:ngetrack/core/theme/app_theme.dart';
import 'package:ngetrack/core/widgets/dots_day_row.dart';
import 'package:ngetrack/core/widgets/glass_card.dart';
import 'package:ngetrack/core/widgets/weekly_bar.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final today = DateTime.now();

    // Calculate "This Week" completion
    final weekDates = List.generate(7, (i) {
      final currentWeekday = today.weekday;
      final monday = today.subtract(Duration(days: currentWeekday - 1));
      return monday.add(Duration(days: i));
    });

    final weeklyCompletion = weekDates.map((date) {
      if (habits.isEmpty) return false;
      // Consider day "complete" if ALL habits are done? Or at least one?
      // Let's say "All habits done for that day" for the dots.
      return habits.every((h) => h.isCompleted(date));
    }).toList().cast<bool>();

    final completedDaysCount = weeklyCompletion.where((c) => c).length;

    // Calculate "Today Habits"
    final totalToday = habits.length;
    final completedToday = habits.where((h) => h.isCompleted(today)).length;
    final pendingToday = totalToday - completedToday;

    // Calculate "Weekly Activity" (Bar chart)
    // Let's use % of habits completed per day
    final weeklyActivity = weekDates.map((date) {
      if (habits.isEmpty) return 0.0;
      final completed = habits.where((h) => h.isCompleted(date)).length;
      return completed / habits.length;
    }).toList().cast<double>();

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEFECED),
                  AppTheme.pink50,
                  Color(0x14B97980),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Statistics",
                    style: AppTheme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  // This Week Card
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("This Week", style: AppTheme.textTheme.titleLarge),
                        const SizedBox(height: 16),
                        DotsDayRow(
                          completion: weeklyCompletion,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("$completedToday of $totalToday done today", style: AppTheme.textTheme.bodyMedium),
                            Text("Week Completion $completedDaysCount/7", style: AppTheme.textTheme.labelLarge),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: completedDaysCount / 7,
                          backgroundColor: AppTheme.pink900.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.pink900),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Weekly Bar Chart
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Weekly Activity", style: AppTheme.textTheme.titleLarge),
                        const SizedBox(height: 24),
                        WeeklyBar(
                          values: weeklyActivity,
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Today Habits
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today Habits", style: AppTheme.textTheme.titleLarge),
                        const SizedBox(height: 16),
                        _buildStatRow("Completed", completedToday, totalToday, AppTheme.pink900),
                        const SizedBox(height: 12),
                        _buildStatRow("Pending", pendingToday, totalToday, Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value, int total, Color color) {
    final ratio = total == 0 ? 0.0 : value / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.textTheme.bodyMedium),
            Text("$value/$total", style: AppTheme.textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: ratio,
          backgroundColor: color.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}
