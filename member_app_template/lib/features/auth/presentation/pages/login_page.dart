import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import 'auth_visual_scaffold.dart';
import '../controllers/auth_controller.dart';
import '../providers/auth_providers.dart';
import '../state/auth_state.dart';

enum _LoginChannel { mobile, email }

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  static final RegExp _mobileRegExp = RegExp(r'^[0-9+\-()\s]{6,20}$');

  late final TextEditingController _accountController;
  late final TextEditingController _codeController;
  _LoginChannel _loginChannel = _LoginChannel.mobile;
  String? _localValidationError;

  bool get _isEmailMode => _loginChannel == _LoginChannel.email;

  String _resolveErrorMessage(BuildContext context, AuthErrorKey errorKey) {
    final l10n = context.l10n;
    return switch (errorKey) {
      AuthErrorKey.sendCodeFailed => l10n.loginErrorSendCodeFailed,
      AuthErrorKey.loginFailed => l10n.loginErrorInvalidCode,
    };
  }

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

  bool get _isAccountFormatValid {
    final value = _accountController.text.trim();
    if (value.isEmpty) {
      return false;
    }
    return _isEmailMode ? _looksLikeEmail(value) : _looksLikeMobile(value);
  }

  String _invalidAccountMessage(BuildContext context) {
    final l10n = context.l10n;
    return _isEmailMode
        ? l10n.loginEmailAccountInvalid
        : l10n.loginMobileAccountInvalid;
  }

  bool _ensureValidAccountForSelectedMode(BuildContext context) {
    if (_isAccountFormatValid) {
      if (_localValidationError != null) {
        setState(() {
          _localValidationError = null;
        });
      }
      return true;
    }

    setState(() {
      _localValidationError = _invalidAccountMessage(context);
    });
    return false;
  }

  void _switchLoginChannel(_LoginChannel channel, AuthController controller) {
    if (_loginChannel == channel) {
      return;
    }

    setState(() {
      _loginChannel = channel;
      _localValidationError = null;
      _accountController.clear();
      _codeController.clear();
    });
    controller.onAccountChanged('');
    controller.onCodeChanged('');
  }

  void _onAccountChanged(String value, AuthController controller) {
    if (_localValidationError != null) {
      setState(() {
        _localValidationError = null;
      });
    } else {
      setState(() {});
    }
    controller.onAccountChanged(value);
  }

  void _onCodeChanged(String value, AuthController controller) {
    if (_localValidationError != null) {
      setState(() {
        _localValidationError = null;
      });
    }
    controller.onCodeChanged(value);
  }

  Future<void> _handleSendCode(AuthController controller) async {
    if (!_ensureValidAccountForSelectedMode(context)) {
      return;
    }
    await controller.sendCode();
  }

  Future<void> _handleLogin(AuthController controller) async {
    if (!_ensureValidAccountForSelectedMode(context)) {
      return;
    }
    await controller.login();
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
    final effectiveErrorMessage =
        _localValidationError ??
        (state.errorKey != null
            ? _resolveErrorMessage(context, state.errorKey!)
            : null);

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
          HotelSurfacePanelCard(
            title: l10n.loginModeTitle,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _LoginChannelChip(
                    key: const Key('login_mode_mobile_button'),
                    label: l10n.authModeMobile,
                    icon: Icons.phone_iphone_rounded,
                    selected: _loginChannel == _LoginChannel.mobile,
                    onTap: () =>
                        _switchLoginChannel(_LoginChannel.mobile, controller),
                  ),
                ),
                const SizedBox(width: UiTokens.spacing8),
                Expanded(
                  child: _LoginChannelChip(
                    key: const Key('login_mode_email_button'),
                    label: l10n.authModeEmail,
                    icon: Icons.alternate_email_rounded,
                    selected: _loginChannel == _LoginChannel.email,
                    onTap: () =>
                        _switchLoginChannel(_LoginChannel.email, controller),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
          HotelSurfacePanelCard(
            title: _isEmailMode
                ? l10n.registerEmailAccountLabel
                : l10n.registerMobileAccountLabel,
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: hotelTheme?.primaryButtonColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isEmailMode
                    ? Icons.alternate_email_rounded
                    : Icons.phone_iphone_rounded,
                size: 20,
                color: hotelTheme?.primaryButtonColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (_isEmailMode
                        ? HotelEmailTextField(
                            controller: _accountController,
                            inputKey: const Key('login_account_input'),
                            labelText: l10n.registerEmailAccountLabel,
                            hintText: l10n.registerEmailAccountLabel,
                            leadingIcon: Icons.alternate_email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onChanged: (String value) =>
                                _onAccountChanged(value, controller),
                          )
                        : HotelPhoneTextField(
                            controller: _accountController,
                            inputKey: const Key('login_account_input'),
                            labelText: l10n.registerMobileAccountLabel,
                            hintText: l10n.registerMobileAccountLabel,
                            leadingIcon: Icons.phone_iphone_rounded,
                            textInputAction: TextInputAction.next,
                            onChanged: (String value) =>
                                _onAccountChanged(value, controller),
                          ))
                    as Widget,
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
                  onChanged: (String value) =>
                      _onCodeChanged(value, controller),
                  onSendCode: state.canSendCode
                      ? () => _handleSendCode(controller)
                      : null,
                  buttonWidth: 132,
                ),
              ],
            ),
          ),
          if (effectiveErrorMessage != null) ...<Widget>[
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
                effectiveErrorMessage,
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
            onPressed: state.canLogin ? () => _handleLogin(controller) : null,
          ),
        ],
      ),
    );
  }
}

class _LoginChannelChip extends StatelessWidget {
  const _LoginChannelChip({
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
