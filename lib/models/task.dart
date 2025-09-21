import 'package:flutter/foundation.dart';

enum TaskStatus { pending, inProgress, completed, archived }

enum TaskPriority { low, medium, high }

@immutable
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.creatorId,
    this.description,
    this.assigneeIds = const <String>[],
    this.watchers = const <String>[],
    this.dueDate,
    this.reminder,
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.medium,
    this.rewardPoints = 0,
    this.isRecurring = false,
    this.locationId,
    this.attachments = const <String>[],
    this.tags = const <String>[],
    this.completedAt,
  });

  final String id;
  final String title;
  final String creatorId;
  final String? description;
  final List<String> assigneeIds;
  final List<String> watchers;
  final DateTime? dueDate;
  final DateTime? reminder;
  final TaskStatus status;
  final TaskPriority priority;
  final int rewardPoints;
  final bool isRecurring;
  final String? locationId;
  final List<String> attachments;
  final List<String> tags;
  final DateTime? completedAt;

  bool get isCompleted => status == TaskStatus.completed;

  Task copyWith({
    String? id,
    String? title,
    String? creatorId,
    String? description,
    List<String>? assigneeIds,
    List<String>? watchers,
    DateTime? dueDate,
    DateTime? reminder,
    TaskStatus? status,
    TaskPriority? priority,
    int? rewardPoints,
    bool? isRecurring,
    String? locationId,
    List<String>? attachments,
    List<String>? tags,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      creatorId: creatorId ?? this.creatorId,
      description: description ?? this.description,
      assigneeIds: assigneeIds ?? this.assigneeIds,
      watchers: watchers ?? this.watchers,
      dueDate: dueDate ?? this.dueDate,
      reminder: reminder ?? this.reminder,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      isRecurring: isRecurring ?? this.isRecurring,
      locationId: locationId ?? this.locationId,
      attachments: attachments ?? this.attachments,
      tags: tags ?? this.tags,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'creatorId': creatorId,
      'description': description,
      'assigneeIds': assigneeIds,
      'watchers': watchers,
      'dueDate': dueDate?.toIso8601String(),
      'reminder': reminder?.toIso8601String(),
      'status': status.index,
      'priority': priority.index,
      'rewardPoints': rewardPoints,
      'isRecurring': isRecurring,
      'locationId': locationId,
      'attachments': attachments,
      'tags': tags,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      creatorId: json['creatorId'] as String,
      description: json['description'] as String?,
      assigneeIds: (json['assigneeIds'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
      watchers: (json['watchers'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.tryParse(json['dueDate'] as String),
      reminder: json['reminder'] == null
          ? null
          : DateTime.tryParse(json['reminder'] as String),
      status: TaskStatus.values[(json['status'] as int?) ?? 0],
      priority: TaskPriority.values[(json['priority'] as int?) ?? 1],
      rewardPoints: json['rewardPoints'] as int? ?? 0,
      isRecurring: json['isRecurring'] as bool? ?? false,
      locationId: json['locationId'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.tryParse(json['completedAt'] as String),
    );
  }
}
