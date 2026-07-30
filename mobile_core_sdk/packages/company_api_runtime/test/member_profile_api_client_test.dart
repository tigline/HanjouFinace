import 'dart:async';
import 'dart:io';

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

ResponseBody _textOk(String body) {
  return ResponseBody.fromString(
    body,
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['text/plain;charset=utf-8'],
    },
  );
}

Dio _buildDio(Future<ResponseBody> Function(RequestOptions options) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/api'));
  dio.httpClientAdapter = _FakeAdapter(handler);
  return dio;
}

void main() {
  group('MemberProfileApiClient', () {
    late Directory tempDir;
    late File imageFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'member_profile_api_client_test',
      );
      imageFile = File('${tempDir.path}/avatar.jpg');
      await imageFile.writeAsBytes(const <int>[1, 2, 3, 4]);
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'fetchRegionsByZip maps ZipCloud address fields to existing regions',
      () async {
        final dio = _buildDio((options) async {
          expect(options.method, equals('GET'));
          expect(
            options.uri.toString(),
            equals('https://zipcloud.ibsnet.co.jp/api/search?zipcode=9201154'),
          );
          expect(options.extra['auth_required'], isFalse);

          return _textOk(
            '{"message":null,"results":[{"address1":"石川県",'
            '"address2":"金沢市","address3":"太陽が丘",'
            '"kana1":"ｲｼｶﾜｹﾝ","kana2":"ｶﾅｻﾞﾜｼ","kana3":"ﾀｲﾖｳｶﾞｵｶ",'
            '"prefcode":"17","zipcode":"9201154"}],"status":200}',
          );
        });
        final api = MemberProfileApiClient(dioForPath: (_) => dio);

        final regions = await api.fetchRegionsByZip(zip: '9201154');

        expect(regions, hasLength(2));
        expect(regions[0].jpName, equals('石川県'));
        expect(regions[0].regionType, equals(0));
        expect(regions[1].jpName, equals('金沢市太陽が丘'));
        expect(regions[1].regionType, equals(1));
        expect(regions.every((region) => region.regionId == null), isTrue);
      },
    );

    test(
      'fetchRegionsByZip returns empty regions when no result exists',
      () async {
        final dio = _buildDio(
          (_) async => _jsonOk('{"message":null,"results":null,"status":200}'),
        );
        final api = MemberProfileApiClient(dioForPath: (_) => dio);

        final regions = await api.fetchRegionsByZip(zip: '0000000');

        expect(regions, isEmpty);
      },
    );

    test('fetchRegionsByZip throws ZipCloud business error', () async {
      final dio = _buildDio(
        (_) async => _jsonOk(
          '{"message":"パラメータ「郵便番号」の桁数が不正です。",'
          '"results":null,"status":400}',
        ),
      );
      final api = MemberProfileApiClient(dioForPath: (_) => dio);

      expect(
        () => api.fetchRegionsByZip(zip: '123'),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            'パラメータ「郵便番号」の桁数が不正です。',
          ),
        ),
      );
    });

    test('uploadAvatar posts multipart and returns uploaded url', () async {
      final dio = _buildDio((options) async {
        expect(options.method, equals('POST'));
        expect(options.path, equals(MemberProfileApiPaths.uploadAvatar));
        expect(options.extra['auth_required'], isTrue);
        expect(
          options.contentType,
          startsWith(Headers.multipartFormDataContentType),
        );
        expect(options.data, isA<FormData>());

        return _jsonOk(
          '{"msg":"success","code":200,"data":"https://cdn.example.com/avatar.jpg"}',
        );
      });
      final api = MemberProfileApiClient(dioForPath: (_) => dio);

      final url = await api.uploadAvatar(filePath: imageFile.path);

      expect(url, equals('https://cdn.example.com/avatar.jpg'));
    });
  });
}
