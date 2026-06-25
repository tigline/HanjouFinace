import '../entities/x_account_models.dart';
import '../repositories/x_account_repository.dart';

class LoadXAccountConnectionUseCase {
  const LoadXAccountConnectionUseCase(this._repository);

  final XAccountRepository _repository;

  Future<XAccountConnection> call() => _repository.fetchConnection();
}

class StartXOAuthUseCase {
  const StartXOAuthUseCase(this._repository);

  final XAccountRepository _repository;

  Future<XOAuthAuthorization> call() => _repository.startOAuth();
}

class DisconnectXAccountUseCase {
  const DisconnectXAccountUseCase(this._repository);

  final XAccountRepository _repository;

  Future<void> call() => _repository.disconnectAccount();
}
