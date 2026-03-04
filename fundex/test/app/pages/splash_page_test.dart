import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/pages/splash_page.dart';

void main() {
  group('resolveSplashNavigationTarget', () {
    test('always routes to home', () {
      final target = resolveSplashNavigationTarget();
      expect(target, '/home');
    });
  });
}
