import 'package:core_network/core_network.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/api_paths.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/auth_providers.dart';
import '../support/code_send_cooldown.dart';
import 'auth_visual_scaffold.dart';

enum _RegisterChannel { mobile, email }

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  static final RegExp _mobileRegExp = RegExp(r'^[0-9+\-()\s]{6,20}$');

  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  late final TextEditingController _contactController;
  _RegisterChannel _registerChannel = _RegisterChannel.mobile;
  bool _acceptPolicy = false;
  bool _isSubmitting = false;
  bool _isSendingCode = false;
  late final CodeSendCooldown _sendCodeCooldown;

  @override
  void initState() {
    super.initState();
    _accountController = TextEditingController();
    _codeController = TextEditingController();
    _contactController = TextEditingController();
    _sendCodeCooldown = CodeSendCooldown(
      onChanged: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _sendCodeCooldown.dispose();
    _accountController.dispose();
    _codeController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  bool get _isEmailMode => _registerChannel == _RegisterChannel.email;

  bool _looksLikeEmail(String value) {
    final normalized = value.trim();
    return normalized.contains('@') && normalized.contains('.');
  }

  bool _looksLikeMobile(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.contains('@')) {
      return false;
    }
    return _mobileRegExp.hasMatch(normalized);
  }

  String get _accountValue => _accountController.text.trim();

  bool get _isAccountFormatValid {
    return _isEmailMode
        ? _looksLikeEmail(_accountValue)
        : _looksLikeMobile(_accountValue);
  }

  bool get _canSendCode {
    return _isAccountFormatValid &&
        !_isSendingCode &&
        !_sendCodeCooldown.isActive;
  }

  bool get _canSubmit {
    final hasRequiredFields =
        _isAccountFormatValid && _codeController.text.trim().isNotEmpty;
    final hasRequiredContact =
        !_isEmailMode || _contactController.text.trim().isNotEmpty;
    return hasRequiredFields &&
        hasRequiredContact &&
        _acceptPolicy &&
        !_isSubmitting;
  }

  String _invalidAccountMessage(BuildContext context) {
    final l10n = context.l10n;
    return _isEmailMode
        ? l10n.registerEmailAccountInvalid
        : l10n.registerMobileAccountInvalid;
  }

  void _switchChannel(_RegisterChannel channel) {
    if (_registerChannel == channel) {
      return;
    }
    setState(() {
      _registerChannel = channel;
      _codeController.clear();
    });
  }

  Future<bool> _ensureValidAccountInput() async {
    if (_isAccountFormatValid) {
      return true;
    }
    if (!mounted) {
      return false;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_invalidAccountMessage(context))));
    return false;
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

  String _sendCodeButtonLabel(String defaultLabel) {
    if (!_sendCodeCooldown.isActive) {
      return defaultLabel;
    }
    return '${_sendCodeCooldown.remainingSeconds}s';
  }

  Future<void> _sendCode() async {
    final l10n = context.l10n;
    if (!await _ensureValidAccountInput()) {
      return;
    }

    setState(() {
      _isSendingCode = true;
    });

    try {
      await ref
          .read(sendRegisterCodeUseCaseProvider)
          .call(account: _accountValue, intlCode: defaultIntlCode);

      if (!mounted) {
        return;
      }
      _sendCodeCooldown.start();
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
    if (!await _ensureValidAccountInput()) {
      return;
    }
    if (!mounted) {
      return;
    }

    if (_isEmailMode && _contactController.text.trim().isEmpty) {
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
            account: _accountValue,
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
            title: l10n.registerModeTitle,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _RegisterChannelChip(
                    key: const Key('register_mode_mobile_button'),
                    label: l10n.authModeMobile,
                    icon: Icons.phone_iphone_rounded,
                    selected: _registerChannel == _RegisterChannel.mobile,
                    onTap: () => _switchChannel(_RegisterChannel.mobile),
                  ),
                ),
                const SizedBox(width: UiTokens.spacing8),
                Expanded(
                  child: _RegisterChannelChip(
                    key: const Key('register_mode_email_button'),
                    label: l10n.authModeEmail,
                    icon: Icons.alternate_email_rounded,
                    selected: _registerChannel == _RegisterChannel.email,
                    onTap: () => _switchChannel(_RegisterChannel.email),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
          HotelSurfacePanelCard(
            title: l10n.registerAccountLabel,
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: travelTheme?.primaryButtonColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isEmailMode
                    ? Icons.alternate_email_rounded
                    : Icons.phone_iphone_rounded,
                size: 20,
                color: travelTheme?.primaryButtonColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (_isEmailMode
                        ? HotelEmailTextField(
                            controller: _accountController,
                            inputKey: const Key('register_account_input'),
                            labelText: l10n.registerEmailAccountLabel,
                            hintText: l10n.registerEmailAccountLabel,
                            leadingIcon: Icons.alternate_email_rounded,
                            onChanged: (_) => setState(() {}),
                          )
                        : HotelPhoneTextField(
                            controller: _accountController,
                            inputKey: const Key('register_account_input'),
                            labelText: l10n.registerMobileAccountLabel,
                            hintText: l10n.registerMobileAccountLabel,
                            leadingIcon: Icons.phone_iphone_rounded,
                            onChanged: (_) => setState(() {}),
                          ))
                    as Widget,
                const SizedBox(height: UiTokens.spacing12),
                HotelVerificationCodeField(
                  controller: _codeController,
                  labelText: l10n.registerCodeLabel,
                  hintText: l10n.registerCodeLabel,
                  sendCodeLabel: _sendCodeButtonLabel(l10n.registerSendCode),
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
            subtitle: _isEmailMode
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
                _isEmailMode ? Icons.phone_outlined : Icons.email_outlined,
                size: 20,
                color: travelTheme?.discountChipBackgroundColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (_isEmailMode
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

class _RegisterChannelChip extends StatelessWidget {
  const _RegisterChannelChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final travelTheme = theme.extension<AppTravelHotelTheme>()!;
    final radius = BorderRadius.circular(16);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected
            ? travelTheme.primaryButtonColor.withValues(alpha: 0.14)
            : theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: radius,
        border: Border.all(
          color: selected
              ? travelTheme.primaryButtonColor.withValues(alpha: 0.45)
              : travelTheme.cardBorderColor.withValues(alpha: 0.95),
          width: selected ? 1.2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 18,
                  color: selected
                      ? travelTheme.primaryButtonColor
                      : travelTheme.categoryIdleIconColor,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (theme.textTheme.labelLarge ?? const TextStyle())
                        .copyWith(
                          color: selected
                              ? travelTheme.primaryButtonColor
                              : theme.textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
