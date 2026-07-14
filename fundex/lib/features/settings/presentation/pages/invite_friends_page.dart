import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/environment_provider.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/invite_friends_providers.dart';
import '../support/invite_friends_support.dart';
import '../widgets/invite_friends_widgets.dart';

class InviteFriendsPage extends ConsumerWidget {
  const InviteFriendsPage({super.key});

  Future<void> _copy(
    BuildContext context, {
    required String value,
    required String successMessage,
  }) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) {
      AppNotice.show(context, message: successMessage);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = Theme.of(context).appColors;
    final inviteInfoAsync = ref.watch(inviteFriendsInfoProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.inviteFriendsTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: inviteInfoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) {
          final failureKind = classifyInviteFriendsLoadError(error);
          if (failureKind == InviteFriendsLoadFailureKind.forbidden) {
            return InviteFriendsErrorView(
              icon: Icons.lock_outline_rounded,
              title: l10n.inviteFriendsForbiddenTitle,
              description: l10n.inviteFriendsForbiddenDescription,
              actionIcon: Icons.arrow_back_rounded,
              actionLabel: l10n.inviteFriendsReturnToSettings,
              onAction: () => context.pop(),
            );
          }

          final isNetworkFailure =
              failureKind == InviteFriendsLoadFailureKind.network;
          return RefreshIndicator(
            onRefresh: () => ref.refresh(inviteFriendsInfoProvider.future),
            child: InviteFriendsErrorView(
              icon: isNetworkFailure
                  ? Icons.wifi_off_rounded
                  : Icons.error_outline_rounded,
              title: isNetworkFailure
                  ? l10n.inviteFriendsLoadErrorTitle
                  : l10n.inviteFriendsRequestErrorTitle,
              description: isNetworkFailure
                  ? l10n.inviteFriendsLoadErrorDescription
                  : l10n.inviteFriendsRequestErrorDescription,
              actionIcon: Icons.refresh_rounded,
              actionLabel: l10n.commonRetry,
              onAction: () => ref.invalidate(inviteFriendsInfoProvider),
            ),
          );
        },
        data: (info) {
          final inviteUri = buildInviteRegistrationUri(
            apiBaseUrl: ref.watch(oaApiBaseUrlProvider),
            inviteCode: info.inviteCode,
          );
          final inviteLink = inviteUri.toString();
          return RefreshIndicator(
            onRefresh: () => ref.refresh(inviteFriendsInfoProvider.future),
            child: InviteFriendsContent(
              inviteCode: info.inviteCode,
              inviteLink: inviteLink,
              invitedCount: info.invitedFriendCount,
              heroTitle: l10n.inviteFriendsHeroTitle,
              heroDescription: l10n.inviteFriendsHeroDescription,
              countLabel: l10n.inviteFriendsCountLabel,
              codeLabel: l10n.inviteFriendsCodeLabel,
              codeDescription: l10n.inviteFriendsCodeDescription,
              linkLabel: l10n.inviteFriendsLinkLabel,
              linkDescription: l10n.inviteFriendsLinkDescription,
              copyLabel: l10n.commonCopy,
              shareLabel: l10n.inviteFriendsShareAction,
              shareHint: l10n.inviteFriendsShareHint,
              onCopyCode: () => _copy(
                context,
                value: info.inviteCode,
                successMessage: l10n.inviteFriendsCodeCopied,
              ),
              onCopyLink: () => _copy(
                context,
                value: inviteLink,
                successMessage: l10n.inviteFriendsLinkCopied,
              ),
              onShare: () => AppShare.shareText(
                context,
                text: l10n.inviteFriendsShareMessage(
                  info.inviteCode,
                  inviteLink,
                ),
                title: l10n.inviteFriendsShareTitle,
                subject: l10n.inviteFriendsShareTitle,
                unavailableNotice: l10n.inviteFriendsShareUnavailable,
              ),
            ),
          );
        },
      ),
    );
  }
}
