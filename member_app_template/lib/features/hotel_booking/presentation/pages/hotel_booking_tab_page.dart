import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/presentation/support/member_profile_action_guard.dart';

class HotelBookingTabPage extends ConsumerWidget {
  const HotelBookingTabPage({super.key});

  Future<void> _runBookingCheck(BuildContext context, WidgetRef ref) async {
    final allowed = await ref
        .read(memberProfileActionGuardProvider)
        .ensureCompleted(
          context,
          actionLabel: context.l10n.profileProtectedBookingAction,
        );
    if (!allowed || !context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.profileGuardPassMessage(
            context.l10n.profileProtectedBookingAction,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return ListView(
      key: const Key('hotel_tab_content'),
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.hotelTabHeadline,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(l10n.hotelTabSubtitle),
                const SizedBox(height: 12),
                FilledButton(
                  key: const Key('simulate_booking_button'),
                  onPressed: () => _runBookingCheck(context, ref),
                  child: Text(l10n.profileProtectedBookingAction),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _PlaceholderListCard(
          title: 'Tokyo Business Stay',
          subtitle: 'Shinagawa, Tokyo',
          trailing: '¥18,000 / night',
          icon: Icons.apartment_rounded,
        ),
        const SizedBox(height: 12),
        const _PlaceholderListCard(
          title: 'Osaka Family Suite',
          subtitle: 'Namba, Osaka',
          trailing: '¥26,500 / night',
          icon: Icons.hotel_rounded,
        ),
      ],
    );
  }
}

class _PlaceholderListCard extends StatelessWidget {
  const _PlaceholderListCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          trailing,
          style: Theme.of(context).textTheme.labelLarge,
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
