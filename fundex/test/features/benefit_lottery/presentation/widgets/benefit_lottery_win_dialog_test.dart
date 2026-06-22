import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/benefit_lottery/presentation/models/benefit_lottery_models.dart';
import 'package:fundex/features/benefit_lottery/presentation/widgets/benefit_lottery_win_dialog.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  testWidgets('shows the winning design and confirms the result', (
    WidgetTester tester,
  ) async {
    bool? confirmed;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: FilledButton(
                onPressed: () async {
                  confirmed = await showBenefitLotteryWinDialog(
                    context,
                    prize: const BenefitLotteryPrize(
                      id: 'a',
                      title: 'A賞',
                      price: 30000,
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('benefit_lottery_win_dialog')), findsOneWidget);
    expect(find.text('当選おめでとうございます！'), findsOneWidget);
    expect(find.text('A賞 宿泊優待券に当選しました'), findsOneWidget);
    expect(find.text('¥30,000'), findsOneWidget);

    await tester.tap(find.byKey(const Key('benefit_lottery_win_confirm')));
    await tester.pumpAndSettle();

    expect(confirmed, isTrue);
    expect(find.byKey(const Key('benefit_lottery_win_dialog')), findsNothing);
  });
}
