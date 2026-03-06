import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../controllers/discussion_board_controller.dart';
import '../providers/discussion_board_providers.dart';
import '../state/discussion_board_state.dart';

class DiscussionBoardTabPage extends ConsumerStatefulWidget {
  const DiscussionBoardTabPage({super.key});

  @override
  ConsumerState<DiscussionBoardTabPage> createState() =>
      _DiscussionBoardTabPageState();
}

class _DiscussionBoardTabPageState
    extends ConsumerState<DiscussionBoardTabPage> {
  late final TextEditingController _composerController;
  final Map<String, TextEditingController> _replyControllers =
      <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _composerController = TextEditingController();
  }

  @override
  void dispose() {
    _composerController.dispose();
    for (final controller in _replyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _replyControllerFor(String threadId) {
    return _replyControllers.putIfAbsent(threadId, TextEditingController.new);
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

  Future<void> _submitPost({required bool isAuthenticated}) async {
    final l10n = context.l10n;
    final controller = ref.read(discussionBoardControllerProvider.notifier);
    if (!isAuthenticated) {
      AppNotice.show(context, message: l10n.kizunarkLoginRequiredToPost);
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

  Future<void> _submitReply(
    String threadId, {
    required bool isAuthenticated,
  }) async {
    final l10n = context.l10n;
    final controller = ref.read(discussionBoardControllerProvider.notifier);
    if (!isAuthenticated) {
      AppNotice.show(context, message: l10n.kizunarkLoginRequiredToPost);
      return;
    }
    final submitted = await controller.submitReply(
      threadId,
      nowLabel: l10n.kizunarkJustNow,
      fallbackName: l10n.kizunarkFallbackDisplayName,
      fallbackHandle: l10n.kizunarkFallbackHandle,
      fallbackBadgeLabel: l10n.kizunarkInvestorBadge,
    );
    if (submitted && mounted) {
      AppNotice.show(context, message: l10n.kizunarkReplySuccessNotice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(discussionBoardControllerProvider);
    final controller = ref.read(discussionBoardControllerProvider.notifier);
    final isAuthenticated =
        ref.watch(isAuthenticatedProvider).asData?.value ?? false;
    final currentUser = ref.watch(currentAuthUserProvider).asData?.value;

    if (_composerController.text != state.composerText) {
      _composerController.value = TextEditingValue(
        text: state.composerText,
        selection: TextSelection.collapsed(offset: state.composerText.length),
      );
    }

    return ListView(
      key: const Key('discussion_tab_content'),
      padding: EdgeInsets.zero,
      children: <Widget>[
        KizunarkGradientHeader(
          title: l10n.mainTabKizunark,
          subtitle: l10n.kizunarkSubtitle,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: KizunarkNoticeBanner(label: l10n.kizunarkInvestorOnlyNotice),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
            enabled: !state.isPosting && isAuthenticated,
            onChanged: controller.updateComposerText,
            onPostTap: () => _submitPost(isAuthenticated: isAuthenticated),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: _buildFeedSection(
            l10n: l10n,
            state: state,
            controller: controller,
            isAuthenticated: isAuthenticated,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedSection({
    required AppLocalizations l10n,
    required DiscussionBoardState state,
    required DiscussionBoardController controller,
    required bool isAuthenticated,
  }) {
    if (state.isLoading && state.threads.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (state.threads.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColorTokens.fundexBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Text(
            l10n.kizunarkEmptyState,
            textAlign: TextAlign.center,
            style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle())
                .copyWith(
                  color: AppColorTokens.fundexTextSecondary,
                  height: 1.6,
                ),
          ),
        ),
      );
    }

    return Column(
      children: state.threads
          .map<Widget>((thread) {
            final expanded = state.expandedThreadIds.contains(thread.id);
            final replyController = _replyControllerFor(thread.id);
            final draft = state.replyDrafts[thread.id] ?? '';
            if (replyController.text != draft) {
              replyController.value = TextEditingValue(
                text: draft,
                selection: TextSelection.collapsed(offset: draft.length),
              );
            }

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

            final replySection = Column(
              children: <Widget>[
                ...replies,
                KizunarkReplyComposer(
                  controller: replyController,
                  placeholder: l10n.kizunarkReplyPlaceholder,
                  sendLabel: l10n.kizunarkReplySendAction,
                  enabled:
                      !state.replySubmittingThreadIds.contains(thread.id) &&
                      isAuthenticated,
                  onChanged: (String value) =>
                      controller.updateReplyDraft(thread.id, value),
                  onSendTap: () =>
                      _submitReply(thread.id, isAuthenticated: isAuthenticated),
                ),
              ],
            );

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
                fundReferenceChip: thread.fundReferenceLabel == null
                    ? null
                    : KizunarkFundReferenceChip(
                        label: thread.fundReferenceLabel!,
                        onTap: () => AppNotice.show(
                          context,
                          message: thread.fundReferenceLabel!,
                        ),
                      ),
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
