import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onStatusChanged,
    this.onTap,
  });

  final Task task;
  final ValueChanged<TaskStatus>? onStatusChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Checkbox(
                value: task.status == TaskStatus.completed,
                onChanged: onStatusChanged == null
                    ? null
                    : (_) => onStatusChanged!(task.status == TaskStatus.completed
                        ? TaskStatus.pending
                        : TaskStatus.completed),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (task.description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    if (task.dueDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Due ${_formatDate(task.dueDate!)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: colorScheme.secondary),
                        ),
                      ),
                  ],
                ),
              ),
              if (task.rewardPoints > 0)
                Chip(
                  label: Text('+${task.rewardPoints}'),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: colorScheme.tertiaryContainer,
                  labelStyle: TextStyle(color: colorScheme.onTertiaryContainer),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'today';
    }
    return '${date.day}.${date.month}.${date.year}';
  }
}
