import 'package:flutter_test/flutter_test.dart';

import 'package:family_app/models/task.dart';
import 'package:family_app/providers/family_provider.dart';
import 'package:family_app/providers/settings_provider.dart';
import 'package:family_app/providers/task_provider.dart';
import 'package:family_app/services/local_storage_service.dart';

Future<void> _waitForAsyncOperations() async {
  await Future<void>.delayed(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TaskProvider', () {
    late LocalStorageService storageService;
    late FamilyProvider familyProvider;
    late SettingsProvider settingsProvider;
    late TaskProvider taskProvider;

    setUp(() async {
      storageService = LocalStorageService();
      await storageService.init();
      await storageService.clear();

      familyProvider = FamilyProvider(storageService: storageService);
      settingsProvider = SettingsProvider(storageService: storageService);
      taskProvider = TaskProvider(storageService: storageService);
      taskProvider.attachDependencies(familyProvider, settingsProvider);
      await _waitForAsyncOperations();
    });

    test('seeds initial demo tasks', () async {
      await _waitForAsyncOperations();
      expect(taskProvider.tasks, isNotEmpty);
    });

    test('completing a task rewards members', () async {
      await _waitForAsyncOperations();
      final Task task = taskProvider.tasks.first;
      final String memberId = task.assigneeIds.first;
      final int initialRewards = familyProvider.members
          .firstWhere((member) => member.id == memberId)
          .rewards;

      await taskProvider.updateStatus(task.id, TaskStatus.completed);
      await _waitForAsyncOperations();

      final int updatedRewards = familyProvider.members
          .firstWhere((member) => member.id == memberId)
          .rewards;

      expect(updatedRewards, initialRewards + task.rewardPoints);
    });
  });
}
