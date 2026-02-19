abstract class KeyValueStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class InMemoryKeyValueStorage implements KeyValueStorage {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<void> clear() async {
    _store.clear();
  }

  @override
  Future<String?> read(String key) async {
    return _store[key];
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }
}

abstract class LargeDataStore {
  Future<void> put<T>(String key, T value);
  Future<T?> get<T>(String key);
  Future<void> delete(String key);
  Future<void> clear();
}
