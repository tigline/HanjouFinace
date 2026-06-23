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
    test('starts a binding attempt with an app callback URI', () async {
      final api = XAccountApiClient(
        _buildClient((options) async {
          expect(options.method, 'POST');
          expect(options.path, XAccountApiPaths.startBinding);
          expect(options.extra['auth_required'], isTrue);
          expect(options.data, <String, dynamic>{
            'callbackUri': 'stellavia://oauth/x/result',
          });
          return _ok(
            '{"code":200,"data":{"attemptId":"attempt-1","authorizationUrl":"https://x.com/i/oauth2/authorize","expiresAt":"2026-06-23T10:00:00Z"}}',
          );
        }),
      );

      final result = await api.startBinding(
        callbackUri: 'stellavia://oauth/x/result',
      );

      expect(result.attemptId, 'attempt-1');
      expect(result.authorizationUrl, startsWith('https://x.com/'));
    });

    test('reads a connected account', () async {
      final api = XAccountApiClient(
        _buildClient((options) async {
          expect(options.path, XAccountApiPaths.account);
          return _ok(
            '{"code":200,"data":{"status":"connected","xUserId":"42","username":"stellavia","displayName":"StellaVia"}}',
          );
        }),
      );

      final account = await api.fetchAccount();

      expect(account.status, XAccountConnectionStatus.connected);
      expect(account.username, 'stellavia');
    });

    test('maps an empty account response to disconnected', () async {
      final api = XAccountApiClient(
        _buildClient((_) async => _ok('{"code":200,"data":null}')),
      );

      final account = await api.fetchAccount();

      expect(account.status, XAccountConnectionStatus.disconnected);
    });
  });
}
