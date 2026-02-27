import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      builder: (BuildContext context, Widget? child) {
        final mediaQuery = MediaQuery.of(context);
        final brightness = Theme.of(context).brightness;
        final statusBarColor = brightness == Brightness.dark
            ? AppColorTokens.statusBarBackgroundDark
            : AppColorTokens.statusBarBackgroundLight;
        final statusBarOverlayStyle = AppThemeFactory.statusBarOverlayStyleFor(
          brightness,
        ).copyWith(statusBarColor: statusBarColor);
        SystemChrome.setSystemUIOverlayStyle(statusBarOverlayStyle);
        final appChild = _GlobalKeyboardDismissLayer(
          child: child ?? const SizedBox.shrink(),
        );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: statusBarOverlayStyle,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              appChild,
              if (mediaQuery.viewPadding.top > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: mediaQuery.viewPadding.top,
                  child: IgnorePointer(
                    child: ColoredBox(color: statusBarColor),
                  ),
                ),
            ],
          ),
        );
      },
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppThemeFactory.light(),
      darkTheme: AppThemeFactory.dark(),
      themeMode: ThemeMode.system,
    );
  }
}

class _GlobalKeyboardDismissLayer extends StatelessWidget {
  const _GlobalKeyboardDismissLayer({required this.child});

  final Widget child;

  void _handlePointerDown(PointerDownEvent event) {
    final currentFocus = FocusManager.instance.primaryFocus;
    if (currentFocus == null) {
      return;
    }

    if (_isTapInsideFocusedRenderObject(currentFocus, event.position)) {
      return;
    }

    currentFocus.unfocus();
  }

  bool _isTapInsideFocusedRenderObject(FocusNode node, Offset globalPosition) {
    final renderObject = node.context?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return false;
    }

    final localPosition = renderObject.globalToLocal(globalPosition);
    return renderObject.size.contains(localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handlePointerDown,
      child: child,
    );
  }
}
