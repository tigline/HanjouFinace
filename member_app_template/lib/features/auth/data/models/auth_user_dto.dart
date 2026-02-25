import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'auth_user_dto.freezed.dart';
part 'auth_user_dto.g.dart';

@freezed
class AuthUserDto with _$AuthUserDto {
  const AuthUserDto._();

  const factory AuthUserDto({
    required String username,
    int? userId,
    String? email,
    String? mobile,
    int? memberLevel,
    String? intlTelCode,
  }) = _AuthUserDto;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(_normalizedJson(json));

  static Map<String, dynamic> _normalizedJson(Map<String, dynamic> json) {
    final username =
        _stringOrNull(json['username']) ??
        _stringOrNull(json['usename']) ??
        _stringOrNull(json['mobile']) ??
        '';

    return <String, dynamic>{
      'username': username,
      'userId': _intOrNull(json['userId']),
      'email': _normalizedOptionalString(json['email']),
      'mobile': _normalizedOptionalString(json['mobile']),
      'memberLevel': _intOrNull(json['memberLevel']),
      'intlTelCode': _normalizedOptionalString(json['intlTelCode']),
    };
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
