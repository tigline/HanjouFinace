import 'package:flutter/foundation.dart';

import '../models/benefit_lottery_models.dart';

typedef BenefitLotteryDrawRequest = Future<BenefitLotteryDrawResult> Function();

enum BenefitLotteryDrawPhase { idle, requesting, spinning, completed, failed }

class BenefitLotteryDrawController extends ChangeNotifier {
  BenefitLotteryDrawController({required this.model});

  final BenefitLotteryWheelModel model;

  BenefitLotteryDrawPhase _phase = BenefitLotteryDrawPhase.idle;
  BenefitLotteryPrize? _selectedPrize;
  Object? _error;
  int _spinSequence = 0;

  BenefitLotteryDrawPhase get phase => _phase;
  BenefitLotteryPrize? get selectedPrize => _selectedPrize;
  Object? get error => _error;
  int get spinSequence => _spinSequence;
  bool get isBusy =>
      _phase == BenefitLotteryDrawPhase.requesting ||
      _phase == BenefitLotteryDrawPhase.spinning;

  Future<BenefitLotteryPrize> draw(BenefitLotteryDrawRequest request) async {
    if (isBusy) {
      throw StateError('A lottery draw is already in progress.');
    }

    _phase = BenefitLotteryDrawPhase.requesting;
    _selectedPrize = null;
    _error = null;
    notifyListeners();

    try {
      final result = await request();
      final prize = model.prizeById(result.prizeId);
      _selectedPrize = prize;
      _phase = BenefitLotteryDrawPhase.spinning;
      _spinSequence += 1;
      notifyListeners();
      return prize;
    } catch (error) {
      _error = error;
      _phase = BenefitLotteryDrawPhase.failed;
      notifyListeners();
      rethrow;
    }
  }

  void completeSpinAnimation(int sequence) {
    if (_phase != BenefitLotteryDrawPhase.spinning ||
        sequence != _spinSequence) {
      return;
    }
    _phase = BenefitLotteryDrawPhase.completed;
    notifyListeners();
  }

  void reset() {
    if (isBusy) {
      return;
    }
    _phase = BenefitLotteryDrawPhase.idle;
    _selectedPrize = null;
    _error = null;
    notifyListeners();
  }
}
