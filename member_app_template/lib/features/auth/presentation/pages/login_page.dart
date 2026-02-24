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
    final hotelTheme = Theme.of(context).extension<AppTravelHotelTheme>();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HotelEmailTextField(
            controller: _accountController,
            inputKey: const Key('login_account_input'),
            labelText: l10n.loginAccountLabel,
            hintText: l10n.loginAccountLabel,
            leadingIcon: Icons.person_outline_rounded,
            onChanged: controller.onAccountChanged,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: UiTokens.spacing12),
          HotelVerificationCodeField(
            key: const Key('login_code_field'),
            controller: _codeController,
            labelText: l10n.loginCodeLabel,
            hintText: l10n.loginCodeLabel,
            sendCodeLabel: l10n.loginSendCode,
            inputKey: const Key('login_code_input'),
            sendButtonKey: const Key('login_send_code_button'),
            isSendingCode: state.isSendingCode,
            onChanged: controller.onCodeChanged,
            onSendCode: state.canSendCode ? controller.sendCode : null,
            buttonWidth: 132,
          ),
          if (state.errorKey != null) ...<Widget>[
            const SizedBox(height: UiTokens.spacing8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: hotelTheme?.discountChipBackgroundColor.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(UiTokens.radius16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: UiTokens.spacing12,
                vertical: UiTokens.spacing12,
              ),
              child: Text(
                _resolveErrorMessage(context, state.errorKey!),
                style:
                    Theme.of(
                      context,
                    ).extension<AppAuthVisualTheme>()?.inlineErrorTextStyle ??
                    Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
          const SizedBox(height: UiTokens.spacing16),
          HotelPrimaryCtaButton(
            key: const Key('login_submit_button'),
            label: l10n.loginSubmit,
            isLoading: state.isLoggingIn,
            horizontalPadding: 0,
            onPressed: state.canLogin
                ? () async {
                    await controller.login();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
