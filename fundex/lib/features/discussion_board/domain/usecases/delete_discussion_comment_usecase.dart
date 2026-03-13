import '../entities/discussion_board_models.dart';
import '../repositories/discussion_board_repository.dart';

class DeleteDiscussionCommentUseCase {
  const DeleteDiscussionCommentUseCase(this._repository);

  final DiscussionBoardRepository _repository;

  Future<List<DiscussionThread>> call({required String commentId}) {
    return _repository.deleteComment(commentId: commentId);
  }
}
