/// Funding (crowdfunding) API paths used by FUNDEX features.
///
/// Source of truth:
/// - Swagger UI: https://sit-admin.gutingjun.com/api/swagger-ui.html#/
/// - OpenAPI docs: https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs
///
/// For funding APIs, prioritize Swagger definitions. Do not add new endpoints
/// from the legacy GetX project `http_conf.dart` unless Swagger is missing the
/// endpoint and the fallback is documented in `README_API.md`.
class FundingAuthApiPath {
  const FundingAuthApiPath._();

  static const String smsCode = '/mss/smsCode';
  static const String emailLoginCode = '/member/user/emailLoginCode';
  static const String createRegisterMobileCode =
      '/member/user/createRegisterMobileCode';
  static const String createRegisterEmailCode =
      '/member/user/createRegisterEmailCode';
  static const String registerApply = '/member/user/registerApply';
  static const String oauthToken = '/uaa/oauth/token';
  static const String crowdfundingUserIndex = '/crowdfunding/user/index';
}

/// Funding fund/project APIs used by `feature_investment`.
class FundingFundApiPath {
  const FundingFundApiPath._();

  /// Source: README_API.md section 5.
  /// Full URL sample:
  /// https://testoa.gutingjun.com/api/crowdfunding/offline/project/list
  static const String projectList = '/crowdfunding/offline/project/list';
}

const String fundingOauthClientAuthorization = 'Basic d2ViQXBwOndlYkFwcA==';
const String defaultIntlCode = '81';
