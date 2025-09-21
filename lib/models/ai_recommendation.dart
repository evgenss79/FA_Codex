import 'package:flutter/foundation.dart';

@immutable
class AiRecommendation {
  const AiRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.link,
    this.metadata = const <String, dynamic>{},
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String? link;
  final Map<String, dynamic> metadata;

  AiRecommendation copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? link,
    Map<String, dynamic>? metadata,
  }) {
    return AiRecommendation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      link: link ?? this.link,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'link': link,
      'metadata': metadata,
    };
  }

  factory AiRecommendation.fromJson(Map<String, dynamic> json) {
    return AiRecommendation(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      link: json['link'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ??
          <String, dynamic>{},
    );
  }
}
