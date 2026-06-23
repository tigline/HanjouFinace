import '../../domain/entities/x_account_models.dart';

class XAccountState {
  const XAccountState({
    required this.connection,
    required this.isLoading,
    required this.isStartingBinding,
    required this.isCheckingBinding,
    required this.isDisconnecting,
    this.activeAttemptId,
    this.error,
  });

  const XAccountState.initial()
    : connection = const XAccountConnection.disconnected(),
      isLoading = true,
      isStartingBinding = false,
      isCheckingBinding = false,
      isDisconnecting = false,
      activeAttemptId = null,
      error = null;

  final XAccountConnection connection;
  final bool isLoading;
  final bool isStartingBinding;
  final bool isCheckingBinding;
  final bool isDisconnecting;
  final String? activeAttemptId;
  final Object? error;

  bool get isBusy =>
      isLoading || isStartingBinding || isCheckingBinding || isDisconnecting;

  XAccountState copyWith({
    XAccountConnection? connection,
    bool? isLoading,
    bool? isStartingBinding,
    bool? isCheckingBinding,
    bool? isDisconnecting,
    String? activeAttemptId,
    bool clearActiveAttempt = false,
    Object? error,
    bool clearError = false,
  }) {
    return XAccountState(
      connection: connection ?? this.connection,
      isLoading: isLoading ?? this.isLoading,
      isStartingBinding: isStartingBinding ?? this.isStartingBinding,
      isCheckingBinding: isCheckingBinding ?? this.isCheckingBinding,
      isDisconnecting: isDisconnecting ?? this.isDisconnecting,
      activeAttemptId: clearActiveAttempt
          ? null
          : activeAttemptId ?? this.activeAttemptId,
      error: clearError ? null : error ?? this.error,
    );
  }
}
