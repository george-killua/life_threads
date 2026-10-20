// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get send => '送信';

  @override
  String get preparing => '準備中...';

  @override
  String get settingsTitle => '設定';

  @override
  String get languageTitle => '言語';

  @override
  String get languageBody =>
      'アプリの言語を選びます。「システム」は、LifeThreadsが対応していればスマホの言語に合わせます。';

  @override
  String get systemLanguage => 'システム';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return '言語を$languageに変更しました。';
  }

  @override
  String get privacyTitle => 'プライバシー';

  @override
  String get privacyBody =>
      'LifeThreadsはローカルファースト。アカウントも公開プロフィールもありません。バックアップの書き出し、暗号化カプセルの共有、別の画面へのウォール表示をしない限り、思い出はこの端末に残ります。';

  @override
  String get viewPrivacyPolicy => 'プライバシーポリシーを見る';

  @override
  String get termsTitle => '利用規約';

  @override
  String get viewTerms => '規約を見る';

  @override
  String get betaFeedbackTitle => 'ベータ版フィードバック';

  @override
  String get betaFeedbackBody =>
      '安全な診断情報つきでベータ版のフィードバックを送れます。ログに含まれるのはアプリのイベントとクラッシュの種類だけで、思い出の本文、写真のパス、バックアップ、正確な位置情報は含まれません。';

  @override
  String get closedBetaBadge => 'クローズドベータ';

  @override
  String get sendFeedback => 'フィードバックを送信';

  @override
  String get backupArchiveBody =>
      '思い出、写真、メモ、糸、レイアウトをまとめて1つのファイルに保存。パソコンや自分のクラウドに保管でき、パスワードで暗号化もできます。';

  @override
  String get backupArchiveTitle => 'バックアップ';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => '解除';

  @override
  String get exportArchive => 'アーカイブを書き出す';

  @override
  String get importArchive => 'アーカイブを読み込む';

  @override
  String get importCapsule => 'カプセルを読み込む';

  @override
  String get moveDevices => '機種変更';

  @override
  String get themeTitle => 'テーマ';

  @override
  String get themeBody =>
      'プライベートなウォールの雰囲気を選びましょう。無料版は「ぬくもりの部屋」。Premiumならすべての雰囲気が使えます。';

  @override
  String get oneFreeBadge => '1つ無料';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'Premiumサブスクリプションは有効です。';

  @override
  String get premiumLockedBody => '年額または月額:思い出が無制限、複数のウォール、ストーリー、テーマ、レイアウト。';

  @override
  String get activeBadge => '有効';

  @override
  String get openPremium => 'Premiumを開く';

  @override
  String get appVersionTitle => 'アプリのバージョン';

  @override
  String get clearAllDataTitle => 'すべてのデータを消去';

  @override
  String get clearAllDataBody => 'この端末からすべての思い出、つながり、メモ、ピン、コピーした写真を削除します。';

  @override
  String get clearData => 'データを消去';

  @override
  String exportFailed(Object error) {
    return '書き出しに失敗しました:$error';
  }

  @override
  String importRejected(Object message) {
    return '読み込みが拒否されました:$message';
  }

  @override
  String importFailed(Object error) {
    return '読み込みに失敗しました:$error';
  }

  @override
  String deleteFailed(Object message) {
    return '削除に失敗しました:$message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'カプセルが拒否されました:$message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'カプセルの読み込みに失敗しました:$error';
  }

  @override
  String get clearAllDataQuestion => 'すべてのデータを消去しますか?';

  @override
  String get clearAllDataQuestionBody =>
      'この端末にあるLifeThreadsのローカルデータがすべて完全に削除されます。残したい場合は先にバックアップを書き出してください。';

  @override
  String get clearAll => 'すべて消去';

  @override
  String get allLocalDataCleared => 'ローカルデータをすべて消去しました。';

  @override
  String get feedbackGeneral => '全般';

  @override
  String get feedbackBug => '不具合';

  @override
  String get feedbackCrash => 'クラッシュ';

  @override
  String get feedbackDesign => 'デザインの問題';

  @override
  String get feedbackMissingFeature => 'ほしい機能';

  @override
  String get feedbackPerformance => '動作の速さ';

  @override
  String get betaFeedbackIntro =>
      '何が起きたか、どこが気になったかを書いてください。思い出の内容を含まない安全な診断情報が添付されます。';

  @override
  String get feedbackType => '種類';

  @override
  String get feedbackLabel => 'フィードバック';

  @override
  String get feedbackHint => '例:追加 > クイック写真をタップしたら画面が固まった。';

  @override
  String get betaFeedbackNotIncluded =>
      '含まれないもの:思い出のタイトル、ストーリー、メモ、写真のパス、バックアップのパス、正確な位置情報。';

  @override
  String get feedbackEmpty => 'まず短いメッセージを書いてください。';

  @override
  String get feedbackCopied =>
      'メールアプリが開きませんでした。info@gkcoding.dev宛てのフィードバックをクリップボードにコピーしました。';

  @override
  String themeSelected(Object theme) {
    return '$themeを選びました。';
  }

  @override
  String get onboardingHeadline => '生きたウォールをつくろう。';

  @override
  String get onboardingBody => '写真や場所、人、小さなメモが、気持ちの糸でつながるプライベートな思い出の部屋。';

  @override
  String get onboardingPrivacy =>
      '思い出は最初から非公開。アカウントも公開プロフィールもありません。暗号化されたクラウド共有やバックアップは、あなたが選んだときだけ行われます。';

  @override
  String get onboardingPrivacyShort =>
      'アカウントも公開プロフィールもなし。あなたが選ばない限り、思い出はこの端末に残ります。';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingNameTitle => 'なんて呼べばいい?';

  @override
  String get onboardingNameHint => 'あなたの名前';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'よろしくね、$nameさん。';
  }

  @override
  String get onboardingGetStartedTitle => 'はじめ方を選ぶ';

  @override
  String get onboardingGetStartedBody =>
      'サンプルのウォールを見てみるか、まっさらなウォールに自分の思い出を飾りましょう。';

  @override
  String get settingsNameTitle => 'あなたの名前';

  @override
  String get settingsNameBody => 'ウォールのあいさつに表示されます。';

  @override
  String get settingsNameHint => 'あなたの名前';

  @override
  String get settingsNameSaved => '名前を更新しました。';

  @override
  String get storyPrivacyTitle => '思い出は非公開のまま';

  @override
  String get storyConnectTitle => '瞬間をつなぐ';

  @override
  String get storyConnectText => '思い出、メモ、場所をつないで、どの章にも背景を。';

  @override
  String get storyWallTitle => '生きたウォールをつくろう';

  @override
  String get storyWallText => 'まずは写真1枚から。ウォールが少しずつ育って、生き生きしてきます。';

  @override
  String get previewDemoWall => 'サンプルを見る';

  @override
  String get startFresh => 'まっさらから始める';

  @override
  String get optionalDemoPreview => 'サンプル(任意)';

  @override
  String get quickTutorial => 'かんたんガイド';

  @override
  String get tutorialIntro => 'まずは基本(保存、つなぐ、並べる)、そのあとウォールでできることをすべて紹介します。';

  @override
  String get gotIt => 'わかった';

  @override
  String get howItWorks => '使い方';

  @override
  String get tutorialAddTitle => '思い出を追加';

  @override
  String get tutorialAddText =>
      '+をタップして「思い出」か「クイック写真」を選び、タイトル、日付、人、写真を保存。保存前に離れても下書きとして残ります。';

  @override
  String get tutorialConnectTitle => '思い出をつなぐ';

  @override
  String get tutorialConnectText => 'カードを開いてつなぐアイコンをタップし、関係する思い出を選んで短い理由を書きます。';

  @override
  String get tutorialArrangeTitle => 'ウォールを並べる';

  @override
  String get tutorialArrangeText =>
      'カード、メモ、ピンをドラッグして配置。表示 › 並べ替えで日付、カテゴリ、場所順に整列し、「完了」で反映されます。';

  @override
  String get tutorialShowBoardTitle => 'ボードを映す';

  @override
  String get tutorialShowBoardText =>
      '別の画面でlifethreads.gkcoding.dev/displayを開き、その他 › ウォールを表示を選んでコードを読み取ると、一時的な閲覧専用ボードを表示できます。';

  @override
  String get tutorialBackupTitle => 'プライバシーとバックアップ';

  @override
  String get tutorialBackupText =>
      '設定 › プライバシー › アプリロックで、LifeThreadsをFace IDで開けます。機種変更の前に、設定 › バックアップとデータでバックアップを書き出してください。';

  @override
  String get scanDisplayQr => '表示用QRを読み取る';

  @override
  String get scannerHintTitle => 'QRコードはどこ?';

  @override
  String get addMemoryBeforeDisplay => 'ウォールを表示する前に思い出を追加してください。';

  @override
  String get notLifeThreadsDisplayQr => 'これはLifeThreadsの表示用QRではありません。';

  @override
  String get displayWallQuestion => 'このウォールを表示しますか?';

  @override
  String displayWallBody(int memoryCount) {
    return '読み取ったブラウザに、$memoryCount件の思い出を含む一時的な閲覧専用のボードを送ります。lifethreads.gkcoding.dev/displayで開き、時間がたつと自動で消えます。';
  }

  @override
  String get displayAction => '表示';

  @override
  String get soon => 'まもなく';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return '$expiresまで$memoryCount件の思い出でウォールを表示中です。';
  }

  @override
  String get preparingWallDisplay => 'ウォールの表示を準備中...';

  @override
  String get open => '開く';

  @override
  String get edit => '編集';

  @override
  String get save => '保存';

  @override
  String get done => '完了';

  @override
  String get back => '戻る';

  @override
  String get continueAction => '続ける';

  @override
  String get close => '閉じる';

  @override
  String get add => '追加';

  @override
  String get saveReason => '理由を保存';

  @override
  String get chooseBackup => 'バックアップを選ぶ';

  @override
  String get chooseArchive => 'アーカイブを選ぶ';

  @override
  String get chooseCapsule => 'カプセルを選ぶ';

  @override
  String get exportAction => '書き出す';

  @override
  String get addToWall => 'ウォールに追加';

  @override
  String get cinemaSkip => 'スキップ';

  @override
  String get cinemaNotNow => '今はしない';

  @override
  String get cinemaSharedChapter => '共有された思い出の章';

  @override
  String get cinemaConnectedThread => 'つながった糸';

  @override
  String get cinemaInviteTitle => 'この思い出をウォールに追加しますか?';

  @override
  String get useSelected => '選んだものを使う';

  @override
  String photoGridItem(String date) {
    return '$dateの写真';
  }

  @override
  String get noPhotosFound => '写真が見つかりません。';

  @override
  String get manage => '管理';

  @override
  String get manageAccess => 'アクセスを管理';

  @override
  String get saveNow => '今すぐ保存';

  @override
  String get hangOnWall => 'ウォールに飾る';

  @override
  String get placeHere => 'ここに置く';

  @override
  String get openSettings => '設定を開く';

  @override
  String get viewPremium => 'Premiumを見る';

  @override
  String get memoryNotFound => '思い出が見つかりません';

  @override
  String get memoryTypeMoment => '瞬間';

  @override
  String get memoryTypeTrip => '旅';

  @override
  String get memoryTypePerson => '人';

  @override
  String get memoryTypePlace => '場所';

  @override
  String get memoryTypeNote => 'メモ';

  @override
  String get memoryTypeMomentDescription => '残しておきたい小さな場面';

  @override
  String get memoryTypeTripDescription => '旅行やお出かけ';

  @override
  String get memoryTypePersonDescription => '大切な人';

  @override
  String get memoryTypePlaceDescription => '意味のある場所';

  @override
  String get memoryTypeNoteDescription => '考え、言葉、リマインダー';

  @override
  String get categoryPersonal => '個人';

  @override
  String get categoryFamily => '家族';

  @override
  String get categoryTravel => '旅行';

  @override
  String get feelingWarm => 'あたたかい';

  @override
  String get feelingNostalgic => 'なつかしい';

  @override
  String get feelingProud => '誇らしい';

  @override
  String get feelingCalm => 'おだやか';

  @override
  String get feelingImportant => '大切';

  @override
  String get feelingWarmDescription => 'やさしくて、近くて、愛にあふれた。';

  @override
  String get feelingNostalgicDescription => 'あの頃に引き戻される思い出。';

  @override
  String get feelingProudDescription => '何かを証明できた瞬間。';

  @override
  String get feelingCalmDescription => '静かで、安心で、穏やか。';

  @override
  String get feelingImportantDescription => '物語を変えた思い出。';

  @override
  String get addPeopleHint => 'この瞬間に関わる人を追加しましょう。連絡先は端末内に残ります。';

  @override
  String get addPerson => '人を追加';

  @override
  String get editPerson => '人を編集';

  @override
  String get chooseFromContacts => '連絡先から選ぶ';

  @override
  String get personNameLabel => '名前';

  @override
  String get personNameHint => '入力して保存済みの人を検索';

  @override
  String get relationshipLabel => '関係';

  @override
  String get relationshipHint => '友だち、母、パートナー...';

  @override
  String get phoneOptionalLabel => '電話番号(任意)';

  @override
  String get emailOptionalLabel => 'メール(任意)';

  @override
  String get nameRelationshipRequired => '名前と関係は必須です。';

  @override
  String get contactAccessDenied => '連絡先へのアクセスが許可されませんでした。';

  @override
  String get couldNotOpenContacts => '連絡先を開けませんでした。';

  @override
  String get chooseContact => '連絡先を選ぶ';

  @override
  String get searchContacts => '連絡先を検索';

  @override
  String get noContactsFound => '連絡先が見つかりません。';

  @override
  String get unnamedContact => '名前のない連絡先';

  @override
  String get contactRelationship => '連絡先';

  @override
  String get couldNotLoadContacts => '連絡先を読み込めませんでした。';

  @override
  String get saveMomentTitle => '瞬間を保存';

  @override
  String get todayEyebrow => '今日';

  @override
  String get addMemoryStepTitle => 'なくしたくない出来事は?';

  @override
  String get addMemoryStepSubtitle => '1行書いて、写真があれば追加して保存。細かいことはあとで大丈夫。';

  @override
  String get momentLabel => '瞬間';

  @override
  String get momentHint => 'ララとの夕食、初めてのリリース、静かな散歩...';

  @override
  String get storyWorthLabel => '残したい理由は?';

  @override
  String get storyWorthHint => 'ひとことで十分です。';

  @override
  String get feelingEyebrow => '気持ち';

  @override
  String get feelingStepTitle => '思い出したとき、どんな気持ちになりたい?';

  @override
  String get feelingStepSubtitle => 'あとで思い出を見つけやすくなります。';

  @override
  String get contextEyebrow => '背景';

  @override
  String get whenWasItTitle => 'いつのこと?';

  @override
  String get photoGpsStepSubtitle =>
      '地図は選んだ写真に保存されたGPSを使います。GPSのない写真では場所は表示されません。';

  @override
  String get peopleThreadsEyebrow => '人と糸';

  @override
  String get peopleThreadsTitle => '誰と、何とつながっている?';

  @override
  String get peopleThreadsSubtitle => '任意の詳細を加えると、ひとつひとつの瞬間が人生の糸になります。';

  @override
  String get connectExistingMemoryLabel => '既存の思い出とつなぐ';

  @override
  String get noConnectionYet => 'まだつながりなし';

  @override
  String get connectionReasonLabel => 'つながる理由は?';

  @override
  String get connectionReasonHint => '例:同じ旅、同じ人、ビフォー/アフター...';

  @override
  String get writeMomentOrPhotoFirst => '先に瞬間を書くか、写真を追加してください。';

  @override
  String get todaysMoment => '今日の瞬間';

  @override
  String get savedFromTodaysPrompt => '今日の問いかけから保存しました。';

  @override
  String get saveItBeforeItFades => '薄れる前に残そう';

  @override
  String get chooseDate => '日付を選ぶ';

  @override
  String get dateLabel => '日付';

  @override
  String get untitledMemory => '無題の思い出';

  @override
  String get organize => '整理';

  @override
  String get memoryShape => '思い出の形';

  @override
  String get wallCategory => 'ウォールのカテゴリ';

  @override
  String get privatePhotos => '非公開の写真';

  @override
  String get pick => '選ぶ';

  @override
  String get addMore => 'さらに追加';

  @override
  String get takePhoto => '写真を撮る';

  @override
  String get takePhotosNow => '今すぐ撮る';

  @override
  String get takePhotosFabTooltip => '新しい思い出の写真を撮る';

  @override
  String get takeAnotherPhoto => 'もう1枚撮る';

  @override
  String get continueWithPhotos => 'この写真で続ける';

  @override
  String get addPhotosToMemory => '思い出に追加';

  @override
  String get takeAnotherOrContinueBody => 'この思い出のために撮り続けるか、次へ進んでストーリーを書きましょう。';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count枚撮影しました',
      one: '1枚撮影しました',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreadsは選んだ写真をアプリ専用の保存領域にコピーし、日付と位置情報があれば残します。';

  @override
  String get limitedPhotoAccessActive => '写真へのアクセスが制限されています。許可する写真を追加できます。';

  @override
  String get selectPhotos => '写真を選ぶ';

  @override
  String get photoAccessOff => '写真へのアクセスがオフです';

  @override
  String get photoAccessOffBody => '思い出を選ぶには写真へのアクセスをオンにしてください。写真はこの端末に残ります。';

  @override
  String get freeMemoryLimitReached => '無料の上限に達しました';

  @override
  String get freeMemoryLimitBody => '無料のウォールは思い出30件まで。アップグレードしてウォールを育て続けましょう。';

  @override
  String get photoAccessNeeded => 'まず写真へのアクセスが必要です。';

  @override
  String get quickPhotoMemory => 'クイック写真';

  @override
  String get quickPhotoDescription => '残したい1枚。ストーリーはいつでも追加できます。';

  @override
  String get hangQuickPhoto => 'クイック写真を飾る';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return '写真のGPSを検出:$latitude, $longitude';
  }

  @override
  String get photoGpsMissing => '写真にGPSがありません。この思い出は地図に表示されません。';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • 写真$photoCount枚';
  }

  @override
  String metadataDates(int count, int total) {
    return '日付 $count/$total';
  }

  @override
  String metadataLocations(int count, int total) {
    return '位置 $count/$total';
  }

  @override
  String metadataSizes(int count, int total) {
    return 'サイズ $count/$total';
  }

  @override
  String newSelected(int count) {
    return '新しく$count件選択';
  }

  @override
  String selectedCount(int count) {
    return '$count件選択';
  }

  @override
  String get editMemoryTitle => '思い出を編集';

  @override
  String get storyPanel => 'ストーリー';

  @override
  String get memoryTitleLabel => '思い出のタイトル';

  @override
  String get addTitleValidation => 'タイトルを入力してください';

  @override
  String get storyDescriptionLabel => 'ストーリー/説明';

  @override
  String get addStoryValidation => '短いストーリーを書いてください';

  @override
  String get shapeFeelingTitle => '形と気持ち';

  @override
  String get memoryTypeLabel => '思い出の種類';

  @override
  String get feelingLabel => '気持ち';

  @override
  String get categoryLabel => 'カテゴリ';

  @override
  String get timePhotoGpsTitle => '日時と写真のGPS';

  @override
  String get memoryDateLabel => '思い出の日付';

  @override
  String get peopleTitle => '人';

  @override
  String get galleryTitle => 'ギャラリー';

  @override
  String get addPhotos => '写真を追加';

  @override
  String get saveMemory => '思い出を保存';

  @override
  String get memorySaveFailed => 'この思い出を保存できませんでした。もう一度お試しください。';

  @override
  String get passwordOnlySpaces => 'パスワードをスペースだけにはできません。';

  @override
  String get somethingWentWrong => '問題が発生しました。もう一度お試しください。';

  @override
  String get mapUnavailable => '現在、地図を利用できません。';

  @override
  String get coverPhoto => 'カバー写真';

  @override
  String get galleryPhoto => 'ギャラリーの写真';

  @override
  String get setAsCover => 'カバーにする';

  @override
  String get replacePhoto => '写真を差し替え';

  @override
  String get removePhoto => '写真を外す';

  @override
  String get choosePhoto => '写真を選ぶ';

  @override
  String get threadReasonsTitle => '糸の理由';

  @override
  String get createMoreMemoriesBeforeLinking => 'つなぐ前に、思い出をもっと作りましょう。';

  @override
  String get connectionHeaderBody => '理由を添えて思い出をつなぎましょう。糸は、2つの瞬間がなぜ一緒なのかを語ります。';

  @override
  String get connectedMemory => 'つながった思い出';

  @override
  String get whyConnectedTitle => 'つながる理由は?';

  @override
  String get exportPremiumArchiveTitle => 'バックアップを書き出す';

  @override
  String get importArchiveTitle => 'アーカイブを読み込む';

  @override
  String get archiveExportBody =>
      'パスワードを設定するとアーカイブが暗号化されます。空欄なら通常のローカルzipになります。';

  @override
  String get archiveImportBody =>
      '暗号化されたアーカイブならパスワードを入力してください。古いバックアップや保護なしの場合は空欄のままで。';

  @override
  String get archivePasswordOptional => 'アーカイブのパスワード(任意)';

  @override
  String get archivePasswordLabel => 'アーカイブのパスワード';

  @override
  String get archivePasswordWarning => 'パスワードは安全な場所に保管してください。なくすと復元できません。';

  @override
  String get sendArchiveTitle => 'LifeThreadsのアーカイブを送る';

  @override
  String get sendArchiveSubject => 'LifeThreadsの思い出アーカイブ';

  @override
  String get sendEncryptedArchiveText =>
      '暗号化されたLifeThreadsのアーカイブです。別の端末で読み込むときは、設定したパスワードを使ってください。';

  @override
  String get sendArchiveText =>
      'LifeThreadsのアーカイブです。LifeThreadsで読み込むと、別の端末で思い出のウォールを開けます。';

  @override
  String get archiveReadyToSend => 'バックアップの準備ができました。このスマホ以外の安全な場所に保管してください。';

  @override
  String get archiveNotSaved => 'バックアップは保存されていません。準備ができたらもう一度書き出してください。';

  @override
  String get archiveSharingUnavailable => 'この端末では共有を利用できません。';

  @override
  String archiveShareFailed(Object error) {
    return 'アーカイブは保存しましたが、共有できませんでした:$error';
  }

  @override
  String get archiveImportedTitle => 'アーカイブを読み込みました';

  @override
  String get memoriesLabel => '思い出';

  @override
  String get photosLabel => '写真';

  @override
  String get wallNotesNailsLabel => 'メモ/ピン';

  @override
  String get connectionsLabel => 'つながり';

  @override
  String get archiveImportSummary => '今のウォールはそのままです。読み込んだ思い出を安全に追加しました。';

  @override
  String get shareEncryptedCapsuleTitle => '暗号化カプセルを共有';

  @override
  String get openSharedCapsuleTitle => '共有カプセルを開く';

  @override
  String get exportMemoryCapsuleTitle => '思い出カプセルを書き出す';

  @override
  String get importCapsuleDialogTitle => 'カプセルを読み込む';

  @override
  String get secureSharePasswordBody =>
      'このカプセルをアップロードする前にパスワードを作成してください。パスワードは受け取る人に別に送ってください。';

  @override
  String get sharedCapsulePasswordBody => 'この共有された思い出のために受け取ったパスワードを入力してください。';

  @override
  String get capsuleExportBody =>
      '送る前にこの思い出を守りたいなら、パスワードを設定してください。空欄なら通常のカプセルになります。';

  @override
  String get capsuleImportBody => 'カプセルにパスワードがあれば入力してください。なければ空欄のままで。';

  @override
  String get capsulePasswordLabel => 'カプセルのパスワード';

  @override
  String get sharedCapsulePasswordLabel => '共有カプセルのパスワード';

  @override
  String get capsulePasswordOptional => 'カプセルのパスワード(任意)';

  @override
  String get capsulePasswordWarning => 'LifeThreadsはこのパスワードをあとから復元できません。';

  @override
  String get passwordRequiredCloudSharing => 'クラウド共有にはパスワードが必要です。';

  @override
  String get createSecureShare => '安全な共有リンクを作成';

  @override
  String get previewMemory => '思い出をプレビュー';

  @override
  String get sendCapsuleTitle => 'LifeThreadsの思い出を共有';

  @override
  String get sendCapsuleSubject => 'LifeThreadsの思い出カプセル';

  @override
  String get sendEncryptedCapsuleText =>
      'LifeThreadsで保護された思い出を共有したよ。送ったパスワードで読み込んでね。';

  @override
  String get sendCapsuleText =>
      'LifeThreadsの思い出を共有したよ。LifeThreadsでカプセルを読み込むと、あなたのウォールに追加できます。';

  @override
  String get capsuleReadyToSend => 'カプセルを送る準備ができました。';

  @override
  String get capsuleSavedLater => 'カプセルを保存しました。あとで共有できます。';

  @override
  String get capsuleSharingUnavailable => 'カプセルは保存しましたが、共有を利用できません。';

  @override
  String capsuleShareFailed(Object error) {
    return 'カプセルは保存しましたが、共有できませんでした:$error';
  }

  @override
  String get importThisMemory => 'この思い出を読み込みますか?';

  @override
  String get noStoryTextIncluded => 'ストーリーの本文はありません。';

  @override
  String get placeLabel => '場所';

  @override
  String get notesLabel => 'メモ';

  @override
  String get capsulePasswordProtected => 'このカプセルはパスワードで保護されていました。';

  @override
  String get openingSharedMemory => '共有された思い出を開いています...';

  @override
  String get lifeThreadsMemoryTitle => 'LifeThreadsの思い出';

  @override
  String shareMemoryText(Object url) {
    return 'LifeThreadsで思い出を共有したよ。\n\n$url';
  }

  @override
  String get shareLinkReady => '共有リンクの準備ができました。';

  @override
  String get shareLinkCreated => '共有リンクを作成しました。';

  @override
  String get shareLinkUnavailable => '共有リンクを作成しましたが、共有を利用できません。';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label リンクは自動で期限切れになります。今すぐ削除することもできます。';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'クラウド共有に失敗しました:$message';
  }

  @override
  String get sharedMemoryLinkDeleted => '共有リンクを削除しました。';

  @override
  String get creatingSecureMemoryLink => '安全なリンクを作成中...';

  @override
  String get shareMemoryCapsule => '思い出カプセルを共有';

  @override
  String get editStory => 'ストーリーを編集';

  @override
  String get metaType => '種類';

  @override
  String get metaFeeling => '気持ち';

  @override
  String get metaCategory => 'カテゴリ';

  @override
  String get metaDate => '日付';

  @override
  String get storyEyebrow => 'ストーリー';

  @override
  String get whyMemoryMatters => 'この思い出が大切な理由';

  @override
  String get galleryEyebrow => 'ギャラリー';

  @override
  String editSectionTooltip(String section) {
    return '$sectionを編集';
  }

  @override
  String get openInMaps => 'マップで開く';

  @override
  String get memoryChangesSaved => '変更を保存しました。';

  @override
  String get memoryDeletedToast => '思い出を削除しました。';

  @override
  String get noteDeletedToast => 'メモを削除しました。';

  @override
  String get nailDeletedToast => 'ピンを外しました。';

  @override
  String get undo => '元に戻す';

  @override
  String photoPlaceDetected(String place) {
    return '写真の場所:$place';
  }

  @override
  String get settingsGroupYou => 'あなた';

  @override
  String get settingsGroupReminders => 'リマインダー';

  @override
  String get settingsGroupMore => 'その他';

  @override
  String get backupDataTitle => 'バックアップとデータ';

  @override
  String get backupDataSubtitle => 'バックアップ、復元、新しいスマホへ移行';

  @override
  String get aboutHelpTitle => '情報とヘルプ';

  @override
  String get aboutHelpSubtitle => 'フィードバック、プライバシー、音楽、バージョン';

  @override
  String get discardChangesTitle => '変更を破棄しますか?';

  @override
  String get discardChangesBody => 'ここでの変更は失われます。';

  @override
  String get discardChanges => '破棄';

  @override
  String get keepEditing => '編集を続ける';

  @override
  String get settingsGroupPrivacy => 'プライバシー';

  @override
  String get appLockTitle => 'アプリロック';

  @override
  String get appLockSubtitle => 'Face IDかパスコードでLifeThreadsを開く';

  @override
  String get appLockReason => '思い出のロックを解除';

  @override
  String get appLockLockedTitle => 'LifeThreadsはロック中です';

  @override
  String get appLockUnlock => 'ロックを解除';

  @override
  String get appLockUnavailable => '先にこのスマホでFace IDかパスコードを設定してください。';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years年前の思い出が待っています。',
      one: '1年前の思い出が待っています。',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => '検索';

  @override
  String get searchHint => 'タイトル、場所、人、年';

  @override
  String get searchClear => '検索をクリア';

  @override
  String get searchNoResults => '一致する思い出はありません。';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出$count件',
      one: '思い出1件',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => '思い出を検索';

  @override
  String get premiumFeatureWalls => 'ウォールを増やす';

  @override
  String get newWall => '新しいウォール';

  @override
  String get wallNameLabel => 'ウォールの名前';

  @override
  String get newWallHint => '例:旅行2025';

  @override
  String get createWall => '作成';

  @override
  String get renameWall => '名前を変更';

  @override
  String get deleteWall => 'ウォールを削除';

  @override
  String deleteWallQuestion(String name) {
    return '「$name」を削除しますか?';
  }

  @override
  String get deleteWallBody => '思い出はマイウォールに移ります。何も失われません。';

  @override
  String get personalWallSubtitle => 'あなたのウォール(この端末)';

  @override
  String get wallOptions => 'ウォールのオプション';

  @override
  String get moveToWall => 'ウォールに移動…';

  @override
  String movedToWall(String name) {
    return '$nameに移動しました。';
  }

  @override
  String get hideMemory => '非表示';

  @override
  String get unhideMemory => '再表示';

  @override
  String get memoryHiddenToast => '非表示にしました。表示 › 非表示の思い出で見つかります。';

  @override
  String get showHiddenMemories => '非表示の思い出';

  @override
  String get showHiddenReason => '非表示の思い出を表示';

  @override
  String get yearThreadFirstTitle => 'はじめての「一年の糸」';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出 $count/3',
      one: '思い出 1/3',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => '今すぐストーリーを作る';

  @override
  String get moveMemoriesHere => 'ここに思い出を移動';

  @override
  String get moveMemoriesTitle => 'ここに移動する思い出を選ぶ';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出を$count件移動',
      one: '思い出を1件移動',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'すべて表示';

  @override
  String get addAMemory => '思い出を追加';

  @override
  String get mapAddPhotoMemory => '場所つきの写真を追加';

  @override
  String get searchSuggestions => 'あなたの思い出で試す';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years年前の今週',
      one: '1年前の今週',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => '誰がいた?';

  @override
  String get premiumPlanYearly => '年額';

  @override
  String get premiumPlanMonthly => '月額';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/年';
  }

  @override
  String premiumSavePercent(int percent) {
    return '$percent%お得';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'お支払いは$storeアカウントに請求されます。現在の期間が終わる24時間前までに解約しない限り、サブスクリプションは毎年自動更新されます。管理や解約は$storeのアカウント設定から行えます。';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '保存した写真$count枚',
      one: '保存した写真1枚',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => '人';

  @override
  String get partOfMemory => 'この思い出の一部';

  @override
  String get notesEyebrow => 'メモ';

  @override
  String get attachedThoughts => '添えた想い';

  @override
  String get stickyNote => '付箋';

  @override
  String get placeEyebrow => '場所';

  @override
  String get threadsEyebrow => '糸';

  @override
  String get connectedMemories => 'つながった思い出';

  @override
  String get noConnectedMemoriesYet =>
      'まだつながった思い出はありません。この章を別の瞬間とつなぐと、目に見える人生の糸が始まります。';

  @override
  String get backToWall => 'ウォールに戻る';

  @override
  String get addTextToWall => 'ウォールに文字を追加';

  @override
  String get addTextAction => '文字を追加';

  @override
  String get textNoteHint => '小さな思い出、言葉、メモを書く...';

  @override
  String get placeTextNote => 'メモを置く';

  @override
  String get placeRopeAnchor => '糸の留め具を置く';

  @override
  String get nailSubtitle => 'ピンを使うと、思い出の間に手動で糸を張れます。';

  @override
  String get clearDemoWallQuestion => 'サンプルを消去しますか?';

  @override
  String get clearDemoWallBody => 'サンプルの思い出を消して、空のプライベートなウォールから始めます。';

  @override
  String get importBackupQuestion => 'バックアップを読み込みますか?';

  @override
  String get importBackupBody => 'LifeThreadsのアーカイブから思い出を復元し、今のウォールはそのまま残します。';

  @override
  String get deleteMemoryQuestion => '思い出を削除しますか?';

  @override
  String get deleteMemoryBody => '思い出と、ウォール上のすべてのつながりが削除されます。';

  @override
  String get editText => '文字を編集';

  @override
  String get editTextTitle => '文字を編集';

  @override
  String get connectRope => '糸をつなぐ';

  @override
  String get connectRopeSubtitle => 'このピンを思い出につなぎます。';

  @override
  String get deleteNail => 'ピンを削除';

  @override
  String get connectNailTitle => 'ピンを思い出につなぐ';

  @override
  String get connectNailSubtitle => '選んだ思い出がこの留め具から下がります。';

  @override
  String get timelineTitle => 'タイムライン';

  @override
  String get timelineSubtitle => '思い出を時系列で。';

  @override
  String get noMemoriesFilter => 'このフィルタの思い出はありません';

  @override
  String get noMemoriesFilterBody => 'フィルタを変えるか、思い出を追加してタイムラインを作りましょう。';

  @override
  String get memoryMapTitle => '思い出マップ';

  @override
  String get memoryMapSubtitle => '思い出を場所ごとに。';

  @override
  String get noMappedMemories => '地図上の思い出はまだありません';

  @override
  String get displayWallTooltip => 'ウォールを表示';

  @override
  String get tutorialTooltip => 'ガイド';

  @override
  String get settingsTooltip => '設定';

  @override
  String get freeformLayout => '自由配置';

  @override
  String get categoryLayout => 'カテゴリ';

  @override
  String get locationLayout => '場所';

  @override
  String get saveToday => '今日を残す';

  @override
  String get rememberThis => '覚えておく';

  @override
  String get whatHappenedToday => '今日は何があった?';

  @override
  String get tapToOpenDrag => 'タップで開く • ドラッグで移動';

  @override
  String get demoWallPreview => 'サンプルのウォールです。準備ができたら消去して、まっさらから始めましょう。';

  @override
  String get clearDemo => 'サンプルを消去';

  @override
  String get chooseQuickPhoto => 'クイック写真を選ぶ';

  @override
  String get wallView => 'ウォール';

  @override
  String get timelineView => 'タイムライン';

  @override
  String get mapView => 'マップ';

  @override
  String get wallFilterAll => 'すべて';

  @override
  String get wallViewButton => '表示';

  @override
  String get wallShowAs => '表示形式';

  @override
  String get wallArrange => '並べ替え';

  @override
  String get wallShowOnly => '表示';

  @override
  String get layoutByDate => '日付順';

  @override
  String get moreActionsTooltip => 'その他';

  @override
  String get addToWallTitle => 'ウォールに追加';

  @override
  String get expandableMemory => '思い出';

  @override
  String get expandableMemorySubtitle => 'ガイドつきでじっくり';

  @override
  String get expandableQuickPhoto => 'クイック写真';

  @override
  String get expandableQuickPhotoSubtitle => '写真を選んで飾る';

  @override
  String get expandableTextNote => 'テキストメモ';

  @override
  String get expandableTextNoteSubtitle => 'ウォールにひとこと';

  @override
  String get expandableNail => 'ピン/糸の留め具';

  @override
  String get expandableNailSubtitle => '手動の糸ポイント';

  @override
  String get startWithOneThing => '今日のひとつから始めよう';

  @override
  String get emptyWallBody => '薄れる前に瞬間を残しましょう。ひとことか写真1枚で十分です。';

  @override
  String get usePhoto => '写真を使う';

  @override
  String get editMemoryTooltip => '思い出を編集';

  @override
  String get connectMemoryTooltip => '思い出をつなぐ';

  @override
  String get archiveTransferTitle => '別の端末で開く';

  @override
  String get archiveTransferHeroTitle => '思い出を安全に別の端末へ。';

  @override
  String get archiveTransferHeroBody =>
      'バックアップは、思い出、写真、メモ、糸、ウォール上の位置、メタデータをまとめた1つのzip。パスワードでロックもできます。コピーは私たちの手元に残りません。行き先はあなたが決めます。';

  @override
  String get archiveTransferStep1Title => 'アーカイブを書き出す';

  @override
  String get archiveTransferStep1Body =>
      '設定を開いて「アーカイブを書き出す」を選び、保護したい場合はパスワードを設定します。';

  @override
  String get archiveTransferStep2Title => 'zipを移す';

  @override
  String get archiveTransferStep2Body => 'AirDrop、USB、自分のクラウド、メールで送ります。';

  @override
  String get archiveTransferStep3Title => '安全に読み込む';

  @override
  String get archiveTransferStep3Body =>
      'もう1台にLifeThreadsを入れて「アーカイブを読み込む」を選び、必要ならパスワードを入力。既存のデータを消さずに復元できます。';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled => '開発用のPremium解除を有効にしました。';

  @override
  String get lifetimeActive => 'サブスクリプション有効';

  @override
  String get oneTimeLifetimeUnlock => '年額または月額';

  @override
  String get premiumHeroActiveTitle => '思い出のウォールは無制限です。';

  @override
  String get premiumHeroLockedTitle => '思い出をストーリーに。';

  @override
  String get premiumHeroActiveBody =>
      'Premiumサブスクリプションは有効です。音楽つきストーリー、一年の糸、家族ウォール、無制限の思い出が使えます。';

  @override
  String premiumHeroLockedBody(int limit) {
    return '無料版は思い出$limit件と完全なバックアップつき。Premiumなら音楽つきストーリーや動画、一年の糸、家族ウォール、無制限の思い出が加わります。';
  }

  @override
  String get premiumMemories => 'Premiumの思い出';

  @override
  String get freeMemories => '無料の思い出';

  @override
  String get unlimited => '無制限';

  @override
  String get benefitUnlimitedTitle => '思い出が無制限';

  @override
  String get benefitUnlimitedBody => '30件の上限なし。人生とともにウォールを育て続けられます。';

  @override
  String get benefitThemesTitle => 'Premiumのウォールテーマ';

  @override
  String get benefitThemesBody => '豊かな雰囲気、期間限定の季節テーマ、時間帯で切り替わる「自動」が使えます。';

  @override
  String get benefitLayoutsTitle => '高度なレイアウト';

  @override
  String get benefitLayoutsBody => '糸、タイムライン、留め具、思い出のまとまりを並べる方法がさらに増えます。';

  @override
  String get lifetimeUnlock => 'Premiumサブスクリプション';

  @override
  String get premiumActiveOnDevice => 'この端末でPremiumが有効です。';

  @override
  String onePurchaseBody(String store) {
    return '年額または月額で、音楽つきストーリー、一年の糸、家族ウォール、無制限の思い出が使えます。$storeの設定からいつでも解約できます。';
  }

  @override
  String get premiumActiveButton => 'Premium有効';

  @override
  String get processing => '処理中...';

  @override
  String get unlockPremium => 'Premiumに登録';

  @override
  String get restorePurchase => '購入を復元';

  @override
  String get enableDebugMockUnlock => 'テスト用の解除を有効にする';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'お支払いは$storeアカウントに請求されます。現在の期間が終わる24時間前までに解約しない限り、サブスクリプションは毎月自動更新されます。管理や解約は$storeのアカウント設定から行えます。';
  }

  @override
  String get premiumMessageBillingUpdateFailed => 'ストアの更新に失敗しました。もう一度お試しください。';

  @override
  String get premiumMessageStoreUnavailable => 'この端末では購入できません。';

  @override
  String get premiumMessageProductUnavailable =>
      'Premiumはまだストアで提供されていません。あとでもう一度お試しください。';

  @override
  String get premiumMessageLoadFailed => 'ストアからPremiumを読み込めませんでした。もう一度お試しください。';

  @override
  String get premiumMessageOpeningCheckout => 'お支払い画面を開いています…';

  @override
  String get premiumMessageCheckoutFailed => 'お支払い画面を開けませんでした。もう一度お試しください。';

  @override
  String get premiumMessageChecking => 'サブスクリプションを確認中…';

  @override
  String get premiumMessageRestoreFailed => '復元に失敗しました。もう一度お試しください。';

  @override
  String get premiumMessageNoSubscriptionFound =>
      '有効なPremiumサブスクリプションが見つかりませんでした。';

  @override
  String get premiumMessagePending => '購入は保留中です。承認されるとPremiumが使えるようになります。';

  @override
  String get premiumMessagePurchaseFailed => '購入が完了しませんでした。もう一度お試しください。';

  @override
  String get premiumMessageCanceled => '購入をキャンセルしました。';

  @override
  String get premiumMessageRestored => 'Premiumサブスクリプションを復元しました。';

  @override
  String get premiumMessageActive => 'Premiumサブスクリプションは有効です。';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/月';
  }

  @override
  String get loadingPlayStoreProduct => 'サブスクリプションを読み込み中…';

  @override
  String get playStoreUnavailable => '現在ストアを利用できません';

  @override
  String get productNotConfigured => '現在Premiumを利用できません';

  @override
  String get purchasePending => '購入保留中';

  @override
  String get purchased => '購入済み';

  @override
  String get restored => '復元済み';

  @override
  String get premiumTryAgain => '再試行';

  @override
  String get purchaseFailed => '購入に失敗しました';

  @override
  String get preparingCheckout => 'お支払いを準備中...';

  @override
  String get premiumLocalFirstTitle => 'Premiumもローカルファースト';

  @override
  String get premiumLocalFirstBody => '思い出は端末に残り、バックアップは誰でも無料です。';

  @override
  String get noMappedMemoriesBody => 'GPS情報のある写真を追加すると、ここに思い出が表示されます。';

  @override
  String get peopleLabel => '人';

  @override
  String get connect => 'つなぐ';

  @override
  String get themeWarmMemoryRoom => 'ぬくもりの部屋';

  @override
  String get themeWarmMemoryRoomDescription => 'やわらかな暗さ、金色の光、こもった部屋の奥行き。';

  @override
  String get themeMidnightArchive => '真夜中の書庫';

  @override
  String get themeMidnightArchiveDescription => '美術館のように静かな、深い青の書庫。';

  @override
  String get themeSoftPaperWall => 'やさしい紙';

  @override
  String get themeSoftPaperWallDescription =>
      'クリーム色の紙、インクの影、落ち着いたスクラップブックの雰囲気。';

  @override
  String get themeTravelCorkboard => '旅のコルクボード';

  @override
  String get themeTravelCorkboardDescription => '旅や場所のための、地図模様が入ったあたたかなコルクボード。';

  @override
  String get themeAutoTitle => '時間帯で自動';

  @override
  String get themeAutoDescription => '昼は「やさしい紙」、夕方は「ぬくもりの部屋」、夜は「真夜中の書庫」。';

  @override
  String get themeAutoSelected => 'ウォールが時間帯に合わせて変わるようになりました。';

  @override
  String get themeSeasonalTitle => '季節のテーマ';

  @override
  String get themeSeasonalBody => '期間限定のPremiumテーマ。それぞれの季節にだけ使えます。';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateStringまで';
  }

  @override
  String get themeUseButton => 'このテーマを使う';

  @override
  String get themeInUse => '使用中';

  @override
  String get themeUnlockButton => 'Premiumで解除';

  @override
  String get themeAutumnHarvest => '秋の実り';

  @override
  String get themeAutumnHarvestDescription => '琥珀色の光、クラフト紙のカード、舞い落ちる葉の輝き。';

  @override
  String get themeWinterLights => '冬のあかり';

  @override
  String get themeWinterLightsDescription => '冷たい青い夜に、霜をまとったカードとあたたかなイルミネーション。';

  @override
  String get themeSpringBlossom => '春の花';

  @override
  String get themeSpringBlossomDescription => '淡い花のカードに、やわらかなピンクの光。';

  @override
  String get themeSummerEvening => '夏の夕暮れ';

  @override
  String get themeSummerEveningDescription => '夕焼けの色とインスタント写真のカード。';

  @override
  String get themeYearRoundTitle => 'いつでも使える';

  @override
  String get themeComingTitle => '近日公開';

  @override
  String get themeComingBody => '次の季節をのぞいてみましょう。各テーマはその季節の初日に開きます。';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateStringから';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'すべてのテーマを見る(今の季節:$countつ)',
      one: 'すべてのテーマを見る(今の季節:1つ)',
      zero: 'すべてのテーマを見る',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => '海辺';

  @override
  String get themeSeasideDescription => 'ターコイズの海、砂色の紙、あたたかな夏の光。';

  @override
  String get themeSnowyCabin => '雪の山小屋';

  @override
  String get themeSnowyCabinDescription => '暖炉のそばの木、霜のカード、外にはやわらかな雪。';

  @override
  String get themeSpringMeadow => '春の野原';

  @override
  String get themeSpringMeadowDescription => 'みずみずしい草、淡いカード、黄色い日ざし。';

  @override
  String get themeMistyForest => '霧の森';

  @override
  String get themeMistyForestDescription => '静かな松、朝の霧、金色の葉。';

  @override
  String get demoFirstDanceTitle => 'はじめてのダンス';

  @override
  String get demoFirstDanceStory =>
      'バンドが私たちの曲を演奏して、納屋中が静まり返った。あなたの足を2回踏んで、あなたはずっと笑っていて、その3分間は誰もいないみたいだった。';

  @override
  String get demoFirstDancePlace => 'ザルツブルク';

  @override
  String get demoNewbornTitle => 'おかえり、リナ';

  @override
  String get demoNewbornStory => '小さな手が指1本をまるごと握った。家で迎えたはじめての静かな朝。';

  @override
  String get demoNewbornPlace => 'ウィーン';

  @override
  String get demoBeachSunsetTitle => '海辺の夏';

  @override
  String get demoBeachSunsetStory => '日が沈むまで裸足で。帰り道、リナは肩車のまま眠っていた。';

  @override
  String get demoBeachSunsetPlace => 'スプリト(クロアチア)';

  @override
  String get demoGrandmaKitchenTitle => 'おばあちゃんの台所';

  @override
  String get demoGrandmaKitchenStory => 'あのアプリコットケーキのレシピ、やっと書き留めた。粉だらけになりながら。';

  @override
  String get demoGrandmaKitchenPlace => 'グラーツ';

  @override
  String get demoGraduationTitle => '卒業の日';

  @override
  String get demoGraduationStory => '帽子が落ちてくる前に、パパはもう泣いていた。';

  @override
  String get demoGraduationPlace => 'インスブルック';

  @override
  String get demoFirstHomeTitle => 'はじめての家の鍵';

  @override
  String get demoFirstHomeStory => '家具はまだなくて、段ボールと床で食べるピザと、たくさんの計画だけ。';

  @override
  String get demoFirstHomePlace => 'リンツ';

  @override
  String get demoAlpineSummitTitle => '雲の上へ';

  @override
  String get demoAlpineSummitStory => 'このために朝4時起き。一歩一歩に価値があった。';

  @override
  String get demoAlpineSummitPlace => 'グロースグロックナー';

  @override
  String get demoFirstBikeTitle => 'はじめての手放し運転';

  @override
  String get demoFirstBikeStory => '3回こいで、ふらついて、行っちゃった。誇らしげな顔で。';

  @override
  String get demoFirstBikePlace => 'ウィーン・プラーター';

  @override
  String get demoGardenDinnerTitle => 'おじいちゃんの80歳';

  @override
  String get demoGardenDinnerStory => '長いテーブルに4世代。いちばん面白い話をするのは、やっぱりおじいちゃん。';

  @override
  String get demoGardenDinnerPlace => 'ヴァッハウ';

  @override
  String get demoThreadFirstDanceToFirstHome => 'ふたりの物語';

  @override
  String get demoThreadFirstHomeToNewborn => 'そしてリナが来た';

  @override
  String get demoThreadNewbornToBeachSunset => 'はじめての夏';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => '家族';

  @override
  String get demoThreadGraduationToFirstHome => '新しい章';

  @override
  String get demoThreadAlpineSummitToFirstBike => '小さな冒険';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'おじいちゃんが見ていた';

  @override
  String get demoRelationGrandpa => '祖父';

  @override
  String get demoRelationGrandma => '祖母';

  @override
  String get demoRelationDaughter => '娘';

  @override
  String get demoRelationWife => '妻';

  @override
  String get demoRelationBestMan => 'ベストマン';

  @override
  String get demoRelationMother => '母';

  @override
  String savedToPath(Object label, Object path) {
    return '$label $pathに保存しました';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の思い出がまだバックアップされていません。',
      one: '1件の思い出がまだバックアップされていません。',
    );
    return '$_temp0';
  }

  @override
  String get later => 'あとで';

  @override
  String get backUp => 'バックアップ';

  @override
  String get onThisDayTitle => 'あの日の今日';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years年前の今日',
      one: '1年前の今日',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years年前',
      one: '1年前',
    );
    return 'あの日の今日 · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      '以前の年の思い出がめぐってくる日に、LifeThreadsがそっとお知らせします。';

  @override
  String get onThisDayReminderSwitch => '毎日のお知らせ';

  @override
  String onThisDayReminderAt(String time) {
    return '$timeに通知';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'LifeThreadsの通知がオフです。スマホの設定で許可してください。';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years年前の今日:$title',
      one: '1年前の今日:$title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件',
      one: '1件',
    );
    return '$titleほか$_temp0のこの日の思い出';
  }

  @override
  String get onThisDayChannelDescription => '以前の年の、この日の思い出。';

  @override
  String get benefitOnThisDayBody => '以前の年の思い出がめぐってきたら、ひとつの章として開けるお知らせが届きます。';

  @override
  String get premiumFeatureStoryImage => 'ストーリー画像';

  @override
  String get premiumFeatureStoryVideo => 'ストーリー動画';

  @override
  String get premiumFeatureThreadOfTheYear => '一年の糸';

  @override
  String get premiumFeatureFamilyWall => '家族ウォール';

  @override
  String premiumFeatureNotice(String feature) {
    return '$featureはPremiumの機能です。';
  }

  @override
  String get yearThreadTitle => '一年の糸';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出$count件',
      one: '思い出1件',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countか所',
      one: '1か所',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count人',
      one: '1人',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countか月',
      one: '1か月',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'いちばん多かった気持ち:$feeling';
  }

  @override
  String get yearThreadClosingLine => '一年を、一本の糸に。';

  @override
  String get yearThreadMyYear => 'わたしの一年';

  @override
  String get yearThreadWallCardTitle => '思い出でふり返る一年';

  @override
  String yearThreadWallCardBody(String year) {
    return '$year年をショートムービーに。';
  }

  @override
  String get yearThreadDismiss => '今はしない';

  @override
  String get yearThreadSettingsBody => '思い出が3件以上ある年を、順番に語られ糸でつながるショートムービーにします。';

  @override
  String get yearThreadOpen => 'ムービーを作る';

  @override
  String get yearThreadNoYears => '一年の糸には、思い出が3件以上ある年が必要です。瞬間を残し続けて、また来てください。';

  @override
  String get yearThreadYear => '年';

  @override
  String get yearThreadLength => '長さ';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'ムービー · $seconds秒';
  }

  @override
  String get yearThreadLengthStory => 'ストーリー · 20秒';

  @override
  String get yearThreadMusic => '音楽';

  @override
  String get yearThreadNoMusic => '音楽なし';

  @override
  String get yearThreadInFilm => 'ムービーに入る思い出';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String get yearThreadAddMemory => '思い出を追加';

  @override
  String get yearThreadSwap => '入れ替え';

  @override
  String get yearThreadRemove => '外す';

  @override
  String get yearThreadUseSuggestions => 'おすすめを使う';

  @override
  String yearThreadPickTitle(String year) {
    return '$year年の思い出を選ぶ';
  }

  @override
  String get yearThreadNoOthers => 'この年の思い出はすべてムービーに入っています。';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出を$count件以上選んでください',
      one: '思い出を1件以上選んでください',
    );
    return '$_temp0。';
  }

  @override
  String get yearThreadPreview => 'プレビュー';

  @override
  String get yearThreadExportVideo => '動画を書き出す';

  @override
  String get yearThreadExportImage => '画像を書き出す';

  @override
  String get yearThreadShare => '共有';

  @override
  String get yearThreadSave => '写真に保存';

  @override
  String get yearThreadMakingFilm => 'ムービーを作成中…';

  @override
  String get yearThreadMakingImage => '画像を作成中…';

  @override
  String get yearThreadFilmReady => 'ムービーができました';

  @override
  String get yearThreadImageReady => '画像ができました';

  @override
  String get yearThreadSaved => '写真に保存しました。';

  @override
  String get yearThreadExportFailed => 'うまくいきませんでした。もう一度お試しください。';

  @override
  String get yearThreadPlay => '再生';

  @override
  String get yearThreadPause => '一時停止';

  @override
  String get createStory => 'ストーリーを作る';

  @override
  String get storyPickTitle => '思い出を選ぶ';

  @override
  String storyPickBody(int max) {
    return '1つのストーリーに思い出を$max件まで選べます。';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$count/$max件を選択';
  }

  @override
  String storyPickLimit(int max) {
    return 'ストーリーに入る思い出は$max件までです。';
  }

  @override
  String get storyPickContinue => '続ける';

  @override
  String get storyNoMemories => 'まず思い出を保存して、それからストーリーにしましょう。';

  @override
  String get storyEditorTitle => 'あなたのストーリー';

  @override
  String get storyChangeMemories => '思い出を変える';

  @override
  String get storyTemplateSingle => 'ひとつの思い出';

  @override
  String get storyTemplateThread => '糸のウォール';

  @override
  String get storyTemplateCollage => 'コラージュ';

  @override
  String get storyTemplateQuote => 'ことば';

  @override
  String get storySwipeHint => 'スワイプで別の見せ方に';

  @override
  String get storyCaptionLabel => 'キャプション';

  @override
  String get storyCaptionHint => 'ストーリーをひとことで';

  @override
  String get storyVideoSwitch => '動画';

  @override
  String get storyVideoBody => '動きと音楽のついた、ストーリーズやリール向けのショートムービー。';

  @override
  String get storyMusicTitle => '音楽';

  @override
  String get storyMusicNone => '音楽なし';

  @override
  String get storyMusicNoneHint => '投稿するときにInstagramで音楽を追加することもできます。';

  @override
  String get storyMoodWarm => 'あたたかい';

  @override
  String get storyMoodJoyful => '楽しい';

  @override
  String get storyMoodCalm => 'おだやか';

  @override
  String get storyMoodNostalgic => 'なつかしい';

  @override
  String get storyMoodEpic => '壮大';

  @override
  String get storyMoodEmotional => 'エモーショナル';

  @override
  String get storyMusicTrimHint => '金色の枠をドラッグして、曲の使う部分を選びます';

  @override
  String get storySearchHint => '思い出、場所、年で検索';

  @override
  String storySearchEmpty(String query) {
    return '「$query」に一致する思い出はありません。';
  }

  @override
  String get storyMemoriesInStory => 'ストーリーに入る思い出';

  @override
  String get storyMemoriesReorderHint => '長押ししてドラッグすると順番を変えられます';

  @override
  String get storyAddMemory => '追加';

  @override
  String get storyAddMemoryTitle => '思い出を追加';

  @override
  String storyRemoveMemory(String title) {
    return '$titleをストーリーから外す';
  }

  @override
  String get storyAllMemoriesAdded => 'すべての思い出がこのストーリーに入っています。';

  @override
  String get storyShare => '共有';

  @override
  String get storySaveToPhotos => '写真に保存';

  @override
  String get storySaved => '写真に保存しました。';

  @override
  String get storySaveDenied => 'LifeThreadsは写真に追加できません。スマホの設定で許可してください。';

  @override
  String storyExportFailed(String error) {
    return 'ストーリーを作成できませんでした:$error';
  }

  @override
  String get storyRenderingTitle => 'ムービーを作成中';

  @override
  String get storyRenderingBody => 'LifeThreadsを開いたままにしてください。数秒で終わります。';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent%';
  }

  @override
  String get storyPreviewFree => 'プレビューは無料です。ストーリーの共有と保存はPremiumの機能です。';

  @override
  String get benefitStoriesTitle => 'ストーリーを作る';

  @override
  String get benefitStoriesBody =>
      '思い出を、Instagram、WhatsAppなどで使えるストーリー画像や音楽つきショートムービーに。';

  @override
  String get musicCreditsTitle => '音楽クレジット';

  @override
  String get musicCreditsBody => 'ストーリー動画用に収録した曲とそのライセンス。';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody => '一年をショートムービーに。大切な瞬間を順番に、音楽とともに。';

  @override
  String get benefitFamilyTitle => '家族ウォール';

  @override
  String get benefitFamilyBody =>
      '家族のための共有ウォール。エンドツーエンドで暗号化され、みんなが自分の瞬間を追加できます。';

  @override
  String get myWall => 'マイウォール';

  @override
  String get myWallSubtitle => '非公開(この端末)';

  @override
  String get switchWall => 'ウォールを切り替え';

  @override
  String get familyWallsTitle => '家族ウォール';

  @override
  String get familyWallsSettingsBody =>
      '家族や友だちとウォールを共有。みんなで思い出を追加でき、エンドツーエンドで暗号化されます。マイウォールはこの端末で非公開のままです。';

  @override
  String get familyWallsOpen => '家族ウォールを開く';

  @override
  String get familyWallsManage => '家族ウォールを管理';

  @override
  String get familyWallsHeadline => 'ひとつのウォールを、家族みんなで';

  @override
  String get familyWallsIntro =>
      '家族ウォールは、招待した人と共有されます。思い出と写真はアップロード前にスマホで暗号化され、メンバーだけが開けます。マイウォールは共有されず、この端末に残ります。';

  @override
  String get familyUnavailableTitle => 'まだ利用できません';

  @override
  String get familyUnavailable => 'このバージョンのLifeThreadsでは、家族ウォールはまだ利用できません。';

  @override
  String get familySignInNeededTitle => '家族ウォールにはサインインが必要です';

  @override
  String get familySignInNeededBody =>
      '共有ウォールでは、誰が何を追加したか家族にわかるようアカウントが必要です。マイウォールはアカウントなしで使えます。';

  @override
  String get familySignIn => 'サインイン';

  @override
  String get familyLoadFailed => '読み込めませんでした';

  @override
  String get familyRetry => '再試行';

  @override
  String get familyNoWallsYet => '家族ウォールはまだありません。作成するか、招待リンクで参加しましょう。';

  @override
  String get familyStartTitle => '作成または参加';

  @override
  String get familyStartBody =>
      '家族ウォールの作成にはPremiumが必要です。参加は無料。オーナーのPremiumで家族みんなが使えます。';

  @override
  String get familyCreateAction => '家族ウォールを作成';

  @override
  String get familyCreateTitle => '新しい家族ウォール';

  @override
  String get familyNameLabel => 'ウォールの名前';

  @override
  String get familyNameHint => '例:山田家';

  @override
  String get familyMyNameLabel => 'このウォールでのあなたの名前';

  @override
  String get familyMyNameHelper => 'メンバーにはあなたの思い出に表示されます。ウォール上のすべてと同じく暗号化されます。';

  @override
  String get familyMyNameSaved => '名前を保存しました。';

  @override
  String get familySetMyName => '自分の名前';

  @override
  String get familyCheckingSubscription => 'Premiumを確認中…';

  @override
  String get familyCreating => 'ウォールを作成中…';

  @override
  String get familyJoinWithLink => 'リンクで参加';

  @override
  String get familyInviteLinkLabel => '招待リンク';

  @override
  String get familyJoinTitle => 'この家族ウォールに参加しますか?';

  @override
  String get familyJoinBody =>
      'メンバーにはあなたの名前と追加した思い出が見え、あなたにもメンバーの思い出が見えます。いつでも退出できます。';

  @override
  String get familyJoinAction => '参加';

  @override
  String get familyJoining => '参加中…';

  @override
  String familyJoined(String family) {
    return '$familyに参加しました。';
  }

  @override
  String get familyRoleOwner => 'オーナー';

  @override
  String get familyRoleMember => 'メンバー';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'メンバー$count人',
      one: 'メンバー1人',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'ウォールの設定';

  @override
  String familyStorageUsed(String used, String total) {
    return '$total中$usedを使用';
  }

  @override
  String get familyRename => '名前を変更';

  @override
  String get familyInviteTitle => '招待';

  @override
  String get familyInviteBody => '信頼できる人にリンクを送りましょう。各リンクは1回だけ使え、7日後に期限切れになります。';

  @override
  String get familyInviteAction => '招待リンクを作成';

  @override
  String get familyCreatingInvite => '招待を作成中…';

  @override
  String get familyInviteReady => '招待リンクの準備ができました';

  @override
  String get familyInviteValidity => '1回だけ使え、遅くとも7日後に期限切れになります。';

  @override
  String get familyInviteKeyWarning =>
      'このリンクにはウォールの鍵が含まれています。開いた人は誰でも参加してウォールを読めます。招待する本人にだけ送ってください。';

  @override
  String get familyInviteShare => 'リンクを共有';

  @override
  String get familyInviteCopy => 'リンクをコピー';

  @override
  String get familyInviteCopied => 'リンクをコピーしました。';

  @override
  String get familyInviteShareFailed => '共有を利用できません。リンクをコピーしてください。';

  @override
  String familyInviteSubject(String family) {
    return 'LifeThreadsの$familyに参加しよう';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'LifeThreadsの家族ウォール「$family」に参加してね:$link';
  }

  @override
  String get familyMembersTitle => 'メンバー';

  @override
  String get familyMemberActions => 'メンバーの操作';

  @override
  String get familyYou => 'あなた';

  @override
  String familyYouNamed(String name) {
    return '$name(あなた)';
  }

  @override
  String get familyAMember => 'メンバー';

  @override
  String get familyFormerMember => '元メンバー';

  @override
  String get familyBlocked => 'ブロック中';

  @override
  String get familyBlock => 'ブロック';

  @override
  String get familyUnblock => 'ブロック解除';

  @override
  String familyBlockAuthor(String name) {
    return '$nameをブロック';
  }

  @override
  String familyBlockQuestion(String name) {
    return '$nameをブロックしますか?';
  }

  @override
  String get familyBlockBody =>
      'どの家族ウォールでも、この人の思い出が表示されなくなります。相手には通知されません。メンバー一覧からブロックを解除できます。';

  @override
  String get familyReport => '報告';

  @override
  String get familyRemoveMember => 'ウォールから外す';

  @override
  String familyRemoveQuestion(String name) {
    return '$nameを外しますか?';
  }

  @override
  String get familyRemoveBody => 'このウォールにアクセスできなくなります。戻すにはもう一度招待してください。';

  @override
  String get familyRemoveDeleteContent => 'この人が追加した思い出も削除する';

  @override
  String get familyDeleteTitle => '家族ウォールを削除';

  @override
  String get familyDeleteBody => 'オーナーはウォールから退出できませんが、全員分を削除できます。';

  @override
  String get familyDeleteAction => 'ウォールを削除';

  @override
  String familyDeleteQuestion(String family) {
    return '$familyを削除しますか?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'このウォールの思い出と写真は、すべてのメンバー分がサーバーから削除されます。元に戻せません。マイウォールの思い出には影響しません。';

  @override
  String get familyDeleting => '削除中…';

  @override
  String get familyLeaveTitle => '家族ウォールから退出';

  @override
  String get familyLeaveBody => 'このウォールが見えなくなります。追加した思い出は残すことも削除することもできます。';

  @override
  String get familyLeaveAction => '退出';

  @override
  String familyLeaveQuestion(String family) {
    return '$familyから退出しますか?';
  }

  @override
  String get familyLeaveConfirmBody => '戻るには新しい招待が必要です。';

  @override
  String get familyLeaveDeleteMine => '自分が追加した思い出も削除する';

  @override
  String get familyLeaving => '退出中…';

  @override
  String get familySignInTitle => 'サインイン';

  @override
  String get familySignInHeadline => '家族ウォール用のアカウント';

  @override
  String get familySignInWhy =>
      '家族ウォールは共有されるため、アカウントが必要です。メンバーは誰が思い出を追加したかがわかり、メンバーだけがウォールを開けます。';

  @override
  String get familySignInMyWallStays =>
      'マイウォールにアカウントは不要です。この端末で非公開のままで、アップロードされることはありません。';

  @override
  String get familySignInEncrypted =>
      '家族の思い出と写真はエンドツーエンドで暗号化されます。GK Codingは保管しますが、読むことはできません。';

  @override
  String get familySignInWhatWeGet =>
      'AppleやGoogleから受け取るのはアカウントIDだけ。連絡先や写真は使いません。';

  @override
  String get familySignInApple => 'Appleでサインイン';

  @override
  String get familySignInGoogle => 'Googleでサインイン';

  @override
  String get familySignInFinePrint =>
      'サインインすると、利用規約とプライバシーポリシーに同意したことになります。アカウントはアプリからいつでも削除できます。';

  @override
  String get familyAccountTitle => 'アカウント';

  @override
  String get familySignedOutTitle => 'サインインしていません';

  @override
  String get familySignedOutBody => 'サインインすると家族ウォールが見られます。マイウォールはアカウントなしで使えます。';

  @override
  String get familySignedInTitle => 'サインイン済み';

  @override
  String get familySignedInBody => 'アカウントは家族ウォールにだけ使われます。';

  @override
  String familyAccountId(String id) {
    return 'アカウントID:$id';
  }

  @override
  String get familySignOut => 'サインアウト';

  @override
  String get familySignOutQuestion => 'サインアウトしますか?';

  @override
  String get familySignOutBody =>
      '再びサインインするまで、家族ウォールとその鍵はこの端末から消えます。サーバー上では何も削除されません。マイウォールには影響しません。';

  @override
  String get familySigningOut => 'サインアウト中…';

  @override
  String get familyDeleteAccountTitle => 'アカウントを削除';

  @override
  String get familyDeleteAccountBody =>
      'アカウントと家族ウォールのデータをサーバーから削除します。マイウォールはこの端末に残ります。';

  @override
  String get familyDeleteAccount => 'アカウントを削除';

  @override
  String get familyDeleteAccountQuestion => 'アカウントを削除しますか?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あなたがオーナーの$countつの家族ウォールは、すべての思い出と写真とともに、メンバー全員分が削除されます。',
      one: 'あなたがオーナーの家族ウォールは、すべての思い出と写真とともに、メンバー全員分が削除されます。',
      zero: 'あなたがオーナーの家族ウォールはありません。',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'ほかの家族のウォールに追加した思い出と写真は削除され、それらのウォールからも退出します。';

  @override
  String get familyDeleteAccountKeys =>
      '家族ウォールの鍵とキャッシュされた写真はこの端末から削除されます。元に戻せません。';

  @override
  String get familyDeleteAccountMyWall => 'マイウォールには影響しません。思い出はこの端末に残ります。';

  @override
  String get familyDeleteAccountSubscription =>
      'これでPremiumサブスクリプションは解約されません。App StoreまたはGoogle Playで管理してください。';

  @override
  String get familyDeleteAccountUnderstood => 'アカウントが完全に削除されることを理解しました。';

  @override
  String get familyDeletingAccount => 'アカウントを削除中…';

  @override
  String get familyAccountDeleted => 'アカウントを削除しました。';

  @override
  String get familyTermsTitle => '家族ウォールのルール';

  @override
  String get familyTermsHeadline => '共有する前に';

  @override
  String get familyTermsIntro =>
      '家族ウォールは、あなたが招待した人のためのものです。安全に使えるよう、全員が次のルールに同意します:';

  @override
  String get familyTermsZeroTolerance =>
      '不適切なコンテンツは一切禁止です。嫌がらせ、ヘイト、性的なコンテンツ、暴力、自傷行為、違法なコンテンツ、本人の同意のない個人情報の投稿はできません。';

  @override
  String get familyTermsOwnContent => '共有してよい写真とストーリーだけを共有してください。';

  @override
  String get familyTermsReport =>
      'ウォールから思い出やメンバーを報告できます。GK Codingは24時間以内に報告を確認します。';

  @override
  String get familyTermsBlock => 'メンバーをブロックすると、その人の思い出が見えなくなります。';

  @override
  String get familyTermsOwner => 'ウォールのオーナーは、メンバーとその思い出を外せます。';

  @override
  String get familyTermsConsequences =>
      'ルールに反するコンテンツは削除され、投稿したアカウントは停止または削除されることがあります。';

  @override
  String get familyTermsReadFull => '利用規約の全文を読む';

  @override
  String get familyTermsAgree => '利用規約とこのルールに同意します。';

  @override
  String get familyTermsAccept => '同意して続ける';

  @override
  String familyTermsVersion(String version) {
    return '規約バージョン $version';
  }

  @override
  String get familyWallEmptyTitle => 'ウォールが待っています';

  @override
  String get familyWallEmptyBody => '最初の思い出を追加しましょう。このウォールの全員に表示されます。';

  @override
  String get familyWallGoneBody =>
      'この家族ウォールはもう利用できません。削除されたか、メンバーから外された可能性があります。';

  @override
  String get familyAddMemory => '思い出を追加';

  @override
  String get familyRefresh => '更新';

  @override
  String get familySyncing => '同期中…';

  @override
  String get familyOffline => 'オフライン:保存済みの思い出を表示中';

  @override
  String get familySyncFailed => '同期に失敗しました';

  @override
  String get familyMemoryTitle => '思い出';

  @override
  String get familyMemoryGone => 'この思い出はもうウォールにありません。';

  @override
  String get familyMemoryActions => '思い出の操作';

  @override
  String familyAddedBy(String name) {
    return '$nameが追加';
  }

  @override
  String get familyDeleteMemoryQuestion => 'この思い出を削除しますか?';

  @override
  String get familyDeleteMemoryBody => '写真とともに、全員のウォールから削除されます。';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'オーナーはこのウォールから思い出を削除できます。$nameが追加したこの思い出は、写真とともに全員分が削除されます。';
  }

  @override
  String get familyDeletingMemory => '思い出を削除中…';

  @override
  String get familyNoPhotosYet => '写真はまだありません';

  @override
  String get familyPostNote =>
      'この思い出はウォールの全員に表示されます。写真はアップロード前にスマホで縮小・暗号化されます。';

  @override
  String get familyPost => '投稿';

  @override
  String get familyPostMemory => 'ウォールに投稿';

  @override
  String get familyUploading => '暗号化してアップロード中…';

  @override
  String get familyMemorySaved => '家族ウォールに保存しました。';

  @override
  String get familyConflictTitle => 'ほかの人が変更しました';

  @override
  String get familyConflictBody =>
      '編集中に、この思い出が別の端末で変更されました。最新版を読み込んで、あなたの変更で上書き保存しますか?';

  @override
  String get familyConflictRetry => '更新して保存';

  @override
  String get familyQuotaTitle => 'ウォールがいっぱいです';

  @override
  String get familyReportMemoryTitle => '思い出を報告';

  @override
  String get familyReportPhotoTitle => '写真を報告';

  @override
  String get familyReportMemberTitle => 'メンバーを報告';

  @override
  String get familyReportIntro => '何が問題か教えてください。報告はGK Codingに届き、報告した相手には届きません。';

  @override
  String get familyReportSpam => 'スパム・詐欺';

  @override
  String get familyReportHarassment => '嫌がらせ・いじめ';

  @override
  String get familyReportHate => 'ヘイトスピーチ';

  @override
  String get familyReportSexual => '性的なコンテンツ・ヌード';

  @override
  String get familyReportViolence => '暴力・脅迫';

  @override
  String get familyReportSelfHarm => '自傷行為・自殺';

  @override
  String get familyReportIllegal => '違法なコンテンツ';

  @override
  String get familyReportPrivacy => '同意のない個人情報の共有';

  @override
  String get familyReportOther => 'その他';

  @override
  String get familyReportDetailsLabel => '詳細(任意)';

  @override
  String get familyReportDetailsHint => '伝えたいことは?';

  @override
  String familyReportAlsoBlock(String name) {
    return '$nameもブロックする';
  }

  @override
  String get familyReportSend => '報告を送信';

  @override
  String get familyReportReviewNote =>
      'GK Codingはすべての報告を24時間以内に確認し、ルールに反するコンテンツとメンバーを削除します。';

  @override
  String get familyReportSentTitle => 'ありがとうございます';

  @override
  String get familyReportSentBody =>
      '報告を送信しました。GK Codingが24時間以内に確認し、ルールに反するコンテンツに対応します。';

  @override
  String get familyErrorGeneric => '問題が発生しました。もう一度お試しください。';

  @override
  String get familyErrorOffline => 'オフラインのようです。接続を確認して、もう一度お試しください。';

  @override
  String get familyErrorSubscriptionRequired =>
      'ウォールのオーナーの有効なPremiumサブスクリプションが必要です。';

  @override
  String get familyErrorInviteExpired => 'この招待は期限切れです。新しいリンクをもらってください。';

  @override
  String get familyErrorInviteUsed =>
      'この招待はすでに使われています。各リンクは1回だけ使えます。新しいリンクをもらってください。';

  @override
  String get familyErrorInviteInvalid => '有効なLifeThreadsの招待リンクではありません。';

  @override
  String get familyErrorAlreadyMember => 'すでにこの家族ウォールのメンバーです。';

  @override
  String get familyErrorFamilyFull => 'この家族ウォールはメンバーの上限に達しています。';

  @override
  String get familyErrorQuotaExceeded =>
      'この家族ウォールに空き容量がありません。思い出や写真を削除して空きを作ってください。';

  @override
  String get familyErrorVersionConflict => '先に誰かがこの思い出を変更しました。更新してもう一度お試しください。';

  @override
  String get familyErrorTermsRequired => '先に家族ウォールのルールに同意してください。';

  @override
  String get familyErrorSignedOut => 'サインアウトされました。もう一度サインインしてください。';

  @override
  String get familyErrorNotAllowed => 'このウォールでは、この操作はできません。';

  @override
  String get familyErrorNotFound => '家族ウォールが見つかりません';

  @override
  String get familyErrorOwnerCannotLeave => 'オーナーはウォールから退出できませんが、削除はできます。';

  @override
  String get familyPaste => 'ペースト';

  @override
  String get familyErrorInviteRevoked => 'この招待は取り消されました。新しいリンクをもらってください。';

  @override
  String get familyErrorKeyMissing =>
      'この端末にはこの家族ウォールの鍵がありません(再インストール後や新しいスマホなど)。メンバーに新しい招待リンクをもらってください。開くとアクセスが戻ります。';

  @override
  String get familyErrorSignInUnavailable => '現在この端末ではサインインできません。';

  @override
  String get familyErrorNoPurchase =>
      'このApp StoreまたはGoogle PlayアカウントにはPremiumの購入が見つかりません。先にPremiumを購入してから、もう一度お試しください。';

  @override
  String get familyErrorVerificationUnavailable =>
      '現在Premiumを確認できません。あとでもう一度お試しください。';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'このPremiumの購入は、すでに別の家族ウォールのアカウントにひもづいています。そのアカウントでサインインするか、info@gkcoding.devまでご連絡ください。';

  @override
  String get familyErrorNameTooLong => '名前が長すぎます。短くしてください。';

  @override
  String get familyErrorContentNotAllowed =>
      '家族ウォールで使えない言葉が含まれています。文章を変えてもう一度お試しください。';

  @override
  String get familyErrorPhotoUnreadable => '写真の1枚を読み込めませんでした。外してもう一度お試しください。';

  @override
  String get familyErrorTooLarge =>
      'アップロードするには大きすぎます。写真の枚数を減らすか、小さい写真でお試しください。';

  @override
  String get familyReportEvidenceNote =>
      '確認のため、GK Codingには報告とともにこの思い出のタイトルとストーリーが届きます。写真が送られることはありません。';

  @override
  String get moveLeft => '左へ移動';

  @override
  String get moveUp => '上へ移動';

  @override
  String get moveDown => '下へ移動';

  @override
  String get moveRight => '右へ移動';

  @override
  String get showPassword => 'パスワードを表示';

  @override
  String get hidePassword => 'パスワードを隠す';

  @override
  String get removePerson => '人を外す';

  @override
  String get draftKept => '下書きとして残しました。次回ここから続けられます。';

  @override
  String get draftResumeTitle => '続きから始めますか?';

  @override
  String draftResumeBody(String date) {
    return '$dateに書き始めた思い出がまだ保存されていません。';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '写真$count枚',
      one: '写真1枚',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => '下書きを続ける';

  @override
  String get draftStartNew => '新しく始める';

  @override
  String get lookBackMenu => 'ひと月をふり返る';

  @override
  String lookBackTitle(String month) {
    return 'あなたの$month';
  }

  @override
  String get lookBackWallCardTitle => '思い出でふり返るひと月';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出$count件',
      one: '思い出1件',
    );
    return '$month:$_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出$count件',
      one: '思い出1件',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count人',
      one: '1人',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countか所',
      one: '1か所',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => 'いっしょにいた人';

  @override
  String get lookBackPlacesHeading => '行った場所';

  @override
  String lookBackEmpty(String month) {
    return '$monthの思い出はまだありません。';
  }

  @override
  String get lookBackEmptyHint => 'この月の日付の思い出がここに表示されます。';

  @override
  String get lookBackPreviousMonth => '前の月';

  @override
  String get lookBackNextMonth => '次の月';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件',
      one: '1件',
    );
    return '$month:ふり返る思い出が$_temp0あります。';
  }

  @override
  String get lookBackNotificationPrivate => '思い出でふり返るひと月の準備ができました。';

  @override
  String get homeWidgetLocked => 'LifeThreadsを開いて思い出を見る。';

  @override
  String get homeWidgetSettingsTitle => 'ホーム画面ウィジェット';

  @override
  String get homeWidgetSettingsSubtitle => '表示する思い出';

  @override
  String get homeWidgetPreviewTitle => '今日のウィジェット';

  @override
  String get homeWidgetSourceTitle => 'どの思い出';

  @override
  String get homeWidgetAllWalls => 'すべてのウォール';

  @override
  String get homeWidgetOrderTitle => '優先して表示';

  @override
  String get homeWidgetOnThisDayFirst => 'あの日の今日を優先';

  @override
  String get homeWidgetOnThisDayFirstBody => '以前の年の、この日の思い出を先に表示します。';

  @override
  String get homeWidgetPhotosFirst => '写真つきの思い出を優先';

  @override
  String get homeWidgetPhotosFirstBody => '写真つきがない場合だけ、ほかの思い出を表示します。';

  @override
  String get homeWidgetHowToTitle => 'ホーム画面に追加する';

  @override
  String get homeWidgetHowToIos =>
      'ホーム画面のLifeThreadsアイコンを長押しして、ウィジェットのサイズを選びます。または空いている場所を長押しし、編集 › ウィジェットを追加をタップしてLifeThreadsを選びます。';

  @override
  String get homeWidgetHowToAndroid =>
      'ホーム画面の空いている場所を長押しし、ウィジェットをタップしてLifeThreadsを好きな場所にドラッグします。';

  @override
  String get homeWidgetPrivacyNote =>
      '非表示の思い出がウィジェットに出ることはありません。アプリロックがオンのときは思い出を表示しません。';

  @override
  String get yearThreadAlmostThere => 'あと少し';

  @override
  String get yearThreadMemoriesFrom => 'この年の思い出';

  @override
  String yearThreadAddMemoryTo(String year) {
    return '$year年に思い出を追加';
  }

  @override
  String get onboardingHangTitle => '思い出を飾ろう';

  @override
  String get onboardingHangText => '写真、場所、そこにいた人。ウォールは人生とともに育ちます。';

  @override
  String get onboardingConnectTitle => '糸でつなごう';

  @override
  String get onboardingConnectText =>
      '2つの瞬間がなぜ一緒なのかを書きましょう。糸が、あなたの物語のつながりを見せてくれます。';

  @override
  String get onboardingComeBackTitle => '思い出がめぐってくる';

  @override
  String get onboardingComeBackText =>
      'あの日の今日、ひと月のふり返り、一年のムービー、そしてホーム画面のウィジェット。';

  @override
  String get onboardingPrivateText => 'アカウント不要。すべてスマホの中に。お好みでFace IDも。';

  @override
  String get onboardingNameStaysHere => 'あいさつのためだけに使い、このスマホに残ります。';

  @override
  String get tutorialLookBackTitle => '探して、ふり返る';

  @override
  String get tutorialLookBackText =>
      'タイトル、場所、人、年で検索できます。その他 › ひと月をふり返るで月ごとの思い出を、その他 › 一年の糸で一年をムービーにできます。';

  @override
  String get tutorialStoryTitle => 'ストーリーを作る';

  @override
  String get tutorialStoryText =>
      'その他 › ストーリーを作る:思い出、テンプレート、音楽を選んで、画像や動画で共有します。';

  @override
  String get tutorialWallsTitle => 'ウォールと非表示の思い出';

  @override
  String get tutorialWallsText =>
      'その他 › 新しいウォールで旅や時期を分けられます(Premium)。カードを長押し › 非表示で見えなくし、表示 › 非表示の思い出でFace IDのあと表示します。';

  @override
  String get tutorialFamilyTitle => '家族と共有';

  @override
  String get tutorialFamilyText =>
      'その他 › 家族ウォール:家族みんなのウォールを1つ、エンドツーエンドで暗号化。リンクでほかの人を招待できます。';

  @override
  String get tutorialWidgetTitle => 'ホーム画面に思い出を';

  @override
  String get tutorialWidgetText =>
      'LifeThreadsのウィジェットを追加すると、毎日ちがう思い出が表示されます。設定 › ホーム画面ウィジェットで内容を選べます。';

  @override
  String photoNumber(int number) {
    return '写真$number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'このウォールでの名前を保存できませんでした。ウォールの設定から設定できます。';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '思い出が$count件入っています。',
      one: '思い出が1件入っています。',
    );
    return '$_temp0すでにウォールにある思い出はそのまま残り、重複して追加されません。';
  }

  @override
  String get importAction => '読み込む';

  @override
  String get familyRemovingMember => 'メンバーを外してウォールを保護中…';

  @override
  String get tourSkip => 'スキップ';

  @override
  String get tourNext => '次へ';

  @override
  String get tourDone => '完了';

  @override
  String get tourTapIt => 'タップ';

  @override
  String get tourEnd => 'ツアーを終了';

  @override
  String get tourShowMeHow => '使い方を見る';

  @override
  String get tourShowMeHowSubtitle => 'サンプルの思い出でかんたんツアー';

  @override
  String get tourWelcomeTitle => 'ウォールへようこそ';

  @override
  String get tourWelcomeBody =>
      'サンプルの思い出と写真を使って、LifeThreadsをいっしょに見ていきましょう。金色の輪についてきてください。最後に残すかどうかを決められます。';

  @override
  String get tourCardTitle => 'カード1枚が思い出1つ';

  @override
  String get tourCardBody =>
      '写真、ストーリー、場所、そのときの気持ち。カードはドラッグで並べ替え、ピンチで拡大できます。このカードをタップして開きましょう。';

  @override
  String get tourConnectTitle => '思い出をつなぐ';

  @override
  String get tourConnectBody => '糸は瞬間どうしを結びます。旅と人、場所と気持ち。「つなぐ」をタップ。';

  @override
  String get tourConnectionsTitle => '一緒のものを選ぶ';

  @override
  String get tourConnectionsBody =>
      'ほかの思い出を選んで、一緒な理由を書きましょう。するとウォール上のカードの間に糸が張られます。';

  @override
  String get tourAddTitle => '新しい瞬間を残す';

  @override
  String get tourAddBody => '+をタップしてウォールに追加します。';

  @override
  String get tourAddMemoryTitle => '思い出';

  @override
  String get tourAddMemoryBody => '「思い出」を選びます。メモやピンを留めてカードをまとめることもできます。';

  @override
  String get tourAddTextTitle => 'ひとことで十分';

  @override
  String get tourAddTextBody =>
      'サンプルの写真とタイトルを入れておきました。ふだんは自分の写真を選ぶか撮影します。日付と場所は写真から入ります。';

  @override
  String get tourSaveTitle => 'ウォールに飾る';

  @override
  String get tourSaveBody => '「今すぐ保存」をタップ。気持ち、人、糸はあとからでも大丈夫。';

  @override
  String get tourCameraTitle => 'クイック写真';

  @override
  String get tourCameraBody => 'カメラで瞬間をすぐ残せます。ことばはあとで追加。';

  @override
  String get tourViewTitle => 'いろいろな表示';

  @override
  String get tourViewBody => '「表示」をタップ。';

  @override
  String get tourViewModesTitle => 'ウォール、タイムライン、マップ';

  @override
  String get tourViewModesBody =>
      '人生をウォール、タイムライン、地図で見られます。ここでカテゴリで絞り込んだり、非表示の思い出を表示したり(Face ID)できます。';

  @override
  String get tourViewDoneTitle => 'ウォールに戻る';

  @override
  String get tourViewDoneBody => '「完了」をタップ。';

  @override
  String get tourSearchTitle => 'どんな思い出も見つかる';

  @override
  String get tourSearchBody => 'ここに名前、場所、人、年を入力。入力しながら結果が表示されます。';

  @override
  String get tourMoreTitle => 'そのほかの機能';

  @override
  String get tourMoreBody => 'ストーリー、一年、ふり返り、ほかのウォール、設定はこのメニューに。タップしてみましょう。';

  @override
  String get tourStoryTitle => 'ストーリーを作る';

  @override
  String get tourStoryBody => '「ストーリーを作る」をタップ。';

  @override
  String get tourYearTitle => '一年の糸';

  @override
  String get tourYearBody =>
      '一年を音楽つきのショートムービーに。思い出を順番に、そのあとその年の場所、人、気持ちを(Premium)。';

  @override
  String get tourLookBackTitle => 'ひと月をふり返る';

  @override
  String get tourLookBackBody =>
      '毎月を思い出で。その月の人と場所も。「あの日の今日」が以前の年を思い出させてくれます(Premium)。';

  @override
  String get tourWallsTitle => 'ウォールを増やす';

  @override
  String get tourWallsBody =>
      '子ども、旅、プロジェクトごとにウォールを(Premium)。上の名前をタップしてウォールを切り替えます。';

  @override
  String get tourFamilyTitle => '家族ウォール';

  @override
  String get tourFamilyBody =>
      'みんなが自分の瞬間を追加する共有ウォール。エンドツーエンドで暗号化。Premiumが必要なのは作成する人だけで、家族は無料で参加できます。';

  @override
  String get tourSettingsTitle => '設定';

  @override
  String get tourSettingsBody =>
      'すべてを無料でバックアップ、Face IDでアプリをロック、ホーム画面ウィジェットと「あの日の今日」を設定、言語も選べます。';

  @override
  String get tourFinishTitle => '以上です!';

  @override
  String get tourFinishBody => '使い方はもうバッチリ。あなただけのウォールにしましょう。';

  @override
  String get tourDemoPhotoTitle => '湖で過ごした一日';

  @override
  String get tourRemoveDemoTitle => '自分のウォールを始めますか?';

  @override
  String get tourRemoveDemoBody => 'ツアーではサンプルの思い出と写真を使いました。今すぐ消して、自分の写真で始めますか?';

  @override
  String get tourRemoveDemoRemove => '消して始める';

  @override
  String get tourRemoveDemoKeep => '今は残しておく';

  @override
  String get tourRemovedToast => 'サンプルの思い出を消しました。ウォールの準備ができました。';

  @override
  String get storyTemplatePolaroid => 'ポラロイド';

  @override
  String get storyTemplateAlbum => 'アルバム';

  @override
  String get storyTemplateFilmstrip => 'フィルム';

  @override
  String get storyTemplateTimeline => 'タイムトラベル';

  @override
  String get storyTemplatePostcard => 'ポストカード';

  @override
  String get storyTemplateCinema => 'シネマ';

  @override
  String get storyTemplateSingleHint => '思い出を1つずつ全画面で';

  @override
  String get storyTemplateThreadHint => 'ウォールのカードを糸でつないで';

  @override
  String get storyTemplateCollageHint => 'すべての写真をグリッドに';

  @override
  String get storyTemplateQuoteHint => 'ことばがひとりでに打ち出される';

  @override
  String get storyTemplatePolaroidHint => 'インスタント写真が重なって落ちる';

  @override
  String get storyTemplateAlbumHint => 'ページをめくって1ページに1枚';

  @override
  String get storyTemplateFilmstripHint => 'フィルムが流れてズームイン';

  @override
  String get storyTemplateTimelineHint => '年をさかのぼって各思い出へ';

  @override
  String get storyTemplatePostcardHint => 'ポストカードが裏返ってストーリーに';

  @override
  String get storyTemplateCinemaHint => 'タイトルカード、ゆっくりズーム、エンドロール';

  @override
  String get storyAnimationTitle => 'アニメーション';

  @override
  String get storyAnimationPageTitle => 'アニメーションを選ぶ';

  @override
  String get storyAnimationExamples =>
      'サンプル写真で表示しています。実際のストーリーにはあなたの思い出が使われます。';

  @override
  String get storyMusicPageTitle => '音楽と長さ';

  @override
  String get storyLengthTitle => '長さ';

  @override
  String get storyLengthAuto => '自動';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds秒';
  }

  @override
  String get storyMusicAll => 'すべて';

  @override
  String get storyMusicPlay => '再生';

  @override
  String get storyMusicPause => '一時停止';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return '曲 $song ▸ 動画 $video';
  }

  @override
  String get storyMusicSyncHint => '白い線は、動画と一緒に流れる曲の位置を示します。目印は各思い出が始まる位置です。';

  @override
  String get storyMusicLengthHint => '「自動」は思い出の数に合わせます。長いムービーほどゆっくり動きます。';

  @override
  String get tourBack => '戻る';

  @override
  String get tourStoryPickTitle => '思い出を選ぶ';

  @override
  String get tourStoryPickBody => '3つ選んでおきました。6つまで選べます。「続ける」をタップ。';

  @override
  String get tourStoryAnimationTitle => '動き方を選ぶ';

  @override
  String get tourStoryAnimationBody => 'ポラロイドからシネマまで。「アニメーション」をタップ。';

  @override
  String get tourStoryStyleTitle => 'ポラロイドを試す';

  @override
  String get tourStoryStyleBody => '各タイルでプレビューが流れます。「ポラロイド」をタップ。';

  @override
  String get tourStoryMusicTitle => '音楽を追加';

  @override
  String get tourStoryMusicBody => '曲と動画の長さを選びます。「音楽」をタップ。';

  @override
  String get tourStoryTrimTitle => '曲と動画をシンクロ';

  @override
  String get tourStoryTrimBody =>
      '金色の枠をドラッグして曲の使う部分を選びます。白い線は動画と一緒に動くので、どの瞬間に曲のどこが流れるかがわかります。';

  @override
  String get tourStoryMusicDoneTitle => 'ストーリーに戻る';

  @override
  String get tourStoryMusicDoneBody => '「完了」をタップ。';

  @override
  String get tourStoryShareTitle => '共有・保存';

  @override
  String get tourStoryShareBody =>
      'Instagram、WhatsAppなどにすぐ使えます。保存と共有はPremiumの機能です。';

  @override
  String get tourMoreAgainTitle => 'メニューにはまだまだ';

  @override
  String get tourMoreAgainBody => 'もう一度メニューを開きましょう。タップ。';

  @override
  String get scannerStep1 => 'テレビ、パソコン、タブレットでブラウザを開きます。';

  @override
  String scannerStep2(Object url) {
    return '$urlにアクセスすると、QRコードが表示されます。';
  }

  @override
  String get scannerStep3 =>
      'コードが金色の枠に入るようにスマホをかざします。しばらくの間、そこにウォールが閲覧専用で表示されます。';

  @override
  String get scannerShareLink => 'リンクを送る';

  @override
  String get scannerCopyLink => 'リンクをコピー';

  @override
  String get scannerLinkCopied => 'リンクをコピーしました';

  @override
  String get storyTemplateScrapbook => 'スクラップブック';

  @override
  String get storyTemplateMosaic => 'モザイク';

  @override
  String get storyTemplateContactSheet => 'コンタクトシート';

  @override
  String get storyTemplateWallFlight => 'ウォール飛行';

  @override
  String get storyTemplateCarousel => 'カルーセル';

  @override
  String get storyTemplateJourney => '旅路';

  @override
  String get storyTemplateScrapbookHint => '写真をページにテープで貼って';

  @override
  String get storyTemplateMosaicHint => '大きな1枚のまわりにほかの写真';

  @override
  String get storyTemplateContactSheetHint => '思い出ひとつがフィルムの1コマに';

  @override
  String get storyTemplateWallFlightHint => '糸にそってカードからカードへ飛ぶ';

  @override
  String get storyTemplateCarouselHint => 'カードが回って1枚ずつ前へ';

  @override
  String get storyTemplateJourneyHint => '地図上のルート、場所ごとにピン';

  @override
  String get storyModePicture => '画像';

  @override
  String get storyModeVideo => '動画';

  @override
  String get storyModePictureHint => 'すべての思い出を1枚の画像に。投稿やストーリーズに。';

  @override
  String get storyModeVideoHint => '動きと音楽のついたショートムービー。';

  @override
  String get storyLayoutTitle => 'レイアウト';

  @override
  String get storyLayoutPageTitle => 'レイアウトを選ぶ';

  @override
  String get storyChoosePhoto => 'ストーリーに使う写真を選ぶ';

  @override
  String get wallTidyUp => 'ウォールを整理';

  @override
  String get wallTidyUpBody => 'すべてのカードを古い思い出から新しい順に、列にきれいに並べますか？メモと釘はそのままです。';

  @override
  String get wallTidyUpAction => '整理する';

  @override
  String get wallTidiedToast => 'ウォールを整理しました。';

  @override
  String get storyFormatTitle => 'サイズ';

  @override
  String get storyFormatStory => 'ストーリー 9:16';

  @override
  String get storyFormatPost => '投稿 4:5';

  @override
  String get storyFormatSquare => '正方形 1:1';
}
