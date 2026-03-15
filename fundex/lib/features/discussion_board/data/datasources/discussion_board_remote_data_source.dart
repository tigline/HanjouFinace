import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';

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
    CoreHttpClient client, {
    DiscussionBoardApiClient? apiClient,
  }) : _apiClient = apiClient ?? DiscussionBoardApiClient(client);

  final DiscussionBoardApiClient _apiClient;

  @override
  Future<List<DiscussionCommentDto>> fetchCommentPage({
    int startPage = 1,
    int limit = 50,
    int? projectId,
  }) async {
    return _apiClient.fetchCommentPage(
      startPage: startPage,
      limit: limit,
      projectId: projectId,
    );
  }

  @override
  Future<void> sendComment({
    required String content,
    int? parentId,
    int? projectId,
  }) async {
    await _apiClient.sendComment(
      content: content,
      parentId: parentId,
      projectId: projectId,
    );
  }

  @override
  Future<void> deleteComment({required int commentId}) async {
    await _apiClient.deleteComment(commentId: commentId);
  }
}
