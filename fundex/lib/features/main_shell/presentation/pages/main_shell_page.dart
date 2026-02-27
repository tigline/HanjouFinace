import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:core_ui_kit/core_ui_kit.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  SystemUiOverlayStyle _statusBarStyle(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    return baseStyle.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    );
  }

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shellNavigationTheme = theme.extension<AppShellNavigationTheme>()!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle(context),
      child: Scaffold(
        key: const Key('home_page'),
        body: SafeArea(bottom: false, child: navigationShell),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: colorScheme.primary.withValues(alpha: 0.14),
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
              Set<WidgetState> states,
            ) {
              return IconThemeData(
                color: states.contains(WidgetState.selected)
                    ? colorScheme.primary
                    : shellNavigationTheme.bottomTabInactiveColor,
              );
            }),
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
              Set<WidgetState> states,
            ) {
              final base = theme.textTheme.labelMedium;
              return base?.copyWith(
                color: states.contains(WidgetState.selected)
                    ? colorScheme.primary
                    : shellNavigationTheme.bottomTabInactiveColor,
                fontWeight: states.contains(WidgetState.selected)
                    ? FontWeight.w700
                    : FontWeight.w500,
              );
            }),
          ),
          child: NavigationBar(
            key: const Key('main_tab_bar'),
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: l10n.mainTabHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.hotel_outlined),
                selectedIcon: const Icon(Icons.hotel_rounded),
                label: l10n.mainTabHotel,
              ),
              NavigationDestination(
                icon: const Icon(Icons.show_chart_outlined),
                selectedIcon: const Icon(Icons.show_chart_rounded),
                label: l10n.mainTabInvestment,
              ),
              NavigationDestination(
                icon: const Icon(Icons.forum_outlined),
                selectedIcon: const Icon(Icons.forum_rounded),
                label: l10n.mainTabDiscussion,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: l10n.mainTabProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
