import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'habit.g.dart';

@JsonSerializable()
class Habit {
  final String id;
  final String name;
  final int targetPerDay;
  final List<DateTime>
  completedDates; // Tracks dates when habit was fully completed
  final DateTime createdAt;
  final bool isArchived;

  // We'll store daily progress as a map: "2023-10-27": 3 (completed 3 times)
  // For simplicity in this MVP, we'll just track "done" status per day in a list of dates.
  // If a date is in the list, it's "Done". If not, it's "Pending" or "In Progress".
  // To support "3/5 completed", we would need a more complex structure.
  // Let's upgrade to a Map<String, int> for dailyProgress if we want partial completion.
  // For now, let's stick to the user requirement: "Target per Hari (number)" and "Done/Pending".
  // We will assume if it's in completedDates, it's fully done.
  // But wait, the UI shows "3 of 5 completed". So we need partial progress.

  final Map<String, int> dailyProgress; // "yyyy-MM-dd": count

  Habit({
    String? id,
    required this.name,
    required this.targetPerDay,
    this.completedDates = const [],
    this.dailyProgress = const {},
    DateTime? createdAt,
    this.isArchived = false,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  // Helper to get progress for a specific date
  int getProgress(DateTime date) {
    final key = _dateKey(date);
    return dailyProgress[key] ?? 0;
  }

  bool isCompleted(DateTime date) {
    return getProgress(date) >= targetPerDay;
  }

  String _dateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  int get currentStreak {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    int streakFromYesterday = 0;
    DateTime dateCursor = yesterday;

    // Check backwards from yesterday
    while (true) {
      if (isCompleted(dateCursor)) {
        streakFromYesterday++;
        dateCursor = dateCursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    // Add today if completed
    if (isCompleted(today)) {
      return streakFromYesterday + 1;
    } else {
      return streakFromYesterday;
    }
  }

  Habit copyWith({
    String? name,
    int? targetPerDay,
    List<DateTime>? completedDates,
    Map<String, int>? dailyProgress,
    bool? isArchived,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      targetPerDay: targetPerDay ?? this.targetPerDay,
      completedDates: completedDates ?? this.completedDates,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      createdAt: createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
  Map<String, dynamic> toJson() => _$HabitToJson(this);
}
