import 'package:flutter_test/flutter_test.dart';

import 'package:family_app/providers/event_provider.dart';
import 'package:family_app/providers/family_provider.dart';
import 'package:family_app/services/local_storage_service.dart';

Future<void> _wait() async {
  await Future<void>.delayed(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EventProvider', () {
    late LocalStorageService storageService;
    late FamilyProvider familyProvider;
    late EventProvider eventProvider;

    setUp(() async {
      storageService = LocalStorageService();
      await storageService.init();
      await storageService.clear();

      familyProvider = FamilyProvider(storageService: storageService);
      eventProvider = EventProvider(storageService: storageService);
      eventProvider.attachFamilyProvider(familyProvider);
      await _wait();
    });

    test('seeds sample events on empty store', () async {
      await _wait();
      expect(eventProvider.events, isNotEmpty);
    });

    test('filters events by date', () async {
      await _wait();
      final DateTime today = DateTime.now();
      final events = eventProvider.eventsForDay(today);
      for (final event in events) {
        expect(event.start.day, equals(today.day));
      }
    });
  });
}
