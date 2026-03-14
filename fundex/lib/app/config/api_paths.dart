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

  /// Source: README_API.md section 6.
  /// Full URL sample:
  /// https://testoa.gutingjun.com/api/crowdfunding/offline/project/detail?id=453461223669231137
  static const String projectDetail = '/crowdfunding/offline/project/detail';
}

/// Funding member/my-page APIs used by `feature_member_profile`.
class FundingMemberApiPath {
  const FundingMemberApiPath._();

  /// Source: backend sample request provided for account assets.
  static const String accountStatistic = '/member/login/account-statistic';

  /// Source: README_API.md section 7.
  static const String applyList = '/crowdfunding/user/apply/list';

  /// Source: README_API.md section 8.
  static const String orderInquiryPage = '/crowdfunding/secondary/market/page';

  /// Source: README_API.md section 9.
  static const String myInvestmentList = '/crowdfunding/user/invest/list';

  /// Source: funding Swagger (`user-rest`).
  static const String saveMemberInfo = '/crowdfunding/user/save-member-info';

  /// Source: funding Swagger (`user-rest`).
  static const String uploadPhoto = '/crowdfunding/user/upload/photo';

  /// Source: funding Swagger (`user-rest`) `regionByZipUsingGET`.
  static const String regionByZip = '/crowdfunding/user/region/zip';

  /// Source: backend requirement for selfie upload.
  static const String uploadRealPersonPhoto = '/member/real/person/upload';
}

/// Funding comment-board APIs used by `feature_discussion_board`.
class FundingCommentApiPath {
  const FundingCommentApiPath._();

  /// Source: crowdfunding Swagger (`comment-rest`).
  static const String commentPage = '/crowdfunding/comment/page';

  /// Source: crowdfunding Swagger (`comment-rest`).
  static const String commentSend = '/crowdfunding/comment/send';

  /// Source: crowdfunding Swagger (`comment-rest`).
  static const String commentDelete = '/crowdfunding/comment/delete';
}

const String fundingOauthClientAuthorization = 'Basic d2ViQXBwOndlYkFwcA==';
const String defaultIntlCode = '81';
