enum XAccountStatus { disconnected, connecting, connected }

class XAccountConnection {
  const XAccountConnection({
    required this.status,
    this.username,
    this.displayName,
    this.avatarUrl,
  });

  const XAccountConnection.disconnected()
    : status = XAccountStatus.disconnected,
      username = null,
      displayName = null,
      avatarUrl = null;

  final XAccountStatus status;
  final String? username;
  final String? displayName;
  final String? avatarUrl;

  bool get isConnected => status == XAccountStatus.connected;
}

class XOAuthAuthorization {
  const XOAuthAuthorization({required this.authorizationUri});

  final Uri authorizationUri;
}
