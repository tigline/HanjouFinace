import 'dart:io';

import 'package:core_network/core_network.dart';

import '../../../../app/config/api_paths.dart';
import '../../domain/constants/member_profile_upload_markers.dart';
import '../models/member_profile_region_dto.dart';

abstract class MemberProfileRemoteDataSource {
  Future<List<MemberProfileRegionDto>> fetchRegionsByZip({required String zip});

  Future<String> uploadPhoto({
    required String filePath,
    required bool isSelfie,
  });

  Future<void> saveMemberInfo({required Map<String, dynamic> payload});
}

class MemberProfileRemoteDataSourceImpl
    implements MemberProfileRemoteDataSource {
  MemberProfileRemoteDataSourceImpl(this._client);

  final CoreHttpClient _client;

  @override
  Future<List<MemberProfileRegionDto>> fetchRegionsByZip({
    required String zip,
  }) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      FundingMemberApiPath.regionByZip,
      queryParameters: <String, dynamic>{'zip': zip},
      options: authRequired(true),
    );

    final rows = _extractDataRows(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to lookup address by postal code.',
    );

    return rows
        .map((row) => MemberProfileRegionDto.fromJson(row))
        .toList(growable: false);
  }

  @override
  Future<String> uploadPhoto({
    required String filePath,
    required bool isSelfie,
  }) async {
    final normalizedPath = filePath.trim();
    if (normalizedPath.isEmpty) {
      throw StateError('Failed to upload profile photo.');
    }

    final file = File(normalizedPath);
    if (!await file.exists()) {
      throw StateError('Failed to upload profile photo.');
    }

    final uploadPath = isSelfie
        ? FundingMemberApiPath.uploadRealPersonPhoto
        : FundingMemberApiPath.uploadPhoto;
    final response = await _client.dio.post<dynamic>(
      uploadPath,
      data: FormData.fromMap(<String, dynamic>{
        'file': await MultipartFile.fromFile(normalizedPath),
      }),
      options: authRequired(
        true,
      ).copyWith(contentType: Headers.multipartFormDataContentType),
    );

    _debugUploadResponse(path: uploadPath, data: response.data);

    final payload = _toJsonMap(response.data);
    if (isSelfie) {
      _assertSelfieUploadSucceeded(
        responseData: response.data,
        payload: payload,
        fallbackMessage: 'Failed to upload profile photo.',
      );
      return selfieUploadCompletedMarker;
    }

    return _extractStringData(
      payload,
      fallbackMessage: 'Failed to upload profile photo.',
    );
  }

  @override
  Future<void> saveMemberInfo({required Map<String, dynamic> payload}) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      FundingMemberApiPath.saveMemberInfo,
      data: payload,
      options: authRequired(true),
    );

    _assertLegacySuccess(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to save member profile.',
    );
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
    final codeOk = _isSuccessCode(code);
    if (!codeOk) {
      return false;
    }

    final data = payload['data'];
    if (data == null) {
      return true;
    }
    if (data is bool) {
      return data;
    }
    if (data is num) {
      return data != 0;
    }
    if (data is String) {
      final normalized = data.trim().toLowerCase();
      return normalized != 'false' && normalized != '0';
    }
    return true;
  }

  Never _throwLegacyFailure(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    final message = payload['msg'] ?? payload['message'] ?? fallbackMessage;
    throw StateError(message.toString());
  }

  void _assertLegacySuccess(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty || !_looksLikeLegacyEnvelope(payload)) {
      return;
    }
    if (!_isLegacySuccessResponse(payload)) {
      _throwLegacyFailure(payload, fallbackMessage: fallbackMessage);
    }
  }

  String _extractStringData(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      throw StateError(fallbackMessage);
    }

    if (_looksLikeLegacyEnvelope(payload)) {
      if (!_isLegacySuccessResponse(payload)) {
        _throwLegacyFailure(payload, fallbackMessage: fallbackMessage);
      }
      final dynamic data = payload['data'];
      final text = data?.toString().trim() ?? '';
      if (text.isEmpty) {
        throw StateError(fallbackMessage);
      }
      return text;
    }

    final dynamic direct = payload['data'] ?? payload['url'];
    final text = direct?.toString().trim() ?? '';
    if (text.isEmpty) {
      throw StateError(fallbackMessage);
    }
    return text;
  }

  List<Map<String, dynamic>> _extractDataRows(
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
      final data = payload['data'];
      if (data is List) {
        return data
            .map<Map<String, dynamic>>((item) => _toJsonMap(item))
            .where((item) => item.isNotEmpty)
            .toList(growable: false);
      }
      return const <Map<String, dynamic>>[];
    }

    if (payload['rows'] is List) {
      final rows = payload['rows'] as List<dynamic>;
      return rows
          .map<Map<String, dynamic>>((item) => _toJsonMap(item))
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
    }

    return const <Map<String, dynamic>>[];
  }

  void _assertSelfieUploadSucceeded({
    required dynamic responseData,
    required Map<String, dynamic> payload,
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      final text = responseData?.toString().trim() ?? '';
      if (_looksLikeFailureString(text)) {
        throw StateError(fallbackMessage);
      }
      return;
    }

    if (_looksLikeLegacyEnvelope(payload)) {
      final code = payload['code'];
      if (code != null && !_isSuccessCode(code)) {
        _throwLegacyFailure(payload, fallbackMessage: fallbackMessage);
      }
      final data = payload['data'];
      if (!_isTruthyData(data)) {
        throw StateError(fallbackMessage);
      }
      return;
    }

    if (payload.containsKey('success') && !_isTruthyData(payload['success'])) {
      throw StateError(fallbackMessage);
    }
    if (payload.containsKey('ok') && !_isTruthyData(payload['ok'])) {
      throw StateError(fallbackMessage);
    }
  }

  bool _isTruthyData(dynamic data) {
    if (data == null) {
      return true;
    }
    if (data is bool) {
      return data;
    }
    if (data is num) {
      return data != 0;
    }
    if (data is String) {
      final normalized = data.trim().toLowerCase();
      if (normalized.isEmpty) {
        return true;
      }
      return !_looksLikeFailureString(normalized);
    }
    return true;
  }

  bool _looksLikeFailureString(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'false' ||
        normalized == '0' ||
        normalized == 'error' ||
        normalized == 'failed' ||
        normalized == 'fail';
  }

  bool _isSuccessCode(dynamic code) {
    return code == 200 || code == '200' || code == 0 || code == '0';
  }

  void _debugUploadResponse({required String path, required dynamic data}) {
    // ignore: avoid_print
    print(
      '[member_profile_upload_debug] path=$path '
      'dataType=${data.runtimeType} data=$data',
    );
  }
}
