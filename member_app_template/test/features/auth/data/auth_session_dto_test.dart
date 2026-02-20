import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/features/auth/data/models/auth_session_dto.dart';

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
  });
}
