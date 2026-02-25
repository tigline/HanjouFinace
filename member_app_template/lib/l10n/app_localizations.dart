import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access your member portfolio and hotel booking privileges.'**
  String get loginSubtitle;

  /// No description provided for @loginAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email'**
  String get loginAccountLabel;

  /// No description provided for @loginModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose login method'**
  String get loginModeTitle;

  /// No description provided for @loginCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get loginCodeLabel;

  /// No description provided for @loginSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get loginSendCode;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccount;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get loginForgotPassword;

  /// No description provided for @loginFootnote.
  ///
  /// In en, this message translates to:
  /// **'Designed for global members with Japan-ready UX and privacy standards.'**
  String get loginFootnote;

  /// No description provided for @loginErrorSendCodeFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to send code. Please try again later.'**
  String get loginErrorSendCodeFailed;

  /// No description provided for @loginErrorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed. Please verify your code.'**
  String get loginErrorInvalidCode;

  /// No description provided for @loginEmailAccountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address for email sign in.'**
  String get loginEmailAccountInvalid;

  /// No description provided for @loginMobileAccountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number for phone sign in.'**
  String get loginMobileAccountInvalid;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up secure access for investment, stays, and member privileges.'**
  String get registerSubtitle;

  /// No description provided for @registerModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration method'**
  String get registerModeTitle;

  /// No description provided for @authModeEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authModeEmail;

  /// No description provided for @authModeMobile.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get authModeMobile;

  /// No description provided for @authEntryHeadline.
  ///
  /// In en, this message translates to:
  /// **'One sign-in for investment and hotel member services'**
  String get authEntryHeadline;

  /// No description provided for @authEntryDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in with phone or email to manage investments, bookings, and member privileges.'**
  String get authEntryDescription;

  /// No description provided for @authEntryPhoneLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in with phone'**
  String get authEntryPhoneLogin;

  /// No description provided for @authEntryEmailLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get authEntryEmailLogin;

  /// No description provided for @authEntryNonMemberRegisterNow.
  ///
  /// In en, this message translates to:
  /// **'Not a member? Register now'**
  String get authEntryNonMemberRegisterNow;

  /// No description provided for @authRegisterEntryHeadline.
  ///
  /// In en, this message translates to:
  /// **'Choose registration method'**
  String get authRegisterEntryHeadline;

  /// No description provided for @authRegisterEntryDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your account with phone or email and manage all member services in one place.'**
  String get authRegisterEntryDescription;

  /// No description provided for @authEntryPhoneRegister.
  ///
  /// In en, this message translates to:
  /// **'Register with phone'**
  String get authEntryPhoneRegister;

  /// No description provided for @authEntryEmailRegister.
  ///
  /// In en, this message translates to:
  /// **'Register with email'**
  String get authEntryEmailRegister;

  /// No description provided for @authBackToLoginEntry.
  ///
  /// In en, this message translates to:
  /// **'Back to sign-in options'**
  String get authBackToLoginEntry;

  /// No description provided for @authBackToRegisterEntry.
  ///
  /// In en, this message translates to:
  /// **'Back to registration options'**
  String get authBackToRegisterEntry;

  /// No description provided for @authMethodFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete secure verification with a one-time code.'**
  String get authMethodFormSubtitle;

  /// No description provided for @authMobileLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone sign in'**
  String get authMobileLoginTitle;

  /// No description provided for @authEmailLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Email sign in'**
  String get authEmailLoginTitle;

  /// No description provided for @authMobileRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone registration'**
  String get authMobileRegisterTitle;

  /// No description provided for @authEmailRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Email registration'**
  String get authEmailRegisterTitle;

  /// No description provided for @registerAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email'**
  String get registerAccountLabel;

  /// No description provided for @registerEmailAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get registerEmailAccountLabel;

  /// No description provided for @registerMobileAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get registerMobileAccountLabel;

  /// No description provided for @registerCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get registerCodeLabel;

  /// No description provided for @registerSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get registerSendCode;

  /// No description provided for @registerSendCodeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration code sent.'**
  String get registerSendCodeSuccess;

  /// No description provided for @registerContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get registerContactLabel;

  /// No description provided for @registerContactHelperEmail.
  ///
  /// In en, this message translates to:
  /// **'For email registration, enter your mobile number.'**
  String get registerContactHelperEmail;

  /// No description provided for @registerContactHelperMobile.
  ///
  /// In en, this message translates to:
  /// **'Optional: enter your email for account linking.'**
  String get registerContactHelperMobile;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code (optional)'**
  String get registerInviteCodeLabel;

  /// No description provided for @registerAcceptPolicy.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service and Privacy Policy.'**
  String get registerAcceptPolicy;

  /// No description provided for @registerPolicyButton.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get registerPolicyButton;

  /// No description provided for @registerPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Privacy'**
  String get registerPolicyTitle;

  /// No description provided for @registerPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'This screen demonstrates reusable policy presentation in a shared bottom sheet. Connect your legal policy content service here.'**
  String get registerPolicyDescription;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerSubmit;

  /// No description provided for @registerBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get registerBackToLogin;

  /// No description provided for @registerPasswordMismatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerPasswordMismatchTitle;

  /// No description provided for @registerPasswordMismatchMessage.
  ///
  /// In en, this message translates to:
  /// **'Please make sure both passwords are identical.'**
  String get registerPasswordMismatchMessage;

  /// No description provided for @registerUiReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration UI ready'**
  String get registerUiReadyTitle;

  /// No description provided for @registerUiReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'UI is complete and ready for API integration.'**
  String get registerUiReadyMessage;

  /// No description provided for @registerEmailMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required for email registration.'**
  String get registerEmailMobileRequired;

  /// No description provided for @registerEmailAccountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address for email registration.'**
  String get registerEmailAccountInvalid;

  /// No description provided for @registerMobileAccountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number for phone registration.'**
  String get registerMobileAccountInvalid;

  /// No description provided for @registerSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registerSubmitFailed;

  /// No description provided for @registerSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccessTitle;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is created. Please sign in.'**
  String get registerSuccessMessage;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore account access with secure verification.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email'**
  String get forgotPasswordAccountLabel;

  /// No description provided for @forgotPasswordCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get forgotPasswordCodeLabel;

  /// No description provided for @forgotPasswordSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get forgotPasswordSendCode;

  /// No description provided for @forgotPasswordSendCodeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent.'**
  String get forgotPasswordSendCodeSuccess;

  /// No description provided for @forgotPasswordNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get forgotPasswordNewPasswordLabel;

  /// No description provided for @forgotPasswordConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get forgotPasswordConfirmPasswordLabel;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordMismatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get forgotPasswordMismatchTitle;

  /// No description provided for @forgotPasswordMismatchMessage.
  ///
  /// In en, this message translates to:
  /// **'Please verify your new password and confirmation.'**
  String get forgotPasswordMismatchMessage;

  /// No description provided for @forgotPasswordUiReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset UI ready'**
  String get forgotPasswordUiReadyTitle;

  /// No description provided for @forgotPasswordUiReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'UI is complete and ready for API integration.'**
  String get forgotPasswordUiReadyMessage;

  /// No description provided for @forgotPasswordRecoverFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to recover access. Please verify your code.'**
  String get forgotPasswordRecoverFailed;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get commonBackToLogin;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get homeLogout;

  /// No description provided for @uiErrorRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed. Please try again later.'**
  String get uiErrorRequestFailed;

  /// No description provided for @uiErrorNetworkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Network connection error. Please try again later.'**
  String get uiErrorNetworkUnavailable;

  /// No description provided for @uiErrorAuthExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get uiErrorAuthExpired;

  /// No description provided for @uiErrorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to access this resource.'**
  String get uiErrorForbidden;

  /// No description provided for @uiErrorServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service is temporarily unavailable. Please try again later.'**
  String get uiErrorServerUnavailable;

  /// No description provided for @languageFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get languageFollowSystem;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJapanese;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
