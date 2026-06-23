import '../entities/x_account_models.dart';
import '../repositories/x_account_repository.dart';

class LoadXAccountConnectionUseCase {
  const LoadXAccountConnectionUseCase(this._repository);

  final XAccountRepository _repository;

  Future<XAccountConnection> call() => _repository.fetchConnection();
}

class StartXAccountBindingUseCase {
  const StartXAccountBindingUseCase(this._repository);

  final XAccountRepository _repository;

  Future<XBindingAttempt> call({required Uri callbackUri}) {
    return _repository.startBinding(callbackUri: callbackUri);
  }
}

class CompleteXAccountBindingUseCase {
  const CompleteXAccountBindingUseCase(this._repository);

  final XAccountRepository _repository;

  Future<XBindingStatus> call({required String attemptId}) {
    return _repository.fetchBindingStatus(attemptId: attemptId);
  }
}

class DisconnectXAccountUseCase {
  const DisconnectXAccountUseCase(this._repository);

  final XAccountRepository _repository;

  Future<void> call() => _repository.disconnect();
}
