import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_session.dart';

part 'auth_session_dto.freezed.dart';
part 'auth_session_dto.g.dart';

@freezed
class AuthSessionDto with _$AuthSessionDto {
  const AuthSessionDto._();

  const factory AuthSessionDto({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _AuthSessionDto;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDtoFromJson(_normalizedJson(json));

  static Map<String, dynamic> _normalizedJson(Map<String, dynamic> json) {
    final accessToken =
        _tokenStringOrNull(json['accessToken']) ??
        _tokenStringOrNull(json['access_token']);
    final refreshToken =
        _tokenStringOrNull(json['refreshToken']) ??
        _tokenStringOrNull(json['refresh_token']);

    if (accessToken == null || refreshToken == null) {
      throw const FormatException('Invalid auth session payload.');
    }

    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': _parseExpiresAt(json).toIso8601String(),
    };
  }

  static DateTime _parseExpiresAt(Map<String, dynamic> json) {
    final expiresAt = _dateTimeOrNull(json['expiresAt']);
    if (expiresAt != null) {
      return expiresAt;
    }

    final expiresInValue = _intOrNull(json['expires_in'] ?? json['expiresIn']);
    if (expiresInValue != null) {
      return DateTime.now().toUtc().add(Duration(seconds: expiresInValue));
    }

    return DateTime.now().toUtc().add(const Duration(hours: 4));
  }

  static String? _tokenStringOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is! String && value is! num) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? _dateTimeOrNull(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value.toUtc();
    }

    final text = value.toString().trim();
    if (text.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(text).toUtc();
    } on FormatException {
      return null;
    }
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

  AuthSession toEntity() {
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
}
