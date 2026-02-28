import 'package:core_network/core_network.dart';

import '../../../../app/config/api_paths.dart';
import '../models/fund_project_dto.dart';

abstract class FundProjectRemoteDataSource {
  Future<List<FundProjectDto>> fetchFundProjectList();
  Future<FundProjectDto> fetchFundProjectDetail({required String id});
}

class FundProjectRemoteDataSourceImpl implements FundProjectRemoteDataSource {
  FundProjectRemoteDataSourceImpl(this._client);

  final CoreHttpClient _client;

  Map<String, dynamic> _toJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return <String, dynamic>{};
  }

  bool _looksLikeLegacyEnvelope(Map<String, dynamic> payload) {
    return payload.containsKey('code') ||
        payload.containsKey('msg') ||
        payload.containsKey('data');
  }

  bool _isLegacySuccessResponse(Map<String, dynamic> payload) {
    final code = payload['code'];
    return code == 200 || code == '200';
  }

  Never _throwLegacyFailure(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    final message = payload['msg'] ?? payload['message'] ?? fallbackMessage;
    throw StateError(message.toString());
  }

  List<Map<String, dynamic>> _toJsonMapList(dynamic data) {
    if (data is List) {
      return data
          .map<Map<String, dynamic>>((item) => _toJsonMap(item))
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
    }
    final single = _toJsonMap(data);
    if (single.isEmpty) {
      return const <Map<String, dynamic>>[];
    }
    return <Map<String, dynamic>>[single];
  }

  List<Map<String, dynamic>> _extractEnvelopeDataList(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      return const <Map<String, dynamic>>[];
    }

    if (_looksLikeLegacyEnvelope(payload)) {
      if (!_isLegacySuccessResponse(payload)) {
        _throwLegacyFailure(payload, fallbackMessage: fallbackMessage);
      }
      return _toJsonMapList(payload['data']);
    }

    return _toJsonMapList(payload);
  }

  Map<String, dynamic> _extractEnvelopeDataMap(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      return <String, dynamic>{};
    }

    if (_looksLikeLegacyEnvelope(payload)) {
      if (!_isLegacySuccessResponse(payload)) {
        _throwLegacyFailure(payload, fallbackMessage: fallbackMessage);
      }
      return _toJsonMap(payload['data']);
    }

    return payload;
  }

  @override
  Future<List<FundProjectDto>> fetchFundProjectList() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      FundingFundApiPath.projectList,
      options: authRequired(true),
    );

    final rows = _extractEnvelopeDataList(
      _toJsonMap(response.data),
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

    final row = _extractEnvelopeDataMap(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to load fund project detail.',
    );
    if (row.isEmpty) {
      throw StateError('Failed to load fund project detail.');
    }
    return FundProjectDto.fromJson(row);
  }
}
