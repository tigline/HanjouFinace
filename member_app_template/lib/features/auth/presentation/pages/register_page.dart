import 'package:core_network/core_network.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/api_paths.dart';
import '../../../../app/localization/app_localizations_ext.dart';
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
    final travelTheme = Theme.of(context).extension<AppTravelHotelTheme>();

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
          HotelSurfacePanelCard(
            title: l10n.registerAccountLabel,
            subtitle: l10n.registerSubtitle,
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: travelTheme?.primaryButtonColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.badge_outlined,
                size: 20,
                color: travelTheme?.primaryButtonColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HotelEmailTextField(
                  controller: _accountController,
                  inputKey: const Key('register_account_input'),
                  labelText: l10n.registerAccountLabel,
                  hintText: l10n.registerAccountLabel,
                  leadingIcon: Icons.person_outline_rounded,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: UiTokens.spacing12),
                HotelVerificationCodeField(
                  controller: _codeController,
                  labelText: l10n.registerCodeLabel,
                  hintText: l10n.registerCodeLabel,
                  sendCodeLabel: l10n.registerSendCode,
                  inputKey: const Key('register_code_input'),
                  sendButtonKey: const Key('register_send_code_button'),
                  isSendingCode: _isSendingCode,
                  onChanged: (_) => setState(() {}),
                  onSendCode: _canSendCode ? _sendCode : null,
                  buttonWidth: 132,
                ),
              ],
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
          HotelSurfacePanelCard(
            title: l10n.registerContactLabel,
            subtitle: _isEmailAccount
                ? l10n.registerContactHelperEmail
                : l10n.registerContactHelperMobile,
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: travelTheme?.discountChipBackgroundColor.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.verified_user_outlined,
                size: 20,
                color: travelTheme?.discountChipBackgroundColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (_isEmailAccount
                        ? HotelPhoneTextField(
                            controller: _contactController,
                            inputKey: const Key('register_contact_input'),
                            labelText: l10n.registerContactLabel,
                            hintText: l10n.registerContactHelperEmail,
                            onChanged: (_) => setState(() {}),
                          )
                        : HotelEmailTextField(
                            controller: _contactController,
                            inputKey: const Key('register_contact_input'),
                            labelText: l10n.registerContactLabel,
                            hintText: l10n.registerContactHelperMobile,
                            leadingIcon: Icons.contact_mail_outlined,
                            onChanged: (_) => setState(() {}),
                          ))
                    as Widget,
                const SizedBox(height: UiTokens.spacing8),
                Container(
                  decoration: BoxDecoration(
                    color: travelTheme?.primaryButtonColor.withValues(
                      alpha: 0.06,
                    ),
                    borderRadius: BorderRadius.circular(UiTokens.radius16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiTokens.spacing12,
                    vertical: UiTokens.spacing12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Switch.adaptive(
                        value: _acceptPolicy,
                        activeTrackColor: travelTheme?.primaryButtonColor
                            .withValues(alpha: 0.35),
                        activeThumbColor: travelTheme?.primaryButtonColor,
                        onChanged: (bool value) {
                          setState(() {
                            _acceptPolicy = value;
                          });
                        },
                      ),
                      const SizedBox(width: UiTokens.spacing8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => setState(
                                () => _acceptPolicy = !_acceptPolicy,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  l10n.registerAcceptPolicy,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                            const SizedBox(height: UiTokens.spacing4),
                            TextButton(
                              key: const Key('register_policy_button'),
                              onPressed: _showPolicySheet,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              child: Text(l10n.registerPolicyButton),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: UiTokens.spacing16),
          HotelPrimaryCtaButton(
            key: const Key('register_submit_button'),
            label: l10n.registerSubmit,
            isLoading: _isSubmitting,
            horizontalPadding: 0,
            onPressed: _canSubmit ? _submit : null,
          ),
        ],
      ),
    );
  }
}
