import 'package:hive_flutter/hive_flutter.dart';

import 'storage_contract.dart';

class HiveLargeDataStore implements LargeDataStore {
  HiveLargeDataStore({required String boxName}) : _boxName = boxName;

  final String _boxName;

  Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<dynamic>(_boxName);
    }

    return Hive.openBox<dynamic>(_boxName);
  }

  @override
  Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }

  @override
  Future<void> delete(String key) async {
    final box = await _openBox();
    await box.delete(key);
  }

  @override
  Future<T?> get<T>(String key) async {
    final box = await _openBox();
    final value = box.get(key);
    if (value == null) {
      return null;
    }

    return value as T;
  }

  @override
  Future<void> put<T>(String key, T value) async {
    final box = await _openBox();
    await box.put(key, value);
  }
}
