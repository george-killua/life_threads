// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get send => 'भेजें';

  @override
  String get preparing => 'तैयार हो रहा है...';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get languageBody =>
      'ऐप की भाषा चुनें। अगर LifeThreads आपके फ़ोन की भाषा सपोर्ट करता है, तो सिस्टम उसी भाषा को अपनाता है।';

  @override
  String get systemLanguage => 'सिस्टम';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return 'भाषा बदलकर $language कर दी गई।';
  }

  @override
  String get privacyTitle => 'प्राइवेसी';

  @override
  String get privacyBody =>
      'LifeThreads लोकल-फ़र्स्ट है: न कोई अकाउंट, न कोई पब्लिक प्रोफ़ाइल। आपकी यादें इसी डिवाइस पर रहती हैं, जब तक आप बैकअप एक्सपोर्ट न करें, एन्क्रिप्टेड कैप्सूल शेयर न करें या अपनी दीवार किसी दूसरी स्क्रीन पर न दिखाएं।';

  @override
  String get viewPrivacyPolicy => 'प्राइवेसी पॉलिसी देखें';

  @override
  String get termsTitle => 'उपयोग की शर्तें';

  @override
  String get viewTerms => 'शर्तें देखें';

  @override
  String get betaFeedbackTitle => 'बीटा फ़ीडबैक';

  @override
  String get betaFeedbackBody =>
      'सुरक्षित डायग्नोस्टिक्स के साथ बीटा फ़ीडबैक भेजें। लॉग में सिर्फ़ ऐप इवेंट और क्रैश के प्रकार होते हैं, कभी भी यादों का टेक्स्ट, फ़ोटो पाथ, बैकअप या सटीक लोकेशन नहीं।';

  @override
  String get closedBetaBadge => 'क्लोज़्ड बीटा';

  @override
  String get sendFeedback => 'फ़ीडबैक भेजें';

  @override
  String get backupArchiveBody =>
      'सब कुछ – यादें, फ़ोटो, नोट्स, धागे और लेआउट – एक ही फ़ाइल में सेव करें। इसे अपने कंप्यूटर या अपने क्लाउड में रखें, और एन्क्रिप्ट करने के लिए पासवर्ड जोड़ें।';

  @override
  String get backupArchiveTitle => 'बैकअप';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'अनलॉक';

  @override
  String get exportArchive => 'आर्काइव एक्सपोर्ट करें';

  @override
  String get importArchive => 'आर्काइव इंपोर्ट करें';

  @override
  String get importCapsule => 'कैप्सूल इंपोर्ट करें';

  @override
  String get moveDevices => 'डिवाइस बदलें';

  @override
  String get themeTitle => 'थीम';

  @override
  String get themeBody =>
      'चुनें कि आपकी निजी दीवार कैसी महसूस हो। फ़्री में गर्म यादों का कमरा मिलता है। Premium से हर मूड खुल जाता है।';

  @override
  String get oneFreeBadge => '1 फ़्री';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'Premium सब्सक्रिप्शन चालू है।';

  @override
  String get premiumLockedBody =>
      'सालाना या मासिक: अनलिमिटेड यादें, कई दीवारें, स्टोरी, थीम और लेआउट।';

  @override
  String get activeBadge => 'चालू';

  @override
  String get openPremium => 'Premium खोलें';

  @override
  String get appVersionTitle => 'ऐप वर्ज़न';

  @override
  String get clearAllDataTitle => 'सारा डेटा मिटाएं';

  @override
  String get clearAllDataBody =>
      'इस डिवाइस से सारी यादें, कनेक्शन, नोट्स, कीलें और कॉपी की गई फ़ोटो हटा दें।';

  @override
  String get clearData => 'डेटा मिटाएं';

  @override
  String exportFailed(Object error) {
    return 'एक्सपोर्ट नहीं हुआ: $error';
  }

  @override
  String importRejected(Object message) {
    return 'इंपोर्ट अस्वीकार हुआ: $message';
  }

  @override
  String importFailed(Object error) {
    return 'इंपोर्ट नहीं हुआ: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'हटाया नहीं जा सका: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'कैप्सूल अस्वीकार हुआ: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'कैप्सूल इंपोर्ट नहीं हुआ: $error';
  }

  @override
  String get clearAllDataQuestion => 'सारा डेटा मिटाएं?';

  @override
  String get clearAllDataQuestionBody =>
      'इससे इस डिवाइस का सारा लोकल LifeThreads डेटा हमेशा के लिए हट जाएगा। अगर रखना है, तो पहले बैकअप एक्सपोर्ट करें।';

  @override
  String get clearAll => 'सब मिटाएं';

  @override
  String get allLocalDataCleared => 'सारा लोकल डेटा मिटा दिया गया।';

  @override
  String get feedbackGeneral => 'सामान्य फ़ीडबैक';

  @override
  String get feedbackBug => 'बग';

  @override
  String get feedbackCrash => 'क्रैश';

  @override
  String get feedbackDesign => 'डिज़ाइन की समस्या';

  @override
  String get feedbackMissingFeature => 'कोई फ़ीचर चाहिए';

  @override
  String get feedbackPerformance => 'परफ़ॉर्मेंस';

  @override
  String get betaFeedbackIntro =>
      'लिखें कि क्या हुआ या क्या अजीब लगा। निजी यादों की सामग्री के बिना सुरक्षित डायग्नोस्टिक्स जोड़े जाएंगे।';

  @override
  String get feedbackType => 'प्रकार';

  @override
  String get feedbackLabel => 'फ़ीडबैक';

  @override
  String get feedbackHint =>
      'उदाहरण: मैंने जोड़ें > क्विक फ़ोटो दबाया और स्क्रीन अटक गई।';

  @override
  String get betaFeedbackNotIncluded =>
      'शामिल नहीं: यादों के टाइटल, कहानियां, नोट्स, फ़ोटो पाथ, बैकअप पाथ, सटीक लोकेशन।';

  @override
  String get feedbackEmpty => 'पहले एक छोटा मैसेज लिखें।';

  @override
  String get feedbackCopied =>
      'कोई ईमेल ऐप नहीं खुला। info@gkcoding.dev के लिए फ़ीडबैक क्लिपबोर्ड पर कॉपी हो गया।';

  @override
  String themeSelected(Object theme) {
    return '$theme चुना गया।';
  }

  @override
  String get onboardingHeadline => 'अपनी जीवंत दीवार बनाएं।';

  @override
  String get onboardingBody =>
      'यादों का एक निजी कमरा, जहां फ़ोटो, जगहें, लोग और छोटे नोट्स भावनाओं के धागों से जुड़े रहते हैं।';

  @override
  String get onboardingPrivacy =>
      'आपकी यादें डिफ़ॉल्ट रूप से निजी हैं: न अकाउंट, न पब्लिक प्रोफ़ाइल। एन्क्रिप्टेड क्लाउड शेयर और बैकअप सिर्फ़ तब होते हैं जब आप चुनें।';

  @override
  String get onboardingPrivacyShort =>
      'न अकाउंट, न पब्लिक प्रोफ़ाइल। जब तक आप कुछ और न चुनें, आपकी यादें इसी डिवाइस पर रहती हैं।';

  @override
  String get onboardingNext => 'आगे';

  @override
  String get onboardingNameTitle => 'हम आपको क्या कहें?';

  @override
  String get onboardingNameHint => 'आपका नाम';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'आपसे मिलकर अच्छा लगा, $name।';
  }

  @override
  String get onboardingGetStartedTitle => 'शुरुआत कैसे करें';

  @override
  String get onboardingGetStartedBody =>
      'सैंपल दीवार देखें, या खाली दीवार से शुरू करके अपनी यादें टांगें।';

  @override
  String get settingsNameTitle => 'आपका नाम';

  @override
  String get settingsNameBody => 'आपकी दीवार पर अभिवादन के रूप में दिखता है।';

  @override
  String get settingsNameHint => 'आपका नाम';

  @override
  String get settingsNameSaved => 'नाम अपडेट हो गया।';

  @override
  String get storyPrivacyTitle => 'आपकी यादें निजी रहती हैं';

  @override
  String get storyConnectTitle => 'पलों को जोड़ें';

  @override
  String get storyConnectText =>
      'यादें, नोट्स और जगहें जोड़ें, ताकि हर अध्याय का संदर्भ हो।';

  @override
  String get storyWallTitle => 'अपनी जीवंत दीवार बनाएं';

  @override
  String get storyWallText =>
      'एक फ़ोटो से शुरू करें, फिर दीवार को बढ़ने दें जब तक वह जीवंत न लगे।';

  @override
  String get previewDemoWall => 'सैंपल दीवार देखें';

  @override
  String get startFresh => 'नए सिरे से शुरू करें';

  @override
  String get optionalDemoPreview => 'वैकल्पिक सैंपल';

  @override
  String get quickTutorial => 'छोटा ट्यूटोरियल';

  @override
  String get tutorialIntro =>
      'पहले बुनियादी बातें – सेव, जोड़ना, सजाना – फिर वह सब जो आपकी दीवार कर सकती है।';

  @override
  String get gotIt => 'समझ गया';

  @override
  String get howItWorks => 'यह कैसे काम करता है';

  @override
  String get tutorialAddTitle => 'याद जोड़ें';

  @override
  String get tutorialAddText =>
      '+ दबाएं, याद या क्विक फ़ोटो चुनें, फिर टाइटल, तारीख़, लोग और फ़ोटो सेव करें। सेव करने से पहले निकल गए तो यह ड्राफ़्ट में रहती है।';

  @override
  String get tutorialConnectTitle => 'यादें जोड़ें';

  @override
  String get tutorialConnectText =>
      'कोई कार्ड खोलें, जोड़ने वाला आइकन दबाएं, जुड़ी यादें चुनें और एक छोटा कारण लिखें।';

  @override
  String get tutorialArrangeTitle => 'दीवार सजाएं';

  @override
  String get tutorialArrangeText =>
      'कार्ड, नोट्स और कीलें खींचकर जगह पर रखें। देखें › सजाएं इन्हें तारीख़, कैटेगरी या जगह से लगाता है – हो गया दबाने पर लागू होता है।';

  @override
  String get tutorialShowBoardTitle => 'बोर्ड दिखाएं';

  @override
  String get tutorialShowBoardText =>
      'दूसरी स्क्रीन पर lifethreads.gkcoding.dev/display खोलें, और › दीवार दिखाएं चुनें और कोड स्कैन करके कुछ समय के लिए सिर्फ़ देखने वाला बोर्ड दिखाएं।';

  @override
  String get tutorialBackupTitle => 'प्राइवेसी और बैकअप';

  @override
  String get tutorialBackupText =>
      'सेटिंग्स › प्राइवेसी › ऐप लॉक से LifeThreads Face ID से खुलता है। फ़ोन बदलने से पहले सेटिंग्स › बैकअप और डेटा में बैकअप एक्सपोर्ट करें।';

  @override
  String get scanDisplayQr => 'डिस्प्ले QR स्कैन करें';

  @override
  String get scannerHintTitle => 'QR कोड कहां है?';

  @override
  String get addMemoryBeforeDisplay => 'दीवार दिखाने से पहले एक याद जोड़ें।';

  @override
  String get notLifeThreadsDisplayQr =>
      'यह LifeThreads का डिस्प्ले QR नहीं है।';

  @override
  String get displayWallQuestion => 'यह दीवार दिखाएं?';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads स्कैन किए गए ब्राउज़र सेशन में $memoryCount यादों वाला एक अस्थायी, सिर्फ़ देखने वाला बोर्ड भेजेगा। यह lifethreads.gkcoding.dev/display पर खुलता है और अपने आप ख़त्म हो जाता है।';
  }

  @override
  String get displayAction => 'दिखाएं';

  @override
  String get soon => 'जल्द';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'दीवार $memoryCount यादों के साथ $expires तक दिख रही है।';
  }

  @override
  String get preparingWallDisplay => 'दीवार दिखाने की तैयारी...';

  @override
  String get open => 'खोलें';

  @override
  String get edit => 'बदलें';

  @override
  String get save => 'सेव करें';

  @override
  String get done => 'हो गया';

  @override
  String get back => 'वापस';

  @override
  String get continueAction => 'जारी रखें';

  @override
  String get close => 'बंद करें';

  @override
  String get add => 'जोड़ें';

  @override
  String get saveReason => 'कारण सेव करें';

  @override
  String get chooseBackup => 'बैकअप चुनें';

  @override
  String get chooseArchive => 'आर्काइव चुनें';

  @override
  String get chooseCapsule => 'कैप्सूल चुनें';

  @override
  String get exportAction => 'एक्सपोर्ट';

  @override
  String get addToWall => 'दीवार पर जोड़ें';

  @override
  String get cinemaSkip => 'छोड़ें';

  @override
  String get cinemaNotNow => 'अभी नहीं';

  @override
  String get cinemaSharedChapter => 'यादों का एक साझा अध्याय';

  @override
  String get cinemaConnectedThread => 'जुड़ा धागा';

  @override
  String get cinemaInviteTitle => 'यह याद अपनी दीवार पर जोड़ें?';

  @override
  String get useSelected => 'चुनी हुई इस्तेमाल करें';

  @override
  String photoGridItem(String date) {
    return '$date की फ़ोटो';
  }

  @override
  String get noPhotosFound => 'कोई फ़ोटो नहीं मिली।';

  @override
  String get manage => 'मैनेज करें';

  @override
  String get manageAccess => 'एक्सेस मैनेज करें';

  @override
  String get saveNow => 'अभी सेव करें';

  @override
  String get hangOnWall => 'दीवार पर टांगें';

  @override
  String get placeHere => 'यहां रखें';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get viewPremium => 'Premium देखें';

  @override
  String get memoryNotFound => 'याद नहीं मिली';

  @override
  String get memoryTypeMoment => 'पल';

  @override
  String get memoryTypeTrip => 'सफ़र';

  @override
  String get memoryTypePerson => 'व्यक्ति';

  @override
  String get memoryTypePlace => 'जगह';

  @override
  String get memoryTypeNote => 'नोट';

  @override
  String get memoryTypeMomentDescription => 'संजोने लायक एक छोटा सा दृश्य';

  @override
  String get memoryTypeTripDescription => 'कोई सफ़र या घूमने का दिन';

  @override
  String get memoryTypePersonDescription => 'कोई ख़ास';

  @override
  String get memoryTypePlaceDescription => 'मायने रखने वाली जगह';

  @override
  String get memoryTypeNoteDescription => 'कोई ख़याल, कोट या रिमाइंडर';

  @override
  String get categoryPersonal => 'निजी';

  @override
  String get categoryFamily => 'परिवार';

  @override
  String get categoryTravel => 'सफ़र';

  @override
  String get feelingWarm => 'प्यार भरा';

  @override
  String get feelingNostalgic => 'पुरानी यादें';

  @override
  String get feelingProud => 'गर्व';

  @override
  String get feelingCalm => 'सुकून';

  @override
  String get feelingImportant => 'अहम';

  @override
  String get feelingWarmDescription => 'नरम, क़रीबी, प्यार से भरा।';

  @override
  String get feelingNostalgicDescription => 'ऐसी याद जो पीछे ले जाए।';

  @override
  String get feelingProudDescription => 'ऐसा पल जिसने कुछ साबित किया।';

  @override
  String get feelingCalmDescription => 'शांत, सुरक्षित, सुकून भरा।';

  @override
  String get feelingImportantDescription => 'ऐसी याद जिसने कहानी बदल दी।';

  @override
  String get addPeopleHint =>
      'इस पल से जुड़े लोगों को जोड़ें। कॉन्टैक्ट डिवाइस पर ही रहते हैं।';

  @override
  String get addPerson => 'व्यक्ति जोड़ें';

  @override
  String get editPerson => 'व्यक्ति बदलें';

  @override
  String get chooseFromContacts => 'कॉन्टैक्ट से चुनें';

  @override
  String get personNameLabel => 'नाम';

  @override
  String get personNameHint => 'सेव किए लोगों को खोजने के लिए लिखें';

  @override
  String get relationshipLabel => 'रिश्ता';

  @override
  String get relationshipHint => 'दोस्त, मां, पार्टनर...';

  @override
  String get phoneOptionalLabel => 'फ़ोन (वैकल्पिक)';

  @override
  String get emailOptionalLabel => 'ईमेल (वैकल्पिक)';

  @override
  String get nameRelationshipRequired => 'नाम और रिश्ता ज़रूरी हैं।';

  @override
  String get contactAccessDenied => 'कॉन्टैक्ट का एक्सेस नहीं मिला।';

  @override
  String get couldNotOpenContacts => 'कॉन्टैक्ट नहीं खुल सके।';

  @override
  String get chooseContact => 'कॉन्टैक्ट चुनें';

  @override
  String get searchContacts => 'कॉन्टैक्ट खोजें';

  @override
  String get noContactsFound => 'कोई कॉन्टैक्ट नहीं मिला।';

  @override
  String get unnamedContact => 'बिना नाम का कॉन्टैक्ट';

  @override
  String get contactRelationship => 'कॉन्टैक्ट';

  @override
  String get couldNotLoadContacts => 'कॉन्टैक्ट लोड नहीं हो सके।';

  @override
  String get saveMomentTitle => 'एक पल सेव करें';

  @override
  String get todayEyebrow => 'आज';

  @override
  String get addMemoryStepTitle => 'ऐसा क्या हुआ जिसे आप खोना नहीं चाहते?';

  @override
  String get addMemoryStepSubtitle =>
      'एक लाइन लिखें, फ़ोटो हो तो जोड़ें और सेव करें। बाक़ी बातें बाद में।';

  @override
  String get momentLabel => 'पल';

  @override
  String get momentHint => 'लारा के साथ डिनर, पहला लॉन्च, शांत सैर...';

  @override
  String get storyWorthLabel => 'इसे संजोने की वजह?';

  @override
  String get storyWorthHint => 'कुछ शब्द काफ़ी हैं।';

  @override
  String get feelingEyebrow => 'एहसास';

  @override
  String get feelingStepTitle => 'लौटने पर यह कैसा महसूस हो?';

  @override
  String get feelingStepSubtitle =>
      'इससे बाद में यह याद फिर से ढूंढना आसान होगा।';

  @override
  String get contextEyebrow => 'संदर्भ';

  @override
  String get whenWasItTitle => 'यह कब हुआ?';

  @override
  String get photoGpsStepSubtitle =>
      'मैप चुनी गई फ़ोटो में सेव GPS का इस्तेमाल करता है। फ़ोटो में GPS न हो तो कोई जगह नहीं दिखती।';

  @override
  String get peopleThreadsEyebrow => 'लोग और धागे';

  @override
  String get peopleThreadsTitle => 'यह किससे या किस चीज़ से जुड़ा है?';

  @override
  String get peopleThreadsSubtitle =>
      'वैकल्पिक जानकारी अलग-अलग पलों को ज़िंदगी के धागे में पिरो देती है।';

  @override
  String get connectExistingMemoryLabel => 'किसी मौजूदा याद से जोड़ें';

  @override
  String get noConnectionYet => 'अभी कोई जुड़ाव नहीं';

  @override
  String get connectionReasonLabel => 'ये क्यों जुड़े हैं?';

  @override
  String get connectionReasonHint =>
      'उदाहरण: वही सफ़र, वही व्यक्ति, पहले / बाद में...';

  @override
  String get writeMomentOrPhotoFirst => 'पहले कोई पल लिखें या फ़ोटो जोड़ें।';

  @override
  String get todaysMoment => 'आज का पल';

  @override
  String get savedFromTodaysPrompt => 'आज के सवाल से सेव किया गया।';

  @override
  String get saveItBeforeItFades => 'धुंधला होने से पहले सेव करें';

  @override
  String get chooseDate => 'तारीख़ चुनें';

  @override
  String get dateLabel => 'तारीख़';

  @override
  String get untitledMemory => 'बिना टाइटल की याद';

  @override
  String get organize => 'व्यवस्थित करें';

  @override
  String get memoryShape => 'याद का रूप';

  @override
  String get wallCategory => 'दीवार की कैटेगरी';

  @override
  String get privatePhotos => 'निजी फ़ोटो';

  @override
  String get pick => 'चुनें';

  @override
  String get addMore => 'और जोड़ें';

  @override
  String get takePhoto => 'फ़ोटो लें';

  @override
  String get takePhotosNow => 'अभी फ़ोटो लें';

  @override
  String get takePhotosFabTooltip => 'नई याद के लिए फ़ोटो लें';

  @override
  String get takeAnotherPhoto => 'एक और फ़ोटो लें';

  @override
  String get continueWithPhotos => 'इन फ़ोटो के साथ आगे बढ़ें';

  @override
  String get addPhotosToMemory => 'याद में जोड़ें';

  @override
  String get takeAnotherOrContinueBody =>
      'इस याद के लिए और फ़ोटो लें, या आगे बढ़कर कहानी जोड़ें।';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ोटो ली गईं',
      one: '1 फ़ोटो ली गई',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads चुनी गई फ़ोटो ऐप के निजी स्टोरेज में कॉपी करता है और उपलब्ध हो तो तारीख़/लोकेशन रखता है।';

  @override
  String get limitedPhotoAccessActive =>
      'फ़ोटो का सीमित एक्सेस चालू है। आप और फ़ोटो की अनुमति दे सकते हैं।';

  @override
  String get selectPhotos => 'फ़ोटो चुनें';

  @override
  String get photoAccessOff => 'फ़ोटो एक्सेस बंद है';

  @override
  String get photoAccessOffBody =>
      'यादें चुनने के लिए फ़ोटो एक्सेस चालू करें। आपकी फ़ोटो इसी डिवाइस पर रहती हैं।';

  @override
  String get freeMemoryLimitReached => 'फ़्री यादों की सीमा पूरी';

  @override
  String get freeMemoryLimitBody =>
      'फ़्री दीवारों में 30 यादें होती हैं। अपनी जीवंत दीवार बढ़ाते रहने के लिए अपग्रेड करें।';

  @override
  String get photoAccessNeeded => 'पहले फ़ोटो एक्सेस चाहिए।';

  @override
  String get quickPhotoMemory => 'क्विक फ़ोटो याद';

  @override
  String get quickPhotoDescription =>
      'संजोने लायक एक फ़ोटो। कहानी जब चाहें जोड़ें।';

  @override
  String get hangQuickPhoto => 'क्विक फ़ोटो टांगें';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'फ़ोटो का GPS मिला: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'फ़ोटो में GPS नहीं मिला। यह याद मैप पर नहीं दिखेगी।';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • $photoCount फ़ोटो';
  }

  @override
  String metadataDates(int count, int total) {
    return '$count/$total तारीख़ें';
  }

  @override
  String metadataLocations(int count, int total) {
    return '$count/$total लोकेशन';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total साइज़';
  }

  @override
  String newSelected(int count) {
    return '$count नई चुनी गईं';
  }

  @override
  String selectedCount(int count) {
    return '$count चुनी गईं';
  }

  @override
  String get editMemoryTitle => 'याद बदलें';

  @override
  String get storyPanel => 'कहानी';

  @override
  String get memoryTitleLabel => 'याद का टाइटल';

  @override
  String get addTitleValidation => 'टाइटल जोड़ें';

  @override
  String get storyDescriptionLabel => 'कहानी / विवरण';

  @override
  String get addStoryValidation => 'एक छोटी कहानी जोड़ें';

  @override
  String get shapeFeelingTitle => 'रूप और एहसास';

  @override
  String get memoryTypeLabel => 'याद का प्रकार';

  @override
  String get feelingLabel => 'एहसास';

  @override
  String get categoryLabel => 'कैटेगरी';

  @override
  String get timePhotoGpsTitle => 'समय और फ़ोटो GPS';

  @override
  String get memoryDateLabel => 'याद की तारीख़';

  @override
  String get peopleTitle => 'लोग';

  @override
  String get galleryTitle => 'गैलरी';

  @override
  String get addPhotos => 'फ़ोटो जोड़ें';

  @override
  String get saveMemory => 'याद सेव करें';

  @override
  String get memorySaveFailed =>
      'यह याद सेव नहीं हो सकी। कृपया फिर कोशिश करें।';

  @override
  String get passwordOnlySpaces => 'पासवर्ड में सिर्फ़ स्पेस नहीं हो सकते।';

  @override
  String get somethingWentWrong => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get mapUnavailable => 'मैप अभी उपलब्ध नहीं है।';

  @override
  String get coverPhoto => 'कवर फ़ोटो';

  @override
  String get galleryPhoto => 'गैलरी फ़ोटो';

  @override
  String get setAsCover => 'कवर बनाएं';

  @override
  String get replacePhoto => 'फ़ोटो बदलें';

  @override
  String get removePhoto => 'फ़ोटो हटाएं';

  @override
  String get choosePhoto => 'फ़ोटो चुनें';

  @override
  String get threadReasonsTitle => 'धागों के कारण';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'जोड़ने से पहले और यादें बनाएं।';

  @override
  String get connectionHeaderBody =>
      'यादों को किसी कारण से जोड़ें। धागा बताए कि दो पल साथ क्यों हैं।';

  @override
  String get connectedMemory => 'जुड़ी याद';

  @override
  String get whyConnectedTitle => 'ये क्यों जुड़े हैं?';

  @override
  String get exportPremiumArchiveTitle => 'बैकअप एक्सपोर्ट करें';

  @override
  String get importArchiveTitle => 'आर्काइव इंपोर्ट करें';

  @override
  String get archiveExportBody =>
      'आर्काइव एन्क्रिप्ट करने के लिए पासवर्ड जोड़ें। सामान्य लोकल zip के लिए खाली छोड़ें।';

  @override
  String get archiveImportBody =>
      'अगर आर्काइव एन्क्रिप्टेड है, तो उसका पासवर्ड डालें। पुराने या बिना सुरक्षा वाले बैकअप के लिए खाली छोड़ें।';

  @override
  String get archivePasswordOptional => 'आर्काइव पासवर्ड (वैकल्पिक)';

  @override
  String get archivePasswordLabel => 'आर्काइव पासवर्ड';

  @override
  String get archivePasswordWarning =>
      'पासवर्ड सुरक्षित जगह रखें। खो जाने पर यह वापस नहीं मिल सकता।';

  @override
  String get sendArchiveTitle => 'LifeThreads आर्काइव भेजें';

  @override
  String get sendArchiveSubject => 'LifeThreads यादों का आर्काइव';

  @override
  String get sendEncryptedArchiveText =>
      'एन्क्रिप्टेड LifeThreads आर्काइव। दूसरे डिवाइस पर इंपोर्ट करने के लिए आपका चुना पासवर्ड इस्तेमाल करें।';

  @override
  String get sendArchiveText =>
      'LifeThreads आर्काइव। दूसरे डिवाइस पर अपनी यादों की दीवार खोलने के लिए इसे LifeThreads में इंपोर्ट करें।';

  @override
  String get archiveReadyToSend =>
      'बैकअप तैयार है। इसे इस फ़ोन से अलग किसी सुरक्षित जगह रखें।';

  @override
  String get archiveNotSaved =>
      'बैकअप सेव नहीं हुआ। तैयार हों तो फिर से एक्सपोर्ट करें।';

  @override
  String get archiveSharingUnavailable =>
      'इस डिवाइस पर शेयर करना उपलब्ध नहीं है।';

  @override
  String archiveShareFailed(Object error) {
    return 'आर्काइव सेव हो गया, पर शेयर नहीं हुआ: $error';
  }

  @override
  String get archiveImportedTitle => 'आर्काइव इंपोर्ट हो गया';

  @override
  String get memoriesLabel => 'यादें';

  @override
  String get photosLabel => 'फ़ोटो';

  @override
  String get wallNotesNailsLabel => 'दीवार के नोट्स / कीलें';

  @override
  String get connectionsLabel => 'कनेक्शन';

  @override
  String get archiveImportSummary =>
      'आपकी मौजूदा दीवार बनी रही। इंपोर्ट की गई यादें सुरक्षित रूप से जोड़ दी गईं।';

  @override
  String get shareEncryptedCapsuleTitle => 'एन्क्रिप्टेड कैप्सूल शेयर करें';

  @override
  String get openSharedCapsuleTitle => 'शेयर किया कैप्सूल खोलें';

  @override
  String get exportMemoryCapsuleTitle => 'याद का कैप्सूल एक्सपोर्ट करें';

  @override
  String get importCapsuleDialogTitle => 'कैप्सूल इंपोर्ट करें';

  @override
  String get secureSharePasswordBody =>
      'यह कैप्सूल अपलोड करने से पहले पासवर्ड बनाएं। पासवर्ड पाने वाले को अलग से भेजें।';

  @override
  String get sharedCapsulePasswordBody =>
      'इस शेयर की गई याद के लिए मिला पासवर्ड डालें।';

  @override
  String get capsuleExportBody =>
      'भेजने से पहले याद को सुरक्षित करना हो तो पासवर्ड जोड़ें। सामान्य कैप्सूल के लिए खाली छोड़ें।';

  @override
  String get capsuleImportBody =>
      'कैप्सूल में पासवर्ड हो तो डालें। नहीं तो खाली छोड़ें।';

  @override
  String get capsulePasswordLabel => 'कैप्सूल पासवर्ड';

  @override
  String get sharedCapsulePasswordLabel => 'शेयर किए कैप्सूल का पासवर्ड';

  @override
  String get capsulePasswordOptional => 'कैप्सूल पासवर्ड (वैकल्पिक)';

  @override
  String get capsulePasswordWarning =>
      'LifeThreads यह पासवर्ड बाद में वापस नहीं ला सकता।';

  @override
  String get passwordRequiredCloudSharing =>
      'क्लाउड शेयरिंग के लिए पासवर्ड ज़रूरी है।';

  @override
  String get createSecureShare => 'सुरक्षित शेयर बनाएं';

  @override
  String get previewMemory => 'याद का प्रीव्यू';

  @override
  String get sendCapsuleTitle => 'LifeThreads याद शेयर करें';

  @override
  String get sendCapsuleSubject => 'LifeThreads याद का कैप्सूल';

  @override
  String get sendEncryptedCapsuleText =>
      'हाय, मैंने आपके साथ LifeThreads की एक सुरक्षित याद शेयर की है। इंपोर्ट करने के लिए मेरा भेजा पासवर्ड इस्तेमाल करें।';

  @override
  String get sendCapsuleText =>
      'हाय, मैंने आपके साथ LifeThreads की एक याद शेयर की है। इसे अपनी दीवार पर जोड़ने के लिए कैप्सूल LifeThreads में इंपोर्ट करें।';

  @override
  String get capsuleReadyToSend => 'कैप्सूल भेजने के लिए तैयार है।';

  @override
  String get capsuleSavedLater =>
      'कैप्सूल सेव हो गया। आप इसे बाद में शेयर कर सकते हैं।';

  @override
  String get capsuleSharingUnavailable =>
      'कैप्सूल सेव हो गया, पर शेयर करना उपलब्ध नहीं है।';

  @override
  String capsuleShareFailed(Object error) {
    return 'कैप्सूल सेव हो गया, पर शेयर नहीं हुआ: $error';
  }

  @override
  String get importThisMemory => 'यह याद इंपोर्ट करें?';

  @override
  String get noStoryTextIncluded => 'कहानी का कोई टेक्स्ट नहीं है।';

  @override
  String get placeLabel => 'जगह';

  @override
  String get notesLabel => 'नोट्स';

  @override
  String get capsulePasswordProtected => 'यह कैप्सूल पासवर्ड से सुरक्षित था।';

  @override
  String get openingSharedMemory => 'शेयर की गई याद खुल रही है...';

  @override
  String get lifeThreadsMemoryTitle => 'LifeThreads याद';

  @override
  String shareMemoryText(Object url) {
    return 'हाय, मैंने LifeThreads में आपके साथ एक याद शेयर की है।\n\n$url';
  }

  @override
  String get shareLinkReady => 'शेयर लिंक तैयार है।';

  @override
  String get shareLinkCreated => 'शेयर लिंक बन गया।';

  @override
  String get shareLinkUnavailable =>
      'शेयर लिंक बन गया, पर शेयर करना उपलब्ध नहीं है।';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label लिंक अपने आप ख़त्म हो जाएगा। आप इसे अभी हटा भी सकते हैं।';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'क्लाउड शेयर नहीं हुआ: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'शेयर की गई याद का लिंक हटा दिया गया।';

  @override
  String get creatingSecureMemoryLink => 'सुरक्षित लिंक बन रहा है...';

  @override
  String get shareMemoryCapsule => 'याद का कैप्सूल शेयर करें';

  @override
  String get editStory => 'कहानी बदलें';

  @override
  String get metaType => 'प्रकार';

  @override
  String get metaFeeling => 'एहसास';

  @override
  String get metaCategory => 'कैटेगरी';

  @override
  String get metaDate => 'तारीख़';

  @override
  String get storyEyebrow => 'कहानी';

  @override
  String get whyMemoryMatters => 'यह याद क्यों मायने रखती है';

  @override
  String get galleryEyebrow => 'गैलरी';

  @override
  String editSectionTooltip(String section) {
    return '$section बदलें';
  }

  @override
  String get openInMaps => 'मैप्स में खोलें';

  @override
  String get memoryChangesSaved => 'बदलाव सेव हो गए।';

  @override
  String get memoryDeletedToast => 'याद हटा दी गई।';

  @override
  String get noteDeletedToast => 'नोट हटा दिया गया।';

  @override
  String get nailDeletedToast => 'कील हटा दी गई।';

  @override
  String get undo => 'वापस लाएं';

  @override
  String photoPlaceDetected(String place) {
    return 'फ़ोटो से जगह: $place';
  }

  @override
  String get settingsGroupYou => 'आप';

  @override
  String get settingsGroupReminders => 'रिमाइंडर';

  @override
  String get settingsGroupMore => 'और';

  @override
  String get backupDataTitle => 'बैकअप और डेटा';

  @override
  String get backupDataSubtitle => 'बैकअप, रिस्टोर, नए फ़ोन पर ले जाएं';

  @override
  String get aboutHelpTitle => 'जानकारी और मदद';

  @override
  String get aboutHelpSubtitle => 'फ़ीडबैक, प्राइवेसी, म्यूज़िक, वर्ज़न';

  @override
  String get discardChangesTitle => 'बदलाव छोड़ दें?';

  @override
  String get discardChangesBody => 'यहां किए गए बदलाव खो जाएंगे।';

  @override
  String get discardChanges => 'छोड़ें';

  @override
  String get keepEditing => 'बदलाव जारी रखें';

  @override
  String get settingsGroupPrivacy => 'प्राइवेसी';

  @override
  String get appLockTitle => 'ऐप लॉक';

  @override
  String get appLockSubtitle => 'LifeThreads खोलने के लिए Face ID या पासकोड';

  @override
  String get appLockReason => 'अपनी यादें अनलॉक करें';

  @override
  String get appLockLockedTitle => 'LifeThreads लॉक है';

  @override
  String get appLockUnlock => 'अनलॉक करें';

  @override
  String get appLockUnavailable =>
      'पहले इस फ़ोन पर Face ID या पासकोड सेट करें।';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years साल पहले की एक याद आपका इंतज़ार कर रही है।',
      one: '1 साल पहले की एक याद आपका इंतज़ार कर रही है।',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'खोजें';

  @override
  String get searchHint => 'टाइटल, जगह, व्यक्ति या साल';

  @override
  String get searchClear => 'खोज साफ़ करें';

  @override
  String get searchNoResults => 'कोई याद मेल नहीं खाती।';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यादें',
      one: '1 याद',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => 'यादें खोजें';

  @override
  String get premiumFeatureWalls => 'और दीवारें';

  @override
  String get newWall => 'नई दीवार';

  @override
  String get wallNameLabel => 'दीवार का नाम';

  @override
  String get newWallHint => 'जैसे सफ़र 2025';

  @override
  String get createWall => 'बनाएं';

  @override
  String get renameWall => 'नाम बदलें';

  @override
  String get deleteWall => 'दीवार हटाएं';

  @override
  String deleteWallQuestion(String name) {
    return '“$name” हटाएं?';
  }

  @override
  String get deleteWallBody =>
      'इसकी यादें मेरी दीवार पर चली जाएंगी; कुछ नहीं खोएगा।';

  @override
  String get personalWallSubtitle => 'आपकी दीवार, इस डिवाइस पर';

  @override
  String get wallOptions => 'दीवार के विकल्प';

  @override
  String get moveToWall => 'दीवार पर ले जाएं…';

  @override
  String movedToWall(String name) {
    return '$name पर ले जाया गया।';
  }

  @override
  String get hideMemory => 'छिपाएं';

  @override
  String get unhideMemory => 'फिर से दिखाएं';

  @override
  String get memoryHiddenToast => 'छिपा दी गई। देखें › छिपी यादें में मिलेगी।';

  @override
  String get showHiddenMemories => 'छिपी यादें';

  @override
  String get showHiddenReason => 'छिपी यादें दिखाएं';

  @override
  String get yearThreadFirstTitle => 'आपका पहला साल का धागा';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '3 में से $count यादें',
      one: '3 में से 1 याद',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => 'या अभी स्टोरी बनाएं';

  @override
  String get moveMemoriesHere => 'यादें यहां लाएं';

  @override
  String get moveMemoriesTitle => 'यहां लाने के लिए यादें चुनें';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यादें ले जाएं',
      one: '1 याद ले जाएं',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'सब दिखाएं';

  @override
  String get addAMemory => 'याद जोड़ें';

  @override
  String get mapAddPhotoMemory => 'जगह वाली फ़ोटो जोड़ें';

  @override
  String get searchSuggestions => 'अपनी किसी याद से आज़माएं';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'इस हफ़्ते, $years साल पहले',
      one: 'इस हफ़्ते, 1 साल पहले',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => 'वहां कौन था?';

  @override
  String get premiumPlanYearly => 'सालाना';

  @override
  String get premiumPlanMonthly => 'मासिक';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/साल';
  }

  @override
  String premiumSavePercent(int percent) {
    return '$percent% बचाएं';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'भुगतान आपके $store अकाउंट से लिया जाता है। मौजूदा अवधि ख़त्म होने से कम से कम 24 घंटे पहले रद्द न करने पर सब्सक्रिप्शन हर साल अपने आप रिन्यू होता है। इसे अपनी $store अकाउंट सेटिंग्स में मैनेज या रद्द करें।';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेव फ़ोटो',
      one: '1 सेव फ़ोटो',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => 'लोग';

  @override
  String get partOfMemory => 'इस याद का हिस्सा';

  @override
  String get notesEyebrow => 'नोट्स';

  @override
  String get attachedThoughts => 'जुड़े ख़याल';

  @override
  String get stickyNote => 'स्टिकी नोट';

  @override
  String get placeEyebrow => 'जगह';

  @override
  String get threadsEyebrow => 'धागे';

  @override
  String get connectedMemories => 'जुड़ी यादें';

  @override
  String get noConnectedMemoriesYet =>
      'अभी कोई जुड़ी याद नहीं। ज़िंदगी का दिखने वाला धागा शुरू करने के लिए इस अध्याय को किसी और पल से जोड़ें।';

  @override
  String get backToWall => 'दीवार पर वापस';

  @override
  String get addTextToWall => 'दीवार पर टेक्स्ट जोड़ें';

  @override
  String get addTextAction => 'टेक्स्ट जोड़ें';

  @override
  String get textNoteHint => 'कोई छोटी याद, कोट या नोट लिखें...';

  @override
  String get placeTextNote => 'टेक्स्ट नोट रखें';

  @override
  String get placeRopeAnchor => 'रस्सी का एंकर रखें';

  @override
  String get nailSubtitle =>
      'कील से यादों के बीच रस्सियां हाथ से जोड़ी जा सकती हैं।';

  @override
  String get clearDemoWallQuestion => 'सैंपल दीवार मिटाएं?';

  @override
  String get clearDemoWallBody =>
      'इससे सैंपल यादें हट जाएंगी ताकि आप खाली निजी दीवार से शुरू कर सकें।';

  @override
  String get importBackupQuestion => 'बैकअप इंपोर्ट करें?';

  @override
  String get importBackupBody =>
      'यह LifeThreads आर्काइव से यादें वापस लाता है और आपकी मौजूदा दीवार रखता है।';

  @override
  String get deleteMemoryQuestion => 'याद हटाएं?';

  @override
  String get deleteMemoryBody =>
      'इससे याद और दीवार पर उसके सारे लिंक हट जाएंगे।';

  @override
  String get editText => 'टेक्स्ट बदलें';

  @override
  String get editTextTitle => 'टेक्स्ट बदलें';

  @override
  String get connectRope => 'रस्सी जोड़ें';

  @override
  String get connectRopeSubtitle => 'इस कील को यादों से जोड़ें।';

  @override
  String get deleteNail => 'कील हटाएं';

  @override
  String get connectNailTitle => 'कील को यादों से जोड़ें';

  @override
  String get connectNailSubtitle => 'चुनी गई यादें इस एंकर से लटकेंगी।';

  @override
  String get timelineTitle => 'टाइमलाइन';

  @override
  String get timelineSubtitle => 'समय के क्रम में आपकी यादें।';

  @override
  String get noMemoriesFilter => 'इस फ़िल्टर में कोई याद नहीं';

  @override
  String get noMemoriesFilterBody =>
      'टाइमलाइन बनाने के लिए फ़िल्टर बदलें या याद जोड़ें।';

  @override
  String get memoryMapTitle => 'यादों का मैप';

  @override
  String get memoryMapSubtitle => 'जगह के हिसाब से आपकी यादें।';

  @override
  String get noMappedMemories => 'मैप पर अभी कोई याद नहीं';

  @override
  String get displayWallTooltip => 'दीवार दिखाएं';

  @override
  String get tutorialTooltip => 'ट्यूटोरियल';

  @override
  String get settingsTooltip => 'सेटिंग्स';

  @override
  String get freeformLayout => 'फ़्रीफ़ॉर्म';

  @override
  String get categoryLayout => 'कैटेगरी';

  @override
  String get locationLayout => 'जगह';

  @override
  String get saveToday => 'आज सेव करें';

  @override
  String get rememberThis => 'इसे याद रखें';

  @override
  String get whatHappenedToday => 'आज क्या हुआ?';

  @override
  String get tapToOpenDrag => 'खोलने के लिए टैप • हटाने के लिए खींचें';

  @override
  String get demoWallPreview =>
      'सैंपल दीवार। नए सिरे से शुरू करने को तैयार हों तो इसे मिटा दें।';

  @override
  String get clearDemo => 'सैंपल मिटाएं';

  @override
  String get chooseQuickPhoto => 'क्विक फ़ोटो चुनें';

  @override
  String get wallView => 'दीवार';

  @override
  String get timelineView => 'टाइमलाइन';

  @override
  String get mapView => 'मैप';

  @override
  String get wallFilterAll => 'सभी';

  @override
  String get wallViewButton => 'देखें';

  @override
  String get wallShowAs => 'ऐसे दिखाएं';

  @override
  String get wallArrange => 'सजाएं';

  @override
  String get wallShowOnly => 'दिखाएं';

  @override
  String get layoutByDate => 'तारीख़ से';

  @override
  String get moreActionsTooltip => 'और';

  @override
  String get addToWallTitle => 'अपनी दीवार पर जोड़ें';

  @override
  String get expandableMemory => 'याद';

  @override
  String get expandableMemorySubtitle => 'पूरी गाइडेड कहानी';

  @override
  String get expandableQuickPhoto => 'क्विक फ़ोटो याद';

  @override
  String get expandableQuickPhotoSubtitle => 'फ़ोटो चुनें और टांगें';

  @override
  String get expandableTextNote => 'टेक्स्ट नोट';

  @override
  String get expandableTextNoteSubtitle => 'दीवार पर छोटा ख़याल';

  @override
  String get expandableNail => 'कील / रस्सी एंकर';

  @override
  String get expandableNailSubtitle => 'हाथ से रस्सी का पॉइंट';

  @override
  String get startWithOneThing => 'आज की एक बात से शुरू करें';

  @override
  String get emptyWallBody =>
      'धुंधला होने से पहले एक पल सेव करें। एक वाक्य या एक फ़ोटो काफ़ी है।';

  @override
  String get usePhoto => 'फ़ोटो इस्तेमाल करें';

  @override
  String get editMemoryTooltip => 'याद बदलें';

  @override
  String get connectMemoryTooltip => 'याद जोड़ें';

  @override
  String get archiveTransferTitle => 'दूसरे डिवाइस पर खोलें';

  @override
  String get archiveTransferHeroTitle =>
      'अपनी यादें सुरक्षित तरीक़े से दूसरे डिवाइस पर ले जाएं।';

  @override
  String get archiveTransferHeroBody =>
      'बैकअप एक zip है जिसमें आपकी यादें, फ़ोटो, नोट्स, धागे, दीवार पर जगहें और मेटाडेटा होते हैं, चाहें तो पासवर्ड से लॉक। हम कोई कॉपी नहीं रखते: यह कहां जाए, आप तय करते हैं।';

  @override
  String get archiveTransferStep1Title => 'आर्काइव एक्सपोर्ट करें';

  @override
  String get archiveTransferStep1Body =>
      'सेटिंग्स खोलें, आर्काइव एक्सपोर्ट करें चुनें, और सुरक्षा चाहिए तो पासवर्ड जोड़ें।';

  @override
  String get archiveTransferStep2Title => 'zip ले जाएं';

  @override
  String get archiveTransferStep2Body =>
      'AirDrop, USB, अपने क्लाउड या ईमेल से भेजें।';

  @override
  String get archiveTransferStep3Title => 'सुरक्षित इंपोर्ट करें';

  @override
  String get archiveTransferStep3Body =>
      'दूसरे डिवाइस पर LifeThreads इंस्टॉल करें, आर्काइव इंपोर्ट करें चुनें, ज़रूरत हो तो पासवर्ड डालें और मौजूदा डेटा मिटाए बिना रिस्टोर करें।';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled => 'डेवलपमेंट Premium अनलॉक चालू।';

  @override
  String get lifetimeActive => 'सब्सक्रिप्शन चालू';

  @override
  String get oneTimeLifetimeUnlock => 'सालाना या मासिक';

  @override
  String get premiumHeroActiveTitle => 'आपकी यादों की दीवार की कोई सीमा नहीं।';

  @override
  String get premiumHeroLockedTitle => 'अपनी यादों को स्टोरी बनाएं।';

  @override
  String get premiumHeroActiveBody =>
      'आपका Premium सब्सक्रिप्शन चालू है। म्यूज़िक वाली स्टोरी, साल का धागा, परिवार की दीवारें और अनलिमिटेड यादें अब आपकी हैं।';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'फ़्री में $limit यादें और पूरा बैकअप है। Premium में म्यूज़िक वाली स्टोरी और फ़िल्में, साल का धागा, परिवार की दीवारें और अनलिमिटेड यादें जुड़ती हैं।';
  }

  @override
  String get premiumMemories => 'Premium यादें';

  @override
  String get freeMemories => 'फ़्री यादें';

  @override
  String get unlimited => 'अनलिमिटेड';

  @override
  String get benefitUnlimitedTitle => 'अनलिमिटेड यादें';

  @override
  String get benefitUnlimitedBody =>
      '30 यादों की कोई सीमा नहीं। ज़िंदगी के साथ दीवार बढ़ाते रहें।';

  @override
  String get benefitThemesTitle => 'Premium दीवार थीम';

  @override
  String get benefitThemesBody =>
      'और गहरे मूड, सीमित मौसमी थीम और दिन के समय के हिसाब से ऑटो थीम खोलें।';

  @override
  String get benefitLayoutsTitle => 'एडवांस लेआउट';

  @override
  String get benefitLayoutsBody =>
      'धागे, टाइमलाइन, एंकर और यादों के समूह सजाने के और तरीक़े।';

  @override
  String get lifetimeUnlock => 'Premium सब्सक्रिप्शन';

  @override
  String get premiumActiveOnDevice => 'इस डिवाइस पर Premium चालू है।';

  @override
  String onePurchaseBody(String store) {
    return 'म्यूज़िक वाली स्टोरी, साल का धागा, परिवार की दीवारें और अनलिमिटेड यादों के लिए सालाना या मासिक सब्सक्राइब करें। $store सेटिंग्स में कभी भी रद्द करें।';
  }

  @override
  String get premiumActiveButton => 'Premium चालू';

  @override
  String get processing => 'प्रोसेस हो रहा है...';

  @override
  String get unlockPremium => 'Premium सब्सक्राइब करें';

  @override
  String get restorePurchase => 'सब्सक्रिप्शन रिस्टोर करें';

  @override
  String get enableDebugMockUnlock => 'टेस्ट अनलॉक चालू करें';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'भुगतान आपके $store अकाउंट से लिया जाता है। मौजूदा अवधि ख़त्म होने से कम से कम 24 घंटे पहले रद्द न करने पर सब्सक्रिप्शन हर महीने अपने आप रिन्यू होता है। इसे अपनी $store अकाउंट सेटिंग्स में मैनेज या रद्द करें।';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'स्टोर अपडेट नहीं हुआ। कृपया फिर कोशिश करें।';

  @override
  String get premiumMessageStoreUnavailable =>
      'इस डिवाइस पर ख़रीदारी उपलब्ध नहीं है।';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium अभी स्टोर में उपलब्ध नहीं है। कृपया बाद में कोशिश करें।';

  @override
  String get premiumMessageLoadFailed =>
      'स्टोर से Premium लोड नहीं हो सका। कृपया फिर कोशिश करें।';

  @override
  String get premiumMessageOpeningCheckout => 'पेमेंट खुल रहा है…';

  @override
  String get premiumMessageCheckoutFailed =>
      'पेमेंट नहीं खुल सका। कृपया फिर कोशिश करें।';

  @override
  String get premiumMessageChecking => 'आपका सब्सक्रिप्शन जांचा जा रहा है…';

  @override
  String get premiumMessageRestoreFailed =>
      'रिस्टोर नहीं हुआ। कृपया फिर कोशिश करें।';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'कोई चालू Premium सब्सक्रिप्शन नहीं मिला।';

  @override
  String get premiumMessagePending =>
      'आपकी ख़रीदारी पेंडिंग है। मंज़ूरी मिलते ही Premium खुल जाएगा।';

  @override
  String get premiumMessagePurchaseFailed =>
      'ख़रीदारी पूरी नहीं हुई। कृपया फिर कोशिश करें।';

  @override
  String get premiumMessageCanceled => 'ख़रीदारी रद्द हुई।';

  @override
  String get premiumMessageRestored =>
      'आपका Premium सब्सक्रिप्शन रिस्टोर हो गया।';

  @override
  String get premiumMessageActive => 'आपका Premium सब्सक्रिप्शन चालू है।';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/महीना';
  }

  @override
  String get loadingPlayStoreProduct => 'सब्सक्रिप्शन लोड हो रहा है…';

  @override
  String get playStoreUnavailable => 'स्टोर अभी उपलब्ध नहीं है';

  @override
  String get productNotConfigured => 'Premium अभी उपलब्ध नहीं है';

  @override
  String get purchasePending => 'ख़रीदारी पेंडिंग';

  @override
  String get purchased => 'ख़रीदा गया';

  @override
  String get restored => 'रिस्टोर हुआ';

  @override
  String get premiumTryAgain => 'फिर कोशिश करें';

  @override
  String get purchaseFailed => 'ख़रीदारी नहीं हुई';

  @override
  String get preparingCheckout => 'पेमेंट तैयार हो रहा है...';

  @override
  String get premiumLocalFirstTitle => 'Premium भी लोकल-फ़र्स्ट';

  @override
  String get premiumLocalFirstBody =>
      'आपकी यादें आपके डिवाइस पर रहती हैं, और बैकअप सबके लिए फ़्री है।';

  @override
  String get noMappedMemoriesBody =>
      'यहां यादें देखने के लिए GPS वाली फ़ोटो जोड़ें।';

  @override
  String get peopleLabel => 'लोग';

  @override
  String get connect => 'जोड़ें';

  @override
  String get themeWarmMemoryRoom => 'गर्म यादों का कमरा';

  @override
  String get themeWarmMemoryRoomDescription =>
      'हल्की अंधेरी गर्माहट, सुनहरी रोशनी और निजी कमरे की गहराई।';

  @override
  String get themeMidnightArchive => 'आधी रात का आर्काइव';

  @override
  String get themeMidnightArchiveDescription =>
      'म्यूज़ियम जैसी शांति वाला गहरा नीला आर्काइव रूम।';

  @override
  String get themeSoftPaperWall => 'मुलायम काग़ज़ की दीवार';

  @override
  String get themeSoftPaperWallDescription =>
      'क्रीम काग़ज़, स्याही की परछाइयां और शांत स्क्रैपबुक जैसा एहसास।';

  @override
  String get themeTravelCorkboard => 'ट्रैवल कॉर्कबोर्ड';

  @override
  String get themeTravelCorkboardDescription =>
      'सफ़र और जगहों के लिए मैप-ग्रिड वाला गर्म कॉर्कबोर्ड।';

  @override
  String get themeAutoTitle => 'दिन के समय के हिसाब से ऑटो';

  @override
  String get themeAutoDescription =>
      'दिन में मुलायम काग़ज़ की दीवार, शाम को गर्म यादों का कमरा, रात में आधी रात का आर्काइव।';

  @override
  String get themeAutoSelected => 'आपकी दीवार अब दिन के समय के साथ बदलेगी।';

  @override
  String get themeSeasonalTitle => 'मौसमी';

  @override
  String get themeSeasonalBody =>
      'सीमित Premium थीम, हर एक सिर्फ़ अपने मौसम में।';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString तक';
  }

  @override
  String get themeUseButton => 'यह थीम लगाएं';

  @override
  String get themeInUse => 'लगी हुई';

  @override
  String get themeUnlockButton => 'Premium से अनलॉक करें';

  @override
  String get themeAutumnHarvest => 'पतझड़ की फ़सल';

  @override
  String get themeAutumnHarvestDescription =>
      'अंबर रोशनी, क्राफ़्ट पेपर कार्ड और गिरते पत्तों की चमक।';

  @override
  String get themeWinterLights => 'सर्दियों की रोशनियां';

  @override
  String get themeWinterLightsDescription =>
      'ठंडी नीली रात में पाले वाले कार्ड और गर्म लड़ियां।';

  @override
  String get themeSpringBlossom => 'बसंत के फूल';

  @override
  String get themeSpringBlossomDescription =>
      'हल्की गुलाबी चमक वाले फीके फूलों के कार्ड।';

  @override
  String get themeSummerEvening => 'गर्मियों की शाम';

  @override
  String get themeSummerEveningDescription =>
      'सूर्यास्त के रंग और इंस्टेंट फ़ोटो कार्ड।';

  @override
  String get themeYearRoundTitle => 'हमेशा उपलब्ध';

  @override
  String get themeComingTitle => 'जल्द आ रहा है';

  @override
  String get themeComingBody =>
      'अगले मौसमों की झलक देखें। हर थीम अपने मौसम के पहले दिन खुलती है।';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString से';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सभी थीम देखें, इस मौसम की $count',
      one: 'सभी थीम देखें, इस मौसम की 1',
      zero: 'सभी थीम देखें',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => 'समुद्र किनारा';

  @override
  String get themeSeasideDescription =>
      'फ़िरोज़ी पानी, रेतीला काग़ज़ और गर्मियों की गर्म रोशनी।';

  @override
  String get themeSnowyCabin => 'बर्फ़ीली केबिन';

  @override
  String get themeSnowyCabinDescription =>
      'अलाव के पास लकड़ी, पाले वाले कार्ड और बाहर हल्की बर्फ़।';

  @override
  String get themeSpringMeadow => 'बसंत का मैदान';

  @override
  String get themeSpringMeadowDescription =>
      'ताज़ी हरी घास, हल्के कार्ड और पीली धूप।';

  @override
  String get themeMistyForest => 'धुंधला जंगल';

  @override
  String get themeMistyForestDescription =>
      'शांत चीड़, सुबह की धुंध और सुनहरे पत्ते।';

  @override
  String get demoFirstDanceTitle => 'हमारा पहला डांस';

  @override
  String get demoFirstDanceStory =>
      'बैंड ने हमारा गाना बजाया और पूरा बार्न ख़ामोश हो गया। मैंने दो बार तुम्हारा पैर कुचला, तुम पूरे वक़्त हंसती रहीं, और उन तीन मिनटों में कोई और था ही नहीं।';

  @override
  String get demoFirstDancePlace => 'साल्ज़बर्ग';

  @override
  String get demoNewbornTitle => 'घर में स्वागत है, लीना';

  @override
  String get demoNewbornStory =>
      'उसका पूरा हाथ एक उंगली के चारों ओर आ गया। घर पर पहली शांत सुबह।';

  @override
  String get demoNewbornPlace => 'वियना';

  @override
  String get demoBeachSunsetTitle => 'समुद्र किनारे गर्मियां';

  @override
  String get demoBeachSunsetStory =>
      'सूरज ढलने तक नंगे पैर, लौटते वक़्त लीना तुम्हारे कंधों पर सो गई।';

  @override
  String get demoBeachSunsetPlace => 'स्प्लिट, क्रोएशिया';

  @override
  String get demoGrandmaKitchenTitle => 'दादी की रसोई';

  @override
  String get demoGrandmaKitchenStory =>
      'उनका खुबानी केक, आख़िरकार लिख लिया – और हर तरफ़ आटा।';

  @override
  String get demoGrandmaKitchenPlace => 'ग्राज़';

  @override
  String get demoGraduationTitle => 'ग्रेजुएशन का दिन';

  @override
  String get demoGraduationStory => 'टोपियां नीचे आने से पहले ही पापा रो पड़े।';

  @override
  String get demoGraduationPlace => 'इंसब्रुक';

  @override
  String get demoFirstHomeTitle => 'हमारे पहले घर की चाबियां';

  @override
  String get demoFirstHomeStory =>
      'अभी फ़र्नीचर नहीं, बस डिब्बे, फ़र्श पर पिज़्ज़ा और ढेर सारे प्लान।';

  @override
  String get demoFirstHomePlace => 'लिंत्स';

  @override
  String get demoAlpineSummitTitle => 'बादलों के ऊपर';

  @override
  String get demoAlpineSummitStory => 'इसके लिए सुबह 4 बजे उठे। हर क़दम वसूल।';

  @override
  String get demoAlpineSummitPlace => 'ग्रॉसग्लॉकनर';

  @override
  String get demoFirstBikeTitle => 'पहली राइड, बिना हाथ';

  @override
  String get demoFirstBikeStory =>
      'तीन पैडल, थोड़ा डगमगाया, फिर निकल गया – और कितना गर्व से।';

  @override
  String get demoFirstBikePlace => 'प्राटर, वियना';

  @override
  String get demoGardenDinnerTitle => 'दादाजी का 80वां';

  @override
  String get demoGardenDinnerStory =>
      'एक लंबी मेज़ पर चार पीढ़ियां, और सबसे अच्छी कहानियां अब भी वही सुनाते रहे।';

  @override
  String get demoGardenDinnerPlace => 'वाखाउ';

  @override
  String get demoThreadFirstDanceToFirstHome => 'हमारी कहानी';

  @override
  String get demoThreadFirstHomeToNewborn => 'फिर लीना आई';

  @override
  String get demoThreadNewbornToBeachSunset => 'उसकी पहली गर्मियां';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'परिवार';

  @override
  String get demoThreadGraduationToFirstHome => 'नया अध्याय';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'छोटे-छोटे रोमांच';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'दादाजी देख रहे थे';

  @override
  String get demoRelationGrandpa => 'दादाजी';

  @override
  String get demoRelationGrandma => 'दादी';

  @override
  String get demoRelationDaughter => 'बेटी';

  @override
  String get demoRelationWife => 'पत्नी';

  @override
  String get demoRelationBestMan => 'बेस्ट मैन';

  @override
  String get demoRelationMother => 'मां';

  @override
  String savedToPath(Object label, Object path) {
    return '$label $path में सेव हुआ';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यादें अभी बैकअप में नहीं हैं।',
      one: '1 याद अभी बैकअप में नहीं है।',
    );
    return '$_temp0';
  }

  @override
  String get later => 'बाद में';

  @override
  String get backUp => 'बैकअप लें';

  @override
  String get onThisDayTitle => 'आज ही के दिन';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'आज से $years साल पहले',
      one: 'आज से 1 साल पहले',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years साल पहले',
      one: '1 साल पहले',
    );
    return 'आज ही के दिन · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'जिस दिन किसी पिछले साल की याद लौटती है, LifeThreads एक शांत रिमाइंडर भेजता है।';

  @override
  String get onThisDayReminderSwitch => 'रोज़ का रिमाइंडर';

  @override
  String onThisDayReminderAt(String time) {
    return '$time बजे';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'LifeThreads की नोटिफ़िकेशन बंद हैं। अपने फ़ोन की सेटिंग्स में इन्हें चालू करें।';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'आज से $years साल पहले: $title',
      one: 'आज से 1 साल पहले: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count और यादें',
      one: '1 और याद',
    );
    return '$title और इस दिन की $_temp0';
  }

  @override
  String get onThisDayChannelDescription =>
      'किसी पिछले साल में आज के दिन की याद।';

  @override
  String get benefitOnThisDayBody =>
      'जब किसी पिछले साल की याद लौटे तो रिमाइंडर, जो अपने ही अध्याय के रूप में खुलता है।';

  @override
  String get premiumFeatureStoryImage => 'स्टोरी इमेज';

  @override
  String get premiumFeatureStoryVideo => 'स्टोरी वीडियो';

  @override
  String get premiumFeatureThreadOfTheYear => 'साल का धागा';

  @override
  String get premiumFeatureFamilyWall => 'परिवार की दीवार';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature Premium का हिस्सा है।';
  }

  @override
  String get yearThreadTitle => 'साल का धागा';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यादें',
      one: '1 याद',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जगहें',
      one: '1 जगह',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोग',
      one: '1 व्यक्ति',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महीने',
      one: '1 महीना',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'सबसे ज़्यादा महसूस हुआ: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'एक साल, एक धागे में।';

  @override
  String get yearThreadMyYear => 'मेरा साल';

  @override
  String get yearThreadWallCardTitle => 'यादों में आपका साल';

  @override
  String yearThreadWallCardBody(String year) {
    return '$year को एक छोटी फ़िल्म बनाएं।';
  }

  @override
  String get yearThreadDismiss => 'अभी नहीं';

  @override
  String get yearThreadSettingsBody =>
      'कम से कम 3 यादों वाले किसी भी साल को एक छोटी फ़िल्म बनाएं, क्रम से और धागे से जुड़ी हुई।';

  @override
  String get yearThreadOpen => 'फ़िल्म बनाएं';

  @override
  String get yearThreadNoYears =>
      'साल का धागा के लिए कम से कम 3 यादों वाला साल चाहिए। पल सेव करते रहें और फिर आएं।';

  @override
  String get yearThreadYear => 'साल';

  @override
  String get yearThreadLength => 'लंबाई';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'फ़िल्म · $seconds सेकंड';
  }

  @override
  String get yearThreadLengthStory => 'स्टोरी · 20 सेकंड';

  @override
  String get yearThreadMusic => 'म्यूज़िक';

  @override
  String get yearThreadNoMusic => 'कोई म्यूज़िक नहीं';

  @override
  String get yearThreadInFilm => 'फ़िल्म में';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$max में से $count';
  }

  @override
  String get yearThreadAddMemory => 'याद जोड़ें';

  @override
  String get yearThreadSwap => 'बदलें';

  @override
  String get yearThreadRemove => 'हटाएं';

  @override
  String get yearThreadUseSuggestions => 'सुझाव इस्तेमाल करें';

  @override
  String yearThreadPickTitle(String year) {
    return '$year की एक याद चुनें';
  }

  @override
  String get yearThreadNoOthers => 'इस साल की हर याद पहले से फ़िल्म में है।';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यादें',
      one: '1 याद',
    );
    return 'कम से कम $_temp0 चुनें।';
  }

  @override
  String get yearThreadPreview => 'प्रीव्यू';

  @override
  String get yearThreadExportVideo => 'वीडियो एक्सपोर्ट करें';

  @override
  String get yearThreadExportImage => 'इमेज एक्सपोर्ट करें';

  @override
  String get yearThreadShare => 'शेयर करें';

  @override
  String get yearThreadSave => 'फ़ोटो में सेव करें';

  @override
  String get yearThreadMakingFilm => 'आपकी फ़िल्म बन रही है…';

  @override
  String get yearThreadMakingImage => 'आपकी इमेज बन रही है…';

  @override
  String get yearThreadFilmReady => 'आपकी फ़िल्म तैयार है';

  @override
  String get yearThreadImageReady => 'आपकी इमेज तैयार है';

  @override
  String get yearThreadSaved => 'आपकी फ़ोटो में सेव हो गया।';

  @override
  String get yearThreadExportFailed => 'यह नहीं हो पाया। कृपया फिर कोशिश करें।';

  @override
  String get yearThreadPlay => 'चलाएं';

  @override
  String get yearThreadPause => 'रोकें';

  @override
  String get createStory => 'स्टोरी बनाएं';

  @override
  String get storyPickTitle => 'यादें चुनें';

  @override
  String storyPickBody(int max) {
    return 'एक स्टोरी के लिए ज़्यादा से ज़्यादा $max यादें चुनें।';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$max में से $count चुनी गईं';
  }

  @override
  String storyPickLimit(int max) {
    return 'एक स्टोरी में ज़्यादा से ज़्यादा $max यादें होती हैं।';
  }

  @override
  String get storyPickContinue => 'जारी रखें';

  @override
  String get storyNoMemories => 'पहले एक याद सेव करें, फिर उसे स्टोरी बनाएं।';

  @override
  String get storyEditorTitle => 'आपकी स्टोरी';

  @override
  String get storyChangeMemories => 'यादें बदलें';

  @override
  String get storyTemplateSingle => 'एक-एक याद';

  @override
  String get storyTemplateThread => 'धागे वाली दीवार';

  @override
  String get storyTemplateCollage => 'कोलाज';

  @override
  String get storyTemplateQuote => 'शब्द';

  @override
  String get storySwipeHint => 'दूसरा लुक देखने के लिए स्वाइप करें';

  @override
  String get storyCaptionLabel => 'कैप्शन';

  @override
  String get storyCaptionHint => 'आपकी कहानी की एक लाइन';

  @override
  String get storyVideoSwitch => 'वीडियो';

  @override
  String get storyVideoBody =>
      'Stories और Reels के लिए मोशन और म्यूज़िक वाली छोटी फ़िल्म।';

  @override
  String get storyMusicTitle => 'म्यूज़िक';

  @override
  String get storyMusicNone => 'कोई म्यूज़िक नहीं';

  @override
  String get storyMusicNoneHint =>
      'पोस्ट करते समय आप Instagram में भी म्यूज़िक जोड़ सकते हैं।';

  @override
  String get storyMoodWarm => 'प्यार भरा';

  @override
  String get storyMoodJoyful => 'ख़ुशनुमा';

  @override
  String get storyMoodCalm => 'शांत';

  @override
  String get storyMoodNostalgic => 'पुरानी यादें';

  @override
  String get storyMoodEpic => 'शानदार';

  @override
  String get storyMoodEmotional => 'भावुक';

  @override
  String get storyMusicTrimHint =>
      'गाने का हिस्सा चुनने के लिए सुनहरा बॉक्स खींचें';

  @override
  String get storySearchHint => 'यादें, जगहें, साल खोजें';

  @override
  String storySearchEmpty(String query) {
    return '“$query” से कोई याद मेल नहीं खाती।';
  }

  @override
  String get storyMemoriesInStory => 'आपकी स्टोरी में';

  @override
  String get storyMemoriesReorderHint =>
      'क्रम बदलने के लिए दबाकर रखें और खींचें';

  @override
  String get storyAddMemory => 'जोड़ें';

  @override
  String get storyAddMemoryTitle => 'याद जोड़ें';

  @override
  String storyRemoveMemory(String title) {
    return '$title को स्टोरी से हटाएं';
  }

  @override
  String get storyAllMemoriesAdded => 'हर याद पहले से इस स्टोरी में है।';

  @override
  String get storyShare => 'शेयर करें';

  @override
  String get storySaveToPhotos => 'फ़ोटो में सेव करें';

  @override
  String get storySaved => 'आपकी फ़ोटो में सेव हो गया।';

  @override
  String get storySaveDenied =>
      'LifeThreads आपकी फ़ोटो में जोड़ नहीं सकता। अपने फ़ोन की सेटिंग्स में अनुमति दें।';

  @override
  String storyExportFailed(String error) {
    return 'स्टोरी नहीं बन सकी: $error';
  }

  @override
  String get storyRenderingTitle => 'आपकी फ़िल्म बन रही है';

  @override
  String get storyRenderingBody =>
      'LifeThreads खुला रखें, इसमें कुछ सेकंड लगते हैं।';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent%';
  }

  @override
  String get storyPreviewFree =>
      'प्रीव्यू फ़्री है। स्टोरी शेयर और सेव करना Premium का हिस्सा है।';

  @override
  String get benefitStoriesTitle => 'स्टोरी बनाएं';

  @override
  String get benefitStoriesBody =>
      'यादों को Instagram, WhatsApp वगैरह के लिए स्टोरी इमेज और म्यूज़िक वाली छोटी फ़िल्मों में बदलें।';

  @override
  String get musicCreditsTitle => 'म्यूज़िक क्रेडिट';

  @override
  String get musicCreditsBody =>
      'स्टोरी वीडियो के लिए शामिल गाने, उनके लाइसेंस के साथ।';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'आपका साल एक छोटी फ़िल्म में: अहम पल, क्रम से, म्यूज़िक के साथ।';

  @override
  String get benefitFamilyTitle => 'परिवार की दीवारें';

  @override
  String get benefitFamilyBody =>
      'आपके परिवार के लिए एक साझा दीवार, एंड-टू-एंड एन्क्रिप्टेड। हर कोई अपने पल जोड़ता है।';

  @override
  String get myWall => 'मेरी दीवार';

  @override
  String get myWallSubtitle => 'निजी, इस डिवाइस पर';

  @override
  String get switchWall => 'दीवार बदलें';

  @override
  String get familyWallsTitle => 'परिवार की दीवारें';

  @override
  String get familyWallsSettingsBody =>
      'परिवार या दोस्तों के साथ एक दीवार शेयर करें: सब यादें जोड़ते हैं, एंड-टू-एंड एन्क्रिप्टेड। मेरी दीवार इस डिवाइस पर निजी रहती है।';

  @override
  String get familyWallsOpen => 'परिवार की दीवारें खोलें';

  @override
  String get familyWallsManage => 'परिवार की दीवारें मैनेज करें';

  @override
  String get familyWallsHeadline => 'एक दीवार, पूरा परिवार';

  @override
  String get familyWallsIntro =>
      'परिवार की दीवार उन लोगों के साथ शेयर होती है जिन्हें आप बुलाते हैं। यादें और फ़ोटो अपलोड से पहले आपके फ़ोन पर एन्क्रिप्ट होती हैं; सिर्फ़ सदस्य उन्हें खोल सकते हैं। मेरी दीवार शेयर नहीं होती और इसी डिवाइस पर रहती है।';

  @override
  String get familyUnavailableTitle => 'अभी उपलब्ध नहीं';

  @override
  String get familyUnavailable =>
      'LifeThreads के इस वर्ज़न में परिवार की दीवारें अभी उपलब्ध नहीं हैं।';

  @override
  String get familySignInNeededTitle => 'परिवार की दीवारों के लिए साइन इन करें';

  @override
  String get familySignInNeededBody =>
      'साझा दीवार के लिए अकाउंट चाहिए ताकि परिवार जाने कि किसने क्या जोड़ा। मेरी दीवार बिना अकाउंट के चलती है।';

  @override
  String get familySignIn => 'साइन इन करें';

  @override
  String get familyLoadFailed => 'लोड नहीं हो सका';

  @override
  String get familyRetry => 'फिर कोशिश करें';

  @override
  String get familyNoWallsYet =>
      'अभी कोई परिवार की दीवार नहीं। नई बनाएं या इनवाइट लिंक से जुड़ें।';

  @override
  String get familyStartTitle => 'बनाएं या जुड़ें';

  @override
  String get familyStartBody =>
      'परिवार की दीवार बनाने के लिए Premium चाहिए। जुड़ना फ़्री है: बनाने वाले का Premium पूरे परिवार के लिए काफ़ी है।';

  @override
  String get familyCreateAction => 'परिवार की दीवार बनाएं';

  @override
  String get familyCreateTitle => 'नई परिवार की दीवार';

  @override
  String get familyNameLabel => 'दीवार का नाम';

  @override
  String get familyNameHint => 'जैसे शर्मा परिवार';

  @override
  String get familyMyNameLabel => 'इस दीवार पर आपका नाम';

  @override
  String get familyMyNameHelper =>
      'सदस्य इसे आपकी यादों पर देखते हैं। यह दीवार की हर चीज़ की तरह एन्क्रिप्टेड है।';

  @override
  String get familyMyNameSaved => 'नाम सेव हो गया।';

  @override
  String get familySetMyName => 'मेरा नाम';

  @override
  String get familyCheckingSubscription => 'आपका Premium जांचा जा रहा है…';

  @override
  String get familyCreating => 'दीवार बन रही है…';

  @override
  String get familyJoinWithLink => 'लिंक से जुड़ें';

  @override
  String get familyInviteLinkLabel => 'इनवाइट लिंक';

  @override
  String get familyJoinTitle => 'इस परिवार की दीवार से जुड़ें?';

  @override
  String get familyJoinBody =>
      'सदस्य आपका नाम और आपकी जोड़ी यादें देखेंगे, और आप उनकी। आप कभी भी छोड़ सकते हैं।';

  @override
  String get familyJoinAction => 'जुड़ें';

  @override
  String get familyJoining => 'जुड़ रहे हैं…';

  @override
  String familyJoined(String family) {
    return 'आप $family से जुड़ गए।';
  }

  @override
  String get familyRoleOwner => 'मालिक';

  @override
  String get familyRoleMember => 'सदस्य';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'दीवार की सेटिंग्स';

  @override
  String familyStorageUsed(String used, String total) {
    return '$total में से $used इस्तेमाल';
  }

  @override
  String get familyRename => 'नाम बदलें';

  @override
  String get familyInviteTitle => 'बुलाएं';

  @override
  String get familyInviteBody =>
      'किसी भरोसेमंद को लिंक भेजें। हर लिंक एक बार चलता है और 7 दिन बाद ख़त्म हो जाता है।';

  @override
  String get familyInviteAction => 'इनवाइट लिंक बनाएं';

  @override
  String get familyCreatingInvite => 'इनवाइट बन रहा है…';

  @override
  String get familyInviteReady => 'इनवाइट लिंक तैयार है';

  @override
  String get familyInviteValidity =>
      'एक बार चलता है और ज़्यादा से ज़्यादा 7 दिन बाद ख़त्म हो जाता है।';

  @override
  String get familyInviteKeyWarning =>
      'लिंक में दीवार की चाबी है: जो भी इसे खोलेगा, वह जुड़कर दीवार पढ़ सकता है। इसे सिर्फ़ उसी को भेजें जिसे आप बुला रहे हैं।';

  @override
  String get familyInviteShare => 'लिंक शेयर करें';

  @override
  String get familyInviteCopy => 'लिंक कॉपी करें';

  @override
  String get familyInviteCopied => 'लिंक कॉपी हो गया।';

  @override
  String get familyInviteShareFailed =>
      'शेयर करना उपलब्ध नहीं है। लिंक कॉपी कर लें।';

  @override
  String familyInviteSubject(String family) {
    return 'LifeThreads पर $family से जुड़ें';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'LifeThreads पर हमारी परिवार की दीवार “$family” से जुड़ें: $link';
  }

  @override
  String get familyMembersTitle => 'सदस्य';

  @override
  String get familyMemberActions => 'सदस्य के विकल्प';

  @override
  String get familyYou => 'आप';

  @override
  String familyYouNamed(String name) {
    return '$name (आप)';
  }

  @override
  String get familyAMember => 'एक सदस्य';

  @override
  String get familyFormerMember => 'पूर्व सदस्य';

  @override
  String get familyBlocked => 'ब्लॉक किया गया';

  @override
  String get familyBlock => 'ब्लॉक करें';

  @override
  String get familyUnblock => 'अनब्लॉक करें';

  @override
  String familyBlockAuthor(String name) {
    return '$name को ब्लॉक करें';
  }

  @override
  String familyBlockQuestion(String name) {
    return '$name को ब्लॉक करें?';
  }

  @override
  String get familyBlockBody =>
      'आपको किसी भी परिवार की दीवार पर उनकी यादें नहीं दिखेंगी। उन्हें बताया नहीं जाएगा। आप सदस्य सूची में उन्हें अनब्लॉक कर सकते हैं।';

  @override
  String get familyReport => 'रिपोर्ट करें';

  @override
  String get familyRemoveMember => 'दीवार से हटाएं';

  @override
  String familyRemoveQuestion(String name) {
    return '$name को हटाएं?';
  }

  @override
  String get familyRemoveBody =>
      'उनका इस दीवार से एक्सेस हट जाएगा। वापस लाने के लिए फिर से बुलाएं।';

  @override
  String get familyRemoveDeleteContent => 'उनकी जोड़ी यादें भी हटाएं';

  @override
  String get familyDeleteTitle => 'परिवार की दीवार हटाएं';

  @override
  String get familyDeleteBody =>
      'मालिक होने के नाते आप दीवार छोड़ नहीं सकते; आप इसे सबके लिए हटा सकते हैं।';

  @override
  String get familyDeleteAction => 'दीवार हटाएं';

  @override
  String familyDeleteQuestion(String family) {
    return '$family हटाएं?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'इस दीवार की सारी यादें और फ़ोटो हर सदस्य के लिए हमारे सर्वर से हट जाएंगी। इसे वापस नहीं लाया जा सकता। मेरी दीवार की यादों पर कोई असर नहीं।';

  @override
  String get familyDeleting => 'हटाया जा रहा है…';

  @override
  String get familyLeaveTitle => 'परिवार की दीवार छोड़ें';

  @override
  String get familyLeaveBody =>
      'आपको यह दीवार दिखनी बंद हो जाएगी। अपनी जोड़ी यादें रख सकते हैं या हटा सकते हैं।';

  @override
  String get familyLeaveAction => 'छोड़ें';

  @override
  String familyLeaveQuestion(String family) {
    return '$family छोड़ें?';
  }

  @override
  String get familyLeaveConfirmBody => 'वापस आने के लिए नया इनवाइट चाहिए होगा।';

  @override
  String get familyLeaveDeleteMine => 'मेरी जोड़ी यादें भी हटाएं';

  @override
  String get familyLeaving => 'छोड़ रहे हैं…';

  @override
  String get familySignInTitle => 'साइन इन';

  @override
  String get familySignInHeadline => 'परिवार की दीवारों के लिए अकाउंट';

  @override
  String get familySignInWhy =>
      'परिवार की दीवार साझा होती है, इसलिए अकाउंट चाहिए: सदस्य देखते हैं कि हर याद किसने जोड़ी, और सिर्फ़ सदस्य दीवार खोल सकते हैं।';

  @override
  String get familySignInMyWallStays =>
      'मेरी दीवार को अकाउंट नहीं चाहिए। यह इस डिवाइस पर निजी रहती है और कभी अपलोड नहीं होती।';

  @override
  String get familySignInEncrypted =>
      'परिवार की यादें और फ़ोटो एंड-टू-एंड एन्क्रिप्टेड हैं। GK Coding इन्हें स्टोर करता है पर पढ़ नहीं सकता।';

  @override
  String get familySignInWhatWeGet =>
      'Apple या Google से हम सिर्फ़ अकाउंट ID लेते हैं, आपके कॉन्टैक्ट या फ़ोटो नहीं।';

  @override
  String get familySignInApple => 'Apple से साइन इन करें';

  @override
  String get familySignInGoogle => 'Google से साइन इन करें';

  @override
  String get familySignInFinePrint =>
      'साइन इन करके आप उपयोग की शर्तें और प्राइवेसी पॉलिसी मानते हैं। आप ऐप में कभी भी अपना अकाउंट हटा सकते हैं।';

  @override
  String get familyAccountTitle => 'अकाउंट';

  @override
  String get familySignedOutTitle => 'साइन इन नहीं है';

  @override
  String get familySignedOutBody =>
      'अपनी परिवार की दीवारें देखने के लिए साइन इन करें। मेरी दीवार बिना अकाउंट के चलती है।';

  @override
  String get familySignedInTitle => 'साइन इन है';

  @override
  String get familySignedInBody =>
      'आपका अकाउंट सिर्फ़ परिवार की दीवारों के लिए इस्तेमाल होता है।';

  @override
  String familyAccountId(String id) {
    return 'अकाउंट ID: $id';
  }

  @override
  String get familySignOut => 'साइन आउट करें';

  @override
  String get familySignOutQuestion => 'साइन आउट करें?';

  @override
  String get familySignOutBody =>
      'दोबारा साइन इन करने तक परिवार की दीवारें और उनकी चाबियां इस डिवाइस से हट जाएंगी। सर्वर पर कुछ नहीं हटता। मेरी दीवार पर कोई असर नहीं।';

  @override
  String get familySigningOut => 'साइन आउट हो रहा है…';

  @override
  String get familyDeleteAccountTitle => 'अकाउंट हटाएं';

  @override
  String get familyDeleteAccountBody =>
      'आपका अकाउंट और परिवार की दीवारों का डेटा हमारे सर्वर से हटा देता है। मेरी दीवार इस डिवाइस पर रहती है।';

  @override
  String get familyDeleteAccount => 'अकाउंट हटाएं';

  @override
  String get familyDeleteAccountQuestion => 'अपना अकाउंट हटाएं?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'आपकी $count परिवार की दीवारें उनके सभी सदस्यों के लिए, हर याद और फ़ोटो के साथ, हट जाएंगी।',
      one:
          'आपकी परिवार की दीवार उसके सभी सदस्यों के लिए, हर याद और फ़ोटो के साथ, हट जाएगी।',
      zero: 'आपकी कोई परिवार की दीवार नहीं है।',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'दूसरे परिवारों की दीवारों पर जोड़ी आपकी यादें और फ़ोटो हट जाएंगी, और आप उन दीवारों को छोड़ देंगे।';

  @override
  String get familyDeleteAccountKeys =>
      'परिवार की दीवारों की चाबियां और कैश की गई फ़ोटो इस डिवाइस से हट जाएंगी। इसे वापस नहीं लाया जा सकता।';

  @override
  String get familyDeleteAccountMyWall =>
      'मेरी दीवार पर कोई असर नहीं: उसकी यादें इस डिवाइस पर रहती हैं।';

  @override
  String get familyDeleteAccountSubscription =>
      'इससे Premium सब्सक्रिप्शन रद्द नहीं होता; इसे App Store या Google Play में मैनेज करें।';

  @override
  String get familyDeleteAccountUnderstood =>
      'मैं समझता/समझती हूं कि इससे मेरा अकाउंट हमेशा के लिए हट जाएगा।';

  @override
  String get familyDeletingAccount => 'आपका अकाउंट हटाया जा रहा है…';

  @override
  String get familyAccountDeleted => 'आपका अकाउंट हटा दिया गया।';

  @override
  String get familyTermsTitle => 'परिवार की दीवार के नियम';

  @override
  String get familyTermsHeadline => 'शेयर करने से पहले';

  @override
  String get familyTermsIntro =>
      'परिवार की दीवारें उन लोगों के लिए हैं जिन्हें आप बुलाते हैं। इन्हें सुरक्षित रखने के लिए सब ये नियम मानते हैं:';

  @override
  String get familyTermsZeroTolerance =>
      'आपत्तिजनक सामग्री बिल्कुल नहीं: उत्पीड़न, नफ़रत, यौन सामग्री, हिंसा, ख़ुद को नुक़सान, ग़ैरक़ानूनी सामग्री या बिना सहमति किसी और की निजी जानकारी नहीं।';

  @override
  String get familyTermsOwnContent =>
      'सिर्फ़ वही फ़ोटो और कहानियां शेयर करें जिन्हें शेयर करने का आपको हक़ है।';

  @override
  String get familyTermsReport =>
      'दीवार से किसी भी याद या सदस्य की रिपोर्ट करें। GK Coding 24 घंटे में रिपोर्ट देखता है।';

  @override
  String get familyTermsBlock =>
      'किसी सदस्य की यादें न देखनी हों तो उसे ब्लॉक करें।';

  @override
  String get familyTermsOwner =>
      'दीवार का मालिक सदस्यों और उनकी यादों को हटा सकता है।';

  @override
  String get familyTermsConsequences =>
      'नियम तोड़ने वाली सामग्री हटाई जाती है, और उसे पोस्ट करने वाले अकाउंट सस्पेंड या डिलीट किए जा सकते हैं।';

  @override
  String get familyTermsReadFull => 'पूरी शर्तें पढ़ें';

  @override
  String get familyTermsAgree =>
      'मैं उपयोग की शर्तें और ये नियम मानता/मानती हूं।';

  @override
  String get familyTermsAccept => 'मानें और आगे बढ़ें';

  @override
  String familyTermsVersion(String version) {
    return 'शर्तों का वर्ज़न $version';
  }

  @override
  String get familyWallEmptyTitle => 'दीवार इंतज़ार कर रही है';

  @override
  String get familyWallEmptyBody =>
      'पहली याद जोड़ें। इस दीवार पर सब इसे देखेंगे।';

  @override
  String get familyWallGoneBody =>
      'यह परिवार की दीवार अब आपके लिए उपलब्ध नहीं है। हो सकता है यह हटा दी गई हो, या आपको हटा दिया गया हो।';

  @override
  String get familyAddMemory => 'याद जोड़ें';

  @override
  String get familyRefresh => 'रिफ़्रेश करें';

  @override
  String get familySyncing => 'सिंक हो रहा है…';

  @override
  String get familyOffline => 'ऑफ़लाइन: सेव यादें दिख रही हैं';

  @override
  String get familySyncFailed => 'सिंक नहीं हुआ';

  @override
  String get familyMemoryTitle => 'याद';

  @override
  String get familyMemoryGone => 'यह याद अब दीवार पर नहीं है।';

  @override
  String get familyMemoryActions => 'याद के विकल्प';

  @override
  String familyAddedBy(String name) {
    return '$name ने जोड़ी';
  }

  @override
  String get familyDeleteMemoryQuestion => 'यह याद हटाएं?';

  @override
  String get familyDeleteMemoryBody =>
      'यह अपनी फ़ोटो के साथ सबके लिए दीवार से हट जाएगी।';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'मालिक होने के नाते आप इस दीवार से यादें हटा सकते हैं। $name की यह याद अपनी फ़ोटो के साथ सबके लिए हट जाएगी।';
  }

  @override
  String get familyDeletingMemory => 'याद हटाई जा रही है…';

  @override
  String get familyNoPhotosYet => 'अभी कोई फ़ोटो नहीं';

  @override
  String get familyPostNote =>
      'इस दीवार पर सब यह याद देखेंगे। फ़ोटो अपलोड से पहले आपके फ़ोन पर छोटी और एन्क्रिप्ट की जाती हैं।';

  @override
  String get familyPost => 'पोस्ट करें';

  @override
  String get familyPostMemory => 'दीवार पर पोस्ट करें';

  @override
  String get familyUploading => 'एन्क्रिप्ट और अपलोड हो रहा है…';

  @override
  String get familyMemorySaved => 'परिवार की दीवार पर सेव हो गई।';

  @override
  String get familyConflictTitle => 'किसी और ने बदला';

  @override
  String get familyConflictBody =>
      'आपके बदलते समय यह याद किसी दूसरे डिवाइस पर बदल गई। नया वर्ज़न लोड करके उस पर अपने बदलाव सेव करें?';

  @override
  String get familyConflictRetry => 'रिफ़्रेश करके सेव करें';

  @override
  String get familyQuotaTitle => 'दीवार भर गई है';

  @override
  String get familyReportMemoryTitle => 'याद की रिपोर्ट करें';

  @override
  String get familyReportPhotoTitle => 'फ़ोटो की रिपोर्ट करें';

  @override
  String get familyReportMemberTitle => 'सदस्य की रिपोर्ट करें';

  @override
  String get familyReportIntro =>
      'बताएं क्या ग़लत है। आपकी रिपोर्ट GK Coding को जाती है, जिसकी रिपोर्ट कर रहे हैं उसे नहीं।';

  @override
  String get familyReportSpam => 'स्पैम या धोखाधड़ी';

  @override
  String get familyReportHarassment => 'उत्पीड़न या बुलिंग';

  @override
  String get familyReportHate => 'नफ़रत भरी बातें';

  @override
  String get familyReportSexual => 'यौन सामग्री या नग्नता';

  @override
  String get familyReportViolence => 'हिंसा या धमकी';

  @override
  String get familyReportSelfHarm => 'ख़ुद को नुक़सान या आत्महत्या';

  @override
  String get familyReportIllegal => 'ग़ैरक़ानूनी सामग्री';

  @override
  String get familyReportPrivacy => 'बिना सहमति शेयर की गई निजी जानकारी';

  @override
  String get familyReportOther => 'कुछ और';

  @override
  String get familyReportDetailsLabel => 'विवरण (वैकल्पिक)';

  @override
  String get familyReportDetailsHint => 'हमें क्या जानना चाहिए?';

  @override
  String familyReportAlsoBlock(String name) {
    return '$name को भी ब्लॉक करें';
  }

  @override
  String get familyReportSend => 'रिपोर्ट भेजें';

  @override
  String get familyReportReviewNote =>
      'GK Coding हर रिपोर्ट 24 घंटे में देखता है और नियम तोड़ने वाली सामग्री और सदस्यों को हटाता है।';

  @override
  String get familyReportSentTitle => 'धन्यवाद';

  @override
  String get familyReportSentBody =>
      'आपकी रिपोर्ट भेज दी गई। GK Coding इसे 24 घंटे में देखता है और नियम तोड़ने वाली सामग्री पर कार्रवाई करता है।';

  @override
  String get familyErrorGeneric => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get familyErrorOffline =>
      'लगता है आप ऑफ़लाइन हैं। कनेक्शन जांचकर फिर कोशिश करें।';

  @override
  String get familyErrorSubscriptionRequired =>
      'इसके लिए दीवार के मालिक का चालू Premium सब्सक्रिप्शन चाहिए।';

  @override
  String get familyErrorInviteExpired =>
      'यह इनवाइट ख़त्म हो चुका है। नया लिंक मांगें।';

  @override
  String get familyErrorInviteUsed =>
      'यह इनवाइट पहले इस्तेमाल हो चुका है। हर लिंक एक बार चलता है; नया मांगें।';

  @override
  String get familyErrorInviteInvalid =>
      'यह LifeThreads का मान्य इनवाइट लिंक नहीं है।';

  @override
  String get familyErrorAlreadyMember =>
      'आप पहले से इस परिवार की दीवार के सदस्य हैं।';

  @override
  String get familyErrorFamilyFull =>
      'यह परिवार की दीवार सदस्यों की सीमा तक पहुंच गई है।';

  @override
  String get familyErrorQuotaExceeded =>
      'इस परिवार की दीवार में जगह नहीं बची। जगह बनाने के लिए कुछ यादें या फ़ोटो हटाएं।';

  @override
  String get familyErrorVersionConflict =>
      'किसी ने यह याद पहले बदल दी। रिफ़्रेश करके फिर कोशिश करें।';

  @override
  String get familyErrorTermsRequired =>
      'कृपया पहले परिवार की दीवार के नियम मानें।';

  @override
  String get familyErrorSignedOut =>
      'आप साइन आउट हो गए। कृपया फिर से साइन इन करें।';

  @override
  String get familyErrorNotAllowed => 'आप इस दीवार पर यह नहीं कर सकते।';

  @override
  String get familyErrorNotFound => 'परिवार की दीवार नहीं मिली';

  @override
  String get familyErrorOwnerCannotLeave =>
      'मालिक दीवार नहीं छोड़ सकता, पर उसे हटा सकता है।';

  @override
  String get familyPaste => 'पेस्ट करें';

  @override
  String get familyErrorInviteRevoked =>
      'यह इनवाइट वापस ले लिया गया। नया लिंक मांगें।';

  @override
  String get familyErrorKeyMissing =>
      'इस डिवाइस पर इस परिवार की दीवार की चाबी नहीं है (जैसे दोबारा इंस्टॉल करने के बाद या नए फ़ोन पर)। किसी सदस्य से नया इनवाइट लिंक मांगें: उसे खोलने से एक्सेस वापस मिल जाता है।';

  @override
  String get familyErrorSignInUnavailable =>
      'इस डिवाइस पर अभी साइन इन उपलब्ध नहीं है।';

  @override
  String get familyErrorNoPurchase =>
      'इस App Store या Google Play अकाउंट पर कोई Premium ख़रीदारी नहीं मिली। पहले Premium लें, फिर कोशिश करें।';

  @override
  String get familyErrorVerificationUnavailable =>
      'आपका Premium अभी जांचा नहीं जा सका। कृपया बाद में कोशिश करें।';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'यह Premium ख़रीदारी पहले से किसी दूसरे परिवार की दीवार अकाउंट से जुड़ी है। उस अकाउंट से साइन इन करें, या info@gkcoding.dev पर संपर्क करें।';

  @override
  String get familyErrorNameTooLong =>
      'यह नाम बहुत लंबा है। कृपया छोटा नाम लिखें।';

  @override
  String get familyErrorContentNotAllowed =>
      'इसमें ऐसे शब्द हैं जो परिवार की दीवारों पर मना हैं। टेक्स्ट बदलकर फिर कोशिश करें।';

  @override
  String get familyErrorPhotoUnreadable =>
      'एक फ़ोटो पढ़ी नहीं जा सकी। उसे हटाकर फिर कोशिश करें।';

  @override
  String get familyErrorTooLarge =>
      'यह अपलोड के लिए बहुत बड़ा है। कम या छोटी फ़ोटो आज़माएं।';

  @override
  String get familyReportEvidenceNote =>
      'जांच के लिए GK Coding को आपकी रिपोर्ट के साथ इस याद का टाइटल और कहानी मिलती है। इसकी फ़ोटो कभी नहीं भेजी जातीं।';

  @override
  String get moveLeft => 'बाएं ले जाएं';

  @override
  String get moveUp => 'ऊपर ले जाएं';

  @override
  String get moveDown => 'नीचे ले जाएं';

  @override
  String get moveRight => 'दाएं ले जाएं';

  @override
  String get showPassword => 'पासवर्ड दिखाएं';

  @override
  String get hidePassword => 'पासवर्ड छिपाएं';

  @override
  String get removePerson => 'व्यक्ति हटाएं';

  @override
  String get draftKept => 'ड्राफ़्ट के रूप में रखा – अगली बार यहीं मिलेगा।';

  @override
  String get draftResumeTitle => 'जहां छोड़ा था वहीं से जारी रखें?';

  @override
  String draftResumeBody(String date) {
    return 'आपने $date को एक याद शुरू की थी और अभी सेव नहीं की।';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ोटो',
      one: '1 फ़ोटो',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => 'ड्राफ़्ट जारी रखें';

  @override
  String get draftStartNew => 'नई शुरू करें';

  @override
  String get lookBackMenu => 'एक महीना पलटकर देखें';

  @override
  String lookBackTitle(String month) {
    return 'आपका $month';
  }

  @override
  String get lookBackWallCardTitle => 'यादों में आपका महीना';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यादें',
      one: '1 याद',
    );
    return '$month: $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यादें',
      one: '1 याद',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोग',
      one: '1 व्यक्ति',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जगहें',
      one: '1 जगह',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => 'कौन साथ था';

  @override
  String get lookBackPlacesHeading => 'आप कहां थे';

  @override
  String lookBackEmpty(String month) {
    return '$month से अभी कुछ सेव नहीं है।';
  }

  @override
  String get lookBackEmptyHint =>
      'इस महीने की तारीख़ वाली यादें यहां दिखती हैं।';

  @override
  String get lookBackPreviousMonth => 'पिछला महीना';

  @override
  String get lookBackNextMonth => 'अगला महीना';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count यादें',
      one: '1 याद',
    );
    return '$month: पलटकर देखने के लिए $_temp0।';
  }

  @override
  String get lookBackNotificationPrivate => 'यादों में आपका महीना तैयार है।';

  @override
  String get homeWidgetLocked => 'अपनी यादें देखने के लिए LifeThreads खोलें।';

  @override
  String get homeWidgetSettingsTitle => 'होम स्क्रीन विजेट';

  @override
  String get homeWidgetSettingsSubtitle => 'यह कौन-सी यादें दिखाता है';

  @override
  String get homeWidgetPreviewTitle => 'आज आपके विजेट पर';

  @override
  String get homeWidgetSourceTitle => 'कौन-सी यादें';

  @override
  String get homeWidgetAllWalls => 'मेरी सभी दीवारें';

  @override
  String get homeWidgetOrderTitle => 'पहले दिखाएं';

  @override
  String get homeWidgetOnThisDayFirst => 'पहले आज ही के दिन';

  @override
  String get homeWidgetOnThisDayFirstBody =>
      'किसी पिछले साल में आज के दिन की याद पहले आती है।';

  @override
  String get homeWidgetPhotosFirst => 'पहले फ़ोटो वाली यादें';

  @override
  String get homeWidgetPhotosFirstBody =>
      'बाक़ी सिर्फ़ तब, जब किसी में फ़ोटो न हो।';

  @override
  String get homeWidgetHowToTitle => 'इसे होम स्क्रीन पर जोड़ें';

  @override
  String get homeWidgetHowToIos =>
      'होम स्क्रीन पर LifeThreads आइकन दबाकर रखें और विजेट का साइज़ चुनें। या किसी ख़ाली जगह को दबाकर रखें, बदलें › विजेट जोड़ें टैप करें और LifeThreads चुनें।';

  @override
  String get homeWidgetHowToAndroid =>
      'होम स्क्रीन पर किसी ख़ाली जगह को दबाकर रखें, विजेट टैप करें और LifeThreads को जहां चाहें वहां खींचें।';

  @override
  String get homeWidgetPrivacyNote =>
      'छिपी यादें कभी विजेट पर नहीं दिखतीं। ऐप लॉक चालू होने पर यह कोई याद नहीं दिखाता।';

  @override
  String get yearThreadAlmostThere => 'बस थोड़ा और';

  @override
  String get yearThreadMemoriesFrom => 'यादें इस साल की';

  @override
  String yearThreadAddMemoryTo(String year) {
    return '$year में एक याद जोड़ें';
  }

  @override
  String get onboardingHangTitle => 'अपनी यादें टांगें';

  @override
  String get onboardingHangText =>
      'एक फ़ोटो, एक जगह, वहां मौजूद लोग – आपकी दीवार आपकी ज़िंदगी के साथ बढ़ती है।';

  @override
  String get onboardingConnectTitle => 'इन्हें धागों से जोड़ें';

  @override
  String get onboardingConnectText =>
      'बताएं कि दो पल साथ क्यों हैं। धागे दिखाते हैं कि आपकी कहानी कैसे जुड़ती है।';

  @override
  String get onboardingComeBackTitle => 'यादें आपके पास लौटती हैं';

  @override
  String get onboardingComeBackText =>
      'आज ही के दिन, आपका महीना पलटकर, आपका साल एक फ़िल्म में – और होम स्क्रीन पर एक विजेट।';

  @override
  String get onboardingPrivateText =>
      'कोई अकाउंट नहीं। सब कुछ आपके फ़ोन पर रहता है – चाहें तो Face ID के साथ।';

  @override
  String get onboardingNameStaysHere =>
      'सिर्फ़ आपका स्वागत करने के लिए – यह इसी फ़ोन पर रहता है।';

  @override
  String get tutorialLookBackTitle => 'खोजें और पलटकर देखें';

  @override
  String get tutorialLookBackText =>
      'टाइटल, जगह, व्यक्ति या साल से खोजें। और › एक महीना पलटकर देखें एक महीने की यादें दिखाता है; और › साल का धागा एक साल को फ़िल्म बनाता है।';

  @override
  String get tutorialStoryTitle => 'स्टोरी बनाएं';

  @override
  String get tutorialStoryText =>
      'और › स्टोरी बनाएं: यादें, टेम्पलेट और म्यूज़िक चुनें, फिर इमेज या वीडियो के रूप में शेयर करें।';

  @override
  String get tutorialWallsTitle => 'दीवारें और छिपी यादें';

  @override
  String get tutorialWallsText =>
      'और › नई दीवार सफ़र या दौर अलग रखती है (Premium)। कार्ड दबाकर रखें › छिपाएं उसे नज़र से हटाता है; देखें › छिपी यादें उसे Face ID के बाद दिखाता है।';

  @override
  String get tutorialFamilyTitle => 'परिवार के साथ शेयर करें';

  @override
  String get tutorialFamilyText =>
      'और › परिवार की दीवारें: पूरे परिवार के लिए एक दीवार, एंड-टू-एंड एन्क्रिप्टेड। दूसरों को लिंक से बुलाएं।';

  @override
  String get tutorialWidgetTitle => 'होम स्क्रीन पर एक याद';

  @override
  String get tutorialWidgetText =>
      'LifeThreads विजेट जोड़ें: हर दिन एक अलग याद। सेटिंग्स › होम स्क्रीन विजेट में चुनें कौन-सी।';

  @override
  String photoNumber(int number) {
    return 'फ़ोटो $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'इस दीवार पर आपका नाम सेव नहीं हो सका। आप इसे दीवार की सेटिंग्स में सेट कर सकते हैं।';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'इसमें $count यादें हैं।',
      one: 'इसमें 1 याद है।',
    );
    return '$_temp0 जो यादें पहले से आपकी दीवारों पर हैं, वे बनी रहेंगी और दो बार नहीं जुड़ेंगी।';
  }

  @override
  String get importAction => 'इंपोर्ट करें';

  @override
  String get familyRemovingMember => 'हटाकर दीवार सुरक्षित की जा रही है…';

  @override
  String get tourSkip => 'छोड़ें';

  @override
  String get tourNext => 'आगे';

  @override
  String get tourDone => 'हो गया';

  @override
  String get tourTapIt => 'टैप करें';

  @override
  String get tourEnd => 'टूर ख़त्म करें';

  @override
  String get tourShowMeHow => 'मुझे दिखाएं';

  @override
  String get tourShowMeHowSubtitle => 'सैंपल यादों के साथ छोटा टूर';

  @override
  String get tourWelcomeTitle => 'अपनी दीवार पर स्वागत है';

  @override
  String get tourWelcomeBody =>
      'आइए सैंपल यादों और डेमो फ़ोटो के साथ LifeThreads साथ में देखें। सुनहरे घेरे के पीछे चलें। आख़िर में आप तय करेंगे कि इन्हें रखना है या नहीं।';

  @override
  String get tourCardTitle => 'हर कार्ड एक याद है';

  @override
  String get tourCardBody =>
      'फ़ोटो, एक कहानी, जगह और वह एहसास। कार्ड खींचकर सजाएं, ज़ूम के लिए पिंच करें। इसे खोलने के लिए टैप करें।';

  @override
  String get tourConnectTitle => 'यादें जोड़ें';

  @override
  String get tourConnectBody =>
      'धागे पलों को जोड़ते हैं: एक सफ़र को एक व्यक्ति से, एक जगह को एक एहसास से। जोड़ें टैप करें।';

  @override
  String get tourConnectionsTitle => 'चुनें क्या साथ है';

  @override
  String get tourConnectionsBody =>
      'दूसरी यादें चुनें और लिखें कि वे साथ क्यों हैं। फिर धागा आपकी दीवार पर कार्डों के बीच लटकता है।';

  @override
  String get tourAddTitle => 'नया पल सेव करें';

  @override
  String get tourAddBody => 'अपनी दीवार पर कुछ जोड़ने के लिए + टैप करें।';

  @override
  String get tourAddMemoryTitle => 'एक याद';

  @override
  String get tourAddMemoryBody =>
      'याद चुनें। कार्डों को समूह में रखने के लिए आप नोट या कील भी लगा सकते हैं।';

  @override
  String get tourAddTextTitle => 'कुछ शब्द काफ़ी हैं';

  @override
  String get tourAddTextBody =>
      'हमने आपके लिए एक डेमो फ़ोटो और टाइटल जोड़ा है। आम तौर पर आप अपनी फ़ोटो चुनते हैं या एक खींचते हैं। तारीख़ और जगह फ़ोटो से आती हैं।';

  @override
  String get tourSaveTitle => 'दीवार पर टांगें';

  @override
  String get tourSaveBody =>
      'अभी सेव करें टैप करें। एहसास, लोग और धागे बाद में आ सकते हैं।';

  @override
  String get tourCameraTitle => 'क्विक फ़ोटो';

  @override
  String get tourCameraBody =>
      'कैमरा तुरंत एक पल सेव करता है। शब्द आप बाद में जोड़ें।';

  @override
  String get tourViewTitle => 'अलग-अलग व्यू';

  @override
  String get tourViewBody => 'देखें टैप करें।';

  @override
  String get tourViewModesTitle => 'दीवार, टाइमलाइन, मैप';

  @override
  String get tourViewModesBody =>
      'अपनी ज़िंदगी को दीवार, टाइमलाइन या मैप पर देखें। यहां कैटेगरी से फ़िल्टर करें और छिपी यादें दिखाएं (Face ID से)।';

  @override
  String get tourViewDoneTitle => 'दीवार पर वापस';

  @override
  String get tourViewDoneBody => 'हो गया टैप करें।';

  @override
  String get tourSearchTitle => 'कोई भी याद ढूंढें';

  @override
  String get tourSearchBody =>
      'यहां नाम, जगह, व्यक्ति या साल लिखें। लिखते ही नतीजे दिखते हैं।';

  @override
  String get tourMoreTitle => 'बाक़ी सब';

  @override
  String get tourMoreBody =>
      'स्टोरी, आपका साल, पलटकर देखना, और दीवारें और सेटिंग्स इस मेन्यू में हैं। इसे टैप करें।';

  @override
  String get tourStoryTitle => 'स्टोरी बनाएं';

  @override
  String get tourStoryBody => 'स्टोरी बनाएं टैप करें।';

  @override
  String get tourYearTitle => 'साल का धागा';

  @override
  String get tourYearBody =>
      'आपका साल म्यूज़िक वाली छोटी फ़िल्म में: आपकी यादें क्रम से, फिर साल की जगहें, लोग और एहसास (Premium)।';

  @override
  String get tourLookBackTitle => 'एक महीना पलटकर देखें';

  @override
  String get tourLookBackBody =>
      'हर महीना यादों में, उसके लोगों और जगहों के साथ। आज ही के दिन आपको पिछले सालों की याद दिलाता है (Premium)।';

  @override
  String get tourWallsTitle => 'और दीवारें';

  @override
  String get tourWallsBody =>
      'हर बच्चे, सफ़र या प्रोजेक्ट के लिए एक दीवार (Premium)। दीवार बदलने के लिए ऊपर नाम पर टैप करें।';

  @override
  String get tourFamilyTitle => 'परिवार की दीवारें';

  @override
  String get tourFamilyBody =>
      'एक साझा दीवार जहां हर कोई अपने पल जोड़ता है, एंड-टू-एंड एन्क्रिप्टेड। सिर्फ़ बनाने वाले को Premium चाहिए; परिवार फ़्री में जुड़ता है।';

  @override
  String get tourSettingsTitle => 'सेटिंग्स';

  @override
  String get tourSettingsBody =>
      'सब कुछ फ़्री में बैकअप करें, Face ID से ऐप लॉक करें, होम स्क्रीन विजेट और आज ही के दिन सेट करें, और अपनी भाषा चुनें।';

  @override
  String get tourFinishTitle => 'बस इतना ही!';

  @override
  String get tourFinishBody => 'अब आप सब जानते हैं। अब दीवार को अपना बनाएं।';

  @override
  String get tourDemoPhotoTitle => 'झील पर एक दिन';

  @override
  String get tourRemoveDemoTitle => 'अपनी दीवार शुरू करें?';

  @override
  String get tourRemoveDemoBody =>
      'टूर में सैंपल यादें और डेमो फ़ोटो इस्तेमाल हुईं। इन्हें अभी हटाकर अपनी फ़ोटो से शुरू करें?';

  @override
  String get tourRemoveDemoRemove => 'हटाएं और शुरू करें';

  @override
  String get tourRemoveDemoKeep => 'अभी रहने दें';

  @override
  String get tourRemovedToast => 'सैंपल यादें हटा दी गईं। आपकी दीवार तैयार है।';

  @override
  String get storyTemplatePolaroid => 'पोलरॉइड';

  @override
  String get storyTemplateAlbum => 'एल्बम';

  @override
  String get storyTemplateFilmstrip => 'फ़िल्म स्ट्रिप';

  @override
  String get storyTemplateTimeline => 'टाइम ट्रैवल';

  @override
  String get storyTemplatePostcard => 'पोस्टकार्ड';

  @override
  String get storyTemplateCinema => 'सिनेमा';

  @override
  String get storyTemplateSingleHint => 'हर याद फ़ुल स्क्रीन, एक के बाद एक';

  @override
  String get storyTemplateThreadHint => 'दीवार पर कार्ड, धागे से जुड़े';

  @override
  String get storyTemplateCollageHint => 'सारी फ़ोटो एक ग्रिड में';

  @override
  String get storyTemplateQuoteHint => 'आपके शब्द ख़ुद टाइप होते हैं';

  @override
  String get storyTemplatePolaroidHint => 'इंस्टेंट फ़ोटो एक ढेर पर गिरती हैं';

  @override
  String get storyTemplateAlbumHint => 'पन्ने पलटते हैं, हर पन्ने पर एक फ़ोटो';

  @override
  String get storyTemplateFilmstripHint => 'फ़िल्म गुज़रती है और ज़ूम होती है';

  @override
  String get storyTemplateTimelineHint => 'साल गिनते हुए हर याद तक';

  @override
  String get storyTemplatePostcardHint =>
      'हर पोस्टकार्ड पलटकर अपनी कहानी दिखाता है';

  @override
  String get storyTemplateCinemaHint => 'टाइटल कार्ड, धीमा ज़ूम और क्रेडिट';

  @override
  String get storyAnimationTitle => 'एनिमेशन';

  @override
  String get storyAnimationPageTitle => 'एनिमेशन चुनें';

  @override
  String get storyAnimationExamples =>
      'सैंपल फ़ोटो के साथ दिखाया गया। आपकी स्टोरी में आपकी यादें होंगी।';

  @override
  String get storyMusicPageTitle => 'म्यूज़िक और लंबाई';

  @override
  String get storyLengthTitle => 'लंबाई';

  @override
  String get storyLengthAuto => 'ऑटो';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds सेकंड';
  }

  @override
  String get storyMusicAll => 'सभी';

  @override
  String get storyMusicPlay => 'चलाएं';

  @override
  String get storyMusicPause => 'रोकें';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return 'गाना $song ▸ वीडियो $video';
  }

  @override
  String get storyMusicSyncHint =>
      'सफ़ेद लाइन दिखाती है कि गाने का कौन-सा सेकंड वीडियो के साथ बज रहा है। निशान वहां हैं जहां हर याद शुरू होती है।';

  @override
  String get storyMusicLengthHint =>
      'ऑटो यादों की संख्या के हिसाब से चलता है। लंबी फ़िल्में धीरे चलती हैं।';

  @override
  String get tourBack => 'वापस';

  @override
  String get tourStoryPickTitle => 'यादें चुनें';

  @override
  String get tourStoryPickBody =>
      'हमने आपके लिए तीन चुनी हैं। आप छह तक चुन सकते हैं। जारी रखें टैप करें।';

  @override
  String get tourStoryAnimationTitle => 'चुनें यह कैसे चले';

  @override
  String get tourStoryAnimationBody =>
      'पोलरॉइड से सिनेमा तक एनिमेशन। एनिमेशन टैप करें।';

  @override
  String get tourStoryStyleTitle => 'पोलरॉइड आज़माएं';

  @override
  String get tourStoryStyleBody =>
      'हर टाइल एक प्रीव्यू चलाती है। पोलरॉइड टैप करें।';

  @override
  String get tourStoryMusicTitle => 'म्यूज़िक जोड़ें';

  @override
  String get tourStoryMusicBody =>
      'गाना और वीडियो की लंबाई चुनें। म्यूज़िक टैप करें।';

  @override
  String get tourStoryTrimTitle => 'गाना और वीडियो साथ-साथ';

  @override
  String get tourStoryTrimBody =>
      'गाने का हिस्सा चुनने के लिए सुनहरा बॉक्स खींचें। सफ़ेद लाइन वीडियो के साथ चलती है, ताकि दिखे कि कब कौन-सा सेकंड बजता है।';

  @override
  String get tourStoryMusicDoneTitle => 'अपनी स्टोरी पर वापस';

  @override
  String get tourStoryMusicDoneBody => 'हो गया टैप करें।';

  @override
  String get tourStoryShareTitle => 'शेयर या सेव करें';

  @override
  String get tourStoryShareBody =>
      'Instagram, WhatsApp वगैरह के लिए तैयार। सेव और शेयर करना Premium का हिस्सा है।';

  @override
  String get tourMoreAgainTitle => 'मेन्यू में और भी';

  @override
  String get tourMoreAgainBody => 'मेन्यू एक बार और खोलें। इसे टैप करें।';

  @override
  String get scannerStep1 => 'टीवी, कंप्यूटर या टैबलेट पर वेब ब्राउज़र खोलें।';

  @override
  String scannerStep2(Object url) {
    return '$url पर जाएं। वहां एक QR कोड दिखेगा।';
  }

  @override
  String get scannerStep3 =>
      'फ़ोन ऐसे पकड़ें कि कोड सुनहरे फ़्रेम के अंदर रहे। फिर आपकी दीवार वहां कुछ देर, सिर्फ़ देखने के लिए, दिखेगी।';

  @override
  String get scannerShareLink => 'लिंक भेजें';

  @override
  String get scannerCopyLink => 'लिंक कॉपी करें';

  @override
  String get scannerLinkCopied => 'लिंक कॉपी हो गया';

  @override
  String get storyTemplateScrapbook => 'स्क्रैपबुक';

  @override
  String get storyTemplateMosaic => 'मोज़ेक';

  @override
  String get storyTemplateContactSheet => 'कॉन्टैक्ट शीट';

  @override
  String get storyTemplateWallFlight => 'दीवार पर उड़ान';

  @override
  String get storyTemplateCarousel => 'कैरोसेल';

  @override
  String get storyTemplateJourney => 'सफ़रनामा';

  @override
  String get storyTemplateScrapbookHint => 'हर फ़ोटो पन्ने पर टेप से चिपकी';

  @override
  String get storyTemplateMosaicHint => 'एक बड़ी फ़ोटो, बाक़ी आसपास';

  @override
  String get storyTemplateContactSheetHint => 'हर याद फ़िल्म का एक फ़्रेम';

  @override
  String get storyTemplateWallFlightHint =>
      'धागे के साथ कार्ड से कार्ड तक उड़ान';

  @override
  String get storyTemplateCarouselHint => 'कार्ड घूमते हैं, एक-एक करके आगे';

  @override
  String get storyTemplateJourneyHint => 'मैप पर एक रास्ता, हर जगह पर एक पिन';

  @override
  String get storyModePicture => 'इमेज';

  @override
  String get storyModeVideo => 'वीडियो';

  @override
  String get storyModePictureHint =>
      'आपकी सारी यादों वाली एक इमेज, पोस्ट और स्टोरी के लिए।';

  @override
  String get storyModeVideoHint => 'मोशन और म्यूज़िक वाली छोटी फ़िल्म।';

  @override
  String get storyLayoutTitle => 'लेआउट';

  @override
  String get storyLayoutPageTitle => 'लेआउट चुनें';

  @override
  String get storyChoosePhoto => 'स्टोरी के लिए फ़ोटो चुनें';

  @override
  String get wallTidyUp => 'दीवार व्यवस्थित करें';

  @override
  String get wallTidyUpBody =>
      'क्या सभी कार्ड सबसे पुरानी याद से नई याद तक पंक्तियों में सलीके से टाँग दें? नोट और कीलें अपनी जगह पर रहेंगी।';

  @override
  String get wallTidyUpAction => 'व्यवस्थित करें';

  @override
  String get wallTidiedToast => 'आपकी दीवार व्यवस्थित हो गई।';

  @override
  String get storyFormatTitle => 'आकार';

  @override
  String get storyFormatStory => 'स्टोरी 9:16';

  @override
  String get storyFormatPost => 'पोस्ट 4:5';

  @override
  String get storyFormatSquare => 'वर्ग 1:1';
}
