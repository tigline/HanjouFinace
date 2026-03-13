import 'package:core_storage/core_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/theme/app_theme_mode_providers.dart';

void main() {
  group('AppThemeModeController', () {
    test('restores persisted theme preference from storage', () async {
      final storage = InMemoryKeyValueStorage();
      await storage.write('app_theme_mode', 'dark');

      final controller = AppThemeModeController(storage);
      await controller.ready;

      expect(controller.state, AppThemePreference.dark);
      expect(controller.state.themeMode, ThemeMode.dark);
      controller.dispose();
    });

    test('setPreference persists and clears theme preference', () async {
      final storage = InMemoryKeyValueStorage();
      final controller = AppThemeModeController(storage);
      await controller.ready;

      await controller.setPreference(AppThemePreference.light);
      expect(controller.state, AppThemePreference.light);
      expect(await storage.read('app_theme_mode'), 'light');

      await controller.setPreference(AppThemePreference.dark);
      expect(controller.state, AppThemePreference.dark);
      expect(await storage.read('app_theme_mode'), 'dark');

      await controller.setPreference(AppThemePreference.system);
      expect(controller.state, AppThemePreference.system);
      expect(await storage.read('app_theme_mode'), isNull);
      controller.dispose();
    });
  });
}
