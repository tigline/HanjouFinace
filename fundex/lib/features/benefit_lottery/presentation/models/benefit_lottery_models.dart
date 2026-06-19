class BenefitLotteryPrize {
  const BenefitLotteryPrize({
    required this.id,
    required this.title,
    required this.price,
    this.isNoWin = false,
  });

  final String id;
  final String title;
  final int price;
  final bool isNoWin;
}

class BenefitLotteryWheelModel {
  BenefitLotteryWheelModel({required Iterable<BenefitLotteryPrize> prizes})
    : prizes = List<BenefitLotteryPrize>.unmodifiable(prizes) {
    if (this.prizes.length < 2) {
      throw ArgumentError.value(
        this.prizes.length,
        'prizes',
        'At least one prize and one no-win segment are required.',
      );
    }
    if (this.prizes.length > maximumPrizeCount) {
      throw ArgumentError.value(
        this.prizes.length,
        'prizes',
        'A circular wheel supports at most $maximumPrizeCount segments.',
      );
    }

    final ids = this.prizes.map((prize) => prize.id.trim()).toSet();
    if (ids.length != this.prizes.length || ids.contains('')) {
      throw ArgumentError.value(
        this.prizes,
        'prizes',
        'Prize ids must be non-empty and unique.',
      );
    }
    if (this.prizes.any((prize) => prize.title.trim().isEmpty)) {
      throw ArgumentError.value(
        this.prizes,
        'prizes',
        'Prize titles must not be empty.',
      );
    }
    if (this.prizes.any((prize) => prize.price < 0)) {
      throw ArgumentError.value(
        this.prizes,
        'prizes',
        'Prize prices must not be negative.',
      );
    }

    final noWinPrizes = this.prizes.where((prize) => prize.isNoWin).toList();
    if (noWinPrizes.length != 1 || noWinPrizes.single.price != 0) {
      throw ArgumentError.value(
        this.prizes,
        'prizes',
        'Exactly one no-win segment with a zero price is required.',
      );
    }
  }

  static const int maximumPrizeCount = 8;

  final List<BenefitLotteryPrize> prizes;

  BenefitLotteryPrize prizeById(String prizeId) {
    return prizes.firstWhere(
      (prize) => prize.id == prizeId,
      orElse: () => throw StateError('Unknown lottery prize id: $prizeId'),
    );
  }

  int indexOfPrize(String prizeId) {
    final index = prizes.indexWhere((prize) => prize.id == prizeId);
    if (index < 0) {
      throw StateError('Unknown lottery prize id: $prizeId');
    }
    return index;
  }
}

class BenefitLotteryDrawResult {
  const BenefitLotteryDrawResult({required this.prizeId});

  final String prizeId;
}
