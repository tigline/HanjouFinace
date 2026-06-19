import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/benefit_lottery/presentation/models/benefit_lottery_models.dart';
import 'package:fundex/features/benefit_lottery/presentation/widgets/benefit_lottery_draw_dialog.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  testWidgets('opens with sixteen-point horizontal inset and returns result', (
    WidgetTester tester,
  ) async {
    final model = BenefitLotteryWheelModel(
      prizes: const <BenefitLotteryPrize>[
        BenefitLotteryPrize(id: 'a', title: 'A賞', price: 30000),
        BenefitLotteryPrize(id: 'b', title: 'B賞', price: 10000),
        BenefitLotteryPrize(
          id: 'no-win',
          title: 'はずれ',
          price: 0,
          isNoWin: true,
        ),
      ],
    );
    BenefitLotteryPrize? result;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () async {
                    result = await showBenefitLotteryDrawDialog(
                      context,
                      model: model,
                      drawRequest: () async =>
                          const BenefitLotteryDrawResult(prizeId: 'no-win'),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final dialog = tester.widget<Dialog>(
      find.byKey(const Key('benefit_lottery_draw_dialog')),
    );
    expect(
      dialog.insetPadding,
      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    );
    expect(find.text('ルーレットを回す'), findsNWidgets(2));
    expect(find.text('はずれ'), findsOneWidget);

    await tester.tap(find.byKey(const Key('benefit_lottery_primary_action')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('抽選結果を見る'), findsOneWidget);

    await tester.tap(find.byKey(const Key('benefit_lottery_primary_action')));
    await tester.pumpAndSettle();

    expect(result?.isNoWin, isTrue);
    expect(find.byKey(const Key('benefit_lottery_draw_dialog')), findsNothing);
  });
}
