class XOAuthCallback {
  const XOAuthCallback({
    required this.attemptId,
    required this.result,
    required this.receivedAt,
  });

  static const String callbackScheme = 'stellavia';
  static const String callbackHost = 'oauth';
  static const String callbackPath = '/x/result';

  static Uri get callbackUri =>
      Uri(scheme: callbackScheme, host: callbackHost, path: callbackPath);

  final String attemptId;
  final String result;
  final DateTime receivedAt;

  bool get wasCancelled => result == 'cancelled' || result == 'denied';

  static XOAuthCallback? tryParse(Uri uri) {
    if (uri.scheme.toLowerCase() != callbackScheme ||
        uri.host.toLowerCase() != callbackHost ||
        uri.path != callbackPath) {
      return null;
    }
    final attemptId = uri.queryParameters['attemptId']?.trim() ?? '';
    if (attemptId.isEmpty) {
      return null;
    }
    return XOAuthCallback(
      attemptId: attemptId,
      result: uri.queryParameters['result']?.trim().toLowerCase() ?? 'unknown',
      receivedAt: DateTime.now(),
    );
  }
}
