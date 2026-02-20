import 'package:core_storage/core_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_storage_providers.dart';

const _localeStorageKey = 'app_locale';

enum AppLanguage {
  system(null),
  zh('zh'),
  en('en'),
  ja('ja');

  const AppLanguage(this.languageCode);

  final String? languageCode;

  Locale? toLocale() {
    final code = languageCode;
    if (code == null) {
      return null;
    }
    return Locale(code);
  }

  static AppLanguage fromLanguageCode(String? code) {
    for (final candidate in values) {
      if (candidate.languageCode == code) {
        return candidate;
      }
    }
    return AppLanguage.system;
  }
}

class AppLocaleController extends StateNotifier<AppLanguage> {
  AppLocaleController(this._storage) : super(AppLanguage.system) {
    _restoreFuture = _restore();
  }

  final KeyValueStorage _storage;
  late final Future<void> _restoreFuture;

  Future<void> get ready => _restoreFuture;

  Future<void> _restore() async {
    final languageCode = await _storage.read(_localeStorageKey);
    if (!mounted) {
      return;
    }
    state = AppLanguage.fromLanguageCode(languageCode);
  }

  Future<void> setLanguage(AppLanguage language) async {
    await _restoreFuture;
    if (!mounted) {
      return;
    }
    state = language;
    final languageCode = language.languageCode;
    if (languageCode == null) {
      await _storage.remove(_localeStorageKey);
      return;
    }
    await _storage.write(_localeStorageKey, languageCode);
  }
}

final appLanguageProvider =
    StateNotifierProvider<AppLocaleController, AppLanguage>((ref) {
      return AppLocaleController(ref.watch(sharedPrefsStorageProvider));
    });

final appLocaleProvider = Provider<Locale?>((ref) {
  return ref.watch(appLanguageProvider).toLocale();
});
