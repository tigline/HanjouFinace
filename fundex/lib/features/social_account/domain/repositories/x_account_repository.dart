import '../entities/x_account_models.dart';

abstract class XAccountRepository {
  Future<XAccountConnection> fetchConnection();

  Future<XBindingAttempt> startBinding({required Uri callbackUri});

  Future<XBindingStatus> fetchBindingStatus({required String attemptId});

  Future<void> disconnect();
}
