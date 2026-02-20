import 'package:dio/dio.dart';

import '../interceptors/auth_interceptor.dart';
import '../models/token_pair.dart';

abstract class TokenRefresher {
  Future<TokenPair?> refresh(String refreshToken);
}

class EndpointTokenRefresher implements TokenRefresher {
  EndpointTokenRefresher(this._dio, {required this.refreshPath});

  final Dio _dio;
  final String refreshPath;

  @override
  Future<TokenPair?> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      refreshPath,
      data: <String, dynamic>{'refreshToken': refreshToken},
      options: authRequired(false),
    );

    final data = response.data;
    if (data == null) return null;

    final accessToken = data['accessToken'] as String?;
    final nextRefreshToken = data['refreshToken'] as String?;

    if (accessToken == null || nextRefreshToken == null) {
      return null;
    }

    return TokenPair(accessToken: accessToken, refreshToken: nextRefreshToken);
  }
}
