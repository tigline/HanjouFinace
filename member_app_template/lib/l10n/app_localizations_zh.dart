// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get loginTitle => '登录';

  @override
  String get loginAccountLabel => '手机号或邮箱';

  @override
  String get loginCodeLabel => '验证码';

  @override
  String get loginSendCode => '发送验证码';

  @override
  String get loginSubmit => '登录';

  @override
  String get loginErrorSendCodeFailed => '验证码发送失败，请稍后重试';

  @override
  String get loginErrorInvalidCode => '登录失败，请检查验证码';

  @override
  String get homeTitle => '首页';

  @override
  String get homeLogout => '退出登录';

  @override
  String get uiErrorRequestFailed => '请求失败，请稍后重试';

  @override
  String get uiErrorNetworkUnavailable => '网络连接异常，请稍后重试';

  @override
  String get uiErrorAuthExpired => '登录状态已失效，请重新登录';

  @override
  String get uiErrorForbidden => '暂无权限访问该资源';

  @override
  String get uiErrorServerUnavailable => '服务暂时不可用，请稍后重试';

  @override
  String get languageFollowSystem => '跟随系统';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => '英文';

  @override
  String get languageJapanese => '日文';
}
