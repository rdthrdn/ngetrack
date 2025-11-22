import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ngetrack/core/data/habit.dart';
import 'package:ngetrack/core/data/local_storage_service.dart';
import 'package:ngetrack/core/services/notification_service.dart';

final localStorageServiceProvider = Provider((ref) => LocalStorageService());

final habitProvider = NotifierProvider<HabitNotifier, List<Habit>>(
  HabitNotifier.new,
);

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
    // Schedule notifications for existing habits
    for (final habit in habits) {
      if (habit.reminderTime != null) {
        _scheduleNotification(habit);
      }
    }
  }

  Future<void> _saveHabits() async {
    await _storage.saveHabits(state);
  }

  Future<void> addHabit(
    String name,
    int targetPerDay, {
    String? reminderTime,
  }) async {
    final newHabit = Habit(
      name: name,
      targetPerDay: targetPerDay,
      reminderTime: reminderTime,
    );

    state = [...state, newHabit];
    await _saveHabits();

    if (reminderTime != null) {
      _scheduleNotification(newHabit);
    }
  }

  Future<void> deleteHabit(String id) async {
    final habit = state.firstWhere((h) => h.id == id);
    // Use hashCode of ID as notification ID (simple approach)
    await NotificationService().cancelNotification(habit.id.hashCode);

    state = state.where((h) => h.id != id).toList();
    await _saveHabits();
  }

  Future<void> updateReminder(String id, String? time) async {
    state = [
      for (final h in state)
        if (h.id == id) h.copyWith(reminderTime: time) else h,
    ];
    await _saveHabits();

    final habit = state.firstWhere((h) => h.id == id);
    if (time != null) {
      _scheduleNotification(habit);
    } else {
      await NotificationService().cancelNotification(habit.id.hashCode);
    }
  }

  Future<void> _scheduleNotification(Habit habit) async {
    if (habit.reminderTime == null) return;

    final parts = habit.reminderTime!.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await NotificationService().scheduleDailyNotification(
      id: habit.id.hashCode,
      title: "Saatnya ${habit.name}!",
      body: "Jangan lupa selesaikan targetmu hari ini.",
      hour: hour,
      minute: minute,
    );
  }

  Future<void> toggleHabit(String id, DateTime date) async {
    state = state.map((habit) {
      if (habit.id != id) return habit;

      final dateKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final currentProgress = habit.dailyProgress[dateKey] ?? 0;

      final isCompleted = currentProgress >= habit.targetPerDay;
      final newProgress = isCompleted ? 0 : habit.targetPerDay;

      final newDailyProgress = Map<String, int>.from(habit.dailyProgress);
      newDailyProgress[dateKey] = newProgress;

      final newCompletedDates = List<DateTime>.from(habit.completedDates);
      final dateOnly = DateTime(date.year, date.month, date.day);

      if (!isCompleted) {
        if (!newCompletedDates.any(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        )) {
          newCompletedDates.add(dateOnly);
        }
      } else {
        newCompletedDates.removeWhere(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        );
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

      final dateKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final currentProgress = habit.dailyProgress[dateKey] ?? 0;
      final newProgress = (currentProgress + delta).clamp(0, 999);

      final newDailyProgress = Map<String, int>.from(habit.dailyProgress);
      newDailyProgress[dateKey] = newProgress;

      final newCompletedDates = List<DateTime>.from(habit.completedDates);
      final dateOnly = DateTime(date.year, date.month, date.day);
      final isCompleted = newProgress >= habit.targetPerDay;

      if (isCompleted) {
        if (!newCompletedDates.any(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        )) {
          newCompletedDates.add(dateOnly);
        }
      } else {
        newCompletedDates.removeWhere(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        );
      }

      return habit.copyWith(
        dailyProgress: newDailyProgress,
        completedDates: newCompletedDates,
      );
    }).toList();
    await _storage.saveHabits(state);
  }
}
