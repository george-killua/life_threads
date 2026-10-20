// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get send => '보내기';

  @override
  String get preparing => '준비 중...';

  @override
  String get settingsTitle => '설정';

  @override
  String get languageTitle => '언어';

  @override
  String get languageBody =>
      '앱 언어를 선택하세요. 시스템을 고르면 LifeThreads가 지원하는 경우 휴대폰 언어를 따라요.';

  @override
  String get systemLanguage => '시스템';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return '언어를 $language(으)로 바꿨어요.';
  }

  @override
  String get privacyTitle => '개인정보 보호';

  @override
  String get privacyBody =>
      'LifeThreads는 로컬 우선이에요. 계정도 공개 프로필도 없어요. 백업을 내보내거나, 암호화된 캡슐을 공유하거나, 다른 화면에 벽을 띄우지 않는 한 추억은 이 기기에만 남아요.';

  @override
  String get viewPrivacyPolicy => '개인정보 처리방침 보기';

  @override
  String get termsTitle => '이용약관';

  @override
  String get viewTerms => '약관 보기';

  @override
  String get betaFeedbackTitle => '베타 피드백';

  @override
  String get betaFeedbackBody =>
      '안전한 진단 정보와 함께 베타 피드백을 보내세요. 로그에는 앱 이벤트와 오류 종류만 담기며, 추억 내용, 사진 경로, 백업, 정확한 위치는 절대 포함되지 않아요.';

  @override
  String get closedBetaBadge => '비공개 베타';

  @override
  String get sendFeedback => '피드백 보내기';

  @override
  String get backupArchiveBody =>
      '추억, 사진, 메모, 실, 배치까지 모두 하나의 파일에 저장하세요. 컴퓨터나 내 클라우드에 보관하고, 비밀번호를 걸어 암호화할 수 있어요.';

  @override
  String get backupArchiveTitle => '백업';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => '잠금 해제';

  @override
  String get exportArchive => '아카이브 내보내기';

  @override
  String get importArchive => '아카이브 가져오기';

  @override
  String get importCapsule => '캡슐 가져오기';

  @override
  String get moveDevices => '기기 옮기기';

  @override
  String get themeTitle => '테마';

  @override
  String get themeBody =>
      '나만의 벽 분위기를 골라 보세요. 무료 버전에는 따뜻한 추억의 방이 있어요. Premium이면 모든 분위기를 쓸 수 있어요.';

  @override
  String get oneFreeBadge => '1개 무료';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'Premium 구독이 활성화되어 있어요.';

  @override
  String get premiumLockedBody => '연간 또는 월간: 추억 무제한, 여러 개의 벽, 스토리, 테마, 레이아웃.';

  @override
  String get activeBadge => '사용 중';

  @override
  String get openPremium => 'Premium 열기';

  @override
  String get appVersionTitle => '앱 버전';

  @override
  String get clearAllDataTitle => '모든 데이터 지우기';

  @override
  String get clearAllDataBody => '이 기기에서 모든 추억, 연결, 메모, 핀, 복사한 사진을 삭제해요.';

  @override
  String get clearData => '데이터 지우기';

  @override
  String exportFailed(Object error) {
    return '내보내기 실패: $error';
  }

  @override
  String importRejected(Object message) {
    return '가져오기 거부됨: $message';
  }

  @override
  String importFailed(Object error) {
    return '가져오기 실패: $error';
  }

  @override
  String deleteFailed(Object message) {
    return '삭제 실패: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return '캡슐 거부됨: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return '캡슐 가져오기 실패: $error';
  }

  @override
  String get clearAllDataQuestion => '모든 데이터를 지울까요?';

  @override
  String get clearAllDataQuestionBody =>
      '이 기기의 LifeThreads 로컬 데이터가 모두 영구 삭제돼요. 남기고 싶다면 먼저 백업을 내보내세요.';

  @override
  String get clearAll => '모두 지우기';

  @override
  String get allLocalDataCleared => '로컬 데이터를 모두 지웠어요.';

  @override
  String get feedbackGeneral => '일반 피드백';

  @override
  String get feedbackBug => '버그';

  @override
  String get feedbackCrash => '앱 멈춤';

  @override
  String get feedbackDesign => '디자인 문제';

  @override
  String get feedbackMissingFeature => '필요한 기능';

  @override
  String get feedbackPerformance => '성능';

  @override
  String get betaFeedbackIntro =>
      '무슨 일이 있었는지, 어떤 점이 이상했는지 적어 주세요. 개인 추억 내용 없이 안전한 진단 정보가 함께 첨부돼요.';

  @override
  String get feedbackType => '유형';

  @override
  String get feedbackLabel => '피드백';

  @override
  String get feedbackHint => '예: 추가 > 빠른 사진을 눌렀더니 화면이 멈췄어요.';

  @override
  String get betaFeedbackNotIncluded =>
      '포함되지 않는 것: 추억 제목, 스토리, 메모, 사진 경로, 백업 경로, 정확한 위치.';

  @override
  String get feedbackEmpty => '먼저 짧은 메시지를 적어 주세요.';

  @override
  String get feedbackCopied =>
      '메일 앱이 열리지 않았어요. info@gkcoding.dev로 보낼 피드백을 클립보드에 복사했어요.';

  @override
  String themeSelected(Object theme) {
    return '$theme 선택됨.';
  }

  @override
  String get onboardingHeadline => '살아 있는 벽을 만들어 보세요.';

  @override
  String get onboardingBody => '사진, 장소, 사람, 작은 메모가 감정의 실로 함께 이어지는 나만의 추억 방.';

  @override
  String get onboardingPrivacy =>
      '추억은 기본적으로 비공개예요. 계정도 공개 프로필도 없어요. 암호화된 클라우드 공유와 백업은 직접 선택할 때만 이뤄져요.';

  @override
  String get onboardingPrivacyShort =>
      '계정도 공개 프로필도 없어요. 따로 선택하지 않으면 추억은 이 기기에 남아요.';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingNameTitle => '뭐라고 부르면 될까요?';

  @override
  String get onboardingNameHint => '이름';

  @override
  String onboardingNiceToMeetYou(String name) {
    return '반가워요, $name님.';
  }

  @override
  String get onboardingGetStartedTitle => '시작 방법을 골라요';

  @override
  String get onboardingGetStartedBody =>
      '예시 벽을 미리 보거나, 빈 벽에서 시작해 나만의 추억을 걸어 보세요.';

  @override
  String get settingsNameTitle => '이름';

  @override
  String get settingsNameBody => '벽에 인사말로 표시돼요.';

  @override
  String get settingsNameHint => '이름';

  @override
  String get settingsNameSaved => '이름을 바꿨어요.';

  @override
  String get storyPrivacyTitle => '추억은 비공개로';

  @override
  String get storyConnectTitle => '순간을 이어요';

  @override
  String get storyConnectText => '추억, 메모, 장소를 이어 모든 장면에 이야기를 더하세요.';

  @override
  String get storyWallTitle => '살아 있는 벽 만들기';

  @override
  String get storyWallText => '사진 한 장으로 시작하면, 벽이 점점 자라 살아 있는 듯해져요.';

  @override
  String get previewDemoWall => '예시 벽 보기';

  @override
  String get startFresh => '새로 시작';

  @override
  String get optionalDemoPreview => '예시 미리보기(선택)';

  @override
  String get quickTutorial => '빠른 안내';

  @override
  String get tutorialIntro =>
      '먼저 기본(저장, 연결, 정리)부터, 그다음 벽으로 할 수 있는 모든 것을 알려 드려요.';

  @override
  String get gotIt => '알겠어요';

  @override
  String get howItWorks => '사용 방법';

  @override
  String get tutorialAddTitle => '추억 추가';

  @override
  String get tutorialAddText =>
      '+를 누르고 추억 또는 빠른 사진을 고른 뒤 제목, 날짜, 사람, 사진을 저장하세요. 저장 전에 나가도 임시 저장돼요.';

  @override
  String get tutorialConnectTitle => '추억 연결';

  @override
  String get tutorialConnectText =>
      '카드를 열고 연결 아이콘을 누른 뒤 관련된 추억을 고르고 짧은 이유를 적으세요.';

  @override
  String get tutorialArrangeTitle => '벽 정리';

  @override
  String get tutorialArrangeText =>
      '카드, 메모, 핀을 끌어서 배치하세요. 보기 › 정리로 날짜, 카테고리, 장소별로 정렬하고 완료를 누르면 적용돼요.';

  @override
  String get tutorialShowBoardTitle => '보드 띄우기';

  @override
  String get tutorialShowBoardText =>
      '다른 화면에서 lifethreads.gkcoding.dev/display를 열고, 더보기 › 벽 띄우기를 고른 뒤 코드를 스캔하면 임시 읽기 전용 보드가 표시돼요.';

  @override
  String get tutorialBackupTitle => '개인정보와 백업';

  @override
  String get tutorialBackupText =>
      '설정 › 개인정보 보호 › 앱 잠금을 켜면 Face ID로 LifeThreads를 열어요. 휴대폰을 바꾸기 전에 설정 › 백업 및 데이터에서 백업을 내보내세요.';

  @override
  String get scanDisplayQr => '화면 QR 스캔';

  @override
  String get scannerHintTitle => 'QR 코드는 어디에 있나요?';

  @override
  String get addMemoryBeforeDisplay => '벽을 띄우기 전에 추억을 추가하세요.';

  @override
  String get notLifeThreadsDisplayQr => 'LifeThreads 화면용 QR이 아니에요.';

  @override
  String get displayWallQuestion => '이 벽을 띄울까요?';

  @override
  String displayWallBody(int memoryCount) {
    return '스캔한 브라우저에 추억 $memoryCount개가 담긴 임시 읽기 전용 보드를 보내요. lifethreads.gkcoding.dev/display에서 열리고 자동으로 만료돼요.';
  }

  @override
  String get displayAction => '띄우기';

  @override
  String get soon => '곧';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return '$expires까지 추억 $memoryCount개로 벽을 띄우는 중이에요.';
  }

  @override
  String get preparingWallDisplay => '벽 화면 준비 중...';

  @override
  String get open => '열기';

  @override
  String get edit => '편집';

  @override
  String get save => '저장';

  @override
  String get done => '완료';

  @override
  String get back => '뒤로';

  @override
  String get continueAction => '계속';

  @override
  String get close => '닫기';

  @override
  String get add => '추가';

  @override
  String get saveReason => '이유 저장';

  @override
  String get chooseBackup => '백업 선택';

  @override
  String get chooseArchive => '아카이브 선택';

  @override
  String get chooseCapsule => '캡슐 선택';

  @override
  String get exportAction => '내보내기';

  @override
  String get addToWall => '벽에 추가';

  @override
  String get cinemaSkip => '건너뛰기';

  @override
  String get cinemaNotNow => '나중에';

  @override
  String get cinemaSharedChapter => '함께 나눈 추억의 장';

  @override
  String get cinemaConnectedThread => '이어진 실';

  @override
  String get cinemaInviteTitle => '이 추억을 내 벽에 추가할까요?';

  @override
  String get useSelected => '선택한 항목 사용';

  @override
  String photoGridItem(String date) {
    return '$date 사진';
  }

  @override
  String get noPhotosFound => '사진이 없어요.';

  @override
  String get manage => '관리';

  @override
  String get manageAccess => '접근 관리';

  @override
  String get saveNow => '지금 저장';

  @override
  String get hangOnWall => '벽에 걸기';

  @override
  String get placeHere => '여기에 놓기';

  @override
  String get openSettings => '설정 열기';

  @override
  String get viewPremium => 'Premium 보기';

  @override
  String get memoryNotFound => '추억을 찾을 수 없어요';

  @override
  String get memoryTypeMoment => '순간';

  @override
  String get memoryTypeTrip => '여행';

  @override
  String get memoryTypePerson => '사람';

  @override
  String get memoryTypePlace => '장소';

  @override
  String get memoryTypeNote => '메모';

  @override
  String get memoryTypeMomentDescription => '간직하고 싶은 작은 장면';

  @override
  String get memoryTypeTripDescription => '여행이나 나들이';

  @override
  String get memoryTypePersonDescription => '소중한 사람';

  @override
  String get memoryTypePlaceDescription => '의미 있는 장소';

  @override
  String get memoryTypeNoteDescription => '생각, 인용구, 메모';

  @override
  String get categoryPersonal => '개인';

  @override
  String get categoryFamily => '가족';

  @override
  String get categoryTravel => '여행';

  @override
  String get feelingWarm => '따뜻함';

  @override
  String get feelingNostalgic => '그리움';

  @override
  String get feelingProud => '뿌듯함';

  @override
  String get feelingCalm => '평온함';

  @override
  String get feelingImportant => '소중함';

  @override
  String get feelingWarmDescription => '부드럽고, 가깝고, 사랑이 가득한.';

  @override
  String get feelingNostalgicDescription => '그때로 돌아가게 하는 추억.';

  @override
  String get feelingProudDescription => '무언가를 증명한 순간.';

  @override
  String get feelingCalmDescription => '조용하고, 안전하고, 평화로운.';

  @override
  String get feelingImportantDescription => '이야기를 바꾼 추억.';

  @override
  String get addPeopleHint => '이 순간에 함께한 사람을 추가하세요. 연락처는 기기에 남아요.';

  @override
  String get addPerson => '사람 추가';

  @override
  String get editPerson => '사람 편집';

  @override
  String get chooseFromContacts => '연락처에서 선택';

  @override
  String get personNameLabel => '이름';

  @override
  String get personNameHint => '입력해서 저장된 사람 찾기';

  @override
  String get relationshipLabel => '관계';

  @override
  String get relationshipHint => '친구, 엄마, 파트너...';

  @override
  String get phoneOptionalLabel => '전화번호(선택)';

  @override
  String get emailOptionalLabel => '이메일(선택)';

  @override
  String get nameRelationshipRequired => '이름과 관계는 필수예요.';

  @override
  String get contactAccessDenied => '연락처 접근이 허용되지 않았어요.';

  @override
  String get couldNotOpenContacts => '연락처를 열 수 없어요.';

  @override
  String get chooseContact => '연락처 선택';

  @override
  String get searchContacts => '연락처 검색';

  @override
  String get noContactsFound => '연락처가 없어요.';

  @override
  String get unnamedContact => '이름 없는 연락처';

  @override
  String get contactRelationship => '연락처';

  @override
  String get couldNotLoadContacts => '연락처를 불러올 수 없어요.';

  @override
  String get saveMomentTitle => '순간 저장하기';

  @override
  String get todayEyebrow => '오늘';

  @override
  String get addMemoryStepTitle => '잃고 싶지 않은 일이 있었나요?';

  @override
  String get addMemoryStepSubtitle =>
      '한 줄 쓰고, 사진이 있으면 추가해서 저장하세요. 자세한 건 나중에 해도 돼요.';

  @override
  String get momentLabel => '순간';

  @override
  String get momentHint => '라라와 저녁, 첫 출시, 조용한 산책...';

  @override
  String get storyWorthLabel => '간직할 만한 이유는?';

  @override
  String get storyWorthHint => '몇 마디면 충분해요.';

  @override
  String get feelingEyebrow => '감정';

  @override
  String get feelingStepTitle => '다시 떠올릴 때 어떤 기분이면 좋을까요?';

  @override
  String get feelingStepSubtitle => '나중에 추억을 다시 찾기 쉬워져요.';

  @override
  String get contextEyebrow => '맥락';

  @override
  String get whenWasItTitle => '언제였나요?';

  @override
  String get photoGpsStepSubtitle =>
      '지도는 선택한 사진에 저장된 GPS를 사용해요. GPS가 없는 사진은 장소가 표시되지 않아요.';

  @override
  String get peopleThreadsEyebrow => '사람과 실';

  @override
  String get peopleThreadsTitle => '누구 또는 무엇과 이어지나요?';

  @override
  String get peopleThreadsSubtitle => '선택 정보를 더하면 하나하나의 순간이 삶의 실이 돼요.';

  @override
  String get connectExistingMemoryLabel => '기존 추억과 연결';

  @override
  String get noConnectionYet => '아직 연결 없음';

  @override
  String get connectionReasonLabel => '왜 이어져 있나요?';

  @override
  String get connectionReasonHint => '예: 같은 여행, 같은 사람, 전 / 후...';

  @override
  String get writeMomentOrPhotoFirst => '먼저 순간을 적거나 사진을 추가하세요.';

  @override
  String get todaysMoment => '오늘의 순간';

  @override
  String get savedFromTodaysPrompt => '오늘의 질문에서 저장했어요.';

  @override
  String get saveItBeforeItFades => '흐려지기 전에 저장하세요';

  @override
  String get chooseDate => '날짜 선택';

  @override
  String get dateLabel => '날짜';

  @override
  String get untitledMemory => '제목 없는 추억';

  @override
  String get organize => '정리';

  @override
  String get memoryShape => '추억 형태';

  @override
  String get wallCategory => '벽 카테고리';

  @override
  String get privatePhotos => '비공개 사진';

  @override
  String get pick => '선택';

  @override
  String get addMore => '더 추가';

  @override
  String get takePhoto => '사진 찍기';

  @override
  String get takePhotosNow => '지금 사진 찍기';

  @override
  String get takePhotosFabTooltip => '새 추억을 위한 사진 찍기';

  @override
  String get takeAnotherPhoto => '한 장 더 찍기';

  @override
  String get continueWithPhotos => '이 사진으로 계속';

  @override
  String get addPhotosToMemory => '추억에 추가';

  @override
  String get takeAnotherOrContinueBody =>
      '이 추억을 위해 계속 찍거나, 다음으로 넘어가 이야기를 더하세요.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '사진 $count장 찍음',
      one: '사진 1장 찍음',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads는 선택한 사진을 앱 전용 저장 공간에 복사하고, 날짜와 위치 정보가 있으면 함께 보관해요.';

  @override
  String get limitedPhotoAccessActive =>
      '사진 접근이 제한되어 있어요. 허용할 사진을 더 추가할 수 있어요.';

  @override
  String get selectPhotos => '사진 선택';

  @override
  String get photoAccessOff => '사진 접근이 꺼져 있어요';

  @override
  String get photoAccessOffBody => '추억을 고르려면 사진 접근을 켜세요. 사진은 이 기기에 남아요.';

  @override
  String get freeMemoryLimitReached => '무료 추억 한도에 도달했어요';

  @override
  String get freeMemoryLimitBody =>
      '무료 벽에는 추억 30개까지 담을 수 있어요. 업그레이드해서 벽을 계속 키워 보세요.';

  @override
  String get photoAccessNeeded => '먼저 사진 접근이 필요해요.';

  @override
  String get quickPhotoMemory => '빠른 사진 추억';

  @override
  String get quickPhotoDescription => '간직할 만한 사진 한 장. 이야기는 언제든 더할 수 있어요.';

  @override
  String get hangQuickPhoto => '빠른 사진 걸기';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return '사진 GPS 감지: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing => '사진에 GPS가 없어요. 이 추억은 지도에 표시되지 않아요.';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • 사진 $photoCount장';
  }

  @override
  String metadataDates(int count, int total) {
    return '날짜 $count/$total';
  }

  @override
  String metadataLocations(int count, int total) {
    return '위치 $count/$total';
  }

  @override
  String metadataSizes(int count, int total) {
    return '크기 $count/$total';
  }

  @override
  String newSelected(int count) {
    return '새로 $count개 선택';
  }

  @override
  String selectedCount(int count) {
    return '$count개 선택';
  }

  @override
  String get editMemoryTitle => '추억 편집';

  @override
  String get storyPanel => '이야기';

  @override
  String get memoryTitleLabel => '추억 제목';

  @override
  String get addTitleValidation => '제목을 입력하세요';

  @override
  String get storyDescriptionLabel => '이야기 / 설명';

  @override
  String get addStoryValidation => '짧은 이야기를 적어 주세요';

  @override
  String get shapeFeelingTitle => '형태와 감정';

  @override
  String get memoryTypeLabel => '추억 유형';

  @override
  String get feelingLabel => '감정';

  @override
  String get categoryLabel => '카테고리';

  @override
  String get timePhotoGpsTitle => '시간과 사진 GPS';

  @override
  String get memoryDateLabel => '추억 날짜';

  @override
  String get peopleTitle => '사람';

  @override
  String get galleryTitle => '갤러리';

  @override
  String get addPhotos => '사진 추가';

  @override
  String get saveMemory => '추억 저장';

  @override
  String get memorySaveFailed => '이 추억을 저장하지 못했어요. 다시 시도해 주세요.';

  @override
  String get passwordOnlySpaces => '비밀번호는 공백만으로 만들 수 없어요.';

  @override
  String get somethingWentWrong => '문제가 생겼어요. 다시 시도해 주세요.';

  @override
  String get mapUnavailable => '지금은 지도를 쓸 수 없어요.';

  @override
  String get coverPhoto => '대표 사진';

  @override
  String get galleryPhoto => '갤러리 사진';

  @override
  String get setAsCover => '대표 사진으로 설정';

  @override
  String get replacePhoto => '사진 바꾸기';

  @override
  String get removePhoto => '사진 빼기';

  @override
  String get choosePhoto => '사진 선택';

  @override
  String get threadReasonsTitle => '실의 이유';

  @override
  String get createMoreMemoriesBeforeLinking => '연결하기 전에 추억을 더 만들어 보세요.';

  @override
  String get connectionHeaderBody =>
      '이유와 함께 추억을 이어 보세요. 실은 두 순간이 왜 함께인지 말해 줘야 해요.';

  @override
  String get connectedMemory => '이어진 추억';

  @override
  String get whyConnectedTitle => '왜 이어져 있나요?';

  @override
  String get exportPremiumArchiveTitle => '백업 내보내기';

  @override
  String get importArchiveTitle => '아카이브 가져오기';

  @override
  String get archiveExportBody => '비밀번호를 넣으면 아카이브가 암호화돼요. 비워 두면 일반 로컬 zip이 돼요.';

  @override
  String get archiveImportBody =>
      '암호화된 아카이브라면 비밀번호를 입력하세요. 예전 백업이나 보호되지 않은 백업은 비워 두세요.';

  @override
  String get archivePasswordOptional => '아카이브 비밀번호(선택)';

  @override
  String get archivePasswordLabel => '아카이브 비밀번호';

  @override
  String get archivePasswordWarning => '비밀번호를 안전한 곳에 보관하세요. 잃어버리면 복구할 수 없어요.';

  @override
  String get sendArchiveTitle => 'LifeThreads 아카이브 보내기';

  @override
  String get sendArchiveSubject => 'LifeThreads 추억 아카이브';

  @override
  String get sendEncryptedArchiveText =>
      '암호화된 LifeThreads 아카이브예요. 다른 기기에서 가져올 때 정한 비밀번호를 사용하세요.';

  @override
  String get sendArchiveText =>
      'LifeThreads 아카이브예요. LifeThreads에서 가져오면 다른 기기에서 추억의 벽을 열 수 있어요.';

  @override
  String get archiveReadyToSend => '백업이 준비됐어요. 이 휴대폰이 아닌 안전한 곳에 보관하세요.';

  @override
  String get archiveNotSaved => '백업이 저장되지 않았어요. 준비되면 다시 내보내세요.';

  @override
  String get archiveSharingUnavailable => '이 기기에서는 공유할 수 없어요.';

  @override
  String archiveShareFailed(Object error) {
    return '아카이브는 저장했지만 공유하지 못했어요: $error';
  }

  @override
  String get archiveImportedTitle => '아카이브를 가져왔어요';

  @override
  String get memoriesLabel => '추억';

  @override
  String get photosLabel => '사진';

  @override
  String get wallNotesNailsLabel => '벽 메모 / 핀';

  @override
  String get connectionsLabel => '연결';

  @override
  String get archiveImportSummary => '지금의 벽은 그대로예요. 가져온 추억을 안전하게 추가했어요.';

  @override
  String get shareEncryptedCapsuleTitle => '암호화 캡슐 공유';

  @override
  String get openSharedCapsuleTitle => '공유 캡슐 열기';

  @override
  String get exportMemoryCapsuleTitle => '추억 캡슐 내보내기';

  @override
  String get importCapsuleDialogTitle => '캡슐 가져오기';

  @override
  String get secureSharePasswordBody =>
      '캡슐을 올리기 전에 비밀번호를 만드세요. 비밀번호는 받는 사람에게 따로 보내세요.';

  @override
  String get sharedCapsulePasswordBody => '이 공유 추억을 위해 받은 비밀번호를 입력하세요.';

  @override
  String get capsuleExportBody =>
      '보내기 전에 이 추억을 보호하려면 비밀번호를 넣으세요. 비워 두면 일반 캡슐이 돼요.';

  @override
  String get capsuleImportBody => '캡슐에 비밀번호가 있으면 입력하세요. 없으면 비워 두세요.';

  @override
  String get capsulePasswordLabel => '캡슐 비밀번호';

  @override
  String get sharedCapsulePasswordLabel => '공유 캡슐 비밀번호';

  @override
  String get capsulePasswordOptional => '캡슐 비밀번호(선택)';

  @override
  String get capsulePasswordWarning => 'LifeThreads는 이 비밀번호를 나중에 복구할 수 없어요.';

  @override
  String get passwordRequiredCloudSharing => '클라우드 공유에는 비밀번호가 필요해요.';

  @override
  String get createSecureShare => '안전한 공유 만들기';

  @override
  String get previewMemory => '추억 미리보기';

  @override
  String get sendCapsuleTitle => 'LifeThreads 추억 공유';

  @override
  String get sendCapsuleSubject => 'LifeThreads 추억 캡슐';

  @override
  String get sendEncryptedCapsuleText =>
      'LifeThreads에서 보호된 추억을 공유했어. 내가 보낸 비밀번호로 가져와 줘.';

  @override
  String get sendCapsuleText =>
      'LifeThreads에서 추억을 공유했어. LifeThreads에서 캡슐을 가져오면 네 벽에 추가할 수 있어.';

  @override
  String get capsuleReadyToSend => '캡슐을 보낼 준비가 됐어요.';

  @override
  String get capsuleSavedLater => '캡슐을 저장했어요. 나중에 공유할 수 있어요.';

  @override
  String get capsuleSharingUnavailable => '캡슐은 저장했지만 공유할 수 없어요.';

  @override
  String capsuleShareFailed(Object error) {
    return '캡슐은 저장했지만 공유하지 못했어요: $error';
  }

  @override
  String get importThisMemory => '이 추억을 가져올까요?';

  @override
  String get noStoryTextIncluded => '이야기 내용이 없어요.';

  @override
  String get placeLabel => '장소';

  @override
  String get notesLabel => '메모';

  @override
  String get capsulePasswordProtected => '이 캡슐은 비밀번호로 보호되어 있었어요.';

  @override
  String get openingSharedMemory => '공유 추억 여는 중...';

  @override
  String get lifeThreadsMemoryTitle => 'LifeThreads 추억';

  @override
  String shareMemoryText(Object url) {
    return 'LifeThreads에서 추억을 공유했어.\n\n$url';
  }

  @override
  String get shareLinkReady => '공유 링크가 준비됐어요.';

  @override
  String get shareLinkCreated => '공유 링크를 만들었어요.';

  @override
  String get shareLinkUnavailable => '공유 링크는 만들었지만 공유할 수 없어요.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label 링크는 자동으로 만료돼요. 지금 삭제할 수도 있어요.';
  }

  @override
  String cloudShareFailed(Object message) {
    return '클라우드 공유 실패: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => '공유 추억 링크를 삭제했어요.';

  @override
  String get creatingSecureMemoryLink => '안전한 링크 만드는 중...';

  @override
  String get shareMemoryCapsule => '추억 캡슐 공유';

  @override
  String get editStory => '이야기 편집';

  @override
  String get metaType => '유형';

  @override
  String get metaFeeling => '감정';

  @override
  String get metaCategory => '카테고리';

  @override
  String get metaDate => '날짜';

  @override
  String get storyEyebrow => '이야기';

  @override
  String get whyMemoryMatters => '이 추억이 소중한 이유';

  @override
  String get galleryEyebrow => '갤러리';

  @override
  String editSectionTooltip(String section) {
    return '$section 편집';
  }

  @override
  String get openInMaps => '지도에서 열기';

  @override
  String get memoryChangesSaved => '변경 사항을 저장했어요.';

  @override
  String get memoryDeletedToast => '추억을 삭제했어요.';

  @override
  String get noteDeletedToast => '메모를 삭제했어요.';

  @override
  String get nailDeletedToast => '핀을 뺐어요.';

  @override
  String get undo => '실행 취소';

  @override
  String photoPlaceDetected(String place) {
    return '사진 속 장소: $place';
  }

  @override
  String get settingsGroupYou => '나';

  @override
  String get settingsGroupReminders => '알림';

  @override
  String get settingsGroupMore => '더보기';

  @override
  String get backupDataTitle => '백업 및 데이터';

  @override
  String get backupDataSubtitle => '백업, 복원, 새 휴대폰으로 옮기기';

  @override
  String get aboutHelpTitle => '정보 및 도움말';

  @override
  String get aboutHelpSubtitle => '피드백, 개인정보, 음악, 버전';

  @override
  String get discardChangesTitle => '변경 사항을 버릴까요?';

  @override
  String get discardChangesBody => '여기서 바꾼 내용이 사라져요.';

  @override
  String get discardChanges => '버리기';

  @override
  String get keepEditing => '계속 편집';

  @override
  String get settingsGroupPrivacy => '개인정보 보호';

  @override
  String get appLockTitle => '앱 잠금';

  @override
  String get appLockSubtitle => 'Face ID나 암호로 LifeThreads 열기';

  @override
  String get appLockReason => '추억 잠금 해제';

  @override
  String get appLockLockedTitle => 'LifeThreads가 잠겨 있어요';

  @override
  String get appLockUnlock => '잠금 해제';

  @override
  String get appLockUnavailable => '먼저 이 휴대폰에 Face ID나 암호를 설정하세요.';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years년 전의 추억이 기다리고 있어요.',
      one: '1년 전의 추억이 기다리고 있어요.',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => '검색';

  @override
  String get searchHint => '제목, 장소, 사람, 연도';

  @override
  String get searchClear => '검색 지우기';

  @override
  String get searchNoResults => '맞는 추억이 없어요.';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '추억 $count개',
      one: '추억 1개',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => '추억 검색';

  @override
  String get premiumFeatureWalls => '벽 더 만들기';

  @override
  String get newWall => '새 벽';

  @override
  String get wallNameLabel => '벽 이름';

  @override
  String get newWallHint => '예: 2025 여행';

  @override
  String get createWall => '만들기';

  @override
  String get renameWall => '이름 바꾸기';

  @override
  String get deleteWall => '벽 삭제';

  @override
  String deleteWallQuestion(String name) {
    return '“$name”을(를) 삭제할까요?';
  }

  @override
  String get deleteWallBody => '이 벽의 추억은 내 벽으로 옮겨져요. 사라지는 건 없어요.';

  @override
  String get personalWallSubtitle => '내 벽, 이 기기에';

  @override
  String get wallOptions => '벽 옵션';

  @override
  String get moveToWall => '벽으로 옮기기…';

  @override
  String movedToWall(String name) {
    return '$name(으)로 옮겼어요.';
  }

  @override
  String get hideMemory => '숨기기';

  @override
  String get unhideMemory => '다시 보이기';

  @override
  String get memoryHiddenToast => '숨겼어요. 보기 › 숨긴 추억에서 찾을 수 있어요.';

  @override
  String get showHiddenMemories => '숨긴 추억';

  @override
  String get showHiddenReason => '숨긴 추억 보기';

  @override
  String get yearThreadFirstTitle => '나의 첫 번째 한 해의 실';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '추억 3개 중 $count개',
      one: '추억 3개 중 1개',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => '아니면 지금 스토리 만들기';

  @override
  String get moveMemoriesHere => '여기로 추억 옮기기';

  @override
  String get moveMemoriesTitle => '여기로 옮길 추억을 고르세요';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '추억 $count개 옮기기',
      one: '추억 1개 옮기기',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => '모두 보기';

  @override
  String get addAMemory => '추억 추가';

  @override
  String get mapAddPhotoMemory => '장소가 담긴 사진 추가';

  @override
  String get searchSuggestions => '내 추억으로 검색해 보세요';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years년 전 이번 주',
      one: '1년 전 이번 주',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => '누가 함께였나요?';

  @override
  String get premiumPlanYearly => '연간';

  @override
  String get premiumPlanMonthly => '월간';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/년';
  }

  @override
  String premiumSavePercent(int percent) {
    return '$percent% 절약';
  }

  @override
  String purchasesHandledYearly(String store) {
    return '결제는 $store 계정으로 청구돼요. 현재 기간이 끝나기 최소 24시간 전에 취소하지 않으면 구독은 매년 자동 갱신돼요. $store 계정 설정에서 관리하거나 취소할 수 있어요.';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '저장된 사진 $count장',
      one: '저장된 사진 1장',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => '사람';

  @override
  String get partOfMemory => '이 추억의 일부';

  @override
  String get notesEyebrow => '메모';

  @override
  String get attachedThoughts => '덧붙인 생각';

  @override
  String get stickyNote => '포스트잇';

  @override
  String get placeEyebrow => '장소';

  @override
  String get threadsEyebrow => '실';

  @override
  String get connectedMemories => '이어진 추억';

  @override
  String get noConnectedMemoriesYet =>
      '아직 이어진 추억이 없어요. 이 장면을 다른 순간과 이어 눈에 보이는 삶의 실을 시작해 보세요.';

  @override
  String get backToWall => '벽으로 돌아가기';

  @override
  String get addTextToWall => '벽에 글 추가';

  @override
  String get addTextAction => '글 추가';

  @override
  String get textNoteHint => '작은 추억, 인용구, 메모를 적어 보세요...';

  @override
  String get placeTextNote => '메모 놓기';

  @override
  String get placeRopeAnchor => '실 고정점 놓기';

  @override
  String get nailSubtitle => '핀으로 추억 사이에 실을 직접 이을 수 있어요.';

  @override
  String get clearDemoWallQuestion => '예시 벽을 지울까요?';

  @override
  String get clearDemoWallBody => '예시 추억을 지우고 빈 나만의 벽으로 시작해요.';

  @override
  String get importBackupQuestion => '백업을 가져올까요?';

  @override
  String get importBackupBody => 'LifeThreads 아카이브에서 추억을 복원하고 지금의 벽은 그대로 둬요.';

  @override
  String get deleteMemoryQuestion => '추억을 삭제할까요?';

  @override
  String get deleteMemoryBody => '추억과 벽에 있는 모든 연결이 삭제돼요.';

  @override
  String get editText => '글 편집';

  @override
  String get editTextTitle => '글 편집';

  @override
  String get connectRope => '실 연결';

  @override
  String get connectRopeSubtitle => '이 핀을 추억에 연결해요.';

  @override
  String get deleteNail => '핀 삭제';

  @override
  String get connectNailTitle => '핀을 추억에 연결';

  @override
  String get connectNailSubtitle => '선택한 추억이 이 고정점에 걸려요.';

  @override
  String get timelineTitle => '타임라인';

  @override
  String get timelineSubtitle => '시간순으로 정리한 추억.';

  @override
  String get noMemoriesFilter => '이 필터에 맞는 추억이 없어요';

  @override
  String get noMemoriesFilterBody => '필터를 바꾸거나 추억을 추가해 타임라인을 만들어 보세요.';

  @override
  String get memoryMapTitle => '추억 지도';

  @override
  String get memoryMapSubtitle => '장소별로 모은 추억.';

  @override
  String get noMappedMemories => '지도에 표시된 추억이 아직 없어요';

  @override
  String get displayWallTooltip => '벽 띄우기';

  @override
  String get tutorialTooltip => '안내';

  @override
  String get settingsTooltip => '설정';

  @override
  String get freeformLayout => '자유 배치';

  @override
  String get categoryLayout => '카테고리';

  @override
  String get locationLayout => '장소';

  @override
  String get saveToday => '오늘 저장';

  @override
  String get rememberThis => '기억해 두기';

  @override
  String get whatHappenedToday => '오늘 무슨 일이 있었나요?';

  @override
  String get tapToOpenDrag => '눌러서 열기 • 끌어서 옮기기';

  @override
  String get demoWallPreview => '예시 벽이에요. 새로 시작할 준비가 되면 지우세요.';

  @override
  String get clearDemo => '예시 지우기';

  @override
  String get chooseQuickPhoto => '빠른 사진 선택';

  @override
  String get wallView => '벽';

  @override
  String get timelineView => '타임라인';

  @override
  String get mapView => '지도';

  @override
  String get wallFilterAll => '전체';

  @override
  String get wallViewButton => '보기';

  @override
  String get wallShowAs => '표시 방식';

  @override
  String get wallArrange => '정리';

  @override
  String get wallShowOnly => '표시';

  @override
  String get layoutByDate => '날짜순';

  @override
  String get moreActionsTooltip => '더보기';

  @override
  String get addToWallTitle => '내 벽에 추가';

  @override
  String get expandableMemory => '추억';

  @override
  String get expandableMemorySubtitle => '안내에 따라 자세히';

  @override
  String get expandableQuickPhoto => '빠른 사진 추억';

  @override
  String get expandableQuickPhotoSubtitle => '사진 골라서 걸기';

  @override
  String get expandableTextNote => '글 메모';

  @override
  String get expandableTextNoteSubtitle => '벽에 남기는 작은 생각';

  @override
  String get expandableNail => '핀 / 실 고정점';

  @override
  String get expandableNailSubtitle => '직접 정하는 실 지점';

  @override
  String get startWithOneThing => '오늘의 한 가지로 시작해요';

  @override
  String get emptyWallBody => '흐려지기 전에 순간을 저장하세요. 한 문장이나 사진 한 장이면 충분해요.';

  @override
  String get usePhoto => '사진 사용';

  @override
  String get editMemoryTooltip => '추억 편집';

  @override
  String get connectMemoryTooltip => '추억 연결';

  @override
  String get archiveTransferTitle => '다른 기기에서 열기';

  @override
  String get archiveTransferHeroTitle => '추억을 안전하게 다른 기기로 옮기세요.';

  @override
  String get archiveTransferHeroBody =>
      '백업은 추억, 사진, 메모, 실, 벽 위치, 메타데이터가 담긴 zip 하나예요. 원하면 비밀번호로 잠글 수 있어요. 우리는 사본을 보관하지 않아요. 어디로 보낼지는 직접 정하세요.';

  @override
  String get archiveTransferStep1Title => '아카이브 내보내기';

  @override
  String get archiveTransferStep1Body =>
      '설정을 열고 아카이브 내보내기를 고른 뒤, 보호하려면 비밀번호를 넣으세요.';

  @override
  String get archiveTransferStep2Title => 'zip 옮기기';

  @override
  String get archiveTransferStep2Body => 'AirDrop, USB, 내 클라우드, 이메일로 옮기세요.';

  @override
  String get archiveTransferStep3Title => '안전하게 가져오기';

  @override
  String get archiveTransferStep3Body =>
      '다른 기기에 LifeThreads를 설치하고 아카이브 가져오기를 고른 뒤, 필요하면 비밀번호를 입력하세요. 기존 데이터를 지우지 않고 복원돼요.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled => '개발용 Premium 잠금 해제를 켰어요.';

  @override
  String get lifetimeActive => '구독 중';

  @override
  String get oneTimeLifetimeUnlock => '연간 또는 월간';

  @override
  String get premiumHeroActiveTitle => '추억의 벽에 한계가 없어요.';

  @override
  String get premiumHeroLockedTitle => '추억을 스토리로 만들어 보세요.';

  @override
  String get premiumHeroActiveBody =>
      'Premium 구독이 활성화되어 있어요. 음악이 있는 스토리, 한 해의 실, 가족 벽, 무제한 추억을 모두 쓸 수 있어요.';

  @override
  String premiumHeroLockedBody(int limit) {
    return '무료 버전에는 추억 $limit개와 전체 백업이 있어요. Premium은 음악이 있는 스토리와 영상, 한 해의 실, 가족 벽, 무제한 추억을 더해요.';
  }

  @override
  String get premiumMemories => 'Premium 추억';

  @override
  String get freeMemories => '무료 추억';

  @override
  String get unlimited => '무제한';

  @override
  String get benefitUnlimitedTitle => '무제한 추억';

  @override
  String get benefitUnlimitedBody => '추억 30개 제한이 없어요. 삶과 함께 벽을 계속 키워 가세요.';

  @override
  String get benefitThemesTitle => 'Premium 벽 테마';

  @override
  String get benefitThemesBody => '더 풍성한 분위기, 기간 한정 계절 테마, 시간대별 자동 테마를 열어요.';

  @override
  String get benefitLayoutsTitle => '고급 레이아웃';

  @override
  String get benefitLayoutsBody => '실, 타임라인, 고정점, 추억 묶음을 배치하는 더 많은 방법.';

  @override
  String get lifetimeUnlock => 'Premium 구독';

  @override
  String get premiumActiveOnDevice => '이 기기에서 Premium을 쓰고 있어요.';

  @override
  String onePurchaseBody(String store) {
    return '연간 또는 월간 구독으로 음악이 있는 스토리, 한 해의 실, 가족 벽, 무제한 추억을 누리세요. $store 설정에서 언제든 취소할 수 있어요.';
  }

  @override
  String get premiumActiveButton => 'Premium 사용 중';

  @override
  String get processing => '처리 중...';

  @override
  String get unlockPremium => 'Premium 구독하기';

  @override
  String get restorePurchase => '구독 복원';

  @override
  String get enableDebugMockUnlock => '테스트용 잠금 해제 켜기';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return '결제는 $store 계정으로 청구돼요. 현재 기간이 끝나기 최소 24시간 전에 취소하지 않으면 구독은 매달 자동 갱신돼요. $store 계정 설정에서 관리하거나 취소할 수 있어요.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      '스토어 업데이트에 실패했어요. 다시 시도해 주세요.';

  @override
  String get premiumMessageStoreUnavailable => '이 기기에서는 구매할 수 없어요.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium이 아직 스토어에 없어요. 나중에 다시 시도해 주세요.';

  @override
  String get premiumMessageLoadFailed =>
      '스토어에서 Premium을 불러오지 못했어요. 다시 시도해 주세요.';

  @override
  String get premiumMessageOpeningCheckout => '결제 화면 여는 중…';

  @override
  String get premiumMessageCheckoutFailed => '결제 화면을 열지 못했어요. 다시 시도해 주세요.';

  @override
  String get premiumMessageChecking => '구독 확인 중…';

  @override
  String get premiumMessageRestoreFailed => '복원에 실패했어요. 다시 시도해 주세요.';

  @override
  String get premiumMessageNoSubscriptionFound => '활성화된 Premium 구독을 찾지 못했어요.';

  @override
  String get premiumMessagePending => '구매가 대기 중이에요. 승인되면 Premium이 열려요.';

  @override
  String get premiumMessagePurchaseFailed => '구매가 완료되지 않았어요. 다시 시도해 주세요.';

  @override
  String get premiumMessageCanceled => '구매를 취소했어요.';

  @override
  String get premiumMessageRestored => 'Premium 구독을 복원했어요.';

  @override
  String get premiumMessageActive => 'Premium 구독이 활성화되어 있어요.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/월';
  }

  @override
  String get loadingPlayStoreProduct => '구독 불러오는 중…';

  @override
  String get playStoreUnavailable => '지금은 스토어를 쓸 수 없어요';

  @override
  String get productNotConfigured => '지금은 Premium을 쓸 수 없어요';

  @override
  String get purchasePending => '구매 대기 중';

  @override
  String get purchased => '구매 완료';

  @override
  String get restored => '복원 완료';

  @override
  String get premiumTryAgain => '다시 시도';

  @override
  String get purchaseFailed => '구매 실패';

  @override
  String get preparingCheckout => '결제 준비 중...';

  @override
  String get premiumLocalFirstTitle => 'Premium도 로컬 우선';

  @override
  String get premiumLocalFirstBody => '추억은 내 기기에 남고, 백업은 누구나 무료예요.';

  @override
  String get noMappedMemoriesBody => 'GPS 정보가 있는 사진을 추가하면 여기에 추억이 보여요.';

  @override
  String get peopleLabel => '사람';

  @override
  String get connect => '연결';

  @override
  String get themeWarmMemoryRoom => '따뜻한 추억의 방';

  @override
  String get themeWarmMemoryRoomDescription => '부드러운 어둠의 온기, 금빛 조명, 아늑한 방의 깊이.';

  @override
  String get themeMidnightArchive => '한밤의 기록실';

  @override
  String get themeMidnightArchiveDescription => '박물관처럼 고요한 깊은 파란색 기록실.';

  @override
  String get themeSoftPaperWall => '부드러운 종이 벽';

  @override
  String get themeSoftPaperWallDescription => '크림색 종이, 잉크 그림자, 차분한 스크랩북 느낌.';

  @override
  String get themeTravelCorkboard => '여행 코르크보드';

  @override
  String get themeTravelCorkboardDescription => '여행과 장소를 위한 지도 무늬의 따뜻한 코르크보드.';

  @override
  String get themeAutoTitle => '시간대별 자동';

  @override
  String get themeAutoDescription =>
      '낮에는 부드러운 종이 벽, 저녁에는 따뜻한 추억의 방, 밤에는 한밤의 기록실.';

  @override
  String get themeAutoSelected => '이제 벽이 시간대에 따라 바뀌어요.';

  @override
  String get themeSeasonalTitle => '계절 테마';

  @override
  String get themeSeasonalBody => '기간 한정 Premium 테마. 각 테마는 해당 계절에만 쓸 수 있어요.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString까지';
  }

  @override
  String get themeUseButton => '이 테마 사용';

  @override
  String get themeInUse => '사용 중';

  @override
  String get themeUnlockButton => 'Premium으로 열기';

  @override
  String get themeAutumnHarvest => '가을 수확';

  @override
  String get themeAutumnHarvestDescription => '호박색 빛, 크라프트지 카드, 떨어지는 낙엽의 반짝임.';

  @override
  String get themeWinterLights => '겨울 불빛';

  @override
  String get themeWinterLightsDescription => '차가운 파란 밤, 서리 내린 카드와 따뜻한 전구 장식.';

  @override
  String get themeSpringBlossom => '봄꽃';

  @override
  String get themeSpringBlossomDescription => '은은한 분홍빛이 감도는 연한 꽃 카드.';

  @override
  String get themeSummerEvening => '여름 저녁';

  @override
  String get themeSummerEveningDescription => '노을 색과 즉석 사진 카드.';

  @override
  String get themeYearRoundTitle => '언제나 사용 가능';

  @override
  String get themeComingTitle => '곧 공개';

  @override
  String get themeComingBody => '다가올 계절을 미리 보세요. 각 테마는 계절이 시작되는 첫날 열려요.';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString부터';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '모든 테마 보기, 이번 계절 $count개',
      one: '모든 테마 보기, 이번 계절 1개',
      zero: '모든 테마 보기',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => '바닷가';

  @override
  String get themeSeasideDescription => '청록빛 바다, 모래색 종이, 따뜻한 여름 햇살.';

  @override
  String get themeSnowyCabin => '눈 덮인 오두막';

  @override
  String get themeSnowyCabinDescription => '벽난로 옆 나무, 서리 내린 카드, 창밖의 포근한 눈.';

  @override
  String get themeSpringMeadow => '봄 들판';

  @override
  String get themeSpringMeadowDescription => '싱그러운 풀, 연한 카드, 노란 햇살.';

  @override
  String get themeMistyForest => '안개 숲';

  @override
  String get themeMistyForestDescription => '고요한 소나무, 아침 안개, 금빛 잎.';

  @override
  String get demoFirstDanceTitle => '우리의 첫 춤';

  @override
  String get demoFirstDanceStory =>
      '밴드가 우리 노래를 연주하자 헛간 전체가 조용해졌어. 네 발을 두 번이나 밟았는데 너는 내내 웃었고, 그 3분 동안은 우리 둘뿐이었어.';

  @override
  String get demoFirstDancePlace => '잘츠부르크';

  @override
  String get demoNewbornTitle => '어서 와, 리나';

  @override
  String get demoNewbornStory => '작은 손 전체가 손가락 하나를 꼭 쥐었다. 집에서 맞은 첫 고요한 아침.';

  @override
  String get demoNewbornPlace => '빈';

  @override
  String get demoBeachSunsetTitle => '바닷가의 여름';

  @override
  String get demoBeachSunsetStory => '해가 질 때까지 맨발로. 돌아오는 길, 리나는 네 어깨 위에서 잠들었지.';

  @override
  String get demoBeachSunsetPlace => '크로아티아 스플리트';

  @override
  String get demoGrandmaKitchenTitle => '할머니의 부엌';

  @override
  String get demoGrandmaKitchenStory =>
      '할머니의 살구 케이크, 드디어 레시피로 적었다. 온 사방이 밀가루투성이.';

  @override
  String get demoGrandmaKitchenPlace => '그라츠';

  @override
  String get demoGraduationTitle => '졸업식 날';

  @override
  String get demoGraduationStory => '학사모가 떨어지기도 전에 아빠는 울고 있었다.';

  @override
  String get demoGraduationPlace => '인스브루크';

  @override
  String get demoFirstHomeTitle => '첫 집 열쇠';

  @override
  String get demoFirstHomeStory => '아직 가구는 없고, 상자들과 바닥에서 먹는 피자, 그리고 수많은 계획뿐.';

  @override
  String get demoFirstHomePlace => '린츠';

  @override
  String get demoAlpineSummitTitle => '구름 위에서';

  @override
  String get demoAlpineSummitStory => '이걸 보려고 새벽 4시에 일어났다. 한 걸음 한 걸음 다 가치 있었다.';

  @override
  String get demoAlpineSummitPlace => '그로스글로크너';

  @override
  String get demoFirstBikeTitle => '첫 자전거, 손 놓고';

  @override
  String get demoFirstBikeStory => '세 번 페달, 한 번 휘청, 그리고 쌩. 얼마나 뿌듯해하던지.';

  @override
  String get demoFirstBikePlace => '빈 프라터';

  @override
  String get demoGardenDinnerTitle => '할아버지의 여든 번째 생신';

  @override
  String get demoGardenDinnerStory =>
      '긴 식탁에 4대가 모였고, 가장 재밌는 이야기는 역시 할아버지 몫이었다.';

  @override
  String get demoGardenDinnerPlace => '바하우';

  @override
  String get demoThreadFirstDanceToFirstHome => '우리의 이야기';

  @override
  String get demoThreadFirstHomeToNewborn => '그리고 리나가 왔다';

  @override
  String get demoThreadNewbornToBeachSunset => '리나의 첫 여름';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => '가족';

  @override
  String get demoThreadGraduationToFirstHome => '새로운 장';

  @override
  String get demoThreadAlpineSummitToFirstBike => '작은 모험들';

  @override
  String get demoThreadFirstBikeToGardenDinner => '할아버지가 지켜봤다';

  @override
  String get demoRelationGrandpa => '할아버지';

  @override
  String get demoRelationGrandma => '할머니';

  @override
  String get demoRelationDaughter => '딸';

  @override
  String get demoRelationWife => '아내';

  @override
  String get demoRelationBestMan => '들러리';

  @override
  String get demoRelationMother => '엄마';

  @override
  String savedToPath(Object label, Object path) {
    return '$label $path에 저장했어요';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '추억 $count개가 아직 백업되지 않았어요.',
      one: '추억 1개가 아직 백업되지 않았어요.',
    );
    return '$_temp0';
  }

  @override
  String get later => '나중에';

  @override
  String get backUp => '백업하기';

  @override
  String get onThisDayTitle => '그날의 오늘';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years년 전 오늘',
      one: '1년 전 오늘',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years년 전',
      one: '1년 전',
    );
    return '그날의 오늘 · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      '지난해의 추억이 돌아오는 날이면 LifeThreads가 조용히 알려 드려요.';

  @override
  String get onThisDayReminderSwitch => '매일 알림';

  @override
  String onThisDayReminderAt(String time) {
    return '$time에';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'LifeThreads 알림이 꺼져 있어요. 휴대폰 설정에서 허용해 주세요.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years년 전 오늘: $title',
      one: '1년 전 오늘: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개',
      one: '1개',
    );
    return '$title 외 이날의 추억 $_temp0';
  }

  @override
  String get onThisDayChannelDescription => '지난해 이날의 추억.';

  @override
  String get benefitOnThisDayBody => '지난해의 추억이 돌아오면 하나의 장으로 열어 볼 수 있는 알림.';

  @override
  String get premiumFeatureStoryImage => '스토리 이미지';

  @override
  String get premiumFeatureStoryVideo => '스토리 영상';

  @override
  String get premiumFeatureThreadOfTheYear => '한 해의 실';

  @override
  String get premiumFeatureFamilyWall => '가족 벽';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature은(는) Premium 기능이에요.';
  }

  @override
  String get yearThreadTitle => '한 해의 실';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '추억 $count개',
      one: '추억 1개',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '장소 $count곳',
      one: '장소 1곳',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count명',
      one: '1명',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개월',
      one: '1개월',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return '가장 많이 느낀 감정: $feeling';
  }

  @override
  String get yearThreadClosingLine => '한 해를, 한 가닥 실로.';

  @override
  String get yearThreadMyYear => '나의 한 해';

  @override
  String get yearThreadWallCardTitle => '추억으로 보는 한 해';

  @override
  String yearThreadWallCardBody(String year) {
    return '$year년을 짧은 영상으로 만들어 보세요.';
  }

  @override
  String get yearThreadDismiss => '나중에';

  @override
  String get yearThreadSettingsBody => '추억이 3개 이상인 해를 순서대로 실로 이어 짧은 영상으로 만들어요.';

  @override
  String get yearThreadOpen => '영상 만들기';

  @override
  String get yearThreadNoYears =>
      '한 해의 실을 만들려면 추억이 3개 이상인 해가 필요해요. 순간을 계속 저장하고 다시 와 주세요.';

  @override
  String get yearThreadYear => '연도';

  @override
  String get yearThreadLength => '길이';

  @override
  String yearThreadLengthFull(int seconds) {
    return '영상 · $seconds초';
  }

  @override
  String get yearThreadLengthStory => '스토리 · 20초';

  @override
  String get yearThreadMusic => '음악';

  @override
  String get yearThreadNoMusic => '음악 없음';

  @override
  String get yearThreadInFilm => '영상에 담긴 추억';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String get yearThreadAddMemory => '추억 추가';

  @override
  String get yearThreadSwap => '바꾸기';

  @override
  String get yearThreadRemove => '빼기';

  @override
  String get yearThreadUseSuggestions => '추천 사용';

  @override
  String yearThreadPickTitle(String year) {
    return '$year년의 추억 고르기';
  }

  @override
  String get yearThreadNoOthers => '이 해의 추억은 모두 영상에 들어 있어요.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '추억을 $count개 이상 고르세요',
      one: '추억을 1개 이상 고르세요',
    );
    return '$_temp0.';
  }

  @override
  String get yearThreadPreview => '미리보기';

  @override
  String get yearThreadExportVideo => '영상 내보내기';

  @override
  String get yearThreadExportImage => '이미지 내보내기';

  @override
  String get yearThreadShare => '공유';

  @override
  String get yearThreadSave => '사진에 저장';

  @override
  String get yearThreadMakingFilm => '영상 만드는 중…';

  @override
  String get yearThreadMakingImage => '이미지 만드는 중…';

  @override
  String get yearThreadFilmReady => '영상이 완성됐어요';

  @override
  String get yearThreadImageReady => '이미지가 완성됐어요';

  @override
  String get yearThreadSaved => '사진에 저장했어요.';

  @override
  String get yearThreadExportFailed => '잘 안 됐어요. 다시 시도해 주세요.';

  @override
  String get yearThreadPlay => '재생';

  @override
  String get yearThreadPause => '일시정지';

  @override
  String get createStory => '스토리 만들기';

  @override
  String get storyPickTitle => '추억 고르기';

  @override
  String storyPickBody(int max) {
    return '스토리 하나에 추억을 최대 $max개까지 골라요.';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$max개 중 $count개 선택';
  }

  @override
  String storyPickLimit(int max) {
    return '스토리에는 추억을 최대 $max개까지 담을 수 있어요.';
  }

  @override
  String get storyPickContinue => '계속';

  @override
  String get storyNoMemories => '먼저 추억을 저장한 다음 스토리로 만들어 보세요.';

  @override
  String get storyEditorTitle => '나의 스토리';

  @override
  String get storyChangeMemories => '추억 바꾸기';

  @override
  String get storyTemplateSingle => '추억 하나씩';

  @override
  String get storyTemplateThread => '실로 이은 벽';

  @override
  String get storyTemplateCollage => '콜라주';

  @override
  String get storyTemplateQuote => '글귀';

  @override
  String get storySwipeHint => '밀어서 다른 모습 보기';

  @override
  String get storyCaptionLabel => '캡션';

  @override
  String get storyCaptionHint => '이야기를 한 줄로';

  @override
  String get storyVideoSwitch => '영상';

  @override
  String get storyVideoBody => '움직임과 음악이 있는 스토리·릴스용 짧은 영상.';

  @override
  String get storyMusicTitle => '음악';

  @override
  String get storyMusicNone => '음악 없음';

  @override
  String get storyMusicNoneHint => '게시할 때 Instagram에서 음악을 넣을 수도 있어요.';

  @override
  String get storyMoodWarm => '따뜻한';

  @override
  String get storyMoodJoyful => '신나는';

  @override
  String get storyMoodCalm => '잔잔한';

  @override
  String get storyMoodNostalgic => '그리운';

  @override
  String get storyMoodEpic => '웅장한';

  @override
  String get storyMoodEmotional => '감성적인';

  @override
  String get storyMusicTrimHint => '금색 상자를 끌어서 노래의 구간을 고르세요';

  @override
  String get storySearchHint => '추억, 장소, 연도 검색';

  @override
  String storySearchEmpty(String query) {
    return '“$query”에 맞는 추억이 없어요.';
  }

  @override
  String get storyMemoriesInStory => '스토리에 담긴 추억';

  @override
  String get storyMemoriesReorderHint => '길게 눌러 끌면 순서를 바꿀 수 있어요';

  @override
  String get storyAddMemory => '추가';

  @override
  String get storyAddMemoryTitle => '추억 추가';

  @override
  String storyRemoveMemory(String title) {
    return '스토리에서 $title 빼기';
  }

  @override
  String get storyAllMemoriesAdded => '모든 추억이 이미 이 스토리에 있어요.';

  @override
  String get storyShare => '공유';

  @override
  String get storySaveToPhotos => '사진에 저장';

  @override
  String get storySaved => '사진에 저장했어요.';

  @override
  String get storySaveDenied => 'LifeThreads가 사진에 추가할 수 없어요. 휴대폰 설정에서 허용해 주세요.';

  @override
  String storyExportFailed(String error) {
    return '스토리를 만들지 못했어요: $error';
  }

  @override
  String get storyRenderingTitle => '영상 만드는 중';

  @override
  String get storyRenderingBody => 'LifeThreads를 열어 두세요. 몇 초면 돼요.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent%';
  }

  @override
  String get storyPreviewFree => '미리보기는 무료예요. 스토리 공유와 저장은 Premium 기능이에요.';

  @override
  String get benefitStoriesTitle => '스토리 만들기';

  @override
  String get benefitStoriesBody =>
      '추억을 Instagram, WhatsApp 등에 올릴 스토리 이미지와 음악이 있는 짧은 영상으로 만들어요.';

  @override
  String get musicCreditsTitle => '음악 저작권 정보';

  @override
  String get musicCreditsBody => '스토리 영상용으로 포함된 노래와 라이선스.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody => '한 해를 짧은 영상으로. 소중했던 순간을 순서대로, 음악과 함께.';

  @override
  String get benefitFamilyTitle => '가족 벽';

  @override
  String get benefitFamilyBody => '가족을 위한 종단간 암호화 공유 벽. 모두가 자신의 순간을 더해요.';

  @override
  String get myWall => '내 벽';

  @override
  String get myWallSubtitle => '비공개, 이 기기에';

  @override
  String get switchWall => '벽 바꾸기';

  @override
  String get familyWallsTitle => '가족 벽';

  @override
  String get familyWallsSettingsBody =>
      '가족이나 친구와 벽 하나를 함께 써요. 모두가 추억을 추가하고, 종단간 암호화돼요. 내 벽은 이 기기에서 비공개로 남아요.';

  @override
  String get familyWallsOpen => '가족 벽 열기';

  @override
  String get familyWallsManage => '가족 벽 관리';

  @override
  String get familyWallsHeadline => '벽 하나에 온 가족이';

  @override
  String get familyWallsIntro =>
      '가족 벽은 초대한 사람들과 함께 써요. 추억과 사진은 업로드 전에 휴대폰에서 암호화되고, 구성원만 열 수 있어요. 내 벽은 공유되지 않고 이 기기에 남아요.';

  @override
  String get familyUnavailableTitle => '아직 사용할 수 없어요';

  @override
  String get familyUnavailable => '이 버전의 LifeThreads에서는 아직 가족 벽을 쓸 수 없어요.';

  @override
  String get familySignInNeededTitle => '가족 벽을 쓰려면 로그인하세요';

  @override
  String get familySignInNeededBody =>
      '공유 벽에는 누가 무엇을 올렸는지 가족이 알 수 있도록 계정이 필요해요. 내 벽은 계정 없이 쓸 수 있어요.';

  @override
  String get familySignIn => '로그인';

  @override
  String get familyLoadFailed => '불러오지 못했어요';

  @override
  String get familyRetry => '다시 시도';

  @override
  String get familyNoWallsYet => '아직 가족 벽이 없어요. 새로 만들거나 초대 링크로 참여하세요.';

  @override
  String get familyStartTitle => '만들기 또는 참여';

  @override
  String get familyStartBody =>
      '가족 벽을 만들려면 Premium이 필요해요. 참여는 무료예요. 만든 사람의 Premium으로 온 가족이 써요.';

  @override
  String get familyCreateAction => '가족 벽 만들기';

  @override
  String get familyCreateTitle => '새 가족 벽';

  @override
  String get familyNameLabel => '벽 이름';

  @override
  String get familyNameHint => '예: 김씨네';

  @override
  String get familyMyNameLabel => '이 벽에서 쓸 내 이름';

  @override
  String get familyMyNameHelper => '구성원들이 내 추억에서 보게 돼요. 벽의 다른 모든 것처럼 암호화돼요.';

  @override
  String get familyMyNameSaved => '이름을 저장했어요.';

  @override
  String get familySetMyName => '내 이름';

  @override
  String get familyCheckingSubscription => 'Premium 확인 중…';

  @override
  String get familyCreating => '벽 만드는 중…';

  @override
  String get familyJoinWithLink => '링크로 참여';

  @override
  String get familyInviteLinkLabel => '초대 링크';

  @override
  String get familyJoinTitle => '이 가족 벽에 참여할까요?';

  @override
  String get familyJoinBody =>
      '구성원들은 내 이름과 내가 올린 추억을 보고, 나도 그들의 추억을 봐요. 언제든 나갈 수 있어요.';

  @override
  String get familyJoinAction => '참여';

  @override
  String get familyJoining => '참여하는 중…';

  @override
  String familyJoined(String family) {
    return '$family에 참여했어요.';
  }

  @override
  String get familyRoleOwner => '소유자';

  @override
  String get familyRoleMember => '구성원';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '구성원 $count명',
      one: '구성원 1명',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => '벽 설정';

  @override
  String familyStorageUsed(String used, String total) {
    return '$total 중 $used 사용';
  }

  @override
  String get familyRename => '이름 바꾸기';

  @override
  String get familyInviteTitle => '초대';

  @override
  String get familyInviteBody =>
      '믿을 수 있는 사람에게 링크를 보내세요. 링크는 한 번만 쓸 수 있고 7일 후 만료돼요.';

  @override
  String get familyInviteAction => '초대 링크 만들기';

  @override
  String get familyCreatingInvite => '초대 만드는 중…';

  @override
  String get familyInviteReady => '초대 링크가 준비됐어요';

  @override
  String get familyInviteValidity => '한 번만 쓸 수 있고 늦어도 7일 후 만료돼요.';

  @override
  String get familyInviteKeyWarning =>
      '링크에는 벽의 열쇠가 담겨 있어요. 링크를 연 사람은 누구나 참여해서 벽을 볼 수 있어요. 초대할 사람에게만 보내세요.';

  @override
  String get familyInviteShare => '링크 공유';

  @override
  String get familyInviteCopy => '링크 복사';

  @override
  String get familyInviteCopied => '링크를 복사했어요.';

  @override
  String get familyInviteShareFailed => '공유할 수 없어요. 대신 링크를 복사하세요.';

  @override
  String familyInviteSubject(String family) {
    return 'LifeThreads에서 $family에 참여하세요';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'LifeThreads의 우리 가족 벽 “$family”에 참여해 줘: $link';
  }

  @override
  String get familyMembersTitle => '구성원';

  @override
  String get familyMemberActions => '구성원 작업';

  @override
  String get familyYou => '나';

  @override
  String familyYouNamed(String name) {
    return '$name(나)';
  }

  @override
  String get familyAMember => '구성원';

  @override
  String get familyFormerMember => '이전 구성원';

  @override
  String get familyBlocked => '차단됨';

  @override
  String get familyBlock => '차단';

  @override
  String get familyUnblock => '차단 해제';

  @override
  String familyBlockAuthor(String name) {
    return '$name 차단';
  }

  @override
  String familyBlockQuestion(String name) {
    return '$name님을 차단할까요?';
  }

  @override
  String get familyBlockBody =>
      '어떤 가족 벽에서도 이 사람의 추억이 더 이상 보이지 않아요. 상대에게는 알리지 않아요. 구성원 목록에서 차단을 해제할 수 있어요.';

  @override
  String get familyReport => '신고';

  @override
  String get familyRemoveMember => '벽에서 내보내기';

  @override
  String familyRemoveQuestion(String name) {
    return '$name님을 내보낼까요?';
  }

  @override
  String get familyRemoveBody => '이 벽에 더 이상 접근할 수 없어요. 다시 초대하면 돌아올 수 있어요.';

  @override
  String get familyRemoveDeleteContent => '이 사람이 올린 추억도 삭제';

  @override
  String get familyDeleteTitle => '가족 벽 삭제';

  @override
  String get familyDeleteBody => '소유자는 벽을 나갈 수 없지만, 모두를 위해 삭제할 수 있어요.';

  @override
  String get familyDeleteAction => '벽 삭제';

  @override
  String familyDeleteQuestion(String family) {
    return '$family을(를) 삭제할까요?';
  }

  @override
  String get familyDeleteConfirmBody =>
      '이 벽의 모든 추억과 사진이 모든 구성원에게서 서버에서 삭제돼요. 되돌릴 수 없어요. 내 벽의 추억은 영향받지 않아요.';

  @override
  String get familyDeleting => '삭제 중…';

  @override
  String get familyLeaveTitle => '가족 벽 나가기';

  @override
  String get familyLeaveBody => '이 벽이 더 이상 보이지 않아요. 내가 올린 추억은 남기거나 삭제할 수 있어요.';

  @override
  String get familyLeaveAction => '나가기';

  @override
  String familyLeaveQuestion(String family) {
    return '$family에서 나갈까요?';
  }

  @override
  String get familyLeaveConfirmBody => '다시 들어오려면 새 초대가 필요해요.';

  @override
  String get familyLeaveDeleteMine => '내가 올린 추억도 삭제';

  @override
  String get familyLeaving => '나가는 중…';

  @override
  String get familySignInTitle => '로그인';

  @override
  String get familySignInHeadline => '가족 벽을 위한 계정';

  @override
  String get familySignInWhy =>
      '가족 벽은 함께 쓰는 공간이라 계정이 필요해요. 구성원은 누가 어떤 추억을 올렸는지 볼 수 있고, 구성원만 벽을 열 수 있어요.';

  @override
  String get familySignInMyWallStays =>
      '내 벽은 계정이 필요 없어요. 이 기기에서 비공개로 남고, 절대 업로드되지 않아요.';

  @override
  String get familySignInEncrypted =>
      '가족 추억과 사진은 종단간 암호화돼요. GK Coding은 보관만 할 뿐 읽을 수 없어요.';

  @override
  String get familySignInWhatWeGet =>
      'Apple이나 Google에서는 계정 ID만 사용해요. 연락처나 사진은 쓰지 않아요.';

  @override
  String get familySignInApple => 'Apple로 로그인';

  @override
  String get familySignInGoogle => 'Google로 로그인';

  @override
  String get familySignInFinePrint =>
      '로그인하면 이용약관과 개인정보 처리방침에 동의하게 돼요. 계정은 앱에서 언제든 삭제할 수 있어요.';

  @override
  String get familyAccountTitle => '계정';

  @override
  String get familySignedOutTitle => '로그인하지 않음';

  @override
  String get familySignedOutBody => '로그인하면 가족 벽을 볼 수 있어요. 내 벽은 계정 없이 쓸 수 있어요.';

  @override
  String get familySignedInTitle => '로그인됨';

  @override
  String get familySignedInBody => '계정은 가족 벽에만 사용돼요.';

  @override
  String familyAccountId(String id) {
    return '계정 ID: $id';
  }

  @override
  String get familySignOut => '로그아웃';

  @override
  String get familySignOutQuestion => '로그아웃할까요?';

  @override
  String get familySignOutBody =>
      '다시 로그인할 때까지 가족 벽과 열쇠가 이 기기에서 사라져요. 서버에서는 아무것도 삭제되지 않아요. 내 벽은 영향받지 않아요.';

  @override
  String get familySigningOut => '로그아웃 중…';

  @override
  String get familyDeleteAccountTitle => '계정 삭제';

  @override
  String get familyDeleteAccountBody =>
      '계정과 가족 벽 데이터를 서버에서 삭제해요. 내 벽은 이 기기에 남아요.';

  @override
  String get familyDeleteAccount => '계정 삭제';

  @override
  String get familyDeleteAccountQuestion => '계정을 삭제할까요?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '내가 소유한 가족 벽 $count개가 모든 추억과 사진과 함께 모든 구성원에게서 삭제돼요.',
      one: '내가 소유한 가족 벽이 모든 추억과 사진과 함께 모든 구성원에게서 삭제돼요.',
      zero: '소유한 가족 벽이 없어요.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      '다른 가족의 벽에 올린 추억과 사진이 삭제되고, 그 벽에서도 나가게 돼요.';

  @override
  String get familyDeleteAccountKeys =>
      '가족 벽 열쇠와 캐시된 사진이 이 기기에서 삭제돼요. 되돌릴 수 없어요.';

  @override
  String get familyDeleteAccountMyWall => '내 벽은 영향받지 않아요. 추억은 이 기기에 남아요.';

  @override
  String get familyDeleteAccountSubscription =>
      '이렇게 해도 Premium 구독은 취소되지 않아요. App Store나 Google Play에서 관리하세요.';

  @override
  String get familyDeleteAccountUnderstood => '계정이 영구적으로 삭제된다는 것을 이해했어요.';

  @override
  String get familyDeletingAccount => '계정 삭제 중…';

  @override
  String get familyAccountDeleted => '계정을 삭제했어요.';

  @override
  String get familyTermsTitle => '가족 벽 규칙';

  @override
  String get familyTermsHeadline => '공유하기 전에';

  @override
  String get familyTermsIntro =>
      '가족 벽은 초대한 사람들을 위한 공간이에요. 안전하게 지키기 위해 모두 다음 규칙에 동의해요:';

  @override
  String get familyTermsZeroTolerance =>
      '부적절한 콘텐츠는 절대 허용하지 않아요. 괴롭힘, 혐오, 성적인 콘텐츠, 폭력, 자해, 불법 콘텐츠, 동의 없는 타인의 개인정보는 안 돼요.';

  @override
  String get familyTermsOwnContent => '공유해도 되는 사진과 이야기만 공유하세요.';

  @override
  String get familyTermsReport =>
      '벽에서 어떤 추억이나 구성원이든 신고할 수 있어요. GK Coding은 24시간 안에 신고를 검토해요.';

  @override
  String get familyTermsBlock => '구성원을 차단하면 그 사람의 추억이 보이지 않아요.';

  @override
  String get familyTermsOwner => '벽 소유자는 구성원과 그들의 추억을 내보낼 수 있어요.';

  @override
  String get familyTermsConsequences =>
      '규칙을 어긴 콘텐츠는 삭제되고, 올린 계정은 정지되거나 삭제될 수 있어요.';

  @override
  String get familyTermsReadFull => '약관 전문 읽기';

  @override
  String get familyTermsAgree => '이용약관과 이 규칙에 동의해요.';

  @override
  String get familyTermsAccept => '동의하고 계속';

  @override
  String familyTermsVersion(String version) {
    return '약관 버전 $version';
  }

  @override
  String get familyWallEmptyTitle => '벽이 기다리고 있어요';

  @override
  String get familyWallEmptyBody => '첫 추억을 올려 보세요. 이 벽의 모두가 보게 돼요.';

  @override
  String get familyWallGoneBody =>
      '이 가족 벽은 더 이상 사용할 수 없어요. 삭제되었거나 내보내졌을 수 있어요.';

  @override
  String get familyAddMemory => '추억 추가';

  @override
  String get familyRefresh => '새로고침';

  @override
  String get familySyncing => '동기화 중…';

  @override
  String get familyOffline => '오프라인: 저장된 추억 표시 중';

  @override
  String get familySyncFailed => '동기화 실패';

  @override
  String get familyMemoryTitle => '추억';

  @override
  String get familyMemoryGone => '이 추억은 더 이상 벽에 없어요.';

  @override
  String get familyMemoryActions => '추억 작업';

  @override
  String familyAddedBy(String name) {
    return '$name님이 추가';
  }

  @override
  String get familyDeleteMemoryQuestion => '이 추억을 삭제할까요?';

  @override
  String get familyDeleteMemoryBody => '사진과 함께 모두의 벽에서 사라져요.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return '소유자는 이 벽에서 추억을 삭제할 수 있어요. $name님의 이 추억이 사진과 함께 모두에게서 삭제돼요.';
  }

  @override
  String get familyDeletingMemory => '추억 삭제 중…';

  @override
  String get familyNoPhotosYet => '아직 사진이 없어요';

  @override
  String get familyPostNote =>
      '이 벽의 모두가 이 추억을 보게 돼요. 사진은 업로드 전에 휴대폰에서 크기를 줄이고 암호화해요.';

  @override
  String get familyPost => '올리기';

  @override
  String get familyPostMemory => '벽에 올리기';

  @override
  String get familyUploading => '암호화하고 업로드하는 중…';

  @override
  String get familyMemorySaved => '가족 벽에 저장했어요.';

  @override
  String get familyConflictTitle => '다른 사람이 수정했어요';

  @override
  String get familyConflictBody =>
      '편집하는 동안 다른 기기에서 이 추억이 바뀌었어요. 최신 버전을 불러와서 내 변경 사항으로 덮어쓸까요?';

  @override
  String get familyConflictRetry => '새로고침 후 저장';

  @override
  String get familyQuotaTitle => '벽이 가득 찼어요';

  @override
  String get familyReportMemoryTitle => '추억 신고';

  @override
  String get familyReportPhotoTitle => '사진 신고';

  @override
  String get familyReportMemberTitle => '구성원 신고';

  @override
  String get familyReportIntro =>
      '무엇이 문제인지 알려 주세요. 신고는 신고 대상이 아닌 GK Coding에 전달돼요.';

  @override
  String get familyReportSpam => '스팸 또는 사기';

  @override
  String get familyReportHarassment => '괴롭힘 또는 따돌림';

  @override
  String get familyReportHate => '혐오 발언';

  @override
  String get familyReportSexual => '성적인 콘텐츠 또는 노출';

  @override
  String get familyReportViolence => '폭력 또는 위협';

  @override
  String get familyReportSelfHarm => '자해 또는 자살';

  @override
  String get familyReportIllegal => '불법 콘텐츠';

  @override
  String get familyReportPrivacy => '동의 없이 공유된 개인정보';

  @override
  String get familyReportOther => '기타';

  @override
  String get familyReportDetailsLabel => '자세한 내용(선택)';

  @override
  String get familyReportDetailsHint => '알려 주고 싶은 내용이 있나요?';

  @override
  String familyReportAlsoBlock(String name) {
    return '$name님도 차단';
  }

  @override
  String get familyReportSend => '신고 보내기';

  @override
  String get familyReportReviewNote =>
      'GK Coding은 모든 신고를 24시간 안에 검토하고, 규칙을 어긴 콘텐츠와 구성원을 삭제해요.';

  @override
  String get familyReportSentTitle => '감사해요';

  @override
  String get familyReportSentBody =>
      '신고를 보냈어요. GK Coding이 24시간 안에 검토하고 규칙을 어긴 콘텐츠에 조치해요.';

  @override
  String get familyErrorGeneric => '문제가 생겼어요. 다시 시도해 주세요.';

  @override
  String get familyErrorOffline => '오프라인 상태인 것 같아요. 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get familyErrorSubscriptionRequired => '벽 소유자의 활성 Premium 구독이 필요해요.';

  @override
  String get familyErrorInviteExpired => '초대가 만료됐어요. 새 링크를 요청하세요.';

  @override
  String get familyErrorInviteUsed =>
      '이미 사용된 초대예요. 링크는 한 번만 쓸 수 있어요. 새 링크를 요청하세요.';

  @override
  String get familyErrorInviteInvalid => '유효한 LifeThreads 초대 링크가 아니에요.';

  @override
  String get familyErrorAlreadyMember => '이미 이 가족 벽의 구성원이에요.';

  @override
  String get familyErrorFamilyFull => '이 가족 벽은 구성원 한도에 도달했어요.';

  @override
  String get familyErrorQuotaExceeded =>
      '이 가족 벽의 저장 공간이 없어요. 추억이나 사진을 삭제해 공간을 만들어 주세요.';

  @override
  String get familyErrorVersionConflict =>
      '다른 사람이 먼저 이 추억을 바꿨어요. 새로고침하고 다시 시도해 주세요.';

  @override
  String get familyErrorTermsRequired => '먼저 가족 벽 규칙에 동의해 주세요.';

  @override
  String get familyErrorSignedOut => '로그아웃됐어요. 다시 로그인해 주세요.';

  @override
  String get familyErrorNotAllowed => '이 벽에서는 이 작업을 할 수 없어요.';

  @override
  String get familyErrorNotFound => '가족 벽을 찾을 수 없어요';

  @override
  String get familyErrorOwnerCannotLeave => '소유자는 벽을 나갈 수 없지만 삭제할 수는 있어요.';

  @override
  String get familyPaste => '붙여넣기';

  @override
  String get familyErrorInviteRevoked => '이 초대는 취소됐어요. 새 링크를 요청하세요.';

  @override
  String get familyErrorKeyMissing =>
      '이 기기에 이 가족 벽의 열쇠가 없어요(예: 재설치 후 또는 새 휴대폰). 구성원에게 새 초대 링크를 요청하세요. 링크를 열면 다시 접근할 수 있어요.';

  @override
  String get familyErrorSignInUnavailable => '지금 이 기기에서는 로그인할 수 없어요.';

  @override
  String get familyErrorNoPurchase =>
      '이 App Store 또는 Google Play 계정에서 Premium 구매를 찾지 못했어요. 먼저 Premium을 구매한 뒤 다시 시도해 주세요.';

  @override
  String get familyErrorVerificationUnavailable =>
      '지금은 Premium을 확인할 수 없어요. 나중에 다시 시도해 주세요.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      '이 Premium 구매는 이미 다른 가족 벽 계정에 연결되어 있어요. 그 계정으로 로그인하거나 info@gkcoding.dev로 문의하세요.';

  @override
  String get familyErrorNameTooLong => '이름이 너무 길어요. 더 짧게 써 주세요.';

  @override
  String get familyErrorContentNotAllowed =>
      '가족 벽에서 허용되지 않는 단어가 있어요. 글을 고친 뒤 다시 시도해 주세요.';

  @override
  String get familyErrorPhotoUnreadable =>
      '사진 한 장을 읽을 수 없어요. 그 사진을 빼고 다시 시도해 주세요.';

  @override
  String get familyErrorTooLarge =>
      '업로드하기에 너무 커요. 사진 수를 줄이거나 더 작은 사진으로 시도해 주세요.';

  @override
  String get familyReportEvidenceNote =>
      '검토를 위해 GK Coding은 신고와 함께 이 추억의 제목과 이야기를 받아요. 사진은 절대 전송되지 않아요.';

  @override
  String get moveLeft => '왼쪽으로 이동';

  @override
  String get moveUp => '위로 이동';

  @override
  String get moveDown => '아래로 이동';

  @override
  String get moveRight => '오른쪽으로 이동';

  @override
  String get showPassword => '비밀번호 보기';

  @override
  String get hidePassword => '비밀번호 숨기기';

  @override
  String get removePerson => '사람 빼기';

  @override
  String get draftKept => '임시 저장했어요. 다음에 여기서 이어 갈 수 있어요.';

  @override
  String get draftResumeTitle => '하던 곳부터 이어 갈까요?';

  @override
  String draftResumeBody(String date) {
    return '$date에 시작한 추억을 아직 저장하지 않았어요.';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '사진 $count장',
      one: '사진 1장',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => '임시 저장 이어 쓰기';

  @override
  String get draftStartNew => '새로 시작';

  @override
  String get lookBackMenu => '한 달 돌아보기';

  @override
  String lookBackTitle(String month) {
    return '나의 $month';
  }

  @override
  String get lookBackWallCardTitle => '추억으로 보는 한 달';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '추억 $count개',
      one: '추억 1개',
    );
    return '$month: $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '추억 $count개',
      one: '추억 1개',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count명',
      one: '1명',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '장소 $count곳',
      one: '장소 1곳',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => '함께한 사람';

  @override
  String get lookBackPlacesHeading => '다녀온 곳';

  @override
  String lookBackEmpty(String month) {
    return '$month에 저장한 추억이 아직 없어요.';
  }

  @override
  String get lookBackEmptyHint => '이달 날짜의 추억이 여기에 표시돼요.';

  @override
  String get lookBackPreviousMonth => '이전 달';

  @override
  String get lookBackNextMonth => '다음 달';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개',
      one: '1개',
    );
    return '$month: 돌아볼 추억 $_temp0.';
  }

  @override
  String get lookBackNotificationPrivate => '추억으로 보는 한 달이 준비됐어요.';

  @override
  String get homeWidgetLocked => 'LifeThreads를 열어 추억을 보세요.';

  @override
  String get homeWidgetSettingsTitle => '홈 화면 위젯';

  @override
  String get homeWidgetSettingsSubtitle => '표시할 추억';

  @override
  String get homeWidgetPreviewTitle => '오늘의 위젯';

  @override
  String get homeWidgetSourceTitle => '어떤 추억';

  @override
  String get homeWidgetAllWalls => '내 모든 벽';

  @override
  String get homeWidgetOrderTitle => '먼저 보여 줄 것';

  @override
  String get homeWidgetOnThisDayFirst => '그날의 오늘 먼저';

  @override
  String get homeWidgetOnThisDayFirstBody => '지난해 이날의 추억을 먼저 보여 줘요.';

  @override
  String get homeWidgetPhotosFirst => '사진 있는 추억 먼저';

  @override
  String get homeWidgetPhotosFirstBody => '사진 있는 추억이 없을 때만 다른 추억을 보여 줘요.';

  @override
  String get homeWidgetHowToTitle => '홈 화면에 추가하기';

  @override
  String get homeWidgetHowToIos =>
      '홈 화면에서 LifeThreads 아이콘을 길게 누르고 위젯 크기를 고르세요. 또는 빈 곳을 길게 누르고 편집 › 위젯 추가를 눌러 LifeThreads를 고르세요.';

  @override
  String get homeWidgetHowToAndroid =>
      '홈 화면의 빈 곳을 길게 누르고 위젯을 누른 뒤 LifeThreads를 원하는 곳으로 끌어 놓으세요.';

  @override
  String get homeWidgetPrivacyNote =>
      '숨긴 추억은 위젯에 절대 나오지 않아요. 앱 잠금이 켜져 있으면 추억을 보여 주지 않아요.';

  @override
  String get yearThreadAlmostThere => '거의 다 왔어요';

  @override
  String get yearThreadMemoriesFrom => '이 해의 추억';

  @override
  String yearThreadAddMemoryTo(String year) {
    return '$year년에 추억 추가';
  }

  @override
  String get onboardingHangTitle => '추억을 걸어 보세요';

  @override
  String get onboardingHangText => '사진 한 장, 장소 하나, 그곳에 있던 사람들. 벽은 삶과 함께 자라요.';

  @override
  String get onboardingConnectTitle => '실로 이어 보세요';

  @override
  String get onboardingConnectText =>
      '두 순간이 왜 함께인지 적어 보세요. 실이 이야기가 어떻게 이어지는지 보여 줘요.';

  @override
  String get onboardingComeBackTitle => '추억이 다시 찾아와요';

  @override
  String get onboardingComeBackText =>
      '그날의 오늘, 한 달 돌아보기, 영상으로 보는 한 해, 그리고 홈 화면 위젯까지.';

  @override
  String get onboardingPrivateText => '계정 없이. 모든 게 휴대폰에 남아요. 원하면 Face ID로.';

  @override
  String get onboardingNameStaysHere => '인사할 때만 쓰고, 이 휴대폰에 남아요.';

  @override
  String get tutorialLookBackTitle => '찾고 돌아보기';

  @override
  String get tutorialLookBackText =>
      '제목, 장소, 사람, 연도로 검색하세요. 더보기 › 한 달 돌아보기로 한 달의 추억을, 더보기 › 한 해의 실로 한 해를 영상으로 볼 수 있어요.';

  @override
  String get tutorialStoryTitle => '스토리 만들기';

  @override
  String get tutorialStoryText =>
      '더보기 › 스토리 만들기: 추억, 템플릿, 음악을 고르고 이미지나 영상으로 공유하세요.';

  @override
  String get tutorialWallsTitle => '벽과 숨긴 추억';

  @override
  String get tutorialWallsText =>
      '더보기 › 새 벽으로 여행이나 시기를 나눠요(Premium). 카드를 길게 누르고 › 숨기기로 감추고, 보기 › 숨긴 추억에서 Face ID 후에 볼 수 있어요.';

  @override
  String get tutorialFamilyTitle => '가족과 함께';

  @override
  String get tutorialFamilyText =>
      '더보기 › 가족 벽: 온 가족을 위한 종단간 암호화 벽 하나. 링크로 다른 사람을 초대하세요.';

  @override
  String get tutorialWidgetTitle => '홈 화면에 추억 하나';

  @override
  String get tutorialWidgetText =>
      'LifeThreads 위젯을 추가하면 매일 다른 추억이 보여요. 설정 › 홈 화면 위젯에서 어떤 추억을 보여 줄지 골라요.';

  @override
  String photoNumber(int number) {
    return '사진 $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      '이 벽에서 쓸 이름을 저장하지 못했어요. 벽 설정에서 정할 수 있어요.';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '추억 $count개가 들어 있어요.',
      one: '추억 1개가 들어 있어요.',
    );
    return '$_temp0 이미 벽에 있는 추억은 그대로 두고 중복으로 추가하지 않아요.';
  }

  @override
  String get importAction => '가져오기';

  @override
  String get familyRemovingMember => '내보내고 벽을 보호하는 중…';

  @override
  String get tourSkip => '건너뛰기';

  @override
  String get tourNext => '다음';

  @override
  String get tourDone => '완료';

  @override
  String get tourTapIt => '눌러 보세요';

  @override
  String get tourEnd => '투어 끝내기';

  @override
  String get tourShowMeHow => '사용법 보기';

  @override
  String get tourShowMeHowSubtitle => '예시 추억으로 보는 짧은 투어';

  @override
  String get tourWelcomeTitle => '내 벽에 오신 걸 환영해요';

  @override
  String get tourWelcomeBody =>
      '예시 추억과 사진으로 LifeThreads를 함께 둘러봐요. 금색 고리를 따라오세요. 마지막에 남길지 정할 수 있어요.';

  @override
  String get tourCardTitle => '카드 한 장이 추억 하나';

  @override
  String get tourCardBody =>
      '사진, 이야기, 장소, 그때의 감정. 카드를 끌어 배치하고, 두 손가락으로 확대하세요. 이 카드를 눌러 열어 보세요.';

  @override
  String get tourConnectTitle => '추억 잇기';

  @override
  String get tourConnectBody => '실은 순간을 이어 줘요. 여행과 사람, 장소와 감정을. 연결을 눌러 보세요.';

  @override
  String get tourConnectionsTitle => '어울리는 것 고르기';

  @override
  String get tourConnectionsBody =>
      '다른 추억을 고르고 왜 함께인지 적어 보세요. 그러면 벽의 카드 사이에 실이 걸려요.';

  @override
  String get tourAddTitle => '새 순간 저장하기';

  @override
  String get tourAddBody => '+를 눌러 벽에 무언가를 추가하세요.';

  @override
  String get tourAddMemoryTitle => '추억';

  @override
  String get tourAddMemoryBody => '추억을 고르세요. 메모나 핀을 꽂아 카드를 묶을 수도 있어요.';

  @override
  String get tourAddTextTitle => '몇 마디면 충분해요';

  @override
  String get tourAddTextBody =>
      '예시 사진과 제목을 넣어 두었어요. 평소엔 직접 사진을 고르거나 찍어요. 날짜와 장소는 사진에서 가져와요.';

  @override
  String get tourSaveTitle => '벽에 걸기';

  @override
  String get tourSaveBody => '지금 저장을 누르세요. 감정, 사람, 실은 나중에 더해도 돼요.';

  @override
  String get tourCameraTitle => '빠른 사진';

  @override
  String get tourCameraBody => '카메라로 순간을 바로 저장해요. 글은 나중에 더하세요.';

  @override
  String get tourViewTitle => '다양한 보기';

  @override
  String get tourViewBody => '보기를 누르세요.';

  @override
  String get tourViewModesTitle => '벽, 타임라인, 지도';

  @override
  String get tourViewModesBody =>
      '삶을 벽, 타임라인, 지도로 볼 수 있어요. 여기서 카테고리로 거르고 숨긴 추억도 볼 수 있어요(Face ID).';

  @override
  String get tourViewDoneTitle => '벽으로 돌아가기';

  @override
  String get tourViewDoneBody => '완료를 누르세요.';

  @override
  String get tourSearchTitle => '어떤 추억이든 찾기';

  @override
  String get tourSearchBody => '여기에 이름, 장소, 사람, 연도를 입력하세요. 입력하는 대로 결과가 나와요.';

  @override
  String get tourMoreTitle => '그 밖의 모든 것';

  @override
  String get tourMoreBody => '스토리, 나의 한 해, 돌아보기, 다른 벽, 설정이 이 메뉴에 있어요. 눌러 보세요.';

  @override
  String get tourStoryTitle => '스토리 만들기';

  @override
  String get tourStoryBody => '스토리 만들기를 누르세요.';

  @override
  String get tourYearTitle => '한 해의 실';

  @override
  String get tourYearBody =>
      '음악이 있는 짧은 영상으로 보는 한 해. 추억을 순서대로, 그다음 그해의 장소, 사람, 감정까지(Premium).';

  @override
  String get tourLookBackTitle => '한 달 돌아보기';

  @override
  String get tourLookBackBody =>
      '매달을 추억으로, 그달의 사람과 장소와 함께. 그날의 오늘이 지난해를 떠올리게 해 줘요(Premium).';

  @override
  String get tourWallsTitle => '벽 더 만들기';

  @override
  String get tourWallsBody =>
      '아이, 여행, 프로젝트마다 벽 하나씩(Premium). 위쪽 이름을 눌러 벽을 바꾸세요.';

  @override
  String get tourFamilyTitle => '가족 벽';

  @override
  String get tourFamilyBody =>
      '모두가 자신의 순간을 더하는 종단간 암호화 공유 벽. 만드는 사람만 Premium이 필요하고, 가족은 무료로 참여해요.';

  @override
  String get tourSettingsTitle => '설정';

  @override
  String get tourSettingsBody =>
      '모든 걸 무료로 백업하고, Face ID로 앱을 잠그고, 홈 화면 위젯과 그날의 오늘을 설정하고, 언어를 고르세요.';

  @override
  String get tourFinishTitle => '끝!';

  @override
  String get tourFinishBody => '이제 다 알았어요. 나만의 벽으로 꾸며 보세요.';

  @override
  String get tourDemoPhotoTitle => '호숫가에서의 하루';

  @override
  String get tourRemoveDemoTitle => '나만의 벽을 시작할까요?';

  @override
  String get tourRemoveDemoBody => '투어에서는 예시 추억과 사진을 썼어요. 지금 지우고 내 사진으로 시작할까요?';

  @override
  String get tourRemoveDemoRemove => '지우고 시작';

  @override
  String get tourRemoveDemoKeep => '지금은 두기';

  @override
  String get tourRemovedToast => '예시 추억을 지웠어요. 벽이 준비됐어요.';

  @override
  String get storyTemplatePolaroid => '폴라로이드';

  @override
  String get storyTemplateAlbum => '앨범';

  @override
  String get storyTemplateFilmstrip => '필름';

  @override
  String get storyTemplateTimeline => '시간 여행';

  @override
  String get storyTemplatePostcard => '엽서';

  @override
  String get storyTemplateCinema => '시네마';

  @override
  String get storyTemplateSingleHint => '추억을 하나씩 전체 화면으로';

  @override
  String get storyTemplateThreadHint => '벽 위의 카드를 실로 이어서';

  @override
  String get storyTemplateCollageHint => '모든 사진을 한 격자에';

  @override
  String get storyTemplateQuoteHint => '글이 저절로 타이핑돼요';

  @override
  String get storyTemplatePolaroidHint => '즉석 사진이 차곡차곡 떨어져요';

  @override
  String get storyTemplateAlbumHint => '페이지를 넘기며 한 장씩';

  @override
  String get storyTemplateFilmstripHint => '필름이 지나가며 확대돼요';

  @override
  String get storyTemplateTimelineHint => '연도가 흘러 각 추억으로';

  @override
  String get storyTemplatePostcardHint => '엽서가 뒤집히며 이야기로';

  @override
  String get storyTemplateCinemaHint => '타이틀 카드, 느린 줌, 엔딩 크레딧';

  @override
  String get storyAnimationTitle => '애니메이션';

  @override
  String get storyAnimationPageTitle => '애니메이션 고르기';

  @override
  String get storyAnimationExamples => '예시 사진으로 보여 드려요. 스토리에는 내 추억이 쓰여요.';

  @override
  String get storyMusicPageTitle => '음악과 길이';

  @override
  String get storyLengthTitle => '길이';

  @override
  String get storyLengthAuto => '자동';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds초';
  }

  @override
  String get storyMusicAll => '전체';

  @override
  String get storyMusicPlay => '재생';

  @override
  String get storyMusicPause => '일시정지';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return '노래 $song ▸ 영상 $video';
  }

  @override
  String get storyMusicSyncHint =>
      '흰 선은 영상과 함께 노래의 몇 초가 재생되는지 보여 줘요. 표시는 각 추억이 시작되는 지점이에요.';

  @override
  String get storyMusicLengthHint => '자동은 추억 수에 맞춰요. 영상이 길수록 천천히 움직여요.';

  @override
  String get tourBack => '뒤로';

  @override
  String get tourStoryPickTitle => '추억 고르기';

  @override
  String get tourStoryPickBody => '세 개를 골라 두었어요. 최대 여섯 개까지 고를 수 있어요. 계속을 누르세요.';

  @override
  String get tourStoryAnimationTitle => '움직임 고르기';

  @override
  String get tourStoryAnimationBody => '폴라로이드부터 시네마까지. 애니메이션을 누르세요.';

  @override
  String get tourStoryStyleTitle => '폴라로이드 써 보기';

  @override
  String get tourStoryStyleBody => '각 타일에서 미리보기가 재생돼요. 폴라로이드를 누르세요.';

  @override
  String get tourStoryMusicTitle => '음악 추가';

  @override
  String get tourStoryMusicBody => '노래와 영상 길이를 고르세요. 음악을 누르세요.';

  @override
  String get tourStoryTrimTitle => '노래와 영상 맞추기';

  @override
  String get tourStoryTrimBody =>
      '금색 상자를 끌어 노래 구간을 고르세요. 흰 선이 영상과 함께 움직여서 언제 몇 초가 재생되는지 보여 줘요.';

  @override
  String get tourStoryMusicDoneTitle => '스토리로 돌아가기';

  @override
  String get tourStoryMusicDoneBody => '완료를 누르세요.';

  @override
  String get tourStoryShareTitle => '공유 또는 저장';

  @override
  String get tourStoryShareBody =>
      'Instagram, WhatsApp 등에 바로 올릴 수 있어요. 저장과 공유는 Premium 기능이에요.';

  @override
  String get tourMoreAgainTitle => '메뉴에 더 있어요';

  @override
  String get tourMoreAgainBody => '메뉴를 한 번 더 여세요. 눌러 보세요.';

  @override
  String get scannerStep1 => 'TV, 컴퓨터, 태블릿에서 웹 브라우저를 여세요.';

  @override
  String scannerStep2(Object url) {
    return '$url에 접속하면 QR 코드가 나타나요.';
  }

  @override
  String get scannerStep3 =>
      '코드가 금색 테두리 안에 들어오도록 휴대폰을 대세요. 잠시 동안 그곳에 벽이 보기 전용으로 표시돼요.';

  @override
  String get scannerShareLink => '링크 보내기';

  @override
  String get scannerCopyLink => '링크 복사';

  @override
  String get scannerLinkCopied => '링크를 복사했어요';

  @override
  String get storyTemplateScrapbook => '스크랩북';

  @override
  String get storyTemplateMosaic => '모자이크';

  @override
  String get storyTemplateContactSheet => '밀착 인화';

  @override
  String get storyTemplateWallFlight => '벽 비행';

  @override
  String get storyTemplateCarousel => '회전목마';

  @override
  String get storyTemplateJourney => '여정';

  @override
  String get storyTemplateScrapbookHint => '사진마다 페이지에 테이프로 붙여서';

  @override
  String get storyTemplateMosaicHint => '큰 사진 하나와 그 주위의 사진들';

  @override
  String get storyTemplateContactSheetHint => '추억 하나가 필름의 한 칸으로';

  @override
  String get storyTemplateWallFlightHint => '실을 따라 카드에서 카드로 날아가요';

  @override
  String get storyTemplateCarouselHint => '카드가 돌며 하나씩 앞으로';

  @override
  String get storyTemplateJourneyHint => '지도 위의 경로, 장소마다 핀';

  @override
  String get storyModePicture => '이미지';

  @override
  String get storyModeVideo => '영상';

  @override
  String get storyModePictureHint => '모든 추억을 한 장의 이미지로. 게시물과 스토리용.';

  @override
  String get storyModeVideoHint => '움직임과 음악이 있는 짧은 영상.';

  @override
  String get storyLayoutTitle => '레이아웃';

  @override
  String get storyLayoutPageTitle => '레이아웃 고르기';

  @override
  String get storyChoosePhoto => '스토리에 쓸 사진 선택';

  @override
  String get wallTidyUp => '벽 정리하기';

  @override
  String get wallTidyUpBody =>
      '모든 카드를 가장 오래된 추억부터 최신 순으로 줄 맞춰 걸까요? 메모와 못은 그대로 있어요.';

  @override
  String get wallTidyUpAction => '정리하기';

  @override
  String get wallTidiedToast => '벽을 정리했어요.';

  @override
  String get storyFormatTitle => '크기';

  @override
  String get storyFormatStory => '스토리 9:16';

  @override
  String get storyFormatPost => '게시물 4:5';

  @override
  String get storyFormatSquare => '정사각형 1:1';
}
