// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get send => 'إرسال';

  @override
  String get preparing => 'جار التحضير...';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get languageBody =>
      'اختر لغة التطبيق. خيار النظام يتبع لغة الهاتف عندما يدعمها LifeThreads.';

  @override
  String get systemLanguage => 'النظام';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return 'تم تغيير اللغة إلى $language.';
  }

  @override
  String get privacyTitle => 'الخصوصية';

  @override
  String get privacyBody =>
      'LifeThreads يعمل محلياً أولاً: بلا حساب وبلا ملف عام. تبقى ذكرياتك على هذا الجهاز إلا إذا صدّرت نسخة احتياطية أو شاركت كبسولة مشفّرة أو عرضت جدارك على شاشة أخرى.';

  @override
  String get viewPrivacyPolicy => 'عرض سياسة الخصوصية';

  @override
  String get termsTitle => 'شروط الاستخدام';

  @override
  String get viewTerms => 'عرض الشروط';

  @override
  String get betaFeedbackTitle => 'ملاحظات بيتا';

  @override
  String get betaFeedbackBody =>
      'أرسل ملاحظات بيتا مع تشخيصات آمنة. السجلات تتضمن أحداث التطبيق وأنواع الأعطال فقط، ولا تتضمن نصوص الذكريات أو مسارات الصور أو النسخ الاحتياطية أو المواقع الدقيقة.';

  @override
  String get closedBetaBadge => 'بيتا مغلقة';

  @override
  String get sendFeedback => 'إرسال الملاحظات';

  @override
  String get backupArchiveBody =>
      'احفظ كل شيء – الذكريات والصور والملاحظات والخيوط وترتيب الجدار – في ملف واحد. احتفظ به على حاسوبك أو في سحابتك الخاصة، وأضف كلمة مرور لتشفيره.';

  @override
  String get backupArchiveTitle => 'النسخ الاحتياطي';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'فتح';

  @override
  String get exportArchive => 'تصدير الأرشيف';

  @override
  String get importArchive => 'استيراد أرشيف';

  @override
  String get importCapsule => 'استيراد كبسولة';

  @override
  String get moveDevices => 'نقل الأجهزة';

  @override
  String get themeTitle => 'المظهر';

  @override
  String get themeBody =>
      'اختر إحساس جدارك الخاص. المستخدم المجاني يحصل على Warm Memory Room. Premium يفتح كل أجواء الجدار.';

  @override
  String get oneFreeBadge => '1 مجاني';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'اشتراك Premium مفعّل.';

  @override
  String get premiumLockedBody =>
      'اشتراك شهري: ذكريات غير محدودة، ومظاهر Premium، وتخطيطات متقدمة.';

  @override
  String get activeBadge => 'مفعّل';

  @override
  String get openPremium => 'فتح Premium';

  @override
  String get appVersionTitle => 'إصدار التطبيق';

  @override
  String get clearAllDataTitle => 'حذف كل البيانات';

  @override
  String get clearAllDataBody =>
      'احذف كل الذكريات والروابط وملاحظات الجدار والمسامير والصور المنسوخة من هذا الجهاز.';

  @override
  String get clearData => 'حذف البيانات';

  @override
  String exportFailed(Object error) {
    return 'فشل التصدير: $error';
  }

  @override
  String importRejected(Object message) {
    return 'تم رفض الاستيراد: $message';
  }

  @override
  String importFailed(Object error) {
    return 'فشل الاستيراد: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'فشل الحذف: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'تم رفض الكبسولة: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'فشل استيراد الكبسولة: $error';
  }

  @override
  String get clearAllDataQuestion => 'حذف كل البيانات؟';

  @override
  String get clearAllDataQuestionBody =>
      'هذا يزيل نهائياً كل بيانات LifeThreads المحلية على هذا الجهاز. صدّر نسخة احتياطية أولاً إذا كنت تريد الاحتفاظ بها.';

  @override
  String get clearAll => 'حذف الكل';

  @override
  String get allLocalDataCleared => 'تم حذف كل البيانات المحلية.';

  @override
  String get feedbackGeneral => 'ملاحظات عامة';

  @override
  String get feedbackBug => 'خلل';

  @override
  String get feedbackCrash => 'تعطل';

  @override
  String get feedbackDesign => 'مشكلة تصميم';

  @override
  String get feedbackMissingFeature => 'ميزة ناقصة';

  @override
  String get feedbackPerformance => 'الأداء';

  @override
  String get betaFeedbackIntro =>
      'اكتب ماذا حدث أو ما الذي بدا غير صحيح. سيتم إرفاق تشخيصات آمنة بدون محتوى ذكريات خاص.';

  @override
  String get feedbackType => 'النوع';

  @override
  String get feedbackLabel => 'الملاحظات';

  @override
  String get feedbackHint => 'مثال: ضغطت Add > Quick photo فتجمدت الشاشة.';

  @override
  String get betaFeedbackNotIncluded =>
      'غير مرفق: عناوين الذكريات، القصص، الملاحظات، مسارات الصور، مسارات النسخ الاحتياطية، المواقع الدقيقة.';

  @override
  String get feedbackEmpty => 'اكتب رسالة ملاحظات قصيرة أولاً.';

  @override
  String get feedbackCopied =>
      'لم يتم فتح تطبيق بريد. تم نسخ الملاحظات إلى الحافظة من أجل info@gkcoding.dev.';

  @override
  String themeSelected(Object theme) {
    return 'تم اختيار $theme.';
  }

  @override
  String get onboardingHeadline => 'ابنِ جدار ذكرياتك الحي.';

  @override
  String get onboardingBody =>
      'غرفة ذكريات خاصة يمكن أن تتجمع فيها الصور والأماكن والأشخاص والملاحظات الصغيرة بخيوط عاطفية.';

  @override
  String get onboardingPrivacy =>
      'ذكرياتك تبقى خاصة افتراضياً: بلا حساب وبلا ملف عام. المشاركة السحابية المشفّرة والنسخ الاحتياطي اختياريان ولا يحدثان إلا عندما تختارهما.';

  @override
  String get onboardingPrivacyShort =>
      'بلا حساب وبلا ملف عام. ذكرياتك تبقى على هذا الجهاز ما لم تختر غير ذلك.';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingNameTitle => 'بماذا نناديك؟';

  @override
  String get onboardingNameHint => 'اسمك';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'سررنا بلقائك، $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'اختر كيف تبدأ';

  @override
  String get onboardingGetStartedBody =>
      'عاين جداراً تجريبياً، أو ابدأ بجدار فارغ وعلّق ذكرياتك.';

  @override
  String get settingsNameTitle => 'اسمك';

  @override
  String get settingsNameBody => 'يظهر كتحية على جدارك.';

  @override
  String get settingsNameHint => 'اسمك';

  @override
  String get settingsNameSaved => 'تم تحديث الاسم.';

  @override
  String get storyPrivacyTitle => 'ذكرياتك تبقى خاصة';

  @override
  String get storyConnectTitle => 'اربط اللحظات';

  @override
  String get storyConnectText =>
      'اربط الذكريات والملاحظات والأماكن حتى يصبح لكل فصل سياقه.';

  @override
  String get storyWallTitle => 'ابنِ جدار ذكرياتك الحي';

  @override
  String get storyWallText =>
      'ابدأ بصورة واحدة، ثم دع الجدار ينمو إلى شيء يشعر بأنه حي.';

  @override
  String get previewDemoWall => 'معاينة جدار تجريبي';

  @override
  String get startFresh => 'بدء جديد';

  @override
  String get optionalDemoPreview => 'معاينة تجريبية اختيارية';

  @override
  String get quickTutorial => 'شرح سريع';

  @override
  String get tutorialIntro =>
      'المسار الأساسي: احفظ الذكريات، اربط المتشابه منها، ثم رتّب الجدار.';

  @override
  String get gotIt => 'فهمت';

  @override
  String get howItWorks => 'كيف يعمل';

  @override
  String get tutorialAddTitle => 'أضف ذكرى';

  @override
  String get tutorialAddText =>
      'اضغط إضافة، اختر ذكرى أو صورة سريعة، ثم احفظ العنوان والتاريخ والأشخاص والصورة.';

  @override
  String get tutorialConnectTitle => 'اربط الذكريات';

  @override
  String get tutorialConnectText =>
      'افتح بطاقة، اضغط أيقونة الربط، اختر الذكريات المرتبطة، وأضف سبباً قصيراً.';

  @override
  String get tutorialArrangeTitle => 'رتّب الجدار';

  @override
  String get tutorialArrangeText =>
      'اسحب البطاقات والملاحظات والمسامير إلى مكانها. الروابط الحقيقية ترسم الحبال خلف العناصر.';

  @override
  String get tutorialShowBoardTitle => 'اعرض اللوحة';

  @override
  String get tutorialShowBoardText =>
      'افتح lifethreads.gkcoding.dev/display على شاشة أخرى، اضغط زر QR في أدوات الجدار، ثم امسح الرمز لعرض لوحة مؤقتة للقراءة فقط.';

  @override
  String get tutorialBackupTitle => 'احتفظ بنسخة احتياطية';

  @override
  String get tutorialBackupText =>
      'قبل تغيير هاتفك، صدّر نسخة احتياطية من الإعدادات واحفظ الملف في مكان آمن.';

  @override
  String get scanDisplayQr => 'مسح QR للعرض';

  @override
  String get scannerHintTitle =>
      'افتح lifethreads.gkcoding.dev/display على شاشة أخرى.';

  @override
  String get scannerHintBody =>
      'امسح رمز QR من تلك الصفحة. يرسل LifeThreads لقطة مؤقتة للوحة للقراءة فقط إلى جلسة المتصفح هذه.';

  @override
  String get addMemoryBeforeDisplay => 'أضف ذكرى قبل عرض الجدار.';

  @override
  String get notLifeThreadsDisplayQr => 'هذا ليس رمز QR لعرض LifeThreads.';

  @override
  String get displayWallQuestion => 'عرض هذا الجدار؟';

  @override
  String displayWallBody(int memoryCount) {
    return 'سيرسل LifeThreads لقطة مؤقتة للوحة للقراءة فقط تحتوي على $memoryCount ذكريات إلى جلسة المتصفح التي مسحتها. تُفتح على lifethreads.gkcoding.dev/display وتنتهي تلقائياً.';
  }

  @override
  String get displayAction => 'عرض';

  @override
  String get soon => 'قريباً';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'عرض الجدار مباشر مع $memoryCount ذكريات حتى $expires.';
  }

  @override
  String get preparingWallDisplay => 'جار تحضير عرض الجدار...';

  @override
  String get open => 'فتح';

  @override
  String get edit => 'تعديل';

  @override
  String get save => 'حفظ';

  @override
  String get done => 'تم';

  @override
  String get back => 'رجوع';

  @override
  String get continueAction => 'متابعة';

  @override
  String get close => 'إغلاق';

  @override
  String get add => 'إضافة';

  @override
  String get saveReason => 'حفظ السبب';

  @override
  String get chooseBackup => 'اختيار نسخة';

  @override
  String get chooseArchive => 'اختيار أرشيف';

  @override
  String get chooseCapsule => 'اختيار كبسولة';

  @override
  String get exportAction => 'تصدير';

  @override
  String get addToWall => 'إضافة إلى الجدار';

  @override
  String get cinemaSkip => 'تخطي';

  @override
  String get cinemaNotNow => 'ليس الآن';

  @override
  String get cinemaSharedChapter => 'فصل ذكرى مشتركة';

  @override
  String get cinemaConnectedThread => 'خيط متصل';

  @override
  String get cinemaInviteTitle => 'إضافة هذه الذكرى إلى جدارك؟';

  @override
  String get useSelected => 'استخدام المحدد';

  @override
  String get noPhotosFound => 'لم يتم العثور على صور.';

  @override
  String get manage => 'إدارة';

  @override
  String get manageAccess => 'إدارة الوصول';

  @override
  String get saveNow => 'احفظ الآن';

  @override
  String get hangOnWall => 'علّق على الجدار';

  @override
  String get placeHere => 'ضع هنا';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get viewPremium => 'عرض Premium';

  @override
  String get memoryNotFound => 'لم يتم العثور على الذكرى';

  @override
  String get memoryTypeMoment => 'لحظة';

  @override
  String get memoryTypeTrip => 'رحلة';

  @override
  String get memoryTypePerson => 'شخص';

  @override
  String get memoryTypePlace => 'مكان';

  @override
  String get memoryTypeNote => 'ملاحظة';

  @override
  String get memoryTypeMomentDescription => 'مشهد صغير يستحق الحفظ';

  @override
  String get memoryTypeTripDescription => 'رحلة أو يوم خارج المنزل';

  @override
  String get memoryTypePersonDescription => 'شخص مهم';

  @override
  String get memoryTypePlaceDescription => 'مكان يحمل معنى';

  @override
  String get memoryTypeNoteDescription => 'فكرة أو اقتباس أو تذكير';

  @override
  String get categoryPersonal => 'شخصي';

  @override
  String get categoryFamily => 'عائلة';

  @override
  String get categoryTravel => 'سفر';

  @override
  String get feelingWarm => 'دافئ';

  @override
  String get feelingNostalgic => 'حنين';

  @override
  String get feelingProud => 'فخر';

  @override
  String get feelingCalm => 'هدوء';

  @override
  String get feelingImportant => 'مهم';

  @override
  String get feelingWarmDescription => 'ناعم وقريب ومليء بالمحبة.';

  @override
  String get feelingNostalgicDescription => 'ذكرى تعيدك إلى الماضي.';

  @override
  String get feelingProudDescription => 'لحظة أثبتت شيئاً.';

  @override
  String get feelingCalmDescription => 'هادئة وآمنة ومطمئنة.';

  @override
  String get feelingImportantDescription => 'ذكرى غيّرت القصة.';

  @override
  String get addPeopleHint =>
      'أضف الأشخاص الذين ينتمون لهذه اللحظة. جهات الاتصال تبقى محلية.';

  @override
  String get addPerson => 'إضافة شخص';

  @override
  String get editPerson => 'تعديل شخص';

  @override
  String get chooseFromContacts => 'اختيار من جهات الاتصال';

  @override
  String get personNameLabel => 'الاسم';

  @override
  String get personNameHint => 'اكتب للبحث في الأشخاص المحفوظين';

  @override
  String get relationshipLabel => 'العلاقة';

  @override
  String get relationshipHint => 'صديق، أم، شريك...';

  @override
  String get phoneOptionalLabel => 'الهاتف (اختياري)';

  @override
  String get emailOptionalLabel => 'البريد (اختياري)';

  @override
  String get nameRelationshipRequired => 'الاسم والعلاقة مطلوبان.';

  @override
  String get contactAccessDenied => 'لم يتم منح وصول جهات الاتصال.';

  @override
  String get couldNotOpenContacts => 'تعذر فتح جهات الاتصال.';

  @override
  String get chooseContact => 'اختر جهة اتصال';

  @override
  String get searchContacts => 'البحث في جهات الاتصال';

  @override
  String get noContactsFound => 'لم يتم العثور على جهات اتصال.';

  @override
  String get unnamedContact => 'جهة اتصال بدون اسم';

  @override
  String get contactRelationship => 'جهة اتصال';

  @override
  String get couldNotLoadContacts => 'تعذر تحميل جهات الاتصال.';

  @override
  String get saveMomentTitle => 'حفظ لحظة';

  @override
  String get todayEyebrow => 'اليوم';

  @override
  String get addMemoryStepTitle => 'ماذا حدث ولا تريد أن تفقده؟';

  @override
  String get addMemoryStepSubtitle =>
      'اكتب سطراً واحداً، أضف صورة إن وجدت، ثم احفظ. التفاصيل يمكن أن تنتظر.';

  @override
  String get momentLabel => 'اللحظة';

  @override
  String get momentHint => 'عشاء مع لارا، أول إطلاق، مشي هادئ...';

  @override
  String get storyWorthLabel => 'ما الذي جعلها تستحق الحفظ؟';

  @override
  String get storyWorthHint => 'بضع كلمات تكفي.';

  @override
  String get feelingEyebrow => 'الشعور';

  @override
  String get feelingStepTitle => 'كيف يجب أن تشعر عندما تعود؟';

  @override
  String get feelingStepSubtitle => 'هذا يجعل العثور على الذكرى لاحقاً أسهل.';

  @override
  String get contextEyebrow => 'السياق';

  @override
  String get whenWasItTitle => 'متى كان ذلك؟';

  @override
  String get photoGpsStepSubtitle =>
      'الخريطة تستخدم GPS المحفوظ داخل الصور المحددة. إذا لم تحتوي الصورة على GPS فلن يظهر مكان.';

  @override
  String get peopleThreadsEyebrow => 'أشخاص وخيوط';

  @override
  String get peopleThreadsTitle => 'من أو ماذا يرتبط بهذا؟';

  @override
  String get peopleThreadsSubtitle =>
      'التفاصيل الاختيارية تحول اللحظات المفردة إلى خيط حياة.';

  @override
  String get connectExistingMemoryLabel => 'ربط بذكرى موجودة';

  @override
  String get noConnectionYet => 'لا يوجد ربط بعد';

  @override
  String get connectionReasonLabel => 'لماذا هما مرتبطان؟';

  @override
  String get connectionReasonHint =>
      'مثال: نفس الرحلة، نفس الشخص، قبل / بعد...';

  @override
  String get writeMomentOrPhotoFirst => 'اكتب لحظة أو أضف صورة أولاً.';

  @override
  String get todaysMoment => 'لحظة اليوم';

  @override
  String get savedFromTodaysPrompt => 'تم الحفظ من سؤال اليوم.';

  @override
  String get saveItBeforeItFades => 'احفظها قبل أن تتلاشى';

  @override
  String get chooseDate => 'اختيار التاريخ';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get untitledMemory => 'ذكرى بدون عنوان';

  @override
  String get organize => 'تنظيم';

  @override
  String get memoryShape => 'شكل الذكرى';

  @override
  String get wallCategory => 'تصنيف الجدار';

  @override
  String get privatePhotos => 'صور خاصة';

  @override
  String get pick => 'اختيار';

  @override
  String get addMore => 'إضافة المزيد';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get takePhotosNow => 'التقاط صور الآن';

  @override
  String get takePhotosFabTooltip => 'التقاط صور لذكرى جديدة';

  @override
  String get takeAnotherPhoto => 'التقاط صورة أخرى';

  @override
  String get continueWithPhotos => 'المتابعة بهذه الصور';

  @override
  String get addPhotosToMemory => 'إضافة إلى الذكرى';

  @override
  String get takeAnotherOrContinueBody =>
      'استمر بالتصوير لهذه الذكرى، أو تابع وأضف القصة.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم التقاط $count صور',
      one: 'تم التقاط صورة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'ينسخ LifeThreads الصور المحددة إلى تخزين التطبيق الخاص ويحافظ على بيانات التاريخ/الموقع عند توفرها.';

  @override
  String get limitedPhotoAccessActive =>
      'وصول الصور المحدود مفعّل. يمكنك إضافة صور مسموحة أخرى.';

  @override
  String get selectPhotos => 'اختر الصور';

  @override
  String get photoAccessOff => 'وصول الصور مغلق';

  @override
  String get photoAccessOffBody =>
      'فعّل وصول الصور لاختيار الذكريات. صورك تبقى على هذا الجهاز.';

  @override
  String get freeMemoryLimitReached => 'تم الوصول إلى حد الذكريات المجاني';

  @override
  String get freeMemoryLimitBody =>
      'الجدران المجانية تتضمن 30 ذكرى. قم بالترقية لمتابعة بناء جدارك الحي.';

  @override
  String get photoAccessNeeded => 'يجب منح وصول الصور أولاً.';

  @override
  String get quickPhotoMemory => 'ذكرى صورة سريعة';

  @override
  String get quickPhotoDescription => 'صورة تستحق الحفظ. أضف القصة لاحقاً.';

  @override
  String get hangQuickPhoto => 'تعليق صورة سريعة';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'تم العثور على GPS في الصورة: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'لم يتم العثور على GPS في الصورة. لن تظهر هذه الذكرى على الخريطة.';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • $photoCount صورة';
  }

  @override
  String metadataDates(int count, int total) {
    return '$count/$total تواريخ';
  }

  @override
  String metadataLocations(int count, int total) {
    return '$count/$total مواقع';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total أحجام';
  }

  @override
  String newSelected(int count) {
    return '$count محدد جديد';
  }

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String get editMemoryTitle => 'تعديل الذكرى';

  @override
  String get storyPanel => 'القصة';

  @override
  String get memoryTitleLabel => 'عنوان الذكرى';

  @override
  String get addTitleValidation => 'أضف عنواناً';

  @override
  String get storyDescriptionLabel => 'القصة / الوصف';

  @override
  String get addStoryValidation => 'أضف قصة قصيرة';

  @override
  String get shapeFeelingTitle => 'الشكل والشعور';

  @override
  String get memoryTypeLabel => 'نوع الذكرى';

  @override
  String get feelingLabel => 'الشعور';

  @override
  String get categoryLabel => 'التصنيف';

  @override
  String get timePhotoGpsTitle => 'الوقت و GPS الصورة';

  @override
  String get memoryDateLabel => 'تاريخ الذكرى';

  @override
  String get peopleTitle => 'الأشخاص';

  @override
  String get galleryTitle => 'المعرض';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get saveMemory => 'حفظ الذكرى';

  @override
  String get memorySaveFailed => 'تعذّر حفظ هذه الذكرى. حاول مرة أخرى.';

  @override
  String get passwordOnlySpaces =>
      'لا يمكن أن تتكون كلمة المرور من مسافات فقط.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get mapUnavailable => 'الخريطة غير متاحة الآن.';

  @override
  String get coverPhoto => 'صورة الغلاف';

  @override
  String get galleryPhoto => 'صورة المعرض';

  @override
  String get setAsCover => 'تعيين كغلاف';

  @override
  String get replacePhoto => 'استبدال الصورة';

  @override
  String get removePhoto => 'إزالة الصورة';

  @override
  String get choosePhoto => 'اختيار صورة';

  @override
  String get threadReasonsTitle => 'أسباب الخيوط';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'أنشئ المزيد من الذكريات قبل الربط.';

  @override
  String get connectionHeaderBody =>
      'اربط الذكريات بسبب واضح. يجب أن يشرح الحبل لماذا تنتمي اللحظتان معاً.';

  @override
  String get connectedMemory => 'ذكرى مرتبطة';

  @override
  String get whyConnectedTitle => 'لماذا هما مرتبطان؟';

  @override
  String get exportPremiumArchiveTitle => 'تصدير نسخة احتياطية';

  @override
  String get importArchiveTitle => 'استيراد أرشيف';

  @override
  String get archiveExportBody =>
      'أضف كلمة مرور لتشفير الأرشيف. اتركه فارغاً لملف ZIP محلي عادي.';

  @override
  String get archiveImportBody =>
      'إذا كان هذا الأرشيف مشفراً، أدخل كلمة المرور. اتركه فارغاً للنسخ القديمة أو غير المحمية.';

  @override
  String get archivePasswordOptional => 'كلمة مرور الأرشيف (اختياري)';

  @override
  String get archivePasswordLabel => 'كلمة مرور الأرشيف';

  @override
  String get archivePasswordWarning =>
      'احتفظ بكلمة المرور في مكان آمن. لا يمكن استعادتها إذا فقدتها.';

  @override
  String get sendArchiveTitle => 'إرسال أرشيف LifeThreads';

  @override
  String get sendArchiveSubject => 'أرشيف ذكريات LifeThreads';

  @override
  String get sendEncryptedArchiveText =>
      'أرشيف LifeThreads مشفر. استخدم كلمة المرور التي اخترتها لاستيراده على جهاز آخر.';

  @override
  String get sendArchiveText =>
      'أرشيف LifeThreads. استورده في LifeThreads لفتح جدار ذكرياتك على جهاز آخر.';

  @override
  String get archiveReadyToSend =>
      'النسخة الاحتياطية جاهزة. احفظها في مكان آمن خارج هذا الهاتف.';

  @override
  String get archiveNotSaved =>
      'لم تُحفظ النسخة الاحتياطية. صدّرها مرة أخرى عندما تكون جاهزاً.';

  @override
  String get archiveSharingUnavailable => 'المشاركة غير متاحة على هذا الجهاز.';

  @override
  String archiveShareFailed(Object error) {
    return 'تم حفظ الأرشيف، لكن فشلت المشاركة: $error';
  }

  @override
  String get archiveImportedTitle => 'تم استيراد الأرشيف';

  @override
  String get memoriesLabel => 'الذكريات';

  @override
  String get photosLabel => 'الصور';

  @override
  String get wallNotesNailsLabel => 'ملاحظات الجدار / المسامير';

  @override
  String get connectionsLabel => 'الروابط';

  @override
  String get archiveImportSummary =>
      'تم الاحتفاظ بجدارك الحالي. أضيفت الذكريات المستوردة بأمان.';

  @override
  String get shareEncryptedCapsuleTitle => 'مشاركة كبسولة مشفرة';

  @override
  String get openSharedCapsuleTitle => 'فتح كبسولة مشتركة';

  @override
  String get exportMemoryCapsuleTitle => 'تصدير كبسولة ذكرى';

  @override
  String get importCapsuleDialogTitle => 'استيراد كبسولة';

  @override
  String get secureSharePasswordBody =>
      'أنشئ كلمة مرور قبل رفع هذه الكبسولة. أرسل كلمة المرور بشكل منفصل للشخص المستلم.';

  @override
  String get sharedCapsulePasswordBody =>
      'أدخل كلمة المرور التي استلمتها لهذه الذكرى المشتركة.';

  @override
  String get capsuleExportBody =>
      'أضف كلمة مرور إذا كانت هذه الذكرى يجب أن تكون محمية قبل إرسالها. اتركه فارغاً لكبسولة عادية.';

  @override
  String get capsuleImportBody =>
      'إذا كانت هذه الكبسولة تحتوي على كلمة مرور، أدخلها. وإلا اتركه فارغاً.';

  @override
  String get capsulePasswordLabel => 'كلمة مرور الكبسولة';

  @override
  String get sharedCapsulePasswordLabel => 'كلمة مرور الكبسولة المشتركة';

  @override
  String get capsulePasswordOptional => 'كلمة مرور الكبسولة (اختياري)';

  @override
  String get capsulePasswordWarning =>
      'لا يستطيع LifeThreads استعادة كلمة المرور هذه لاحقاً.';

  @override
  String get passwordRequiredCloudSharing =>
      'كلمة المرور مطلوبة للمشاركة السحابية.';

  @override
  String get createSecureShare => 'إنشاء مشاركة آمنة';

  @override
  String get previewMemory => 'معاينة الذكرى';

  @override
  String get sendCapsuleTitle => 'مشاركة ذكرى LifeThreads';

  @override
  String get sendCapsuleSubject => 'كبسولة ذكرى LifeThreads';

  @override
  String get sendEncryptedCapsuleText =>
      'مرحباً، شاركت معك ذكرى LifeThreads محمية. استخدم كلمة المرور التي أرسلتها لك لاستيرادها.';

  @override
  String get sendCapsuleText =>
      'مرحباً، شاركت معك ذكرى LifeThreads. استورد الكبسولة في LifeThreads لإضافتها إلى جدارك.';

  @override
  String get capsuleReadyToSend => 'الكبسولة جاهزة للإرسال.';

  @override
  String get capsuleSavedLater => 'تم حفظ الكبسولة. يمكنك مشاركتها لاحقاً.';

  @override
  String get capsuleSharingUnavailable =>
      'تم حفظ الكبسولة، لكن المشاركة غير متاحة.';

  @override
  String capsuleShareFailed(Object error) {
    return 'تم حفظ الكبسولة، لكن فشلت المشاركة: $error';
  }

  @override
  String get importThisMemory => 'استيراد هذه الذكرى؟';

  @override
  String get noStoryTextIncluded => 'لا يوجد نص قصة.';

  @override
  String get placeLabel => 'المكان';

  @override
  String get notesLabel => 'الملاحظات';

  @override
  String get capsulePasswordProtected => 'كانت هذه الكبسولة محمية بكلمة مرور.';

  @override
  String get openingSharedMemory => 'جار فتح الذكرى المشتركة...';

  @override
  String get lifeThreadsMemoryTitle => 'ذكرى LifeThreads';

  @override
  String shareMemoryText(Object url) {
    return 'مرحباً، شاركت معك ذكرى في LifeThreads.\n\n$url';
  }

  @override
  String get shareLinkReady => 'رابط المشاركة جاهز.';

  @override
  String get shareLinkCreated => 'تم إنشاء رابط المشاركة.';

  @override
  String get shareLinkUnavailable =>
      'تم إنشاء رابط المشاركة، لكن المشاركة غير متاحة.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label ينتهي الرابط تلقائياً. يمكنك حذفه الآن.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'فشلت المشاركة السحابية: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'تم حذف رابط الذكرى المشتركة.';

  @override
  String get creatingSecureMemoryLink => 'جار إنشاء رابط ذكرى آمن...';

  @override
  String get shareMemoryCapsule => 'مشاركة كبسولة الذكرى';

  @override
  String get editStory => 'تعديل القصة';

  @override
  String get metaType => 'النوع';

  @override
  String get metaFeeling => 'الشعور';

  @override
  String get metaCategory => 'التصنيف';

  @override
  String get metaDate => 'التاريخ';

  @override
  String get storyEyebrow => 'القصة';

  @override
  String get whyMemoryMatters => 'لماذا هذه الذكرى مهمة';

  @override
  String get galleryEyebrow => 'المعرض';

  @override
  String savedPhotosTitle(int count) {
    return '$count صورة محفوظة';
  }

  @override
  String get peopleEyebrow => 'الأشخاص';

  @override
  String get partOfMemory => 'جزء من هذه الذكرى';

  @override
  String get notesEyebrow => 'ملاحظات';

  @override
  String get attachedThoughts => 'أفكار مرتبطة';

  @override
  String get stickyNote => 'ملاحظة لاصقة';

  @override
  String get placeEyebrow => 'المكان';

  @override
  String get threadsEyebrow => 'الخيوط';

  @override
  String get connectedMemories => 'ذكريات مرتبطة';

  @override
  String get noConnectedMemoriesYet =>
      'لا توجد ذكريات مرتبطة بعد. اربط هذا الفصل بلحظة أخرى لبدء خيط حياة مرئي.';

  @override
  String get backToWall => 'العودة إلى الجدار';

  @override
  String get addTextToWall => 'إضافة نص إلى الجدار';

  @override
  String get addTextAction => 'إضافة نص';

  @override
  String get textNoteHint => 'اكتب ذكرى صغيرة أو اقتباساً أو ملاحظة...';

  @override
  String get placeTextNote => 'وضع ملاحظة نصية';

  @override
  String get placeRopeAnchor => 'وضع مرساة حبل';

  @override
  String get nailSubtitle => 'يمكن للمسمار ربط الحبال يدوياً بين الذكريات.';

  @override
  String get clearDemoWallQuestion => 'مسح جدار العرض؟';

  @override
  String get clearDemoWallBody =>
      'هذا يزيل الذكريات التجريبية لتبدأ بجدار خاص فارغ.';

  @override
  String get importBackupQuestion => 'استيراد نسخة احتياطية؟';

  @override
  String get importBackupBody =>
      'هذا يستعيد الذكريات من أرشيف LifeThreads ويحافظ على جدارك الحالي.';

  @override
  String get deleteMemoryQuestion => 'حذف الذكرى؟';

  @override
  String get deleteMemoryBody => 'هذا يزيل الذكرى وكل روابطها على الجدار.';

  @override
  String get editText => 'تعديل النص';

  @override
  String get editTextTitle => 'تعديل النص';

  @override
  String get connectRope => 'ربط الحبل';

  @override
  String get connectRopeSubtitle => 'اربط هذا المسمار بالذكريات.';

  @override
  String get deleteNail => 'حذف المسمار';

  @override
  String get connectNailTitle => 'ربط المسمار بالذكريات';

  @override
  String get connectNailSubtitle => 'الذكريات المحددة ستتعلق من هذه المرساة.';

  @override
  String get timelineTitle => 'الخط الزمني';

  @override
  String get timelineSubtitle => 'ذكرياتك مرتبة حسب الوقت.';

  @override
  String get noMemoriesFilter => 'لا توجد ذكريات في هذا الفلتر';

  @override
  String get noMemoriesFilterBody =>
      'غيّر الفلتر أو أضف ذكرى لبناء الخط الزمني.';

  @override
  String get memoryMapTitle => 'خريطة الذكريات';

  @override
  String get memoryMapSubtitle => 'ذكرياتك مجمعة حسب المكان.';

  @override
  String get noMappedMemories => 'لا توجد ذكريات على الخريطة بعد';

  @override
  String get displayWallTooltip => 'عرض الجدار';

  @override
  String get tutorialTooltip => 'الشرح';

  @override
  String get settingsTooltip => 'الإعدادات';

  @override
  String get freeformLayout => 'حر';

  @override
  String get categoryLayout => 'تصنيف';

  @override
  String get locationLayout => 'مكان';

  @override
  String get saveToday => 'احفظ اليوم';

  @override
  String get rememberThis => 'تذكر هذا';

  @override
  String get whatHappenedToday => 'ماذا حدث اليوم؟';

  @override
  String get tapToOpenDrag => 'اضغط للفتح • اسحب للتحريك';

  @override
  String get demoWallPreview =>
      'معاينة جدار تجريبي. امسحه عندما تكون جاهزاً للبدء من جديد.';

  @override
  String get clearDemo => 'مسح العرض';

  @override
  String get chooseQuickPhoto => 'اختر صورة سريعة';

  @override
  String get wallView => 'الجدار';

  @override
  String get timelineView => 'الخط الزمني';

  @override
  String get mapView => 'الخريطة';

  @override
  String get wallFilterAll => 'الكل';

  @override
  String get wallViewButton => 'العرض';

  @override
  String get wallShowAs => 'اعرض كـ';

  @override
  String get wallArrange => 'الترتيب';

  @override
  String get wallShowOnly => 'إظهار';

  @override
  String get layoutByDate => 'حسب التاريخ';

  @override
  String get moreActionsTooltip => 'المزيد';

  @override
  String get expandableMemory => 'ذكرى';

  @override
  String get expandableMemorySubtitle => 'قصة موجهة كاملة';

  @override
  String get expandableQuickPhoto => 'ذكرى صورة سريعة';

  @override
  String get expandableQuickPhotoSubtitle => 'اختر صورة وعلّقها';

  @override
  String get expandableTextNote => 'ملاحظة نصية';

  @override
  String get expandableTextNoteSubtitle => 'فكرة صغيرة على الجدار';

  @override
  String get expandableNail => 'مسمار / مرساة حبل';

  @override
  String get expandableNailSubtitle => 'نقطة حبل يدوية';

  @override
  String get startWithOneThing => 'ابدأ بشيء واحد من اليوم';

  @override
  String get emptyWallBody => 'احفظ لحظة قبل أن تتلاشى. جملة أو صورة تكفي.';

  @override
  String get usePhoto => 'استخدام صورة';

  @override
  String get editMemoryTooltip => 'تعديل الذكرى';

  @override
  String get connectMemoryTooltip => 'ربط الذكرى';

  @override
  String get archiveTransferTitle => 'افتح على جهاز آخر';

  @override
  String get archiveTransferHeroTitle => 'انقل ذكرياتك بين الأجهزة بأمان.';

  @override
  String get archiveTransferHeroBody =>
      'النسخة الاحتياطية ملف ZIP واحد يضم ذكرياتك وصورك وملاحظاتك وخيوطك ومواقع الجدار والبيانات الوصفية، ويمكن قفله بكلمة مرور. لا نحتفظ بأي نسخة: أنت تقرر أين يذهب.';

  @override
  String get archiveTransferStep1Title => 'تصدير أرشيف';

  @override
  String get archiveTransferStep1Body =>
      'افتح الإعدادات، اختر تصدير الأرشيف، وأضف كلمة مرور إذا أردت الحماية.';

  @override
  String get archiveTransferStep2Title => 'انقل ملف ZIP';

  @override
  String get archiveTransferStep2Body =>
      'انقله عبر AirDrop أو USB أو سحابتك الخاصة أو البريد.';

  @override
  String get archiveTransferStep3Title => 'استيراد بأمان';

  @override
  String get archiveTransferStep3Body =>
      'ثبت LifeThreads على الجهاز الآخر، اختر استيراد الأرشيف، أدخل كلمة المرور عند الحاجة، واستعد البيانات دون حذف الموجود.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled => 'تم تفعيل فتح Premium للتطوير.';

  @override
  String get lifetimeActive => 'الاشتراك مفعّل';

  @override
  String get oneTimeLifetimeUnlock => 'اشتراك شهري';

  @override
  String get premiumHeroActiveTitle => 'جدار ذكرياتك غير محدود.';

  @override
  String get premiumHeroLockedTitle => 'حوّل ذكرياتك إلى قصص.';

  @override
  String get premiumHeroActiveBody =>
      'اشتراكك في Premium مفعّل. القصص مع الموسيقى وخيط السنة وجدران العائلة والذكريات بلا حدود أصبحت لك.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'النسخة المجانية تشمل $limit ذكرى ونسخاً احتياطية كاملة. يضيف Premium القصص والأفلام مع الموسيقى، وخيط السنة، وجدران العائلة، وذكريات بلا حدود.';
  }

  @override
  String get premiumMemories => 'ذكريات Premium';

  @override
  String get freeMemories => 'ذكريات مجانية';

  @override
  String get unlimited => 'غير محدود';

  @override
  String get benefitUnlimitedTitle => 'ذكريات غير محدودة';

  @override
  String get benefitUnlimitedBody =>
      'لا يوجد سقف 30 ذكرى. استمر في بناء الجدار مع نمو الحياة.';

  @override
  String get benefitThemesTitle => 'مظاهر جدار Premium';

  @override
  String get benefitThemesBody =>
      'افتح أجواء جدار أغنى، وسمات موسمية محدودة، والتبديل التلقائي حسب وقت اليوم.';

  @override
  String get benefitLayoutsTitle => 'تخطيطات متقدمة';

  @override
  String get benefitLayoutsBody =>
      'طرق أكثر لترتيب الخيوط والجداول الزمنية والمراسي ومجموعات الذكريات.';

  @override
  String get lifetimeUnlock => 'اشتراك Premium';

  @override
  String get premiumActiveOnDevice => 'Premium مفعّل على هذا الجهاز.';

  @override
  String onePurchaseBody(String store) {
    return 'اشتراك شهري للقصص مع الموسيقى، وخيط السنة، وجدران العائلة، وذكريات بلا حدود. يمكنك الإلغاء في أي وقت من إعدادات $store.';
  }

  @override
  String get premiumActiveButton => 'Premium مفعّل';

  @override
  String get processing => 'جار المعالجة...';

  @override
  String get unlockPremium => 'اشترك في Premium';

  @override
  String get restorePurchase => 'استعادة الاشتراك';

  @override
  String get enableDebugMockUnlock => 'تفعيل فتح تجريبي';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'يُخصم المبلغ من حسابك في $store. يتجدّد الاشتراك تلقائياً كل شهر ما لم تُلغِه قبل 24 ساعة على الأقل من نهاية الفترة الحالية. يمكنك إدارته أو إلغاؤه من إعدادات حسابك في $store.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'فشل تحديث المتجر. حاول مرة أخرى.';

  @override
  String get premiumMessageStoreUnavailable =>
      'عمليات الشراء غير متاحة على هذا الجهاز.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium غير متاح في المتجر بعد. حاول لاحقاً.';

  @override
  String get premiumMessageLoadFailed =>
      'تعذّر تحميل Premium من المتجر. حاول مرة أخرى.';

  @override
  String get premiumMessageOpeningCheckout => 'جارٍ فتح صفحة الشراء…';

  @override
  String get premiumMessageCheckoutFailed =>
      'تعذّر فتح صفحة الشراء. حاول مرة أخرى.';

  @override
  String get premiumMessageChecking => 'جارٍ التحقق من اشتراكك…';

  @override
  String get premiumMessageRestoreFailed => 'فشلت الاستعادة. حاول مرة أخرى.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'لم يتم العثور على اشتراك Premium فعّال.';

  @override
  String get premiumMessagePending =>
      'عملية الشراء قيد الانتظار. سيتم تفعيل Premium بعد الموافقة.';

  @override
  String get premiumMessagePurchaseFailed =>
      'لم تكتمل عملية الشراء. حاول مرة أخرى.';

  @override
  String get premiumMessageCanceled => 'تم إلغاء الشراء.';

  @override
  String get premiumMessageRestored => 'تمت استعادة اشتراك Premium.';

  @override
  String get premiumMessageActive => 'اشتراك Premium مفعّل.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/شهر';
  }

  @override
  String get loadingPlayStoreProduct => 'جارٍ تحميل الاشتراك…';

  @override
  String get playStoreUnavailable => 'المتجر غير متاح حالياً';

  @override
  String get productNotConfigured => 'المنتج غير مهيأ';

  @override
  String get purchasePending => 'الشراء معلق';

  @override
  String get purchased => 'تم الشراء';

  @override
  String get restored => 'تمت الاستعادة';

  @override
  String get purchaseFailed => 'فشل الشراء';

  @override
  String get preparingCheckout => 'جار تحضير الدفع...';

  @override
  String get premiumLocalFirstTitle => 'Premium محلي أولاً';

  @override
  String get premiumLocalFirstBody =>
      'تبقى ذكرياتك على جهازك، والنسخ الاحتياطي مجاني للجميع.';

  @override
  String get noMappedMemoriesBody =>
      'أضف صوراً تحتوي على بيانات GPS لرؤية الذكريات هنا.';

  @override
  String get peopleLabel => 'الأشخاص';

  @override
  String get connect => 'ربط';

  @override
  String get themeWarmMemoryRoom => 'غرفة ذكريات دافئة';

  @override
  String get themeWarmMemoryRoomDescription =>
      'دفء داكن ناعم، ضوء ذهبي، وعمق غرفة خاصة.';

  @override
  String get themeMidnightArchive => 'أرشيف منتصف الليل';

  @override
  String get themeMidnightArchiveDescription =>
      'غرفة أرشيف زرقاء عميقة بتركيز هادئ يشبه المتحف.';

  @override
  String get themeSoftPaperWall => 'جدار ورقي ناعم';

  @override
  String get themeSoftPaperWallDescription =>
      'ورق كريمي، ظلال حبر، وإحساس سجل هادئ.';

  @override
  String get themeTravelCorkboard => 'لوحة سفر فلينية';

  @override
  String get themeTravelCorkboardDescription =>
      'دفء لوحة فلين مع تلميحات شبكة خرائط للرحلات والأماكن.';

  @override
  String get themeAutoTitle => 'تلقائي حسب وقت اليوم';

  @override
  String get themeAutoDescription =>
      'جدار ورقي ناعم نهاراً، وغرفة ذكريات دافئة مساءً، وأرشيف منتصف الليل ليلاً.';

  @override
  String get themeAutoSelected => 'أصبح جدارك يتبع وقت اليوم.';

  @override
  String get themeSeasonalTitle => 'موسمي';

  @override
  String get themeSeasonalBody =>
      'سمات Premium محدودة، كل منها متاحة خلال موسمها فقط.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'حتى $dateString';
  }

  @override
  String get themeUseButton => 'استخدام هذه السمة';

  @override
  String get themeInUse => 'قيد الاستخدام';

  @override
  String get themeUnlockButton => 'افتحها مع Premium';

  @override
  String get themeAutumnHarvest => 'حصاد الخريف';

  @override
  String get themeAutumnHarvestDescription =>
      'ضوء كهرماني وبطاقات من ورق الكرافت ووهج الأوراق المتساقطة.';

  @override
  String get themeWinterLights => 'أضواء الشتاء';

  @override
  String get themeWinterLightsDescription =>
      'بطاقات مكسوّة بالصقيع وأضواء دافئة في ليلة زرقاء باردة.';

  @override
  String get themeSpringBlossom => 'زهر الربيع';

  @override
  String get themeSpringBlossomDescription =>
      'بطاقات بلون الزهر الفاتح مع توهج وردي ناعم.';

  @override
  String get themeSummerEvening => 'مساء صيفي';

  @override
  String get themeSummerEveningDescription =>
      'ألوان الغروب وبطاقات الصور الفورية.';

  @override
  String get demoFirstDanceTitle => 'رقصتنا الأولى';

  @override
  String get demoFirstDanceStory =>
      'عزفت الفرقة أغنيتنا فسكت المكان كلّه. دست على قدمك مرّتين وأنتِ تضحكين، ولثلاث دقائق لم يكن هناك أحد غيرنا.';

  @override
  String get demoFirstDancePlace => 'سالزبورغ';

  @override
  String get demoNewbornTitle => 'أهلاً بكِ في البيت يا لينا';

  @override
  String get demoNewbornStory =>
      'أمسكت يدها الصغيرة بإصبع واحد. أول صباح هادئ في البيت.';

  @override
  String get demoNewbornPlace => 'فيينا';

  @override
  String get demoBeachSunsetTitle => 'صيف على البحر';

  @override
  String get demoBeachSunsetStory =>
      'حفاة حتى غابت الشمس، ولينا نائمة على كتفيك في طريق العودة.';

  @override
  String get demoBeachSunsetPlace => 'سبليت، كرواتيا';

  @override
  String get demoGrandmaKitchenTitle => 'في مطبخ جدّتي';

  @override
  String get demoGrandmaKitchenStory =>
      'كتبنا أخيراً وصفة كعكة المشمش – والطحين في كل مكان.';

  @override
  String get demoGrandmaKitchenPlace => 'غراتس';

  @override
  String get demoGraduationTitle => 'يوم التخرّج';

  @override
  String get demoGraduationStory => 'بكى أبي قبل أن تسقط القبعات.';

  @override
  String get demoGraduationPlace => 'إنسبروك';

  @override
  String get demoFirstHomeTitle => 'مفتاح بيتنا الأول';

  @override
  String get demoFirstHomeStory =>
      'لا أثاث بعد، فقط صناديق وبيتزا على الأرض وأحلام كثيرة.';

  @override
  String get demoFirstHomePlace => 'لينتس';

  @override
  String get demoAlpineSummitTitle => 'فوق الغيوم';

  @override
  String get demoAlpineSummitStory =>
      'استيقظنا في الرابعة فجراً من أجل هذا المنظر، وكانت كل خطوة تستحق.';

  @override
  String get demoAlpineSummitPlace => 'غروسغلوكنر';

  @override
  String get demoFirstBikeTitle => 'أول جولة وحده';

  @override
  String get demoFirstBikeStory =>
      'ثلاث دفعات، ثم ترنّح قليلاً، ثم انطلق – وكان فخوراً جداً.';

  @override
  String get demoFirstBikePlace => 'براتر، فيينا';

  @override
  String get demoGardenDinnerTitle => 'عيد ميلاد جدّي الثمانين';

  @override
  String get demoGardenDinnerStory =>
      'أربعة أجيال حول طاولة واحدة، وما زال يروي أجمل القصص.';

  @override
  String get demoGardenDinnerPlace => 'فاخاو';

  @override
  String get demoThreadFirstDanceToFirstHome => 'قصّتنا';

  @override
  String get demoThreadFirstHomeToNewborn => 'ثم جاءت لينا';

  @override
  String get demoThreadNewbornToBeachSunset => 'صيفها الأول';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'العائلة';

  @override
  String get demoThreadGraduationToFirstHome => 'فصل جديد';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'مغامرات صغيرة';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'وجدّي يتفرّج';

  @override
  String get demoRelationGrandpa => 'جدّي';

  @override
  String get demoRelationGrandma => 'جدّتي';

  @override
  String get demoRelationDaughter => 'ابنتي';

  @override
  String get demoRelationWife => 'زوجتي';

  @override
  String get demoRelationBestMan => 'الإشبين';

  @override
  String get demoRelationMother => 'أمي';

  @override
  String savedToPath(Object label, Object path) {
    return '$label تم الحفظ في $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ذكرى ليست في نسخة احتياطية بعد.',
      few: '$count ذكريات ليست في نسخة احتياطية بعد.',
      two: 'ذكريان ليستا في نسخة احتياطية بعد.',
      one: 'ذكرى واحدة ليست في نسخة احتياطية بعد.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'لاحقاً';

  @override
  String get backUp => 'احفظ نسخة';

  @override
  String get onThisDayTitle => 'في مثل هذا اليوم';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'في مثل هذا اليوم قبل $years سنة',
      many: 'في مثل هذا اليوم قبل $years سنة',
      few: 'في مثل هذا اليوم قبل $years سنوات',
      two: 'في مثل هذا اليوم قبل سنتين',
      one: 'في مثل هذا اليوم قبل سنة',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'قبل $years سنة',
      many: 'قبل $years سنة',
      few: 'قبل $years سنوات',
      two: 'قبل سنتين',
      one: 'قبل سنة',
    );
    return 'في مثل هذا اليوم · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'في الأيام التي تعود فيها ذكرى من سنة سابقة، يرسل LifeThreads تذكيراً هادئاً واحداً.';

  @override
  String get onThisDayReminderSwitch => 'تذكير يومي';

  @override
  String onThisDayReminderAt(String time) {
    return 'عند $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'الإشعارات متوقفة لـ LifeThreads. فعّلها من إعدادات هاتفك.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'في مثل هذا اليوم قبل $years سنة: $title',
      many: 'في مثل هذا اليوم قبل $years سنة: $title',
      few: 'في مثل هذا اليوم قبل $years سنوات: $title',
      two: 'في مثل هذا اليوم قبل سنتين: $title',
      one: 'في مثل هذا اليوم قبل سنة: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ذكرى أخرى',
      many: '$count ذكرى أخرى',
      few: '$count ذكريات أخرى',
      two: 'ذكريان أخريان',
      one: 'ذكرى أخرى',
    );
    return '$title و$_temp0 من هذا اليوم';
  }

  @override
  String get onThisDayChannelDescription => 'ذكرى من هذا اليوم في سنة سابقة.';

  @override
  String get benefitOnThisDayBody =>
      'تذكير حين تعود ذكرى من سنة سابقة، تُفتح كفصل خاص بها.';

  @override
  String get premiumFeatureStoryImage => 'صور القصص';

  @override
  String get premiumFeatureStoryVideo => 'فيديوهات القصص';

  @override
  String get premiumFeatureThreadOfTheYear => 'خيط السنة';

  @override
  String get premiumFeatureFamilyWall => 'جدار العائلة';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature جزء من Premium.';
  }

  @override
  String get yearThreadTitle => 'خيط السنة';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ذكرى',
      many: '$count ذكرى',
      few: '$count ذكريات',
      two: 'ذكريان',
      one: 'ذكرى واحدة',
      zero: 'لا ذكريات',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مكان',
      many: '$count مكانًا',
      few: '$count أماكن',
      two: 'مكانان',
      one: 'مكان واحد',
      zero: 'لا أماكن',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شخص',
      many: '$count شخصًا',
      few: '$count أشخاص',
      two: 'شخصان',
      one: 'شخص واحد',
      zero: 'لا أشخاص',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شهر',
      many: '$count شهرًا',
      few: '$count أشهر',
      two: 'شهران',
      one: 'شهر واحد',
      zero: 'لا أشهر',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'الشعور الأكثر حضورًا: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'عامٌ في خيطٍ واحد.';

  @override
  String get yearThreadMyYear => 'عامي';

  @override
  String get yearThreadWallCardTitle => 'عامك في ذكريات';

  @override
  String yearThreadWallCardBody(String year) {
    return 'حوِّل عام $year إلى فيلم قصير.';
  }

  @override
  String get yearThreadDismiss => 'ليس الآن';

  @override
  String get yearThreadSettingsBody =>
      'حوِّل أي عام فيه 3 ذكريات على الأقل إلى فيلم قصير يروي لحظاته بالترتيب ويربطها الخيط.';

  @override
  String get yearThreadOpen => 'أنشئ الفيلم';

  @override
  String get yearThreadNoYears =>
      'يحتاج خيط السنة إلى عام فيه 3 ذكريات على الأقل. واصل حفظ لحظاتك ثم عُد إلينا.';

  @override
  String get yearThreadYear => 'العام';

  @override
  String get yearThreadLength => 'المدة';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'فيلم · $seconds ث';
  }

  @override
  String get yearThreadLengthStory => 'قصة · 20 ث';

  @override
  String get yearThreadMusic => 'الموسيقى';

  @override
  String get yearThreadNoMusic => 'بدون موسيقى';

  @override
  String get yearThreadInFilm => 'في الفيلم';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count من $max';
  }

  @override
  String get yearThreadAddMemory => 'أضف ذكرى';

  @override
  String get yearThreadSwap => 'استبدل';

  @override
  String get yearThreadRemove => 'أزل';

  @override
  String get yearThreadUseSuggestions => 'استخدم الاقتراحات';

  @override
  String yearThreadPickTitle(String year) {
    return 'اختر ذكرى من عام $year';
  }

  @override
  String get yearThreadNoOthers =>
      'كل ذكريات هذا العام موجودة في الفيلم بالفعل.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ذكرى',
      many: '$count ذكرى',
      few: '$count ذكريات',
      two: 'ذكريين',
      one: 'ذكرى واحدة',
    );
    return 'اختر $_temp0 على الأقل.';
  }

  @override
  String get yearThreadPreview => 'معاينة';

  @override
  String get yearThreadExportVideo => 'صدِّر الفيديو';

  @override
  String get yearThreadExportImage => 'صدِّر الصورة';

  @override
  String get yearThreadShare => 'شارك';

  @override
  String get yearThreadSave => 'احفظ في الصور';

  @override
  String get yearThreadMakingFilm => 'جارٍ إعداد فيلمك…';

  @override
  String get yearThreadMakingImage => 'جارٍ إعداد صورتك…';

  @override
  String get yearThreadFilmReady => 'فيلمك جاهز';

  @override
  String get yearThreadImageReady => 'صورتك جاهزة';

  @override
  String get yearThreadSaved => 'حُفظ في صورك.';

  @override
  String get yearThreadExportFailed => 'لم ينجح ذلك. يُرجى المحاولة مرة أخرى.';

  @override
  String get yearThreadPlay => 'تشغيل';

  @override
  String get yearThreadPause => 'إيقاف مؤقت';

  @override
  String get createStory => 'إنشاء قصة';

  @override
  String get storyPickTitle => 'اختر الذكريات';

  @override
  String storyPickBody(int max) {
    return 'اختر حتى $max ذكريات لقصة واحدة.';
  }

  @override
  String storyPickCount(int count, int max) {
    return 'تم اختيار $count من $max';
  }

  @override
  String storyPickLimit(int max) {
    return 'تتسع القصة لـ $max ذكريات كحد أقصى.';
  }

  @override
  String get storyPickContinue => 'متابعة';

  @override
  String get storyNoMemories => 'احفظ ذكرى أولاً، ثم حوّلها إلى قصة.';

  @override
  String get storyEditorTitle => 'قصتك';

  @override
  String get storyChangeMemories => 'تغيير الذكريات';

  @override
  String get storyTemplateSingle => 'ذكرى واحدة';

  @override
  String get storyTemplateThread => 'خيط';

  @override
  String get storyTemplateCollage => 'مجموعة صور';

  @override
  String get storyTemplateQuote => 'اقتباس';

  @override
  String get storySwipeHint => 'اسحب لشكل آخر';

  @override
  String get storyCaptionLabel => 'التعليق';

  @override
  String get storyCaptionHint => 'سطر واحد من قصتك';

  @override
  String get storyVideoSwitch => 'فيديو';

  @override
  String get storyVideoBody =>
      'فيلم قصير للقصص والريلز: تنساب الصور، ويُرسم الخيط، وتظهر العناوين تدريجيًا.';

  @override
  String get storyMusicTitle => 'الموسيقى';

  @override
  String get storyMusicNone => 'بدون موسيقى';

  @override
  String get storyMusicNoneHint =>
      'يمكنك إضافة أغنية من مكتبة موسيقى Instagram عند نشر القصة.';

  @override
  String get storyMoodWarm => 'دافئة';

  @override
  String get storyMoodJoyful => 'مبهجة';

  @override
  String get storyMoodCalm => 'هادئة';

  @override
  String get storyMoodNostalgic => 'حنين';

  @override
  String get storyMoodEpic => 'ملحمية';

  @override
  String get storyMoodEmotional => 'مؤثرة';

  @override
  String get storyMusicTrimHint => 'اسحب لاختيار الجزء الذي يُعزف';

  @override
  String get storySearchHint => 'ابحث في الذكريات والأماكن والسنوات';

  @override
  String storySearchEmpty(String query) {
    return 'لا توجد ذكرى تطابق «$query».';
  }

  @override
  String get storyMemoriesInStory => 'في قصتك';

  @override
  String get storyMemoriesReorderHint => 'اضغط مطولاً واسحب لتغيير الترتيب';

  @override
  String get storyAddMemory => 'إضافة';

  @override
  String get storyAddMemoryTitle => 'أضف ذكرى';

  @override
  String storyRemoveMemory(String title) {
    return 'إزالة $title من القصة';
  }

  @override
  String get storyAllMemoriesAdded => 'كل الذكريات موجودة في هذه القصة بالفعل.';

  @override
  String get storyShare => 'مشاركة';

  @override
  String get storySaveToPhotos => 'حفظ في الصور';

  @override
  String get storySaved => 'تم الحفظ في صورك.';

  @override
  String get storySaveDenied =>
      'لا يُسمح لـ LifeThreads بالإضافة إلى صورك. اسمح بذلك من إعدادات هاتفك.';

  @override
  String storyExportFailed(String error) {
    return 'تعذّر إنشاء القصة: $error';
  }

  @override
  String get storyRenderingTitle => 'جارٍ إنشاء فيلمك';

  @override
  String get storyRenderingBody =>
      'أبقِ LifeThreads مفتوحًا، سيستغرق ذلك بضع ثوانٍ.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent٪';
  }

  @override
  String get storyPreviewFree =>
      'المعاينة مجانية. مشاركة القصص وحفظها جزء من Premium.';

  @override
  String get benefitStoriesTitle => 'إنشاء قصة';

  @override
  String get benefitStoriesBody =>
      'حوّل ذكرياتك إلى صور قصص وأفلام قصيرة مع موسيقى لـ Instagram وWhatsApp وغيرها.';

  @override
  String get musicCreditsTitle => 'حقوق الموسيقى';

  @override
  String get musicCreditsBody => 'الأغاني المرفقة لفيديوهات القصص مع تراخيصها.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'عامك في فيلم قصير: اللحظات التي صنعت فرقاً، مربوطة بالترتيب، مع موسيقى.';

  @override
  String get benefitFamilyTitle => 'جدران العائلة';

  @override
  String get benefitFamilyBody =>
      'جدار مشترك لعائلتك، مشفّر من طرف إلى طرف. كل واحد يضيف لحظاته.';

  @override
  String get myWall => 'جداري';

  @override
  String get myWallSubtitle => 'خاص، على هذا الجهاز';

  @override
  String get switchWall => 'تبديل الجدار';

  @override
  String get familyWallsTitle => 'جدران العائلة';

  @override
  String get familyWallsSettingsBody =>
      'شارك جداراً واحداً مع العائلة أو الأصدقاء: يضيف الجميع ذكريات مشفّرة من طرف إلى طرف. يبقى جداري خاصاً على هذا الجهاز.';

  @override
  String get familyWallsOpen => 'فتح جدران العائلة';

  @override
  String get familyWallsManage => 'إدارة جدران العائلة';

  @override
  String get familyWallsHeadline => 'جدار واحد للعائلة كلها';

  @override
  String get familyWallsIntro =>
      'جدار العائلة مشترك مع الأشخاص الذين تدعوهم. تُشفَّر الذكريات والصور على هاتفك قبل رفعها، ولا يستطيع فتحها إلا الأعضاء. جداري لا يُشارَك ويبقى على هذا الجهاز.';

  @override
  String get familyUnavailableTitle => 'غير متاح بعد';

  @override
  String get familyUnavailable =>
      'جدران العائلة غير متاحة بعد في هذا الإصدار من LifeThreads.';

  @override
  String get familySignInNeededTitle => 'سجّل الدخول لاستخدام جدران العائلة';

  @override
  String get familySignInNeededBody =>
      'يحتاج الجدار المشترك إلى حساب لتعرف العائلة من أضاف ماذا. يعمل جداري من دون حساب.';

  @override
  String get familySignIn => 'تسجيل الدخول';

  @override
  String get familyLoadFailed => 'تعذّر التحميل';

  @override
  String get familyRetry => 'إعادة المحاولة';

  @override
  String get familyNoWallsYet =>
      'لا توجد جدران عائلة بعد. أنشئ جداراً أو انضم برابط دعوة.';

  @override
  String get familyStartTitle => 'إنشاء أو انضمام';

  @override
  String get familyStartBody =>
      'إنشاء جدار عائلة يتطلب Premium. الانضمام مجاني: اشتراك Premium لمالك الجدار يغطي العائلة.';

  @override
  String get familyCreateAction => 'إنشاء جدار عائلة';

  @override
  String get familyCreateTitle => 'جدار عائلة جديد';

  @override
  String get familyNameLabel => 'اسم الجدار';

  @override
  String get familyNameHint => 'مثلاً: عائلة الأحمد';

  @override
  String get familyMyNameLabel => 'اسمك على هذا الجدار';

  @override
  String get familyMyNameHelper =>
      'يراه الأعضاء على ذكرياتك، وهو مشفّر مثل كل ما على الجدار.';

  @override
  String get familyMyNameSaved => 'تم حفظ الاسم.';

  @override
  String get familySetMyName => 'اسمي';

  @override
  String get familyCheckingSubscription => 'جارٍ التحقق من Premium…';

  @override
  String get familyCreating => 'جارٍ إنشاء الجدار…';

  @override
  String get familyJoinWithLink => 'الانضمام برابط';

  @override
  String get familyInviteLinkLabel => 'رابط الدعوة';

  @override
  String get familyJoinTitle => 'الانضمام إلى جدار العائلة هذا؟';

  @override
  String get familyJoinBody =>
      'سيرى الأعضاء اسمك والذكريات التي تضيفها، وسترى ذكرياتهم. يمكنك المغادرة في أي وقت.';

  @override
  String get familyJoinAction => 'انضمام';

  @override
  String get familyJoining => 'جارٍ الانضمام…';

  @override
  String familyJoined(String family) {
    return 'انضممت إلى $family.';
  }

  @override
  String get familyRoleOwner => 'المالك';

  @override
  String get familyRoleMember => 'عضو';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عضو',
      many: '$count عضواً',
      few: '$count أعضاء',
      two: 'عضوان',
      one: 'عضو واحد',
      zero: 'لا أعضاء',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'إعدادات الجدار';

  @override
  String familyStorageUsed(String used, String total) {
    return 'المستخدم $used من $total';
  }

  @override
  String get familyRename => 'إعادة التسمية';

  @override
  String get familyInviteTitle => 'دعوة';

  @override
  String get familyInviteBody =>
      'أرسل رابطاً إلى شخص تثق به. كل رابط يعمل مرة واحدة وتنتهي صلاحيته بعد 7 أيام.';

  @override
  String get familyInviteAction => 'إنشاء رابط دعوة';

  @override
  String get familyCreatingInvite => 'جارٍ إنشاء الدعوة…';

  @override
  String get familyInviteReady => 'رابط الدعوة جاهز';

  @override
  String get familyInviteValidity =>
      'يعمل مرة واحدة وتنتهي صلاحيته بعد 7 أيام على الأكثر.';

  @override
  String get familyInviteKeyWarning =>
      'يحمل الرابط مفتاح الجدار: من يفتحه يمكنه الانضمام وقراءة الجدار. أرسله فقط إلى الشخص الذي تدعوه.';

  @override
  String get familyInviteShare => 'مشاركة الرابط';

  @override
  String get familyInviteCopy => 'نسخ الرابط';

  @override
  String get familyInviteCopied => 'تم نسخ الرابط.';

  @override
  String get familyInviteShareFailed =>
      'المشاركة غير متاحة. انسخ الرابط بدلاً من ذلك.';

  @override
  String familyInviteSubject(String family) {
    return 'انضم إلى $family على LifeThreads';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'انضم إلى جدار عائلتنا «$family» على LifeThreads: $link';
  }

  @override
  String get familyMembersTitle => 'الأعضاء';

  @override
  String get familyMemberActions => 'إجراءات العضو';

  @override
  String get familyYou => 'أنت';

  @override
  String familyYouNamed(String name) {
    return '$name (أنت)';
  }

  @override
  String get familyAMember => 'أحد الأعضاء';

  @override
  String get familyFormerMember => 'عضو سابق';

  @override
  String get familyBlocked => 'محظور';

  @override
  String get familyBlock => 'حظر';

  @override
  String get familyUnblock => 'إلغاء الحظر';

  @override
  String familyBlockAuthor(String name) {
    return 'حظر $name';
  }

  @override
  String familyBlockQuestion(String name) {
    return 'حظر $name؟';
  }

  @override
  String get familyBlockBody =>
      'لن ترى ذكرياته على أي جدار عائلة بعد الآن، ولن يتم إعلامه. يمكنك إلغاء الحظر من قائمة الأعضاء.';

  @override
  String get familyReport => 'إبلاغ';

  @override
  String get familyRemoveMember => 'إزالة من الجدار';

  @override
  String familyRemoveQuestion(String name) {
    return 'إزالة $name؟';
  }

  @override
  String get familyRemoveBody =>
      'سيفقد الوصول إلى هذا الجدار. ادعُه مجدداً لإعادته.';

  @override
  String get familyRemoveDeleteContent => 'احذف أيضاً الذكريات التي أضافها';

  @override
  String get familyDeleteTitle => 'حذف جدار العائلة';

  @override
  String get familyDeleteBody =>
      'بصفتك المالك لا يمكنك مغادرة الجدار، ويمكنك حذفه للجميع.';

  @override
  String get familyDeleteAction => 'حذف الجدار';

  @override
  String familyDeleteQuestion(String family) {
    return 'حذف $family؟';
  }

  @override
  String get familyDeleteConfirmBody =>
      'تُحذف كل الذكريات والصور على هذا الجدار من خوادمنا لكل الأعضاء. لا يمكن التراجع عن ذلك. لا تتأثر الذكريات على جداري.';

  @override
  String get familyDeleting => 'جارٍ الحذف…';

  @override
  String get familyLeaveTitle => 'مغادرة جدار العائلة';

  @override
  String get familyLeaveBody =>
      'لن ترى هذا الجدار بعد الآن. يمكنك الإبقاء على الذكريات التي أضفتها أو حذفها.';

  @override
  String get familyLeaveAction => 'مغادرة';

  @override
  String familyLeaveQuestion(String family) {
    return 'مغادرة $family؟';
  }

  @override
  String get familyLeaveConfirmBody => 'للعودة ستحتاج إلى دعوة جديدة.';

  @override
  String get familyLeaveDeleteMine => 'احذف أيضاً الذكريات التي أضفتها';

  @override
  String get familyLeaving => 'جارٍ المغادرة…';

  @override
  String get familySignInTitle => 'تسجيل الدخول';

  @override
  String get familySignInHeadline => 'حساب لجدران العائلة';

  @override
  String get familySignInWhy =>
      'جدار العائلة مشترك، لذلك يحتاج إلى حساب: يرى الأعضاء من أضاف كل ذكرى، ولا يفتح الجدار إلا الأعضاء.';

  @override
  String get familySignInMyWallStays =>
      'جداري لا يحتاج إلى حساب. يبقى خاصاً على هذا الجهاز ولا يُرفع أبداً.';

  @override
  String get familySignInEncrypted =>
      'ذكريات العائلة وصورها مشفّرة من طرف إلى طرف. تخزّنها GK Coding لكنها لا تستطيع قراءتها.';

  @override
  String get familySignInWhatWeGet =>
      'لا نستخدم من Apple أو Google إلا معرّف الحساب، وليس جهات اتصالك أو صورك.';

  @override
  String get familySignInApple => 'تسجيل الدخول باستخدام Apple';

  @override
  String get familySignInGoogle => 'تسجيل الدخول باستخدام Google';

  @override
  String get familySignInFinePrint =>
      'بتسجيل الدخول توافق على شروط الاستخدام وسياسة الخصوصية. يمكنك حذف حسابك من التطبيق في أي وقت.';

  @override
  String get familyAccountTitle => 'الحساب';

  @override
  String get familySignedOutTitle => 'لم تسجّل الدخول';

  @override
  String get familySignedOutBody =>
      'سجّل الدخول لرؤية جدران عائلتك. يعمل جداري من دون حساب.';

  @override
  String get familySignedInTitle => 'تم تسجيل الدخول';

  @override
  String get familySignedInBody => 'يُستخدم حسابك لجدران العائلة فقط.';

  @override
  String familyAccountId(String id) {
    return 'معرّف الحساب: $id';
  }

  @override
  String get familySignOut => 'تسجيل الخروج';

  @override
  String get familySignOutQuestion => 'تسجيل الخروج؟';

  @override
  String get familySignOutBody =>
      'تُزال جدران العائلة ومفاتيحها من هذا الجهاز حتى تسجّل الدخول مجدداً. لا يُحذف شيء من الخادم. لا يتأثر جداري.';

  @override
  String get familySigningOut => 'جارٍ تسجيل الخروج…';

  @override
  String get familyDeleteAccountTitle => 'حذف الحساب';

  @override
  String get familyDeleteAccountBody =>
      'يحذف حسابك وبيانات جدران العائلة الخاصة بك من خوادمنا. يبقى جداري على هذا الجهاز.';

  @override
  String get familyDeleteAccount => 'حذف الحساب';

  @override
  String get familyDeleteAccountQuestion => 'حذف حسابك؟';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'تُحذف جدران العائلة الـ$count التي تملكها لكل أعضائها مع كل الذكريات والصور.',
      many:
          'تُحذف جدران العائلة الـ$count التي تملكها لكل أعضائها مع كل الذكريات والصور.',
      few:
          'تُحذف جدران العائلة الـ$count التي تملكها لكل أعضائها مع كل الذكريات والصور.',
      two:
          'يُحذف جدارا العائلة اللذان تملكهما لكل أعضائهما مع كل الذكريات والصور.',
      one: 'يُحذف جدار العائلة الذي تملكه لكل أعضائه مع كل ذكرياته وصوره.',
      zero: 'لا تملك أي جدار عائلة.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'تُحذف الذكريات والصور التي أضفتها إلى جدران العائلات الأخرى، وتغادر تلك الجدران.';

  @override
  String get familyDeleteAccountKeys =>
      'تُزال مفاتيح جدران العائلة والصور المخزنة مؤقتاً من هذا الجهاز. لا يمكن التراجع عن ذلك.';

  @override
  String get familyDeleteAccountMyWall =>
      'لا يتأثر جداري: تبقى ذكرياته على هذا الجهاز.';

  @override
  String get familyDeleteAccountSubscription =>
      'لا يُلغى اشتراك Premium بذلك؛ أدِره من App Store أو Google Play.';

  @override
  String get familyDeleteAccountUnderstood => 'أفهم أن هذا يحذف حسابي نهائياً.';

  @override
  String get familyDeletingAccount => 'جارٍ حذف حسابك…';

  @override
  String get familyAccountDeleted => 'تم حذف حسابك.';

  @override
  String get familyTermsTitle => 'قواعد جدار العائلة';

  @override
  String get familyTermsHeadline => 'قبل أن تشارك';

  @override
  String get familyTermsIntro =>
      'جدران العائلة للأشخاص الذين تدعوهم. وللحفاظ على أمانها، يقبل الجميع هذه القواعد:';

  @override
  String get familyTermsZeroTolerance =>
      'لا تسامح مطلقاً مع المحتوى المسيء: لا تحرّش ولا كراهية ولا محتوى جنسي ولا عنف ولا إيذاء للنفس ولا محتوى غير قانوني ولا معلومات خاصة بالآخرين دون موافقتهم.';

  @override
  String get familyTermsOwnContent =>
      'شارك فقط الصور والقصص التي يحق لك مشاركتها.';

  @override
  String get familyTermsReport =>
      'أبلغ عن أي ذكرى أو عضو من الجدار. تراجع GK Coding البلاغات خلال 24 ساعة.';

  @override
  String get familyTermsBlock => 'احظر عضواً لتتوقف عن رؤية ذكرياته.';

  @override
  String get familyTermsOwner => 'يمكن لمالك الجدار إزالة الأعضاء وذكرياتهم.';

  @override
  String get familyTermsConsequences =>
      'يُزال المحتوى المخالف لهذه القواعد، ويمكن تعليق الحسابات التي نشرته أو حذفها.';

  @override
  String get familyTermsReadFull => 'قراءة الشروط كاملة';

  @override
  String get familyTermsAgree => 'أوافق على شروط الاستخدام وهذه القواعد.';

  @override
  String get familyTermsAccept => 'قبول ومتابعة';

  @override
  String familyTermsVersion(String version) {
    return 'إصدار الشروط $version';
  }

  @override
  String get familyWallEmptyTitle => 'الجدار ينتظر';

  @override
  String get familyWallEmptyBody =>
      'أضف الذكرى الأولى، وسيراها كل من على هذا الجدار.';

  @override
  String get familyWallGoneBody =>
      'لم يعد جدار العائلة هذا متاحاً لك. ربما حُذف أو أُزلت منه.';

  @override
  String get familyAddMemory => 'إضافة ذكرى';

  @override
  String get familyRefresh => 'تحديث';

  @override
  String get familySyncing => 'جارٍ المزامنة…';

  @override
  String get familyOffline => 'غير متصل: عرض الذكريات المحفوظة';

  @override
  String get familySyncFailed => 'فشلت المزامنة';

  @override
  String get familyMemoryTitle => 'ذكرى';

  @override
  String get familyMemoryGone => 'لم تعد هذه الذكرى على الجدار.';

  @override
  String get familyMemoryActions => 'إجراءات الذكرى';

  @override
  String familyAddedBy(String name) {
    return 'أضافها $name';
  }

  @override
  String get familyDeleteMemoryQuestion => 'حذف هذه الذكرى؟';

  @override
  String get familyDeleteMemoryBody => 'ستُزال من الجدار للجميع مع صورها.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'بصفتك المالك يمكنك إزالة الذكريات من هذا الجدار. ستُزال هذه الذكرى التي أضافها $name للجميع مع صورها.';
  }

  @override
  String get familyDeletingMemory => 'جارٍ حذف الذكرى…';

  @override
  String get familyNoPhotosYet => 'لا صور بعد';

  @override
  String get familyPostNote =>
      'سيرى كل من على هذا الجدار هذه الذكرى. تُصغَّر الصور وتُشفَّر على هاتفك قبل رفعها.';

  @override
  String get familyPostMemory => 'نشر على الجدار';

  @override
  String get familyUploading => 'جارٍ التشفير والرفع…';

  @override
  String get familyMemorySaved => 'تم الحفظ على جدار العائلة.';

  @override
  String get familyConflictTitle => 'غيّرها شخص آخر';

  @override
  String get familyConflictBody =>
      'تغيّرت هذه الذكرى على جهاز آخر أثناء تعديلك لها. هل تريد تحميل أحدث نسخة وحفظ تغييراتك فوقها؟';

  @override
  String get familyConflictRetry => 'تحديث وحفظ';

  @override
  String get familyQuotaTitle => 'الجدار ممتلئ';

  @override
  String get familyReportMemoryTitle => 'الإبلاغ عن ذكرى';

  @override
  String get familyReportPhotoTitle => 'الإبلاغ عن صورة';

  @override
  String get familyReportMemberTitle => 'الإبلاغ عن عضو';

  @override
  String get familyReportIntro =>
      'أخبرنا بما هو خطأ. يذهب بلاغك إلى GK Coding وليس إلى الشخص الذي تبلّغ عنه.';

  @override
  String get familyReportSpam => 'رسائل مزعجة أو احتيال';

  @override
  String get familyReportHarassment => 'تحرّش أو تنمّر';

  @override
  String get familyReportHate => 'خطاب كراهية';

  @override
  String get familyReportSexual => 'محتوى جنسي أو عُري';

  @override
  String get familyReportViolence => 'عنف أو تهديد';

  @override
  String get familyReportSelfHarm => 'إيذاء النفس أو الانتحار';

  @override
  String get familyReportIllegal => 'محتوى غير قانوني';

  @override
  String get familyReportPrivacy => 'معلومات خاصة نُشرت دون موافقة';

  @override
  String get familyReportOther => 'شيء آخر';

  @override
  String get familyReportDetailsLabel => 'تفاصيل (اختياري)';

  @override
  String get familyReportDetailsHint => 'ما الذي يجب أن نعرفه؟';

  @override
  String familyReportAlsoBlock(String name) {
    return 'حظر $name أيضاً';
  }

  @override
  String get familyReportSend => 'إرسال البلاغ';

  @override
  String get familyReportReviewNote =>
      'تراجع GK Coding كل بلاغ خلال 24 ساعة وتزيل المحتوى والأعضاء المخالفين للقواعد.';

  @override
  String get familyReportSentTitle => 'شكراً لك';

  @override
  String get familyReportSentBody =>
      'تم إرسال بلاغك. تراجعه GK Coding خلال 24 ساعة وتتخذ إجراءً بحق المحتوى المخالف للقواعد.';

  @override
  String get familyErrorGeneric => 'حدث خطأ ما. يُرجى المحاولة مجدداً.';

  @override
  String get familyErrorOffline =>
      'يبدو أنك غير متصل. تحقّق من اتصالك وحاول مجدداً.';

  @override
  String get familyErrorSubscriptionRequired =>
      'يتطلب هذا اشتراك Premium فعّالاً لمالك الجدار.';

  @override
  String get familyErrorInviteExpired =>
      'انتهت صلاحية هذه الدعوة. اطلب رابطاً جديداً.';

  @override
  String get familyErrorInviteUsed =>
      'استُخدمت هذه الدعوة من قبل. كل رابط يعمل مرة واحدة؛ اطلب رابطاً جديداً.';

  @override
  String get familyErrorInviteInvalid =>
      'هذا ليس رابط دعوة صالحاً من LifeThreads.';

  @override
  String get familyErrorAlreadyMember => 'أنت عضو في جدار العائلة هذا بالفعل.';

  @override
  String get familyErrorFamilyFull =>
      'وصل جدار العائلة هذا إلى الحد الأقصى للأعضاء.';

  @override
  String get familyErrorQuotaExceeded =>
      'لم تعد هناك مساحة تخزين في جدار العائلة هذا. احذف بعض الذكريات أو الصور لإفساح المجال.';

  @override
  String get familyErrorVersionConflict =>
      'غيّر شخص آخر هذه الذكرى أولاً. حدّث وحاول مجدداً.';

  @override
  String get familyErrorTermsRequired => 'يُرجى قبول قواعد جدار العائلة أولاً.';

  @override
  String get familyErrorSignedOut =>
      'تم تسجيل خروجك. يُرجى تسجيل الدخول مجدداً.';

  @override
  String get familyErrorNotAllowed => 'غير مسموح لك بذلك على هذا الجدار.';

  @override
  String get familyErrorNotFound => 'لم يُعثر على جدار العائلة';

  @override
  String get familyErrorOwnerCannotLeave =>
      'لا يمكن للمالك مغادرة الجدار، لكن يمكنه حذفه.';

  @override
  String get familyPaste => 'لصق';

  @override
  String get familyErrorInviteRevoked =>
      'تم سحب هذه الدعوة. اطلب رابطاً جديداً.';

  @override
  String get familyErrorKeyMissing =>
      'لا يملك هذا الجهاز مفتاح جدار العائلة هذا (مثلاً بعد إعادة التثبيت أو على هاتف جديد). اطلب من أحد الأعضاء رابط دعوة جديداً، فبفتحه يُستعاد الوصول.';

  @override
  String get familyErrorSignInUnavailable =>
      'تسجيل الدخول غير متاح على هذا الجهاز حالياً.';

  @override
  String get familyErrorNoPurchase =>
      'لم يُعثر على شراء Premium لحساب App Store أو Google Play هذا. احصل على Premium أولاً ثم حاول مجدداً.';

  @override
  String get familyErrorVerificationUnavailable =>
      'تعذّر التحقق من اشتراك Premium الآن. حاول مجدداً لاحقاً.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'شراء Premium هذا مرتبط بالفعل بحساب آخر لجدران العائلة. سجّل الدخول بذلك الحساب أو راسلنا على info@gkcoding.dev.';

  @override
  String get familyErrorNameTooLong =>
      'هذا الاسم طويل جداً. يُرجى استخدام اسم أقصر.';

  @override
  String get familyErrorPhotoUnreadable =>
      'تعذّرت قراءة إحدى الصور. أزلها وحاول مجدداً.';

  @override
  String get familyErrorTooLarge =>
      'هذا كبير جداً للرفع. جرّب صوراً أقل أو أصغر.';

  @override
  String get familyReportEvidenceNote =>
      'لمراجعة البلاغ تتلقى GK Coding عنوان هذه الذكرى وقصتها مع بلاغك. لا تُرسل صورها أبداً.';
}
