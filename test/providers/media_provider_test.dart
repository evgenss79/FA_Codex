import 'package:flutter_test/flutter_test.dart';

import 'package:family_app/providers/family_provider.dart';
import 'package:family_app/providers/media_provider.dart';
import 'package:family_app/services/ai_assistant_service.dart';
import 'package:family_app/services/geolocation_service.dart';
import 'package:family_app/services/local_storage_service.dart';

Future<void> _wait() async {
  await Future<void>.delayed(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MediaProvider', () {
    late LocalStorageService storageService;
    late FamilyProvider familyProvider;
    late MediaProvider mediaProvider;

    setUp(() async {
      storageService = LocalStorageService();
      await storageService.init();
      await storageService.clear();

      familyProvider = FamilyProvider(storageService: storageService);
      mediaProvider = MediaProvider(
        storageService: storageService,
        geolocationService: GeolocationService(),
        aiAssistantService: AiAssistantService(),
      );
      mediaProvider.attachFamilyProvider(familyProvider);
      await _wait();
    });

    test('provides demo media items', () async {
      await _wait();
      expect(mediaProvider.items, isNotEmpty);
    });

    test('generates AI recommendations', () async {
      await _wait();
      expect(mediaProvider.recommendations, isNotEmpty);
    });
  });
}
