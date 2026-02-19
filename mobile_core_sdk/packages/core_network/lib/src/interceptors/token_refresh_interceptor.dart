import 'package:dio/dio.dart';

import '../auth/token_refresher.dart';
import '../auth/token_store.dart';
import '../models/token_pair.dart';
import 'auth_interceptor.dart';

const String _retryAttemptExtraKey = 'token_retry_attempt';

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required Dio dio,
    required TokenStore tokenStore,
    required TokenRefresher tokenRefresher,
  })  : _dio = dio,
        _tokenStore = tokenStore,
        _tokenRefresher = tokenRefresher;

  final Dio _dio;
  final TokenStore _tokenStore;
  final TokenRefresher _tokenRefresher;

  Future<TokenPair?>? _refreshing;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRefresh(err.requestOptions, err.response?.statusCode)) {
      handler.next(err);
      return;
    }

    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      handler.next(err);
      return;
    }

    try {
      final pair = await _queueRefresh(refreshToken);
      if (pair == null) {
        await _tokenStore.clear();
        handler.next(err);
        return;
      }

      await _tokenStore.save(pair);
      final response =
          await _retryWithToken(err.requestOptions, pair.accessToken);
      handler.resolve(response);
    } catch (_) {
      await _tokenStore.clear();
      handler.next(err);
    }
  }

  bool _shouldRefresh(RequestOptions request, int? statusCode) {
    final retried = request.extra[_retryAttemptExtraKey] == true;
    return statusCode == 401 && isAuthRequired(request) && !retried;
  }

  Future<TokenPair?> _queueRefresh(String refreshToken) {
    if (_refreshing != null) {
      return _refreshing!;
    }

    final future = _tokenRefresher.refresh(refreshToken);
    _refreshing = future.whenComplete(() {
      _refreshing = null;
    });
    return _refreshing!;
  }

  Future<Response<dynamic>> _retryWithToken(
    RequestOptions request,
    String accessToken,
  ) {
    final headers = Map<String, dynamic>.from(request.headers)
      ..['Authorization'] = 'Bearer $accessToken';
    final extra = Map<String, dynamic>.from(request.extra)
      ..[_retryAttemptExtraKey] = true;

    final retry = request.copyWith(
      headers: headers,
      extra: extra,
    );

    return _dio.fetch<dynamic>(retry);
  }
}
