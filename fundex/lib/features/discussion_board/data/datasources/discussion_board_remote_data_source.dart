import 'package:core_network/core_network.dart';

import '../../../../app/config/api_paths.dart';
import '../models/discussion_comment_dto.dart';

abstract class DiscussionBoardRemoteDataSource {
  Future<List<DiscussionCommentDto>> fetchCommentPage({
    int startPage = 1,
    int limit = 50,
    int? projectId,
  });

  Future<void> sendComment({
    required String content,
    int? parentId,
    int? projectId,
  });

  Future<void> deleteComment({required int commentId});
}

class DiscussionBoardRemoteDataSourceImpl
    implements DiscussionBoardRemoteDataSource {
  DiscussionBoardRemoteDataSourceImpl(this._client);

  final CoreHttpClient _client;

  @override
  Future<List<DiscussionCommentDto>> fetchCommentPage({
    int startPage = 1,
    int limit = 50,
    int? projectId,
  }) async {
    final payload = <String, dynamic>{'startPage': startPage, 'limit': limit};
    if (projectId != null) {
      payload['projectId'] = projectId;
    }

    final response = await _client.dio.post<Map<String, dynamic>>(
      FundingCommentApiPath.commentPage,
      data: payload,
      options: authRequired(true),
    );

    final rows = _extractPagedRows(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to load comments.',
    );
    return rows
        .map((Map<String, dynamic> row) => DiscussionCommentDto.fromJson(row))
        .toList(growable: false);
  }

  @override
  Future<void> sendComment({
    required String content,
    int? parentId,
    int? projectId,
  }) async {
    final payload = <String, dynamic>{'content': content.trim()};
    if (parentId != null) {
      payload['parentId'] = parentId;
    }
    if (projectId != null) {
      payload['projectId'] = projectId;
    }

    final response = await _client.dio.post<Map<String, dynamic>>(
      FundingCommentApiPath.commentSend,
      data: payload,
      options: authRequired(true),
    );

    _assertLegacyBoolSuccessIfPresent(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to send comment.',
    );
  }

  @override
  Future<void> deleteComment({required int commentId}) async {
    final response = await _client.dio.delete<Map<String, dynamic>>(
      FundingCommentApiPath.commentDelete,
      queryParameters: <String, dynamic>{'commentId': commentId},
      options: authRequired(true),
    );

    _assertLegacyBoolSuccessIfPresent(
      _toJsonMap(response.data),
      fallbackMessage: 'Failed to delete comment.',
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
    final data = payload['data'];
    final codeOk = code == 200 || code == '200';
    if (!codeOk) {
      return false;
    }
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
      final normalized = data.toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'ok';
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

  void _assertLegacyBoolSuccessIfPresent(
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
