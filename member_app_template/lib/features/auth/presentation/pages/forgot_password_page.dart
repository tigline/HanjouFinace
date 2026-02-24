import 'package:core_network/core_network.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/auth_providers.dart';
import 'auth_visual_scaffold.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  bool _isSubmitting = false;
  bool _isSendingCode = false;

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

  bool get _canSendCode {
    return _accountController.text.trim().isNotEmpty && !_isSendingCode;
  }

  bool get _canSubmit {
    return _accountController.text.trim().isNotEmpty &&
        _codeController.text.trim().isNotEmpty &&
        !_isSubmitting;
  }

  String _resolveErrorMessage(Object error, String fallback) {
    if (error is StateError) {
      return error.message.toString();
    }
    if (error is NetworkFailure) {
      return error.message;
    }
    return fallback;
  }

  Future<void> _sendCode() async {
    setState(() {
      _isSendingCode = true;
    });

    try {
      await ref
          .read(sendLoginCodeUseCaseProvider)
          .call(account: _accountController.text.trim());

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.forgotPasswordSendCodeSuccess)),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _resolveErrorMessage(
              error,
              context.l10n.forgotPasswordRecoverFailed,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSendingCode = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    final l10n = context.l10n;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(loginWithCodeUseCaseProvider)
          .call(
            account: _accountController.text.trim(),
            code: _codeController.text.trim(),
          );
      ref.read(authSessionProvider.notifier).markAuthenticated();
      if (mounted) {
        context.go('/home');
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      await AppDialogs.showAdaptiveAlert<void>(
        context: context,
        title: l10n.forgotPasswordTitle,
        message: _resolveErrorMessage(error, l10n.forgotPasswordRecoverFailed),
        actions: <AppDialogAction<void>>[
          AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
        ],
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthVisualScaffold(
      pageKey: const Key('forgot_password_page'),
      title: l10n.forgotPasswordTitle,
      subtitle: l10n.forgotPasswordSubtitle,
      footer: Center(
        child: TextButton(
          key: const Key('forgot_back_login_button'),
          onPressed: () => context.go('/login'),
          child: Text(l10n.commonBackToLogin),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HotelEmailTextField(
            controller: _accountController,
            inputKey: const Key('forgot_account_input'),
            labelText: l10n.forgotPasswordAccountLabel,
            hintText: l10n.forgotPasswordAccountLabel,
            leadingIcon: Icons.person_outline_rounded,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: UiTokens.spacing12),
          HotelVerificationCodeField(
            controller: _codeController,
            labelText: l10n.forgotPasswordCodeLabel,
            hintText: l10n.forgotPasswordCodeLabel,
            sendCodeLabel: l10n.forgotPasswordSendCode,
            inputKey: const Key('forgot_code_input'),
            sendButtonKey: const Key('forgot_send_code_button'),
            isSendingCode: _isSendingCode,
            onChanged: (_) => setState(() {}),
            onSendCode: _canSendCode ? _sendCode : null,
            buttonWidth: 136,
          ),
          const SizedBox(height: UiTokens.spacing16),
          HotelPrimaryCtaButton(
            key: const Key('forgot_submit_button'),
            label: l10n.forgotPasswordSubmit,
            isLoading: _isSubmitting,
            horizontalPadding: 0,
            onPressed: _canSubmit ? _submit : null,
          ),
        ],
      ),
    );
  }
}
