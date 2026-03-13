import '../entities/discussion_board_models.dart';
import '../repositories/discussion_board_repository.dart';

class LoadDiscussionThreadsUseCase {
  const LoadDiscussionThreadsUseCase(this._repository);

  final DiscussionBoardRepository _repository;

  Future<List<DiscussionThread>> call({int page = 1, int limit = 50}) {
    return _repository.loadThreads(page: page, limit: limit);
  }
}
