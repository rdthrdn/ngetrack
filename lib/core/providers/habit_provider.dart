import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ngetrack/core/data/habit.dart';
import 'package:ngetrack/core/data/local_storage_service.dart';

final localStorageServiceProvider = Provider((ref) => LocalStorageService());

final habitProvider = NotifierProvider<HabitNotifier, List<Habit>>(HabitNotifier.new);

class HabitNotifier extends Notifier<List<Habit>> {
  late LocalStorageService _storage;

  @override
  List<Habit> build() {
    _storage = ref.watch(localStorageServiceProvider);
    _loadHabits();
    return [];
  }

  Future<void> _loadHabits() async {
    final habits = await _storage.loadHabits();
    state = habits;
  }

  Future<void> addHabit(String name, int target) async {
    final newHabit = Habit(name: name, targetPerDay: target);
    state = [...state, newHabit];
    await _storage.saveHabits(state);
  }

  Future<void> deleteHabit(String id) async {
    state = state.where((h) => h.id != id).toList();
    await _storage.saveHabits(state);
  }

  Future<void> toggleHabit(String id, DateTime date) async {
    state = state.map((habit) {
      if (habit.id != id) return habit;

      final dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final currentProgress = habit.dailyProgress[dateKey] ?? 0;
      
      final isCompleted = currentProgress >= habit.targetPerDay;
      final newProgress = isCompleted ? 0 : habit.targetPerDay;

      final newDailyProgress = Map<String, int>.from(habit.dailyProgress);
      newDailyProgress[dateKey] = newProgress;
      
      final newCompletedDates = List<DateTime>.from(habit.completedDates);
      final dateOnly = DateTime(date.year, date.month, date.day);
      
      if (!isCompleted) {
         if (!newCompletedDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day)) {
           newCompletedDates.add(dateOnly);
         }
      } else {
        newCompletedDates.removeWhere((d) => d.year == date.year && d.month == date.month && d.day == date.day);
      }

      return habit.copyWith(
        dailyProgress: newDailyProgress,
        completedDates: newCompletedDates,
      );
    }).toList();
    await _storage.saveHabits(state);
  }
  
  Future<void> updateProgress(String id, DateTime date, int delta) async {
     state = state.map((habit) {
      if (habit.id != id) return habit;

      final dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final currentProgress = habit.dailyProgress[dateKey] ?? 0;
      final newProgress = (currentProgress + delta).clamp(0, 999);

      final newDailyProgress = Map<String, int>.from(habit.dailyProgress);
      newDailyProgress[dateKey] = newProgress;
      
      final newCompletedDates = List<DateTime>.from(habit.completedDates);
      final dateOnly = DateTime(date.year, date.month, date.day);
      final isCompleted = newProgress >= habit.targetPerDay;
      
      if (isCompleted) {
         if (!newCompletedDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day)) {
           newCompletedDates.add(dateOnly);
         }
      } else {
        newCompletedDates.removeWhere((d) => d.year == date.year && d.month == date.month && d.day == date.day);
      }

      return habit.copyWith(
        dailyProgress: newDailyProgress,
        completedDates: newCompletedDates,
      );
    }).toList();
    await _storage.saveHabits(state);
  }
}
