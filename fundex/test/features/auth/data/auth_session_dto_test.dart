import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/data/models/auth_session_dto.dart';

void main() {
  group('AuthSessionDto.fromJson', () {
    test('parses snake_case oauth token payload', () {
      final before = DateTime.now().toUtc();

      final dto = AuthSessionDto.fromJson(<String, dynamic>{
        'access_token': 'token-a',
        'refresh_token': 'token-r',
        'expires_in': 3600,
      });

      expect(dto.accessToken, 'token-a');
      expect(dto.refreshToken, 'token-r');
      expect(dto.expiresAt.isAfter(before), isTrue);
    });

    test('parses camelCase payload for compatibility', () {
      final dto = AuthSessionDto.fromJson(<String, dynamic>{
        'accessToken': 'token-a',
        'refreshToken': 'token-r',
        'expiresAt': '2100-01-01T00:00:00.000Z',
      });

      expect(dto.accessToken, 'token-a');
      expect(dto.refreshToken, 'token-r');
      expect(dto.expiresAt, DateTime.parse('2100-01-01T00:00:00.000Z'));
    });

    test('throws when token fields are missing', () {
      expect(
        () => AuthSessionDto.fromJson(<String, dynamic>{}),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws when token fields are empty strings', () {
      expect(
        () => AuthSessionDto.fromJson(<String, dynamic>{
          'access_token': '   ',
          'refresh_token': '',
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('falls back to expires_in when expiresAt is invalid', () {
      final before = DateTime.now().toUtc();

      final dto = AuthSessionDto.fromJson(<String, dynamic>{
        'access_token': 'token-a',
        'refresh_token': 'token-r',
        'expiresAt': 'not-a-date',
        'expires_in': '1800',
      });

      final lowerBound = before.add(const Duration(minutes: 29));
      final upperBound = before.add(const Duration(minutes: 31));
      expect(dto.expiresAt.isAfter(lowerBound), isTrue);
      expect(dto.expiresAt.isBefore(upperBound), isTrue);
    });

    test('treats invalid token value types as invalid payload', () {
      expect(
        () => AuthSessionDto.fromJson(<String, dynamic>{
          'access_token': <String, dynamic>{'bad': 'value'},
          'refresh_token': 'token-r',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
