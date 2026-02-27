import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HomeOverviewTabPage extends ConsumerWidget {
  const HomeOverviewTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return ListView(
      key: const Key('home_tab_content'),
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: <Color>[
                theme.colorScheme.primary,
                theme.colorScheme.primaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.homeHeroTitle,
                style: (theme.textTheme.titleLarge ?? const TextStyle())
                    .copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.homeHeroSubtitle,
                style: (theme.textTheme.bodyMedium ?? const TextStyle())
                    .copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                    ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  _MetricPill(
                    label: l10n.homeHeroAssetsLabel,
                    value: '¥12,580,400',
                    darkText: theme.colorScheme.onPrimary,
                  ),
                  _MetricPill(
                    label: l10n.homeHeroPnlLabel,
                    value: '+¥186,240',
                    darkText: theme.colorScheme.onPrimary,
                  ),
                  _MetricPill(
                    label: l10n.homeHeroCashLabel,
                    value: '¥1,056,000',
                    darkText: theme.colorScheme.onPrimary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
    required this.darkText,
  });

  final String label;
  final String value;
  final Color darkText;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 132),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: darkText.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
