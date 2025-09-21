import 'package:flutter/foundation.dart';

enum EventVisibility { private, family, friends }

enum EventType { celebration, appointment, reminder, task, travel }

@immutable
class Event {
  const Event({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.createdBy,
    this.description,
    this.location,
    this.participantIds = const <String>[],
    this.type = EventType.appointment,
    this.visibility = EventVisibility.family,
    this.reminders = const <Duration>[],
    this.linkedTaskIds = const <String>[],
    this.isAllDay = false,
  });

  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String createdBy;
  final String? description;
  final String? location;
  final List<String> participantIds;
  final EventType type;
  final EventVisibility visibility;
  final List<Duration> reminders;
  final List<String> linkedTaskIds;
  final bool isAllDay;

  Event copyWith({
    String? id,
    String? title,
    DateTime? start,
    DateTime? end,
    String? createdBy,
    String? description,
    String? location,
    List<String>? participantIds,
    EventType? type,
    EventVisibility? visibility,
    List<Duration>? reminders,
    List<String>? linkedTaskIds,
    bool? isAllDay,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      createdBy: createdBy ?? this.createdBy,
      description: description ?? this.description,
      location: location ?? this.location,
      participantIds: participantIds ?? this.participantIds,
      type: type ?? this.type,
      visibility: visibility ?? this.visibility,
      reminders: reminders ?? this.reminders,
      linkedTaskIds: linkedTaskIds ?? this.linkedTaskIds,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'createdBy': createdBy,
      'description': description,
      'location': location,
      'participantIds': participantIds,
      'type': type.index,
      'visibility': visibility.index,
      'reminders': reminders.map((Duration e) => e.inMinutes).toList(),
      'linkedTaskIds': linkedTaskIds,
      'isAllDay': isAllDay,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      createdBy: json['createdBy'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      participantIds: (json['participantIds'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
      type: EventType.values[(json['type'] as int?) ?? 0],
      visibility: EventVisibility.values[(json['visibility'] as int?) ?? 1],
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((dynamic e) => Duration(minutes: e as int))
              .toList() ??
          <Duration>[],
      linkedTaskIds: (json['linkedTaskIds'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
      isAllDay: json['isAllDay'] as bool? ?? false,
    );
  }
}
