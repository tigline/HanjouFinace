import 'package:core_storage/core_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_storage_providers.dart';

const _themeModeStorageKey = 'app_theme_mode';

enum AppThemePreference {
  system(ThemeMode.system, null),
  light(ThemeMode.light, 'light'),
  dark(ThemeMode.dark, 'dark');

  const AppThemePreference(this.themeMode, this.storageCode);

  final ThemeMode themeMode;
  final String? storageCode;

  static AppThemePreference fromStorageCode(String? code) {
    if (code == null || code.isEmpty) {
      return AppThemePreference.system;
    }

    for (final candidate in values) {
      if (candidate.storageCode == code) {
        return candidate;
      }
    }
    return AppThemePreference.system;
  }
}

class AppThemeModeController extends StateNotifier<AppThemePreference> {
  AppThemeModeController(this._storage) : super(AppThemePreference.system) {
    _restoreFuture = _restore();
  }

  final KeyValueStorage _storage;
  late final Future<void> _restoreFuture;

  Future<void> get ready => _restoreFuture;

  Future<void> _restore() async {
    final persistedValue = await _storage.read(_themeModeStorageKey);
    if (!mounted) {
      return;
    }

    state = AppThemePreference.fromStorageCode(persistedValue);
  }

  Future<void> setPreference(AppThemePreference preference) async {
    await _restoreFuture;
    if (!mounted) {
      return;
    }

    state = preference;
    final storageCode = preference.storageCode;
    if (storageCode == null) {
      await _storage.remove(_themeModeStorageKey);
      return;
    }
    await _storage.write(_themeModeStorageKey, storageCode);
  }
}

final appThemePreferenceProvider =
    StateNotifierProvider<AppThemeModeController, AppThemePreference>((ref) {
      return AppThemeModeController(ref.watch(sharedPrefsStorageProvider));
    });

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(appThemePreferenceProvider).themeMode;
});
