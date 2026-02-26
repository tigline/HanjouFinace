import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';

import '../providers/member_profile_providers.dart';
import '../support/member_profile_action_guard.dart';

class ProfileCenterTabPage extends ConsumerWidget {
  const ProfileCenterTabPage({super.key});

  Future<void> _runProtectedActionCheck(
    BuildContext context,
    WidgetRef ref, {
    required String actionLabel,
  }) async {
    final allowed = await ref
        .read(memberProfileActionGuardProvider)
        .ensureCompleted(context, actionLabel: actionLabel);
    if (!allowed || !context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.profileGuardPassMessage(actionLabel)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profileCompletion = ref.watch(isMemberProfileCompletedProvider);

    return ListView(
      key: const Key('profile_tab_content'),
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.profileTabHeadline,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(l10n.profileTabSubtitle),
                const SizedBox(height: 12),
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
                    OutlinedButton(
                      onPressed: () => _runProtectedActionCheck(
                        context,
                        ref,
                        actionLabel: l10n.profileProtectedBookingAction,
                      ),
                      child: Text(l10n.profileProtectedBookingAction),
                    ),
                    OutlinedButton(
                      onPressed: () => _runProtectedActionCheck(
                        context,
                        ref,
                        actionLabel: l10n.profileProtectedTradeAction,
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
    );
  }
}
