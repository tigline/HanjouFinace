import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_locale_providers.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../member_profile/presentation/support/member_profile_action_guard.dart';

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

  Future<void> _runProtectedActionCheck(String actionLabel) async {
    final allowed = await ref
        .read(memberProfileActionGuardProvider)
        .ensureCompleted(context, actionLabel: actionLabel);
    if (!allowed || !mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.profileGuardPassMessage(actionLabel)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLanguage = ref.watch(appLanguageProvider);
    final profileCompletion = ref.watch(isMemberProfileCompletedProvider);

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.profileStatusCardTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  profileCompletion.when(
                    data: (bool isCompleted) => Text(
                      isCompleted
                          ? l10n.profileStatusCompleted
                          : l10n.profileStatusIncomplete,
                    ),
                    loading: () => const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => Text(l10n.profileStatusLoadFailed),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      FilledButton.tonal(
                        key: const Key('profile_edit_entry_button'),
                        onPressed: () => context.push('/member-profile/edit'),
                        child: Text(l10n.profileEditEntryButton),
                      ),
                      FilledButton(
                        key: const Key('simulate_booking_button'),
                        onPressed: () => _runProtectedActionCheck(
                          l10n.profileProtectedBookingAction,
                        ),
                        child: Text(l10n.profileProtectedBookingAction),
                      ),
                      FilledButton(
                        key: const Key('simulate_trade_button'),
                        onPressed: () => _runProtectedActionCheck(
                          l10n.profileProtectedTradeAction,
                        ),
                        child: Text(l10n.profileProtectedTradeAction),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
