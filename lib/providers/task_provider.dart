import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/family_member.dart';
import '../models/family_module.dart';
import '../models/task.dart';
import '../services/local_storage_service.dart';
import 'family_provider.dart';
import 'settings_provider.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider({required this.storageService}) {
    _load();
  }

  final LocalStorageService storageService;
  final Uuid _uuid = const Uuid();

  List<Task> _tasks = <Task>[];
  bool _loading = true;
  FamilyProvider? _familyProvider;
  SettingsProvider? _settingsProvider;
  VoidCallback? _familyListener;

  List<Task> get tasks => _tasks;

  bool get isLoading => _loading;

  void attachDependencies(
    FamilyProvider familyProvider,
    SettingsProvider settingsProvider,
  ) {
    if (_familyProvider != familyProvider) {
      if (_familyProvider != null && _familyListener != null) {
        _familyProvider!.removeListener(_familyListener!);
      }
      _familyProvider = familyProvider;
      _familyListener = _handleFamilyUpdated;
      _familyProvider!.addListener(_familyListener!);
    }

    _settingsProvider = settingsProvider;
    _seedIfNeeded();
  }

  Future<void> _load() async {
    _tasks = await storageService.loadTasks();
    _loading = false;
    notifyListeners();
    await _seedIfNeeded();
  }

  Future<void> _seedIfNeeded() async {
    if (_tasks.isNotEmpty || _familyProvider == null) {
      return;
    }

    final List<Task> seeded = _createSampleTasks(_familyProvider!.members);
    if (seeded.isEmpty) {
      return;
    }
    _tasks = seeded;
    await storageService.saveTasks(_tasks);
    notifyListeners();
  }

  void _handleFamilyUpdated() {
    _seedIfNeeded();
  }

  List<Task> _createSampleTasks(List<FamilyMember> members) {
    if (members.isEmpty) {
      return <Task>[];
    }

    final String parentId = members.first.id;
    final String? childId = members.length > 1 ? members[1].id : null;

    return <Task>[
      Task(
        id: _uuid.v4(),
        title: 'Grocery shopping',
        description: 'Buy milk, eggs, vegetables and cereal.',
        creatorId: parentId,
        assigneeIds: <String>[parentId],
        dueDate: DateTime.now().add(const Duration(days: 1)),
        rewardPoints: 20,
        priority: TaskPriority.high,
        tags: const <String>['groceries', 'weekly'],
      ),
      if (childId != null)
        Task(
          id: _uuid.v4(),
          title: 'Homework',
          description: 'Complete math exercises for Monday.',
          creatorId: parentId,
          assigneeIds: <String>[childId],
          dueDate: DateTime.now().add(const Duration(days: 2)),
          rewardPoints: 15,
          tags: const <String>['school'],
        ),
    ];
  }

  Future<void> addTask(Task task) async {
    _tasks = List<Task>.from(_tasks)..add(task);
    await storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<Task> createTask({
    required String title,
    required String creatorId,
    String? description,
    List<String>? assignees,
    DateTime? dueDate,
    int rewardPoints = 0,
    TaskPriority priority = TaskPriority.medium,
    List<String>? tags,
    String? locationId,
  }) async {
    final Task task = Task(
      id: _uuid.v4(),
      title: title,
      creatorId: creatorId,
      description: description,
      assigneeIds: assignees ?? <String>[],
      dueDate: dueDate,
      rewardPoints: rewardPoints,
      priority: priority,
      tags: tags ?? <String>[],
      locationId: locationId,
    );

    await addTask(task);
    return task;
  }

  Future<void> updateTask(Task task) async {
    _tasks = _tasks.map((Task existing) => existing.id == task.id ? task : existing).toList();
    await storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    _tasks = _tasks.where((Task task) => task.id != taskId).toList();
    await storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> assignTask(String taskId, List<String> memberIds) async {
    final int index = _tasks.indexWhere((Task task) => task.id == taskId);
    if (index == -1) {
      return;
    }
    final Task updated = _tasks[index].copyWith(assigneeIds: memberIds);
    _tasks[index] = updated;
    await storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> updateStatus(String taskId, TaskStatus status) async {
    final int index = _tasks.indexWhere((Task task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    final Task current = _tasks[index];
    final Task updated = current.copyWith(
      status: status,
      completedAt: status == TaskStatus.completed ? DateTime.now() : current.completedAt,
    );

    _tasks[index] = updated;
    await storageService.saveTasks(_tasks);
    notifyListeners();

    if (status == TaskStatus.completed && updated.rewardPoints > 0) {
      for (final String memberId in updated.assigneeIds) {
        await _familyProvider?.updateMemberReward(memberId, updated.rewardPoints);
      }
    }
  }

  List<Task> tasksForMember(String memberId) {
    return _tasks.where((Task task) => task.assigneeIds.contains(memberId)).toList();
  }

  List<Task> pendingTasks() {
    return _tasks.where((Task task) => task.status == TaskStatus.pending).toList();
  }

  List<Task> completedTasks() {
    return _tasks.where((Task task) => task.status == TaskStatus.completed).toList();
  }

  List<Task> overdueTasks(DateTime now) {
    return _tasks.where((Task task) {
      if (task.dueDate == null) {
        return false;
      }
      return !task.isCompleted && task.dueDate!.isBefore(now);
    }).toList();
  }

  bool moduleEnabled() {
    if (_settingsProvider == null) {
      return true;
    }
    return _settingsProvider!.isModuleEnabled(FamilyModule.tasks);
  }

  @override
  void dispose() {
    if (_familyProvider != null && _familyListener != null) {
      _familyProvider!.removeListener(_familyListener!);
    }
    super.dispose();
  }
}
