import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/load_discussion_threads_usecase.dart';
import '../../domain/usecases/submit_discussion_post_usecase.dart';
import '../../domain/usecases/submit_discussion_reply_usecase.dart';
import '../state/discussion_board_state.dart';

class DiscussionBoardController extends StateNotifier<DiscussionBoardState> {
  DiscussionBoardController(
    this._loadUseCase,
    this._submitPostUseCase,
    this._submitReplyUseCase,
  ) : super(const DiscussionBoardState.initial()) {
    unawaited(loadThreads());
  }

  final LoadDiscussionThreadsUseCase _loadUseCase;
  final SubmitDiscussionPostUseCase _submitPostUseCase;
  final SubmitDiscussionReplyUseCase _submitReplyUseCase;

  Future<void> loadThreads() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final threads = await _loadUseCase.call();
      state = state.copyWith(
        isLoading: false,
        threads: threads,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'failed_to_load_threads',
      );
    }
  }

  void updateComposerText(String text) {
    state = state.copyWith(composerText: text);
  }

  void toggleReplies(String threadId) {
    final next = Set<String>.from(state.expandedThreadIds);
    if (next.contains(threadId)) {
      next.remove(threadId);
    } else {
      next.add(threadId);
    }
    state = state.copyWith(expandedThreadIds: next);
  }

  void updateReplyDraft(String threadId, String text) {
    final drafts = Map<String, String>.from(state.replyDrafts);
    drafts[threadId] = text;
    state = state.copyWith(replyDrafts: drafts);
  }

  Future<bool> submitPost({
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
  }) async {
    final content = state.composerText.trim();
    if (content.isEmpty || state.isPosting) {
      return false;
    }

    state = state.copyWith(isPosting: true, clearError: true);
    try {
      final threads = await _submitPostUseCase.call(
        content: content,
        nowLabel: nowLabel,
        fallbackName: fallbackName,
        fallbackHandle: fallbackHandle,
        fallbackBadgeLabel: fallbackBadgeLabel,
      );
      state = state.copyWith(
        isPosting: false,
        composerText: '',
        threads: threads,
        clearError: true,
      );
      return true;
    } catch (_) {
      state = state.copyWith(
        isPosting: false,
        errorMessage: 'failed_to_submit_post',
      );
      return false;
    }
  }

  Future<bool> submitReply(
    String threadId, {
    required String nowLabel,
    required String fallbackName,
    required String fallbackHandle,
    required String fallbackBadgeLabel,
  }) async {
    final draft = (state.replyDrafts[threadId] ?? '').trim();
    if (draft.isEmpty || state.replySubmittingThreadIds.contains(threadId)) {
      return false;
    }

    final submitting = Set<String>.from(state.replySubmittingThreadIds)
      ..add(threadId);
    state = state.copyWith(
      replySubmittingThreadIds: submitting,
      clearError: true,
    );

    try {
      final threads = await _submitReplyUseCase.call(
        threadId: threadId,
        content: draft,
        nowLabel: nowLabel,
        fallbackName: fallbackName,
        fallbackHandle: fallbackHandle,
        fallbackBadgeLabel: fallbackBadgeLabel,
      );

      final nextDrafts = Map<String, String>.from(state.replyDrafts)
        ..[threadId] = '';
      final nextSubmitting = Set<String>.from(state.replySubmittingThreadIds)
        ..remove(threadId);
      state = state.copyWith(
        threads: threads,
        replyDrafts: nextDrafts,
        replySubmittingThreadIds: nextSubmitting,
        clearError: true,
      );
      return true;
    } catch (_) {
      final nextSubmitting = Set<String>.from(state.replySubmittingThreadIds)
        ..remove(threadId);
      state = state.copyWith(
        replySubmittingThreadIds: nextSubmitting,
        errorMessage: 'failed_to_submit_reply',
      );
      return false;
    }
  }
}
