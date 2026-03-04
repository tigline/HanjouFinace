import 'package:core_network/core_network.dart';

import '../../../../app/config/api_paths.dart';
import '../models/mypage_dtos.dart';

abstract class MyPageRemoteDataSource {
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
  MyPageRemoteDataSourceImpl(this._client);

  final CoreHttpClient _client;

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

    final rows = _extractPagedRows(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to load member apply list.',
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

    final rows = _extractPagedRows(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to load order inquiry list.',
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

    final rows = _extractPagedRows(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to load my investment list.',
    );
    return rows
        .map((row) => MyPageInvestmentRecordDto.fromJson(row))
        .toList(growable: false);
  }

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

  List<Map<String, dynamic>> _extractPagedRows(
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

      final pageData = _toJsonMap(payload['data']);
      final rows = pageData['rows'];
      if (rows is List) {
        return rows
            .map<Map<String, dynamic>>((item) => _toJsonMap(item))
            .where((item) => item.isNotEmpty)
            .toList(growable: false);
      }
      return const <Map<String, dynamic>>[];
    }

    final rows = payload['rows'];
    if (rows is List) {
      return rows
          .map<Map<String, dynamic>>((item) => _toJsonMap(item))
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }
}
