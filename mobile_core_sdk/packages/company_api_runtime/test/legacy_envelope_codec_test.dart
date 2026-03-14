import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:test/test.dart';

void main() {
  group('LegacyEnvelopeCodec', () {
    test('accepts only configured success codes', () {
      const code200Codec = LegacyEnvelopeCodec(
        profile: LegacyEnvelopeProfile(successCodes: <String>{'200'}),
      );
      const mixedCodec = LegacyEnvelopeCodec(
        profile: LegacyEnvelopeProfile(successCodes: <String>{'0', '200'}),
      );

      expect(code200Codec.isSuccessCode(200), isTrue);
      expect(code200Codec.isSuccessCode(0), isFalse);

      expect(mixedCodec.isSuccessCode(200), isTrue);
      expect(mixedCodec.isSuccessCode(0), isTrue);
      expect(mixedCodec.isSuccessCode('0'), isTrue);
    });

    test('extracts envelope data map and direct map payload', () {
      const codec = LegacyEnvelopeCodec(
        profile: LegacyEnvelopeProfile(successCodes: <String>{'200'}),
      );

      final envelope = codec.extractDataMap(<String, dynamic>{
        'code': 200,
        'data': <String, dynamic>{'name': 'demo'},
      }, fallbackMessage: 'failed');
      final direct = codec.extractDataMap(<String, dynamic>{
        'name': 'direct',
      }, fallbackMessage: 'failed');

      expect(envelope['name'], 'demo');
      expect(direct['name'], 'direct');
    });

    test('extracts paged rows from envelope and direct rows payload', () {
      const codec = LegacyEnvelopeCodec(
        profile: LegacyEnvelopeProfile(successCodes: <String>{'200'}),
      );

      final fromEnvelope = codec.extractPagedRows(<String, dynamic>{
        'code': 200,
        'data': <String, dynamic>{
          'rows': <Map<String, dynamic>>[
            <String, dynamic>{'id': 1},
          ],
        },
      }, fallbackMessage: 'failed');

      final fromDirect = codec.extractPagedRows(<String, dynamic>{
        'rows': <Map<String, dynamic>>[
          <String, dynamic>{'id': 2},
        ],
      }, fallbackMessage: 'failed');

      expect(fromEnvelope.single['id'], 1);
      expect(fromDirect.single['id'], 2);
    });

    test('supports truthy data validation', () {
      const codec = LegacyEnvelopeCodec(
        profile: LegacyEnvelopeProfile(successCodes: <String>{'200'}),
      );

      expect(
        () => codec.assertSuccessIfEnvelope(
          <String, dynamic>{'code': 200, 'data': false},
          fallbackMessage: 'failed',
          requireTruthyData: true,
        ),
        throwsA(isA<StateError>()),
      );

      expect(
        () => codec.assertSuccessIfEnvelope(
          <String, dynamic>{'code': 200, 'data': true},
          fallbackMessage: 'failed',
          requireTruthyData: true,
        ),
        returnsNormally,
      );
    });

    test('extracts data string with fallback keys', () {
      const codec = LegacyEnvelopeCodec(
        profile: LegacyEnvelopeProfile(successCodes: <String>{'200'}),
      );

      final value = codec.extractDataString(
        <String, dynamic>{'url': 'https://example.com/file.png'},
        fallbackMessage: 'failed',
        fallbackKeys: const <String>['url'],
      );

      expect(value, 'https://example.com/file.png');
    });

    test('throws message from envelope when response fails', () {
      const codec = LegacyEnvelopeCodec(
        profile: LegacyEnvelopeProfile(successCodes: <String>{'200'}),
      );

      expect(
        () => codec.extractDataMap(<String, dynamic>{
          'code': 500,
          'msg': 'custom-error',
          'data': <String, dynamic>{},
        }, fallbackMessage: 'failed'),
        throwsA(
          predicate<StateError>((error) => error.message == 'custom-error'),
        ),
      );
    });
  });
}
