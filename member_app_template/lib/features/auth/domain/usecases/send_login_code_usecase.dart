import '../repositories/auth_repository.dart';

class SendLoginCodeUseCase {
  SendLoginCodeUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String account}) {
    return _repository.sendLoginCode(account: account);
  }
}
