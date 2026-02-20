import 'package:dio/dio.dart';

import '../interceptors/auth_interceptor.dart';
import '../models/token_pair.dart';

typedef TokenRefreshRequestBuilder =
    Map<String, dynamic> Function(String refreshToken);

typedef TokenRefreshResponseParser =
    TokenPair? Function(Map<String, dynamic> response);

abstract class TokenRefresher {
  Future<TokenPair?> refresh(String refreshToken);
}

class EndpointTokenRefresher implements TokenRefresher {
  EndpointTokenRefresher(
    this._dio, {
    required this.refreshPath,
    TokenRefreshRequestBuilder? buildRequestBody,
    TokenRefreshResponseParser? parseTokenPair,
    Options? requestOptions,
  }) : _buildRequestBody = buildRequestBody ?? _defaultBuildRequestBody,
       _parseTokenPair = parseTokenPair ?? _defaultParseTokenPair,
       _requestOptions = requestOptions;

  factory EndpointTokenRefresher.oauth2(
    Dio dio, {
    required String refreshPath,
    required String basicAuthorization,
    String? scope,
  }) {
    return EndpointTokenRefresher(
      dio,
      refreshPath: refreshPath,
      buildRequestBody: (refreshToken) => <String, dynamic>{
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        if (scope != null && scope.trim().isNotEmpty) 'scope': scope,
      },
      parseTokenPair: (response) {
        final accessToken = response['access_token'] as String?;
        final nextRefreshToken = response['refresh_token'] as String?;
        if (accessToken == null || nextRefreshToken == null) {
          return null;
        }
        return TokenPair(
          accessToken: accessToken,
          refreshToken: nextRefreshToken,
        );
      },
      requestOptions: Options(
        headers: <String, dynamic>{'Authorization': basicAuthorization},
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }

  final Dio _dio;
  final String refreshPath;
  final TokenRefreshRequestBuilder _buildRequestBody;
  final TokenRefreshResponseParser _parseTokenPair;
  final Options? _requestOptions;

  @override
  Future<TokenPair?> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      refreshPath,
      data: _buildRequestBody(refreshToken),
      options: _buildOptions(),
    );

    final data = response.data;
    if (data == null) return null;

    return _parseTokenPair(data);
  }

  Options _buildOptions() {
    final noAuthOptions = authRequired(false);
    if (_requestOptions == null) {
      return noAuthOptions;
    }

    return _requestOptions.copyWith(
      headers: <String, dynamic>{
        ...?noAuthOptions.headers,
        ...?_requestOptions.headers,
      },
      extra: <String, dynamic>{
        ...?noAuthOptions.extra,
        ...?_requestOptions.extra,
      },
    );
  }

  static Map<String, dynamic> _defaultBuildRequestBody(String refreshToken) {
    return <String, dynamic>{'refreshToken': refreshToken};
  }

  static TokenPair? _defaultParseTokenPair(Map<String, dynamic> response) {
    final accessToken = response['accessToken'] as String?;
    final nextRefreshToken = response['refreshToken'] as String?;
    if (accessToken == null || nextRefreshToken == null) {
      return null;
    }

    return TokenPair(accessToken: accessToken, refreshToken: nextRefreshToken);
  }
}
