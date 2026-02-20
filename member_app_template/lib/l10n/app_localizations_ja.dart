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
  String get loginAccountLabel => '電話番号またはメール';

  @override
  String get loginCodeLabel => '認証コード';

  @override
  String get loginSendCode => 'コード送信';

  @override
  String get loginSubmit => 'ログイン';

  @override
  String get loginErrorSendCodeFailed => 'コード送信に失敗しました。後でもう一度お試しください。';

  @override
  String get loginErrorInvalidCode => 'ログインに失敗しました。認証コードを確認してください。';

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
