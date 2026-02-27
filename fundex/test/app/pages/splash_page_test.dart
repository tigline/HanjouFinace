import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/pages/splash_page.dart';

void main() {
  group('resolveSplashNavigationTarget', () {
    test('returns null while auth state is loading', () {
      final target = resolveSplashNavigationTarget(const AsyncLoading<bool>());

      expect(target, isNull);
    });

    test('routes to home when authenticated', () {
      final target = resolveSplashNavigationTarget(const AsyncData<bool>(true));

      expect(target, '/home');
    });

    test('routes to login when unauthenticated', () {
      final target = resolveSplashNavigationTarget(
        const AsyncData<bool>(false),
      );

      expect(target, '/login');
    });

    test('routes to login when auth state has error', () {
      final target = resolveSplashNavigationTarget(
        AsyncError<bool>(Exception('auth failed'), StackTrace.empty),
      );

      expect(target, '/login');
    });
  });
}
