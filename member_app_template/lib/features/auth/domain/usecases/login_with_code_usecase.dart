import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginWithCodeUseCase {
  LoginWithCodeUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call({required String account, required String code}) {
    return _repository.loginWithCode(account: account, code: code);
  }
}
