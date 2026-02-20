import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLanguage = ref.watch(appLanguageProvider);

    return Scaffold(
      key: const Key('home_page'),
      appBar: AppBar(
        title: Text(l10n.homeTitle),
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
          TextButton(
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
        ],
      ),
      body: Center(child: Text(l10n.homeTitle)),
    );
  }
}
