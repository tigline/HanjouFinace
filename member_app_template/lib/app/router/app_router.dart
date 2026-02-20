import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

String? resolveAuthRedirect({
  required AsyncValue<bool> authState,
  required String location,
}) {
  final isSplash = location == '/splash';
  final isLogin = location == '/login';

  if (authState.isLoading) {
    return isSplash ? null : '/splash';
  }

  if (authState.hasError) {
    return isLogin ? null : '/login';
  }

  final isAuthenticated = authState.asData?.value ?? false;
  if (!isAuthenticated) {
    return isLogin ? null : '/login';
  }

  if (isSplash || isLogin) {
    return '/home';
  }

  return null;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(authRouteRefreshListenableProvider);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshListenable,
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(isAuthenticatedProvider);
      return resolveAuthRedirect(
        authState: authState,
        location: state.matchedLocation,
      );
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
    ],
  );
});
