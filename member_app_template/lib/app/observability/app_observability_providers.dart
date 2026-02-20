import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLoggerProvider = Provider<AppLogger>((ref) {
  throw UnimplementedError(
    'appLoggerProvider must be overridden from bootstrap.',
  );
});

class AppUiMessage {
  const AppUiMessage({required this.id, required this.message});

  final int id;
  final String message;
}

class AppUiMessageController extends StateNotifier<AppUiMessage?> {
  AppUiMessageController() : super(null);

  void showError(String message) {
    final now = DateTime.now().microsecondsSinceEpoch;
    state = AppUiMessage(id: now, message: message);
  }

  void clearIfMatches(int messageId) {
    if (state?.id == messageId) {
      state = null;
    }
  }
}

final appUiMessageProvider =
    StateNotifierProvider<AppUiMessageController, AppUiMessage?>((ref) {
      return AppUiMessageController();
    });
