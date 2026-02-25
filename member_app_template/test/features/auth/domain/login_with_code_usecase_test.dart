import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/features/auth/domain/entities/auth_session.dart';
import 'package:member_app_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:member_app_template/features/auth/domain/usecases/login_with_code_usecase.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._session);

  final AuthSession _session;

  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) async {
    return _session;
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
  Future<void> sendLoginCode({
    required String account,
    String? intlCode,
  }) async {}

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {}
}

void main() {
  test('returns session from repository', () async {
    final session = AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      expiresAt: DateTime(2100),
    );
    final useCase = LoginWithCodeUseCase(_FakeAuthRepository(session));

    final result = await useCase.call(account: 'foo@bar.com', code: '123456');

    expect(result.accessToken, 'a');
    expect(result.refreshToken, 'r');
  });
}
