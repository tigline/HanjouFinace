import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'notice_dtos.dart';

typedef NoticeDioForPath = Dio Function(String path);

class NoticeApiPaths {
  const NoticeApiPaths._();

  static const String check = '/crowdfunding/notice/check';
  static const String list = '/crowdfunding/notice/list';
  static const String statistics = '/crowdfunding/notice/statistics';
}

class NoticeApiClient {
  NoticeApiClient({
    required NoticeDioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    this.checkPath = NoticeApiPaths.check,
    this.listPath = NoticeApiPaths.list,
    this.statisticsPath = NoticeApiPaths.statistics,
  }) : _dioForPath = dioForPath,
       _envelopeCodec = envelopeCodec ?? const LegacyEnvelopeCodec();

  final NoticeDioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;

  final String checkPath;
  final String listPath;
  final String statisticsPath;

  Future<NoticeItemDto> checkNotice({required int id}) async {
    final response = await _dioForPath(checkPath).get<Map<String, dynamic>>(
      checkPath,
      queryParameters: <String, dynamic>{'id': id},
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load notice detail.',
    );
    return NoticeItemDto.fromJson(data);
  }

  Future<NoticePageResultDto> fetchNoticeList({
    int startPage = 1,
    int limit = 20,
    int? memberId,
    bool? status,
  }) async {
    final request = NoticeListRequestDto(
      startPage: startPage,
      limit: limit,
      memberId: memberId,
      status: status,
    );

    final response = await _dioForPath(listPath).post<Map<String, dynamic>>(
      listPath,
      data: request.toJson(),
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load notice list.',
    );
    return NoticePageResultDto.fromJson(data);
  }

  Future<NoticeStatisticsDto> fetchNoticeStatistics() async {
    final response = await _dioForPath(
      statisticsPath,
    ).get<Map<String, dynamic>>(statisticsPath, options: authRequired(true));

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load notice statistics.',
    );
    return NoticeStatisticsDto.fromJson(data);
  }
}
