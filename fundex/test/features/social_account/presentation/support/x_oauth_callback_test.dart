import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/social_account/presentation/support/x_oauth_callback.dart';

void main() {
  test('matches the registered X OAuth callback URLs only', () {
    expect(isXOAuthCallbackUri(Uri.parse(xOAuthUniversalLinkUrl)), isTrue);
    expect(
      isXOAuthCallbackUri(Uri.parse('$xOAuthUniversalLinkUrl?status=success')),
      isTrue,
    );
    expect(isXOAuthCallbackUri(Uri.parse(xOAuthFallbackUrl)), isTrue);

    expect(
      isXOAuthCallbackUri(
        Uri.parse('https://stellavia.co.jp/app/social/x/other'),
      ),
      isFalse,
    );
    expect(
      isXOAuthCallbackUri(
        Uri.parse('https://gutingjun.com/app/social/x/callback'),
      ),
      isFalse,
    );
    expect(
      isXOAuthCallbackUri(Uri.parse('stellavia://profile/x/callback')),
      isFalse,
    );
  });
}
