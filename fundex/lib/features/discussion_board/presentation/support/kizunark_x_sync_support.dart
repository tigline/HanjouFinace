import '../../../social_account/domain/entities/x_account_models.dart';

bool shouldPromptKizunarkXConnection({
  required bool isKizunarkTabActive,
  required bool isAuthenticated,
  required bool hasPromptedForCurrentVisit,
  required bool isPromptOpen,
  required bool isAccountLoading,
  required bool hasAccountError,
  required XAccountStatus accountStatus,
}) {
  if (!isKizunarkTabActive ||
      !isAuthenticated ||
      hasPromptedForCurrentVisit ||
      isPromptOpen ||
      isAccountLoading ||
      hasAccountError) {
    return false;
  }
  return accountStatus == XAccountStatus.disconnected;
}
