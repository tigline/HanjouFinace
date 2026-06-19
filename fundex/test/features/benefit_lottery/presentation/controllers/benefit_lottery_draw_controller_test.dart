import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/benefit_lottery/presentation/controllers/benefit_lottery_draw_controller.dart';
import 'package:fundex/features/benefit_lottery/presentation/models/benefit_lottery_models.dart';
import 'package:fundex/features/benefit_lottery/presentation/support/benefit_lottery_mock_draw_source.dart';

void main() {
  late BenefitLotteryWheelModel model;

  setUp(() {
    model = BenefitLotteryWheelModel(
      prizes: const <BenefitLotteryPrize>[
        BenefitLotteryPrize(id: 'a', title: 'A prize', price: 30000),
        BenefitLotteryPrize(id: 'b', title: 'B prize', price: 10000),
        BenefitLotteryPrize(
          id: 'no-win',
          title: 'No prize',
          price: 0,
          isNoWin: true,
        ),
      ],
    );
  });

  test('uses the draw-source result instead of selecting locally', () async {
    final controller = BenefitLotteryDrawController(model: model);
    final source = BenefitLotteryMockDrawSource(
      delay: Duration.zero,
      fixedPrizeId: 'b',
    );

    final prize = await controller.draw(() => source.draw(model));

    expect(prize.id, 'b');
    expect(controller.selectedPrize?.id, 'b');
    expect(controller.phase, BenefitLotteryDrawPhase.spinning);

    controller.completeSpinAnimation(controller.spinSequence);

    expect(controller.phase, BenefitLotteryDrawPhase.completed);
  });

  test('moves to failed when the API returns an unknown prize id', () async {
    final controller = BenefitLotteryDrawController(model: model);

    await expectLater(
      controller.draw(
        () async => const BenefitLotteryDrawResult(prizeId: 'missing'),
      ),
      throwsStateError,
    );

    expect(controller.phase, BenefitLotteryDrawPhase.failed);
    expect(controller.error, isA<StateError>());
  });
}
