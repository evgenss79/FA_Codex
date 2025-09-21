import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/family_member.dart';
import '../../models/task.dart';
import '../../providers/event_provider.dart';
import '../../providers/family_provider.dart';
import '../../providers/media_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/member_avatar.dart';
import '../../widgets/recommendation_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/task_card.dart';
import '../calendar/calendar_screen.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final FamilyProvider familyProvider = context.watch<FamilyProvider>();
    final TaskProvider taskProvider = context.watch<TaskProvider>();
    final EventProvider eventProvider = context.watch<EventProvider>();
    final MediaProvider mediaProvider = context.watch<MediaProvider>();

    final List<Task> todaysTasks = taskProvider.tasks.where((Task task) {
      if (task.dueDate == null) {
        return false;
      }
      final DateTime now = DateTime.now();
      return task.dueDate!.year == now.year &&
          task.dueDate!.month == now.month &&
          task.dueDate!.day == now.day;
    }).toList();

    final List<FamilyMember> members = familyProvider.members;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${l10n.translate('welcomeTitle')}, ${members.isNotEmpty ? members.first.displayName : 'Family'}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            SectionHeader(title: l10n.translate('tasksDueToday')),
            if (todaysTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EmptyState(message: l10n.translate('emptyState')),
              )
            else
              ...todaysTasks.map(
                (Task task) => TaskCard(
                  task: task,
                  onStatusChanged: (TaskStatus status) =>
                      taskProvider.updateStatus(task.id, status),
                ),
              ),
            SectionHeader(title: l10n.translate('eventsThisWeek'), actionLabel: l10n.translate('addNew'), onActionPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CalendarScreen(),
                ),
              );
            }),
            if (eventProvider.events.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EmptyState(message: l10n.translate('emptyState')),
              )
            else
              ...eventProvider.upcomingEvents(DateTime.now(), limit: 3).map(
                (event) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    child: ListTile(
                      title: Text(event.title),
                      subtitle: Text(
                        '${event.start.day}.${event.start.month}.${event.start.year}',
                      ),
                    ),
                  ),
                ),
              ),
            SectionHeader(title: l10n.translate('familyMembers')),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: members.length,
                itemBuilder: (BuildContext context, int index) {
                  final FamilyMember member = members[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: <Widget>[
                        MemberAvatar(member: member),
                        const SizedBox(height: 8),
                        Text(member.displayName, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  );
                },
              ),
            ),
            SectionHeader(title: l10n.translate('mediaHighlights')),
            if (mediaProvider.recommendations.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EmptyState(message: l10n.translate('emptyState')),
              )
            else
              ...mediaProvider.recommendations
                  .map((recommendation) => RecommendationCard(recommendation: recommendation)),
          ],
        ),
      ),
    );
  }
}
