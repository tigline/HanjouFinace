import '../../domain/entities/x_account_models.dart';

class XAccountState {
  const XAccountState({
    required this.connection,
    required this.isLoading,
    required this.isStartingOAuth,
    required this.isCheckingConnection,
    required this.isDisconnecting,
    required this.isAwaitingAuthorization,
    this.error,
  });

  const XAccountState.initial()
    : connection = const XAccountConnection.disconnected(),
      isLoading = true,
      isStartingOAuth = false,
      isCheckingConnection = false,
      isDisconnecting = false,
      isAwaitingAuthorization = false,
      error = null;

  final XAccountConnection connection;
  final bool isLoading;
  final bool isStartingOAuth;
  final bool isCheckingConnection;
  final bool isDisconnecting;
  final bool isAwaitingAuthorization;
  final Object? error;

  bool get isBusy =>
      isLoading || isStartingOAuth || isCheckingConnection || isDisconnecting;

  XAccountState copyWith({
    XAccountConnection? connection,
    bool? isLoading,
    bool? isStartingOAuth,
    bool? isCheckingConnection,
    bool? isDisconnecting,
    bool? isAwaitingAuthorization,
    Object? error,
    bool clearError = false,
  }) {
    return XAccountState(
      connection: connection ?? this.connection,
      isLoading: isLoading ?? this.isLoading,
      isStartingOAuth: isStartingOAuth ?? this.isStartingOAuth,
      isCheckingConnection: isCheckingConnection ?? this.isCheckingConnection,
      isDisconnecting: isDisconnecting ?? this.isDisconnecting,
      isAwaitingAuthorization:
          isAwaitingAuthorization ?? this.isAwaitingAuthorization,
      error: clearError ? null : error ?? this.error,
    );
  }
}
