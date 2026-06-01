import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_storage_providers.dart';

const _textScaleStorageKey = 'app_text_scale';

enum AppTextScalePreference {
  normal('normal', 1.0),
  large('large', 1.2);

  const AppTextScalePreference(this.storageCode, this.scale);

  final String storageCode;
  final double scale;

  static AppTextScalePreference fromStorageCode(String? code) {
    for (final candidate in values) {
      if (candidate.storageCode == code) {
        return candidate;
      }
    }
    return AppTextScalePreference.normal;
  }
}

class AppTextScaleController extends StateNotifier<AppTextScalePreference> {
  AppTextScaleController(this._storage) : super(AppTextScalePreference.normal) {
    _restoreFuture = _restore();
  }

  final KeyValueStorage _storage;
  late final Future<void> _restoreFuture;

  Future<void> get ready => _restoreFuture;

  Future<void> _restore() async {
    final persistedValue = await _storage.read(_textScaleStorageKey);
    if (!mounted) {
      return;
    }
    state = AppTextScalePreference.fromStorageCode(persistedValue);
  }

  Future<void> setPreference(AppTextScalePreference preference) async {
    await _restoreFuture;
    if (!mounted) {
      return;
    }
    state = preference;
    if (preference == AppTextScalePreference.normal) {
      await _storage.remove(_textScaleStorageKey);
      return;
    }
    await _storage.write(_textScaleStorageKey, preference.storageCode);
  }
}

final appTextScalePreferenceProvider =
    StateNotifierProvider<AppTextScaleController, AppTextScalePreference>((
      ref,
    ) {
      return AppTextScaleController(ref.watch(sharedPrefsStorageProvider));
    });

final appTextScaleFactorProvider = Provider<double>((ref) {
  return ref.watch(appTextScalePreferenceProvider).scale;
});
