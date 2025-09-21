import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/event.dart';
import '../models/family_member.dart';
import '../services/local_storage_service.dart';
import 'family_provider.dart';

class EventProvider extends ChangeNotifier {
  EventProvider({required this.storageService}) {
    _load();
  }

  final LocalStorageService storageService;
  final Uuid _uuid = const Uuid();

  List<Event> _events = <Event>[];
  bool _loading = true;
  FamilyProvider? _familyProvider;
  VoidCallback? _familyListener;

  List<Event> get events => _events;

  bool get isLoading => _loading;

  void attachFamilyProvider(FamilyProvider familyProvider) {
    if (_familyProvider != familyProvider) {
      if (_familyProvider != null && _familyListener != null) {
        _familyProvider!.removeListener(_familyListener!);
      }
      _familyProvider = familyProvider;
      _familyListener = _handleFamilyUpdated;
      _familyProvider!.addListener(_familyListener!);
    }
    _seedIfNeeded();
  }

  Future<void> _load() async {
    _events = await storageService.loadEvents();
    _loading = false;
    notifyListeners();
    await _seedIfNeeded();
  }

  Future<void> _seedIfNeeded() async {
    if (_events.isNotEmpty || _familyProvider == null) {
      return;
    }

    final List<Event> seeded = _createSampleEvents(_familyProvider!.members);
    if (seeded.isEmpty) {
      return;
    }

    _events = seeded;
    await storageService.saveEvents(_events);
    notifyListeners();
  }

  void _handleFamilyUpdated() {
    _seedIfNeeded();
  }

  List<Event> _createSampleEvents(List<FamilyMember> members) {
    if (members.isEmpty) {
      return <Event>[];
    }

    final String ownerId = members.first.id;
    final DateTime now = DateTime.now();
    return <Event>[
      Event(
        id: _uuid.v4(),
        title: 'Family dinner',
        createdBy: ownerId,
        start: DateTime(now.year, now.month, now.day, 18, 30),
        end: DateTime(now.year, now.month, now.day, 20, 0),
        description: 'Cook together and share highlights of the week.',
        participantIds: members.map((FamilyMember member) => member.id).toList(),
        type: EventType.celebration,
        reminders: const <Duration>[Duration(hours: 2), Duration(minutes: 30)],
      ),
      Event(
        id: _uuid.v4(),
        title: 'Doctor appointment',
        createdBy: ownerId,
        start: now.add(const Duration(days: 1, hours: 10)),
        end: now.add(const Duration(days: 1, hours: 11)),
        description: 'Annual check-up.',
        participantIds: <String>[members.first.id],
        type: EventType.appointment,
        visibility: EventVisibility.private,
      ),
    ];
  }

  Future<void> addEvent(Event event) async {
    _events = List<Event>.from(_events)..add(event);
    await storageService.saveEvents(_events);
    notifyListeners();
  }

  Future<Event> createEvent({
    required String title,
    required String createdBy,
    required DateTime start,
    required DateTime end,
    String? description,
    String? location,
    List<String>? participantIds,
    EventType type = EventType.appointment,
    EventVisibility visibility = EventVisibility.family,
  }) async {
    final Event event = Event(
      id: _uuid.v4(),
      title: title,
      start: start,
      end: end,
      createdBy: createdBy,
      description: description,
      location: location,
      participantIds: participantIds ?? <String>[],
      type: type,
      visibility: visibility,
    );
    await addEvent(event);
    return event;
  }

  Future<void> updateEvent(Event event) async {
    _events = _events.map((Event existing) => existing.id == event.id ? event : existing).toList();
    await storageService.saveEvents(_events);
    notifyListeners();
  }

  Future<void> deleteEvent(String eventId) async {
    _events = _events.where((Event event) => event.id != eventId).toList();
    await storageService.saveEvents(_events);
    notifyListeners();
  }

  List<Event> eventsForDay(DateTime date) {
    return _events.where((Event event) {
      return event.start.year == date.year &&
          event.start.month == date.month &&
          event.start.day == date.day;
    }).toList();
  }

  List<Event> upcomingEvents(DateTime now, {int limit = 10}) {
    final List<Event> upcoming = _events
        .where((Event event) => event.start.isAfter(now))
        .toList()
      ..sort((Event a, Event b) => a.start.compareTo(b.start));
    if (upcoming.length <= limit) {
      return upcoming;
    }
    return upcoming.sublist(0, limit);
  }

  @override
  void dispose() {
    if (_familyProvider != null && _familyListener != null) {
      _familyProvider!.removeListener(_familyListener!);
    }
    super.dispose();
  }
}
