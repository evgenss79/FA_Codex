# FamilyApp

FamilyApp is a modular Flutter application that unifies family communication, planning, and memory sharing into a single digital space. The app showcases a Provider-based architecture, Hive-powered persistence, localization, and reusable UI components that cover the most important family scenarios.

## Features

- **Communication**: Family group chat with message history, reactions, and entry points for calls.
- **Planning**: Shared calendar and recurring schedule with per-member filtering.
- **Tasks**: Assignable tasks with reward points and completion tracking.
- **Memories**: Media gallery with AI-powered highlight recommendations.
- **Social**: Friend-family directory and geofenced places for contextual reminders.
- **Profiles**: Rich member cards with interests, social links, and reward scores.

## Architecture

```
lib/
 ├─ models/           # Data models with JSON serialization helpers
 ├─ providers/        # ChangeNotifier classes powered by Provider
 ├─ services/         # Hive storage, notifications, AI, communication, geolocation
 ├─ screens/          # Feature screens grouped by module
 ├─ widgets/          # Reusable UI components (cards, tiles, section headers)
 ├─ l10n/             # Lightweight localization layer
 └─ theme/            # Light and dark themes
```

Key principles:

- **Modularity** – Each major feature (tasks, calendar, chat, media, social, schedule, profiles) lives in its own module and can be toggled via `SettingsProvider`.
- **State management** – `provider` is used to compose `ChangeNotifier` classes with dependency injection through `ChangeNotifierProxyProvider`.
- **Persistence** – `Hive` / `hive_flutter` store all user data locally with an in-memory fallback for test environments.
- **AI & automation** – `AiAssistantService` and `GeolocationService` expose extension points for smart hints and contextual reminders.
- **Null safety** – The entire project is written with Dart null safety and linted with `flutter_lints`.

## Getting started

```bash
flutter pub get
flutter run
```

### Running tests

```bash
flutter test
```

> **Note:** When running on desktop/mobile, ensure Hive has write access to the application directory.

## Localization

English (`en`) and Russian (`ru`) translations are provided through `AppLocalizations` with lightweight string maps. Extend `_localizedValues` to add new languages or keys.

## Sample data

On first launch, the providers seed demo content (family members, tasks, events, media, schedules) so that every module demonstrates its capabilities out of the box.

## Extending the app

- Integrate WebRTC or Jitsi in `CommunicationService` for calls.
- Replace the in-memory Hive fallback with secure cloud sync.
- Connect external APIs for smarter AI recommendations and real location data.
- Expand reward gamification with badges, streaks, and leaderboards.
