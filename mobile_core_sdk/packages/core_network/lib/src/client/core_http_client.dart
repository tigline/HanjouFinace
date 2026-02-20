import 'package:dio/dio.dart';

import '../auth/auth_failure_handler.dart';
import '../auth/token_refresher.dart';
import '../auth/token_store.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/network_error_interceptor.dart';
import '../interceptors/token_refresh_interceptor.dart';

class CoreHttpClient {
  CoreHttpClient({
    required String baseUrl,
    required TokenStore tokenStore,
    required TokenRefresher tokenRefresher,
    AuthFailureHandler? authFailureHandler,
    int maxAuthRetryAttempts = 1,
    Dio? dio,
  }) : dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl)) {
    this.dio.interceptors.addAll(<Interceptor>[
      NetworkErrorInterceptor(),
      AuthInterceptor(tokenStore: tokenStore),
      TokenRefreshInterceptor(
        dio: this.dio,
        tokenStore: tokenStore,
        tokenRefresher: tokenRefresher,
        authFailureHandler: authFailureHandler,
        maxRetryAttempts: maxAuthRetryAttempts,
      ),
    ]);
  }

  final Dio dio;
}
