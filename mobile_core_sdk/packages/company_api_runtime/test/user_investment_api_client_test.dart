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
  group('UserInvestmentApiClient', () {
    test('fetchAccountStatistic gets envelope and parses data', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('GET'));
        expect(options.path, equals(UserInvestmentApiPaths.accountStatistic));
        expect(options.extra['auth_required'], isTrue);
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"userId":125530,"total":"98767523","crowdfundingTotal":"89703200","financialTotal":"9054667","firstLevelAccountTotal":"9656"}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final row = await api.fetchAccountStatistic();

      expect(row.userId, equals(125530));
      expect(row.total, equals(98767523));
      expect(row.crowdfundingTotal, equals(89703200));
      expect(row.financialTotal, equals(9054667));
      expect(row.firstLevelAccountTotal, equals(9656));
    });

    test('fetchApplyList posts payload and parses rows envelope', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserInvestmentApiPaths.applyList));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{'startPage': 1, 'limit': 20}),
        );
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"rows":[{"projecId":"p-1","projectName":"プレミアムレジデンス赤坂","status":2}]}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchApplyList();

      expect(rows, hasLength(1));
      expect(rows.first.projectId, equals('p-1'));
      expect(rows.first.projectName, equals('プレミアムレジデンス赤坂'));
      expect(rows.first.status, equals(2));
    });

    test('fetchOrderInquiryList posts userId and parses rows envelope', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserInvestmentApiPaths.orderInquiryPage));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{
            'startPage': 1,
            'limit': 20,
            'userId': 58350,
          }),
        );
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"rows":[{"id":"o-1","projectName":"商業ビル心斎橋","price":300000}]}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchOrderInquiryList(userId: 58350);

      expect(rows, hasLength(1));
      expect(rows.first.id, equals('o-1'));
      expect(rows.first.projectName, equals('商業ビル心斎橋'));
      expect(rows.first.price, equals(300000));
    });

    test('fetchInvestmentList posts payload and parses rows envelope', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(UserInvestmentApiPaths.myInvestmentList));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.data,
          equals(<String, dynamic>{'startPage': 1, 'limit': 20}),
        );
        return _jsonOk(
          '{"msg":"success","code":200,"data":{"rows":[{"projectId":"p-3","projectName":"渋谷区 オフィスビル #12","investMoney":1000000}]}}',
        );
      });
      final api = UserInvestmentApiClient(dioForPath: (_) => dio);

      final rows = await api.fetchInvestmentList();

      expect(rows, hasLength(1));
      expect(rows.first.projectId, equals('p-3'));
      expect(rows.first.projectName, equals('渋谷区 オフィスビル #12'));
      expect(rows.first.investMoney, equals(1000000));
    });
  });
}
