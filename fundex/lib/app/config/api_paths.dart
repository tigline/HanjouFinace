/// Funding (crowdfunding) member/auth API paths used by `feature_auth`.
///
/// Source of truth:
/// - Swagger UI: https://sit-admin.gutingjun.com/api/swagger-ui.html#/
/// - OpenAPI docs: https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs
///
/// For user-related auth/member APIs, prioritize `user-rest` and `off-rest`
/// definitions in funding Swagger. Do not add new funding endpoints from the
/// legacy GetX project `http_conf.dart` unless Swagger is missing the endpoint
/// and the fallback is documented in `README_API.md`.
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

const String fundingOauthClientAuthorization = 'Basic d2ViQXBwOndlYkFwcA==';
const String defaultIntlCode = '81';
