import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:member_app_template/app/app.dart';
import 'package:member_app_template/app/config/app_environment.dart';
import 'package:member_app_template/app/config/app_flavor.dart';
import 'package:member_app_template/app/config/environment_provider.dart';
import 'package:member_app_template/features/auth/presentation/providers/auth_providers.dart';

class _SeededTokenStore implements TokenStore {
  _SeededTokenStore({String? accessToken, String? refreshToken})
    : _accessToken = accessToken,
      _refreshToken = refreshToken;

  String? _accessToken;
  String? _refreshToken;

  @override
  Future<void> clear() async {
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
  _FakeTokenRefresher(this._onRefresh);

  final Future<TokenPair?> Function(String refreshToken) _onRefresh;

  @override
  Future<TokenPair?> refresh(String refreshToken) {
    return _onRefresh(refreshToken);
  }
}

Future<void> _pumpTemplateApp(
  WidgetTester tester, {
  required TokenStore tokenStore,
  required TokenRefresher tokenRefresher,
}) async {
  final environment = EnvironmentFactory.fromFlavor(AppFlavor.dev);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        appEnvironmentProvider.overrideWithValue(environment),
        tokenStoreProvider.overrideWithValue(tokenStore),
        tokenRefresherProvider.overrideWithValue(tokenRefresher),
      ],
      child: const MemberTemplateApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth cold start', () {
    testWidgets('routes to login when no persisted token exists', (
      tester,
    ) async {
      await _pumpTemplateApp(
        tester,
        tokenStore: _SeededTokenStore(),
        tokenRefresher: _FakeTokenRefresher((_) async => null),
      );

      expect(find.text('登录'), findsOneWidget);
    });

    testWidgets('restores session from refresh token and routes to home', (
      tester,
    ) async {
      await _pumpTemplateApp(
        tester,
        tokenStore: _SeededTokenStore(refreshToken: 'stale-refresh'),
        tokenRefresher: _FakeTokenRefresher((refreshToken) async {
          expect(refreshToken, 'stale-refresh');
          return const TokenPair(
            accessToken: 'restored-access',
            refreshToken: 'restored-refresh',
          );
        }),
      );

      expect(find.text('Home'), findsWidgets);
    });
  });
}
