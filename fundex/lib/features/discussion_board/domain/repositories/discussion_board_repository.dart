import '../entities/discussion_board_models.dart';

abstract class DiscussionBoardRepository {
  Future<List<DiscussionThread>> loadThreads();

  Future<List<DiscussionThread>> submitPost({
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
  });

  Future<List<DiscussionThread>> submitReply({
    required String threadId,
    required String content,
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
  });
}
