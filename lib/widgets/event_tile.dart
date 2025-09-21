import 'package:flutter/material.dart';

import '../models/event.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(_iconForType(event.type)),
      title: Text(event.title),
      subtitle: Text('${_formatTime(event.start)} - ${_formatTime(event.end)}'),
      trailing: event.isAllDay ? const Chip(label: Text('All day')) : null,
      onTap: () {},
      titleTextStyle: textTheme.titleMedium,
    );
  }

  IconData _iconForType(EventType type) {
    switch (type) {
      case EventType.celebration:
        return Icons.celebration_outlined;
      case EventType.appointment:
        return Icons.event_available_outlined;
      case EventType.reminder:
        return Icons.alarm_outlined;
      case EventType.task:
        return Icons.check_circle_outline;
      case EventType.travel:
        return Icons.flight_takeoff_outlined;
    }
  }

  String _formatTime(DateTime time) {
    final String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(time.hour)}:${twoDigits(time.minute)}';
  }
}
