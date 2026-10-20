// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get send => '发送';

  @override
  String get preparing => '准备中...';

  @override
  String get settingsTitle => '设置';

  @override
  String get languageTitle => '语言';

  @override
  String get languageBody =>
      '选择 App 语言。选“系统”时，如果 LifeThreads 支持你手机的语言，就会跟随手机语言。';

  @override
  String get systemLanguage => '系统';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return '语言已切换为$language。';
  }

  @override
  String get privacyTitle => '隐私';

  @override
  String get privacyBody =>
      'LifeThreads 本地优先：无需账户，没有公开主页。除非你导出备份、分享加密胶囊或在其他屏幕上展示回忆墙，你的回忆只留在这台设备上。';

  @override
  String get viewPrivacyPolicy => '查看隐私政策';

  @override
  String get termsTitle => '使用条款';

  @override
  String get viewTerms => '查看条款';

  @override
  String get betaFeedbackTitle => '测试版反馈';

  @override
  String get betaFeedbackBody =>
      '附带安全诊断信息发送测试版反馈。日志只包含 App 事件和崩溃类型，绝不包含回忆内容、照片路径、备份或精确位置。';

  @override
  String get closedBetaBadge => '封闭测试';

  @override
  String get sendFeedback => '发送反馈';

  @override
  String get backupArchiveBody =>
      '把一切——回忆、照片、便签、连线和布局——保存到一个文件里。存放在电脑或你自己的云盘中，还可以加密码加密。';

  @override
  String get backupArchiveTitle => '备份';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => '解锁';

  @override
  String get exportArchive => '导出归档';

  @override
  String get importArchive => '导入归档';

  @override
  String get importCapsule => '导入胶囊';

  @override
  String get moveDevices => '换设备';

  @override
  String get themeTitle => '主题';

  @override
  String get themeBody => '选择你私人回忆墙的氛围。免费版包含“温暖回忆屋”。Premium 解锁全部氛围。';

  @override
  String get oneFreeBadge => '1 个免费';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'Premium 订阅已生效。';

  @override
  String get premiumLockedBody => '按年或按月：无限回忆、多面墙、故事、主题和布局。';

  @override
  String get activeBadge => '已生效';

  @override
  String get openPremium => '打开 Premium';

  @override
  String get appVersionTitle => 'App 版本';

  @override
  String get clearAllDataTitle => '清除所有数据';

  @override
  String get clearAllDataBody => '从这台设备删除所有回忆、连接、便签、钉子和复制的照片。';

  @override
  String get clearData => '清除数据';

  @override
  String exportFailed(Object error) {
    return '导出失败：$error';
  }

  @override
  String importRejected(Object message) {
    return '导入被拒绝：$message';
  }

  @override
  String importFailed(Object error) {
    return '导入失败：$error';
  }

  @override
  String deleteFailed(Object message) {
    return '删除失败：$message';
  }

  @override
  String capsuleRejected(Object message) {
    return '胶囊被拒绝：$message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return '胶囊导入失败：$error';
  }

  @override
  String get clearAllDataQuestion => '清除所有数据？';

  @override
  String get clearAllDataQuestionBody =>
      '这会永久删除这台设备上所有 LifeThreads 本地数据。如果想保留，请先导出备份。';

  @override
  String get clearAll => '全部清除';

  @override
  String get allLocalDataCleared => '本地数据已全部清除。';

  @override
  String get feedbackGeneral => '一般反馈';

  @override
  String get feedbackBug => '问题';

  @override
  String get feedbackCrash => '崩溃';

  @override
  String get feedbackDesign => '设计问题';

  @override
  String get feedbackMissingFeature => '缺少功能';

  @override
  String get feedbackPerformance => '性能';

  @override
  String get betaFeedbackIntro => '写下发生了什么，或哪里感觉不对。会附上不含私人回忆内容的安全诊断信息。';

  @override
  String get feedbackType => '类型';

  @override
  String get feedbackLabel => '反馈';

  @override
  String get feedbackHint => '例如：我点了 添加 > 快拍照片，屏幕卡住了。';

  @override
  String get betaFeedbackNotIncluded => '不包含：回忆标题、故事、便签、照片路径、备份路径、精确位置。';

  @override
  String get feedbackEmpty => '请先写一条简短的反馈。';

  @override
  String get feedbackCopied => '没有打开邮件 App。反馈已复制到剪贴板，可发送至 info@gkcoding.dev。';

  @override
  String themeSelected(Object theme) {
    return '已选择$theme。';
  }

  @override
  String get onboardingHeadline => '打造你的鲜活回忆墙。';

  @override
  String get onboardingBody => '一间私密的回忆小屋，照片、地点、人和小便签都由情感之线串在一起。';

  @override
  String get onboardingPrivacy => '你的回忆默认私密：无需账户，没有公开主页。只有你选择时，才会进行加密云分享和备份。';

  @override
  String get onboardingPrivacyShort => '无需账户，没有公开主页。除非你另作选择，回忆只留在这台设备上。';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingNameTitle => '我们怎么称呼你？';

  @override
  String get onboardingNameHint => '你的名字';

  @override
  String onboardingNiceToMeetYou(String name) {
    return '很高兴认识你，$name。';
  }

  @override
  String get onboardingGetStartedTitle => '选择开始方式';

  @override
  String get onboardingGetStartedBody => '先看看示例墙，或从一面空墙开始，挂上你自己的回忆。';

  @override
  String get settingsNameTitle => '你的名字';

  @override
  String get settingsNameBody => '会在回忆墙上作为问候显示。';

  @override
  String get settingsNameHint => '你的名字';

  @override
  String get settingsNameSaved => '名字已更新。';

  @override
  String get storyPrivacyTitle => '你的回忆保持私密';

  @override
  String get storyConnectTitle => '串起时光';

  @override
  String get storyConnectText => '把回忆、便签和地点连起来，让每一章都有来龙去脉。';

  @override
  String get storyWallTitle => '打造你的鲜活回忆墙';

  @override
  String get storyWallText => '从一张照片开始，让回忆墙慢慢长大，变得鲜活。';

  @override
  String get previewDemoWall => '看看示例墙';

  @override
  String get startFresh => '从头开始';

  @override
  String get optionalDemoPreview => '可选示例预览';

  @override
  String get quickTutorial => '快速教程';

  @override
  String get tutorialIntro => '先学基础——保存、连接、整理——再看看回忆墙还能做什么。';

  @override
  String get gotIt => '知道了';

  @override
  String get howItWorks => '使用方法';

  @override
  String get tutorialAddTitle => '添加回忆';

  @override
  String get tutorialAddText =>
      '点 +，选择“回忆”或“快拍照片”，然后保存标题、日期、人物和照片。保存前离开的话，会自动存为草稿。';

  @override
  String get tutorialConnectTitle => '连接回忆';

  @override
  String get tutorialConnectText => '打开一张卡片，点连接图标，选择相关的回忆，再写一句简短的理由。';

  @override
  String get tutorialArrangeTitle => '整理回忆墙';

  @override
  String get tutorialArrangeText =>
      '拖动卡片、便签和钉子到合适的位置。视图 › 整理 可按日期、分类或地点排列——点“完成”后生效。';

  @override
  String get tutorialShowBoardTitle => '投屏展示';

  @override
  String get tutorialShowBoardText =>
      '在另一块屏幕上打开 lifethreads.gkcoding.dev/display，选择 更多 › 展示回忆墙，扫描二维码即可显示一个临时的只读看板。';

  @override
  String get tutorialBackupTitle => '隐私与备份';

  @override
  String get tutorialBackupText =>
      '设置 › 隐私 › App 锁 可用面容 ID 打开 LifeThreads。换手机前，请在 设置 › 备份与数据 中导出备份。';

  @override
  String get scanDisplayQr => '扫描投屏二维码';

  @override
  String get scannerHintTitle => '二维码在哪里？';

  @override
  String get addMemoryBeforeDisplay => '展示回忆墙前，请先添加一条回忆。';

  @override
  String get notLifeThreadsDisplayQr => '这不是 LifeThreads 的投屏二维码。';

  @override
  String get displayWallQuestion => '展示这面墙？';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads 会把包含 $memoryCount 条回忆的临时只读快照发送到你扫描的浏览器。它在 lifethreads.gkcoding.dev/display 打开，并会自动过期。';
  }

  @override
  String get displayAction => '展示';

  @override
  String get soon => '即将';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return '回忆墙正在展示 $memoryCount 条回忆，直到 $expires。';
  }

  @override
  String get preparingWallDisplay => '正在准备展示...';

  @override
  String get open => '打开';

  @override
  String get edit => '编辑';

  @override
  String get save => '保存';

  @override
  String get done => '完成';

  @override
  String get back => '返回';

  @override
  String get continueAction => '继续';

  @override
  String get close => '关闭';

  @override
  String get add => '添加';

  @override
  String get saveReason => '保存理由';

  @override
  String get chooseBackup => '选择备份';

  @override
  String get chooseArchive => '选择归档';

  @override
  String get chooseCapsule => '选择胶囊';

  @override
  String get exportAction => '导出';

  @override
  String get addToWall => '添加到墙上';

  @override
  String get cinemaSkip => '跳过';

  @override
  String get cinemaNotNow => '以后再说';

  @override
  String get cinemaSharedChapter => '一段共享的回忆';

  @override
  String get cinemaConnectedThread => '相连的线';

  @override
  String get cinemaInviteTitle => '把这条回忆添加到你的墙上？';

  @override
  String get useSelected => '使用所选';

  @override
  String photoGridItem(String date) {
    return '$date 的照片';
  }

  @override
  String get noPhotosFound => '没有找到照片。';

  @override
  String get manage => '管理';

  @override
  String get manageAccess => '管理权限';

  @override
  String get saveNow => '立即保存';

  @override
  String get hangOnWall => '挂到墙上';

  @override
  String get placeHere => '放在这里';

  @override
  String get openSettings => '打开设置';

  @override
  String get viewPremium => '查看 Premium';

  @override
  String get memoryNotFound => '找不到这条回忆';

  @override
  String get memoryTypeMoment => '瞬间';

  @override
  String get memoryTypeTrip => '旅行';

  @override
  String get memoryTypePerson => '人物';

  @override
  String get memoryTypePlace => '地点';

  @override
  String get memoryTypeNote => '便签';

  @override
  String get memoryTypeMomentDescription => '值得留住的小场景';

  @override
  String get memoryTypeTripDescription => '一段旅程或一日出游';

  @override
  String get memoryTypePersonDescription => '重要的人';

  @override
  String get memoryTypePlaceDescription => '有意义的地方';

  @override
  String get memoryTypeNoteDescription => '一个想法、一句话或一个提醒';

  @override
  String get categoryPersonal => '个人';

  @override
  String get categoryFamily => '家庭';

  @override
  String get categoryTravel => '旅行';

  @override
  String get feelingWarm => '温暖';

  @override
  String get feelingNostalgic => '怀念';

  @override
  String get feelingProud => '自豪';

  @override
  String get feelingCalm => '平静';

  @override
  String get feelingImportant => '重要';

  @override
  String get feelingWarmDescription => '柔软、亲近、满满的爱。';

  @override
  String get feelingNostalgicDescription => '一段把你拉回过去的回忆。';

  @override
  String get feelingProudDescription => '证明了什么的一刻。';

  @override
  String get feelingCalmDescription => '安静、安心、平和。';

  @override
  String get feelingImportantDescription => '改变了故事走向的回忆。';

  @override
  String get addPeopleHint => '添加属于这一刻的人。联系人只保存在本机。';

  @override
  String get addPerson => '添加人物';

  @override
  String get editPerson => '编辑人物';

  @override
  String get chooseFromContacts => '从通讯录选择';

  @override
  String get personNameLabel => '名字';

  @override
  String get personNameHint => '输入以搜索已保存的人';

  @override
  String get relationshipLabel => '关系';

  @override
  String get relationshipHint => '朋友、妈妈、伴侣...';

  @override
  String get phoneOptionalLabel => '电话（可选）';

  @override
  String get emailOptionalLabel => '邮箱（可选）';

  @override
  String get nameRelationshipRequired => '名字和关系为必填项。';

  @override
  String get contactAccessDenied => '未获得通讯录访问权限。';

  @override
  String get couldNotOpenContacts => '无法打开通讯录。';

  @override
  String get chooseContact => '选择联系人';

  @override
  String get searchContacts => '搜索联系人';

  @override
  String get noContactsFound => '没有找到联系人。';

  @override
  String get unnamedContact => '未命名联系人';

  @override
  String get contactRelationship => '联系人';

  @override
  String get couldNotLoadContacts => '无法加载联系人。';

  @override
  String get saveMomentTitle => '留住一刻';

  @override
  String get todayEyebrow => '今天';

  @override
  String get addMemoryStepTitle => '发生了什么你不想忘记的事？';

  @override
  String get addMemoryStepSubtitle => '写一句话，有照片就加上，然后保存。细节可以以后再补。';

  @override
  String get momentLabel => '瞬间';

  @override
  String get momentHint => '和 Lara 吃晚饭、第一次发布、安静的散步...';

  @override
  String get storyWorthLabel => '为什么值得留住？';

  @override
  String get storyWorthHint => '几个字就够了。';

  @override
  String get feelingEyebrow => '感受';

  @override
  String get feelingStepTitle => '它再次出现时，你希望是什么感觉？';

  @override
  String get feelingStepSubtitle => '这样以后更容易重新找到这段回忆。';

  @override
  String get contextEyebrow => '背景';

  @override
  String get whenWasItTitle => '是什么时候？';

  @override
  String get photoGpsStepSubtitle => '地图使用所选照片中保存的 GPS。照片没有 GPS 时不会显示地点。';

  @override
  String get peopleThreadsEyebrow => '人物与连线';

  @override
  String get peopleThreadsTitle => '它和谁、和什么有关？';

  @override
  String get peopleThreadsSubtitle => '补充一些可选细节，零散的瞬间就会串成生命之线。';

  @override
  String get connectExistingMemoryLabel => '连接到已有回忆';

  @override
  String get noConnectionYet => '还没有连接';

  @override
  String get connectionReasonLabel => '它们为什么相连？';

  @override
  String get connectionReasonHint => '例如：同一次旅行、同一个人、之前 / 之后...';

  @override
  String get writeMomentOrPhotoFirst => '请先写下一个瞬间或添加一张照片。';

  @override
  String get todaysMoment => '今天的瞬间';

  @override
  String get savedFromTodaysPrompt => '已从今日提问保存。';

  @override
  String get saveItBeforeItFades => '趁它还没褪色，留住它';

  @override
  String get chooseDate => '选择日期';

  @override
  String get dateLabel => '日期';

  @override
  String get untitledMemory => '未命名回忆';

  @override
  String get organize => '整理';

  @override
  String get memoryShape => '回忆形式';

  @override
  String get wallCategory => '墙面分类';

  @override
  String get privatePhotos => '私密照片';

  @override
  String get pick => '选择';

  @override
  String get addMore => '再加一些';

  @override
  String get takePhoto => '拍照';

  @override
  String get takePhotosNow => '现在拍照';

  @override
  String get takePhotosFabTooltip => '为新回忆拍照';

  @override
  String get takeAnotherPhoto => '再拍一张';

  @override
  String get continueWithPhotos => '用这些照片继续';

  @override
  String get addPhotosToMemory => '添加到回忆';

  @override
  String get takeAnotherOrContinueBody => '继续为这条回忆拍照，或者下一步写下故事。';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已拍 $count 张照片',
      one: '已拍 1 张照片',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads 会把所选照片复制到 App 的私密存储中，并在可用时保留日期和位置信息。';

  @override
  String get limitedPhotoAccessActive => '当前为有限照片访问。你可以允许更多照片。';

  @override
  String get selectPhotos => '选择照片';

  @override
  String get photoAccessOff => '照片访问已关闭';

  @override
  String get photoAccessOffBody => '开启照片访问才能挑选回忆。你的照片会留在这台设备上。';

  @override
  String get freeMemoryLimitReached => '已达到免费回忆上限';

  @override
  String get freeMemoryLimitBody => '免费回忆墙最多 30 条回忆。升级即可继续打造你的鲜活回忆墙。';

  @override
  String get photoAccessNeeded => '需要先开启照片访问。';

  @override
  String get quickPhotoMemory => '快拍回忆';

  @override
  String get quickPhotoDescription => '一张值得留下的照片。故事随时都能补上。';

  @override
  String get hangQuickPhoto => '挂上快拍照片';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return '检测到照片 GPS：$latitude, $longitude';
  }

  @override
  String get photoGpsMissing => '照片中没有 GPS。这条回忆不会出现在地图上。';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • $photoCount 张照片';
  }

  @override
  String metadataDates(int count, int total) {
    return '$count/$total 个日期';
  }

  @override
  String metadataLocations(int count, int total) {
    return '$count/$total 个位置';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total 个尺寸';
  }

  @override
  String newSelected(int count) {
    return '新选 $count 张';
  }

  @override
  String selectedCount(int count) {
    return '已选 $count 张';
  }

  @override
  String get editMemoryTitle => '编辑回忆';

  @override
  String get storyPanel => '故事';

  @override
  String get memoryTitleLabel => '回忆标题';

  @override
  String get addTitleValidation => '请添加标题';

  @override
  String get storyDescriptionLabel => '故事 / 描述';

  @override
  String get addStoryValidation => '请写一个简短的故事';

  @override
  String get shapeFeelingTitle => '形式与感受';

  @override
  String get memoryTypeLabel => '回忆类型';

  @override
  String get feelingLabel => '感受';

  @override
  String get categoryLabel => '分类';

  @override
  String get timePhotoGpsTitle => '时间与照片 GPS';

  @override
  String get memoryDateLabel => '回忆日期';

  @override
  String get peopleTitle => '人物';

  @override
  String get galleryTitle => '相册';

  @override
  String get addPhotos => '添加照片';

  @override
  String get saveMemory => '保存回忆';

  @override
  String get memorySaveFailed => '无法保存这条回忆。请再试一次。';

  @override
  String get passwordOnlySpaces => '密码不能只有空格。';

  @override
  String get somethingWentWrong => '出了点问题。请再试一次。';

  @override
  String get mapUnavailable => '地图暂时不可用。';

  @override
  String get coverPhoto => '封面照片';

  @override
  String get galleryPhoto => '相册照片';

  @override
  String get setAsCover => '设为封面';

  @override
  String get replacePhoto => '更换照片';

  @override
  String get removePhoto => '移除照片';

  @override
  String get choosePhoto => '选择照片';

  @override
  String get threadReasonsTitle => '连线的理由';

  @override
  String get createMoreMemoriesBeforeLinking => '先多创建几条回忆再来连接。';

  @override
  String get connectionHeaderBody => '带着理由连接回忆。这根线应该说明两个瞬间为什么属于彼此。';

  @override
  String get connectedMemory => '相连的回忆';

  @override
  String get whyConnectedTitle => '它们为什么相连？';

  @override
  String get exportPremiumArchiveTitle => '导出备份';

  @override
  String get importArchiveTitle => '导入归档';

  @override
  String get archiveExportBody => '添加密码即可加密归档。留空则为普通的本地 zip。';

  @override
  String get archiveImportBody => '如果归档已加密，请输入密码。旧的或未加密的备份请留空。';

  @override
  String get archivePasswordOptional => '归档密码（可选）';

  @override
  String get archivePasswordLabel => '归档密码';

  @override
  String get archivePasswordWarning => '请把密码保存在安全的地方。丢失后无法找回。';

  @override
  String get sendArchiveTitle => '发送 LifeThreads 归档';

  @override
  String get sendArchiveSubject => 'LifeThreads 回忆归档';

  @override
  String get sendEncryptedArchiveText =>
      '加密的 LifeThreads 归档。在另一台设备上导入时，请使用你设置的密码。';

  @override
  String get sendArchiveText =>
      'LifeThreads 归档。在 LifeThreads 中导入，即可在另一台设备上打开你的回忆墙。';

  @override
  String get archiveReadyToSend => '备份已就绪。请把它存放在这台手机以外的安全地方。';

  @override
  String get archiveNotSaved => '备份未保存。准备好后再导出一次。';

  @override
  String get archiveSharingUnavailable => '这台设备不支持分享。';

  @override
  String archiveShareFailed(Object error) {
    return '归档已保存，但分享失败：$error';
  }

  @override
  String get archiveImportedTitle => '归档已导入';

  @override
  String get memoriesLabel => '回忆';

  @override
  String get photosLabel => '照片';

  @override
  String get wallNotesNailsLabel => '便签 / 钉子';

  @override
  String get connectionsLabel => '连接';

  @override
  String get archiveImportSummary => '你当前的墙已保留。导入的回忆已安全添加。';

  @override
  String get shareEncryptedCapsuleTitle => '分享加密胶囊';

  @override
  String get openSharedCapsuleTitle => '打开共享胶囊';

  @override
  String get exportMemoryCapsuleTitle => '导出回忆胶囊';

  @override
  String get importCapsuleDialogTitle => '导入胶囊';

  @override
  String get secureSharePasswordBody => '上传这个胶囊前请先设置密码。把密码单独发给接收的人。';

  @override
  String get sharedCapsulePasswordBody => '输入你收到的这条共享回忆的密码。';

  @override
  String get capsuleExportBody => '如果想在发送前保护这条回忆，请添加密码。留空则为普通胶囊。';

  @override
  String get capsuleImportBody => '如果胶囊有密码，请输入。没有就留空。';

  @override
  String get capsulePasswordLabel => '胶囊密码';

  @override
  String get sharedCapsulePasswordLabel => '共享胶囊密码';

  @override
  String get capsulePasswordOptional => '胶囊密码（可选）';

  @override
  String get capsulePasswordWarning => 'LifeThreads 之后无法找回这个密码。';

  @override
  String get passwordRequiredCloudSharing => '云分享需要密码。';

  @override
  String get createSecureShare => '创建安全分享';

  @override
  String get previewMemory => '预览回忆';

  @override
  String get sendCapsuleTitle => '分享 LifeThreads 回忆';

  @override
  String get sendCapsuleSubject => 'LifeThreads 回忆胶囊';

  @override
  String get sendEncryptedCapsuleText =>
      '嗨，我在 LifeThreads 和你分享了一条加密的回忆。用我发你的密码导入吧。';

  @override
  String get sendCapsuleText =>
      '嗨，我在 LifeThreads 和你分享了一条回忆。在 LifeThreads 中导入胶囊，就能把它加到你的墙上。';

  @override
  String get capsuleReadyToSend => '胶囊已准备好发送。';

  @override
  String get capsuleSavedLater => '胶囊已保存。你可以稍后再分享。';

  @override
  String get capsuleSharingUnavailable => '胶囊已保存，但无法分享。';

  @override
  String capsuleShareFailed(Object error) {
    return '胶囊已保存，但分享失败：$error';
  }

  @override
  String get importThisMemory => '导入这条回忆？';

  @override
  String get noStoryTextIncluded => '不含故事文字。';

  @override
  String get placeLabel => '地点';

  @override
  String get notesLabel => '便签';

  @override
  String get capsulePasswordProtected => '这个胶囊设有密码保护。';

  @override
  String get openingSharedMemory => '正在打开共享回忆...';

  @override
  String get lifeThreadsMemoryTitle => 'LifeThreads 回忆';

  @override
  String shareMemoryText(Object url) {
    return '嗨，我在 LifeThreads 和你分享了一条回忆。\n\n$url';
  }

  @override
  String get shareLinkReady => '分享链接已就绪。';

  @override
  String get shareLinkCreated => '分享链接已创建。';

  @override
  String get shareLinkUnavailable => '分享链接已创建，但无法分享。';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label 链接会自动过期。你也可以现在删除。';
  }

  @override
  String cloudShareFailed(Object message) {
    return '云分享失败：$message';
  }

  @override
  String get sharedMemoryLinkDeleted => '共享回忆链接已删除。';

  @override
  String get creatingSecureMemoryLink => '正在创建安全链接...';

  @override
  String get shareMemoryCapsule => '分享回忆胶囊';

  @override
  String get editStory => '编辑故事';

  @override
  String get metaType => '类型';

  @override
  String get metaFeeling => '感受';

  @override
  String get metaCategory => '分类';

  @override
  String get metaDate => '日期';

  @override
  String get storyEyebrow => '故事';

  @override
  String get whyMemoryMatters => '这段回忆为何重要';

  @override
  String get galleryEyebrow => '相册';

  @override
  String editSectionTooltip(String section) {
    return '编辑$section';
  }

  @override
  String get openInMaps => '在地图中打开';

  @override
  String get memoryChangesSaved => '更改已保存。';

  @override
  String get memoryDeletedToast => '回忆已删除。';

  @override
  String get noteDeletedToast => '便签已删除。';

  @override
  String get nailDeletedToast => '钉子已移除。';

  @override
  String get undo => '撤销';

  @override
  String photoPlaceDetected(String place) {
    return '照片中的地点：$place';
  }

  @override
  String get settingsGroupYou => '你';

  @override
  String get settingsGroupReminders => '提醒';

  @override
  String get settingsGroupMore => '更多';

  @override
  String get backupDataTitle => '备份与数据';

  @override
  String get backupDataSubtitle => '备份、恢复、换新手机';

  @override
  String get aboutHelpTitle => '关于与帮助';

  @override
  String get aboutHelpSubtitle => '反馈、隐私、音乐、版本';

  @override
  String get discardChangesTitle => '放弃更改？';

  @override
  String get discardChangesBody => '你在这里的更改将会丢失。';

  @override
  String get discardChanges => '放弃';

  @override
  String get keepEditing => '继续编辑';

  @override
  String get settingsGroupPrivacy => '隐私';

  @override
  String get appLockTitle => 'App 锁';

  @override
  String get appLockSubtitle => '用面容 ID 或密码打开 LifeThreads';

  @override
  String get appLockReason => '解锁你的回忆';

  @override
  String get appLockLockedTitle => 'LifeThreads 已锁定';

  @override
  String get appLockUnlock => '解锁';

  @override
  String get appLockUnavailable => '请先在这台手机上设置面容 ID 或密码。';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '一条 $years 年前的回忆在等你。',
      one: '一条 1 年前的回忆在等你。',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => '搜索';

  @override
  String get searchHint => '标题、地点、人物或年份';

  @override
  String get searchClear => '清除搜索';

  @override
  String get searchNoResults => '没有匹配的回忆。';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条回忆',
      one: '1 条回忆',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => '搜索回忆';

  @override
  String get premiumFeatureWalls => '更多墙';

  @override
  String get newWall => '新建墙';

  @override
  String get wallNameLabel => '墙的名称';

  @override
  String get newWallHint => '例如：2025 旅行';

  @override
  String get createWall => '创建';

  @override
  String get renameWall => '重命名';

  @override
  String get deleteWall => '删除墙';

  @override
  String deleteWallQuestion(String name) {
    return '删除“$name”？';
  }

  @override
  String get deleteWallBody => '其中的回忆会移到“我的墙”，不会丢失任何内容。';

  @override
  String get personalWallSubtitle => '你的墙，在这台设备上';

  @override
  String get wallOptions => '墙的选项';

  @override
  String get moveToWall => '移到墙…';

  @override
  String movedToWall(String name) {
    return '已移到$name。';
  }

  @override
  String get hideMemory => '隐藏';

  @override
  String get unhideMemory => '重新显示';

  @override
  String get memoryHiddenToast => '已隐藏。可在 视图 › 隐藏的回忆 中找到。';

  @override
  String get showHiddenMemories => '隐藏的回忆';

  @override
  String get showHiddenReason => '显示隐藏的回忆';

  @override
  String get yearThreadFirstTitle => '你的第一条年度时光线';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '3 条回忆中的 $count 条',
      one: '3 条回忆中的 1 条',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => '或者现在做个故事';

  @override
  String get moveMemoriesHere => '把回忆移到这里';

  @override
  String get moveMemoriesTitle => '选择要移到这里的回忆';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '移动 $count 条回忆',
      one: '移动 1 条回忆',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => '全部显示';

  @override
  String get addAMemory => '添加回忆';

  @override
  String get mapAddPhotoMemory => '添加一张带地点的照片';

  @override
  String get searchSuggestions => '试试你的回忆';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years 年前的这一周',
      one: '1 年前的这一周',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => '当时有谁？';

  @override
  String get premiumPlanYearly => '按年';

  @override
  String get premiumPlanMonthly => '按月';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/年';
  }

  @override
  String premiumSavePercent(int percent) {
    return '省 $percent%';
  }

  @override
  String purchasesHandledYearly(String store) {
    return '费用将从你的 $store 账户扣除。除非在当前周期结束前至少 24 小时取消，否则订阅会每年自动续订。你可以在 $store 账户设置中管理或取消订阅。';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已保存 $count 张照片',
      one: '已保存 1 张照片',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => '人物';

  @override
  String get partOfMemory => '这段回忆里的人';

  @override
  String get notesEyebrow => '便签';

  @override
  String get attachedThoughts => '附上的想法';

  @override
  String get stickyNote => '便利贴';

  @override
  String get placeEyebrow => '地点';

  @override
  String get threadsEyebrow => '连线';

  @override
  String get connectedMemories => '相连的回忆';

  @override
  String get noConnectedMemoriesYet => '还没有相连的回忆。把这一章和另一个瞬间连起来，开启一条看得见的生命之线。';

  @override
  String get backToWall => '返回回忆墙';

  @override
  String get addTextToWall => '在墙上添加文字';

  @override
  String get addTextAction => '添加文字';

  @override
  String get textNoteHint => '写一段小回忆、一句话或一张便签...';

  @override
  String get placeTextNote => '放置文字便签';

  @override
  String get placeRopeAnchor => '放置绳结';

  @override
  String get nailSubtitle => '钉子可以在回忆之间手动牵线。';

  @override
  String get clearDemoWallQuestion => '清除示例墙？';

  @override
  String get clearDemoWallBody => '这会移除示例回忆，让你从一面空白的私人墙开始。';

  @override
  String get importBackupQuestion => '导入备份？';

  @override
  String get importBackupBody => '这会从 LifeThreads 归档恢复回忆，并保留你当前的墙。';

  @override
  String get deleteMemoryQuestion => '删除回忆？';

  @override
  String get deleteMemoryBody => '这会删除这条回忆及其在墙上的所有连线。';

  @override
  String get editText => '编辑文字';

  @override
  String get editTextTitle => '编辑文字';

  @override
  String get connectRope => '连接绳子';

  @override
  String get connectRopeSubtitle => '把这颗钉子连到回忆上。';

  @override
  String get deleteNail => '删除钉子';

  @override
  String get connectNailTitle => '把钉子连到回忆';

  @override
  String get connectNailSubtitle => '所选回忆会挂在这个绳结上。';

  @override
  String get timelineTitle => '时间线';

  @override
  String get timelineSubtitle => '按时间排列的回忆。';

  @override
  String get noMemoriesFilter => '此筛选下没有回忆';

  @override
  String get noMemoriesFilterBody => '换个筛选条件，或添加一条回忆来建立时间线。';

  @override
  String get memoryMapTitle => '回忆地图';

  @override
  String get memoryMapSubtitle => '按地点分组的回忆。';

  @override
  String get noMappedMemories => '地图上还没有回忆';

  @override
  String get displayWallTooltip => '展示回忆墙';

  @override
  String get tutorialTooltip => '教程';

  @override
  String get settingsTooltip => '设置';

  @override
  String get freeformLayout => '自由';

  @override
  String get categoryLayout => '分类';

  @override
  String get locationLayout => '地点';

  @override
  String get saveToday => '记录今天';

  @override
  String get rememberThis => '记住这一刻';

  @override
  String get whatHappenedToday => '今天发生了什么？';

  @override
  String get tapToOpenDrag => '轻点打开 • 拖动移动';

  @override
  String get demoWallPreview => '这是示例墙。准备好从头开始时就清除它。';

  @override
  String get clearDemo => '清除示例';

  @override
  String get chooseQuickPhoto => '选择快拍照片';

  @override
  String get wallView => '墙';

  @override
  String get timelineView => '时间线';

  @override
  String get mapView => '地图';

  @override
  String get wallFilterAll => '全部';

  @override
  String get wallViewButton => '视图';

  @override
  String get wallShowAs => '显示为';

  @override
  String get wallArrange => '整理';

  @override
  String get wallShowOnly => '显示';

  @override
  String get layoutByDate => '按日期';

  @override
  String get moreActionsTooltip => '更多';

  @override
  String get addToWallTitle => '添加到你的墙';

  @override
  String get expandableMemory => '回忆';

  @override
  String get expandableMemorySubtitle => '完整的引导式故事';

  @override
  String get expandableQuickPhoto => '快拍回忆';

  @override
  String get expandableQuickPhotoSubtitle => '选张照片挂上去';

  @override
  String get expandableTextNote => '文字便签';

  @override
  String get expandableTextNoteSubtitle => '墙上的小想法';

  @override
  String get expandableNail => '钉子 / 绳结';

  @override
  String get expandableNailSubtitle => '手动牵线点';

  @override
  String get startWithOneThing => '从今天的一件事开始';

  @override
  String get emptyWallBody => '趁瞬间还没褪色，留住它。一句话或一张照片就够了。';

  @override
  String get usePhoto => '使用照片';

  @override
  String get editMemoryTooltip => '编辑回忆';

  @override
  String get connectMemoryTooltip => '连接回忆';

  @override
  String get archiveTransferTitle => '在另一台设备上打开';

  @override
  String get archiveTransferHeroTitle => '安全地在设备间迁移回忆。';

  @override
  String get archiveTransferHeroBody =>
      '备份是一个 zip，包含你的回忆、照片、便签、连线、墙上位置和元数据，可选择加密码。我们不保留任何副本：去向由你决定。';

  @override
  String get archiveTransferStep1Title => '导出归档';

  @override
  String get archiveTransferStep1Body => '打开设置，选择“导出归档”，需要保护时再加个密码。';

  @override
  String get archiveTransferStep2Title => '转移 zip';

  @override
  String get archiveTransferStep2Body => '通过隔空投送、USB、你自己的云盘或邮件传输。';

  @override
  String get archiveTransferStep3Title => '安全导入';

  @override
  String get archiveTransferStep3Body =>
      '在另一台设备上安装 LifeThreads，选择“导入归档”，需要时输入密码，即可在不删除现有数据的情况下恢复。';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled => '已启用开发版 Premium 解锁。';

  @override
  String get lifetimeActive => '订阅已生效';

  @override
  String get oneTimeLifetimeUnlock => '按年或按月';

  @override
  String get premiumHeroActiveTitle => '你的回忆墙没有上限。';

  @override
  String get premiumHeroLockedTitle => '把回忆变成故事。';

  @override
  String get premiumHeroActiveBody =>
      '你的 Premium 订阅已生效。带音乐的故事、年度时光线、家庭墙和无限回忆，全都归你。';

  @override
  String premiumHeroLockedBody(int limit) {
    return '免费版包含 $limit 条回忆和完整备份。Premium 再加上带音乐的故事和短片、年度时光线、家庭墙和无限回忆。';
  }

  @override
  String get premiumMemories => 'Premium 回忆';

  @override
  String get freeMemories => '免费回忆';

  @override
  String get unlimited => '无限';

  @override
  String get benefitUnlimitedTitle => '无限回忆';

  @override
  String get benefitUnlimitedBody => '不再有 30 条的上限。随着生活成长，继续丰富你的墙。';

  @override
  String get benefitThemesTitle => 'Premium 墙面主题';

  @override
  String get benefitThemesBody => '解锁更丰富的氛围、限时季节主题，以及按时段自动切换。';

  @override
  String get benefitLayoutsTitle => '高级布局';

  @override
  String get benefitLayoutsBody => '更多方式排列连线、时间线、绳结和回忆分组。';

  @override
  String get lifetimeUnlock => 'Premium 订阅';

  @override
  String get premiumActiveOnDevice => 'Premium 已在这台设备上生效。';

  @override
  String onePurchaseBody(String store) {
    return '按年或按月订阅，享受带音乐的故事、年度时光线、家庭墙和无限回忆。可随时在 $store 设置中取消。';
  }

  @override
  String get premiumActiveButton => 'Premium 已生效';

  @override
  String get processing => '处理中...';

  @override
  String get unlockPremium => '订阅 Premium';

  @override
  String get restorePurchase => '恢复订阅';

  @override
  String get enableDebugMockUnlock => '启用测试解锁';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return '费用将从你的 $store 账户扣除。除非在当前周期结束前至少 24 小时取消，否则订阅会每月自动续订。你可以在 $store 账户设置中管理或取消订阅。';
  }

  @override
  String get premiumMessageBillingUpdateFailed => '商店更新失败。请再试一次。';

  @override
  String get premiumMessageStoreUnavailable => '这台设备无法购买。';

  @override
  String get premiumMessageProductUnavailable => '商店中暂时还没有 Premium。请稍后再试。';

  @override
  String get premiumMessageLoadFailed => '无法从商店加载 Premium。请再试一次。';

  @override
  String get premiumMessageOpeningCheckout => '正在打开付款页面…';

  @override
  String get premiumMessageCheckoutFailed => '无法打开付款页面。请再试一次。';

  @override
  String get premiumMessageChecking => '正在检查你的订阅…';

  @override
  String get premiumMessageRestoreFailed => '恢复失败。请再试一次。';

  @override
  String get premiumMessageNoSubscriptionFound => '没有找到有效的 Premium 订阅。';

  @override
  String get premiumMessagePending => '你的购买正在处理中。批准后即可解锁 Premium。';

  @override
  String get premiumMessagePurchaseFailed => '购买没有完成。请再试一次。';

  @override
  String get premiumMessageCanceled => '已取消购买。';

  @override
  String get premiumMessageRestored => '你的 Premium 订阅已恢复。';

  @override
  String get premiumMessageActive => '你的 Premium 订阅已生效。';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/月';
  }

  @override
  String get loadingPlayStoreProduct => '正在加载订阅…';

  @override
  String get playStoreUnavailable => '商店暂时不可用';

  @override
  String get productNotConfigured => 'Premium 暂时不可用';

  @override
  String get purchasePending => '购买处理中';

  @override
  String get purchased => '已购买';

  @override
  String get restored => '已恢复';

  @override
  String get premiumTryAgain => '重试';

  @override
  String get purchaseFailed => '购买失败';

  @override
  String get preparingCheckout => '正在准备付款...';

  @override
  String get premiumLocalFirstTitle => 'Premium 同样本地优先';

  @override
  String get premiumLocalFirstBody => '你的回忆留在你的设备上，备份对所有人免费。';

  @override
  String get noMappedMemoriesBody => '添加带有 GPS 信息的照片，回忆就会显示在这里。';

  @override
  String get peopleLabel => '人物';

  @override
  String get connect => '连接';

  @override
  String get themeWarmMemoryRoom => '温暖回忆屋';

  @override
  String get themeWarmMemoryRoomDescription => '柔和的暗调暖意、金色灯光和私密小屋的深邃感。';

  @override
  String get themeMidnightArchive => '午夜档案馆';

  @override
  String get themeMidnightArchiveDescription => '深蓝色档案室，像博物馆一样静谧专注。';

  @override
  String get themeSoftPaperWall => '柔和纸墙';

  @override
  String get themeSoftPaperWallDescription => '奶油色纸张、墨色阴影和安静的手账感。';

  @override
  String get themeTravelCorkboard => '旅行软木板';

  @override
  String get themeTravelCorkboardDescription => '带地图网格的温暖软木板，适合旅行和地点。';

  @override
  String get themeAutoTitle => '按时段自动';

  @override
  String get themeAutoDescription => '白天柔和纸墙，傍晚温暖回忆屋，夜里午夜档案馆。';

  @override
  String get themeAutoSelected => '你的墙现在会随时段变化。';

  @override
  String get themeSeasonalTitle => '季节限定';

  @override
  String get themeSeasonalBody => '限时 Premium 主题，每个只在对应季节开放。';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '截至 $dateString';
  }

  @override
  String get themeUseButton => '使用此主题';

  @override
  String get themeInUse => '使用中';

  @override
  String get themeUnlockButton => '用 Premium 解锁';

  @override
  String get themeAutumnHarvest => '秋日丰收';

  @override
  String get themeAutumnHarvestDescription => '琥珀色光线、牛皮纸卡片和飘落树叶的光泽。';

  @override
  String get themeWinterLights => '冬日灯火';

  @override
  String get themeWinterLightsDescription => '寒冷蓝夜里，结霜的卡片和温暖的串灯。';

  @override
  String get themeSpringBlossom => '春日花开';

  @override
  String get themeSpringBlossomDescription => '淡雅的花卉卡片，泛着柔和的粉色光晕。';

  @override
  String get themeSummerEvening => '夏日傍晚';

  @override
  String get themeSummerEveningDescription => '落日色彩和拍立得卡片。';

  @override
  String get themeYearRoundTitle => '全年可用';

  @override
  String get themeComingTitle => '即将推出';

  @override
  String get themeComingBody => '预览接下来的季节。每个主题会在它所属季节的第一天开放。';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString 起';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '查看全部主题，本季 $count 个',
      one: '查看全部主题，本季 1 个',
      zero: '查看全部主题',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => '海边';

  @override
  String get themeSeasideDescription => '碧绿海水、沙色纸张和温暖的夏日阳光。';

  @override
  String get themeSnowyCabin => '雪中小屋';

  @override
  String get themeSnowyCabinDescription => '炉火旁的木头、结霜的卡片，窗外是轻柔的雪。';

  @override
  String get themeSpringMeadow => '春日草地';

  @override
  String get themeSpringMeadowDescription => '清新的青草、浅色卡片和金黄阳光。';

  @override
  String get themeMistyForest => '雾中森林';

  @override
  String get themeMistyForestDescription => '静谧松林、晨雾和金色树叶。';

  @override
  String get demoFirstDanceTitle => '我们的第一支舞';

  @override
  String get demoFirstDanceStory =>
      '乐队奏起我们的歌，整个谷仓都安静了。我踩了你两次脚，你一直在笑，那三分钟里仿佛只有我们俩。';

  @override
  String get demoFirstDancePlace => '萨尔茨堡';

  @override
  String get demoNewbornTitle => '欢迎回家，Lina';

  @override
  String get demoNewbornStory => '她整只小手只够握住一根手指。在家的第一个安静早晨。';

  @override
  String get demoNewbornPlace => '维也纳';

  @override
  String get demoBeachSunsetTitle => '海边的夏天';

  @override
  String get demoBeachSunsetStory => '光着脚玩到日落，回去的路上 Lina 趴在你肩上睡着了。';

  @override
  String get demoBeachSunsetPlace => '克罗地亚 斯普利特';

  @override
  String get demoGrandmaKitchenTitle => '奶奶的厨房';

  @override
  String get demoGrandmaKitchenStory => '她的杏子蛋糕，终于写成了食谱——面粉撒得到处都是。';

  @override
  String get demoGrandmaKitchenPlace => '格拉茨';

  @override
  String get demoGraduationTitle => '毕业那天';

  @override
  String get demoGraduationStory => '学士帽还没落地，爸爸就哭了。';

  @override
  String get demoGraduationPlace => '因斯布鲁克';

  @override
  String get demoFirstHomeTitle => '第一个家的钥匙';

  @override
  String get demoFirstHomeStory => '还没有家具，只有纸箱、地板上的披萨和一堆计划。';

  @override
  String get demoFirstHomePlace => '林茨';

  @override
  String get demoAlpineSummitTitle => '云层之上';

  @override
  String get demoAlpineSummitStory => '为了这一幕凌晨 4 点起床。每一步都值得。';

  @override
  String get demoAlpineSummitPlace => '大格洛克纳山';

  @override
  String get demoFirstBikeTitle => '第一次放手骑车';

  @override
  String get demoFirstBikeStory => '蹬了三下，晃了一下，然后他就骑走了——骄傲极了。';

  @override
  String get demoFirstBikePlace => '维也纳 普拉特公园';

  @override
  String get demoGardenDinnerTitle => '爷爷的 80 岁生日';

  @override
  String get demoGardenDinnerStory => '四代人围坐在一张长桌旁，讲故事最好听的还是他。';

  @override
  String get demoGardenDinnerPlace => '瓦豪河谷';

  @override
  String get demoThreadFirstDanceToFirstHome => '我们的故事';

  @override
  String get demoThreadFirstHomeToNewborn => '后来有了 Lina';

  @override
  String get demoThreadNewbornToBeachSunset => '她的第一个夏天';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => '家人';

  @override
  String get demoThreadGraduationToFirstHome => '新篇章';

  @override
  String get demoThreadAlpineSummitToFirstBike => '小小冒险';

  @override
  String get demoThreadFirstBikeToGardenDinner => '爷爷在一旁看着';

  @override
  String get demoRelationGrandpa => '爷爷';

  @override
  String get demoRelationGrandma => '奶奶';

  @override
  String get demoRelationDaughter => '女儿';

  @override
  String get demoRelationWife => '妻子';

  @override
  String get demoRelationBestMan => '伴郎';

  @override
  String get demoRelationMother => '妈妈';

  @override
  String savedToPath(Object label, Object path) {
    return '$label 已保存到 $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 条回忆还没备份。',
      one: '有 1 条回忆还没备份。',
    );
    return '$_temp0';
  }

  @override
  String get later => '稍后';

  @override
  String get backUp => '备份';

  @override
  String get onThisDayTitle => '那年今日';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years 年前的今天',
      one: '1 年前的今天',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years 年前',
      one: '1 年前',
    );
    return '那年今日 · $_temp0';
  }

  @override
  String get onThisDaySettingsBody => '在往年的回忆重现的日子里，LifeThreads 会发送一条安静的提醒。';

  @override
  String get onThisDayReminderSwitch => '每日提醒';

  @override
  String onThisDayReminderAt(String time) {
    return '$time';
  }

  @override
  String get onThisDayNotificationsDenied => 'LifeThreads 的通知已关闭。请在手机设置中允许通知。';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years 年前的今天：$title',
      one: '1 年前的今天：$title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条回忆',
      one: '1 条回忆',
    );
    return '$title，以及这一天的另外 $_temp0';
  }

  @override
  String get onThisDayChannelDescription => '往年这一天的回忆。';

  @override
  String get benefitOnThisDayBody => '往年的回忆重现时提醒你，并作为独立的一章打开。';

  @override
  String get premiumFeatureStoryImage => '故事图片';

  @override
  String get premiumFeatureStoryVideo => '故事视频';

  @override
  String get premiumFeatureThreadOfTheYear => '年度时光线';

  @override
  String get premiumFeatureFamilyWall => '家庭墙';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature是 Premium 功能。';
  }

  @override
  String get yearThreadTitle => '年度时光线';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条回忆',
      one: '1 条回忆',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个地点',
      one: '1 个地点',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个人',
      one: '1 个人',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个月',
      one: '1 个月',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return '最常有的感受：$feeling';
  }

  @override
  String get yearThreadClosingLine => '一年，一线串起。';

  @override
  String get yearThreadMyYear => '我的一年';

  @override
  String get yearThreadWallCardTitle => '回忆里的这一年';

  @override
  String yearThreadWallCardBody(String year) {
    return '把 $year 年做成一部短片。';
  }

  @override
  String get yearThreadDismiss => '以后再说';

  @override
  String get yearThreadSettingsBody => '把任何至少有 3 条回忆的年份做成短片，按顺序讲述，由一条线串起。';

  @override
  String get yearThreadOpen => '制作短片';

  @override
  String get yearThreadNoYears => '年度时光线需要某一年至少有 3 条回忆。继续记录瞬间，再回来看看。';

  @override
  String get yearThreadYear => '年份';

  @override
  String get yearThreadLength => '时长';

  @override
  String yearThreadLengthFull(int seconds) {
    return '短片 · $seconds 秒';
  }

  @override
  String get yearThreadLengthStory => '故事 · 20 秒';

  @override
  String get yearThreadMusic => '音乐';

  @override
  String get yearThreadNoMusic => '无音乐';

  @override
  String get yearThreadInFilm => '片中回忆';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String get yearThreadAddMemory => '添加回忆';

  @override
  String get yearThreadSwap => '替换';

  @override
  String get yearThreadRemove => '移除';

  @override
  String get yearThreadUseSuggestions => '使用推荐';

  @override
  String yearThreadPickTitle(String year) {
    return '选择 $year 年的一条回忆';
  }

  @override
  String get yearThreadNoOthers => '这一年的所有回忆都已经在短片里了。';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条回忆',
      one: '1 条回忆',
    );
    return '请至少选择 $_temp0。';
  }

  @override
  String get yearThreadPreview => '预览';

  @override
  String get yearThreadExportVideo => '导出视频';

  @override
  String get yearThreadExportImage => '导出图片';

  @override
  String get yearThreadShare => '分享';

  @override
  String get yearThreadSave => '存到相册';

  @override
  String get yearThreadMakingFilm => '正在制作短片…';

  @override
  String get yearThreadMakingImage => '正在制作图片…';

  @override
  String get yearThreadFilmReady => '短片做好了';

  @override
  String get yearThreadImageReady => '图片做好了';

  @override
  String get yearThreadSaved => '已存到相册。';

  @override
  String get yearThreadExportFailed => '没有成功。请再试一次。';

  @override
  String get yearThreadPlay => '播放';

  @override
  String get yearThreadPause => '暂停';

  @override
  String get createStory => '制作故事';

  @override
  String get storyPickTitle => '选择回忆';

  @override
  String storyPickBody(int max) {
    return '一个故事最多选 $max 条回忆。';
  }

  @override
  String storyPickCount(int count, int max) {
    return '已选 $count/$max';
  }

  @override
  String storyPickLimit(int max) {
    return '一个故事最多包含 $max 条回忆。';
  }

  @override
  String get storyPickContinue => '继续';

  @override
  String get storyNoMemories => '先保存一条回忆，再把它变成故事。';

  @override
  String get storyEditorTitle => '你的故事';

  @override
  String get storyChangeMemories => '更换回忆';

  @override
  String get storyTemplateSingle => '单条回忆';

  @override
  String get storyTemplateThread => '连线墙';

  @override
  String get storyTemplateCollage => '拼贴';

  @override
  String get storyTemplateQuote => '文字';

  @override
  String get storySwipeHint => '滑动换个样式';

  @override
  String get storyCaptionLabel => '配文';

  @override
  String get storyCaptionHint => '用一句话讲你的故事';

  @override
  String get storyVideoSwitch => '视频';

  @override
  String get storyVideoBody => '适合快拍和 Reels 的短片，带动效和音乐。';

  @override
  String get storyMusicTitle => '音乐';

  @override
  String get storyMusicNone => '无音乐';

  @override
  String get storyMusicNoneHint => '你也可以在 Instagram 发布时再加音乐。';

  @override
  String get storyMoodWarm => '温暖';

  @override
  String get storyMoodJoyful => '欢快';

  @override
  String get storyMoodCalm => '平静';

  @override
  String get storyMoodNostalgic => '怀旧';

  @override
  String get storyMoodEpic => '壮阔';

  @override
  String get storyMoodEmotional => '动情';

  @override
  String get storyMusicTrimHint => '拖动金色框，选择歌曲片段';

  @override
  String get storySearchHint => '搜索回忆、地点、年份';

  @override
  String storySearchEmpty(String query) {
    return '没有回忆匹配“$query”。';
  }

  @override
  String get storyMemoriesInStory => '故事里的回忆';

  @override
  String get storyMemoriesReorderHint => '长按并拖动来调整顺序';

  @override
  String get storyAddMemory => '添加';

  @override
  String get storyAddMemoryTitle => '添加回忆';

  @override
  String storyRemoveMemory(String title) {
    return '从故事中移除$title';
  }

  @override
  String get storyAllMemoriesAdded => '所有回忆都已经在这个故事里了。';

  @override
  String get storyShare => '分享';

  @override
  String get storySaveToPhotos => '存到相册';

  @override
  String get storySaved => '已存到相册。';

  @override
  String get storySaveDenied => 'LifeThreads 无法添加到你的相册。请在手机设置中允许。';

  @override
  String storyExportFailed(String error) {
    return '无法制作故事：$error';
  }

  @override
  String get storyRenderingTitle => '正在制作短片';

  @override
  String get storyRenderingBody => '请保持 LifeThreads 打开，只需几秒钟。';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent%';
  }

  @override
  String get storyPreviewFree => '预览免费。分享和保存故事是 Premium 功能。';

  @override
  String get benefitStoriesTitle => '制作故事';

  @override
  String get benefitStoriesBody => '把回忆变成故事图片和带音乐的短片，发到 Instagram、WhatsApp 等。';

  @override
  String get musicCreditsTitle => '音乐版权信息';

  @override
  String get musicCreditsBody => '故事视频内置的歌曲及其许可证。';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody => '把你的一年做成短片：重要的瞬间，按顺序串起，配上音乐。';

  @override
  String get benefitFamilyTitle => '家庭墙';

  @override
  String get benefitFamilyBody => '为家人准备的共享墙，端到端加密。每个人都能添加自己的瞬间。';

  @override
  String get myWall => '我的墙';

  @override
  String get myWallSubtitle => '私密，在这台设备上';

  @override
  String get switchWall => '切换墙';

  @override
  String get familyWallsTitle => '家庭墙';

  @override
  String get familyWallsSettingsBody =>
      '与家人或朋友共享一面墙：每个人都能添加回忆，端到端加密。“我的墙”仍在这台设备上保持私密。';

  @override
  String get familyWallsOpen => '打开家庭墙';

  @override
  String get familyWallsManage => '管理家庭墙';

  @override
  String get familyWallsHeadline => '一面墙，全家人';

  @override
  String get familyWallsIntro =>
      '家庭墙与你邀请的人共享。回忆和照片在上传前会在你的手机上加密，只有成员才能打开。“我的墙”不会共享，只留在这台设备上。';

  @override
  String get familyUnavailableTitle => '暂不可用';

  @override
  String get familyUnavailable => '这个版本的 LifeThreads 还不支持家庭墙。';

  @override
  String get familySignInNeededTitle => '登录后使用家庭墙';

  @override
  String get familySignInNeededBody => '共享墙需要账户，这样家人才知道是谁添加了什么。“我的墙”无需账户。';

  @override
  String get familySignIn => '登录';

  @override
  String get familyLoadFailed => '无法加载';

  @override
  String get familyRetry => '重试';

  @override
  String get familyNoWallsYet => '还没有家庭墙。创建一面，或通过邀请链接加入。';

  @override
  String get familyStartTitle => '创建或加入';

  @override
  String get familyStartBody => '创建家庭墙需要 Premium。加入是免费的：创建者的 Premium 覆盖全家。';

  @override
  String get familyCreateAction => '创建家庭墙';

  @override
  String get familyCreateTitle => '新的家庭墙';

  @override
  String get familyNameLabel => '墙的名称';

  @override
  String get familyNameHint => '例如：王家';

  @override
  String get familyMyNameLabel => '你在这面墙上的名字';

  @override
  String get familyMyNameHelper => '成员会在你的回忆上看到它。和墙上的一切一样，它也是加密的。';

  @override
  String get familyMyNameSaved => '名字已保存。';

  @override
  String get familySetMyName => '我的名字';

  @override
  String get familyCheckingSubscription => '正在检查你的 Premium…';

  @override
  String get familyCreating => '正在创建墙…';

  @override
  String get familyJoinWithLink => '通过链接加入';

  @override
  String get familyInviteLinkLabel => '邀请链接';

  @override
  String get familyJoinTitle => '加入这面家庭墙？';

  @override
  String get familyJoinBody => '成员会看到你的名字和你添加的回忆，你也能看到他们的。你可以随时离开。';

  @override
  String get familyJoinAction => '加入';

  @override
  String get familyJoining => '正在加入…';

  @override
  String familyJoined(String family) {
    return '你已加入$family。';
  }

  @override
  String get familyRoleOwner => '创建者';

  @override
  String get familyRoleMember => '成员';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位成员',
      one: '1 位成员',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => '墙的设置';

  @override
  String familyStorageUsed(String used, String total) {
    return '已用 $used，共 $total';
  }

  @override
  String get familyRename => '重命名';

  @override
  String get familyInviteTitle => '邀请';

  @override
  String get familyInviteBody => '把链接发给你信任的人。每个链接只能用一次，7 天后过期。';

  @override
  String get familyInviteAction => '创建邀请链接';

  @override
  String get familyCreatingInvite => '正在创建邀请…';

  @override
  String get familyInviteReady => '邀请链接已就绪';

  @override
  String get familyInviteValidity => '只能使用一次，最迟 7 天后过期。';

  @override
  String get familyInviteKeyWarning => '链接中含有这面墙的密钥：打开它的人都能加入并查看这面墙。只发给你要邀请的人。';

  @override
  String get familyInviteShare => '分享链接';

  @override
  String get familyInviteCopy => '复制链接';

  @override
  String get familyInviteCopied => '链接已复制。';

  @override
  String get familyInviteShareFailed => '无法分享。请改为复制链接。';

  @override
  String familyInviteSubject(String family) {
    return '来 LifeThreads 加入$family';
  }

  @override
  String familyInviteText(String family, String link) {
    return '来 LifeThreads 加入我们的家庭墙“$family”吧：$link';
  }

  @override
  String get familyMembersTitle => '成员';

  @override
  String get familyMemberActions => '成员操作';

  @override
  String get familyYou => '你';

  @override
  String familyYouNamed(String name) {
    return '$name（你）';
  }

  @override
  String get familyAMember => '一位成员';

  @override
  String get familyFormerMember => '前成员';

  @override
  String get familyBlocked => '已屏蔽';

  @override
  String get familyBlock => '屏蔽';

  @override
  String get familyUnblock => '取消屏蔽';

  @override
  String familyBlockAuthor(String name) {
    return '屏蔽$name';
  }

  @override
  String familyBlockQuestion(String name) {
    return '屏蔽$name？';
  }

  @override
  String get familyBlockBody => '你将不再在任何家庭墙上看到对方的回忆。对方不会收到通知。你可以在成员列表中取消屏蔽。';

  @override
  String get familyReport => '举报';

  @override
  String get familyRemoveMember => '移出这面墙';

  @override
  String familyRemoveQuestion(String name) {
    return '移除$name？';
  }

  @override
  String get familyRemoveBody => '对方将无法访问这面墙。再次邀请即可让对方回来。';

  @override
  String get familyRemoveDeleteContent => '同时删除对方添加的回忆';

  @override
  String get familyDeleteTitle => '删除家庭墙';

  @override
  String get familyDeleteBody => '作为创建者，你不能离开这面墙，但可以为所有人删除它。';

  @override
  String get familyDeleteAction => '删除墙';

  @override
  String familyDeleteQuestion(String family) {
    return '删除$family？';
  }

  @override
  String get familyDeleteConfirmBody =>
      '这面墙上的所有回忆和照片都会为所有成员从我们的服务器上删除。此操作无法撤销。“我的墙”中的回忆不受影响。';

  @override
  String get familyDeleting => '正在删除…';

  @override
  String get familyLeaveTitle => '离开家庭墙';

  @override
  String get familyLeaveBody => '你将不再看到这面墙。你可以保留或删除自己添加的回忆。';

  @override
  String get familyLeaveAction => '离开';

  @override
  String familyLeaveQuestion(String family) {
    return '离开$family？';
  }

  @override
  String get familyLeaveConfirmBody => '要回来需要新的邀请。';

  @override
  String get familyLeaveDeleteMine => '同时删除我添加的回忆';

  @override
  String get familyLeaving => '正在离开…';

  @override
  String get familySignInTitle => '登录';

  @override
  String get familySignInHeadline => '家庭墙专用账户';

  @override
  String get familySignInWhy => '家庭墙是共享的，所以需要账户：成员能看到每条回忆是谁添加的，而且只有成员能打开这面墙。';

  @override
  String get familySignInMyWallStays => '“我的墙”无需账户。它在这台设备上保持私密，绝不会上传。';

  @override
  String get familySignInEncrypted => '家庭回忆和照片端到端加密。GK Coding 负责存储，但无法读取。';

  @override
  String get familySignInWhatWeGet =>
      '我们只从 Apple 或 Google 获取账户 ID，不会获取你的联系人或照片。';

  @override
  String get familySignInApple => '通过 Apple 登录';

  @override
  String get familySignInGoogle => '通过 Google 登录';

  @override
  String get familySignInFinePrint => '登录即表示你同意使用条款和隐私政策。你可以随时在 App 中删除账户。';

  @override
  String get familyAccountTitle => '账户';

  @override
  String get familySignedOutTitle => '未登录';

  @override
  String get familySignedOutBody => '登录后即可查看你的家庭墙。“我的墙”无需账户。';

  @override
  String get familySignedInTitle => '已登录';

  @override
  String get familySignedInBody => '你的账户只用于家庭墙。';

  @override
  String familyAccountId(String id) {
    return '账户 ID：$id';
  }

  @override
  String get familySignOut => '退出登录';

  @override
  String get familySignOutQuestion => '退出登录？';

  @override
  String get familySignOutBody =>
      '在你重新登录前，家庭墙及其密钥会从这台设备上移除。服务器上的内容不会被删除。“我的墙”不受影响。';

  @override
  String get familySigningOut => '正在退出…';

  @override
  String get familyDeleteAccountTitle => '删除账户';

  @override
  String get familyDeleteAccountBody => '从我们的服务器删除你的账户和家庭墙数据。“我的墙”留在这台设备上。';

  @override
  String get familyDeleteAccount => '删除账户';

  @override
  String get familyDeleteAccountQuestion => '删除你的账户？';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '你创建的 $count 面家庭墙会为所有成员删除，包括墙上的所有回忆和照片。',
      one: '你创建的家庭墙会为所有成员删除，包括墙上的所有回忆和照片。',
      zero: '你没有创建任何家庭墙。',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts => '你在其他家庭墙上添加的回忆和照片会被删除，你也会离开那些墙。';

  @override
  String get familyDeleteAccountKeys => '家庭墙密钥和缓存的照片会从这台设备上移除。此操作无法撤销。';

  @override
  String get familyDeleteAccountMyWall => '“我的墙”不受影响：其中的回忆留在这台设备上。';

  @override
  String get familyDeleteAccountSubscription =>
      '这不会取消 Premium 订阅；请在 App Store 或 Google Play 中管理。';

  @override
  String get familyDeleteAccountUnderstood => '我明白这会永久删除我的账户。';

  @override
  String get familyDeletingAccount => '正在删除你的账户…';

  @override
  String get familyAccountDeleted => '你的账户已删除。';

  @override
  String get familyTermsTitle => '家庭墙规则';

  @override
  String get familyTermsHeadline => '分享之前';

  @override
  String get familyTermsIntro => '家庭墙只属于你邀请的人。为了保持安全，所有人都需同意以下规则：';

  @override
  String get familyTermsZeroTolerance =>
      '对不当内容零容忍：禁止骚扰、仇恨、色情内容、暴力、自残、违法内容，以及未经同意发布他人的隐私信息。';

  @override
  String get familyTermsOwnContent => '只分享你有权分享的照片和故事。';

  @override
  String get familyTermsReport => '可以在墙上举报任何回忆或成员。GK Coding 会在 24 小时内处理举报。';

  @override
  String get familyTermsBlock => '屏蔽某位成员后，就不会再看到对方的回忆。';

  @override
  String get familyTermsOwner => '墙的创建者可以移除成员及其回忆。';

  @override
  String get familyTermsConsequences => '违反这些规则的内容会被删除，发布者的账户可能被暂停或删除。';

  @override
  String get familyTermsReadFull => '阅读完整条款';

  @override
  String get familyTermsAgree => '我同意使用条款和这些规则。';

  @override
  String get familyTermsAccept => '同意并继续';

  @override
  String familyTermsVersion(String version) {
    return '条款版本 $version';
  }

  @override
  String get familyWallEmptyTitle => '这面墙在等你';

  @override
  String get familyWallEmptyBody => '添加第一条回忆。墙上的每个人都能看到。';

  @override
  String get familyWallGoneBody => '你已无法访问这面家庭墙。它可能已被删除，或者你已被移除。';

  @override
  String get familyAddMemory => '添加回忆';

  @override
  String get familyRefresh => '刷新';

  @override
  String get familySyncing => '正在同步…';

  @override
  String get familyOffline => '离线：显示已保存的回忆';

  @override
  String get familySyncFailed => '同步失败';

  @override
  String get familyMemoryTitle => '回忆';

  @override
  String get familyMemoryGone => '这条回忆已不在墙上。';

  @override
  String get familyMemoryActions => '回忆操作';

  @override
  String familyAddedBy(String name) {
    return '由$name添加';
  }

  @override
  String get familyDeleteMemoryQuestion => '删除这条回忆？';

  @override
  String get familyDeleteMemoryBody => '它会连同照片一起，为所有人从墙上移除。';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return '作为创建者，你可以从这面墙移除回忆。$name的这条回忆会连同照片一起为所有人移除。';
  }

  @override
  String get familyDeletingMemory => '正在删除回忆…';

  @override
  String get familyNoPhotosYet => '还没有照片';

  @override
  String get familyPostNote => '墙上的每个人都会看到这条回忆。照片在上传前会在你的手机上压缩并加密。';

  @override
  String get familyPost => '发布';

  @override
  String get familyPostMemory => '发布到墙上';

  @override
  String get familyUploading => '正在加密并上传…';

  @override
  String get familyMemorySaved => '已保存到家庭墙。';

  @override
  String get familyConflictTitle => '已被他人修改';

  @override
  String get familyConflictBody => '你编辑时，这条回忆在另一台设备上被修改了。要加载最新版本并用你的更改覆盖它吗？';

  @override
  String get familyConflictRetry => '刷新并保存';

  @override
  String get familyQuotaTitle => '这面墙满了';

  @override
  String get familyReportMemoryTitle => '举报回忆';

  @override
  String get familyReportPhotoTitle => '举报照片';

  @override
  String get familyReportMemberTitle => '举报成员';

  @override
  String get familyReportIntro => '告诉我们哪里有问题。你的举报会发给 GK Coding，而不是被举报的人。';

  @override
  String get familyReportSpam => '垃圾信息或诈骗';

  @override
  String get familyReportHarassment => '骚扰或霸凌';

  @override
  String get familyReportHate => '仇恨言论';

  @override
  String get familyReportSexual => '色情内容或裸露';

  @override
  String get familyReportViolence => '暴力或威胁';

  @override
  String get familyReportSelfHarm => '自残或自杀';

  @override
  String get familyReportIllegal => '违法内容';

  @override
  String get familyReportPrivacy => '未经同意分享的隐私信息';

  @override
  String get familyReportOther => '其他';

  @override
  String get familyReportDetailsLabel => '详情（可选）';

  @override
  String get familyReportDetailsHint => '还有什么需要我们知道的？';

  @override
  String familyReportAlsoBlock(String name) {
    return '同时屏蔽$name';
  }

  @override
  String get familyReportSend => '发送举报';

  @override
  String get familyReportReviewNote =>
      'GK Coding 会在 24 小时内处理每一条举报，并移除违反规则的内容和成员。';

  @override
  String get familyReportSentTitle => '谢谢';

  @override
  String get familyReportSentBody =>
      '你的举报已发送。GK Coding 会在 24 小时内处理，并对违规内容采取行动。';

  @override
  String get familyErrorGeneric => '出了点问题。请再试一次。';

  @override
  String get familyErrorOffline => '你似乎处于离线状态。请检查网络后重试。';

  @override
  String get familyErrorSubscriptionRequired => '这需要墙的创建者拥有有效的 Premium 订阅。';

  @override
  String get familyErrorInviteExpired => '这个邀请已过期。请索取新的链接。';

  @override
  String get familyErrorInviteUsed => '这个邀请已被使用。每个链接只能用一次，请索取新的链接。';

  @override
  String get familyErrorInviteInvalid => '这不是有效的 LifeThreads 邀请链接。';

  @override
  String get familyErrorAlreadyMember => '你已经是这面家庭墙的成员了。';

  @override
  String get familyErrorFamilyFull => '这面家庭墙的成员已满。';

  @override
  String get familyErrorQuotaExceeded => '这面家庭墙没有存储空间了。删除一些回忆或照片来腾出空间。';

  @override
  String get familyErrorVersionConflict => '有人先修改了这条回忆。请刷新后重试。';

  @override
  String get familyErrorTermsRequired => '请先同意家庭墙规则。';

  @override
  String get familyErrorSignedOut => '你已退出登录。请重新登录。';

  @override
  String get familyErrorNotAllowed => '你无权在这面墙上执行此操作。';

  @override
  String get familyErrorNotFound => '找不到家庭墙';

  @override
  String get familyErrorOwnerCannotLeave => '创建者不能离开这面墙，但可以删除它。';

  @override
  String get familyPaste => '粘贴';

  @override
  String get familyErrorInviteRevoked => '这个邀请已被撤回。请索取新的链接。';

  @override
  String get familyErrorKeyMissing =>
      '这台设备没有这面家庭墙的密钥（例如重新安装后或在新手机上）。请向成员索取新的邀请链接：打开它即可恢复访问。';

  @override
  String get familyErrorSignInUnavailable => '这台设备暂时无法登录。';

  @override
  String get familyErrorNoPurchase =>
      '这个 App Store 或 Google Play 账户没有 Premium 购买记录。请先开通 Premium，再试一次。';

  @override
  String get familyErrorVerificationUnavailable => '暂时无法验证你的 Premium。请稍后再试。';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      '这笔 Premium 购买已关联到另一个家庭墙账户。请用那个账户登录，或联系 info@gkcoding.dev。';

  @override
  String get familyErrorNameTooLong => '名字太长了。请换个短一点的。';

  @override
  String get familyErrorContentNotAllowed => '内容中有家庭墙不允许使用的词语。请修改文字后重试。';

  @override
  String get familyErrorPhotoUnreadable => '有一张照片无法读取。请移除后重试。';

  @override
  String get familyErrorTooLarge => '文件太大，无法上传。试试少一些或小一些的照片。';

  @override
  String get familyReportEvidenceNote =>
      '为便于审核，GK Coding 会随举报收到这条回忆的标题和故事。照片绝不会被发送。';

  @override
  String get moveLeft => '向左移动';

  @override
  String get moveUp => '向上移动';

  @override
  String get moveDown => '向下移动';

  @override
  String get moveRight => '向右移动';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get removePerson => '移除人物';

  @override
  String get draftKept => '已存为草稿——下次还在这里。';

  @override
  String get draftResumeTitle => '从上次中断的地方继续？';

  @override
  String draftResumeBody(String date) {
    return '你在 $date 开始写的一条回忆还没保存。';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 张照片',
      one: '1 张照片',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => '继续草稿';

  @override
  String get draftStartNew => '重新开始';

  @override
  String get lookBackMenu => '回顾一个月';

  @override
  String lookBackTitle(String month) {
    return '你的$month';
  }

  @override
  String get lookBackWallCardTitle => '回忆里的这个月';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条回忆',
      one: '1 条回忆',
    );
    return '$month：$_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条回忆',
      one: '1 条回忆',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个人',
      one: '1 个人',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个地点',
      one: '1 个地点',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => '当时有谁';

  @override
  String get lookBackPlacesHeading => '去过哪里';

  @override
  String lookBackEmpty(String month) {
    return '$month还没有保存任何内容。';
  }

  @override
  String get lookBackEmptyHint => '日期在这个月的回忆会显示在这里。';

  @override
  String get lookBackPreviousMonth => '上个月';

  @override
  String get lookBackNextMonth => '下个月';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条回忆',
      one: '1 条回忆',
    );
    return '$month：有 $_temp0等你回顾。';
  }

  @override
  String get lookBackNotificationPrivate => '回忆里的这个月已准备好。';

  @override
  String get homeWidgetLocked => '打开 LifeThreads 查看你的回忆。';

  @override
  String get homeWidgetSettingsTitle => '主屏幕小组件';

  @override
  String get homeWidgetSettingsSubtitle => '显示哪些回忆';

  @override
  String get homeWidgetPreviewTitle => '今天的小组件';

  @override
  String get homeWidgetSourceTitle => '哪些回忆';

  @override
  String get homeWidgetAllWalls => '我所有的墙';

  @override
  String get homeWidgetOrderTitle => '优先显示';

  @override
  String get homeWidgetOnThisDayFirst => '优先显示那年今日';

  @override
  String get homeWidgetOnThisDayFirstBody => '往年这一天的回忆排在最前面。';

  @override
  String get homeWidgetPhotosFirst => '优先显示带照片的回忆';

  @override
  String get homeWidgetPhotosFirstBody => '只有都没有照片时才显示其他回忆。';

  @override
  String get homeWidgetHowToTitle => '添加到主屏幕';

  @override
  String get homeWidgetHowToIos =>
      '在主屏幕上长按 LifeThreads 图标，选择小组件尺寸。或者长按空白处，轻点 编辑 › 添加小组件，然后选择 LifeThreads。';

  @override
  String get homeWidgetHowToAndroid =>
      '在主屏幕上长按空白处，轻点“小组件”，把 LifeThreads 拖到你想放的位置。';

  @override
  String get homeWidgetPrivacyNote => '隐藏的回忆绝不会出现在小组件上。开启 App 锁时，小组件不显示任何回忆。';

  @override
  String get yearThreadAlmostThere => '快完成了';

  @override
  String get yearThreadMemoriesFrom => '回忆来自';

  @override
  String yearThreadAddMemoryTo(String year) {
    return '为 $year 年添加回忆';
  }

  @override
  String get onboardingHangTitle => '挂上你的回忆';

  @override
  String get onboardingHangText => '一张照片、一个地方、当时在场的人——你的墙随着你的生活一起成长。';

  @override
  String get onboardingConnectTitle => '用线把它们串起来';

  @override
  String get onboardingConnectText => '说说两个瞬间为什么属于彼此。这些线会让你看到故事如何相连。';

  @override
  String get onboardingComeBackTitle => '回忆会回来找你';

  @override
  String get onboardingComeBackText => '那年今日、月度回顾、年度短片——还有主屏幕上的小组件。';

  @override
  String get onboardingPrivateText => '无需账户。一切都留在你的手机上——想要的话还能用面容 ID 锁住。';

  @override
  String get onboardingNameStaysHere => '只用来跟你打招呼——它留在这台手机上。';

  @override
  String get tutorialLookBackTitle => '查找与回顾';

  @override
  String get tutorialLookBackText =>
      '按标题、地点、人物或年份搜索。更多 › 回顾一个月 显示某个月的回忆；更多 › 年度时光线 把一年做成短片。';

  @override
  String get tutorialStoryTitle => '制作故事';

  @override
  String get tutorialStoryText => '更多 › 制作故事：选择回忆、模板和音乐，然后以图片或视频分享。';

  @override
  String get tutorialWallsTitle => '多面墙与隐藏回忆';

  @override
  String get tutorialWallsText =>
      '更多 › 新建墙 可把旅行或人生阶段分开（Premium）。长按卡片 › 隐藏 让它不再显示；视图 › 隐藏的回忆 在面容 ID 验证后显示。';

  @override
  String get tutorialFamilyTitle => '与家人分享';

  @override
  String get tutorialFamilyText => '更多 › 家庭墙：全家共用一面墙，端到端加密。用链接邀请其他人。';

  @override
  String get tutorialWidgetTitle => '主屏幕上的回忆';

  @override
  String get tutorialWidgetText =>
      '添加 LifeThreads 小组件：每天一条不同的回忆。在 设置 › 主屏幕小组件 中选择显示哪些。';

  @override
  String photoNumber(int number) {
    return '照片 $number';
  }

  @override
  String get familyDisplayNameNotSaved => '无法保存你在这面墙上的名字。你可以在墙的设置中设置。';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '其中有 $count 条回忆。',
      one: '其中有 1 条回忆。',
    );
    return '$_temp0已在你墙上的回忆会保留，不会重复添加。';
  }

  @override
  String get importAction => '导入';

  @override
  String get familyRemovingMember => '正在移除并保护这面墙…';

  @override
  String get tourSkip => '跳过';

  @override
  String get tourNext => '下一步';

  @override
  String get tourDone => '完成';

  @override
  String get tourTapIt => '点这里';

  @override
  String get tourEnd => '结束导览';

  @override
  String get tourShowMeHow => '教我用';

  @override
  String get tourShowMeHowSubtitle => '用示例回忆快速导览';

  @override
  String get tourWelcomeTitle => '欢迎来到你的墙';

  @override
  String get tourWelcomeBody =>
      '让我们用示例回忆和示例图片一起逛逛 LifeThreads。跟着金色圆环走。最后由你决定是否保留它们。';

  @override
  String get tourCardTitle => '每张卡片都是一段回忆';

  @override
  String get tourCardBody => '照片、故事、地点和当时的感受。拖动卡片来整理，双指捏合来缩放。轻点这张卡片打开它。';

  @override
  String get tourConnectTitle => '连接回忆';

  @override
  String get tourConnectBody => '线把瞬间串在一起：一次旅行连着一个人，一个地方连着一种感受。轻点“连接”。';

  @override
  String get tourConnectionsTitle => '选出相关的回忆';

  @override
  String get tourConnectionsBody => '选择其他回忆，写下它们为什么属于彼此。然后线就会挂在你墙上的卡片之间。';

  @override
  String get tourAddTitle => '保存新的瞬间';

  @override
  String get tourAddBody => '轻点 + 往墙上添加内容。';

  @override
  String get tourAddMemoryTitle => '一条回忆';

  @override
  String get tourAddMemoryBody => '选择“回忆”。你也可以钉一张便签或一颗钉子来给卡片分组。';

  @override
  String get tourAddTextTitle => '几个字就够了';

  @override
  String get tourAddTextBody =>
      '我们为你放了一张示例图片和标题。平时你可以选自己的照片或现拍一张。日期和地点会从照片中读取。';

  @override
  String get tourSaveTitle => '挂到墙上';

  @override
  String get tourSaveBody => '轻点“立即保存”。感受、人物和连线可以以后再加。';

  @override
  String get tourCameraTitle => '快拍照片';

  @override
  String get tourCameraBody => '相机能立刻留住一个瞬间。文字以后再补。';

  @override
  String get tourViewTitle => '不同的视图';

  @override
  String get tourViewBody => '轻点“视图”。';

  @override
  String get tourViewModesTitle => '墙、时间线、地图';

  @override
  String get tourViewModesBody => '以墙、时间线或地图来看你的人生。在这里按分类筛选，并显示隐藏的回忆（需面容 ID）。';

  @override
  String get tourViewDoneTitle => '回到墙上';

  @override
  String get tourViewDoneBody => '轻点“完成”。';

  @override
  String get tourSearchTitle => '找到任何回忆';

  @override
  String get tourSearchBody => '在这里输入名字、地点、人物或年份。边输入边出结果。';

  @override
  String get tourMoreTitle => '其他功能';

  @override
  String get tourMoreBody => '故事、你的一年、回顾、更多墙和设置都在这个菜单里。轻点它。';

  @override
  String get tourStoryTitle => '制作故事';

  @override
  String get tourStoryBody => '轻点“制作故事”。';

  @override
  String get tourYearTitle => '年度时光线';

  @override
  String get tourYearBody => '把一年做成带音乐的短片：先按顺序呈现你的回忆，再呈现这一年的地点、人物和感受（Premium）。';

  @override
  String get tourLookBackTitle => '回顾一个月';

  @override
  String get tourLookBackBody => '每个月的回忆，以及其中的人和地方。“那年今日”会提醒你往年的回忆（Premium）。';

  @override
  String get tourWallsTitle => '更多墙';

  @override
  String get tourWallsBody => '为每个孩子、每次旅行或每个项目建一面墙（Premium）。轻点顶部的名字切换墙。';

  @override
  String get tourFamilyTitle => '家庭墙';

  @override
  String get tourFamilyBody =>
      '一面共享的墙，每个人都能添加自己的瞬间，端到端加密。只有创建者需要 Premium，家人免费加入。';

  @override
  String get tourSettingsTitle => '设置';

  @override
  String get tourSettingsBody => '免费备份一切，用面容 ID 锁住 App，设置主屏幕小组件和“那年今日”，还能选择语言。';

  @override
  String get tourFinishTitle => '就是这些！';

  @override
  String get tourFinishBody => '你已经会用了。现在把这面墙变成你自己的吧。';

  @override
  String get tourDemoPhotoTitle => '湖边的一天';

  @override
  String get tourRemoveDemoTitle => '开始你自己的墙？';

  @override
  String get tourRemoveDemoBody => '导览使用了示例回忆和示例图片。现在移除它们，用你自己的照片开始吗？';

  @override
  String get tourRemoveDemoRemove => '移除并开始';

  @override
  String get tourRemoveDemoKeep => '先保留';

  @override
  String get tourRemovedToast => '示例回忆已移除。你的墙准备好了。';

  @override
  String get storyTemplatePolaroid => '拍立得';

  @override
  String get storyTemplateAlbum => '相册';

  @override
  String get storyTemplateFilmstrip => '胶片';

  @override
  String get storyTemplateTimeline => '时光旅行';

  @override
  String get storyTemplatePostcard => '明信片';

  @override
  String get storyTemplateCinema => '电影';

  @override
  String get storyTemplateSingleHint => '每条回忆全屏显示，一条接一条';

  @override
  String get storyTemplateThreadHint => '墙上的卡片，由线串起';

  @override
  String get storyTemplateCollageHint => '所有照片排成网格';

  @override
  String get storyTemplateQuoteHint => '你的文字自己打出来';

  @override
  String get storyTemplatePolaroidHint => '拍立得照片一张张落成一叠';

  @override
  String get storyTemplateAlbumHint => '翻页，每页一张照片';

  @override
  String get storyTemplateFilmstripHint => '胶片滑过并放大';

  @override
  String get storyTemplateTimelineHint => '年份滚动到每条回忆';

  @override
  String get storyTemplatePostcardHint => '每张明信片翻面，露出故事';

  @override
  String get storyTemplateCinemaHint => '片头字幕、慢速缩放和片尾字幕';

  @override
  String get storyAnimationTitle => '动画';

  @override
  String get storyAnimationPageTitle => '选择动画';

  @override
  String get storyAnimationExamples => '用示例照片展示。你的故事会使用你的回忆。';

  @override
  String get storyMusicPageTitle => '音乐和时长';

  @override
  String get storyLengthTitle => '时长';

  @override
  String get storyLengthAuto => '自动';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds 秒';
  }

  @override
  String get storyMusicAll => '全部';

  @override
  String get storyMusicPlay => '播放';

  @override
  String get storyMusicPause => '暂停';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return '歌曲 $song ▸ 视频 $video';
  }

  @override
  String get storyMusicSyncHint => '白线显示歌曲的哪一秒与视频同步播放。标记是每条回忆开始的位置。';

  @override
  String get storyMusicLengthHint => '“自动”会根据回忆数量调整。短片越长，节奏越慢。';

  @override
  String get tourBack => '返回';

  @override
  String get tourStoryPickTitle => '选择回忆';

  @override
  String get tourStoryPickBody => '我们为你选了三条。你最多可以选六条。轻点“继续”。';

  @override
  String get tourStoryAnimationTitle => '选择动效';

  @override
  String get tourStoryAnimationBody => '从拍立得到电影，多种动画。轻点“动画”。';

  @override
  String get tourStoryStyleTitle => '试试拍立得';

  @override
  String get tourStoryStyleBody => '每个方块都会播放预览。轻点“拍立得”。';

  @override
  String get tourStoryMusicTitle => '添加音乐';

  @override
  String get tourStoryMusicBody => '选择一首歌和视频时长。轻点“音乐”。';

  @override
  String get tourStoryTrimTitle => '歌曲与视频同步';

  @override
  String get tourStoryTrimBody => '拖动金色框选择歌曲片段。白线随视频移动，让你看到每一刻播放的是第几秒。';

  @override
  String get tourStoryMusicDoneTitle => '回到你的故事';

  @override
  String get tourStoryMusicDoneBody => '轻点“完成”。';

  @override
  String get tourStoryShareTitle => '分享或保存';

  @override
  String get tourStoryShareBody =>
      '可直接发到 Instagram、WhatsApp 等。保存和分享是 Premium 功能。';

  @override
  String get tourMoreAgainTitle => '菜单里还有更多';

  @override
  String get tourMoreAgainBody => '再打开一次菜单。轻点它。';

  @override
  String get scannerStep1 => '在电视、电脑或平板上打开浏览器。';

  @override
  String scannerStep2(Object url) {
    return '访问 $url，那里会出现一个二维码。';
  }

  @override
  String get scannerStep3 => '把手机对准二维码，让它位于金色框内。你的墙会在那里显示一段时间，仅供观看。';

  @override
  String get scannerShareLink => '发送链接';

  @override
  String get scannerCopyLink => '复制链接';

  @override
  String get scannerLinkCopied => '链接已复制';

  @override
  String get storyTemplateScrapbook => '手账';

  @override
  String get storyTemplateMosaic => '马赛克';

  @override
  String get storyTemplateContactSheet => '印样';

  @override
  String get storyTemplateWallFlight => '飞越回忆墙';

  @override
  String get storyTemplateCarousel => '旋转木马';

  @override
  String get storyTemplateJourney => '旅程';

  @override
  String get storyTemplateScrapbookHint => '每张照片都用胶带贴在纸上';

  @override
  String get storyTemplateMosaicHint => '一张大照片，其他环绕四周';

  @override
  String get storyTemplateContactSheetHint => '每条回忆都是胶片上的一格';

  @override
  String get storyTemplateWallFlightHint => '沿着线从一张卡片飞向下一张';

  @override
  String get storyTemplateCarouselHint => '卡片旋转，每次一张转到前面';

  @override
  String get storyTemplateJourneyHint => '地图上的路线，每个地点一枚图钉';

  @override
  String get storyModePicture => '图片';

  @override
  String get storyModeVideo => '视频';

  @override
  String get storyModePictureHint => '一张包含所有回忆的图片，适合帖子和快拍。';

  @override
  String get storyModeVideoHint => '带动效和音乐的短片。';

  @override
  String get storyLayoutTitle => '布局';

  @override
  String get storyLayoutPageTitle => '选择布局';

  @override
  String get storyChoosePhoto => '选择故事要用的照片';

  @override
  String get wallTidyUp => '整理照片墙';

  @override
  String get wallTidyUpBody => '要把所有卡片按从最早到最新的顺序整齐地挂成几排吗？便签和钉子会留在原处。';

  @override
  String get wallTidyUpAction => '整理';

  @override
  String get wallTidiedToast => '你的照片墙已整理好。';

  @override
  String get storyFormatTitle => '尺寸';

  @override
  String get storyFormatStory => '快拍 9:16';

  @override
  String get storyFormatPost => '帖子 4:5';

  @override
  String get storyFormatSquare => '正方形 1:1';
}
