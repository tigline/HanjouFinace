import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/home/presentation/widgets/home_lottery_entry_bar.dart';

void main() {
  testWidgets('renders lottery copy and wheel asset', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: const Scaffold(
          body: HomeLotteryEntryBar(
            title: '抽選チャンス',
            body: '毎日1回、ルーレットを回して宿泊優待券を当てましょう。',
            actionLabel: '抽選する',
          ),
        ),
      ),
    );

    expect(find.text('抽選チャンス'), findsOneWidget);
    expect(find.text('毎日1回、ルーレットを回して宿泊優待券を当てましょう。'), findsOneWidget);
    expect(find.text('抽選する'), findsOneWidget);
    expect(find.byKey(const Key('home_lottery_prize_wheel')), findsOneWidget);
  });

  testWidgets('forwards taps when the entry becomes actionable', (
    WidgetTester tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: Scaffold(
          body: HomeLotteryEntryBar(
            title: '抽選チャンス',
            body: 'ルーレットを回しましょう。',
            actionLabel: '抽選する',
            onTap: () => tapCount += 1,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(HomeLotteryEntryBar));

    expect(tapCount, 1);
  });
}
