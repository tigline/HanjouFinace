import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
import 'package:test/test.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }
}

class _NoopTokenRefresher implements TokenRefresher {
  @override
  Future<TokenPair?> refresh(String refreshToken) async => null;
}

CoreHttpClient _buildClient(
  Future<ResponseBody> Function(RequestOptions options) handler,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);
  return CoreHttpClient(
    baseUrl: dio.options.baseUrl,
    tokenStore: InMemoryTokenStore(),
    tokenRefresher: _NoopTokenRefresher(),
    dio: dio,
  );
}

ResponseBody _ok(String body) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

void main() {
  group('XAccountApiClient', () {
    test('starts OAuth without a request body and reads URL map', () async {
      final api = XAccountApiClient(
        _buildClient((options) async {
          expect(options.method, 'POST');
          expect(options.path, XAccountApiPaths.startOAuth);
          expect(options.extra['auth_required'], isTrue);
          expect(options.data, isNull);
          return _ok(
            '{"code":0,"data":{"url":"https://x.com/i/oauth2/authorize"}}',
          );
        }),
      );

      final result = await api.startOAuth();

      expect(result.authorizationUrl, startsWith('https://x.com/'));
    });

    test('reads SocialXAccountVO connected state', () async {
      final api = XAccountApiClient(
        _buildClient((options) async {
          expect(options.method, 'GET');
          expect(options.path, XAccountApiPaths.account);
          return _ok(
            '{"code":200,"data":{"connected":true,"username":"stellavia","displayName":"StellaVia","avatarUrl":"https://cdn.example.com/x.png"}}',
          );
        }),
      );

      final account = await api.fetchAccount();

      expect(account.connected, isTrue);
      expect(account.username, 'stellavia');
      expect(account.displayName, 'StellaVia');
    });

    test('maps an empty account response to disconnected', () async {
      final api = XAccountApiClient(
        _buildClient((_) async => _ok('{"code":200,"data":null}')),
      );

      final account = await api.fetchAccount();

      expect(account.connected, isFalse);
    });
  });
}
