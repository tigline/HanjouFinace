import '../../domain/entities/auth_session.dart';

class AuthSessionDto {
  const AuthSessionDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) {
    final accessToken =
        (json['accessToken'] as String?) ?? (json['access_token'] as String?);
    final refreshToken =
        (json['refreshToken'] as String?) ?? (json['refresh_token'] as String?);

    if (accessToken == null || refreshToken == null) {
      throw const FormatException('Invalid auth session payload.');
    }

    return AuthSessionDto(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: _parseExpiresAt(json),
    );
  }

  static DateTime _parseExpiresAt(Map<String, dynamic> json) {
    final expiresAtValue = json['expiresAt'] as String?;
    if (expiresAtValue != null && expiresAtValue.trim().isNotEmpty) {
      return DateTime.parse(expiresAtValue).toUtc();
    }

    final expiresInValue = json['expires_in'] ?? json['expiresIn'];
    if (expiresInValue is num) {
      return DateTime.now().toUtc().add(
        Duration(seconds: expiresInValue.toInt()),
      );
    }

    return DateTime.now().toUtc().add(const Duration(hours: 4));
  }

  AuthSession toEntity() {
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
}
