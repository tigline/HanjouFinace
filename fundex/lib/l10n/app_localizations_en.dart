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
  String get loginBrowseAsGuest => 'Browse without signing in (Guest mode)';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get commonClose => 'Close';

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
  String get registerQuickTitle => 'Create your account first';

  @override
  String get registerQuickSubtitle =>
      'Register with your email and verification code. You can complete investment profile details later.';

  @override
  String get registerModeTitle => 'Registration method';

  @override
  String get authModeEmail => 'Email';

  @override
  String get authModeMobile => 'Phone';

  @override
  String get splashBrandName => 'FUNDEX';

  @override
  String get splashTagline => 'Real estate crowdfunding';

  @override
  String get authEntryHeadline =>
      'One sign-in for investment and hotel member services';

  @override
  String get authEntryDescription =>
      'Sign in with phone or email to manage investments, bookings, and member privileges.';

  @override
  String get authEntryPhoneLogin => 'Sign in with phone';

  @override
  String get authEntryEmailLogin => 'Sign in with email';

  @override
  String get authEntryNonMemberRegisterNow => 'Not a member? Register now';

  @override
  String get authBeforeMemberDirectLogin => 'Already a member? Sign in';

  @override
  String get authBeforeNonMemberRegister => 'Not a member? Register';

  @override
  String get authRegisterEntryHeadline => 'Choose registration method';

  @override
  String get authRegisterEntryDescription =>
      'Create your account with phone or email and manage all member services in one place.';

  @override
  String get authEntryPhoneRegister => 'Register with phone';

  @override
  String get authEntryEmailRegister => 'Register with email';

  @override
  String get authBackToLoginEntry => 'Back to sign-in options';

  @override
  String get authBackToRegisterEntry => 'Back to registration options';

  @override
  String get authIntlCodeLabel => 'Phone region code';

  @override
  String get authIntlCodePickerTitle => 'Select phone region code';

  @override
  String get authMethodFormSubtitle =>
      'Complete secure verification with a one-time code.';

  @override
  String get profileOnboardingTitle => 'Complete profile details';

  @override
  String get profileEditTitle => 'Edit profile details';

  @override
  String get profileOnboardingCardTitle =>
      'Profile confirmation before trading & booking';

  @override
  String get profileOnboardingCardSubtitle =>
      'To meet transaction and booking verification requirements, please complete your profile details. You can skip for now and return later.';

  @override
  String get profileEditCardTitle => 'Profile details';

  @override
  String get profileEditCardSubtitle =>
      'Your previous local input is retained and can be updated anytime.';

  @override
  String get profileLastSavedHint =>
      'Previously saved local details have been loaded.';

  @override
  String get profileSkipButton => 'Skip for now';

  @override
  String get profileStepName => 'Name';

  @override
  String get profileStepNameSubtitle =>
      'Enter family name first, then given name (JP-style order).';

  @override
  String get profileStepContact => 'Contact details';

  @override
  String get profileStepContactSubtitle =>
      'Enter address, phone, and email (auto-filled when available).';

  @override
  String get profileStepDocument => 'ID document photo';

  @override
  String get profileStepDocumentSubtitle =>
      'Upload an ID photo for future trading and booking verification.';

  @override
  String get profileFamilyNameLabel => 'Family name';

  @override
  String get profileFamilyNameHint => 'Enter family name';

  @override
  String get profileGivenNameLabel => 'Given name';

  @override
  String get profileGivenNameHint => 'Enter given name';

  @override
  String get profileAddressLabel => 'Address';

  @override
  String get profileAddressHint =>
      'Enter full address (prefecture/city/street/building)';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profilePhoneHint => 'Enter phone number';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileEmailHint => 'Enter email address';

  @override
  String get profileDocumentPhotoLabel => 'ID document photo';

  @override
  String get profileDocumentAddPhoto => 'Upload document photo';

  @override
  String get profileDocumentChangePhoto => 'Change document photo';

  @override
  String get profileDocumentRemovePhoto => 'Remove document photo';

  @override
  String get profileDocumentTakePhoto => 'Take photo';

  @override
  String get profileDocumentPickFromGallery => 'Choose from gallery';

  @override
  String get profileDocumentHint =>
      'Please upload a clear, unobstructed document photo for later manual review.';

  @override
  String get profileDocumentAttachedBadge => 'Attached';

  @override
  String get profilePrevStep => 'Back';

  @override
  String get profileNextStep => 'Next';

  @override
  String get profileSaveButton => 'Save details';

  @override
  String get profileSavedTitle => 'Profile details saved';

  @override
  String get profileSavedAndContinueLoginMessage =>
      'Your details have been saved locally. You can continue to sign in.';

  @override
  String get profileSavedSnackbar => 'Profile details saved locally.';

  @override
  String get profileIntakeValidationTitle => 'Incomplete profile details';

  @override
  String get profileFamilyNameRequired => 'Please enter your family name.';

  @override
  String get profileGivenNameRequired => 'Please enter your given name.';

  @override
  String get profileAddressRequired => 'Please enter your address.';

  @override
  String get profilePhoneRequired => 'Please enter a valid phone number.';

  @override
  String get profileEmailRequired => 'Please enter a valid email address.';

  @override
  String get profileDocumentPhotoRequired =>
      'Please upload an ID document photo.';

  @override
  String get profileDocumentPickFailed =>
      'Failed to select document photo. Please try again.';

  @override
  String get profileIncompleteBannerTitle => 'Profile details incomplete';

  @override
  String get profileIncompleteBannerSubtitle =>
      'Trading and booking require a complete profile.';

  @override
  String get profileIncompleteBannerBody =>
      'Please complete name, address, phone, email, and ID document photo before trading or booking.';

  @override
  String get profileGuardTitle => 'Profile details required';

  @override
  String get profileGuardMessage =>
      'Please complete your profile details before trading or booking.';

  @override
  String profileGuardMessageWithAction(Object actionLabel) {
    return 'Please complete your profile details before \"$actionLabel\".';
  }

  @override
  String get profileGuardCancel => 'Cancel';

  @override
  String get profileGuardGoFill => 'Complete now';

  @override
  String profileGuardPassMessage(Object actionLabel) {
    return 'Profile validation passed. You can continue with $actionLabel.';
  }

  @override
  String get profileStatusCardTitle => 'Profile detail status';

  @override
  String get profileStatusCompleted =>
      'Completed. Trading and booking are available.';

  @override
  String get profileStatusIncomplete =>
      'Incomplete. Please complete your details before trading or booking.';

  @override
  String get profileStatusLoadFailed =>
      'Unable to load profile status. Please try again.';

  @override
  String get profileEditEntryButton => 'Fill / Edit details';

  @override
  String get profileProtectedBookingAction => 'Booking';

  @override
  String get profileProtectedTradeAction => 'Trading';

  @override
  String get authMobileLoginTitle => 'Phone sign in';

  @override
  String get authEmailLoginTitle => 'Email sign in';

  @override
  String get authMobileRegisterTitle => 'Phone registration';

  @override
  String get authEmailRegisterTitle => 'Email registration';

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
  String get mainTabHome => 'Home';

  @override
  String get mainTabHotel => 'Hotels';

  @override
  String get mainTabDiscussion => 'Board';

  @override
  String get mainTabInvestment => 'Invest';

  @override
  String get mainTabProfile => 'Profile';

  @override
  String get mainTabKizunark => 'KIZUNARK';

  @override
  String get mainTabSettings => 'Settings';

  @override
  String get homeHeroTitle => 'Investment Overview';

  @override
  String get homeHeroSubtitle =>
      'Quick view of portfolio, floating P/L, and available cash.';

  @override
  String get homeHeroAssetsLabel => 'Total assets';

  @override
  String get homeHeroPnlLabel => 'Floating P/L';

  @override
  String get homeHeroCashLabel => 'Available cash';

  @override
  String homeWelcomeUser(Object name) {
    return 'Welcome back, $name 👋';
  }

  @override
  String get homeHeroTotalAssetsAmountLabel => 'Total assets';

  @override
  String get homeHeroMonthlyDelta => '+¥127,500 (vs last month +3.4%)';

  @override
  String get homeHeroActiveInvestmentLabel => 'Active investments';

  @override
  String get homeHeroTotalDividendsLabel => 'Total dividends';

  @override
  String get homeGuestBrowsingTitle => 'Browsing without signing in';

  @override
  String get homeGuestBrowsingBody => 'An account is required to invest.';

  @override
  String get homeReminderProfileTitle => 'Profile information is required';

  @override
  String get homeReminderProfileBody =>
      'Identity verification is required for investing and withdrawals. Please complete your profile information.';

  @override
  String get homeReminderProfileBadge => 'Action needed';

  @override
  String get homeReminderCoolingOffTitle => 'Cooling-off period in progress';

  @override
  String get homeReminderCoolingOffBody =>
      '\"Shinsaibashi Commercial Building\" Contract document issued 3/2 → Cancellation deadline 3/10 (8 days)';

  @override
  String get homeReminderCoolingOffBadge => '5 days left';

  @override
  String get homeReminderCoolingOffAction => 'Cancel contract';

  @override
  String get homeFeaturedFundsTitle => '🔥 Featured Funds';

  @override
  String get homeViewAllAction => 'View all';

  @override
  String get homeEstimatedYieldLabel => 'Est. yield';

  @override
  String get homeTagOpen => 'Open';

  @override
  String get homeTagLottery => 'Lottery';

  @override
  String get homeTagUpcoming => 'Upcoming';

  @override
  String get homeActiveFundsTitle => '📊 Active Funds';

  @override
  String get homeInvestedAmountLabel => 'Investment amount';

  @override
  String get homeNextDividendLabel => 'Next dividend';

  @override
  String get homeShowMoreAction => 'Show more';

  @override
  String get homeShowLessAction => 'Show less';

  @override
  String get homeMockFeaturedFundA =>
      'Akasaka Premium Residence, Minato, Tokyo';

  @override
  String get homeMockFeaturedFundB =>
      'Shinsaibashi Commercial Building, Chuo, Osaka';

  @override
  String get homeMockFeaturedFundC =>
      'Machiya Renovation Hotel, Higashiyama, Kyoto';

  @override
  String get homeMockFeaturedMetaA => '12 months ・ ¥200M';

  @override
  String get homeMockFeaturedMetaB => '18 months ・ ¥150M';

  @override
  String get homeMockFeaturedMetaC => '24 months ・ ¥300M';

  @override
  String get homeMockActiveFundA => 'Shibuya Office Building #12';

  @override
  String get homeMockActiveFundB => 'Nagoya Logistics Facility #09';

  @override
  String get homeMockActiveFundC => 'Fukuoka Residence Fund #07';

  @override
  String get homeMockActiveFundD => 'Sapporo Mixed-Use Fund #03';

  @override
  String get fundListTitle => 'Fund List';

  @override
  String get fundListFilterAll => 'All';

  @override
  String get fundListFilterOperating => 'Operating';

  @override
  String get fundListFilterOperatingEnded => 'Operation Ended';

  @override
  String get fundListFilterOpen => 'Open';

  @override
  String get fundListFilterUpcoming => 'Upcoming';

  @override
  String get fundListFilterClosed => 'Closed';

  @override
  String get fundListFilterCompleted => 'Completed';

  @override
  String get fundListFilterFailed => 'Failed';

  @override
  String get fundListYieldLabel => 'Yield';

  @override
  String get fundListPeriodLabel => 'Period';

  @override
  String get fundListMethodLabel => 'Method';

  @override
  String get fundListMethodLottery => 'Lottery';

  @override
  String get fundListMethodUnknown => 'Unknown';

  @override
  String fundListAppliedAmount(Object amount, Object progress) {
    return 'Applied $amount ($progress)';
  }

  @override
  String fundListOpenStartAt(Object start) {
    return 'Subscription starts $start';
  }

  @override
  String get fundListViewDetail => 'View details →';

  @override
  String get fundListLoadError => 'Failed to load funds. Please try again.';

  @override
  String get fundListRetry => 'Retry';

  @override
  String get fundListEmpty => 'No funds found for this filter.';

  @override
  String get fundListStatusOperating => 'Operating';

  @override
  String get fundListStatusOperatingEnded => 'Operation Ended';

  @override
  String get fundListStatusOpen => 'Open';

  @override
  String get fundListStatusUpcoming => 'Upcoming';

  @override
  String get fundListStatusClosed => 'Closed';

  @override
  String get fundListStatusCompleted => 'Completed';

  @override
  String get fundListStatusFailed => 'Failed';

  @override
  String get fundListStatusUnknown => 'Unknown';

  @override
  String fundListVolume(Object number) {
    return 'Vol. $number';
  }

  @override
  String get hotelTabHeadline => 'Hotel Booking Module (Framework)';

  @override
  String get hotelTabSubtitle =>
      'Search, list, detail, and booking flows will be integrated here next.';

  @override
  String get discussionTabHeadline => 'Investment Discussion Board (Framework)';

  @override
  String get discussionTabSubtitle =>
      'Interactive message-board area for replies, likes, pinning, and moderation.';

  @override
  String get discussionTabReplyAction => 'Reply';

  @override
  String get investmentTabHeadline => 'Investment Module (Framework)';

  @override
  String get investmentTabSubtitle =>
      'Products, portfolio, subscriptions/redemptions, and statements will be added here.';

  @override
  String get investmentTabPortfolioLabel => 'Holdings';

  @override
  String get investmentTabWatchlistLabel => 'Watchlist';

  @override
  String get profileTabHeadline => 'Profile Center (Framework)';

  @override
  String get profileTabSubtitle =>
      'Manage account details, profile intake, preferences, and member status.';

  @override
  String get settingsTabHeadline => 'Settings';

  @override
  String get settingsTabSubtitle =>
      'Account, security, legal documents, and preference settings will be integrated here.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsLotteryTitle => 'Lottery result';

  @override
  String get notificationsLotterySubtitle =>
      'After API integration, lottery and deposit notifications will appear here.';

  @override
  String get notificationsSystemTitle => 'System notices';

  @override
  String get notificationsSystemSubtitle =>
      'Maintenance, statements, and legal updates.';

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

  @override
  String get fundDetailEstimatedYieldAnnualLabel =>
      'Estimated yield (annualized)';

  @override
  String get fundDetailYieldDisclaimer => '* Estimate only. Not guaranteed.';

  @override
  String get fundDetailKeyFactsTitle => '📌 Key facts';

  @override
  String get fundDetailFundTotalLabel => 'Fund size';

  @override
  String get fundDetailMinimumInvestmentLabel => 'Minimum investment';

  @override
  String get fundDetailDividendLabel => 'Distribution';

  @override
  String get fundDetailLotteryDateLabel => 'Lottery date';

  @override
  String get fundDetailPreferredStructureTitle =>
      '🛡️ Preferred/Subordinated Structure';

  @override
  String get fundDetailSeniorInvestmentLabel => 'Preferred';

  @override
  String get fundDetailJuniorInvestmentLabel => 'Subordinated';

  @override
  String get fundDetailPropertyInfoTitle => '📍 Property details';

  @override
  String get fundDetailLocationLabel => 'Location';

  @override
  String get fundDetailPropertyTypeLabel => 'Property type';

  @override
  String get fundDetailStructureLabel => 'Structure';

  @override
  String get fundDetailBuiltYearLabel => 'Built';

  @override
  String get fundDetailContractOverviewTitle => '📋 Contract overview';

  @override
  String get fundDetailContractTypeLabel => 'Contract type';

  @override
  String get fundDetailContractTypeValue => 'Silent partnership';

  @override
  String get fundDetailTargetPropertyTypeLabel => 'Target real estate type';

  @override
  String get fundDetailAppraisalValueLabel => 'Appraisal value';

  @override
  String get fundDetailAcquisitionPriceLabel => 'Planned acquisition price';

  @override
  String get fundDetailOfferPeriodLabel => 'Offering period';

  @override
  String get fundDetailOperationStartLabel => 'Planned start date';

  @override
  String get fundDetailOperationEndLabel => 'Planned end date';

  @override
  String get fundDetailOperatorInfoTitle => '🏢 Operator information';

  @override
  String get fundDetailOperatorCompanyLabel => 'Operator';

  @override
  String get fundDetailPermitNumberLabel => 'License number';

  @override
  String get fundDetailRepresentativeLabel => 'Representative';

  @override
  String get fundDetailCompanyAddressLabel => 'Address';

  @override
  String get fundDetailDocumentsTitle => '📄 Related documents';

  @override
  String get fundDetailDocumentReady => 'Tap to review';

  @override
  String get fundDetailDocumentUnavailable => 'Document URL not available';

  @override
  String get fundDetailPropertyPreviewBadge => 'Property preview';

  @override
  String get fundDetailCommentsTitle => '💬 Investor voices';

  @override
  String get fundDetailCommentsPlaceholder =>
      'Comments are intentionally left empty for now. UI integration will be added later.';

  @override
  String get fundDetailFinancialStatusAction =>
      '📊 View operator financial status →';

  @override
  String get fundDetailFinancialStatusToast =>
      'The financial status page will be connected in a later implementation.';

  @override
  String get fundDetailApplyNowAction => 'Apply for lottery';

  @override
  String get fundDetailOpenSoonAction => 'Waiting for opening';

  @override
  String get fundDetailUnavailableAction => 'Unavailable now';

  @override
  String get fundDetailApplyComingSoonToast =>
      'The application flow will be connected in the next implementation.';

  @override
  String get fundDetailUnknownValue => '--';

  @override
  String get fundDetailOneUnitSuffix => '(1 unit)';

  @override
  String get fundDetailMonthlyDistribution => 'Monthly';

  @override
  String get fundDetailQuarterlyDistribution => 'Quarterly';

  @override
  String get fundDetailSemiAnnualDistribution => 'Semi-annually';

  @override
  String get fundDetailAnnualDistribution => 'Annually';

  @override
  String get myPageTitle => 'My Page';

  @override
  String get myPageTotalAssetsLabel => 'Total assets';

  @override
  String get myPageTotalAssetsCaption =>
      'Operating + standby cash + distributions + lending';

  @override
  String get myPageMetricOperating => 'Operating';

  @override
  String get myPageMetricStandby => 'Standby cash';

  @override
  String get myPageMetricAccumulatedDistribution => 'Total distributions';

  @override
  String get myPageMetricLoanType => 'Lending';

  @override
  String get myPageDepositAction => 'Deposit';

  @override
  String get myPageWithdrawAction => 'Withdraw';

  @override
  String get myPagePendingApplicationsTitle => 'Applications / Lottery waiting';

  @override
  String get myPageCoolingOffTitle => 'Cooling-off period (contract formed)';

  @override
  String get myPageOperatingFundsTitle => 'Operating funds';

  @override
  String get myPageTransactionHistoryAction => 'View transaction history';

  @override
  String get myPageApplyAmountLabel => 'Application amount';

  @override
  String get myPageResultAnnouncementLabel => 'Result date';

  @override
  String get myPageResultAnnouncementTbd => 'TBD';

  @override
  String get myPageApplySubmittedAtLabel => 'Applied at';

  @override
  String get myPageApplyReviewedAtLabel => 'Reviewed at';

  @override
  String get myPageApplyPaymentNoticeLabel => 'Payment notice';

  @override
  String get myPageApplyPaidAtLabel => 'Paid at';

  @override
  String get myPageApplyCancellationRequestedAtLabel =>
      'Cancellation requested';

  @override
  String get myPageApplyCancelledAtLabel => 'Cancelled at';

  @override
  String get myPageInvestmentAmountLabel => 'Investment amount';

  @override
  String get myPageAccumulatedDistributionLabel => 'Total distributions';

  @override
  String get myPageDocumentDeliveryDateLabel => 'Document date';

  @override
  String get myPageCancelDeadlineLabel => 'Cancellation deadline';

  @override
  String get myPageCoolingOffFootnote =>
      '* Cooling-off cancellation is available for 8 days from the day after receiving the contract document.';

  @override
  String get myPageCancelRequestAction => 'Request cancellation';

  @override
  String get myPageCancelRequestComingSoon =>
      'Cancellation flow will be connected in a later implementation.';

  @override
  String get myPageDepositComingSoon =>
      'Deposit page will be connected in a later implementation.';

  @override
  String get myPageWithdrawComingSoon =>
      'Withdraw page will be connected in a later implementation.';

  @override
  String get myPageHistoryComingSoon =>
      'Transaction history page will be connected in a later implementation.';

  @override
  String get myPagePendingEmptyState =>
      'No applications or lottery-waiting items.';

  @override
  String get myPageCoolingOffEmptyState =>
      'No contracts in the cooling-off period.';

  @override
  String get myPageOperatingFundsEmptyState => 'No operating funds yet.';

  @override
  String get myPageSectionLoadError =>
      'Failed to load this section. Please try again.';

  @override
  String get myPageApplyStatusUnderReview => 'Under review';

  @override
  String get myPageApplyStatusReviewed => 'Reviewed';

  @override
  String get myPageApplyStatusAwaitingPayment => 'Awaiting payment';

  @override
  String get myPageApplyStatusPaid => 'Paid';

  @override
  String get myPageApplyStatusCancellationReview => 'Cancellation in review';

  @override
  String get myPageApplyStatusCancelled => 'Cancelled';

  @override
  String myPageCoolingOffDeadlineRemaining(Object date, int days) {
    return 'Until $date ($days days left)';
  }

  @override
  String myPageCoolingOffDeadlineExpired(Object date) {
    return 'Expired on $date';
  }
}
