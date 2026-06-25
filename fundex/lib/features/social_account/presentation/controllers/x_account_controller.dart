import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/x_account_models.dart';
import '../../domain/usecases/x_account_usecases.dart';
import '../state/x_account_state.dart';

class XAccountController extends StateNotifier<XAccountState> {
  XAccountController(
    this._loadConnection,
    this._startOAuth,
    this._disconnectAccount,
  ) : super(const XAccountState.initial()) {
    unawaited(load());
  }

  final LoadXAccountConnectionUseCase _loadConnection;
  final StartXOAuthUseCase _startOAuth;
  final DisconnectXAccountUseCase _disconnectAccount;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final connection = await _loadConnection();
      if (state.isCheckingConnection) {
        state = state.copyWith(isLoading: false);
        return;
      }
      state = state.copyWith(
        connection: connection,
        isLoading: false,
        isAwaitingAuthorization: connection.isConnected
            ? false
            : state.isAwaitingAuthorization,
        clearError: true,
      );
    } catch (error) {
      if (state.isCheckingConnection) {
        state = state.copyWith(isLoading: false);
        return;
      }
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  Future<XOAuthAuthorization?> startOAuth() async {
    if (state.isBusy) {
      return null;
    }
    state = state.copyWith(isStartingOAuth: true, clearError: true);
    try {
      final authorization = await _startOAuth();
      state = state.copyWith(
        isStartingOAuth: false,
        isAwaitingAuthorization: true,
        connection: const XAccountConnection(status: XAccountStatus.connecting),
        clearError: true,
      );
      return authorization;
    } catch (error) {
      state = state.copyWith(isStartingOAuth: false, error: error);
      return null;
    }
  }

  Future<bool> disconnect() async {
    if (state.isBusy || !state.connection.isConnected) {
      return false;
    }
    state = state.copyWith(isDisconnecting: true, clearError: true);
    try {
      await _disconnectAccount();
      state = state.copyWith(
        connection: const XAccountConnection.disconnected(),
        isDisconnecting: false,
        isAwaitingAuthorization: false,
        clearError: true,
      );
      return true;
    } catch (error) {
      state = state.copyWith(isDisconnecting: false, error: error);
      return false;
    }
  }

  void cancelAuthorizationLaunch() {
    state = state.copyWith(
      connection: const XAccountConnection.disconnected(),
      isAwaitingAuthorization: false,
    );
  }

  Future<bool> confirmAuthorization({
    int maxAttempts = 3,
    Duration retryDelay = const Duration(milliseconds: 700),
    bool requireAwaitingAuthorization = true,
  }) async {
    if (state.isCheckingConnection ||
        (requireAwaitingAuthorization && !state.isAwaitingAuthorization)) {
      return state.connection.isConnected;
    }
    state = state.copyWith(isCheckingConnection: true, clearError: true);
    Object? lastError;
    final attempts = maxAttempts < 1 ? 1 : maxAttempts;
    for (var attempt = 0; attempt < attempts; attempt++) {
      try {
        final connection = await _loadConnection();
        if (connection.isConnected) {
          state = state.copyWith(
            connection: connection,
            isCheckingConnection: false,
            isAwaitingAuthorization: false,
            clearError: true,
          );
          return true;
        }
      } catch (error) {
        lastError = error;
      }
      if (attempt + 1 < attempts) {
        await Future<void>.delayed(retryDelay);
      }
    }
    state = state.copyWith(
      connection: const XAccountConnection.disconnected(),
      isCheckingConnection: false,
      isAwaitingAuthorization: false,
      error: lastError,
      clearError: lastError == null,
    );
    return false;
  }
}
