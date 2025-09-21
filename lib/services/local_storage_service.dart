import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/ai_recommendation.dart';
import '../models/chat_message.dart';
import '../models/chat_thread.dart';
import '../models/event.dart';
import '../models/family.dart';
import '../models/family_module.dart';
import '../models/location_point.dart';
import '../models/media_item.dart';
import '../models/schedule_item.dart';
import '../models/task.dart';

class LocalStorageService {
  static const String _appBoxName = 'family_app_box';
  bool _initialized = false;
  Box<dynamic>? _box;
  final Map<String, dynamic> _memoryCache = <String, dynamic>{};

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox<dynamic>(_appBoxName);
    } catch (_) {
      _box = null;
    }
    _initialized = true;
  }

  dynamic _get(String key) {
    if (_box != null && _box!.isOpen) {
      return _box!.get(key);
    }
    return _memoryCache[key];
  }

  Future<void> _set(String key, dynamic value) async {
    if (_box != null && _box!.isOpen) {
      await _box!.put(key, value);
    } else {
      _memoryCache[key] = value;
    }
  }

  Future<void> _delete(String key) async {
    if (_box != null && _box!.isOpen) {
      await _box!.delete(key);
    } else {
      _memoryCache.remove(key);
    }
  }

  Future<void> saveFamily(Family family) async {
    await _set('family', family.toJson());
  }

  Future<Family?> loadFamily() async {
    final dynamic data = _get('family');
    if (data is Map<dynamic, dynamic>) {
      return Family.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<void> saveTasks(List<Task> tasks) async {
    await _set('tasks', tasks.map((Task e) => e.toJson()).toList());
  }

  Future<List<Task>> loadTasks() async {
    final dynamic data = _get('tasks');
    if (data is List<dynamic>) {
      return data
          .map((dynamic e) => Task.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return <Task>[];
  }

  Future<void> saveEvents(List<Event> events) async {
    await _set('events', events.map((Event e) => e.toJson()).toList());
  }

  Future<List<Event>> loadEvents() async {
    final dynamic data = _get('events');
    if (data is List<dynamic>) {
      return data
          .map((dynamic e) => Event.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return <Event>[];
  }

  Future<void> saveScheduleItems(List<ScheduleItem> items) async {
    await _set('schedule', items.map((ScheduleItem e) => e.toJson()).toList());
  }

  Future<List<ScheduleItem>> loadScheduleItems() async {
    final dynamic data = _get('schedule');
    if (data is List<dynamic>) {
      return data
          .map((dynamic e) =>
              ScheduleItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return <ScheduleItem>[];
  }

  Future<void> saveChatThreads(List<ChatThread> threads) async {
    await _set('chatThreads', threads.map((ChatThread e) => e.toJson()).toList());
  }

  Future<List<ChatThread>> loadChatThreads() async {
    final dynamic data = _get('chatThreads');
    if (data is List<dynamic>) {
      return data
          .map((dynamic e) =>
              ChatThread.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return <ChatThread>[];
  }

  Future<void> saveChatMessages(Map<String, List<ChatMessage>> messages) async {
    final Map<String, dynamic> encoded = <String, dynamic>{};
    messages.forEach((String key, List<ChatMessage> value) {
      encoded[key] = value.map((ChatMessage e) => e.toJson()).toList();
    });
    await _set('chatMessages', encoded);
  }

  Future<Map<String, List<ChatMessage>>> loadChatMessages() async {
    final dynamic data = _get('chatMessages');
    if (data is Map<dynamic, dynamic>) {
      return data.map(
        (dynamic key, dynamic value) => MapEntry(
          key.toString(),
          (value as List<dynamic>)
              .map((dynamic e) =>
                  ChatMessage.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList(),
        ),
      );
    }
    return <String, List<ChatMessage>>{};
  }

  Future<void> saveMediaItems(List<MediaItem> items) async {
    await _set('mediaItems', items.map((MediaItem e) => e.toJson()).toList());
  }

  Future<List<MediaItem>> loadMediaItems() async {
    final dynamic data = _get('mediaItems');
    if (data is List<dynamic>) {
      return data
          .map((dynamic e) =>
              MediaItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return <MediaItem>[];
  }

  Future<void> saveRecommendations(List<AiRecommendation> recommendations) async {
    await _set('recommendations',
        recommendations.map((AiRecommendation e) => e.toJson()).toList());
  }

  Future<List<AiRecommendation>> loadRecommendations() async {
    final dynamic data = _get('recommendations');
    if (data is List<dynamic>) {
      return data
          .map((dynamic e) => AiRecommendation.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return <AiRecommendation>[];
  }

  Future<void> saveLocations(List<LocationPoint> locations) async {
    await _set('locations', locations.map((LocationPoint e) => e.toJson()).toList());
  }

  Future<List<LocationPoint>> loadLocations() async {
    final dynamic data = _get('locations');
    if (data is List<dynamic>) {
      return data
          .map((dynamic e) => LocationPoint.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    return <LocationPoint>[];
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _set('themeMode', mode.name);
  }

  Future<ThemeMode?> loadThemeMode() async {
    final dynamic data = _get('themeMode');
    if (data is String) {
      return ThemeMode.values.firstWhere(
        (ThemeMode mode) => mode.name == data,
        orElse: () => ThemeMode.system,
      );
    }
    return null;
  }

  Future<void> saveEnabledModules(List<FamilyModule> modules) async {
    await _set('enabledModules', modules.map((FamilyModule e) => e.id).toList());
  }

  Future<Set<FamilyModule>?> loadEnabledModules() async {
    final dynamic data = _get('enabledModules');
    if (data is List<dynamic>) {
      return data
          .map((dynamic e) => FamilyModuleX.fromId(e as String))
          .toSet();
    }
    return null;
  }

  Future<void> clear() async {
    if (_box != null && _box!.isOpen) {
      await _box!.clear();
    }
    _memoryCache.clear();
  }
}
