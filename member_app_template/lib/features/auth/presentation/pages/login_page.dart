import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import 'auth_visual_scaffold.dart';
import '../providers/auth_providers.dart';
import '../state/auth_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController _accountController;
  late final TextEditingController _codeController;

  String _resolveErrorMessage(BuildContext context, AuthErrorKey errorKey) {
    final l10n = context.l10n;
    return switch (errorKey) {
      AuthErrorKey.sendCodeFailed => l10n.loginErrorSendCodeFailed,
      AuthErrorKey.loginFailed => l10n.loginErrorInvalidCode,
    };
  }

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.session == null && next.session != null && mounted) {
        ref.read(authSessionProvider.notifier).markAuthenticated();
        context.go('/home');
      }
    });

    return AuthVisualScaffold(
      pageKey: const Key('login_page'),
      title: l10n.loginTitle,
      subtitle: l10n.loginSubtitle,
      footer: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                key: const Key('to_register_button'),
                onPressed: () => context.push('/register'),
                child: Text(l10n.loginCreateAccount),
              ),
              const SizedBox(width: UiTokens.spacing8),
              TextButton(
                key: const Key('to_forgot_password_button'),
                onPressed: () => context.push('/forgot-password'),
                child: Text(l10n.loginForgotPassword),
              ),
            ],
          ),
          Text(
            l10n.loginFootnote,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          TextField(
            key: const Key('login_account_input'),
            controller: _accountController,
            keyboardType: TextInputType.emailAddress,
            onChanged: controller.onAccountChanged,
            decoration: InputDecoration(
              labelText: l10n.loginAccountLabel,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  key: const Key('login_code_input'),
                  controller: _codeController,
                  onChanged: controller.onCodeChanged,
                  decoration: InputDecoration(
                    labelText: l10n.loginCodeLabel,
                    prefixIcon: const Icon(Icons.sms_outlined),
                  ),
                ),
              ),
              const SizedBox(width: UiTokens.spacing12),
              SizedBox(
                width: 132,
                child: OutlinedButton(
                  key: const Key('login_send_code_button'),
                  onPressed: state.canSendCode ? controller.sendCode : null,
                  child: state.isSendingCode
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.loginSendCode),
                ),
              ),
            ],
          ),
          const SizedBox(height: UiTokens.spacing16),
          FilledButton(
            key: const Key('login_submit_button'),
            onPressed: state.canLogin
                ? () async {
                    await controller.login();
                  }
                : null,
            child: state.isLoggingIn
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.loginSubmit),
          ),
          if (state.errorKey != null) ...<Widget>[
            const SizedBox(height: UiTokens.spacing12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _resolveErrorMessage(context, state.errorKey!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
