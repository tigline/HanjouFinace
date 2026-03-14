import 'package:company_api_runtime/company_api_runtime.dart';

class AppApiResponseProfiles {
  const AppApiResponseProfiles._();

  /// OA gateway (crowdfunding + auth): `code == 200` 视为成功。
  static const LegacyEnvelopeProfile oa = LegacyEnvelopeProfile(
    successCodes: <String>{'200'},
  );

  /// Member gateway: 存在 `0` 与 `200` 混合成功码。
  static const LegacyEnvelopeProfile memberMixed = LegacyEnvelopeProfile(
    successCodes: <String>{'0', '200'},
  );

  /// Hotel gateway: 约定 `code == 0` 视为成功。
  static const LegacyEnvelopeProfile hotel = LegacyEnvelopeProfile(
    successCodes: <String>{'0'},
  );

  /// Funding 常用分页结构：`data.rows`。
  static const LegacyPageProfile standardPage = LegacyPageProfile(
    containerKey: 'data',
    rowsKey: 'rows',
  );
}
