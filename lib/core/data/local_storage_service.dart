import 'dart:convert';
import 'package:ngetrack/core/data/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _habitsKey = 'habits_data';

  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_habitsKey, jsonString);
  }

  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_habitsKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Habit.fromJson(json)).toList();
    } catch (e) {
      // If error parsing, return empty list to avoid crash
      return [];
    }
  }
}
