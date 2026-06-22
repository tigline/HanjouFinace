import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/benefit_lottery/presentation/widgets/benefit_lottery_draw_button.dart';

void main() {
  testWidgets('shows a circular loader and disables taps while loading', (
    WidgetTester tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: Scaffold(
          body: BenefitLotteryDrawButton(
            label: '抽選中',
            isLoading: true,
            onPressed: () => tapCount += 1,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(BenefitLotteryDrawButton));
    expect(tapCount, 0);
  });

  testWidgets('invokes the action when idle', (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: Scaffold(
          body: BenefitLotteryDrawButton(
            label: 'ルーレットを回す',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(BenefitLotteryDrawButton));
    expect(tapped, isTrue);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
