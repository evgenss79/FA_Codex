import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/family_member.dart';
import '../models/schedule_item.dart';
import '../services/local_storage_service.dart';
import 'family_provider.dart';

class ScheduleProvider extends ChangeNotifier {
  ScheduleProvider({required this.storageService}) {
    _load();
  }

  final LocalStorageService storageService;
  final Uuid _uuid = const Uuid();

  List<ScheduleItem> _items = <ScheduleItem>[];
  bool _loading = true;
  FamilyProvider? _familyProvider;
  VoidCallback? _familyListener;

  List<ScheduleItem> get items => _items;

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
    _items = await storageService.loadScheduleItems();
    _loading = false;
    notifyListeners();
    await _seedIfNeeded();
  }

  Future<void> _seedIfNeeded() async {
    if (_items.isNotEmpty || _familyProvider == null) {
      return;
    }

    final List<ScheduleItem> seeded = _createSampleSchedule(_familyProvider!.members);
    if (seeded.isEmpty) {
      return;
    }

    _items = seeded;
    await storageService.saveScheduleItems(_items);
    notifyListeners();
  }

  void _handleFamilyUpdated() {
    _seedIfNeeded();
  }

  List<ScheduleItem> _createSampleSchedule(List<FamilyMember> members) {
    if (members.isEmpty) {
      return <ScheduleItem>[];
    }

    final DateTime now = DateTime.now();
    return <ScheduleItem>[
      ScheduleItem(
        id: _uuid.v4(),
        title: 'Football practice',
        memberId: members.last.id,
        startTime: DateTime(now.year, now.month, now.day, 16, 0),
        endTime: DateTime(now.year, now.month, now.day, 18, 0),
        frequency: ScheduleFrequency.weekly,
        weekday: DateTime.monday,
        location: 'Community stadium',
      ),
      ScheduleItem(
        id: _uuid.v4(),
        title: 'Yoga class',
        memberId: members.first.id,
        startTime: DateTime(now.year, now.month, now.day, 7, 30),
        endTime: DateTime(now.year, now.month, now.day, 8, 30),
        frequency: ScheduleFrequency.weekly,
        weekday: DateTime.wednesday,
        location: 'Wellness center',
      ),
    ];
  }

  Future<void> addItem(ScheduleItem item) async {
    _items = List<ScheduleItem>.from(_items)..add(item);
    await storageService.saveScheduleItems(_items);
    notifyListeners();
  }

  Future<ScheduleItem> createItem({
    required String title,
    required String memberId,
    required DateTime startTime,
    required DateTime endTime,
    ScheduleFrequency frequency = ScheduleFrequency.weekly,
    int? weekday,
    String? notes,
    String? location,
  }) async {
    final ScheduleItem item = ScheduleItem(
      id: _uuid.v4(),
      title: title,
      memberId: memberId,
      startTime: startTime,
      endTime: endTime,
      frequency: frequency,
      weekday: weekday,
      notes: notes,
      location: location,
    );
    await addItem(item);
    return item;
  }

  Future<void> updateItem(ScheduleItem item) async {
    _items = _items.map((ScheduleItem existing) => existing.id == item.id ? item : existing).toList();
    await storageService.saveScheduleItems(_items);
    notifyListeners();
  }

  Future<void> deleteItem(String itemId) async {
    _items = _items.where((ScheduleItem item) => item.id != itemId).toList();
    await storageService.saveScheduleItems(_items);
    notifyListeners();
  }

  List<ScheduleItem> scheduleForMember(String memberId) {
    return _items.where((ScheduleItem item) => item.memberId == memberId).toList();
  }

  List<ScheduleItem> scheduleForWeekday(int weekday) {
    return _items.where((ScheduleItem item) => item.weekday == weekday).toList();
  }

  @override
  void dispose() {
    if (_familyProvider != null && _familyListener != null) {
      _familyProvider!.removeListener(_familyListener!);
    }
    super.dispose();
  }
}
