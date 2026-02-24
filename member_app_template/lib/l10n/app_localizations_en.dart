// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Access your member portfolio and hotel booking privileges.';

  @override
  String get loginAccountLabel => 'Phone number or email';

  @override
  String get loginModeTitle => 'Choose login method';

  @override
  String get loginCodeLabel => 'Verification code';

  @override
  String get loginSendCode => 'Send code';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get loginForgotPassword => 'Forgot password';

  @override
  String get loginFootnote =>
      'Designed for global members with Japan-ready UX and privacy standards.';

  @override
  String get loginErrorSendCodeFailed =>
      'Unable to send code. Please try again later.';

  @override
  String get loginErrorInvalidCode =>
      'Sign in failed. Please verify your code.';

  @override
  String get loginEmailAccountInvalid =>
      'Please enter a valid email address for email sign in.';

  @override
  String get loginMobileAccountInvalid =>
      'Please enter a valid phone number for phone sign in.';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle =>
      'Set up secure access for investment, stays, and member privileges.';

  @override
  String get registerModeTitle => 'Registration method';

  @override
  String get authModeEmail => 'Email';

  @override
  String get authModeMobile => 'Phone';

  @override
  String get registerAccountLabel => 'Phone number or email';

  @override
  String get registerEmailAccountLabel => 'Email address';

  @override
  String get registerMobileAccountLabel => 'Phone number';

  @override
  String get registerCodeLabel => 'Verification code';

  @override
  String get registerSendCode => 'Send code';

  @override
  String get registerSendCodeSuccess => 'Registration code sent.';

  @override
  String get registerContactLabel => 'Contact info';

  @override
  String get registerContactHelperEmail =>
      'For email registration, enter your mobile number.';

  @override
  String get registerContactHelperMobile =>
      'Optional: enter your email for account linking.';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

  @override
  String get registerInviteCodeLabel => 'Invite code (optional)';

  @override
  String get registerAcceptPolicy =>
      'I agree to the Terms of Service and Privacy Policy.';

  @override
  String get registerPolicyButton => 'View';

  @override
  String get registerPolicyTitle => 'Terms and Privacy';

  @override
  String get registerPolicyDescription =>
      'This screen demonstrates reusable policy presentation in a shared bottom sheet. Connect your legal policy content service here.';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get registerBackToLogin => 'Already have an account? Sign in';

  @override
  String get registerPasswordMismatchTitle => 'Passwords do not match';

  @override
  String get registerPasswordMismatchMessage =>
      'Please make sure both passwords are identical.';

  @override
  String get registerUiReadyTitle => 'Registration UI ready';

  @override
  String get registerUiReadyMessage =>
      'UI is complete and ready for API integration.';

  @override
  String get registerEmailMobileRequired =>
      'Mobile number is required for email registration.';

  @override
  String get registerEmailAccountInvalid =>
      'Please enter a valid email address for email registration.';

  @override
  String get registerMobileAccountInvalid =>
      'Please enter a valid phone number for phone registration.';

  @override
  String get registerSubmitFailed => 'Registration failed. Please try again.';

  @override
  String get registerSuccessTitle => 'Registration successful';

  @override
  String get registerSuccessMessage =>
      'Your account is created. Please sign in.';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordSubtitle =>
      'Restore account access with secure verification.';

  @override
  String get forgotPasswordAccountLabel => 'Phone number or email';

  @override
  String get forgotPasswordCodeLabel => 'Verification code';

  @override
  String get forgotPasswordSendCode => 'Send code';

  @override
  String get forgotPasswordSendCodeSuccess => 'Verification code sent.';

  @override
  String get forgotPasswordNewPasswordLabel => 'New password';

  @override
  String get forgotPasswordConfirmPasswordLabel => 'Confirm new password';

  @override
  String get forgotPasswordSubmit => 'Update password';

  @override
  String get forgotPasswordMismatchTitle => 'Passwords do not match';

  @override
  String get forgotPasswordMismatchMessage =>
      'Please verify your new password and confirmation.';

  @override
  String get forgotPasswordUiReadyTitle => 'Reset UI ready';

  @override
  String get forgotPasswordUiReadyMessage =>
      'UI is complete and ready for API integration.';

  @override
  String get forgotPasswordRecoverFailed =>
      'Unable to recover access. Please verify your code.';

  @override
  String get commonOk => 'OK';

  @override
  String get commonBackToLogin => 'Back to sign in';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeLogout => 'Sign out';

  @override
  String get uiErrorRequestFailed => 'Request failed. Please try again later.';

  @override
  String get uiErrorNetworkUnavailable =>
      'Network connection error. Please try again later.';

  @override
  String get uiErrorAuthExpired => 'Session expired. Please sign in again.';

  @override
  String get uiErrorForbidden =>
      'You do not have permission to access this resource.';

  @override
  String get uiErrorServerUnavailable =>
      'Service is temporarily unavailable. Please try again later.';

  @override
  String get languageFollowSystem => 'Follow system';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => 'Japanese';
}
