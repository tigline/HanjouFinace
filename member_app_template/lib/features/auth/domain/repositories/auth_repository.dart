import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<void> sendLoginCode({required String account});
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
  });
  Future<void> logout();
}
