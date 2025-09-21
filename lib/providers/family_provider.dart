import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/family.dart';
import '../models/family_member.dart';
import '../models/family_module.dart';
import '../models/family_role.dart';
import '../models/location_point.dart';
import '../services/local_storage_service.dart';

class FamilyProvider extends ChangeNotifier {
  FamilyProvider({required this.storageService}) {
    _load();
  }

  final LocalStorageService storageService;
  final Uuid _uuid = const Uuid();

  Family? _family;
  bool _loading = true;

  Family get family =>
      _family ??
      const Family(
        id: 'family',
        name: 'Family',
      );

  bool get isLoading => _loading;

  List<FamilyMember> get members => family.members;

  List<LocationPoint> get favoriteLocations => family.favoriteLocations;

  Future<void> _load() async {
    final storedFamily = await storageService.loadFamily();
    if (storedFamily != null) {
      _family = storedFamily;
    } else {
      _family = _createSampleFamily();
      await storageService.saveFamily(_family!);
    }

    _loading = false;
    notifyListeners();
  }

  Family _createSampleFamily() {
    final FamilyMember parent = FamilyMember(
      id: _uuid.v4(),
      displayName: 'Alex',
      role: FamilyRole.parent,
      email: 'alex@example.com',
      phoneNumber: '+1 111 222 33 44',
      bio: 'Family lead and schedule guru.',
      interests: const <String>['Travel', 'Cooking'],
      rewards: 120,
      preferredModules: FamilyModule.values.map((FamilyModule e) => e.id).toSet(),
    );

    final FamilyMember partner = FamilyMember(
      id: _uuid.v4(),
      displayName: 'Jamie',
      role: FamilyRole.guardian,
      email: 'jamie@example.com',
      phoneNumber: '+1 222 333 44 55',
      bio: 'Keeps track of school events.',
      interests: const <String>['Reading', 'Yoga'],
      rewards: 85,
      preferredModules: <String>{FamilyModule.calendar.id, FamilyModule.tasks.id},
    );

    final FamilyMember kid = FamilyMember(
      id: _uuid.v4(),
      displayName: 'Taylor',
      role: FamilyRole.child,
      isChild: true,
      bio: 'Junior football champion.',
      interests: const <String>['Football', 'Games'],
      rewards: 45,
      preferredModules: <String>{FamilyModule.tasks.id, FamilyModule.media.id},
    );

    return Family(
      id: _uuid.v4(),
      name: 'The Swifts',
      members: <FamilyMember>[parent, partner, kid],
      friends: const <String>[],
      moduleToggles: <String, bool>{
        for (final FamilyModule module in FamilyModule.values) module.id: true,
      },
      favoriteLocations: const <LocationPoint>[],
    );
  }

  Future<void> addMember(FamilyMember member) async {
    final updatedMembers = List<FamilyMember>.from(members)..add(member);
    _family = family.copyWith(members: updatedMembers);
    await storageService.saveFamily(family);
    notifyListeners();
  }

  Future<void> updateMember(FamilyMember member) async {
    final List<FamilyMember> updatedMembers = members.map((FamilyMember existing) {
      if (existing.id == member.id) {
        return member;
      }
      return existing;
    }).toList();

    _family = family.copyWith(members: updatedMembers);
    await storageService.saveFamily(family);
    notifyListeners();
  }

  Future<void> removeMember(String memberId) async {
    final updatedMembers = members.where((FamilyMember m) => m.id != memberId).toList();
    _family = family.copyWith(members: updatedMembers);
    await storageService.saveFamily(family);
    notifyListeners();
  }

  Future<void> toggleFriendFamily(String familyId) async {
    final List<String> updatedFriends = List<String>.from(family.friends);
    if (updatedFriends.contains(familyId)) {
      updatedFriends.remove(familyId);
    } else {
      updatedFriends.add(familyId);
    }

    _family = family.copyWith(friends: updatedFriends);
    await storageService.saveFamily(family);
    notifyListeners();
  }

  Future<void> upsertLocation(LocationPoint location) async {
    final List<LocationPoint> updated = List<LocationPoint>.from(favoriteLocations);
    final int index = updated.indexWhere((LocationPoint item) => item.id == location.id);
    if (index >= 0) {
      updated[index] = location;
    } else {
      updated.add(location);
    }

    _family = family.copyWith(favoriteLocations: updated);
    await storageService.saveFamily(family);
    notifyListeners();
  }

  Future<void> deleteLocation(String id) async {
    final updated = favoriteLocations.where((LocationPoint item) => item.id != id).toList();
    _family = family.copyWith(favoriteLocations: updated);
    await storageService.saveFamily(family);
    notifyListeners();
  }

  Future<void> updateMemberReward(String memberId, int delta) async {
    final List<FamilyMember> updatedMembers = members.map((FamilyMember member) {
      if (member.id == memberId) {
        final int newRewards = (member.rewards + delta).clamp(0, 1000000);
        return member.copyWith(rewards: newRewards);
      }
      return member;
    }).toList();

    _family = family.copyWith(members: updatedMembers);
    await storageService.saveFamily(family);
    notifyListeners();
  }

  Future<void> setModuleEnabled(FamilyModule module, bool value) async {
    final Map<String, bool> toggles = Map<String, bool>.from(family.moduleToggles)
      ..[module.id] = value;
    _family = family.copyWith(moduleToggles: toggles);
    await storageService.saveFamily(family);
    notifyListeners();
  }
}
