import 'package:dio/dio.dart';

import '../auth/token_store.dart';

const String _authRequiredExtraKey = 'auth_required';

Options authRequired(bool required) {
  return Options(extra: <String, dynamic>{_authRequiredExtraKey: required});
}

bool isAuthRequired(RequestOptions options) {
  return options.extra[_authRequiredExtraKey] != false;
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required TokenStore tokenStore}) : _tokenStore = tokenStore;

  final TokenStore _tokenStore;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!isAuthRequired(options)) {
      handler.next(options);
      return;
    }

    final token = await _tokenStore.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
