import 'package:flutter/foundation.dart';

enum MediaType { photo, video, document }

@immutable
class MediaItem {
  const MediaItem({
    required this.id,
    required this.url,
    required this.ownerId,
    required this.createdAt,
    this.type = MediaType.photo,
    this.eventId,
    this.taskId,
    this.caption,
    this.locationId,
    this.sharedWith = const <String>[],
  });

  final String id;
  final String url;
  final String ownerId;
  final DateTime createdAt;
  final MediaType type;
  final String? eventId;
  final String? taskId;
  final String? caption;
  final String? locationId;
  final List<String> sharedWith;

  MediaItem copyWith({
    String? id,
    String? url,
    String? ownerId,
    DateTime? createdAt,
    MediaType? type,
    String? eventId,
    String? taskId,
    String? caption,
    String? locationId,
    List<String>? sharedWith,
  }) {
    return MediaItem(
      id: id ?? this.id,
      url: url ?? this.url,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      eventId: eventId ?? this.eventId,
      taskId: taskId ?? this.taskId,
      caption: caption ?? this.caption,
      locationId: locationId ?? this.locationId,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
      'type': type.index,
      'eventId': eventId,
      'taskId': taskId,
      'caption': caption,
      'locationId': locationId,
      'sharedWith': sharedWith,
    };
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      url: json['url'] as String,
      ownerId: json['ownerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: MediaType.values[(json['type'] as int?) ?? 0],
      eventId: json['eventId'] as String?,
      taskId: json['taskId'] as String?,
      caption: json['caption'] as String?,
      locationId: json['locationId'] as String?,
      sharedWith: (json['sharedWith'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
    );
  }
}
