enum AuthFailureReason {
  missingRefreshToken,
  refreshReturnedNull,
  refreshRequestFailed,
  retryExhausted,
}

abstract class AuthFailureHandler {
  Future<void> onAuthFailure(AuthFailureReason reason);
}

class NoopAuthFailureHandler implements AuthFailureHandler {
  const NoopAuthFailureHandler();

  @override
  Future<void> onAuthFailure(AuthFailureReason reason) async {}
}
