import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_contract.dart';

class SecureKeyValueStorage implements KeyValueStorage {
  SecureKeyValueStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> clear() {
    return _secureStorage.deleteAll();
  }

  @override
  Future<String?> read(String key) {
    return _secureStorage.read(key: key);
  }

  @override
  Future<void> remove(String key) {
    return _secureStorage.delete(key: key);
  }

  @override
  Future<void> write(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }
}
