import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/environment_provider.dart';
import 'observability/app_observability_providers.dart';
import 'router/app_router.dart';

final GlobalKey<ScaffoldMessengerState> _rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MemberTemplateApp extends ConsumerWidget {
  const MemberTemplateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final environment = ref.watch(appEnvironmentProvider);

    ref.listen<AppUiMessage?>(appUiMessageProvider, (previous, next) {
      if (next == null) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messenger = _rootScaffoldMessengerKey.currentState;
        if (messenger != null) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(next.message)));
        }
        ref.read(appUiMessageProvider.notifier).clearIfMatches(next.id);
      });
    });

    return MaterialApp.router(
      title: environment.appName,
      scaffoldMessengerKey: _rootScaffoldMessengerKey,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
      ),
    );
  }
}
