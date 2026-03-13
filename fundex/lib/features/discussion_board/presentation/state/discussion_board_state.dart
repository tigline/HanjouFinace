import '../../domain/entities/discussion_board_models.dart';

class DiscussionBoardState {
  const DiscussionBoardState({
    required this.isLoading,
    required this.isRefreshing,
    required this.isLoadingMore,
    required this.isPosting,
    required this.currentPage,
    required this.hasMore,
    required this.threads,
    required this.expandedThreadIds,
    required this.replyDrafts,
    required this.replySubmittingThreadIds,
    required this.deletingCommentIds,
    required this.composerText,
    this.errorMessage,
  });

  const DiscussionBoardState.initial()
    : isLoading = true,
      isRefreshing = false,
      isLoadingMore = false,
      isPosting = false,
      currentPage = 1,
      hasMore = true,
      threads = const <DiscussionThread>[],
      expandedThreadIds = const <String>{},
      replyDrafts = const <String, String>{},
      replySubmittingThreadIds = const <String>{},
      deletingCommentIds = const <String>{},
      composerText = '',
      errorMessage = null;

  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isPosting;
  final int currentPage;
  final bool hasMore;
  final List<DiscussionThread> threads;
  final Set<String> expandedThreadIds;
  final Map<String, String> replyDrafts;
  final Set<String> replySubmittingThreadIds;
  final Set<String> deletingCommentIds;
  final String composerText;
  final String? errorMessage;

  bool get hasData => threads.isNotEmpty;

  DiscussionBoardState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isPosting,
    int? currentPage,
    bool? hasMore,
    List<DiscussionThread>? threads,
    Set<String>? expandedThreadIds,
    Map<String, String>? replyDrafts,
    Set<String>? replySubmittingThreadIds,
    Set<String>? deletingCommentIds,
    String? composerText,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DiscussionBoardState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isPosting: isPosting ?? this.isPosting,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      threads: threads ?? this.threads,
      expandedThreadIds: expandedThreadIds ?? this.expandedThreadIds,
      replyDrafts: replyDrafts ?? this.replyDrafts,
      replySubmittingThreadIds:
          replySubmittingThreadIds ?? this.replySubmittingThreadIds,
      deletingCommentIds: deletingCommentIds ?? this.deletingCommentIds,
      composerText: composerText ?? this.composerText,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
