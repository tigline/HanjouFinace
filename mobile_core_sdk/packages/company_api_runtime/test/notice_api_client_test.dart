import 'dart:async';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_network/core_network.dart';
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

ResponseBody _jsonOk([String body = '{}']) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/json'],
    },
  );
}

Dio _buildDio(Future<ResponseBody> Function(RequestOptions options) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);
  return dio;
}

void main() {
  group('NoticeApiClient', () {
    test('checkNotice sends GET with id and parses detail', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(NoticeApiPaths.check));
        expect(options.queryParameters, equals(<String, dynamic>{'id': 1001}));
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"id":1001,"memberId":77,"noticeType":2,"status":false,"noticeTitle":"募集開始","detail":"募集が開始されました","createUser":"system"}}',
        );
      });
      final api = NoticeApiClient(dioForPath: (_) => dio);

      final detail = await api.checkNotice(id: 1001);

      expect(detail.id, equals(1001));
      expect(detail.memberId, equals(77));
      expect(detail.status, isFalse);
      expect(detail.noticeTitle, equals('募集開始'));
    });

    test('fetchNoticeList posts request and parses page rows', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(NoticeApiPaths.list));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'startPage': 1,
            'limit': 20,
            'memberId': 88,
            'status': false,
          }),
        );
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"currentPage":1,"limit":20,"total":2,"rows":[{"id":1,"noticeTitle":"タイトル1","status":false},{"id":2,"noticeTitle":"タイトル2","status":true}]}}',
        );
      });
      final api = NoticeApiClient(dioForPath: (_) => dio);

      final page = await api.fetchNoticeList(
        startPage: 1,
        limit: 20,
        memberId: 88,
        status: false,
      );

      expect(page.currentPage, equals(1));
      expect(page.total, equals(2));
      expect(page.rows, hasLength(2));
      expect(page.rows.first.id, equals(1));
      expect(page.rows.first.noticeTitle, equals('タイトル1'));
      expect(page.rows.last.status, isTrue);
    });

    test('fetchNoticeStatistics uses GET and parses counters', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(NoticeApiPaths.statistics));
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"check":12,"uncheck":3}}',
        );
      });
      final api = NoticeApiClient(dioForPath: (_) => dio);

      final stats = await api.fetchNoticeStatistics();

      expect(stats.check, equals(12));
      expect(stats.uncheck, equals(3));
    });

    test('fetchNoticeList throws when envelope code is failed', () async {
      final dio = _buildDio((_) async {
        return _jsonOk('{"msg":"failed","code":500,"data":null}');
      });
      final api = NoticeApiClient(dioForPath: (_) => dio);

      expect(() => api.fetchNoticeList(), throwsA(isA<StateError>()));
    });
  });
}
