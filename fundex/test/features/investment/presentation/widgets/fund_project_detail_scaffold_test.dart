import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/investment/presentation/widgets/fund_project_detail_scaffold.dart';

void main() {
  testWidgets('state scaffold keeps a back action visible', (
    WidgetTester tester,
  ) async {
    var backCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(locale: const Locale('ja')),
        home: FundProjectDetailScaffold(
          onBack: () => backCount += 1,
          body: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));

    expect(backCount, 1);
  });
}
