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
  String get loginAccountLabel => 'Phone number or email';

  @override
  String get loginCodeLabel => 'Verification code';

  @override
  String get loginSendCode => 'Send code';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginErrorSendCodeFailed =>
      'Unable to send code. Please try again later.';

  @override
  String get loginErrorInvalidCode =>
      'Sign in failed. Please verify your code.';

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
