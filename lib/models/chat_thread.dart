import 'package:flutter/foundation.dart';

@immutable
class ChatThread {
  const ChatThread({
    required this.id,
    required this.title,
    required this.memberIds,
    this.isGroup = false,
    this.avatarUrl,
    this.lastMessage,
    this.updatedAt,
  });

  final String id;
  final String title;
  final List<String> memberIds;
  final bool isGroup;
  final String? avatarUrl;
  final String? lastMessage;
  final DateTime? updatedAt;

  ChatThread copyWith({
    String? id,
    String? title,
    List<String>? memberIds,
    bool? isGroup,
    String? avatarUrl,
    String? lastMessage,
    DateTime? updatedAt,
  }) {
    return ChatThread(
      id: id ?? this.id,
      title: title ?? this.title,
      memberIds: memberIds ?? this.memberIds,
      isGroup: isGroup ?? this.isGroup,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'memberIds': memberIds,
      'isGroup': isGroup,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(
      id: json['id'] as String,
      title: json['title'] as String,
      memberIds: (json['memberIds'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
      isGroup: json['isGroup'] as bool? ?? false,
      avatarUrl: json['avatarUrl'] as String?,
      lastMessage: json['lastMessage'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'] as String),
    );
  }
}
