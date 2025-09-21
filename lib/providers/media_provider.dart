import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/ai_recommendation.dart';
import '../models/family_member.dart';
import '../models/media_item.dart';
import '../services/ai_assistant_service.dart';
import '../services/geolocation_service.dart';
import '../services/local_storage_service.dart';
import 'family_provider.dart';

class MediaProvider extends ChangeNotifier {
  MediaProvider({
    required this.storageService,
    required this.geolocationService,
    required this.aiAssistantService,
  }) {
    _load();
  }

  final LocalStorageService storageService;
  final GeolocationService geolocationService;
  final AiAssistantService aiAssistantService;
  final Uuid _uuid = const Uuid();

  List<MediaItem> _items = <MediaItem>[];
  List<AiRecommendation> _recommendations = <AiRecommendation>[];
  bool _loading = true;
  FamilyProvider? _familyProvider;
  VoidCallback? _familyListener;

  List<MediaItem> get items => _items;

  List<AiRecommendation> get recommendations => _recommendations;

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
    refreshRecommendations();
  }

  Future<void> _load() async {
    _items = await storageService.loadMediaItems();
    _recommendations = await storageService.loadRecommendations();
    _loading = false;
    notifyListeners();
    await _seedIfNeeded();
  }

  Future<void> _seedIfNeeded() async {
    if (_items.isNotEmpty || _familyProvider == null) {
      return;
    }

    final List<MediaItem> seeded = _createSampleMedia(_familyProvider!.members);
    if (seeded.isEmpty) {
      return;
    }

    _items = seeded;
    await storageService.saveMediaItems(_items);
    notifyListeners();
  }

  void _handleFamilyUpdated() {
    _seedIfNeeded();
    refreshRecommendations();
  }

  List<MediaItem> _createSampleMedia(List<FamilyMember> members) {
    if (members.isEmpty) {
      return <MediaItem>[];
    }

    final DateTime now = DateTime.now();
    return <MediaItem>[
      MediaItem(
        id: _uuid.v4(),
        url: 'assets/images/sample_trip.jpg',
        ownerId: members.first.id,
        createdAt: now.subtract(const Duration(days: 3)),
        caption: 'Weekend hiking trip',
        sharedWith: members.map((FamilyMember member) => member.id).toList(),
      ),
      MediaItem(
        id: _uuid.v4(),
        url: 'assets/images/sample_award.jpg',
        ownerId: members.last.id,
        createdAt: now.subtract(const Duration(days: 10)),
        caption: 'Taylor\'s football award',
        sharedWith: members.map((FamilyMember member) => member.id).toList(),
        type: MediaType.photo,
      ),
    ];
  }

  Future<void> addMediaItem(MediaItem item) async {
    _items = List<MediaItem>.from(_items)..add(item);
    await storageService.saveMediaItems(_items);
    await refreshRecommendations();
    notifyListeners();
  }

  Future<MediaItem> createMedia({
    required String ownerId,
    required String url,
    MediaType type = MediaType.photo,
    String? eventId,
    String? taskId,
    String? caption,
    String? locationId,
    List<String>? sharedWith,
  }) async {
    final MediaItem item = MediaItem(
      id: _uuid.v4(),
      ownerId: ownerId,
      url: url,
      type: type,
      eventId: eventId,
      taskId: taskId,
      caption: caption,
      locationId: locationId,
      sharedWith: sharedWith ?? <String>[],
      createdAt: DateTime.now(),
    );
    await addMediaItem(item);
    return item;
  }

  Future<void> removeMedia(String mediaId) async {
    _items = _items.where((MediaItem item) => item.id != mediaId).toList();
    await storageService.saveMediaItems(_items);
    await refreshRecommendations();
    notifyListeners();
  }

  List<MediaItem> mediaForMember(String memberId) {
    return _items.where((MediaItem item) => item.ownerId == memberId).toList();
  }

  List<MediaItem> mediaForEvent(String eventId) {
    return _items.where((MediaItem item) => item.eventId == eventId).toList();
  }

  List<MediaItem> sharedMedia(String memberId) {
    return _items.where((MediaItem item) => item.sharedWith.contains(memberId)).toList();
  }

  Future<void> refreshRecommendations() async {
    if (_familyProvider == null) {
      return;
    }

    final List<AiRecommendation> suggestions = await aiAssistantService.generateMediaHighlights(
      members: _familyProvider!.members,
      media: _items,
    );
    _recommendations = suggestions;
    await storageService.saveRecommendations(_recommendations);
    notifyListeners();
  }

  @override
  void dispose() {
    if (_familyProvider != null && _familyListener != null) {
      _familyProvider!.removeListener(_familyListener!);
    }
    super.dispose();
  }
}
