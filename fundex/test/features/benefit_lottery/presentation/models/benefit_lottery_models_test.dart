import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/benefit_lottery/presentation/models/benefit_lottery_models.dart';

void main() {
  test('accepts up to eight segments including one no-win segment', () {
    final model = BenefitLotteryWheelModel(
      prizes: <BenefitLotteryPrize>[
        for (var index = 0; index < 7; index++)
          BenefitLotteryPrize(
            id: 'prize-$index',
            title: 'Prize $index',
            price: (index + 1) * 1000,
          ),
        const BenefitLotteryPrize(
          id: 'no-win',
          title: 'No prize',
          price: 0,
          isNoWin: true,
        ),
      ],
    );

    expect(model.prizes, hasLength(8));
    expect(model.prizeById('no-win').isNoWin, isTrue);
  });

  test('rejects more than eight segments', () {
    expect(
      () => BenefitLotteryWheelModel(
        prizes: <BenefitLotteryPrize>[
          for (var index = 0; index < 8; index++)
            BenefitLotteryPrize(
              id: 'prize-$index',
              title: 'Prize $index',
              price: (index + 1) * 1000,
            ),
          const BenefitLotteryPrize(
            id: 'no-win',
            title: 'No prize',
            price: 0,
            isNoWin: true,
          ),
        ],
      ),
      throwsArgumentError,
    );
  });

  test('requires exactly one zero-price no-win segment', () {
    expect(
      () => BenefitLotteryWheelModel(
        prizes: const <BenefitLotteryPrize>[
          BenefitLotteryPrize(id: 'a', title: 'A', price: 30000),
          BenefitLotteryPrize(id: 'b', title: 'B', price: 10000),
        ],
      ),
      throwsArgumentError,
    );
  });
}
