class FundLotteryDocumentItem {
  const FundLotteryDocumentItem({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

class FundLotterySummaryRow {
  const FundLotterySummaryRow({required this.label, required this.value});

  final String label;
  final String value;
}

class FundLotteryDepositRow {
  const FundLotteryDepositRow({
    required this.label,
    required this.value,
    this.copyable = false,
  });

  final String label;
  final String value;
  final bool copyable;
}
