import 'package:shared_preferences/shared_preferences.dart';

import 'storage_contract.dart';

class SharedPrefsKeyValueStorage implements KeyValueStorage {
  SharedPrefsKeyValueStorage({this.namespace = 'app'});

  final String namespace;

  String _prefKey(String key) => '${namespace}_$key';

  Future<SharedPreferences> _prefs() {
    return SharedPreferences.getInstance();
  }

  @override
  Future<void> clear() async {
    final prefs = await _prefs();
    final keys = prefs.getKeys().where((String key) {
      return key.startsWith('${namespace}_');
    });

    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  @override
  Future<String?> read(String key) async {
    final prefs = await _prefs();
    return prefs.getString(_prefKey(key));
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await _prefs();
    await prefs.remove(_prefKey(key));
  }

  @override
  Future<void> write(String key, String value) async {
    final prefs = await _prefs();
    await prefs.setString(_prefKey(key), value);
  }
}
