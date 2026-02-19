import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/login_with_code_usecase.dart';
import '../../domain/usecases/send_login_code_usecase.dart';
import '../state/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._sendCode, this._login) : super(const AuthState());

  final SendLoginCodeUseCase _sendCode;
  final LoginWithCodeUseCase _login;

  void onAccountChanged(String value) {
    state = state.copyWith(account: value, clearError: true);
  }

  void onCodeChanged(String value) {
    state = state.copyWith(code: value, clearError: true);
  }

  Future<void> sendCode() async {
    if (!state.canSendCode) return;
    state = state.copyWith(isSendingCode: true, clearError: true);

    try {
      await _sendCode.call(account: state.account.trim());
      state = state.copyWith(isSendingCode: false);
    } catch (_) {
      state = state.copyWith(
        isSendingCode: false,
        errorMessage: '验证码发送失败，请稍后重试',
      );
    }
  }

  Future<bool> login() async {
    if (!state.canLogin) return false;
    state = state.copyWith(isLoggingIn: true, clearError: true);

    try {
      final session = await _login.call(
        account: state.account.trim(),
        code: state.code.trim(),
      );
      state = state.copyWith(isLoggingIn: false, session: session);
      return true;
    } catch (_) {
      state = state.copyWith(isLoggingIn: false, errorMessage: '登录失败，请检查验证码');
      return false;
    }
  }
}
