import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/presentation/widgets/mypage_active_fund_detail_sections.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  testWidgets('renders the operation period in the overview card', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: ActiveFundOverviewHeroCard(
              title: '白馬ホテルファンド',
              statusLabel: '運用中',
              statusBackgroundColor: Colors.white,
              statusForegroundColor: Colors.black,
              totalBenefitLabel: '累計分配金',
              totalBenefitValue: '¥28,500',
              primaryMetrics: <ActiveFundOverviewMetricData>[],
              secondaryMetrics: <ActiveFundOverviewMetricData>[],
              periodLabel: '運用期間',
              periodValue: '2026/04～2027/03',
              investorCode: '優先投資者',
              returnText: '想定利回り 6%',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('運用期間'), findsOneWidget);
    expect(find.text('2026/04～2027/03'), findsOneWidget);
    expect(find.byIcon(Icons.calendar_month_outlined), findsOneWidget);
    expect(find.text('優先投資者'), findsOneWidget);
    expect(find.text('想定利回り 6%'), findsOneWidget);
    expect(find.byIcon(Icons.badge_outlined), findsOneWidget);
  });
}
