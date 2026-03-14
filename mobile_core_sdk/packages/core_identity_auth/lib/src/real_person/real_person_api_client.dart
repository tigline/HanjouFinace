import 'dart:io';

import 'package:core_network/core_network.dart';

import 'real_person_endpoints.dart';
import 'real_person_gateway.dart';
import 'real_person_models.dart';

class RealPersonApiClient implements RealPersonGateway {
  RealPersonApiClient({
    required CoreHttpClient client,
    RealPersonEndpoints endpoints = const RealPersonEndpoints(),
  }) : _client = client,
       _endpoints = endpoints;

  final CoreHttpClient _client;
  final RealPersonEndpoints _endpoints;

  @override
  Future<String> fetchToken({required String bizId}) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      _endpoints.token,
      queryParameters: <String, dynamic>{'bizId': bizId},
      options: authRequired(true),
    );
    return _extractDataAsString(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to fetch real-person token.',
    );
  }

  @override
  Future<Map<String, dynamic>> fetchResult({required String bizId}) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      _endpoints.result,
      queryParameters: <String, dynamic>{'bizId': bizId},
      options: authRequired(true),
    );
    return _extractDataAsMap(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to fetch real-person result.',
    );
  }

  @override
  Future<Map<String, dynamic>> fetchVerifyImage({required int userId}) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      _endpoints.image,
      queryParameters: <String, dynamic>{'userId': userId},
      options: authRequired(true),
    );
    return _extractDataAsMap(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to fetch verify image.',
    );
  }

  @override
  Future<Map<String, dynamic>> uploadPhoto({required String filePath}) {
    return _uploadFile(
      path: _endpoints.upload,
      filePath: filePath,
      fallbackMessage: 'Failed to upload real-person photo.',
    );
  }

  @override
  Future<Map<String, dynamic>> uploadPhotoForUserId({
    required String filePath,
  }) {
    return _uploadFile(
      path: _endpoints.uploadUserId,
      filePath: filePath,
      fallbackMessage: 'Failed to upload user-id photo.',
    );
  }

  @override
  Future<RealPersonIdentifyResponse> identify(
    RealPersonIdentifyRequest request,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      _endpoints.identify,
      data: request.toJson(),
      options: authRequired(true),
    );
    final envelope = _toJsonMap(response.data);
    final data = _extractDataAsMap(
      envelope,
      fallbackMessage: 'Failed to identify real person.',
    );
    return RealPersonIdentifyResponse(
      userId: _toIntOrNull(data['userId']),
      rawData: data,
    );
  }

  Future<Map<String, dynamic>> _uploadFile({
    required String path,
    required String filePath,
    required String fallbackMessage,
  }) async {
    final normalizedPath = filePath.trim();
    if (normalizedPath.isEmpty) {
      throw StateError(fallbackMessage);
    }

    final file = File(normalizedPath);
    if (!await file.exists()) {
      throw StateError(fallbackMessage);
    }

    final response = await _client.dio.post<dynamic>(
      path,
      data: FormData.fromMap(<String, dynamic>{
        'file': await MultipartFile.fromFile(normalizedPath),
      }),
      options: authRequired(
        true,
      ).copyWith(contentType: Headers.multipartFormDataContentType),
    );

    return _extractDataAsMap(
      _toJsonMap(response.data),
      fallbackMessage: fallbackMessage,
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

  bool _looksLikeEnvelope(Map<String, dynamic> payload) {
    return payload.containsKey('code') ||
        payload.containsKey('msg') ||
        payload.containsKey('data');
  }

  bool _isSuccessCode(dynamic code) {
    return code == 200 || code == '200' || code == 0 || code == '0';
  }

  Never _throwFailure(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    final message = payload['msg'] ?? payload['message'] ?? fallbackMessage;
    throw StateError(message.toString());
  }

  dynamic _extractData(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      return null;
    }

    if (_looksLikeEnvelope(payload)) {
      if (!_isSuccessCode(payload['code'])) {
        _throwFailure(payload, fallbackMessage: fallbackMessage);
      }
      return payload['data'];
    }

    return payload;
  }

  String _extractDataAsString(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    final data = _extractData(payload, fallbackMessage: fallbackMessage);
    final text = data?.toString().trim() ?? '';
    if (text.isEmpty) {
      throw StateError(fallbackMessage);
    }
    return text;
  }

  Map<String, dynamic> _extractDataAsMap(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    final data = _extractData(payload, fallbackMessage: fallbackMessage);
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data == null) {
      return const <String, dynamic>{};
    }
    return <String, dynamic>{'value': data};
  }

  int? _toIntOrNull(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }
}
