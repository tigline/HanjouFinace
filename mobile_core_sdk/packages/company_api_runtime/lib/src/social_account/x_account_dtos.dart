class XAccountConnectionDto {
  const XAccountConnectionDto({
    required this.connected,
    this.username,
    this.displayName,
    this.avatarUrl,
  });

  const XAccountConnectionDto.disconnected()
    : connected = false,
      username = null,
      displayName = null,
      avatarUrl = null;

  factory XAccountConnectionDto.fromJson(Map<String, dynamic> json) {
    return XAccountConnectionDto(
      connected: _toBool(json['connected']),
      username: _toNullableString(json['username']),
      displayName: _toNullableString(json['displayName']),
      avatarUrl: _toNullableString(json['avatarUrl']),
    );
  }

  final bool connected;
  final String? username;
  final String? displayName;
  final String? avatarUrl;
}

class XOAuthStartDto {
  const XOAuthStartDto({required this.authorizationUrl});

  factory XOAuthStartDto.fromJson(Map<String, dynamic> json) {
    return XOAuthStartDto(
      authorizationUrl:
          _toNullableString(
            json['authorizationUrl'] ??
                json['authorizeUrl'] ??
                json['authUrl'] ??
                json['url'],
          ) ??
          '',
    );
  }

  final String authorizationUrl;
}

String? _toNullableString(Object? value) {
  final normalized = value?.toString().trim() ?? '';
  return normalized.isEmpty ? null : normalized;
}

bool _toBool(Object? value) {
  if (value is bool) {
    return value;
  }
  return value?.toString().trim().toLowerCase() == 'true' ||
      value?.toString().trim() == '1';
}
