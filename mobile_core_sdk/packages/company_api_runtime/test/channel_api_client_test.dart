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
  test('loads authenticated channel detail and maps invitation fields', () async {
    final api = ChannelApiClient(
      _buildClient((options) async {
        expect(options.method, 'GET');
        expect(options.path, ChannelApiPaths.detail);
        expect(options.extra['auth_required'], isTrue);
        expect(options.extra['refresh_on_forbidden'], isTrue);
        return _ok(
          '{"code":0,"data":{"inviteCode":"STAR2026","countNum":12,"channelName":"Friends"}}',
        );
      }),
    );

    final result = await api.fetchMyChannelDetail();

    expect(result.inviteCode, 'STAR2026');
    expect(result.invitedFriendCount, 12);
    expect(result.channelName, 'Friends');
  });

  test('accepts member success code 200', () async {
    final api = ChannelApiClient(
      _buildClient(
        (_) async =>
            _ok('{"code":200,"data":{"inviteCode":"MEMBER","countNum":"3"}}'),
      ),
    );

    final result = await api.fetchMyChannelDetail();

    expect(result.inviteCode, 'MEMBER');
    expect(result.invitedFriendCount, 3);
  });
}
