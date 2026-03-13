import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../discussion_board/presentation/controllers/discussion_board_controller.dart';
import '../../../discussion_board/presentation/providers/discussion_board_providers.dart';
import '../../../discussion_board/presentation/state/discussion_board_state.dart';

class FundProjectDetailCommentsSection extends ConsumerStatefulWidget {
  const FundProjectDetailCommentsSection({
    super.key,
    required this.projectId,
    this.onViewMoreTap,
  });

  final int? projectId;
  final VoidCallback? onViewMoreTap;

  @override
  ConsumerState<FundProjectDetailCommentsSection> createState() =>
      _FundProjectDetailCommentsSectionState();
}

class _FundProjectDetailCommentsSectionState
    extends ConsumerState<FundProjectDetailCommentsSection> {
  late final TextEditingController _composerController;

  @override
  void initState() {
    super.initState();
    _composerController = TextEditingController();
  }

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  String _resolveAvatarText(AuthUser? user) {
    final candidates = <String>[
      user?.lastName ?? '',
      user?.username ?? '',
      user?.firstName ?? '',
      user?.id ?? '',
    ];
    for (final candidate in candidates) {
      final text = candidate.trim();
      if (text.isNotEmpty) {
        return String.fromCharCode(text.runes.first);
      }
    }
    return '田';
  }

  String _resolveCurrentUserId(AuthUser? user) {
    final candidates = <String>[
      user?.userId?.toString() ?? '',
      user?.memberId?.toString() ?? '',
      user?.id ?? '',
      user?.accountId ?? '',
      user?.username ?? '',
    ];
    for (final candidate in candidates) {
      final text = candidate.trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }

  Future<void> _submitPost({required bool isAuthenticated}) async {
    final l10n = context.l10n;
    final controller = ref.read(
      discussionBoardControllerProvider(widget.projectId).notifier,
    );
    if (!isAuthenticated) {
      return;
    }
    final submitted = await controller.submitPost(
      nowLabel: l10n.kizunarkJustNow,
      fallbackName: l10n.kizunarkFallbackDisplayName,
      fallbackHandle: l10n.kizunarkFallbackHandle,
      fallbackBadgeLabel: l10n.kizunarkInvestorBadge,
    );
    if (submitted && mounted) {
      AppNotice.show(context, message: l10n.kizunarkPostSuccessNotice);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
      final previousValue = previous?.asData?.value;
      final nextValue = next.asData?.value;
      if (previousValue == nextValue) {
        return;
      }
      ref
          .read(discussionBoardControllerProvider(widget.projectId).notifier)
          .loadThreads();
    });

    ref.listen<AsyncValue<AuthUser?>>(currentAuthUserProvider, (
      previous,
      next,
    ) {
      final previousId = _resolveCurrentUserId(previous?.asData?.value);
      final nextId = _resolveCurrentUserId(next.asData?.value);
      if (previousId == nextId) {
        return;
      }
      ref
          .read(discussionBoardControllerProvider(widget.projectId).notifier)
          .loadThreads();
    });

    final l10n = context.l10n;
    final state = ref.watch(
      discussionBoardControllerProvider(widget.projectId),
    );
    final controller = ref.read(
      discussionBoardControllerProvider(widget.projectId).notifier,
    );
    final isAuthenticated =
        ref.watch(isAuthenticatedProvider).asData?.value ?? false;
    final currentUser = ref.watch(currentAuthUserProvider).asData?.value;

    if (_composerController.text != state.composerText) {
      _composerController.value = TextEditingValue(
        text: state.composerText,
        selection: TextSelection.collapsed(offset: state.composerText.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (isAuthenticated)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: KizunarkComposerCard(
              leading: KizunarkAvatarBadge(
                text: _resolveAvatarText(currentUser),
                gradientColors: const <Color>[
                  AppColorTokens.kizunarkPrimary,
                  AppColorTokens.kizunarkSecondary,
                ],
                size: 32,
                fontSize: 13,
              ),
              controller: _composerController,
              placeholder: l10n.kizunarkComposePlaceholder,
              postLabel: l10n.kizunarkPostAction,
              enabled: !state.isPosting,
              onChanged: controller.updateComposerText,
              onPostTap: () => _submitPost(isAuthenticated: isAuthenticated),
            ),
          ),
        _FundProjectDetailThreadList(
          l10n: l10n,
          state: state,
          controller: controller,
        ),
        if (widget.onViewMoreTap != null) ...<Widget>[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: widget.onViewMoreTap,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              side: const BorderSide(color: AppColorTokens.fundexViolet),
              foregroundColor: AppColorTokens.fundexViolet,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiTokens.radius12),
              ),
            ),
            child: Text(l10n.fundDetailCommentsMoreAction),
          ),
        ],
      ],
    );
  }
}

class _FundProjectDetailThreadList extends StatelessWidget {
  const _FundProjectDetailThreadList({
    required this.l10n,
    required this.state,
    required this.controller,
  });

  final AppLocalizations l10n;
  final DiscussionBoardState state;
  final DiscussionBoardController controller;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.threads.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (state.threads.isEmpty) {
      return FundDetailContentCard(
        child: Text(
          l10n.kizunarkEmptyState,
          textAlign: TextAlign.center,
          style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle())
              .copyWith(color: AppColorTokens.fundexTextSecondary, height: 1.6),
        ),
      );
    }

    return Column(
      children: state.threads
          .map<Widget>((thread) {
            final expanded = state.expandedThreadIds.contains(thread.id);

            final replies = thread.replies
                .map<Widget>(
                  (reply) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: KizunarkReplyTile(
                      avatar: KizunarkAvatarBadge(
                        text: reply.author.avatarText,
                        gradientColors: reply.author.avatarGradientColorValues
                            .map(Color.new)
                            .toList(growable: false),
                        size: 24,
                        fontSize: 10,
                      ),
                      displayName: reply.author.displayName,
                      timeLabel: reply.timeLabel,
                      body: reply.body,
                      quoteTitle: reply.quote?.sourceText,
                      quoteBody: reply.quote?.body,
                    ),
                  ),
                )
                .toList(growable: false);

            final replySection = replies.isEmpty
                ? null
                : Column(children: replies);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: KizunarkPostCard(
                avatar: KizunarkAvatarBadge(
                  text: thread.author.avatarText,
                  gradientColors: thread.author.avatarGradientColorValues
                      .map(Color.new)
                      .toList(growable: false),
                  size: 32,
                  fontSize: 12,
                ),
                displayName: thread.author.displayName,
                accountText: thread.author.accountHandle,
                badgeLabel: thread.author.badge.label,
                badgeBackgroundColor: Color(
                  thread.author.badge.backgroundColorValue,
                ),
                badgeForegroundColor: Color(
                  thread.author.badge.foregroundColorValue,
                ),
                timeLabel: thread.timeLabel,
                body: thread.body,
                commentCount: thread.commentCount,
                onToggleRepliesTap: () => controller.toggleReplies(thread.id),
                showReplies: expanded,
                replySection: replySection,
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
