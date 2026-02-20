import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/app/localization/app_locale_providers.dart';

void main() {
  group('AppLocaleController', () {
    test('restores persisted locale from storage', () async {
      final storage = InMemoryKeyValueStorage();
      await storage.write('app_locale', 'en');

      final controller = AppLocaleController(storage);
      await controller.ready;

      expect(controller.state, AppLanguage.en);
      controller.dispose();
    });

    test('setLanguage persists and clears locale setting', () async {
      final storage = InMemoryKeyValueStorage();
      final controller = AppLocaleController(storage);
      await controller.ready;

      await controller.setLanguage(AppLanguage.zh);
      expect(controller.state, AppLanguage.zh);
      expect(await storage.read('app_locale'), 'zh');

      await controller.setLanguage(AppLanguage.system);
      expect(controller.state, AppLanguage.system);
      expect(await storage.read('app_locale'), isNull);
      controller.dispose();
    });
  });
}
