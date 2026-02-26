import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class MainShellPage extends ConsumerStatefulWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage> {
  bool _isLoggingOut = false;

  Future<void> _switchLanguage(AppLanguage language) {
    return ref.read(appLanguageProvider.notifier).setLanguage(language);
  }

  String _languageLabel(BuildContext context, AppLanguage language) {
    final l10n = context.l10n;
    return switch (language) {
      AppLanguage.system => l10n.languageFollowSystem,
      AppLanguage.zh => l10n.languageChinese,
      AppLanguage.en => l10n.languageEnglish,
      AppLanguage.ja => l10n.languageJapanese,
    };
  }

  Future<void> _logout() async {
    if (_isLoggingOut) {
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await ref.read(logoutUseCaseProvider).call();
      await ref.read(authSessionProvider.notifier).markUnauthenticated();
      if (mounted) {
        context.go('/login');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  void _onDestinationSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  String _tabTitle(BuildContext context, int index) {
    final l10n = context.l10n;
    return switch (index) {
      0 => l10n.mainTabHome,
      1 => l10n.mainTabHotel,
      2 => l10n.mainTabDiscussion,
      3 => l10n.mainTabInvestment,
      4 => l10n.mainTabProfile,
      _ => l10n.mainTabHome,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLanguage = ref.watch(appLanguageProvider);

    return Scaffold(
      key: const Key('home_page'),
      appBar: AppBar(
        title: Text(_tabTitle(context, widget.navigationShell.currentIndex)),
        actions: <Widget>[
          PopupMenuButton<AppLanguage>(
            key: const Key('language_menu_button'),
            initialValue: currentLanguage,
            onSelected: _switchLanguage,
            itemBuilder: (BuildContext context) {
              return AppLanguage.values.map((language) {
                return PopupMenuItem<AppLanguage>(
                  value: language,
                  child: Text(_languageLabel(context, language)),
                );
              }).toList();
            },
            icon: const Icon(Icons.language),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              key: const Key('logout_button'),
              onPressed: _isLoggingOut ? null : _logout,
              child: _isLoggingOut
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.homeLogout),
            ),
          ),
        ],
      ),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        key: const Key('main_tab_bar'),
        selectedIndex: widget.navigationShell.currentIndex,
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
            icon: const Icon(Icons.forum_outlined),
            selectedIcon: const Icon(Icons.forum_rounded),
            label: l10n.mainTabDiscussion,
          ),
          NavigationDestination(
            icon: const Icon(Icons.show_chart_outlined),
            selectedIcon: const Icon(Icons.show_chart_rounded),
            label: l10n.mainTabInvestment,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.mainTabProfile,
          ),
        ],
      ),
    );
  }
}
