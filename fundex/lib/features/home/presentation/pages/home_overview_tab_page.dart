import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class HomeOverviewTabPage extends StatelessWidget {
  const HomeOverviewTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final reminders = <FundReminderData>[
      FundReminderData(
        leading: const Text('📋', style: TextStyle(fontSize: 20)),
        title: l10n.homeReminderProfileTitle,
        message: l10n.homeReminderProfileBody,
        progress: 0.4,
        onTap: () {
          final route = Uri(
            path: '/member-profile/onboarding',
            queryParameters: <String, String>{'next': '/home'},
          ).toString();
          context.push(route);
        },
      ),
      FundReminderData(
        leading: const Text('⏰', style: TextStyle(fontSize: 20)),
        title: l10n.homeReminderCoolingOffTitle,
        message: l10n.homeReminderCoolingOffBody,
        actionLabel: l10n.homeReminderCoolingOffAction,
        onActionTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.homeReminderCoolingOffAction)),
          );
        },
      ),
    ];

    final featuredFunds = <FundFeaturedFundCardData>[
      FundFeaturedFundCardData(
        title: l10n.homeMockFeaturedFundA,
        annualYield: '8.5%',
        metadata: l10n.homeMockFeaturedMetaA,
        progress: 0.72,
        tags: <FundFeaturedFundTagData>[
          FundFeaturedFundTagData(
            label: l10n.homeTagOpen,
            backgroundColor: AppColorTokens.fundexSuccess.withValues(
              alpha: 0.9,
            ),
            foregroundColor: Colors.white,
          ),
          FundFeaturedFundTagData(
            label: l10n.homeTagLottery,
            backgroundColor: AppColorTokens.fundexPink.withValues(alpha: 0.85),
            foregroundColor: Colors.white,
          ),
        ],
        artworkGradientColors: const <Color>[
          Color(0xFF0F172A),
          Color(0xFF1E3A5F),
          Color(0xFF2563EB),
        ],
        onTap: () => context.go('/funds'),
      ),
      FundFeaturedFundCardData(
        title: l10n.homeMockFeaturedFundB,
        annualYield: '6.2%',
        metadata: l10n.homeMockFeaturedMetaB,
        progress: 0.45,
        tags: <FundFeaturedFundTagData>[
          FundFeaturedFundTagData(
            label: l10n.homeTagOpen,
            backgroundColor: AppColorTokens.fundexSuccess.withValues(
              alpha: 0.9,
            ),
            foregroundColor: Colors.white,
          ),
          FundFeaturedFundTagData(
            label: l10n.homeTagLottery,
            backgroundColor: AppColorTokens.fundexPink.withValues(alpha: 0.85),
            foregroundColor: Colors.white,
          ),
        ],
        artworkGradientColors: const <Color>[
          Color(0xFF7C2D12),
          Color(0xFFC2410C),
          Color(0xFFF97316),
        ],
        onTap: () => context.go('/funds'),
      ),
      FundFeaturedFundCardData(
        title: l10n.homeMockFeaturedFundC,
        annualYield: '10.0%',
        metadata: l10n.homeMockFeaturedMetaC,
        progress: 0.18,
        tags: <FundFeaturedFundTagData>[
          FundFeaturedFundTagData(
            label: l10n.homeTagUpcoming,
            backgroundColor: AppColorTokens.fundexWarning.withValues(
              alpha: 0.92,
            ),
            foregroundColor: Colors.white,
          ),
        ],
        artworkGradientColors: const <Color>[
          Color(0xFF14532D),
          Color(0xFF166534),
          Color(0xFF22C55E),
        ],
        onTap: () => context.go('/funds'),
      ),
    ];

    final activeFunds = <FundActiveFundCardData>[
      FundActiveFundCardData(
        title: l10n.homeMockActiveFundA,
        annualYield: '7.2%',
        rows: <FundLabeledValue>[
          FundLabeledValue(
            label: l10n.homeInvestedAmountLabel,
            value: '¥1,000,000',
          ),
          FundLabeledValue(
            label: l10n.homeNextDividendLabel,
            value: '2025/03/15',
          ),
        ],
        progress: 0.65,
        progressColor: AppColorTokens.fundexSuccess,
        onTap: () => context.go('/funds'),
      ),
      FundActiveFundCardData(
        title: l10n.homeMockActiveFundB,
        annualYield: '5.8%',
        rows: <FundLabeledValue>[
          FundLabeledValue(
            label: l10n.homeInvestedAmountLabel,
            value: '¥500,000',
          ),
          FundLabeledValue(
            label: l10n.homeNextDividendLabel,
            value: '2025/04/01',
          ),
        ],
        onTap: () => context.go('/funds'),
      ),
      FundActiveFundCardData(
        title: l10n.homeMockActiveFundC,
        annualYield: '6.1%',
        rows: <FundLabeledValue>[
          FundLabeledValue(
            label: l10n.homeInvestedAmountLabel,
            value: '¥800,000',
          ),
          FundLabeledValue(
            label: l10n.homeNextDividendLabel,
            value: '2025/04/18',
          ),
        ],
        onTap: () => context.go('/funds'),
      ),
      FundActiveFundCardData(
        title: l10n.homeMockActiveFundD,
        annualYield: '5.3%',
        rows: <FundLabeledValue>[
          FundLabeledValue(
            label: l10n.homeInvestedAmountLabel,
            value: '¥300,000',
          ),
          FundLabeledValue(
            label: l10n.homeNextDividendLabel,
            value: '2025/05/02',
          ),
        ],
        onTap: () => context.go('/funds'),
      ),
    ];

    return ListView(
      key: const Key('home_tab_content'),
      padding: EdgeInsets.zero,
      children: <Widget>[
        FundHomeHeroSummary(
          greeting: l10n.homeWelcomeUser('田中さん'),
          totalAssetsLabel: l10n.homeHeroTotalAssetsAmountLabel,
          totalAssetsValue: '¥3,850,000',
          totalAssetsDelta: l10n.homeHeroMonthlyDelta,
          activeInvestmentLabel: l10n.homeHeroActiveInvestmentLabel,
          activeInvestmentValue: '¥3,200,000',
          totalDividendsLabel: l10n.homeHeroTotalDividendsLabel,
          totalDividendsValue: '¥285,000',
          showNotificationDot: true,
          onNotificationTap: () => context.push('/notifications'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FundReminderFeed(items: reminders),
              const SizedBox(height: UiTokens.spacing16),
              FundSectionHeader(
                title: l10n.homeFeaturedFundsTitle,
                actionLabel: l10n.homeViewAllAction,
                onActionTap: () => context.go('/funds'),
              ),
              const SizedBox(height: UiTokens.spacing8),
              FundFeaturedFundCarousel(
                items: featuredFunds,
                yieldLabel: l10n.homeEstimatedYieldLabel,
              ),
              const SizedBox(height: UiTokens.spacing16),
              FundSectionHeader(title: l10n.homeActiveFundsTitle),
              const SizedBox(height: UiTokens.spacing8),
              FundActiveFundsList(
                items: activeFunds,
                showMoreLabel: l10n.homeShowMoreAction,
                showLessLabel: l10n.homeShowLessAction,
                initialVisibleCount: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
