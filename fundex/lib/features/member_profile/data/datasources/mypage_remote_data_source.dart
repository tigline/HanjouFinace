import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

import '../../../../app/config/api_paths.dart';
import '../../../../app/network/app_api_response_profiles.dart';
import '../models/mypage_dtos.dart';

abstract class MyPageRemoteDataSource {
  Future<MyPageAccountStatisticDto> fetchAccountStatistic();

  Future<List<MyPageApplyRecordDto>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
  });

  Future<List<MyPageOrderInquiryRecordDto>> fetchOrderInquiryList({
    required int userId,
    int startPage = 1,
    int limit = 20,
  });

  Future<List<MyPageInvestmentRecordDto>> fetchInvestmentList({
    int startPage = 1,
    int limit = 20,
  });
}

class MyPageRemoteDataSourceImpl implements MyPageRemoteDataSource {
  MyPageRemoteDataSourceImpl(this._client, {LegacyEnvelopeCodec? envelopeCodec})
    : _envelopeCodec =
          envelopeCodec ??
          const LegacyEnvelopeCodec(profile: AppApiResponseProfiles.oa);

  final CoreHttpClient _client;
  final LegacyEnvelopeCodec _envelopeCodec;

  @override
  Future<MyPageAccountStatisticDto> fetchAccountStatistic() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      FundingMemberApiPath.accountStatistic,
      options: authRequired(true),
    );

    final data = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load account statistic.',
    );
    return MyPageAccountStatisticDto.fromJson(data);
  }

  @override
  Future<List<MyPageApplyRecordDto>> fetchApplyList({
    int startPage = 1,
    int limit = 20,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      FundingMemberApiPath.applyList,
      data: <String, dynamic>{'startPage': startPage, 'limit': limit},
      options: authRequired(true),
    );

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load member apply list.',
      pageProfile: AppApiResponseProfiles.standardPage,
    );
    return rows
        .map((row) => MyPageApplyRecordDto.fromJson(row))
        .toList(growable: false);
  }

  @override
  Future<List<MyPageOrderInquiryRecordDto>> fetchOrderInquiryList({
    required int userId,
    int startPage = 1,
    int limit = 20,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      FundingMemberApiPath.orderInquiryPage,
      data: <String, dynamic>{
        'startPage': startPage,
        'limit': limit,
        'userId': userId,
      },
      options: authRequired(true),
    );

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load order inquiry list.',
      pageProfile: AppApiResponseProfiles.standardPage,
    );
    return rows
        .map((row) => MyPageOrderInquiryRecordDto.fromJson(row))
        .toList(growable: false);
  }

  @override
  Future<List<MyPageInvestmentRecordDto>> fetchInvestmentList({
    int startPage = 1,
    int limit = 20,
  }) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      FundingMemberApiPath.myInvestmentList,
      data: <String, dynamic>{'startPage': startPage, 'limit': limit},
      options: authRequired(true),
    );

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load my investment list.',
      pageProfile: AppApiResponseProfiles.standardPage,
    );
    return rows
        .map((row) => MyPageInvestmentRecordDto.fromJson(row))
        .toList(growable: false);
  }
}
