import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/data/models/auth_user_dto.dart';

void main() {
  group('AuthUserDto.fromJson', () {
    test('returns safe defaults when optional fields are missing', () {
      final dto = AuthUserDto.fromJson(<String, dynamic>{});

      expect(dto.username, '');
      expect(dto.userId, isNull);
      expect(dto.email, isNull);
      expect(dto.mobile, isNull);
      expect(dto.phone, isNull);
      expect(dto.memberLevel, isNull);
      expect(dto.intlTelCode, isNull);
      expect(dto.memberId, isNull);
      expect(dto.address, isNull);
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
      expect(dto.phone, '13900000000');
    });

    test('parses crowdfunding user index payload safely', () {
      final dto = AuthUserDto.fromJson(<String, dynamic>{
        'id': '438786029784006656',
        'memberId': 125530,
        'accountId': '0125530',
        'email': 'dennis.diao@51fanxing.co.jp',
        'firstName': '张',
        'lastName': '冠李戴',
        'taxRadio': 0.2042,
        'intlTelCode': 81,
        'phone': '09085309521',
        'zipCode': '5370011',
        'address': '東今里１－７－２４',
        'status': 4,
        'frontUrl': 'https://example.com/front.jpg',
        'backUrl': 'https://example.com/back.jpg',
      });

      expect(dto.id, '438786029784006656');
      expect(dto.memberId, 125530);
      expect(dto.userId, 125530);
      expect(dto.accountId, '0125530');
      expect(dto.email, 'dennis.diao@51fanxing.co.jp');
      expect(dto.phone, '09085309521');
      expect(dto.mobile, '09085309521');
      expect(dto.intlTelCode, '81');
      expect(dto.firstName, '张');
      expect(dto.lastName, '冠李戴');
      expect(dto.taxRadio, 0.2042);
      expect(dto.address, '東今里１－７－２４');
      expect(dto.status, 4);
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

  group('AuthUserDto.tryFromCurrentUserPayload', () {
    test('returns null when payload has no meaningful user profile fields', () {
      final dto = AuthUserDto.tryFromCurrentUserPayload(<String, dynamic>{});

      expect(dto, isNull);
    });

    test('builds user from current user profile payload', () {
      final dto = AuthUserDto.tryFromCurrentUserPayload(<String, dynamic>{
        'id': '438786029784006656',
        'memberId': '125530',
        'email': 'dennis.diao@51fanxing.co.jp',
        'phone': '09085309521',
        'intlTelCode': 81,
      });

      expect(dto, isNotNull);
      expect(dto?.id, '438786029784006656');
      expect(dto?.memberId, 125530);
      expect(dto?.userId, 125530);
      expect(dto?.email, 'dennis.diao@51fanxing.co.jp');
      expect(dto?.phone, '09085309521');
      expect(dto?.mobile, '09085309521');
      expect(dto?.intlTelCode, '81');
      expect(dto?.username, 'dennis.diao@51fanxing.co.jp');
    });
  });
}
