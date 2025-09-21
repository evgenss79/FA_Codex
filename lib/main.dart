import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'providers/chat_provider.dart';
import 'providers/event_provider.dart';
import 'providers/family_provider.dart';
import 'providers/media_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/task_provider.dart';
import 'providers/schedule_provider.dart';
import 'screens/home/home_screen.dart';
import 'services/ai_assistant_service.dart';
import 'services/communication_service.dart';
import 'services/geolocation_service.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'theme/family_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = LocalStorageService();
  await storageService.init();

  final notificationService = NotificationService();
  await notificationService.initialize();

  final geolocationService = GeolocationService();
  final aiAssistantService = AiAssistantService();
  final communicationService = CommunicationService();

  runApp(
    FamilyApp(
      storageService: storageService,
      notificationService: notificationService,
      geolocationService: geolocationService,
      aiAssistantService: aiAssistantService,
      communicationService: communicationService,
    ),
  );
}

class FamilyApp extends StatelessWidget {
  const FamilyApp({
    super.key,
    required this.storageService,
    required this.notificationService,
    required this.geolocationService,
    required this.aiAssistantService,
    required this.communicationService,
  });

  final LocalStorageService storageService;
  final NotificationService notificationService;
  final GeolocationService geolocationService;
  final AiAssistantService aiAssistantService;
  final CommunicationService communicationService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storageService: storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => FamilyProvider(storageService: storageService),
        ),
        ChangeNotifierProxyProvider2<FamilyProvider, SettingsProvider, TaskProvider>(
          create: (_) => TaskProvider(storageService: storageService),
          update: (_, familyProvider, settingsProvider, taskProvider) =>
              taskProvider!..attachDependencies(familyProvider, settingsProvider),
        ),
        ChangeNotifierProxyProvider<FamilyProvider, EventProvider>(
          create: (_) => EventProvider(storageService: storageService),
          update: (_, familyProvider, eventProvider) =>
              eventProvider!..attachFamilyProvider(familyProvider),
        ),
        ChangeNotifierProxyProvider<FamilyProvider, ScheduleProvider>(
          create: (_) => ScheduleProvider(storageService: storageService),
          update: (_, familyProvider, scheduleProvider) =>
              scheduleProvider!..attachFamilyProvider(familyProvider),
        ),
        ChangeNotifierProxyProvider<FamilyProvider, ChatProvider>(
          create: (_) => ChatProvider(
            storageService: storageService,
            communicationService: communicationService,
          ),
          update: (_, familyProvider, chatProvider) =>
              chatProvider!..attachFamilyProvider(familyProvider),
        ),
        ChangeNotifierProxyProvider<FamilyProvider, MediaProvider>(
          create: (_) => MediaProvider(
            storageService: storageService,
            geolocationService: geolocationService,
            aiAssistantService: aiAssistantService,
          ),
          update: (_, familyProvider, mediaProvider) =>
              mediaProvider!..attachFamilyProvider(familyProvider),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: 'FamilyApp',
            debugShowCheckedModeBanner: false,
            theme: FamilyTheme.light,
            darkTheme: FamilyTheme.dark,
            themeMode: settingsProvider.themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
