import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  static const Map<String, Map<String, String>> _localizedValues = <String, Map<String, String>>{
    'en': <String, String>{
      'appTitle': 'FamilyApp',
      'moduleDashboard': 'Home',
      'moduleCalendar': 'Calendar',
      'moduleSchedule': 'Schedule',
      'moduleTasks': 'Tasks',
      'moduleChat': 'Chat',
      'moduleMedia': 'Gallery',
      'moduleSocial': 'Social',
      'moduleProfile': 'Profile',
      'moduleServices': 'Services',
      'welcomeTitle': 'Welcome back',
      'tasksDueToday': 'Tasks due today',
      'eventsThisWeek': 'Events this week',
      'familyMembers': 'Family members',
      'emptyState': 'Nothing here yet',
      'addNew': 'Add new',
      'totalPoints': 'Total points',
      'roleParent': 'Parent',
      'roleChild': 'Child',
      'roleRelative': 'Relative',
      'roleGuardian': 'Guardian',
      'roleGuest': 'Guest',
      'friendsFamilies': 'Friend families',
      'mediaHighlights': 'Highlights',
      'recommendedActions': 'Recommended actions',
      'completedTasks': 'Completed tasks',
      'noConversations': 'No conversations yet',
      'geoPlaces': 'Places & services',
    },
    'ru': <String, String>{
      'appTitle': 'FamilyApp',
      'moduleDashboard': 'Главная',
      'moduleCalendar': 'Календарь',
      'moduleSchedule': 'Расписание',
      'moduleTasks': 'Задачи',
      'moduleChat': 'Чат',
      'moduleMedia': 'Галерея',
      'moduleSocial': 'Соцсеть',
      'moduleProfile': 'Профиль',
      'moduleServices': 'Сервисы',
      'welcomeTitle': 'С возвращением',
      'tasksDueToday': 'Задачи на сегодня',
      'eventsThisWeek': 'События недели',
      'familyMembers': 'Члены семьи',
      'emptyState': 'Здесь пока пусто',
      'addNew': 'Добавить',
      'totalPoints': 'Всего баллов',
      'roleParent': 'Родитель',
      'roleChild': 'Ребенок',
      'roleRelative': 'Родственник',
      'roleGuardian': 'Опекун',
      'roleGuest': 'Гость',
      'friendsFamilies': 'Дружеские семьи',
      'mediaHighlights': 'Лучшие моменты',
      'recommendedActions': 'Рекомендации',
      'completedTasks': 'Завершенные задачи',
      'noConversations': 'Нет переписок',
      'geoPlaces': 'Места и сервисы',
    },
  };

  String translate(String key) {
    final Map<String, String>? values = _localizedValues[locale.languageCode];
    return values?[key] ?? _localizedValues['en']![key] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((Locale item) => item.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
