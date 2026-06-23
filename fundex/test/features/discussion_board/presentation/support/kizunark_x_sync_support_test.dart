import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/discussion_board/presentation/support/kizunark_x_sync_support.dart';
import 'package:fundex/features/social_account/domain/entities/x_account_models.dart';

void main() {
  test('prompts only for an authenticated active visit without X binding', () {
    expect(
      shouldPromptKizunarkXConnection(
        isKizunarkTabActive: true,
        isAuthenticated: true,
        hasPromptedForCurrentVisit: false,
        isPromptOpen: false,
        isAccountLoading: false,
        hasAccountError: false,
        accountStatus: XAccountStatus.disconnected,
      ),
      isTrue,
    );

    expect(
      shouldPromptKizunarkXConnection(
        isKizunarkTabActive: true,
        isAuthenticated: true,
        hasPromptedForCurrentVisit: true,
        isPromptOpen: false,
        isAccountLoading: false,
        hasAccountError: false,
        accountStatus: XAccountStatus.disconnected,
      ),
      isFalse,
    );

    expect(
      shouldPromptKizunarkXConnection(
        isKizunarkTabActive: true,
        isAuthenticated: true,
        hasPromptedForCurrentVisit: false,
        isPromptOpen: false,
        isAccountLoading: false,
        hasAccountError: false,
        accountStatus: XAccountStatus.connected,
      ),
      isFalse,
    );
  });
}
