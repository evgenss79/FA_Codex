import 'package:flutter/foundation.dart';

class NotificationService {
  final Map<String, DateTime> _scheduledReminders = <String, DateTime>{};

  Future<void> initialize() async {
    debugPrint('NotificationService initialized');
  }

  Future<void> scheduleReminder({
    required String id,
    required DateTime time,
    required String title,
    required String body,
  }) async {
    debugPrint('Reminder scheduled: $title at $time');
    _scheduledReminders[id] = time;
  }

  Future<void> cancelReminder(String id) async {
    debugPrint('Reminder cancelled: $id');
    _scheduledReminders.remove(id);
  }

  List<String> get activeReminderIds => _scheduledReminders.keys.toList();
}
