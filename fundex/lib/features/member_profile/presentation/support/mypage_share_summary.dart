import '../../domain/entities/mypage_models.dart';

class MyPageShareSummary {
  const MyPageShareSummary({
    required this.investedAmount,
    required this.profitAmount,
  });

  final num investedAmount;
  final num profitAmount;

  double get profitRate {
    if (investedAmount <= 0) {
      return 0;
    }
    return profitAmount / investedAmount * 100;
  }

  factory MyPageShareSummary.fromRecords({
    required MyPageAccountStatistic? statistic,
    required List<MyPageInvestmentRecord>? records,
  }) {
    final investments = records ?? const <MyPageInvestmentRecord>[];
    final investedAmount = investments.fold<num>(
      0,
      (sum, record) =>
          sum + (record.investMoneyValid ?? record.investMoney ?? 0),
    );
    final recordProfit = investments.fold<num>(
      0,
      (sum, record) => sum + (record.earnings ?? 0),
    );
    return MyPageShareSummary(
      investedAmount: investedAmount,
      profitAmount: statistic?.crowdfundingDistributedBenefit ?? recordProfit,
    );
  }
}
