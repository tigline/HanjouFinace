import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:member_app_template/features/auth/data/models/auth_session_dto.dart';
import 'package:member_app_template/features/auth/data/repositories/auth_repository_impl.dart';

class _FakeRemoteDataSource implements AuthRemoteDataSource {
  String? lastSendCodeAccount;
  String? lastLoginAccount;
  String? lastLoginCode;
  String? lastRefreshToken;
  String? lastLogoutAccessToken;

  AuthSessionDto loginResult = AuthSessionDto(
    accessToken: 'login-access',
    refreshToken: 'login-refresh',
    expiresAt: DateTime.utc(2100, 1, 1),
  );
  AuthSessionDto? refreshResult;
  Object? refreshError;
  Object? logoutError;

  @override
  Future<AuthSessionDto> loginWithCode({
    required String account,
    required String code,
  }) async {
    lastLoginAccount = account;
    lastLoginCode = code;
    return loginResult;
  }

  @override
  Future<AuthSessionDto?> refreshSession({required String refreshToken}) async {
    lastRefreshToken = refreshToken;
    if (refreshError != null) {
      throw refreshError!;
    }
    return refreshResult;
  }

  @override
  Future<void> sendLoginCode({required String account}) async {
    lastSendCodeAccount = account;
  }

  @override
  Future<void> logout({required String accessToken}) async {
    lastLogoutAccessToken = accessToken;
    if (logoutError != null) {
      throw logoutError!;
    }
  }
}

void main() {
  group('AuthRepositoryImpl', () {
    late _FakeRemoteDataSource remote;
    late InMemoryTokenStore tokenStore;
    late AuthRepositoryImpl repository;

    setUp(() {
      remote = _FakeRemoteDataSource();
      tokenStore = InMemoryTokenStore();
      repository = AuthRepositoryImpl(remote: remote, tokenStore: tokenStore);
    });

    test('loginWithCode persists token pair from response', () async {
      final session = await repository.loginWithCode(
        account: 'user@example.com',
        code: '123456',
      );

      expect(session.accessToken, 'login-access');
      expect(await tokenStore.readAccessToken(), 'login-access');
      expect(await tokenStore.readRefreshToken(), 'login-refresh');
      expect(remote.lastLoginAccount, 'user@example.com');
      expect(remote.lastLoginCode, '123456');
    });

    test('restoreSession returns true when access token exists', () async {
      await tokenStore.save(
        const TokenPair(accessToken: 'cached-access', refreshToken: 'cached-r'),
      );

      final restored = await repository.restoreSession();

      expect(restored, isTrue);
      expect(remote.lastRefreshToken, isNull);
    });

    test(
      'restoreSession refreshes when only refresh token is available',
      () async {
        await tokenStore.save(
          const TokenPair(accessToken: '', refreshToken: 'r1'),
        );
        remote.refreshResult = AuthSessionDto(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
          expiresAt: DateTime.utc(2100, 1, 1),
        );

        final restored = await repository.restoreSession();

        expect(restored, isTrue);
        expect(remote.lastRefreshToken, 'r1');
        expect(await tokenStore.readAccessToken(), 'new-access');
        expect(await tokenStore.readRefreshToken(), 'new-refresh');
      },
    );

    test('refreshSession clears local token when refresh fails', () async {
      await tokenStore.save(
        const TokenPair(accessToken: 'old-access', refreshToken: 'old-refresh'),
      );
      remote.refreshError = StateError('refresh failed');

      final refreshed = await repository.refreshSession();

      expect(refreshed, isFalse);
      expect(await tokenStore.readAccessToken(), isNull);
      expect(await tokenStore.readRefreshToken(), isNull);
    });

    test('logout calls remote revoke and clears local token', () async {
      await tokenStore.save(
        const TokenPair(accessToken: 'old-access', refreshToken: 'old-refresh'),
      );

      await repository.logout();

      expect(remote.lastLogoutAccessToken, 'old-access');
      expect(await tokenStore.readAccessToken(), isNull);
      expect(await tokenStore.readRefreshToken(), isNull);
    });

    test('logout still clears local token when remote revoke fails', () async {
      await tokenStore.save(
        const TokenPair(accessToken: 'old-access', refreshToken: 'old-refresh'),
      );
      remote.logoutError = StateError('network');

      await repository.logout();

      expect(remote.lastLogoutAccessToken, 'old-access');
      expect(await tokenStore.readAccessToken(), isNull);
      expect(await tokenStore.readRefreshToken(), isNull);
    });
  });
}
