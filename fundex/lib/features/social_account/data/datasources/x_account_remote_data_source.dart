import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

abstract class XAccountRemoteDataSource {
  Future<XAccountConnectionDto> fetchAccount();

  Future<XOAuthStartDto> startOAuth();

  Future<void> disconnectAccount();
}

class XAccountRemoteDataSourceImpl implements XAccountRemoteDataSource {
  XAccountRemoteDataSourceImpl(
    CoreHttpClient client, {
    XAccountApiClient? apiClient,
  }) : _apiClient = apiClient ?? XAccountApiClient(client);

  final XAccountApiClient _apiClient;

  @override
  Future<XAccountConnectionDto> fetchAccount() => _apiClient.fetchAccount();

  @override
  Future<XOAuthStartDto> startOAuth() => _apiClient.startOAuth();

  @override
  Future<void> disconnectAccount() => _apiClient.disconnectAccount();
}
