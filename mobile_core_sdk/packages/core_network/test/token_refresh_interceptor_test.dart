import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }
}

class _FakeTokenRefresher implements TokenRefresher {
  _FakeTokenRefresher(this.onRefresh);

  final Future<TokenPair?> Function(String refreshToken) onRefresh;

  @override
  Future<TokenPair?> refresh(String refreshToken) => onRefresh(refreshToken);
}

void main() {
  group('TokenRefreshInterceptor', () {
    test('adds Authorization header from token store on request', () async {
      final store = InMemoryTokenStore();
      await store
          .save(const TokenPair(accessToken: 'oldA', refreshToken: 'oldR'));

      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      dio.httpClientAdapter = _FakeAdapter((options) async {
        expect(options.headers['Authorization'], 'Bearer oldA');
        return ResponseBody.fromString('{"ok":true}', 200, headers: {
          Headers.contentTypeHeader: <String>['application/json']
        });
      });

      final client = CoreHttpClient(
        baseUrl: 'https://api.example.com',
        tokenStore: store,
        tokenRefresher: _FakeTokenRefresher((_) async => null),
        dio: dio,
      );

      final response = await client.dio.get<Map<String, dynamic>>('/check');
      expect(response.statusCode, 200);
    });

    test('refreshes token and retries request after 401', () async {
      final store = InMemoryTokenStore();
      await store.save(
          const TokenPair(accessToken: 'expiredA', refreshToken: 'validR'));

      var callCount = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      dio.httpClientAdapter = _FakeAdapter((options) async {
        callCount += 1;

        if (callCount == 1) {
          return ResponseBody.fromString('unauthorized', 401);
        }

        expect(options.headers['Authorization'], 'Bearer newA');
        return ResponseBody.fromString('{"ok":true}', 200, headers: {
          Headers.contentTypeHeader: <String>['application/json']
        });
      });

      final client = CoreHttpClient(
        baseUrl: 'https://api.example.com',
        tokenStore: store,
        tokenRefresher: _FakeTokenRefresher((refreshToken) async {
          expect(refreshToken, 'validR');
          return const TokenPair(accessToken: 'newA', refreshToken: 'newR');
        }),
        dio: dio,
      );

      final response = await client.dio.get<Map<String, dynamic>>('/secure');

      expect(response.statusCode, 200);
      expect(await store.readAccessToken(), 'newA');
      expect(await store.readRefreshToken(), 'newR');
      expect(callCount, 2);
    });

    test('clears token when refresh fails', () async {
      final store = InMemoryTokenStore();
      await store
          .save(const TokenPair(accessToken: 'expiredA', refreshToken: 'badR'));

      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
      dio.httpClientAdapter = _FakeAdapter((_) async {
        return ResponseBody.fromString('unauthorized', 401);
      });

      final client = CoreHttpClient(
        baseUrl: 'https://api.example.com',
        tokenStore: store,
        tokenRefresher: _FakeTokenRefresher((_) async => null),
        dio: dio,
      );

      expect(
        () => client.dio.get<Map<String, dynamic>>('/secure'),
        throwsA(isA<DioException>()),
      );
      expect(await store.readAccessToken(), isNull);
      expect(await store.readRefreshToken(), isNull);
    });
  });
}
