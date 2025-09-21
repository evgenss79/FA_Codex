enum FamilyRole {
  parent,
  child,
  relative,
  guardian,
  guest,
}

extension FamilyRoleX on FamilyRole {
  String get nameKey {
    switch (this) {
      case FamilyRole.parent:
        return 'roleParent';
      case FamilyRole.child:
        return 'roleChild';
      case FamilyRole.relative:
        return 'roleRelative';
      case FamilyRole.guardian:
        return 'roleGuardian';
      case FamilyRole.guest:
        return 'roleGuest';
    }
  }

  String get id {
    return toString().split('.').last;
  }

  static FamilyRole fromId(String value) {
    return FamilyRole.values.firstWhere(
      (role) => role.id == value,
      orElse: () => FamilyRole.guest,
    );
  }
}
