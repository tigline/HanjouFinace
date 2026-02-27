import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fundex/features/auth/data/models/auth_user_dto.dart';

class _InMemoryLargeDataStore implements LargeDataStore {
  final Map<String, dynamic> _values = <String, dynamic>{};

  @override
  Future<void> clear() async {
    _values.clear();
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<T?> get<T>(String key) async {
    final value = _values[key];
    if (value == null) {
      return null;
    }
    return value as T;
  }

  @override
  Future<void> put<T>(String key, T value) async {
    _values[key] = value;
  }
}

void main() {
  group('AuthLocalDataSourceImpl', () {
    test('saves and restores current user from large data store', () async {
      final store = _InMemoryLargeDataStore();
      final source = AuthLocalDataSourceImpl(store);

      await source.saveCurrentUser(
        const AuthUserDto(
          username: 'Aaron.hou@51fanxing.co.jp',
          userId: 126575,
          email: 'Aaron.hou@51fanxing.co.jp',
          memberLevel: 10,
          intlTelCode: '81',
        ),
      );

      final restored = await source.readCurrentUser();
      expect(restored, isNotNull);
      expect(restored?.username, 'Aaron.hou@51fanxing.co.jp');
      expect(restored?.userId, 126575);
      expect(restored?.memberLevel, 10);
    });

    test('clearCurrentUser removes cached profile', () async {
      final store = _InMemoryLargeDataStore();
      final source = AuthLocalDataSourceImpl(store);
      await source.saveCurrentUser(const AuthUserDto(username: 'cached'));

      await source.clearCurrentUser();

      expect(await source.readCurrentUser(), isNull);
    });
  });
}
