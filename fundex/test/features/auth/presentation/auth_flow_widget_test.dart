import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fundex/app/app.dart';
import 'package:fundex/app/localization/app_localizations_ext.dart';
import 'package:fundex/app/config/app_environment.dart';
import 'package:fundex/app/config/app_flavor.dart';
import 'package:fundex/app/config/environment_provider.dart';
import 'package:fundex/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fundex/features/auth/data/models/auth_user_dto.dart';
import 'package:fundex/features/auth/domain/entities/auth_session.dart';
import 'package:fundex/features/auth/domain/repositories/auth_repository.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/member_profile/presentation/providers/member_profile_providers.dart';

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

class _InMemoryAuthLocalDataSource implements AuthLocalDataSource {
  AuthUserDto? _user;

  @override
  Future<void> clearCurrentUser() async {
    _user = null;
  }

  @override
  Future<AuthUserDto?> readCurrentUser() async => _user;

  @override
  Future<void> saveCurrentUser(AuthUserDto user) async {
    _user = user;
  }
}

class _FakeAuthRepository implements AuthRepository {
  bool sendCodeCalled = false;
  bool loginCalled = false;
  bool logoutCalled = false;

  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) async {
    loginCalled = true;
    return AuthSession(
      accessToken: 'token-a',
      refreshToken: 'token-r',
      expiresAt: DateTime.utc(2100, 1, 1),
    );
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<bool> refreshSession() async {
    return true;
  }

  @override
  Future<bool> restoreSession() async {
    return true;
  }

  @override
  Future<void> registerAccount({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) async {}

  @override
  Future<void> sendLoginCode({
    required String account,
    String? intlCode,
  }) async {
    sendCodeCalled = true;
  }

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {}
}

Future<void> _pumpApp(
  WidgetTester tester, {
  required TokenStore tokenStore,
  required TokenRefresher tokenRefresher,
  required AuthRepository authRepository,
}) async {
  final environment = EnvironmentFactory.fromFlavor(AppFlavor.dev);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        appEnvironmentProvider.overrideWithValue(environment),
        tokenStoreProvider.overrideWithValue(tokenStore),
        tokenRefresherProvider.overrideWithValue(tokenRefresher),
        authLocalDataSourceProvider.overrideWithValue(
          _InMemoryAuthLocalDataSource(),
        ),
        authRepositoryProvider.overrideWithValue(authRepository),
        isMemberProfileCompletedProvider.overrideWith((ref) async => false),
      ],
      child: const MemberTemplateApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 2600));
  await tester.pumpAndSettle();
}

Future<void> _pumpUntilVisible(
  WidgetTester tester,
  Finder finder, {
  int maxTicks = 30,
}) async {
  for (var i = 0; i < maxTicks; i++) {
    if (finder.evaluate().isNotEmpty) {
      return;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  group('Auth flow widget', () {
    testWidgets('login page submits send code and login then routes to home', (
      tester,
    ) async {
      final repository = _FakeAuthRepository();
      await _pumpApp(
        tester,
        tokenStore: _SeededTokenStore(),
        tokenRefresher: _FakeTokenRefresher((_) async => null),
        authRepository: repository,
      );

      await _pumpUntilVisible(tester, find.byType(TextField));
      expect(find.byKey(const Key('login_page')), findsOneWidget);
      await tester.ensureVisible(
        find.byKey(const Key('login_mode_email_button')),
      );
      await tester.tap(find.byKey(const Key('login_mode_email_button')));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(2));
      await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
      await tester.enterText(find.byType(TextField).at(1), '123456');

      await tester.ensureVisible(
        find.byKey(const Key('login_send_code_button')),
      );
      await tester.tap(find.byKey(const Key('login_send_code_button')));
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('login_submit_button')));
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(repository.sendCodeCalled, isTrue);
      expect(repository.loginCalled, isTrue);
      await _pumpUntilVisible(tester, find.byKey(const Key('main_tab_bar')));
      expect(find.byKey(const Key('main_tab_bar')), findsOneWidget);
    });

    testWidgets('home logout triggers repository logout and routes to login', (
      tester,
    ) async {
      final repository = _FakeAuthRepository();
      await _pumpApp(
        tester,
        tokenStore: _SeededTokenStore(
          accessToken: 'token-a',
          refreshToken: 'token-r',
        ),
        tokenRefresher: _FakeTokenRefresher((_) async => null),
        authRepository: repository,
      );

      final homeContext = tester.element(find.byKey(const Key('home_page')));
      final l10n = homeContext.l10n;
      await tester.tap(find.text(l10n.mainTabProfile));
      await tester.pumpAndSettle();

      await _pumpUntilVisible(tester, find.byKey(const Key('logout_button')));
      expect(find.byKey(const Key('logout_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('logout_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(repository.logoutCalled, isTrue);
      await _pumpUntilVisible(tester, find.byKey(const Key('login_page')));
      expect(find.byKey(const Key('login_page')), findsOneWidget);
    });
  });
}
