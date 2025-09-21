import 'package:flutter/foundation.dart';

@immutable
class LocationPoint {
  const LocationPoint({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    this.category,
    this.address,
    this.notes,
    this.radius = 200,
  });

  final String id;
  final String title;
  final double latitude;
  final double longitude;
  final String? category;
  final String? address;
  final String? notes;
  final double radius;

  LocationPoint copyWith({
    String? id,
    String? title,
    double? latitude,
    double? longitude,
    String? category,
    String? address,
    String? notes,
    double? radius,
  }) {
    return LocationPoint(
      id: id ?? this.id,
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      radius: radius ?? this.radius,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'address': address,
      'notes': notes,
      'radius': radius,
    };
  }

  factory LocationPoint.fromJson(Map<String, dynamic> json) {
    return LocationPoint(
      id: json['id'] as String,
      title: json['title'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: json['category'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      radius: (json['radius'] as num?)?.toDouble() ?? 200,
    );
  }
}
