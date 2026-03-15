import 'legacy_envelope_codec.dart';

class CompanyApiResponseProfiles {
  const CompanyApiResponseProfiles._();

  /// OA gateway (crowdfunding + auth): success when `code == 200`.
  static const LegacyEnvelopeProfile oa = LegacyEnvelopeProfile(
    successCodes: <String>{'200'},
  );

  /// Member gateway: mixed success codes `0` and `200`.
  static const LegacyEnvelopeProfile memberMixed = LegacyEnvelopeProfile(
    successCodes: <String>{'0', '200'},
  );

  /// Hotel gateway: success when `code == 0`.
  static const LegacyEnvelopeProfile hotel = LegacyEnvelopeProfile(
    successCodes: <String>{'0'},
  );

  /// Common paging structure where rows are inside `data.rows`.
  static const LegacyPageProfile standardPage = LegacyPageProfile(
    containerKey: 'data',
    rowsKey: 'rows',
  );
}
