import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_share_summary.dart';

void main() {
  test('summarizes invested amount, profit, and profit rate', () {
    final summary = MyPageShareSummary.fromRecords(
      statistic: const MyPageAccountStatistic(
        crowdfundingDistributedBenefit: 300,
      ),
      records: const <MyPageInvestmentRecord>[
        MyPageInvestmentRecord(
          projectId: '1',
          projectName: 'A',
          investMoney: 1000,
          investMoneyValid: 800,
          earnings: 100,
        ),
        MyPageInvestmentRecord(
          projectId: '2',
          projectName: 'B',
          investMoney: 1200,
          earnings: 200,
        ),
      ],
    );

    expect(summary.investedAmount, 2000);
    expect(summary.profitAmount, 300);
    expect(summary.profitRate, 15);
  });

  test('falls back to record earnings and avoids division by zero', () {
    final summary = MyPageShareSummary.fromRecords(
      statistic: null,
      records: const <MyPageInvestmentRecord>[
        MyPageInvestmentRecord(projectId: '1', projectName: 'A', earnings: 42),
      ],
    );

    expect(summary.investedAmount, 0);
    expect(summary.profitAmount, 42);
    expect(summary.profitRate, 0);
  });
}
