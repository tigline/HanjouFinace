import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/app/router/app_router.dart';

void main() {
  group('resolveAuthRedirect', () {
    test('redirects loading state to splash', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncLoading<bool>(),
        location: '/home',
      );

      expect(redirect, '/splash');
    });

    test('keeps splash while loading', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncLoading<bool>(),
        location: '/splash',
      );

      expect(redirect, isNull);
    });

    test('redirects unauthenticated user to login', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/home',
      );

      expect(redirect, '/login');
    });

    test('keeps unauthenticated user on login', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/login',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on register', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/register',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on forgot password', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/forgot-password',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on design showcase', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/design-showcase/hotel',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on member profile onboarding', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/member-profile/onboarding',
      );

      expect(redirect, isNull);
    });

    test('keeps unauthenticated user on nested login route', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(false),
        location: '/login/email',
      );

      expect(redirect, isNull);
    });

    test('redirects authenticated user from login to home', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(true),
        location: '/login',
      );

      expect(redirect, '/home');
    });

    test('keeps authenticated user on protected routes', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(true),
        location: '/home',
      );

      expect(redirect, isNull);
    });

    test('redirects authenticated user from register to home', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(true),
        location: '/register',
      );

      expect(redirect, '/home');
    });

    test('redirects authenticated user from nested register route to home', () {
      final redirect = resolveAuthRedirect(
        authState: const AsyncData<bool>(true),
        location: '/register/mobile',
      );

      expect(redirect, '/home');
    });
  });
}
