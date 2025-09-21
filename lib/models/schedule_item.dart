import 'package:flutter/foundation.dart';

enum ScheduleFrequency { once, daily, weekly, monthly }

@immutable
class ScheduleItem {
  const ScheduleItem({
    required this.id,
    required this.title,
    required this.memberId,
    required this.startTime,
    required this.endTime,
    this.frequency = ScheduleFrequency.weekly,
    this.weekday,
    this.notes,
    this.location,
    this.reminders = const <Duration>[],
  });

  final String id;
  final String title;
  final String memberId;
  final DateTime startTime;
  final DateTime endTime;
  final ScheduleFrequency frequency;
  final int? weekday;
  final String? notes;
  final String? location;
  final List<Duration> reminders;

  ScheduleItem copyWith({
    String? id,
    String? title,
    String? memberId,
    DateTime? startTime,
    DateTime? endTime,
    ScheduleFrequency? frequency,
    int? weekday,
    String? notes,
    String? location,
    List<Duration>? reminders,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      memberId: memberId ?? this.memberId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      frequency: frequency ?? this.frequency,
      weekday: weekday ?? this.weekday,
      notes: notes ?? this.notes,
      location: location ?? this.location,
      reminders: reminders ?? this.reminders,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'memberId': memberId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'frequency': frequency.index,
      'weekday': weekday,
      'notes': notes,
      'location': location,
      'reminders': reminders.map((Duration e) => e.inMinutes).toList(),
    };
  }

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'] as String,
      title: json['title'] as String,
      memberId: json['memberId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      frequency: ScheduleFrequency.values[(json['frequency'] as int?) ?? 0],
      weekday: json['weekday'] as int?,
      notes: json['notes'] as String?,
      location: json['location'] as String?,
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((dynamic e) => Duration(minutes: e as int))
              .toList() ??
          <Duration>[],
    );
  }
}
