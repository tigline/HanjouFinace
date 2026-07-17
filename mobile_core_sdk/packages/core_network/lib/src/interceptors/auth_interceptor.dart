import 'package:dio/dio.dart';

import '../auth/token_store.dart';

const String _authRequiredExtraKey = 'auth_required';
const String _refreshOnForbiddenExtraKey = 'refresh_on_forbidden';

Options authRequired(bool required, {bool refreshOnForbidden = false}) {
  return Options(
    extra: <String, dynamic>{
      _authRequiredExtraKey: required,
      if (refreshOnForbidden) _refreshOnForbiddenExtraKey: true,
    },
  );
}

bool isAuthRequired(RequestOptions options) {
  return options.extra[_authRequiredExtraKey] != false;
}

bool shouldRefreshOnForbidden(RequestOptions options) {
  return options.extra[_refreshOnForbiddenExtraKey] == true;
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
