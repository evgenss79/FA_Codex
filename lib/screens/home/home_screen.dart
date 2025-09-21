import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/family_module.dart';
import '../../providers/settings_provider.dart';
import '../calendar/calendar_screen.dart';
import '../chat/chat_screen.dart';
import '../media/media_gallery_screen.dart';
import '../profile/profile_screen.dart';
import '../schedule/schedule_screen.dart';
import '../social/social_screen.dart';
import '../tasks/tasks_screen.dart';
import 'overview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localization = AppLocalizations.of(context);
    final SettingsProvider settingsProvider = context.watch<SettingsProvider>();

    if (settingsProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<_HomeTab> availableTabs = _tabs
        .where((_HomeTab tab) => settingsProvider.isModuleEnabled(tab.module))
        .toList();

    if (availableTabs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(localization.translate('appTitle'))),
        body: Center(child: Text(localization.translate('emptyState'))),
      );
    }

    final int safeIndex = _currentIndex.clamp(0, availableTabs.length - 1);

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: <Widget>[
          for (final _HomeTab tab in availableTabs) tab.builder(context),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: <NavigationDestination>[
          for (final _HomeTab tab in availableTabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              label: tab.labelBuilder(localization),
            ),
        ],
      ),
    );
  }
}

class _HomeTab {
  const _HomeTab({
    required this.module,
    required this.icon,
    required this.labelBuilder,
    required this.builder,
  });

  final FamilyModule module;
  final IconData icon;
  final String Function(AppLocalizations) labelBuilder;
  final WidgetBuilder builder;
}

final List<_HomeTab> _tabs = <_HomeTab>[
  _HomeTab(
    module: FamilyModule.dashboard,
    icon: Icons.dashboard_outlined,
    labelBuilder: (AppLocalizations l10n) => l10n.translate(FamilyModule.dashboard.localizationKey),
    builder: (_) => const OverviewScreen(),
  ),
  _HomeTab(
    module: FamilyModule.calendar,
    icon: Icons.calendar_month_outlined,
    labelBuilder: (AppLocalizations l10n) => l10n.translate(FamilyModule.calendar.localizationKey),
    builder: (_) => const CalendarScreen(),
  ),
  _HomeTab(
    module: FamilyModule.schedule,
    icon: Icons.schedule_outlined,
    labelBuilder: (AppLocalizations l10n) => l10n.translate(FamilyModule.schedule.localizationKey),
    builder: (_) => const ScheduleScreen(),
  ),
  _HomeTab(
    module: FamilyModule.tasks,
    icon: Icons.check_circle_outline,
    labelBuilder: (AppLocalizations l10n) => l10n.translate(FamilyModule.tasks.localizationKey),
    builder: (_) => const TasksScreen(),
  ),
  _HomeTab(
    module: FamilyModule.chat,
    icon: Icons.chat_bubble_outline,
    labelBuilder: (AppLocalizations l10n) => l10n.translate(FamilyModule.chat.localizationKey),
    builder: (_) => const ChatScreen(),
  ),
  _HomeTab(
    module: FamilyModule.media,
    icon: Icons.photo_library_outlined,
    labelBuilder: (AppLocalizations l10n) => l10n.translate(FamilyModule.media.localizationKey),
    builder: (_) => const MediaGalleryScreen(),
  ),
  _HomeTab(
    module: FamilyModule.social,
    icon: Icons.group_outlined,
    labelBuilder: (AppLocalizations l10n) => l10n.translate(FamilyModule.social.localizationKey),
    builder: (_) => const SocialScreen(),
  ),
  _HomeTab(
    module: FamilyModule.profile,
    icon: Icons.person_outline,
    labelBuilder: (AppLocalizations l10n) => l10n.translate(FamilyModule.profile.localizationKey),
    builder: (_) => const ProfileScreen(),
  ),
];
