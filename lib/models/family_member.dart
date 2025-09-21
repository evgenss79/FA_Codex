import 'package:flutter/foundation.dart';

import 'family_role.dart';

typedef SocialLinks = Map<String, String>;

typedef DocumentLinks = Map<String, String>;

@immutable
class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.displayName,
    required this.role,
    this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.bio,
    this.birthday,
    this.interests = const <String>[],
    this.socialLinks = const <String, String>{},
    this.documentLinks = const <String, String>{},
    this.rewards = 0,
    this.isChild = false,
    this.preferredModules = const <String>{},
  });

  final String id;
  final String displayName;
  final FamilyRole role;
  final String? email;
  final String? phoneNumber;
  final String? avatarUrl;
  final String? bio;
  final DateTime? birthday;
  final List<String> interests;
  final SocialLinks socialLinks;
  final DocumentLinks documentLinks;
  final int rewards;
  final bool isChild;
  final Set<String> preferredModules;

  FamilyMember copyWith({
    String? id,
    String? displayName,
    FamilyRole? role,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? bio,
    DateTime? birthday,
    List<String>? interests,
    SocialLinks? socialLinks,
    DocumentLinks? documentLinks,
    int? rewards,
    bool? isChild,
    Set<String>? preferredModules,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      birthday: birthday ?? this.birthday,
      interests: interests ?? this.interests,
      socialLinks: socialLinks ?? this.socialLinks,
      documentLinks: documentLinks ?? this.documentLinks,
      rewards: rewards ?? this.rewards,
      isChild: isChild ?? this.isChild,
      preferredModules: preferredModules ?? this.preferredModules,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'role': role.id,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'birthday': birthday?.toIso8601String(),
      'interests': interests,
      'socialLinks': socialLinks,
      'documentLinks': documentLinks,
      'rewards': rewards,
      'isChild': isChild,
      'preferredModules': preferredModules.toList(),
    };
  }

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      role: FamilyRoleX.fromId(json['role'] as String),
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.tryParse(json['birthday'] as String),
      interests: (json['interests'] as List<dynamic>?)
              ?.map((dynamic e) => e as String)
              .toList() ??
          <String>[],
      socialLinks: (json['socialLinks'] as Map<dynamic, dynamic>?)
              ?.map(
                (dynamic key, dynamic value) =>
                    MapEntry(key.toString(), value.toString()),
              ) ??
          <String, String>{},
      documentLinks: (json['documentLinks'] as Map<dynamic, dynamic>?)
              ?.map(
                (dynamic key, dynamic value) =>
                    MapEntry(key.toString(), value.toString()),
              ) ??
          <String, String>{},
      rewards: json['rewards'] as int? ?? 0,
      isChild: json['isChild'] as bool? ?? false,
      preferredModules: ((json['preferredModules'] as List<dynamic>?) ?? <dynamic>[])
          .map((dynamic e) => e.toString())
          .toSet(),
    );
  }
}
