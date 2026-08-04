import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_hiwari_card_display.dart';
import 'package:fundex/features/member_profile/presentation/widgets/my_page_hiwari_info_card.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  testWidgets('renders hiwari information in the detail section card', (
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
            child: MyPageHiwariInfoCard(
              data: MyPageHiwariCardDisplayData(
                explanation: '運用開始日前の収益に関する説明',
                blocks: <MyPageHiwariCardBlockData>[
                  MyPageHiwariCardBlockData(
                    rows: <MyPageHiwariCardRowData>[
                      MyPageHiwariCardRowData(
                        label: '収益基準日',
                        value: '2026-05-20',
                      ),
                      MyPageHiwariCardRowData(label: '約定口数', value: '2'),
                    ],
                  ),
                  MyPageHiwariCardBlockData(
                    badgeLabel: '運用開始前の日割り収益',
                    rows: <MyPageHiwariCardRowData>[
                      MyPageHiwariCardRowData(
                        label: '収益期間',
                        value: '2026-04-01～2026-04-17',
                      ),
                      MyPageHiwariCardRowData(label: '対象日数', value: '17'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('日割り収益情報'), findsOneWidget);
    expect(find.text('運用開始日前の収益に関する説明'), findsOneWidget);
    expect(find.text('収益基準日'), findsOneWidget);
    expect(find.text('約定口数'), findsOneWidget);
    expect(find.text('運用開始前の日割り収益'), findsOneWidget);
    expect(find.text('収益期間'), findsOneWidget);
    expect(find.text('対象日数'), findsOneWidget);
  });
}
