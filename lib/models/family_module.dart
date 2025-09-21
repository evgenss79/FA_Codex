enum FamilyModule {
  dashboard,
  calendar,
  schedule,
  tasks,
  chat,
  media,
  social,
  profile,
  services,
}

extension FamilyModuleX on FamilyModule {
  String get id => toString().split('.').last;

  String get localizationKey {
    switch (this) {
      case FamilyModule.dashboard:
        return 'moduleDashboard';
      case FamilyModule.calendar:
        return 'moduleCalendar';
      case FamilyModule.schedule:
        return 'moduleSchedule';
      case FamilyModule.tasks:
        return 'moduleTasks';
      case FamilyModule.chat:
        return 'moduleChat';
      case FamilyModule.media:
        return 'moduleMedia';
      case FamilyModule.social:
        return 'moduleSocial';
      case FamilyModule.profile:
        return 'moduleProfile';
      case FamilyModule.services:
        return 'moduleServices';
    }
  }

  static FamilyModule fromId(String id) {
    return FamilyModule.values.firstWhere(
      (FamilyModule module) => module.id == id,
      orElse: () => FamilyModule.dashboard,
    );
  }
}
