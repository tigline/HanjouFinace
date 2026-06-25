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

class _XAccountSettingsPageState extends ConsumerState<XAccountSettingsPage>
    with WidgetsBindingObserver {
  bool _authorizationBrowserOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !_authorizationBrowserOpened) {
      return;
    }
    _authorizationBrowserOpened = false;
    unawaited(_confirmAuthorization());
  }

  Future<void> _startBinding() async {
    final controller = ref.read(xAccountControllerProvider.notifier);
    final authorization = await controller.startOAuth();
    if (!mounted || authorization == null) {
      return;
    }
    _authorizationBrowserOpened = true;
    final launched = await launchUrl(
      authorization.authorizationUri,
      mode: LaunchMode.externalApplication,
    ).catchError((Object _) => false);
    if (!mounted) {
      return;
    }
    if (launched) {
      return;
    }
    _authorizationBrowserOpened = false;
    controller.cancelAuthorizationLaunch();
    AppNotice.show(
      context,
      message: context.l10n.xAccountAuthorizationOpenFailed,
    );
  }

  Future<void> _confirmAuthorization() async {
    final connected = await ref
        .read(xAccountControllerProvider.notifier)
        .confirmAuthorization();
    if (!mounted) {
      return;
    }
    AppNotice.show(
      context,
      message: connected
          ? context.l10n.xAccountConnectedNotice
          : context.l10n.xAccountConnectionFailed,
    );
  }

  Future<void> _confirmDisconnect() async {
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: context.l10n.xAccountDisconnectConfirmTitle,
      message: context.l10n.xAccountDisconnectConfirmBody,
      barrierDismissible: false,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(label: context.l10n.commonCancel, value: false),
        AppDialogAction<bool>(
          label: context.l10n.xAccountDisconnectAction,
          value: true,
          isDestructive: true,
        ),
      ],
    );
    if (!mounted || confirmed != true) {
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
          : context.l10n.xAccountDisconnectFailed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(xAccountControllerProvider);
    ref.listen<XAccountState>(xAccountControllerProvider, (previous, next) {
      if (previous?.isDisconnecting == true) {
        return;
      }
      if (next.error != null && next.error != previous?.error) {
        AppNotice.show(context, message: context.l10n.xAccountConnectionFailed);
      }
    });
    ref.listen<int>(xOAuthCallbackSignalProvider, (previous, next) {
      if (previous == null || previous == next) {
        return;
      }
      _authorizationBrowserOpened = false;
      unawaited(
        ref
            .read(xAccountControllerProvider.notifier)
            .confirmAuthorization(requireAwaitingAuthorization: false),
      );
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
                  _XAccountSummary(
                    connection: state.connection,
                    isDisconnecting: state.isDisconnecting,
                    onDisconnect: state.connection.isConnected && !state.isBusy
                        ? _confirmDisconnect
                        : null,
                  ),
                  const SizedBox(height: 24),
                  if (!state.connection.isConnected)
                    FilledButton.icon(
                      onPressed: state.isBusy ? null : _startBinding,
                      icon: state.isStartingOAuth || state.isCheckingConnection
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.link_rounded),
                      label: Text(context.l10n.xAccountConnectAction),
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
  const _XAccountSummary({
    required this.connection,
    required this.isDisconnecting,
    required this.onDisconnect,
  });

  final XAccountConnection connection;
  final bool isDisconnecting;
  final VoidCallback? onDisconnect;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final connected = connection.isConnected;
    final statusText = switch (connection.status) {
      XAccountStatus.disconnected => context.l10n.xAccountStatusDisconnected,
      XAccountStatus.connecting => context.l10n.xAccountStatusConnecting,
      XAccountStatus.connected => context.l10n.xAccountStatusConnected,
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
            if (connected) ...<Widget>[
              const SizedBox(width: 12),
              TextButton(
                onPressed: onDisconnect,
                child: isDisconnecting
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n.xAccountDisconnectAction),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
