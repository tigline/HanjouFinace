import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

abstract class XAccountRemoteDataSource {
  Future<XAccountConnectionDto> fetchAccount();

  Future<XBindingAttemptDto> startBinding({required String callbackUri});

  Future<XBindingStatusDto> fetchBindingStatus({required String attemptId});

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
  Future<XBindingAttemptDto> startBinding({required String callbackUri}) {
    return _apiClient.startBinding(callbackUri: callbackUri);
  }

  @override
  Future<XBindingStatusDto> fetchBindingStatus({required String attemptId}) {
    return _apiClient.fetchBindingStatus(attemptId: attemptId);
  }

  @override
  Future<void> disconnectAccount() => _apiClient.disconnectAccount();
}
