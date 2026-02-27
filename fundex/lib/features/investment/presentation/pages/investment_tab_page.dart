import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/presentation/support/member_profile_action_guard.dart';

class InvestmentTabPage extends ConsumerWidget {
  const InvestmentTabPage({super.key});

  Future<void> _runTradeCheck(BuildContext context, WidgetRef ref) async {
    final allowed = await ref
        .read(memberProfileActionGuardProvider)
        .ensureCompleted(
          context,
          actionLabel: context.l10n.profileProtectedTradeAction,
        );
    if (!allowed || !context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.profileGuardPassMessage(
            context.l10n.profileProtectedTradeAction,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return ListView(
      key: const Key('investment_tab_content'),
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.investmentTabHeadline,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(l10n.investmentTabSubtitle),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _MiniStatCard(
                        label: l10n.investmentTabPortfolioLabel,
                        value: '8',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MiniStatCard(
                        label: l10n.investmentTabWatchlistLabel,
                        value: '23',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton(
                  key: const Key('simulate_trade_button'),
                  onPressed: () => _runTradeCheck(context, ref),
                  child: Text(l10n.profileProtectedTradeAction),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 6),
          Text(
            value,
            style: (Theme.of(context).textTheme.titleLarge ?? const TextStyle())
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
