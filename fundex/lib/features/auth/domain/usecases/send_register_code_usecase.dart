import '../repositories/auth_repository.dart';

class SendRegisterCodeUseCase {
  SendRegisterCodeUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String account, required String intlCode}) {
    return _repository.sendRegisterCode(account: account, intlCode: intlCode);
  }
}
