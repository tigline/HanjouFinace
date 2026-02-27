import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../pages/hotel_design_showcase_page.dart';
import '../pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/pages/auth_entry_page.dart';
import '../../features/auth/presentation/pages/auth_mode_pages.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/discussion_board/presentation/pages/discussion_board_tab_page.dart';
import '../../features/home/presentation/pages/home_overview_tab_page.dart';
import '../../features/investment/presentation/pages/investment_tab_page.dart';
import '../../features/main_shell/presentation/pages/main_shell_page.dart';
import '../../features/member_profile/presentation/pages/member_profile_intake_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/member_profile/presentation/pages/profile_center_tab_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

String? resolveAuthRedirect({
  required AsyncValue<bool> authState,
  required String location,
}) {
  final isSplash = location == '/splash';
  final isLogin =
      location == '/login' ||
      location.startsWith('/login/') ||
      location == '/login-legacy';
  final isRegister =
      location == '/register' ||
      location.startsWith('/register/') ||
      location == '/register-legacy';
  final isForgotPassword = location == '/forgot-password';
  final isMemberProfileOnboarding = location == '/member-profile/onboarding';
  final isHotelDesignShowcase = location == '/design-showcase/hotel';
  final isAuthRoute = isLogin || isRegister || isForgotPassword;
  final isPublicRoute =
      isAuthRoute || isHotelDesignShowcase || isMemberProfileOnboarding;

  if (authState.isLoading) {
    return isSplash ? null : '/splash';
  }

  if (authState.hasError) {
    return isPublicRoute ? null : '/login';
  }

  final isAuthenticated = authState.asData?.value ?? false;
  if (!isAuthenticated) {
    return isPublicRoute ? null : '/login';
  }

  if (isSplash || isAuthRoute) {
    return '/home';
  }

  return null;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(isAuthenticatedProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) {
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
          return const AuthEntryPage();
        },
      ),
      GoRoute(
        path: '/login/mobile',
        builder: (BuildContext context, GoRouterState state) {
          return const MobileLoginMethodPage();
        },
      ),
      GoRoute(
        path: '/login/email',
        builder: (BuildContext context, GoRouterState state) {
          return const EmailLoginMethodPage();
        },
      ),
      GoRoute(
        path: '/login-legacy',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterEntryPage();
        },
      ),
      GoRoute(
        path: '/register/mobile',
        builder: (BuildContext context, GoRouterState state) {
          return const MobileRegisterMethodPage();
        },
      ),
      GoRoute(
        path: '/register/email',
        builder: (BuildContext context, GoRouterState state) {
          return const EmailRegisterMethodPage();
        },
      ),
      GoRoute(
        path: '/register-legacy',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordPage();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return MainShellPage(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) {
                  return const HomeOverviewTabPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/funds',
                builder: (BuildContext context, GoRouterState state) {
                  return const InvestmentTabPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/discussion-board',
                builder: (BuildContext context, GoRouterState state) {
                  return const DiscussionBoardTabPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                builder: (BuildContext context, GoRouterState state) {
                  return const ProfileCenterTabPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/settings',
                builder: (BuildContext context, GoRouterState state) {
                  return const SettingsPage();
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationsPage();
        },
      ),
      GoRoute(
        path: '/investment',
        redirect: (BuildContext context, GoRouterState state) => '/funds',
      ),
      GoRoute(
        path: '/hotel-booking',
        redirect: (BuildContext context, GoRouterState state) => '/funds',
      ),
      GoRoute(
        path: '/member-profile/onboarding',
        builder: (BuildContext context, GoRouterState state) {
          final query = state.uri.queryParameters;
          return MemberProfileIntakePage.onboarding(
            nextRoute: query['next'],
            seedPhone: query['phone'],
            seedEmail: query['email'],
          );
        },
      ),
      GoRoute(
        path: '/member-profile/edit',
        builder: (BuildContext context, GoRouterState state) {
          return const MemberProfileIntakePage.edit();
        },
      ),
      GoRoute(
        path: '/design-showcase/hotel',
        builder: (BuildContext context, GoRouterState state) {
          return const HotelDesignShowcasePage();
        },
      ),
    ],
  );
});
