import '../entities/x_account_models.dart';

abstract class XAccountRepository {
  Future<XAccountConnection> fetchConnection();

  Future<XOAuthAuthorization> startOAuth();
}
