import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_section_support.dart';
import 'package:fundex/l10n/app_localizations_ja.dart';

void main() {
  group('sortApplyRecords', () {
    test('returns the latest three records regardless of status', () {
      final records = <MyPageApplyRecord>[
        _applyRecord('invalid', status: 5, applyTime: '2026-01-01T00:00:00Z'),
        _applyRecord('completed', status: 3, applyTime: '2026-04-01T00:00:00Z'),
        _applyRecord('applying', status: 0, applyTime: '2026-03-01T00:00:00Z'),
        _applyRecord('cancelled', status: 4, applyTime: '2026-02-01T00:00:00Z'),
      ];

      final result = sortApplyRecords(records, maxItems: 3);

      expect(result.map((record) => record.projectName), <String>[
        'completed',
        'applying',
        'cancelled',
      ]);
      expect(result.map((record) => record.status), <int?>[3, 0, 4]);
    });
  });

  group('filterInvestmentRecordsByActiveFundFilter', () {
    test('selects operating and ended records by project status', () {
      final records = <MyPageInvestmentRecord>[
        _record(projectId: 'operating', projectStatus: 4),
        _record(projectId: 'ended', projectStatus: 5),
        _record(projectId: 'closed', projectStatus: 3),
      ];

      final operating = filterInvestmentRecordsByActiveFundFilter(
        records,
        MyPageActiveFundFilter.operating,
      );
      final ended = filterInvestmentRecordsByActiveFundFilter(
        records,
        MyPageActiveFundFilter.ended,
      );

      expect(operating.map((record) => record.projectId), <String>[
        'operating',
      ]);
      expect(ended.map((record) => record.projectId), <String>['ended']);
    });
  });

  group('groupActiveInvestmentRecords', () {
    test('keeps the latest record project status on the grouped item', () {
      final records = <MyPageInvestmentRecord>[
        _record(
          projectId: 'p1',
          projectStatus: 4,
          createTime: '2026-01-01T00:00:00Z',
        ),
        _record(
          projectId: 'p1',
          projectStatus: 5,
          createTime: '2026-02-01T00:00:00Z',
        ),
      ];

      final groups = groupActiveInvestmentRecords(records);

      expect(groups, hasLength(1));
      expect(groups.single.projectStatus, 5);
    });

    test('preserves missing valid units instead of treating them as zero', () {
      final groups = groupActiveInvestmentRecords(<MyPageInvestmentRecord>[
        _record(projectId: 'p1', projectStatus: 4),
      ]);

      expect(groups.single.investNumValid, isNull);
    });

    test('keeps an explicit zero valid units value', () {
      final groups = groupActiveInvestmentRecords(<MyPageInvestmentRecord>[
        _record(projectId: 'p1', projectStatus: 4, investNumValid: 0),
      ]);

      expect(groups.single.investNumValid, 0);
    });
  });

  group('resolveMyPageActiveFundStatusLabel', () {
    final l10n = AppLocalizationsJa();

    test('uses redeemed status when valid units are explicitly zero', () {
      expect(
        resolveMyPageActiveFundStatusLabel(l10n, 4, investNumValid: 0),
        '償還済',
      );
    });

    test('keeps project status when valid units are unavailable', () {
      expect(
        resolveMyPageActiveFundStatusLabel(l10n, 4),
        l10n.fundListStatusOperating,
      );
    });
  });
}

MyPageApplyRecord _applyRecord(
  String projectName, {
  required int status,
  required String applyTime,
}) {
  return MyPageApplyRecord(
    projectName: projectName,
    status: status,
    applyTime: applyTime,
  );
}

MyPageInvestmentRecord _record({
  required String projectId,
  required int projectStatus,
  String createTime = '2026-01-01T00:00:00Z',
  int? investNumValid,
}) {
  return MyPageInvestmentRecord(
    projectId: projectId,
    projectName: 'Fund $projectId',
    projectStatus: projectStatus,
    createTime: createTime,
    investNumValid: investNumValid,
  );
}
