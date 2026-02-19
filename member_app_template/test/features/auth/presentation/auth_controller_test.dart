import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/features/auth/domain/entities/auth_session.dart';
import 'package:member_app_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:member_app_template/features/auth/domain/usecases/login_with_code_usecase.dart';
import 'package:member_app_template/features/auth/domain/usecases/send_login_code_usecase.dart';
import 'package:member_app_template/features/auth/presentation/controllers/auth_controller.dart';

class _FakeRepository implements AuthRepository {
  bool sendCodeCalled = false;

  @override
  Future<void> sendLoginCode({required String account}) async {
    sendCodeCalled = true;
  }

  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
  }) async {
    return AuthSession(
      accessToken: 'token',
      refreshToken: 'refresh',
      expiresAt: DateTime(2100),
    );
  }

  @override
  Future<void> logout() async {}
}

void main() {
  test('send code updates state', () async {
    final repo = _FakeRepository();
    final controller = AuthController(
      SendLoginCodeUseCase(repo),
      LoginWithCodeUseCase(repo),
    );

    controller.onAccountChanged('13900000000');
    await controller.sendCode();

    expect(repo.sendCodeCalled, true);
    expect(controller.state.errorMessage, isNull);
  });

  test('login returns true and sets session', () async {
    final repo = _FakeRepository();
    final controller = AuthController(
      SendLoginCodeUseCase(repo),
      LoginWithCodeUseCase(repo),
    );

    controller.onAccountChanged('13900000000');
    controller.onCodeChanged('123456');
    final success = await controller.login();

    expect(success, true);
    expect(controller.state.session, isNotNull);
  });
}
