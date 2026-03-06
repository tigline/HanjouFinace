import '../../domain/entities/discussion_board_models.dart';

class DiscussionBoardState {
  const DiscussionBoardState({
    required this.isLoading,
    required this.isPosting,
    required this.threads,
    required this.expandedThreadIds,
    required this.replyDrafts,
    required this.replySubmittingThreadIds,
    required this.composerText,
    this.errorMessage,
  });

  const DiscussionBoardState.initial()
    : isLoading = true,
      isPosting = false,
      threads = const <DiscussionThread>[],
      expandedThreadIds = const <String>{},
      replyDrafts = const <String, String>{},
      replySubmittingThreadIds = const <String>{},
      composerText = '',
      errorMessage = null;

  final bool isLoading;
  final bool isPosting;
  final List<DiscussionThread> threads;
  final Set<String> expandedThreadIds;
  final Map<String, String> replyDrafts;
  final Set<String> replySubmittingThreadIds;
  final String composerText;
  final String? errorMessage;

  bool get hasData => threads.isNotEmpty;

  DiscussionBoardState copyWith({
    bool? isLoading,
    bool? isPosting,
    List<DiscussionThread>? threads,
    Set<String>? expandedThreadIds,
    Map<String, String>? replyDrafts,
    Set<String>? replySubmittingThreadIds,
    String? composerText,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DiscussionBoardState(
      isLoading: isLoading ?? this.isLoading,
      isPosting: isPosting ?? this.isPosting,
      threads: threads ?? this.threads,
      expandedThreadIds: expandedThreadIds ?? this.expandedThreadIds,
      replyDrafts: replyDrafts ?? this.replyDrafts,
      replySubmittingThreadIds:
          replySubmittingThreadIds ?? this.replySubmittingThreadIds,
      composerText: composerText ?? this.composerText,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
