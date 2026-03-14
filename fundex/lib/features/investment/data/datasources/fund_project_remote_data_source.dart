import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

import '../../../../app/config/api_paths.dart';
import '../../../../app/network/app_api_response_profiles.dart';
import '../models/fund_project_dto.dart';

abstract class FundProjectRemoteDataSource {
  Future<List<FundProjectDto>> fetchFundProjectList();
  Future<FundProjectDto> fetchFundProjectDetail({required String id});
}

class FundProjectRemoteDataSourceImpl implements FundProjectRemoteDataSource {
  FundProjectRemoteDataSourceImpl(
    this._client, {
    LegacyEnvelopeCodec? envelopeCodec,
  }) : _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(profile: AppApiResponseProfiles.oa);

  final CoreHttpClient _client;
  final LegacyEnvelopeCodec _envelopeCodec;

  @override
  Future<List<FundProjectDto>> fetchFundProjectList() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      FundingFundApiPath.projectList,
      options: authRequired(true),
    );

    final rows = _envelopeCodec.extractDataList(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load fund project list.',
    );
    return rows
        .map((row) => FundProjectDto.fromJson(row))
        .toList(growable: false);
  }

  @override
  Future<FundProjectDto> fetchFundProjectDetail({required String id}) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      FundingFundApiPath.projectDetail,
      queryParameters: <String, dynamic>{'id': id},
      options: authRequired(true),
    );

    final row = _envelopeCodec.extractDataMap(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load fund project detail.',
    );
    if (row.isEmpty) {
      throw StateError('Failed to load fund project detail.');
    }
    return FundProjectDto.fromJson(row);
  }
}
