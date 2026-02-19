import 'package:dio/dio.dart';

import '../auth/token_refresher.dart';
import '../auth/token_store.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/token_refresh_interceptor.dart';

class CoreHttpClient {
  CoreHttpClient({
    required String baseUrl,
    required TokenStore tokenStore,
    required TokenRefresher tokenRefresher,
    Dio? dio,
  }) : dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl)) {
    this.dio.interceptors.addAll(<Interceptor>[
      AuthInterceptor(tokenStore: tokenStore),
      TokenRefreshInterceptor(
        dio: this.dio,
        tokenStore: tokenStore,
        tokenRefresher: tokenRefresher,
      ),
    ]);
  }

  final Dio dio;
}
