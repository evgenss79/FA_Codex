import 'package:flutter/foundation.dart';

import 'family_member.dart';
import 'location_point.dart';

@immutable
class Family {
  const Family({
    required this.id,
    required this.name,
    this.members = const <FamilyMember>[],
    this.friends = const <String>[],
    this.moduleToggles = const <String, bool>{},
    this.favoriteLocations = const <LocationPoint>[],
  });

  final String id;
  final String name;
  final List<FamilyMember> members;
  final List<String> friends;
  final Map<String, bool> moduleToggles;
  final List<LocationPoint> favoriteLocations;

  Family copyWith({
    String? id,
    String? name,
    List<FamilyMember>? members,
    List<String>? friends,
    Map<String, bool>? moduleToggles,
    List<LocationPoint>? favoriteLocations,
  }) {
    return Family(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      friends: friends ?? this.friends,
      moduleToggles: moduleToggles ?? this.moduleToggles,
      favoriteLocations: favoriteLocations ?? this.favoriteLocations,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'members': members.map((FamilyMember e) => e.toJson()).toList(),
      'friends': friends,
      'moduleToggles': moduleToggles,
      'favoriteLocations':
          favoriteLocations.map((LocationPoint e) => e.toJson()).toList(),
    };
  }

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'] as String,
      name: json['name'] as String,
      members: (json['members'] as List<dynamic>?)
              ?.map((dynamic e) =>
                  FamilyMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <FamilyMember>[],
      friends: (json['friends'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
      moduleToggles: (json['moduleToggles'] as Map<dynamic, dynamic>?)
              ?.map(
                (dynamic key, dynamic value) =>
                    MapEntry(key.toString(), value as bool),
              ) ??
          <String, bool>{},
      favoriteLocations: (json['favoriteLocations'] as List<dynamic>?)
              ?.map((dynamic e) =>
                  LocationPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <LocationPoint>[],
    );
  }
}
