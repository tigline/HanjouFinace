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

  /// No description provided for @authBeforeMemberDirectLogin.
  ///
  /// In en, this message translates to:
  /// **'Already a member? Sign in'**
  String get authBeforeMemberDirectLogin;

  /// No description provided for @authBeforeNonMemberRegister.
  ///
  /// In en, this message translates to:
  /// **'Not a member? Register'**
  String get authBeforeNonMemberRegister;

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

  /// No description provided for @authIntlCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone region code'**
  String get authIntlCodeLabel;

  /// No description provided for @authIntlCodePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select phone region code'**
  String get authIntlCodePickerTitle;

  /// No description provided for @authMethodFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete secure verification with a one-time code.'**
  String get authMethodFormSubtitle;

  /// No description provided for @profileOnboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete profile details'**
  String get profileOnboardingTitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile details'**
  String get profileEditTitle;

  /// No description provided for @profileOnboardingCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile confirmation before trading & booking'**
  String get profileOnboardingCardTitle;

  /// No description provided for @profileOnboardingCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To meet transaction and booking verification requirements, please complete your profile details. You can skip for now and return later.'**
  String get profileOnboardingCardSubtitle;

  /// No description provided for @profileEditCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details'**
  String get profileEditCardTitle;

  /// No description provided for @profileEditCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your previous local input is retained and can be updated anytime.'**
  String get profileEditCardSubtitle;

  /// No description provided for @profileLastSavedHint.
  ///
  /// In en, this message translates to:
  /// **'Previously saved local details have been loaded.'**
  String get profileLastSavedHint;

  /// No description provided for @profileSkipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get profileSkipButton;

  /// No description provided for @profileStepName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileStepName;

  /// No description provided for @profileStepNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter family name first, then given name (JP-style order).'**
  String get profileStepNameSubtitle;

  /// No description provided for @profileStepContact.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get profileStepContact;

  /// No description provided for @profileStepContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter address, phone, and email (auto-filled when available).'**
  String get profileStepContactSubtitle;

  /// No description provided for @profileStepDocument.
  ///
  /// In en, this message translates to:
  /// **'ID document photo'**
  String get profileStepDocument;

  /// No description provided for @profileStepDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload an ID photo for future trading and booking verification.'**
  String get profileStepDocumentSubtitle;

  /// No description provided for @profileFamilyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get profileFamilyNameLabel;

  /// No description provided for @profileFamilyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter family name'**
  String get profileFamilyNameHint;

  /// No description provided for @profileGivenNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Given name'**
  String get profileGivenNameLabel;

  /// No description provided for @profileGivenNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter given name'**
  String get profileGivenNameHint;

  /// No description provided for @profileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileAddressLabel;

  /// No description provided for @profileAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full address (prefecture/city/street/building)'**
  String get profileAddressHint;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhoneLabel;

  /// No description provided for @profilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get profilePhoneHint;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get profileEmailHint;

  /// No description provided for @profileDocumentPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'ID document photo'**
  String get profileDocumentPhotoLabel;

  /// No description provided for @profileDocumentAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload document photo'**
  String get profileDocumentAddPhoto;

  /// No description provided for @profileDocumentChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change document photo'**
  String get profileDocumentChangePhoto;

  /// No description provided for @profileDocumentRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove document photo'**
  String get profileDocumentRemovePhoto;

  /// No description provided for @profileDocumentTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get profileDocumentTakePhoto;

  /// No description provided for @profileDocumentPickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get profileDocumentPickFromGallery;

  /// No description provided for @profileDocumentHint.
  ///
  /// In en, this message translates to:
  /// **'Please upload a clear, unobstructed document photo for later manual review.'**
  String get profileDocumentHint;

  /// No description provided for @profileDocumentAttachedBadge.
  ///
  /// In en, this message translates to:
  /// **'Attached'**
  String get profileDocumentAttachedBadge;

  /// No description provided for @profilePrevStep.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get profilePrevStep;

  /// No description provided for @profileNextStep.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get profileNextStep;

  /// No description provided for @profileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save details'**
  String get profileSaveButton;

  /// No description provided for @profileSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details saved'**
  String get profileSavedTitle;

  /// No description provided for @profileSavedAndContinueLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Your details have been saved locally. You can continue to sign in.'**
  String get profileSavedAndContinueLoginMessage;

  /// No description provided for @profileSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Profile details saved locally.'**
  String get profileSavedSnackbar;

  /// No description provided for @profileIntakeValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Incomplete profile details'**
  String get profileIntakeValidationTitle;

  /// No description provided for @profileFamilyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your family name.'**
  String get profileFamilyNameRequired;

  /// No description provided for @profileGivenNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your given name.'**
  String get profileGivenNameRequired;

  /// No description provided for @profileAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address.'**
  String get profileAddressRequired;

  /// No description provided for @profilePhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get profilePhoneRequired;

  /// No description provided for @profileEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get profileEmailRequired;

  /// No description provided for @profileDocumentPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Please upload an ID document photo.'**
  String get profileDocumentPhotoRequired;

  /// No description provided for @profileDocumentPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select document photo. Please try again.'**
  String get profileDocumentPickFailed;

  /// No description provided for @profileIncompleteBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details incomplete'**
  String get profileIncompleteBannerTitle;

  /// No description provided for @profileIncompleteBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Trading and booking require a complete profile.'**
  String get profileIncompleteBannerSubtitle;

  /// No description provided for @profileIncompleteBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Please complete name, address, phone, email, and ID document photo before trading or booking.'**
  String get profileIncompleteBannerBody;

  /// No description provided for @profileGuardTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details required'**
  String get profileGuardTitle;

  /// No description provided for @profileGuardMessage.
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile details before trading or booking.'**
  String get profileGuardMessage;

  /// No description provided for @profileGuardMessageWithAction.
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile details before \"{actionLabel}\".'**
  String profileGuardMessageWithAction(Object actionLabel);

  /// No description provided for @profileGuardCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileGuardCancel;

  /// No description provided for @profileGuardGoFill.
  ///
  /// In en, this message translates to:
  /// **'Complete now'**
  String get profileGuardGoFill;

  /// No description provided for @profileGuardPassMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile validation passed. You can continue with {actionLabel}.'**
  String profileGuardPassMessage(Object actionLabel);

  /// No description provided for @profileStatusCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile detail status'**
  String get profileStatusCardTitle;

  /// No description provided for @profileStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed. Trading and booking are available.'**
  String get profileStatusCompleted;

  /// No description provided for @profileStatusIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete. Please complete your details before trading or booking.'**
  String get profileStatusIncomplete;

  /// No description provided for @profileStatusLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile status. Please try again.'**
  String get profileStatusLoadFailed;

  /// No description provided for @profileEditEntryButton.
  ///
  /// In en, this message translates to:
  /// **'Fill / Edit details'**
  String get profileEditEntryButton;

  /// No description provided for @profileProtectedBookingAction.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get profileProtectedBookingAction;

  /// No description provided for @profileProtectedTradeAction.
  ///
  /// In en, this message translates to:
  /// **'Trading'**
  String get profileProtectedTradeAction;

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

  /// No description provided for @mainTabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainTabHome;

  /// No description provided for @mainTabHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get mainTabHotel;

  /// No description provided for @mainTabDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get mainTabDiscussion;

  /// No description provided for @mainTabInvestment.
  ///
  /// In en, this message translates to:
  /// **'Invest'**
  String get mainTabInvestment;

  /// No description provided for @mainTabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get mainTabProfile;

  /// No description provided for @mainTabKizunark.
  ///
  /// In en, this message translates to:
  /// **'KIZUNARK'**
  String get mainTabKizunark;

  /// No description provided for @mainTabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainTabSettings;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment Overview'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick view of portfolio, floating P/L, and available cash.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeHeroAssetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total assets'**
  String get homeHeroAssetsLabel;

  /// No description provided for @homeHeroPnlLabel.
  ///
  /// In en, this message translates to:
  /// **'Floating P/L'**
  String get homeHeroPnlLabel;

  /// No description provided for @homeHeroCashLabel.
  ///
  /// In en, this message translates to:
  /// **'Available cash'**
  String get homeHeroCashLabel;

  /// No description provided for @hotelTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Hotel Booking Module (Framework)'**
  String get hotelTabHeadline;

  /// No description provided for @hotelTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search, list, detail, and booking flows will be integrated here next.'**
  String get hotelTabSubtitle;

  /// No description provided for @discussionTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Investment Discussion Board (Framework)'**
  String get discussionTabHeadline;

  /// No description provided for @discussionTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive message-board area for replies, likes, pinning, and moderation.'**
  String get discussionTabSubtitle;

  /// No description provided for @discussionTabReplyAction.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get discussionTabReplyAction;

  /// No description provided for @investmentTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Investment Module (Framework)'**
  String get investmentTabHeadline;

  /// No description provided for @investmentTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products, portfolio, subscriptions/redemptions, and statements will be added here.'**
  String get investmentTabSubtitle;

  /// No description provided for @investmentTabPortfolioLabel.
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get investmentTabPortfolioLabel;

  /// No description provided for @investmentTabWatchlistLabel.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get investmentTabWatchlistLabel;

  /// No description provided for @profileTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Profile Center (Framework)'**
  String get profileTabHeadline;

  /// No description provided for @profileTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage account details, profile intake, preferences, and member status.'**
  String get profileTabSubtitle;

  /// No description provided for @settingsTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTabHeadline;

  /// No description provided for @settingsTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account, security, legal documents, and preference settings will be integrated here.'**
  String get settingsTabSubtitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsLotteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Lottery result'**
  String get notificationsLotteryTitle;

  /// No description provided for @notificationsLotterySubtitle.
  ///
  /// In en, this message translates to:
  /// **'After API integration, lottery and deposit notifications will appear here.'**
  String get notificationsLotterySubtitle;

  /// No description provided for @notificationsSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'System notices'**
  String get notificationsSystemTitle;

  /// No description provided for @notificationsSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance, statements, and legal updates.'**
  String get notificationsSystemSubtitle;

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
