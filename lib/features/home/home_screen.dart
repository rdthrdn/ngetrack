import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ngetrack/core/data/habit.dart';
import 'package:ngetrack/core/providers/habit_provider.dart';
import 'package:ngetrack/core/theme/app_theme.dart';
import 'package:ngetrack/core/widgets/glass_card.dart';
import 'package:ngetrack/core/widgets/progress_ring.dart';
import 'package:ngetrack/core/widgets/soft_chip.dart';
import 'package:ngetrack/features/detail/detail_sheet.dart';
import 'package:ngetrack/core/services/feedback_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedChipIndex = 0;
  final List<String> _chips = ['All', 'Done', 'Pending', 'On Streak'];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMM').format(today);
    final habits = ref.watch(habitProvider);

    // Filter habits
    final filteredHabits = habits.where((h) {
      if (_selectedChipIndex == 0) return true;
      final isDone = h.isCompleted(today);
      if (_selectedChipIndex == 1) return isDone;
      if (_selectedChipIndex == 2) return !isDone;
      // Mock "On Streak" logic for now (e.g., completed yesterday and today)
      if (_selectedChipIndex == 3) return isDone;
      return true;
    }).toList();

    // Calculate progress
    final totalHabits = habits.length;
    final completedCount = habits.where((h) => h.isCompleted(today)).length;
    final progress = totalHabits == 0 ? 0.0 : completedCount / totalHabits;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFEFECED), AppTheme.pink50, Color(0x14B97980)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Header
                Text(dateStr, style: AppTheme.textTheme.headlineSmall),
                const SizedBox(height: 24),

                // Hero Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    height: 180,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Daily\nProgress",
                              style: AppTheme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "$completedCount of $totalHabits completed",
                              style: AppTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        ProgressRing(
                          progress: progress,
                          size: 120,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${(progress * 100).toInt()}%",
                                style: AppTheme.textTheme.displayMedium
                                    ?.copyWith(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                "Complete",
                                style: AppTheme.textTheme.labelLarge?.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: List.generate(_chips.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SoftChip(
                          label: _chips[index],
                          isSelected: _selectedChipIndex == index,
                          onTap: () {
                            setState(() {
                              _selectedChipIndex = index;
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 16),

                // Habit List
                Expanded(
                  child: filteredHabits.isEmpty
                      ? Center(
                          child: Text(
                            "No habits found.\nAdd one to get started!",
                            textAlign: TextAlign.center,
                            style: AppTheme.textTheme.bodyLarge?.copyWith(
                              color: AppTheme.onGlass.withValues(alpha: 0.5),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          itemCount: filteredHabits.length,
                          itemBuilder: (context, index) {
                            return _buildHabitItem(
                              filteredHabits[index],
                              today,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitItem(Habit habit, DateTime today) {
    final isDone = habit.isCompleted(today);
    final currentProgress = habit.getProgress(today);
    final progressRatio = habit.targetPerDay == 0
        ? 0.0
        : (currentProgress / habit.targetPerDay).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DetailSheet(habitId: habit.id),
          );
        },
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressRatio,
                    backgroundColor: AppTheme.pink900.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.pink900),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                _toggleHabit(ref, habit);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDone
                      ? AppTheme.pink900.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDone ? Colors.transparent : AppTheme.glassBorder,
                  ),
                ),
                child: Text(
                  isDone ? "Done" : "Pending",
                  style: AppTheme.textTheme.labelLarge?.copyWith(
                    color: isDone ? AppTheme.pink900 : AppTheme.onGlass,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleHabit(WidgetRef ref, Habit habit) {
    final today = DateTime.now();
    final isCompleted = habit.isCompleted(today);

    if (!isCompleted) {
      FeedbackService().medium(); // Haptic
      FeedbackService().playSuccess(); // Sound
    } else {
      FeedbackService().light();
    }

    ref.read(habitProvider.notifier).toggleHabit(habit.id, today);
  }
}
