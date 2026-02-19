import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
      next.whenOrNull(
        data: (bool isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) {
              return;
            }
            context.go(isAuthenticated ? '/home' : '/login');
          });
        },
        error: (Object error, StackTrace stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) {
              return;
            }
            context.go('/login');
          });
        },
      );
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
