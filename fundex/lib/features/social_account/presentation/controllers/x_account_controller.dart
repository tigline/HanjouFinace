import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/x_account_models.dart';
import '../../domain/usecases/x_account_usecases.dart';
import '../state/x_account_state.dart';
import '../support/x_oauth_callback.dart';

class XAccountController extends StateNotifier<XAccountState> {
  XAccountController(
    this._loadConnection,
    this._startBinding,
    this._completeBinding,
    this._disconnect,
  ) : super(const XAccountState.initial()) {
    unawaited(load());
  }

  final LoadXAccountConnectionUseCase _loadConnection;
  final StartXAccountBindingUseCase _startBinding;
  final CompleteXAccountBindingUseCase _completeBinding;
  final DisconnectXAccountUseCase _disconnect;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final connection = await _loadConnection();
      if (state.isCheckingBinding) {
        state = state.copyWith(isLoading: false);
        return;
      }
      state = state.copyWith(
        connection: connection,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      if (state.isCheckingBinding) {
        state = state.copyWith(isLoading: false);
        return;
      }
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  Future<XBindingAttempt?> startBinding() async {
    if (state.isBusy) {
      return null;
    }
    state = state.copyWith(isStartingBinding: true, clearError: true);
    try {
      final attempt = await _startBinding(
        callbackUri: XOAuthCallback.callbackUri,
      );
      state = state.copyWith(
        isStartingBinding: false,
        activeAttemptId: attempt.attemptId,
        connection: const XAccountConnection(status: XAccountStatus.connecting),
        clearError: true,
      );
      return attempt;
    } catch (error) {
      state = state.copyWith(isStartingBinding: false, error: error);
      return null;
    }
  }

  Future<bool> handleCallback(XOAuthCallback callback) async {
    if (state.isCheckingBinding || callback.wasCancelled) {
      if (callback.wasCancelled) {
        state = state.copyWith(
          connection: const XAccountConnection.disconnected(),
          clearActiveAttempt: true,
        );
      }
      return false;
    }
    final activeAttemptId = state.activeAttemptId;
    if (activeAttemptId != null && activeAttemptId != callback.attemptId) {
      return false;
    }
    state = state.copyWith(isCheckingBinding: true, clearError: true);
    try {
      final result = await _completeBinding(attemptId: callback.attemptId);
      final connected = result.status == XAccountStatus.connected;
      state = state.copyWith(
        connection: result.connection,
        isCheckingBinding: false,
        clearActiveAttempt: connected,
        clearError: true,
      );
      return connected;
    } catch (error) {
      state = state.copyWith(isCheckingBinding: false, error: error);
      return false;
    }
  }

  Future<bool> disconnect() async {
    if (state.isBusy || !state.connection.isConnected) {
      return false;
    }
    state = state.copyWith(isDisconnecting: true, clearError: true);
    try {
      await _disconnect();
      state = state.copyWith(
        connection: const XAccountConnection.disconnected(),
        isDisconnecting: false,
        clearActiveAttempt: true,
        clearError: true,
      );
      return true;
    } catch (error) {
      state = state.copyWith(isDisconnecting: false, error: error);
      return false;
    }
  }
}
