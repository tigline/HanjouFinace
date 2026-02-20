import 'package:core_network/core_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/app/app.dart';
import 'package:member_app_template/app/config/app_environment.dart';
import 'package:member_app_template/app/config/app_flavor.dart';
import 'package:member_app_template/app/config/environment_provider.dart';
import 'package:member_app_template/features/auth/domain/entities/auth_session.dart';
import 'package:member_app_template/features/auth/domain/repositories/auth_repository.dart';
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

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
  }) async {
    return AuthSession(
      accessToken: 'token-a',
      refreshToken: 'token-r',
      expiresAt: DateTime.utc(2100, 1, 1),
    );
  }

  @override
  Future<void> logout() async {}

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
  Future<void> sendLoginCode({required String account}) async {}

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {}
}

Future<void> _pumpApp(WidgetTester tester) async {
  final environment = EnvironmentFactory.fromFlavor(AppFlavor.dev);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        appEnvironmentProvider.overrideWithValue(environment),
        tokenStoreProvider.overrideWithValue(_SeededTokenStore()),
        tokenRefresherProvider.overrideWithValue(
          _FakeTokenRefresher((_) async => null),
        ),
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
      ],
      child: const MemberTemplateApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 220));
}

void main() {
  group('Auth entry navigation', () {
    testWidgets('navigates from login to register and back', (tester) async {
      await _pumpApp(tester);
      expect(find.byKey(const Key('login_page')), findsOneWidget);

      await tester.tap(find.byKey(const Key('to_register_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('register_page')), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('register_back_login_button')),
      );
      await tester.tap(find.byKey(const Key('register_back_login_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('login_page')), findsOneWidget);
    });

    testWidgets('navigates from login to forgot password and back', (
      tester,
    ) async {
      await _pumpApp(tester);
      expect(find.byKey(const Key('login_page')), findsOneWidget);

      await tester.tap(find.byKey(const Key('to_forgot_password_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('forgot_password_page')), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('forgot_back_login_button')),
      );
      await tester.tap(find.byKey(const Key('forgot_back_login_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('login_page')), findsOneWidget);
    });
  });
}
