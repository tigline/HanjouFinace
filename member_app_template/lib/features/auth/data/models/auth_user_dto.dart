import '../../domain/entities/auth_user.dart';

class AuthUserDto {
  const AuthUserDto({
    required this.username,
    this.userId,
    this.email,
    this.mobile,
    this.memberLevel,
    this.intlTelCode,
  });

  final String username;
  final int? userId;
  final String? email;
  final String? mobile;
  final int? memberLevel;
  final String? intlTelCode;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) {
    final username =
        _stringOrNull(json['username']) ??
        _stringOrNull(json['usename']) ??
        _stringOrNull(json['mobile']) ??
        '';

    return AuthUserDto(
      username: username,
      userId: _intOrNull(json['userId']),
      email: _normalizedOptionalString(json['email']),
      mobile: _normalizedOptionalString(json['mobile']),
      memberLevel: _intOrNull(json['memberLevel']),
      intlTelCode: _normalizedOptionalString(json['intlTelCode']),
    );
  }

  static AuthUserDto? tryFromLoginPayload(Map<String, dynamic> json) {
    final username =
        _stringOrNull(json['username']) ?? _stringOrNull(json['usename']);
    final mobile = _normalizedOptionalString(json['mobile']);
    final userId = _intOrNull(json['userId']);
    final memberLevel = _intOrNull(json['memberLevel']);
    final intlTelCode = _normalizedOptionalString(json['intlTelCode']);

    final normalizedUsername = (username ?? mobile ?? '').trim();
    final hasMeaningfulData =
        normalizedUsername.isNotEmpty || userId != null || memberLevel != null;
    if (!hasMeaningfulData) {
      return null;
    }

    final email = _looksLikeEmail(normalizedUsername)
        ? normalizedUsername
        : _normalizedOptionalString(json['email']);

    return AuthUserDto(
      username: normalizedUsername,
      userId: userId,
      email: email,
      mobile: mobile,
      memberLevel: memberLevel,
      intlTelCode: intlTelCode,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'userId': userId,
      'email': email,
      'mobile': mobile,
      'memberLevel': memberLevel,
      'intlTelCode': intlTelCode,
    };
  }

  AuthUser toEntity() {
    return AuthUser(
      username: username,
      userId: userId,
      email: email,
      mobile: mobile,
      memberLevel: memberLevel,
      intlTelCode: intlTelCode,
    );
  }

  static String? _stringOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    final text = value.toString();
    return text.trim().isEmpty ? null : text;
  }

  static String? _normalizedOptionalString(Object? value) {
    final text = _stringOrNull(value);
    if (text == null) {
      return null;
    }
    return text.trim();
  }

  static int? _intOrNull(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value == null) {
      return null;
    }
    return int.tryParse(value.toString());
  }

  static bool _looksLikeEmail(String value) {
    return value.contains('@') && value.contains('.');
  }
}
