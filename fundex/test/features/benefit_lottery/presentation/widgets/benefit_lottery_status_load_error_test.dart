import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/benefit_lottery/presentation/widgets/benefit_lottery_status_content_view.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  testWidgets('load error exposes retry and back actions', (
    WidgetTester tester,
  ) async {
    var retryCount = 0;
    var backCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppThemeFactory.light(locale: const Locale('zh')),
        home: Scaffold(
          body: BenefitLotteryStatusLoadError(
            onRetry: () => retryCount += 1,
            onBack: () => backCount += 1,
          ),
        ),
      ),
    );

    expect(find.text('重试'), findsOneWidget);
    expect(find.text('返回'), findsOneWidget);

    await tester.tap(find.text('重试'));
    await tester.tap(find.text('返回'));

    expect(retryCount, 1);
    expect(backCount, 1);
  });
}
