import 'dart:math';

import '../models/benefit_lottery_models.dart';

class BenefitLotteryMockDrawSource {
  BenefitLotteryMockDrawSource({
    Random? random,
    this.delay = const Duration(milliseconds: 500),
    this.fixedPrizeId,
  }) : _random = random ?? Random();

  final Random _random;
  final Duration delay;
  final String? fixedPrizeId;

  Future<BenefitLotteryDrawResult> draw(BenefitLotteryWheelModel model) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    final configuredPrizeId = fixedPrizeId;
    if (configuredPrizeId != null) {
      model.prizeById(configuredPrizeId);
      return BenefitLotteryDrawResult(prizeId: configuredPrizeId);
    }

    final selectedPrize = model.prizes[_random.nextInt(model.prizes.length)];
    return BenefitLotteryDrawResult(prizeId: selectedPrize.id);
  }
}
