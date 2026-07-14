import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

abstract class InviteFriendsRemoteDataSource {
  Future<ChannelPartnerDto> fetchChannelDetail();
}

class InviteFriendsRemoteDataSourceImpl
    implements InviteFriendsRemoteDataSource {
  InviteFriendsRemoteDataSourceImpl(
    CoreHttpClient client, {
    ChannelApiClient? apiClient,
  }) : _apiClient = apiClient ?? ChannelApiClient(client);

  final ChannelApiClient _apiClient;

  @override
  Future<ChannelPartnerDto> fetchChannelDetail() {
    return _apiClient.fetchMyChannelDetail();
  }
}
