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
  String get loginSubtitle => '进入会员投资与订房权益中心。';

  @override
  String get loginAccountLabel => '手机号或邮箱';

  @override
  String get loginModeTitle => '请选择登录方式';

  @override
  String get loginCodeLabel => '验证码';

  @override
  String get loginSendCode => '发送验证码';

  @override
  String get loginSubmit => '登录';

  @override
  String get loginCreateAccount => '注册账号';

  @override
  String get loginForgotPassword => '找回密码';

  @override
  String get loginFootnote => '面向国际会员设计，兼顾日本市场体验与隐私规范。';

  @override
  String get loginErrorSendCodeFailed => '验证码发送失败，请稍后重试';

  @override
  String get loginErrorInvalidCode => '登录失败，请检查验证码';

  @override
  String get loginEmailAccountInvalid => '邮箱登录请填写有效邮箱地址。';

  @override
  String get loginMobileAccountInvalid => '手机登录请填写有效手机号。';

  @override
  String get registerTitle => '创建账号';

  @override
  String get registerSubtitle => '开通安全账号，统一管理投资、订房与会员权益。';

  @override
  String get registerModeTitle => '注册方式';

  @override
  String get authModeEmail => '邮箱';

  @override
  String get authModeMobile => '手机';

  @override
  String get authEntryHeadline => '投资与订房会员服务一站登录';

  @override
  String get authEntryDescription => '使用手机号或邮箱快速登录，统一管理投资、订房与会员权益。';

  @override
  String get authEntryPhoneLogin => '手机号登录';

  @override
  String get authEntryEmailLogin => '邮箱登录';

  @override
  String get authEntryNonMemberRegisterNow => '非会员？立即注册';

  @override
  String get authRegisterEntryHeadline => '请选择注册方式';

  @override
  String get authRegisterEntryDescription => '手机号或邮箱均可创建账号，注册后统一管理会员权益。';

  @override
  String get authEntryPhoneRegister => '手机号注册';

  @override
  String get authEntryEmailRegister => '邮箱注册';

  @override
  String get authBackToLoginEntry => '返回登录入口';

  @override
  String get authBackToRegisterEntry => '返回注册方式';

  @override
  String get authIntlCodeLabel => '手机区号';

  @override
  String get authIntlCodePickerTitle => '选择手机区号';

  @override
  String get authMethodFormSubtitle => '使用验证码完成安全验证。';

  @override
  String get authMobileLoginTitle => '手机号登录';

  @override
  String get authEmailLoginTitle => '邮箱登录';

  @override
  String get authMobileRegisterTitle => '手机号注册';

  @override
  String get authEmailRegisterTitle => '邮箱注册';

  @override
  String get registerAccountLabel => '手机号或邮箱';

  @override
  String get registerEmailAccountLabel => '邮箱';

  @override
  String get registerMobileAccountLabel => '手机号';

  @override
  String get registerCodeLabel => '验证码';

  @override
  String get registerSendCode => '发送验证码';

  @override
  String get registerSendCodeSuccess => '注册验证码已发送。';

  @override
  String get registerContactLabel => '联系信息';

  @override
  String get registerContactHelperEmail => '邮箱注册时请填写手机号。';

  @override
  String get registerContactHelperMobile => '可选：填写邮箱用于账号绑定。';

  @override
  String get registerPasswordLabel => '密码';

  @override
  String get registerConfirmPasswordLabel => '确认密码';

  @override
  String get registerInviteCodeLabel => '邀请码（选填）';

  @override
  String get registerAcceptPolicy => '我已阅读并同意《服务条款》与《隐私政策》。';

  @override
  String get registerPolicyButton => '查看';

  @override
  String get registerPolicyTitle => '条款与隐私';

  @override
  String get registerPolicyDescription => '此处示例展示复用的底部弹框。后续可接入正式法务内容与版本记录。';

  @override
  String get registerSubmit => '创建账号';

  @override
  String get registerBackToLogin => '已有账号？去登录';

  @override
  String get registerPasswordMismatchTitle => '两次密码不一致';

  @override
  String get registerPasswordMismatchMessage => '请确认两次输入的密码完全一致。';

  @override
  String get registerUiReadyTitle => '注册页面已就绪';

  @override
  String get registerUiReadyMessage => 'UI 已完成，可继续接入注册接口。';

  @override
  String get registerEmailMobileRequired => '邮箱注册必须填写手机号。';

  @override
  String get registerEmailAccountInvalid => '邮箱注册请填写有效邮箱地址。';

  @override
  String get registerMobileAccountInvalid => '手机注册请填写有效手机号。';

  @override
  String get registerSubmitFailed => '注册失败，请稍后重试。';

  @override
  String get registerSuccessTitle => '注册成功';

  @override
  String get registerSuccessMessage => '账号已创建，请登录。';

  @override
  String get forgotPasswordTitle => '重置密码';

  @override
  String get forgotPasswordSubtitle => '通过安全验证恢复账号访问。';

  @override
  String get forgotPasswordAccountLabel => '手机号或邮箱';

  @override
  String get forgotPasswordCodeLabel => '验证码';

  @override
  String get forgotPasswordSendCode => '发送验证码';

  @override
  String get forgotPasswordSendCodeSuccess => '验证码已发送。';

  @override
  String get forgotPasswordNewPasswordLabel => '新密码';

  @override
  String get forgotPasswordConfirmPasswordLabel => '确认新密码';

  @override
  String get forgotPasswordSubmit => '更新密码';

  @override
  String get forgotPasswordMismatchTitle => '两次密码不一致';

  @override
  String get forgotPasswordMismatchMessage => '请检查新密码与确认密码是否一致。';

  @override
  String get forgotPasswordUiReadyTitle => '找回密码页面已就绪';

  @override
  String get forgotPasswordUiReadyMessage => 'UI 已完成，可继续接入找回密码接口。';

  @override
  String get forgotPasswordRecoverFailed => '恢复访问失败，请检查验证码。';

  @override
  String get commonOk => '知道了';

  @override
  String get commonBackToLogin => '返回登录';

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
