import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/schedule_item.dart';
import '../../providers/family_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ScheduleProvider scheduleProvider = context.watch<ScheduleProvider>();
    final FamilyProvider familyProvider = context.watch<FamilyProvider>();

    if (scheduleProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final Map<int, List<ScheduleItem>> grouped = groupBy<ScheduleItem, int>(
      scheduleProvider.items,
      (ScheduleItem item) => item.weekday ?? item.startTime.weekday,
    );

    if (grouped.isEmpty) {
      return Center(child: EmptyState(message: l10n.translate('emptyState')));
    }

    final List<int> sortedKeys = grouped.keys.toList()..sort();
    return SafeArea(
      child: ListView.builder(
        itemCount: sortedKeys.length,
        itemBuilder: (BuildContext context, int index) {
          final int weekday = sortedKeys[index];
          final List<ScheduleItem> items = grouped[weekday] ?? <ScheduleItem>[];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionHeader(title: _weekdayLabel(weekday)),
              for (final ScheduleItem item in items)
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(
                      '${_formatTime(item.startTime)} - ${_formatTime(item.endTime)} | ${_memberName(familyProvider, item.memberId)}',
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _weekdayLabel(int weekday) {
    const List<String> names = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[(weekday - 1) % names.length];
  }

  String _formatTime(DateTime time) {
    final String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(time.hour)}:${twoDigits(time.minute)}';
  }

  String _memberName(FamilyProvider provider, String memberId) {
    return provider.members.firstWhereOrNull((member) => member.id == memberId)?.displayName ?? 'Unknown';
  }
}
