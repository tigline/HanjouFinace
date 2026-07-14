import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/settings/presentation/support/invite_friends_support.dart';

void main() {
  group('classifyInviteFriendsLoadError', () {
    test('classifies a wrapped 403 failure as forbidden', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/member/channel/detail'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/member/channel/detail'),
          statusCode: 403,
        ),
        type: DioExceptionType.badResponse,
        error: const NetworkFailure(
          type: NetworkFailureType.forbidden,
          message: 'Forbidden',
          statusCode: 403,
        ),
      );

      expect(
        classifyInviteFriendsLoadError(error),
        InviteFriendsLoadFailureKind.forbidden,
      );
    });

    test('classifies connection failures as network errors', () {
      const error = NetworkFailure(
        type: NetworkFailureType.connectionTimeout,
        message: 'Connection timeout',
      );

      expect(
        classifyInviteFriendsLoadError(error),
        InviteFriendsLoadFailureKind.network,
      );
    });

    test('keeps server failures separate from network errors', () {
      const error = NetworkFailure(
        type: NetworkFailureType.serverError,
        message: 'Server error',
        statusCode: 500,
      );

      expect(
        classifyInviteFriendsLoadError(error),
        InviteFriendsLoadFailureKind.other,
      );
    });
  });

  group('buildInviteRegistrationUri', () {
    test('uses the current environment origin and encoded invite code', () {
      final uri = buildInviteRegistrationUri(
        apiBaseUrl: 'https://testoa.gutingjun.com/api',
        inviteCode: 'STAR 2026',
      );

      expect(
        uri.toString(),
        'https://testoa.gutingjun.com/register?ref=STAR+2026',
      );
    });

    test('falls back to the StellaVia production domain', () {
      final uri = buildInviteRegistrationUri(
        apiBaseUrl: 'not-a-url',
        inviteCode: 'ABC',
      );

      expect(uri.toString(), 'https://stellavia.co.jp/register?ref=ABC');
    });
  });
}
