import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/section_header.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final EventProvider eventProvider = context.watch<EventProvider>();

    if (eventProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final Map<DateTime, List<Event>> grouped = groupBy<Event, DateTime>(
      eventProvider.events,
      (Event event) => DateTime(event.start.year, event.start.month, event.start.day),
    );

    if (grouped.isEmpty) {
      return Center(child: EmptyState(message: l10n.translate('emptyState')));
    }

    final List<DateTime> sortedDays = grouped.keys.toList()
      ..sort((DateTime a, DateTime b) => a.compareTo(b));

    return SafeArea(
      child: ListView.builder(
        itemCount: sortedDays.length,
        itemBuilder: (BuildContext context, int index) {
          final DateTime day = sortedDays[index];
          final List<Event> events = grouped[day] ?? <Event>[];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionHeader(title: '${day.day}.${day.month}.${day.year}'),
              for (final Event event in events)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(child: EventTile(event: event)),
                ),
            ],
          );
        },
      ),
    );
  }
}
