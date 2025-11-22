// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Habit _$HabitFromJson(Map<String, dynamic> json) => Habit(
  id: json['id'] as String?,
  name: json['name'] as String,
  targetPerDay: (json['targetPerDay'] as num).toInt(),
  completedDates:
      (json['completedDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ??
      const [],
  dailyProgress:
      (json['dailyProgress'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  reminderTime: json['reminderTime'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  isArchived: json['isArchived'] as bool? ?? false,
);

Map<String, dynamic> _$HabitToJson(Habit instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'targetPerDay': instance.targetPerDay,
  'completedDates': instance.completedDates
      .map((e) => e.toIso8601String())
      .toList(),
  'createdAt': instance.createdAt.toIso8601String(),
  'isArchived': instance.isArchived,
  'dailyProgress': instance.dailyProgress,
  'reminderTime': instance.reminderTime,
};
