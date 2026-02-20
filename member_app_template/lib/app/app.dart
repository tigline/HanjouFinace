import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';

import 'config/environment_provider.dart';
import 'localization/app_locale_providers.dart';
import 'observability/app_observability_providers.dart';
import 'observability/app_ui_message_localizer.dart';
import 'router/app_router.dart';

final GlobalKey<ScaffoldMessengerState> _rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MemberTemplateApp extends ConsumerWidget {
  const MemberTemplateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final environment = ref.watch(appEnvironmentProvider);
    final locale = ref.watch(appLocaleProvider);

    ref.listen<AppUiMessage?>(appUiMessageProvider, (previous, next) {
      if (next == null) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messenger = _rootScaffoldMessengerKey.currentState;
        final messengerContext = _rootScaffoldMessengerKey.currentContext;
        if (messenger != null && messengerContext != null) {
          final message = next.key.resolve(
            AppLocalizations.of(messengerContext),
          );
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
        ref.read(appUiMessageProvider.notifier).clearIfMatches(next.id);
      });
    });

    return MaterialApp.router(
      title: environment.appName,
      scaffoldMessengerKey: _rootScaffoldMessengerKey,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppThemeFactory.light(),
      darkTheme: AppThemeFactory.dark(),
      themeMode: ThemeMode.system,
    );
  }
}
