import 'package:company_api_runtime/company_api_runtime.dart';

import '../../domain/entities/x_account_models.dart';
import '../../domain/repositories/x_account_repository.dart';
import '../datasources/x_account_remote_data_source.dart';

class XAccountRepositoryImpl implements XAccountRepository {
  const XAccountRepositoryImpl(this._remote);

  final XAccountRemoteDataSource _remote;

  @override
  Future<XAccountConnection> fetchConnection() async {
    return _mapConnection(await _remote.fetchAccount());
  }

  @override
  Future<XOAuthAuthorization> startOAuth() async {
    final dto = await _remote.startOAuth();
    final authorizationUri = Uri.tryParse(dto.authorizationUrl);
    if (authorizationUri == null || !authorizationUri.hasScheme) {
      throw StateError('Invalid X authorization URL.');
    }
    return XOAuthAuthorization(authorizationUri: authorizationUri);
  }

  XAccountConnection _mapConnection(XAccountConnectionDto dto) {
    return XAccountConnection(
      status: dto.connected
          ? XAccountStatus.connected
          : XAccountStatus.disconnected,
      username: dto.username,
      displayName: dto.displayName,
      avatarUrl: dto.avatarUrl,
    );
  }
}
