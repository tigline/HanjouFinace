import '../repositories/auth_repository.dart';

class RegisterAccountUseCase {
  RegisterAccountUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) {
    return _repository.registerAccount(
      account: account,
      code: code,
      intlCode: intlCode,
      contact: contact,
    );
  }
}
