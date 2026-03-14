import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

import '../../../../app/config/api_paths.dart';
import '../../../../app/network/app_api_response_profiles.dart';
import '../../../../app/network/api_cluster_router.dart';
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
  MyPageRemoteDataSourceImpl(
    CoreHttpClient oaClient, {
    CoreHttpClient? memberClient,
    ApiClusterRouter? clusterRouter,
    LegacyEnvelopeCodec? envelopeCodec,
  }) : _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(profile: AppApiResponseProfiles.oa),
       _clusterRouter =
           clusterRouter ??
           ApiClusterRouter.fromClients(
             oaClient: oaClient,
             memberClient: memberClient,
           );

  final ApiClusterRouter _clusterRouter;
  final LegacyEnvelopeCodec _envelopeCodec;

  @override
  Future<MyPageAccountStatisticDto> fetchAccountStatistic() async {
    const path = FundingMemberApiPath.accountStatistic;
    final response = await _clusterRouter
        .dioForPath(path)
        .get<Map<String, dynamic>>(path, options: authRequired(true));

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
    const path = FundingMemberApiPath.applyList;
    final response = await _clusterRouter
        .dioForPath(path)
        .post<Map<String, dynamic>>(
          path,
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
    const path = FundingMemberApiPath.orderInquiryPage;
    final response = await _clusterRouter
        .dioForPath(path)
        .post<Map<String, dynamic>>(
          path,
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
    const path = FundingMemberApiPath.myInvestmentList;
    final response = await _clusterRouter
        .dioForPath(path)
        .post<Map<String, dynamic>>(
          path,
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
