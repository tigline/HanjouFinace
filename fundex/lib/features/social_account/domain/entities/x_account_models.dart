enum XAccountStatus { disconnected, connecting, connected, expired }

class XAccountConnection {
  const XAccountConnection({
    required this.status,
    this.xUserId,
    this.username,
    this.displayName,
    this.avatarUrl,
    this.connectedAt,
  });

  const XAccountConnection.disconnected()
    : status = XAccountStatus.disconnected,
      xUserId = null,
      username = null,
      displayName = null,
      avatarUrl = null,
      connectedAt = null;

  final XAccountStatus status;
  final String? xUserId;
  final String? username;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? connectedAt;

  bool get isConnected => status == XAccountStatus.connected;
}

class XBindingAttempt {
  const XBindingAttempt({
    required this.attemptId,
    required this.authorizationUri,
    this.expiresAt,
  });

  final String attemptId;
  final Uri authorizationUri;
  final DateTime? expiresAt;
}

class XBindingStatus {
  const XBindingStatus({
    required this.attemptId,
    required this.status,
    required this.connection,
    this.errorCode,
  });

  final String attemptId;
  final XAccountStatus status;
  final XAccountConnection connection;
  final String? errorCode;
}
