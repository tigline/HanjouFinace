import 'package:core_network/core_network.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/config/api_paths.dart';
import '../providers/auth_providers.dart';
import 'auth_visual_scaffold.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  late final TextEditingController _contactController;
  bool _acceptPolicy = false;
  bool _isSubmitting = false;
  bool _isSendingCode = false;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController();
    _codeController = TextEditingController();
    _contactController = TextEditingController();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _codeController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  bool get _isEmailAccount => _accountController.text.contains('@');

  bool get _canSendCode {
    return _accountController.text.trim().isNotEmpty && !_isSendingCode;
  }

  bool get _canSubmit {
    final hasRequiredFields =
        _accountController.text.trim().isNotEmpty &&
        _codeController.text.trim().isNotEmpty;
    final hasEmailContact =
        !_isEmailAccount || _contactController.text.trim().isNotEmpty;
    return hasRequiredFields &&
        hasEmailContact &&
        _acceptPolicy &&
        !_isSubmitting;
  }

  Future<void> _showPolicySheet() {
    final l10n = context.l10n;
    return AppBottomSheet.showAdaptive<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.registerPolicyTitle,
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: UiTokens.spacing12),
            Text(
              l10n.registerPolicyDescription,
              style: Theme.of(sheetContext).textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
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
    final l10n = context.l10n;
    setState(() {
      _isSendingCode = true;
    });

    try {
      await ref
          .read(sendRegisterCodeUseCaseProvider)
          .call(
            account: _accountController.text.trim(),
            intlCode: defaultIntlCode,
          );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registerSendCodeSuccess)));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_resolveErrorMessage(error, l10n.registerSubmitFailed)),
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
    if (_isEmailAccount && _contactController.text.trim().isEmpty) {
      await AppDialogs.showAdaptiveAlert<void>(
        context: context,
        title: l10n.registerPolicyTitle,
        message: l10n.registerEmailMobileRequired,
        actions: <AppDialogAction<void>>[
          AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
        ],
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(registerAccountUseCaseProvider)
          .call(
            account: _accountController.text.trim(),
            code: _codeController.text.trim(),
            intlCode: defaultIntlCode,
            contact: _contactController.text.trim(),
          );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
      await AppDialogs.showAdaptiveAlert<void>(
        context: context,
        title: l10n.registerPolicyTitle,
        message: _resolveErrorMessage(error, l10n.registerSubmitFailed),
        actions: <AppDialogAction<void>>[
          AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
        ],
      );
      return;
    }

    if (!mounted) {
      return;
    }

    await AppDialogs.showAdaptiveAlert<void>(
      context: context,
      title: l10n.registerSuccessTitle,
      message: l10n.registerSuccessMessage,
      actions: <AppDialogAction<void>>[
        AppDialogAction<void>(
          label: l10n.commonBackToLogin,
          isDefaultAction: true,
        ),
      ],
    );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthVisualScaffold(
      pageKey: const Key('register_page'),
      title: l10n.registerTitle,
      subtitle: l10n.registerSubtitle,
      footer: Center(
        child: TextButton(
          key: const Key('register_back_login_button'),
          onPressed: () => context.go('/login'),
          child: Text(l10n.registerBackToLogin),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            key: const Key('register_account_input'),
            controller: _accountController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: l10n.registerAccountLabel,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  key: const Key('register_code_input'),
                  controller: _codeController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l10n.registerCodeLabel,
                    prefixIcon: const Icon(Icons.sms_outlined),
                  ),
                ),
              ),
              const SizedBox(width: UiTokens.spacing12),
              SizedBox(
                width: 132,
                child: OutlinedButton(
                  key: const Key('register_send_code_button'),
                  onPressed: _canSendCode ? _sendCode : null,
                  child: _isSendingCode
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.registerSendCode),
                ),
              ),
            ],
          ),
          const SizedBox(height: UiTokens.spacing12),
          TextField(
            key: const Key('register_contact_input'),
            controller: _contactController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: l10n.registerContactLabel,
              helperText: _isEmailAccount
                  ? l10n.registerContactHelperEmail
                  : l10n.registerContactHelperMobile,
              prefixIcon: const Icon(Icons.contact_mail_outlined),
            ),
          ),
          const SizedBox(height: UiTokens.spacing8),
          Row(
            children: <Widget>[
              Checkbox(
                value: _acceptPolicy,
                onChanged: (bool? value) {
                  setState(() {
                    _acceptPolicy = value ?? false;
                  });
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _acceptPolicy = !_acceptPolicy),
                  child: Text(
                    l10n.registerAcceptPolicy,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              TextButton(
                key: const Key('register_policy_button'),
                onPressed: _showPolicySheet,
                child: Text(l10n.registerPolicyButton),
              ),
            ],
          ),
          const SizedBox(height: UiTokens.spacing8),
          FilledButton(
            key: const Key('register_submit_button'),
            onPressed: _canSubmit ? _submit : null,
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.registerSubmit),
          ),
        ],
      ),
    );
  }
}
