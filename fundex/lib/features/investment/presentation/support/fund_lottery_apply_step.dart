enum FundLotteryApplyStep {
  amountInput,
  contractDocuments,
  confirmApplication,
  submitted,
  selected,
  depositCompleted,
}

extension FundLotteryApplyStepX on FundLotteryApplyStep {
  int get index => FundLotteryApplyStep.values.indexOf(this);

  bool get isFirst => this == FundLotteryApplyStep.amountInput;

  FundLotteryApplyStep? get next {
    final current = index;
    if (current >= FundLotteryApplyStep.values.length - 1) {
      return null;
    }
    return FundLotteryApplyStep.values[current + 1];
  }

  FundLotteryApplyStep? get previous {
    final current = index;
    if (current == 0) {
      return null;
    }
    return FundLotteryApplyStep.values[current - 1];
  }
}
