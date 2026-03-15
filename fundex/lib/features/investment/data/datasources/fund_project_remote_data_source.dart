import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

abstract class FundProjectRemoteDataSource {
  Future<List<FundProjectDto>> fetchFundProjectList();
  Future<FundProjectDto> fetchFundProjectDetail({required String id});
}

class FundProjectRemoteDataSourceImpl implements FundProjectRemoteDataSource {
  FundProjectRemoteDataSourceImpl(
    CoreHttpClient client, {
    FundProjectApiClient? apiClient,
  }) : _apiClient = apiClient ?? FundProjectApiClient(client);

  final FundProjectApiClient _apiClient;

  @override
  Future<List<FundProjectDto>> fetchFundProjectList() async {
    return _apiClient.fetchFundProjectList();
  }

  @override
  Future<FundProjectDto> fetchFundProjectDetail({required String id}) async {
    return _apiClient.fetchFundProjectDetail(id: id);
  }
}
