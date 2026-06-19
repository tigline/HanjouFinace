import 'package:fundex/l10n/app_localizations.dart';

import '../models/benefit_lottery_models.dart';

BenefitLotteryWheelModel buildBenefitLotteryMockWheelModel(
  AppLocalizations l10n,
) {
  return BenefitLotteryWheelModel(
    prizes: <BenefitLotteryPrize>[
      BenefitLotteryPrize(
        id: 's',
        title: l10n.benefitLotteryMockPrizeTitle('S'),
        price: 100000,
      ),
      BenefitLotteryPrize(
        id: 'a',
        title: l10n.benefitLotteryMockPrizeTitle('A'),
        price: 30000,
      ),
      BenefitLotteryPrize(
        id: 'b',
        title: l10n.benefitLotteryMockPrizeTitle('B'),
        price: 10000,
      ),
      BenefitLotteryPrize(
        id: 'c',
        title: l10n.benefitLotteryMockPrizeTitle('C'),
        price: 3000,
      ),
      BenefitLotteryPrize(
        id: 'd',
        title: l10n.benefitLotteryMockPrizeTitle('D'),
        price: 1000,
      ),
      BenefitLotteryPrize(
        id: 'no-win',
        title: l10n.benefitLotteryNoWinTitle,
        price: 0,
        isNoWin: true,
      ),
    ],
  );
}
