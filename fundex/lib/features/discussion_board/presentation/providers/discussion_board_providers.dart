import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/storage/app_storage_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/discussion_board_local_data_source.dart';
import '../../data/datasources/discussion_board_remote_data_source.dart';
import '../../data/repositories/discussion_board_repository_impl.dart';
import '../../domain/repositories/discussion_board_repository.dart';
import '../../domain/usecases/delete_discussion_comment_usecase.dart';
import '../../domain/usecases/load_discussion_threads_usecase.dart';
import '../../domain/usecases/submit_discussion_post_usecase.dart';
import '../../domain/usecases/submit_discussion_reply_usecase.dart';
import '../controllers/discussion_board_controller.dart';
import '../state/discussion_board_state.dart';

final discussionBoardLocalDataSourceProvider =
    Provider<DiscussionBoardLocalDataSource>((ref) {
      return DiscussionBoardLocalDataSourceImpl(
        ref.watch(largeDataStoreProvider),
        ref.watch(authLocalDataSourceProvider),
      );
    });

/// Optional project-scoped feed id. Keep `null` for global feed.
final discussionBoardProjectIdProvider = Provider<int?>((ref) => null);

final discussionBoardRemoteDataSourceProvider =
    Provider<DiscussionBoardRemoteDataSource>((ref) {
      return DiscussionBoardRemoteDataSourceImpl(
        ref.watch(coreHttpClientProvider),
      );
    });

final discussionBoardRepositoryProvider = Provider<DiscussionBoardRepository>((
  ref,
) {
  return DiscussionBoardRepositoryImpl(
    remote: ref.watch(discussionBoardRemoteDataSourceProvider),
    local: ref.watch(discussionBoardLocalDataSourceProvider),
    projectId: ref.watch(discussionBoardProjectIdProvider),
  );
});

final loadDiscussionThreadsUseCaseProvider =
    Provider<LoadDiscussionThreadsUseCase>((ref) {
      return LoadDiscussionThreadsUseCase(
        ref.watch(discussionBoardRepositoryProvider),
      );
    });

final submitDiscussionPostUseCaseProvider =
    Provider<SubmitDiscussionPostUseCase>((ref) {
      return SubmitDiscussionPostUseCase(
        ref.watch(discussionBoardRepositoryProvider),
      );
    });

final submitDiscussionReplyUseCaseProvider =
    Provider<SubmitDiscussionReplyUseCase>((ref) {
      return SubmitDiscussionReplyUseCase(
        ref.watch(discussionBoardRepositoryProvider),
      );
    });

final deleteDiscussionCommentUseCaseProvider =
    Provider<DeleteDiscussionCommentUseCase>((ref) {
      return DeleteDiscussionCommentUseCase(
        ref.watch(discussionBoardRepositoryProvider),
      );
    });

final discussionBoardControllerProvider =
    StateNotifierProvider<DiscussionBoardController, DiscussionBoardState>((
      ref,
    ) {
      return DiscussionBoardController(
        ref.watch(loadDiscussionThreadsUseCaseProvider),
        ref.watch(submitDiscussionPostUseCaseProvider),
        ref.watch(submitDiscussionReplyUseCaseProvider),
        ref.watch(deleteDiscussionCommentUseCaseProvider),
      );
    });
