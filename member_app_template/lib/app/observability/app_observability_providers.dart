import 'package:core_tool_kit/core_tool_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLoggerProvider = Provider<AppLogger>((ref) {
  throw UnimplementedError(
    'appLoggerProvider must be overridden from bootstrap.',
  );
});

enum AppUiMessageKey {
  requestFailed,
  networkUnavailable,
  authExpired,
  forbidden,
  serverUnavailable,
}

class AppUiMessage {
  const AppUiMessage({required this.id, required this.key});

  final int id;
  final AppUiMessageKey key;
}

class AppUiMessageController extends StateNotifier<AppUiMessage?> {
  AppUiMessageController() : super(null);

  void showError(AppUiMessageKey messageKey) {
    final now = DateTime.now().microsecondsSinceEpoch;
    state = AppUiMessage(id: now, key: messageKey);
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
