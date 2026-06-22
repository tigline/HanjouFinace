import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/benefit_lottery/presentation/models/benefit_lottery_models.dart';
import 'package:fundex/features/benefit_lottery/presentation/widgets/benefit_lottery_draw_dialog.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  testWidgets('returns to the draw action after each completed spin', (
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
    var drawCount = 0;

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
                  onPressed: () {
                    showBenefitLotteryDrawDialog(
                      context,
                      model: model,
                      drawRequest: () async {
                        drawCount += 1;
                        return const BenefitLotteryDrawResult(
                          prizeId: 'no-win',
                        );
                      },
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

    expect(find.text('抽選結果を見る'), findsNothing);
    expect(
      find.byKey(const Key('benefit_lottery_draw_dialog')),
      findsOneWidget,
    );
    expect(drawCount, 1);

    await tester.tap(find.byKey(const Key('benefit_lottery_primary_action')));
    await tester.pumpAndSettle();

    expect(drawCount, 2);
    expect(
      find.byKey(const Key('benefit_lottery_draw_dialog')),
      findsOneWidget,
    );
  });

  testWidgets('closes the dialog and invokes the details action', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final model = BenefitLotteryWheelModel(
      prizes: const <BenefitLotteryPrize>[
        BenefitLotteryPrize(id: 'a', title: 'A賞', price: 30000),
        BenefitLotteryPrize(
          id: 'no-win',
          title: 'はずれ',
          price: 0,
          isNoWin: true,
        ),
      ],
    );
    var detailsTapped = false;

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
                onPressed: () {
                  showBenefitLotteryDrawDialog(
                    context,
                    model: model,
                    drawRequest: () async =>
                        const BenefitLotteryDrawResult(prizeId: 'no-win'),
                    onDetailsTap: () => detailsTapped = true,
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
    await tester.tap(find.text('詳しく'));
    await tester.pumpAndSettle();

    expect(detailsTapped, isTrue);
    expect(find.byKey(const Key('benefit_lottery_draw_dialog')), findsNothing);
  });
}
