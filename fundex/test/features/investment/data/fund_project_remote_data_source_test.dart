import 'dart:async';

import 'package:core_network/core_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/config/api_paths.dart';
import 'package:fundex/features/investment/data/datasources/fund_project_remote_data_source.dart';

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

class _NoopTokenRefresher implements TokenRefresher {
  @override
  Future<TokenPair?> refresh(String refreshToken) async {
    return null;
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

CoreHttpClient _buildClient(
  Future<ResponseBody> Function(RequestOptions options) handler,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);

  return CoreHttpClient(
    baseUrl: 'https://api.example.com/api',
    tokenStore: InMemoryTokenStore(),
    tokenRefresher: _NoopTokenRefresher(),
    dio: dio,
  );
}

void main() {
  group('FundProjectRemoteDataSourceImpl', () {
    test('fetchFundProjectList uses list endpoint and parses envelope', () async {
      final client = _buildClient((options) async {
        expect(options.method, 'GET');
        expect(options.path, FundingFundApiPath.projectList);
        expect(options.extra['auth_required'], true);

        return _jsonOk(
          '{"msg":"success","code":200,"data":[{"id":"453461223669231137","projectName":"繁星優選Fund商品20241123","expectedDistributionRatioMax":0.02,"expectedDistributionRatioMin":0.01,"investmentPeriod":"１４ヶ月","investmentUnit":100000,"maximumInvestmentPerPerson":100,"achievementRate":1.01,"amountApplication":10000000,"currentlySubscribed":10100000,"daysRemaining":0,"projectStatus":4,"operatingCompany":"運営会社","periodType":"SEASON","photos":[{"url":"https://cdn.example.com/p1.png"}],"investorTypeList":[{"id":"i1","projectId":"453461223669231137","investorType":"INVESTMENT","investorCode":"優先出資者A","earningsType":"FLOATING","earningsRadio":0.0,"interestRadio":0.0,"isOpen":false,"isOpenType":2,"currentAmountApplication":5000000}],"pdfs":[{"projectId":"453461223669231137","type":1,"desc":"契約成立前書面","urls":["https://cdn.example.com/a.pdf"]}]}]}',
        );
      });
      final source = FundProjectRemoteDataSourceImpl(client);

      final list = await source.fetchFundProjectList();

      expect(list, hasLength(1));
      final item = list.first;
      expect(item.id, '453461223669231137');
      expect(item.projectName, '繁星優選Fund商品20241123');
      expect(item.expectedDistributionRatioMax, 0.02);
      expect(item.expectedDistributionRatioMin, 0.01);
      expect(item.investmentPeriod, '１４ヶ月');
      expect(item.investmentUnit, 100000);
      expect(item.maximumInvestmentPerPerson, 100);
      expect(item.achievementRate, 1.01);
      expect(item.amountApplication, 10000000);
      expect(item.currentlySubscribed, 10100000);
      expect(item.projectStatus, 4);
      expect(item.operatingCompany, '運営会社');
      expect(item.periodType, 'SEASON');
      expect(item.photos, <String>['https://cdn.example.com/p1.png']);
      expect(item.investorTypes, hasLength(1));
      expect(item.investorTypes.first.investorCode, '優先出資者A');
      expect(item.pdfDocuments, hasLength(1));
      expect(item.pdfDocuments.first.description, '契約成立前書面');
      expect(item.pdfDocuments.first.urls, <String>[
        'https://cdn.example.com/a.pdf',
      ]);
    });

    test('fetchFundProjectList throws when envelope reports failure', () async {
      final client = _buildClient((options) async {
        expect(options.path, FundingFundApiPath.projectList);
        return _jsonOk('{"msg":"query failed","code":500,"data":null}');
      });
      final source = FundProjectRemoteDataSourceImpl(client);

      await expectLater(
        source.fetchFundProjectList(),
        throwsA(isA<StateError>()),
      );
    });
  });
}
