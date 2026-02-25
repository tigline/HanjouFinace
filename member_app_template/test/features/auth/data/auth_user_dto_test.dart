import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/features/auth/data/models/auth_user_dto.dart';

void main() {
  group('AuthUserDto.fromJson', () {
    test('returns safe defaults when optional fields are missing', () {
      final dto = AuthUserDto.fromJson(<String, dynamic>{});

      expect(dto.username, '');
      expect(dto.userId, isNull);
      expect(dto.email, isNull);
      expect(dto.mobile, isNull);
      expect(dto.memberLevel, isNull);
      expect(dto.intlTelCode, isNull);
    });

    test('supports legacy usename field and numeric strings', () {
      final dto = AuthUserDto.fromJson(<String, dynamic>{
        'usename': ' user@example.com ',
        'userId': '126575',
        'memberLevel': '10',
        'intlTelCode': ' 81 ',
      });

      expect(dto.username, ' user@example.com ');
      expect(dto.userId, 126575);
      expect(dto.memberLevel, 10);
      expect(dto.intlTelCode, '81');
    });

    test('falls back to mobile when username fields are absent', () {
      final dto = AuthUserDto.fromJson(<String, dynamic>{
        'mobile': '13900000000',
      });

      expect(dto.username, '13900000000');
      expect(dto.mobile, '13900000000');
    });
  });

  group('AuthUserDto.tryFromLoginPayload', () {
    test('returns null when payload has no meaningful user data', () {
      final dto = AuthUserDto.tryFromLoginPayload(<String, dynamic>{
        'username': '   ',
        'mobile': '',
      });

      expect(dto, isNull);
    });

    test('builds user from legacy login payload safely', () {
      final dto = AuthUserDto.tryFromLoginPayload(<String, dynamic>{
        'usename': 'Aaron.hou@51fanxing.co.jp',
        'userId': 126575,
        'memberLevel': 10,
        'intlTelCode': '',
      });

      expect(dto, isNotNull);
      expect(dto?.username, 'Aaron.hou@51fanxing.co.jp');
      expect(dto?.email, 'Aaron.hou@51fanxing.co.jp');
      expect(dto?.userId, 126575);
      expect(dto?.memberLevel, 10);
      expect(dto?.intlTelCode, isNull);
    });

    test('ignores malformed numeric fields instead of throwing', () {
      final dto = AuthUserDto.tryFromLoginPayload(<String, dynamic>{
        'usename': 'user@example.com',
        'userId': <String, dynamic>{'bad': 1},
        'memberLevel': <String, dynamic>{'bad': 2},
      });

      expect(dto, isNotNull);
      expect(dto?.username, 'user@example.com');
      expect(dto?.userId, isNull);
      expect(dto?.memberLevel, isNull);
    });
  });
}
