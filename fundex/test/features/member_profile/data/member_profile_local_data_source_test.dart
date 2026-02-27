import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/data/datasources/member_profile_local_data_source.dart';
import 'package:fundex/features/member_profile/data/models/member_profile_details_dto.dart';

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
  group('MemberProfileLocalDataSourceImpl', () {
    test('saves and restores profile details from local store', () async {
      final store = _InMemoryLargeDataStore();
      final source = MemberProfileLocalDataSourceImpl(store);

      await source.saveProfile(
        MemberProfileDetailsDto(
          familyName: 'Hou',
          givenName: 'Aaron',
          address: 'Tokyo Chiyoda 1-1',
          phoneIntlCode: '81',
          phone: '09012345678',
          email: 'aaron@example.com',
          idDocumentPhotoPath: '/tmp/id.jpg',
          lastUpdatedAt: DateTime.utc(2026, 2, 25),
        ),
      );

      final restored = await source.readProfile();
      expect(restored, isNotNull);
      expect(restored?.familyName, 'Hou');
      expect(restored?.givenName, 'Aaron');
      expect(restored?.phoneIntlCode, '81');
      expect(restored?.phone, '09012345678');
      expect(restored?.email, 'aaron@example.com');
      expect(restored?.idDocumentPhotoPath, '/tmp/id.jpg');
    });

    test('clearProfile removes cached details', () async {
      final store = _InMemoryLargeDataStore();
      final source = MemberProfileLocalDataSourceImpl(store);
      await source.saveProfile(
        const MemberProfileDetailsDto(familyName: 'Hou'),
      );

      await source.clearProfile();

      expect(await source.readProfile(), isNull);
    });
  });
}
