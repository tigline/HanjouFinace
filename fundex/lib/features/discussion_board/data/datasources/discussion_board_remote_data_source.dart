import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

import '../../../../app/config/api_paths.dart';
import '../../../../app/network/app_api_response_profiles.dart';
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
  DiscussionBoardRemoteDataSourceImpl(
    this._client, {
    LegacyEnvelopeCodec? envelopeCodec,
  }) : _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(profile: AppApiResponseProfiles.oa);

  final CoreHttpClient _client;
  final LegacyEnvelopeCodec _envelopeCodec;

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

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load comments.',
      pageProfile: AppApiResponseProfiles.standardPage,
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

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to send comment.',
      requireTruthyData: true,
    );
  }

  @override
  Future<void> deleteComment({required int commentId}) async {
    final response = await _client.dio.delete<Map<String, dynamic>>(
      FundingCommentApiPath.commentDelete,
      queryParameters: <String, dynamic>{'commentId': commentId},
      options: authRequired(true),
    );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to delete comment.',
      requireTruthyData: true,
    );
  }
}
