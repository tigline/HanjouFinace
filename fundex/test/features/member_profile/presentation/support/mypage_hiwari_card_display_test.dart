import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_hiwari_card_display.dart';
import 'package:fundex/l10n/app_localizations_ja.dart';

void main() {
  final l10n = AppLocalizationsJa();

  test('builds pre-operation explanation, badge, period, and day count', () {
    final display = buildMyPageHiwariCardDisplayData(
      l10n,
      const <MyPageHiwariJob>[
        MyPageHiwariJob(
          startDate: '2024-01-01',
          endDate: '2024-04-17',
          num: 20,
        ),
      ],
    );

    expect(display.explanation, l10n.myPageHiwariPreOpExplain);
    expect(display.blocks, hasLength(1));
    expect(
      display.blocks.single.badgeLabel,
      l10n.myPageHiwariPreOpProRataBadge,
    );
    expect(display.blocks.single.rows.first.label, '収益期間');
    expect(display.blocks.single.rows.first.value, '2024-01-01～2024-04-17');
    expect(display.blocks.single.rows.last.label, '対象日数');
    expect(display.blocks.single.rows.last.value, '20');
  });

  test('builds revenue base date and contracted units for a process job', () {
    final display = buildMyPageHiwariCardDisplayData(
      l10n,
      const <MyPageHiwariJob>[
        MyPageHiwariJob(processId: 'proc-1', startDate: '2026-05-20', num: 2),
      ],
    );

    expect(display.explanation, isNull);
    expect(display.blocks.single.badgeLabel, isNull);
    expect(display.blocks.single.rows.first.label, '収益基準日');
    expect(display.blocks.single.rows.first.value, '2026-05-20');
    expect(display.blocks.single.rows.last.label, '約定口数');
    expect(display.blocks.single.rows.last.value, '2');
  });

  test('uses the localized missing-value marker', () {
    final display = buildMyPageHiwariCardDisplayData(
      l10n,
      const <MyPageHiwariJob>[MyPageHiwariJob(processId: 'proc-1')],
    );

    expect(display.blocks.single.rows.first.value, '—');
    expect(display.blocks.single.rows.last.value, '—');
  });
}
