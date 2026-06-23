import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/x_account_models.dart';
import '../providers/x_account_providers.dart';
import '../state/x_account_state.dart';
import '../support/x_oauth_callback.dart';

class XAccountSettingsPage extends ConsumerStatefulWidget {
  const XAccountSettingsPage({super.key});

  @override
  ConsumerState<XAccountSettingsPage> createState() =>
      _XAccountSettingsPageState();
}

class _XAccountSettingsPageState extends ConsumerState<XAccountSettingsPage> {
  bool _hasScheduledInitialCallback = false;

  Future<void> _startBinding() async {
    final controller = ref.read(xAccountControllerProvider.notifier);
    final attempt = await controller.startBinding();
    if (!mounted || attempt == null) {
      return;
    }
    final launched = await launchUrl(
      attempt.authorizationUri,
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || launched) {
      return;
    }
    AppNotice.show(
      context,
      message: context.l10n.xAccountAuthorizationOpenFailed,
    );
  }

  Future<void> _handleCallback(XOAuthCallback callback) async {
    final connected = await ref
        .read(xAccountControllerProvider.notifier)
        .handleCallback(callback);
    if (!mounted) {
      return;
    }
    ref.read(xOAuthCallbackProvider.notifier).state = null;
    AppNotice.show(
      context,
      message: connected
          ? context.l10n.xAccountConnectedNotice
          : callback.wasCancelled
          ? context.l10n.xAccountAuthorizationCancelled
          : context.l10n.xAccountConnectionFailed,
    );
  }

  Future<void> _confirmDisconnect() async {
    final l10n = context.l10n;
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.xAccountDisconnectConfirmTitle,
      message: l10n.xAccountDisconnectConfirmBody,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(label: l10n.profileGuardCancel, value: false),
        AppDialogAction<bool>(
          label: l10n.xAccountDisconnectAction,
          value: true,
          isDestructive: true,
        ),
      ],
    );
    if (confirmed != true || !mounted) {
      return;
    }
    final disconnected = await ref
        .read(xAccountControllerProvider.notifier)
        .disconnect();
    if (!mounted) {
      return;
    }
    AppNotice.show(
      context,
      message: disconnected
          ? context.l10n.xAccountDisconnectedNotice
          : context.l10n.xAccountConnectionFailed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(xAccountControllerProvider);
    ref.listen<XOAuthCallback?>(xOAuthCallbackProvider, (previous, next) {
      if (next != null && next != previous) {
        _hasScheduledInitialCallback = true;
        unawaited(_handleCallback(next));
      }
    });
    final initialCallback = ref.read(xOAuthCallbackProvider);
    if (initialCallback != null && !_hasScheduledInitialCallback) {
      _hasScheduledInitialCallback = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_handleCallback(initialCallback));
        }
      });
    }
    ref.listen<XAccountState>(xAccountControllerProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        AppNotice.show(context, message: context.l10n.xAccountConnectionFailed);
      }
    });

    final colors = Theme.of(context).appColors;
    return Scaffold(
      appBar: AppNavigationBar(
        title: context.l10n.xAccountSettingsTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(xAccountControllerProvider.notifier).load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                children: <Widget>[
                  _XAccountSummary(connection: state.connection),
                  const SizedBox(height: 24),
                  if (state.connection.isConnected)
                    OutlinedButton.icon(
                      onPressed: state.isBusy ? null : _confirmDisconnect,
                      icon: state.isDisconnecting
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.link_off_rounded),
                      label: Text(context.l10n.xAccountDisconnectAction),
                    )
                  else
                    FilledButton.icon(
                      onPressed: state.isBusy ? null : _startBinding,
                      icon: state.isStartingBinding || state.isCheckingBinding
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.link_rounded),
                      label: Text(
                        state.connection.status == XAccountStatus.expired
                            ? context.l10n.xAccountReconnectAction
                            : context.l10n.xAccountConnectAction,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.xAccountSecurityDescription,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _XAccountSummary extends StatelessWidget {
  const _XAccountSummary({required this.connection});

  final XAccountConnection connection;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final connected = connection.isConnected;
    final statusText = switch (connection.status) {
      XAccountStatus.disconnected => context.l10n.xAccountStatusDisconnected,
      XAccountStatus.connecting => context.l10n.xAccountStatusConnecting,
      XAccountStatus.connected => context.l10n.xAccountStatusConnected,
      XAccountStatus.expired => context.l10n.xAccountStatusExpired,
    };
    final username = connection.username?.trim() ?? '';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            if (connected)
              AppUserAvatar(avatarUrl: connection.avatarUrl, size: 48)
            else
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  'X',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.surface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    connection.displayName?.trim().isNotEmpty == true
                        ? connection.displayName!.trim()
                        : context.l10n.xAccountServiceName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (username.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      '@$username',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: connected ? colors.success : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
