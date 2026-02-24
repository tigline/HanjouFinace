// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get loginTitle => 'ログイン';

  @override
  String get loginSubtitle => '会員向け投資・宿泊特典へ安全にアクセス。';

  @override
  String get loginAccountLabel => '電話番号またはメール';

  @override
  String get loginModeTitle => 'ログイン方法を選択';

  @override
  String get loginCodeLabel => '認証コード';

  @override
  String get loginSendCode => 'コード送信';

  @override
  String get loginSubmit => 'ログイン';

  @override
  String get loginCreateAccount => '新規登録';

  @override
  String get loginForgotPassword => 'パスワードを忘れた場合';

  @override
  String get loginFootnote => '日本市場とグローバル利用を意識した、上質で安全なUX設計。';

  @override
  String get loginErrorSendCodeFailed => 'コード送信に失敗しました。後でもう一度お試しください。';

  @override
  String get loginErrorInvalidCode => 'ログインに失敗しました。認証コードを確認してください。';

  @override
  String get loginEmailAccountInvalid => 'メールログインには有効なメールアドレスを入力してください。';

  @override
  String get loginMobileAccountInvalid => '電話ログインには有効な電話番号を入力してください。';

  @override
  String get registerTitle => 'アカウント作成';

  @override
  String get registerSubtitle => '投資・予約・会員特典に使う安全なアカウントを設定します。';

  @override
  String get registerModeTitle => '登録方法';

  @override
  String get authModeEmail => 'メール';

  @override
  String get authModeMobile => '電話';

  @override
  String get registerAccountLabel => '電話番号またはメール';

  @override
  String get registerEmailAccountLabel => 'メールアドレス';

  @override
  String get registerMobileAccountLabel => '電話番号';

  @override
  String get registerCodeLabel => '認証コード';

  @override
  String get registerSendCode => 'コード送信';

  @override
  String get registerSendCodeSuccess => '登録用コードを送信しました。';

  @override
  String get registerContactLabel => '連絡先情報';

  @override
  String get registerContactHelperEmail => 'メール登録の場合は電話番号を入力してください。';

  @override
  String get registerContactHelperMobile => '任意：アカウント連携用メールを入力できます。';

  @override
  String get registerPasswordLabel => 'パスワード';

  @override
  String get registerConfirmPasswordLabel => 'パスワード確認';

  @override
  String get registerInviteCodeLabel => '招待コード（任意）';

  @override
  String get registerAcceptPolicy => '利用規約とプライバシーポリシーに同意します。';

  @override
  String get registerPolicyButton => '表示';

  @override
  String get registerPolicyTitle => '規約とプライバシー';

  @override
  String get registerPolicyDescription =>
      'この画面は共通のボトムシートUIを利用したサンプルです。正式な法務コンテンツ連携に置き換えてください。';

  @override
  String get registerSubmit => 'アカウント作成';

  @override
  String get registerBackToLogin => '既にアカウントをお持ちですか？ ログインへ';

  @override
  String get registerPasswordMismatchTitle => 'パスワードが一致しません';

  @override
  String get registerPasswordMismatchMessage => '2つのパスワードが同一であることを確認してください。';

  @override
  String get registerUiReadyTitle => '登録UIは実装済みです';

  @override
  String get registerUiReadyMessage => 'UI実装は完了しました。次はAPI連携です。';

  @override
  String get registerEmailMobileRequired => 'メール登録には電話番号が必要です。';

  @override
  String get registerEmailAccountInvalid => 'メール登録には有効なメールアドレスを入力してください。';

  @override
  String get registerMobileAccountInvalid => '電話登録には有効な電話番号を入力してください。';

  @override
  String get registerSubmitFailed => '登録に失敗しました。後でもう一度お試しください。';

  @override
  String get registerSuccessTitle => '登録完了';

  @override
  String get registerSuccessMessage => 'アカウントを作成しました。ログインしてください。';

  @override
  String get forgotPasswordTitle => 'パスワード再設定';

  @override
  String get forgotPasswordSubtitle => '安全な認証でアカウントアクセスを復旧します。';

  @override
  String get forgotPasswordAccountLabel => '電話番号またはメール';

  @override
  String get forgotPasswordCodeLabel => '認証コード';

  @override
  String get forgotPasswordSendCode => 'コード送信';

  @override
  String get forgotPasswordSendCodeSuccess => '認証コードを送信しました。';

  @override
  String get forgotPasswordNewPasswordLabel => '新しいパスワード';

  @override
  String get forgotPasswordConfirmPasswordLabel => '新しいパスワード確認';

  @override
  String get forgotPasswordSubmit => 'パスワード更新';

  @override
  String get forgotPasswordMismatchTitle => 'パスワードが一致しません';

  @override
  String get forgotPasswordMismatchMessage => '新しいパスワードと確認入力を見直してください。';

  @override
  String get forgotPasswordUiReadyTitle => '再設定UIは実装済みです';

  @override
  String get forgotPasswordUiReadyMessage => 'UI実装は完了しました。次はAPI連携です。';

  @override
  String get forgotPasswordRecoverFailed => 'アクセス復旧に失敗しました。認証コードを確認してください。';

  @override
  String get commonOk => 'OK';

  @override
  String get commonBackToLogin => 'ログインへ戻る';

  @override
  String get homeTitle => 'ホーム';

  @override
  String get homeLogout => 'ログアウト';

  @override
  String get uiErrorRequestFailed => 'リクエストに失敗しました。後でもう一度お試しください。';

  @override
  String get uiErrorNetworkUnavailable => 'ネットワーク接続に問題があります。後でもう一度お試しください。';

  @override
  String get uiErrorAuthExpired => 'セッションの有効期限が切れました。再度ログインしてください。';

  @override
  String get uiErrorForbidden => 'このリソースにアクセスする権限がありません。';

  @override
  String get uiErrorServerUnavailable => 'サービスは一時的に利用できません。後でもう一度お試しください。';

  @override
  String get languageFollowSystem => 'システムに従う';

  @override
  String get languageChinese => '中国語';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageJapanese => '日本語';
}
