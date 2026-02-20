import 'package:core_network/core_network.dart';
import 'package:core_tool_kit/core_tool_kit.dart';

class AppAuthFailureHandler implements AuthFailureHandler {
  AppAuthFailureHandler({
    required AppLogger logger,
    required Future<void> Function() onSignedOut,
    required void Function(String message) reportErrorMessage,
  }) : _logger = logger,
       _onSignedOut = onSignedOut,
       _reportErrorMessage = reportErrorMessage;

  final AppLogger _logger;
  final Future<void> Function() _onSignedOut;
  final void Function(String message) _reportErrorMessage;

  @override
  Future<void> onAuthFailure(AuthFailureReason reason) async {
    _logger.warning(
      'Authentication failure handled',
      context: <String, Object?>{'reason': reason.name},
    );
    _reportErrorMessage('登录状态已失效，请重新登录');
    await _onSignedOut();
  }
}
