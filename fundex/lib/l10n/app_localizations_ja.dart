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
  String get registerQuickTitle => 'まずはアカウントを作成';

  @override
  String get registerQuickSubtitle =>
      'メールアドレスと認証コードで登録できます。投資に必要な情報は登録後に入力できます。';

  @override
  String get registerModeTitle => '登録方法';

  @override
  String get authModeEmail => 'メール';

  @override
  String get authModeMobile => '電話';

  @override
  String get splashBrandName => 'FUNDEX';

  @override
  String get splashTagline => '不動産クラウドファンディング';

  @override
  String get authEntryHeadline => '投資・宿泊会員サービスをひとつのログインで';

  @override
  String get authEntryDescription => '電話番号またはメールでログインし、投資・予約・会員特典をまとめて管理できます。';

  @override
  String get authEntryPhoneLogin => '電話でログイン';

  @override
  String get authEntryEmailLogin => 'メールでログイン';

  @override
  String get authEntryNonMemberRegisterNow => '会員ではありませんか？ 今すぐ登録';

  @override
  String get authBeforeMemberDirectLogin => '会員の方はこちらからログイン';

  @override
  String get authBeforeNonMemberRegister => '非会員の方は新規登録';

  @override
  String get authRegisterEntryHeadline => '登録方法を選択';

  @override
  String get authRegisterEntryDescription =>
      '電話番号またはメールでアカウントを作成し、会員サービスを一元管理します。';

  @override
  String get authEntryPhoneRegister => '電話で登録';

  @override
  String get authEntryEmailRegister => 'メールで登録';

  @override
  String get authBackToLoginEntry => 'ログイン方法へ戻る';

  @override
  String get authBackToRegisterEntry => '登録方法へ戻る';

  @override
  String get authIntlCodeLabel => '電話国番号';

  @override
  String get authIntlCodePickerTitle => '電話国番号を選択';

  @override
  String get authMethodFormSubtitle => '認証コードで安全に確認を完了します。';

  @override
  String get profileOnboardingTitle => '詳細情報の入力';

  @override
  String get profileEditTitle => '詳細情報を編集';

  @override
  String get profileOnboardingCardTitle => '取引・宿泊前の本人情報確認';

  @override
  String get profileOnboardingCardSubtitle =>
      '取引・宿泊の確認要件のため詳細情報を入力してください。あとで入力することもできます。';

  @override
  String get profileEditCardTitle => '詳細情報';

  @override
  String get profileEditCardSubtitle => '前回ローカル保存した内容を保持したまま再編集できます。';

  @override
  String get profileLastSavedHint => '前回保存したローカル情報を読み込みました。';

  @override
  String get profileSkipButton => 'あとで入力';

  @override
  String get profileStepName => '氏名';

  @override
  String get profileStepNameSubtitle => '日本式の順序で姓・名を入力します。';

  @override
  String get profileStepContact => '連絡先';

  @override
  String get profileStepContactSubtitle => '住所・電話・メールを入力します（利用可能な場合は自動入力）。';

  @override
  String get profileStepDocument => '本人確認書類の写真';

  @override
  String get profileStepDocumentSubtitle => '後続の取引・宿泊確認のため書類写真をアップロードします。';

  @override
  String get profileFamilyNameLabel => '姓';

  @override
  String get profileFamilyNameHint => '姓を入力';

  @override
  String get profileGivenNameLabel => '名';

  @override
  String get profileGivenNameHint => '名を入力';

  @override
  String get profileAddressLabel => '住所';

  @override
  String get profileAddressHint => '住所を入力（都道府県 / 市区町村 / 番地 / 建物名）';

  @override
  String get profilePhoneLabel => '電話番号';

  @override
  String get profilePhoneHint => '電話番号を入力';

  @override
  String get profileEmailLabel => 'メールアドレス';

  @override
  String get profileEmailHint => 'メールアドレスを入力';

  @override
  String get profileDocumentPhotoLabel => '本人確認書類の写真';

  @override
  String get profileDocumentAddPhoto => '書類写真をアップロード';

  @override
  String get profileDocumentChangePhoto => '書類写真を変更';

  @override
  String get profileDocumentRemovePhoto => '書類写真を削除';

  @override
  String get profileDocumentTakePhoto => '写真を撮る';

  @override
  String get profileDocumentPickFromGallery => '写真ライブラリから選択';

  @override
  String get profileDocumentHint => '後続の確認作業のため、鮮明で文字が見える書類写真をアップロードしてください。';

  @override
  String get profileDocumentAttachedBadge => '添付済み';

  @override
  String get profilePrevStep => '戻る';

  @override
  String get profileNextStep => '次へ';

  @override
  String get profileSaveButton => '保存';

  @override
  String get profileSavedTitle => '詳細情報を保存しました';

  @override
  String get profileSavedAndContinueLoginMessage =>
      '詳細情報はローカルに保存されました。続けてログインできます。';

  @override
  String get profileSavedSnackbar => '詳細情報をローカルに保存しました。';

  @override
  String get profileIntakeValidationTitle => '入力未完了';

  @override
  String get profileFamilyNameRequired => '姓を入力してください。';

  @override
  String get profileGivenNameRequired => '名を入力してください。';

  @override
  String get profileAddressRequired => '住所を入力してください。';

  @override
  String get profilePhoneRequired => '有効な電話番号を入力してください。';

  @override
  String get profileEmailRequired => '有効なメールアドレスを入力してください。';

  @override
  String get profileDocumentPhotoRequired => '本人確認書類の写真をアップロードしてください。';

  @override
  String get profileDocumentPickFailed => '書類写真の選択に失敗しました。再度お試しください。';

  @override
  String get profileIncompleteBannerTitle => '詳細情報が未完了です';

  @override
  String get profileIncompleteBannerSubtitle => '取引・宿泊には詳細情報の完了が必要です。';

  @override
  String get profileIncompleteBannerBody =>
      '氏名、住所、電話、メール、本人確認書類の写真を入力後に取引または宿泊手続きを進めてください。';

  @override
  String get profileGuardTitle => '先に詳細情報の入力が必要です';

  @override
  String get profileGuardMessage => '取引または宿泊の前に詳細情報を入力してください。';

  @override
  String profileGuardMessageWithAction(Object actionLabel) {
    return '「$actionLabel」の前に詳細情報の入力が必要です。';
  }

  @override
  String get profileGuardCancel => 'キャンセル';

  @override
  String get profileGuardGoFill => '入力する';

  @override
  String profileGuardPassMessage(Object actionLabel) {
    return '詳細情報の確認が完了しました。$actionLabelを続けられます。';
  }

  @override
  String get profileStatusCardTitle => '詳細情報の状態';

  @override
  String get profileStatusCompleted => '完了済み。取引・宿泊を進められます。';

  @override
  String get profileStatusIncomplete => '未完了。取引・宿泊前に詳細情報を入力してください。';

  @override
  String get profileStatusLoadFailed => '詳細情報の状態を読み込めませんでした。';

  @override
  String get profileEditEntryButton => '入力 / 編集';

  @override
  String get profileProtectedBookingAction => '宿泊予約';

  @override
  String get profileProtectedTradeAction => '取引';

  @override
  String get authMobileLoginTitle => '電話ログイン';

  @override
  String get authEmailLoginTitle => 'メールログイン';

  @override
  String get authMobileRegisterTitle => '電話登録';

  @override
  String get authEmailRegisterTitle => 'メール登録';

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
  String get mainTabHome => 'ホーム';

  @override
  String get mainTabHotel => 'ホテル';

  @override
  String get mainTabDiscussion => '掲示板';

  @override
  String get mainTabInvestment => '投資';

  @override
  String get mainTabProfile => 'マイページ';

  @override
  String get mainTabKizunark => 'KIZUNARK';

  @override
  String get mainTabSettings => '設定';

  @override
  String get homeHeroTitle => '投資サマリー';

  @override
  String get homeHeroSubtitle => '保有状況、評価損益、利用可能資金をすぐに確認できます。';

  @override
  String get homeHeroAssetsLabel => '総資産';

  @override
  String get homeHeroPnlLabel => '評価損益';

  @override
  String get homeHeroCashLabel => '利用可能資金';

  @override
  String homeWelcomeUser(Object name) {
    return 'おかえりなさい、$name 👋';
  }

  @override
  String get homeHeroTotalAssetsAmountLabel => '総資産額';

  @override
  String get homeHeroMonthlyDelta => '+¥127,500（前月比 +3.4%）';

  @override
  String get homeHeroActiveInvestmentLabel => '運用中';

  @override
  String get homeHeroTotalDividendsLabel => '累計分配金';

  @override
  String get homeReminderProfileTitle => '本人情報を入力して投資を始めましょう';

  @override
  String get homeReminderProfileBody => '投資するには本人確認が必要です。あと3ステップで完了。';

  @override
  String get homeReminderCoolingOffTitle => 'クーリングオフ期間中';

  @override
  String get homeReminderCoolingOffBody =>
      '「商業ビル心斎橋」\n契約書面交付日 3/2 → 取消期限 3/10（8日間）\n残り5日';

  @override
  String get homeReminderCoolingOffAction => '取消手続き';

  @override
  String get homeFeaturedFundsTitle => '🔥 注目ファンド';

  @override
  String get homeViewAllAction => 'すべて見る';

  @override
  String get homeEstimatedYieldLabel => '想定利回り';

  @override
  String get homeTagOpen => '募集中';

  @override
  String get homeTagLottery => '抽選';

  @override
  String get homeTagUpcoming => '募集前';

  @override
  String get homeActiveFundsTitle => '📊 運用中ファンド';

  @override
  String get homeInvestedAmountLabel => '投資額';

  @override
  String get homeNextDividendLabel => '次回配当';

  @override
  String get homeShowMoreAction => 'もっと見る';

  @override
  String get homeShowLessAction => '表示を減らす';

  @override
  String get homeMockFeaturedFundA => '東京都港区 プレミアムレジデンス赤坂';

  @override
  String get homeMockFeaturedFundB => '大阪市中央区 商業ビル心斎橋';

  @override
  String get homeMockFeaturedFundC => '京都市東山区 町家リノベホテル';

  @override
  String get homeMockFeaturedMetaA => '12ヶ月 ・ 2億円';

  @override
  String get homeMockFeaturedMetaB => '18ヶ月 ・ 1.5億円';

  @override
  String get homeMockFeaturedMetaC => '24ヶ月 ・ 3億円';

  @override
  String get homeMockActiveFundA => '渋谷区 オフィスビル #12';

  @override
  String get homeMockActiveFundB => '名古屋市 物流施設 #09';

  @override
  String get homeMockActiveFundC => '福岡市 レジデンスファンド #07';

  @override
  String get homeMockActiveFundD => '札幌市 複合施設ファンド #03';

  @override
  String get fundListTitle => 'ファンド一覧';

  @override
  String get fundListFilterAll => 'すべて';

  @override
  String get fundListFilterOperating => '運用中';

  @override
  String get fundListFilterOperatingEnded => '運用終了';

  @override
  String get fundListFilterOpen => '募集中';

  @override
  String get fundListFilterUpcoming => '募集前';

  @override
  String get fundListFilterClosed => '募集終了';

  @override
  String get fundListFilterCompleted => '募集完成';

  @override
  String get fundListFilterFailed => '募集失敗';

  @override
  String get fundListYieldLabel => '利回り';

  @override
  String get fundListPeriodLabel => '運用期間';

  @override
  String get fundListMethodLabel => '募集方式';

  @override
  String get fundListMethodLottery => '抽選';

  @override
  String get fundListMethodUnknown => '未設定';

  @override
  String fundListAppliedAmount(Object amount, Object progress) {
    return '応募金額 $amount（$progress）';
  }

  @override
  String fundListOpenStartAt(Object start) {
    return '募集開始 $start〜';
  }

  @override
  String get fundListViewDetail => '詳細を確認 →';

  @override
  String get fundListLoadError => 'ファンド一覧の取得に失敗しました。再度お試しください。';

  @override
  String get fundListRetry => '再試行';

  @override
  String get fundListEmpty => 'この条件に一致するファンドがありません。';

  @override
  String get fundListStatusOperating => '運用中';

  @override
  String get fundListStatusOperatingEnded => '運用終了';

  @override
  String get fundListStatusOpen => '募集中';

  @override
  String get fundListStatusUpcoming => '募集前';

  @override
  String get fundListStatusClosed => '募集終了';

  @override
  String get fundListStatusCompleted => '募集完成';

  @override
  String get fundListStatusFailed => '募集失敗';

  @override
  String get fundListStatusUnknown => '未設定';

  @override
  String fundListVolume(Object number) {
    return 'Vol. $number';
  }

  @override
  String get hotelTabHeadline => 'ホテル予約モジュール（枠組み）';

  @override
  String get hotelTabSubtitle => '今後ここに検索・一覧・詳細・予約フローを実装します。';

  @override
  String get discussionTabHeadline => '投資ディスカッション掲示板（枠組み）';

  @override
  String get discussionTabSubtitle => '返信・いいね・固定表示・審査に対応する掲示板型UIを今後実装します。';

  @override
  String get discussionTabReplyAction => '返信';

  @override
  String get investmentTabHeadline => '投資関連モジュール（枠組み）';

  @override
  String get investmentTabSubtitle => '商品一覧、保有、申込/解約、明細などを今後実装します。';

  @override
  String get investmentTabPortfolioLabel => '保有案件';

  @override
  String get investmentTabWatchlistLabel => 'ウォッチ';

  @override
  String get profileTabHeadline => '個人センター（枠組み）';

  @override
  String get profileTabSubtitle => 'アカウント情報、詳細情報入力、設定、会員状態を管理します。';

  @override
  String get settingsTabHeadline => '設定';

  @override
  String get settingsTabSubtitle => 'アカウント・セキュリティ・法定書面・各種設定をここに統合します。';

  @override
  String get notificationsTitle => 'お知らせ';

  @override
  String get notificationsLotteryTitle => '抽選結果';

  @override
  String get notificationsLotterySubtitle => 'API連携後、抽選結果と入金案内の通知をここに表示します。';

  @override
  String get notificationsSystemTitle => 'システム通知';

  @override
  String get notificationsSystemSubtitle => 'メンテナンス、報告書、法令関連のお知らせ。';

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

  @override
  String get fundDetailEstimatedYieldAnnualLabel => '想定利回り（年率）';

  @override
  String get fundDetailYieldDisclaimer => '※ 想定であり、保証するものではありません';

  @override
  String get fundDetailKeyFactsTitle => '📌 基本情報';

  @override
  String get fundDetailFundTotalLabel => '募集金額';

  @override
  String get fundDetailMinimumInvestmentLabel => '最低投資額';

  @override
  String get fundDetailDividendLabel => '配当';

  @override
  String get fundDetailLotteryDateLabel => '抽選日';

  @override
  String get fundDetailPreferredStructureTitle => '🛡️ 優先劣後構造';

  @override
  String get fundDetailSeniorInvestmentLabel => '優先出資';

  @override
  String get fundDetailJuniorInvestmentLabel => '劣後出資';

  @override
  String get fundDetailPropertyInfoTitle => '📍 物件情報';

  @override
  String get fundDetailLocationLabel => '所在地';

  @override
  String get fundDetailPropertyTypeLabel => '種別';

  @override
  String get fundDetailStructureLabel => '構造';

  @override
  String get fundDetailBuiltYearLabel => '竣工';

  @override
  String get fundDetailContractOverviewTitle => '📋 契約概要（法定記載事項）';

  @override
  String get fundDetailContractTypeLabel => '契約形態';

  @override
  String get fundDetailContractTypeValue => '匿名組合型';

  @override
  String get fundDetailTargetPropertyTypeLabel => '対象不動産の種類';

  @override
  String get fundDetailAppraisalValueLabel => '不動産鑑定評価額';

  @override
  String get fundDetailAcquisitionPriceLabel => '取得予定価格';

  @override
  String get fundDetailOfferPeriodLabel => '募集期間';

  @override
  String get fundDetailOperationStartLabel => '運用開始予定日';

  @override
  String get fundDetailOperationEndLabel => '運用終了予定日';

  @override
  String get fundDetailOperatorInfoTitle => '🏢 事業者情報';

  @override
  String get fundDetailOperatorCompanyLabel => '運営会社';

  @override
  String get fundDetailPermitNumberLabel => '許可番号';

  @override
  String get fundDetailRepresentativeLabel => '代表者';

  @override
  String get fundDetailCompanyAddressLabel => '所在地';

  @override
  String get fundDetailDocumentsTitle => '📄 関連書面';

  @override
  String get fundDetailDocumentReady => 'タップして確認';

  @override
  String get fundDetailDocumentUnavailable => '書面URL未設定';

  @override
  String get fundDetailCommentsTitle => '💬 投資家の声';

  @override
  String get fundDetailCommentsPlaceholder => 'コメント機能は今回未実装です。UIのみ後続で接続します。';

  @override
  String get fundDetailApplyNowAction => '抽選に申し込む';

  @override
  String get fundDetailOpenSoonAction => '募集開始を待つ';

  @override
  String get fundDetailUnavailableAction => '現在申込できません';

  @override
  String get fundDetailApplyComingSoonToast => '申込フローは次の実装で接続します。';

  @override
  String get fundDetailUnknownValue => '--';

  @override
  String get fundDetailOneUnitSuffix => '（1口）';

  @override
  String get fundDetailMonthlyDistribution => '毎月';

  @override
  String get fundDetailQuarterlyDistribution => '四半期毎';

  @override
  String get fundDetailSemiAnnualDistribution => '半年毎';

  @override
  String get fundDetailAnnualDistribution => '年1回';
}
