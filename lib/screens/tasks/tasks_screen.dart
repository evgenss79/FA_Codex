import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/family_member.dart';
import '../../models/task.dart';
import '../../providers/family_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';
import '../../widgets/task_card.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TaskProvider taskProvider = context.watch<TaskProvider>();
    final FamilyProvider familyProvider = context.watch<FamilyProvider>();

    if (taskProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Task> pending = taskProvider.pendingTasks();
    final List<Task> completed = taskProvider.completedTasks();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: <Widget>[
          SectionHeader(title: l10n.translate('moduleTasks')),
          if (pending.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EmptyState(message: l10n.translate('emptyState')),
            )
          else
            ...pending.map(
              (Task task) => TaskCard(
                task: task,
                onStatusChanged: (TaskStatus status) =>
                    taskProvider.updateStatus(task.id, status),
              ),
            ),
          SectionHeader(title: l10n.translate('completedTasks')),
          if (completed.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EmptyState(message: l10n.translate('emptyState')),
            )
          else
            ...completed.map((Task task) => TaskCard(task: task)),
          SectionHeader(title: l10n.translate('totalPoints')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: familyProvider.members
                  .map(
                    (FamilyMember member) => Chip(
                      avatar: CircleAvatar(child: Text(member.displayName.characters.first)),
                      label: Text('${member.displayName}: ${member.rewards}'),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
