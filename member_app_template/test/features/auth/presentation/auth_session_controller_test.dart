import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/features/auth/presentation/providers/auth_providers.dart';

class _SeededTokenStore implements TokenStore {
  _SeededTokenStore({String? accessToken, String? refreshToken})
    : _accessToken = accessToken,
      _refreshToken = refreshToken;

  String? _accessToken;
  String? _refreshToken;
  bool clearCalled = false;

  @override
  Future<void> clear() async {
    clearCalled = true;
    _accessToken = null;
    _refreshToken = null;
  }

  @override
  Future<String?> readAccessToken() async => _accessToken;

  @override
  Future<String?> readRefreshToken() async => _refreshToken;

  @override
  Future<void> save(TokenPair pair) async {
    _accessToken = pair.accessToken;
    _refreshToken = pair.refreshToken;
  }
}

class _FakeTokenRefresher implements TokenRefresher {
  _FakeTokenRefresher(this._handler);

  final Future<TokenPair?> Function(String refreshToken) _handler;
  int refreshCalled = 0;

  @override
  Future<TokenPair?> refresh(String refreshToken) async {
    refreshCalled += 1;
    return _handler(refreshToken);
  }
}

void main() {
  group('AuthSessionController', () {
    test('keeps authenticated state when access token exists', () async {
      final tokenStore = _SeededTokenStore(
        accessToken: 'cached-access',
        refreshToken: 'cached-refresh',
      );
      final refresher = _FakeTokenRefresher((_) async => null);

      final controller = AuthSessionController(tokenStore, refresher);
      await controller.refresh();

      expect(controller.state.value, isTrue);
      expect(refresher.refreshCalled, 0);
    });

    test('refreshes with refresh token when access token missing', () async {
      final tokenStore = _SeededTokenStore(refreshToken: 'old-refresh');
      final refresher = _FakeTokenRefresher((refreshToken) async {
        expect(refreshToken, 'old-refresh');
        return const TokenPair(
          accessToken: 'new-access',
          refreshToken: 'new-refresh',
        );
      });

      final controller = AuthSessionController(tokenStore, refresher);
      await controller.refresh();

      expect(controller.state.value, isTrue);
      expect(await tokenStore.readAccessToken(), 'new-access');
      expect(await tokenStore.readRefreshToken(), 'new-refresh');
    });

    test(
      'falls back to unauthenticated and clears token on refresh failure',
      () async {
        final tokenStore = _SeededTokenStore(refreshToken: 'old-refresh');
        final refresher = _FakeTokenRefresher((_) async {
          throw StateError('refresh failed');
        });

        final controller = AuthSessionController(tokenStore, refresher);
        await controller.refresh();

        expect(controller.state.value, isFalse);
        expect(tokenStore.clearCalled, isTrue);
        expect(await tokenStore.readAccessToken(), isNull);
        expect(await tokenStore.readRefreshToken(), isNull);
      },
    );
  });
}
