import 'package:flutter/foundation.dart';

enum MessageType { text, image, video, file }

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    this.type = MessageType.text,
    this.mediaUrl,
    this.reactions = const <String, List<String>>{},
    this.isRead = false,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final MessageType type;
  final String? mediaUrl;
  final Map<String, List<String>> reactions;
  final bool isRead;

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    DateTime? sentAt,
    MessageType? type,
    String? mediaUrl,
    Map<String, List<String>>? reactions,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      reactions: reactions ?? this.reactions,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'sentAt': sentAt.toIso8601String(),
      'type': type.index,
      'mediaUrl': mediaUrl,
      'reactions': reactions.map(
        (String key, List<String> value) => MapEntry(key, value),
      ),
      'isRead': isRead,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      type: MessageType.values[(json['type'] as int?) ?? 0],
      mediaUrl: json['mediaUrl'] as String?,
      reactions: (json['reactions'] as Map<dynamic, dynamic>?)
              ?.map(
                (dynamic key, dynamic value) => MapEntry(
                  key.toString(),
                  (value as List<dynamic>).map((dynamic e) => e as String).toList(),
                ),
              ) ??
          <String, List<String>>{},
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}
