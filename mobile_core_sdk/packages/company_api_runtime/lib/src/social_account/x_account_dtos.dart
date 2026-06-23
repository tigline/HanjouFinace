enum XAccountConnectionStatus {
  disconnected,
  connecting,
  connected,
  expired;

  static XAccountConnectionStatus fromJson(Object? value) {
    return switch (value?.toString().trim().toLowerCase()) {
      'connecting' || 'pending' => connecting,
      'connected' ||
      'bound' ||
      'success' ||
      'succeeded' ||
      'completed' => connected,
      'expired' || 'revoked' || 'invalid' => expired,
      _ => disconnected,
    };
  }
}

class XAccountConnectionDto {
  const XAccountConnectionDto({
    required this.status,
    this.xUserId,
    this.username,
    this.displayName,
    this.avatarUrl,
    this.connectedAt,
  });

  const XAccountConnectionDto.disconnected()
    : status = XAccountConnectionStatus.disconnected,
      xUserId = null,
      username = null,
      displayName = null,
      avatarUrl = null,
      connectedAt = null;

  factory XAccountConnectionDto.fromJson(Map<String, dynamic> json) {
    final connected = _toBool(json['connected']);
    final rawStatus = json['status'];
    final status = rawStatus == null && connected
        ? XAccountConnectionStatus.connected
        : XAccountConnectionStatus.fromJson(rawStatus);
    return XAccountConnectionDto(
      status: status,
      xUserId: _toNullableString(json['xUserId'] ?? json['userId']),
      username: _toNullableString(json['username']),
      displayName: _toNullableString(json['displayName'] ?? json['name']),
      avatarUrl: _toNullableString(
        json['avatarUrl'] ?? json['profileImageUrl'],
      ),
      connectedAt: _toNullableDateTime(json['connectedAt']),
    );
  }

  final XAccountConnectionStatus status;
  final String? xUserId;
  final String? username;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? connectedAt;
}

class XBindingAttemptDto {
  const XBindingAttemptDto({
    required this.attemptId,
    required this.authorizationUrl,
    this.expiresAt,
  });

  factory XBindingAttemptDto.fromJson(Map<String, dynamic> json) {
    return XBindingAttemptDto(
      attemptId: _toNullableString(json['attemptId']) ?? '',
      authorizationUrl: _toNullableString(json['authorizationUrl']) ?? '',
      expiresAt: _toNullableDateTime(json['expiresAt']),
    );
  }

  final String attemptId;
  final String authorizationUrl;
  final DateTime? expiresAt;
}

class XBindingStatusDto {
  const XBindingStatusDto({
    required this.attemptId,
    required this.status,
    required this.connection,
    this.errorCode,
  });

  factory XBindingStatusDto.fromJson(Map<String, dynamic> json) {
    final connectionJson = _toStringMap(json['account'] ?? json['connection']);
    return XBindingStatusDto(
      attemptId: _toNullableString(json['attemptId']) ?? '',
      status: XAccountConnectionStatus.fromJson(json['status']),
      connection: connectionJson.isEmpty
          ? XAccountConnectionDto.fromJson(json)
          : XAccountConnectionDto.fromJson(connectionJson),
      errorCode: _toNullableString(json['errorCode']),
    );
  }

  final String attemptId;
  final XAccountConnectionStatus status;
  final XAccountConnectionDto connection;
  final String? errorCode;
}

Map<String, dynamic> _toStringMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return const <String, dynamic>{};
}

String? _toNullableString(Object? value) {
  final normalized = value?.toString().trim() ?? '';
  return normalized.isEmpty ? null : normalized;
}

DateTime? _toNullableDateTime(Object? value) {
  final normalized = _toNullableString(value);
  return normalized == null ? null : DateTime.tryParse(normalized);
}

bool _toBool(Object? value) {
  if (value is bool) {
    return value;
  }
  return value?.toString().trim().toLowerCase() == 'true' ||
      value?.toString().trim() == '1';
}
