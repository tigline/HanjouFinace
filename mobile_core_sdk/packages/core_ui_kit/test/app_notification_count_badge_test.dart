import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpBadge(WidgetTester tester, int count) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppThemeFactory.light(),
        home: Scaffold(
          body: Center(child: AppNotificationCountBadge(count: count)),
        ),
      ),
    );
  }

  testWidgets('hides when there are no unread notifications', (tester) async {
    await pumpBadge(tester, 0);

    expect(find.text('0'), findsNothing);
    expect(tester.getSize(find.byType(AppNotificationCountBadge)), Size.zero);
  });

  testWidgets('uses a circle for one digit and expands for two digits', (
    tester,
  ) async {
    await pumpBadge(tester, 9);
    final singleDigitSize = tester.getSize(
      find.byType(AppNotificationCountBadge),
    );

    await pumpBadge(tester, 10);
    final twoDigitSize = tester.getSize(find.byType(AppNotificationCountBadge));

    expect(singleDigitSize, const Size.square(16));
    expect(twoDigitSize.height, 16);
    expect(twoDigitSize.width, greaterThan(singleDigitSize.width));
  });

  testWidgets('caps the displayed count at 99', (tester) async {
    await pumpBadge(tester, 120);

    expect(find.text('99'), findsOneWidget);
    expect(find.text('120'), findsNothing);
  });
}
