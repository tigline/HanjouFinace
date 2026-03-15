import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:test/test.dart';

void main() {
  group('CompanyApiResponseProfiles', () {
    test('oa uses code 200', () {
      expect(CompanyApiResponseProfiles.oa.successCodes, contains('200'));
      expect(CompanyApiResponseProfiles.oa.successCodes.length, 1);
    });

    test('memberMixed supports 0 and 200', () {
      expect(
        CompanyApiResponseProfiles.memberMixed.successCodes,
        contains('0'),
      );
      expect(
        CompanyApiResponseProfiles.memberMixed.successCodes,
        contains('200'),
      );
      expect(CompanyApiResponseProfiles.memberMixed.successCodes.length, 2);
    });

    test('hotel uses code 0', () {
      expect(CompanyApiResponseProfiles.hotel.successCodes, contains('0'));
      expect(CompanyApiResponseProfiles.hotel.successCodes.length, 1);
    });

    test('standardPage uses data.rows convention', () {
      expect(CompanyApiResponseProfiles.standardPage.containerKey, 'data');
      expect(CompanyApiResponseProfiles.standardPage.rowsKey, 'rows');
    });
  });
}
