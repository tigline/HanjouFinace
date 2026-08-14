import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/hotel_booking/presentation/widgets/hotel_state_views.dart';
import 'package:fundex/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('full-page error can return from a direct-entry route', (
    WidgetTester tester,
  ) async {
    var retryCount = 0;
    final router = GoRouter(
      initialLocation: '/error',
      routes: <RouteBase>[
        GoRoute(
          path: '/error',
          builder: (context, state) => Scaffold(
            body: HotelFullPageError(onRetry: () => retryCount += 1),
          ),
        ),
        GoRoute(
          path: '/hotel-booking',
          builder: (context, state) =>
              const Scaffold(body: Text('Hotel booking')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );

    expect(find.text('重试'), findsOneWidget);
    expect(find.text('返回'), findsOneWidget);

    await tester.tap(find.text('重试'));
    expect(retryCount, 1);

    await tester.tap(find.text('返回'));
    await tester.pumpAndSettle();

    expect(find.text('Hotel booking'), findsOneWidget);
  });
}
