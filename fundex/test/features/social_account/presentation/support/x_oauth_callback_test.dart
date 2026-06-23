import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/social_account/presentation/support/x_oauth_callback.dart';

void main() {
  group('XOAuthCallback', () {
    test('parses the registered callback URI', () {
      final callback = XOAuthCallback.tryParse(
        Uri.parse(
          'stellavia://oauth/x/result?attemptId=attempt-1&result=success',
        ),
      );

      expect(callback, isNotNull);
      expect(callback!.attemptId, 'attempt-1');
      expect(callback.result, 'success');
      expect(callback.wasCancelled, isFalse);
    });

    test('rejects unrelated links and callbacks without an attempt id', () {
      expect(
        XOAuthCallback.tryParse(
          Uri.parse('https://example.com/oauth/x/result?attemptId=attempt-1'),
        ),
        isNull,
      );
      expect(
        XOAuthCallback.tryParse(
          Uri.parse('stellavia://oauth/x/result?result=success'),
        ),
        isNull,
      );
    });
  });
}
