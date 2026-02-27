import 'dart:async';

class CodeSendCooldown {
  CodeSendCooldown({required void Function() onChanged, this.totalSeconds = 60})
    : _onChanged = onChanged;

  final int totalSeconds;
  final void Function() _onChanged;

  Timer? _timer;
  int _remainingSeconds = 0;

  int get remainingSeconds => _remainingSeconds;
  bool get isActive => _remainingSeconds > 0;

  void start() {
    _timer?.cancel();
    _remainingSeconds = totalSeconds;
    _onChanged();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        _remainingSeconds = 0;
        timer.cancel();
        _onChanged();
        return;
      }

      _remainingSeconds -= 1;
      _onChanged();
    });
  }

  void reset() {
    _timer?.cancel();
    if (_remainingSeconds == 0) {
      return;
    }
    _remainingSeconds = 0;
    _onChanged();
  }

  void dispose() {
    _timer?.cancel();
  }
}
