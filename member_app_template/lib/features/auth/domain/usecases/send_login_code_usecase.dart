import '../repositories/auth_repository.dart';

class SendLoginCodeUseCase {
  SendLoginCodeUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String account, String? intlCode}) {
    return _repository.sendLoginCode(account: account, intlCode: intlCode);
  }
}
