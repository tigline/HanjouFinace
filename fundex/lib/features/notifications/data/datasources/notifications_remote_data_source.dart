import 'package:company_api_runtime/company_api_runtime.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NoticeItemDto>> fetchNotices({int startPage = 1, int limit = 50});

  Future<NoticeStatisticsDto> fetchStatistics();

  Future<NoticeItemDto> checkNotice({required int id});
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl(this._apiClient);

  final NoticeApiClient _apiClient;

  @override
  Future<List<NoticeItemDto>> fetchNotices({
    int startPage = 1,
    int limit = 50,
  }) async {
    final page = await _apiClient.fetchNoticeList(
      startPage: startPage,
      limit: limit,
    );
    return page.rows;
  }

  @override
  Future<NoticeStatisticsDto> fetchStatistics() async {
    return _apiClient.fetchNoticeStatistics();
  }

  @override
  Future<NoticeItemDto> checkNotice({required int id}) async {
    return _apiClient.checkNotice(id: id);
  }
}
