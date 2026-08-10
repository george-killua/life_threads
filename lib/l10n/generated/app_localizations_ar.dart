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
      'LifeThreads يعمل محلياً أولاً: بلا حساب وبلا ملف عام. تبقى ذكرياتك على هذا الجهاز إلا إذا اخترت مشاركة سحابية مشفّرة أو مزامنة سحابية أو تصدير نسخة احتياطية يدوياً.';

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
  String get premiumArchiveTitle => 'أرشيف Premium';

  @override
  String get premiumArchiveBody =>
      'انقل ذكرياتك بين الأجهزة بأمان. صدّر أرشيفاً يحتوي على الذكريات والصور والملاحظات والحبال وتخطيط الجدار والبيانات الوصفية. أضف حماية بكلمة مرور عند الحاجة.';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'فتح';

  @override
  String get exportArchive => 'تصدير الأرشيف';

  @override
  String get unlockExport => 'فتح التصدير';

  @override
  String get importArchive => 'استيراد أرشيف';

  @override
  String get importCapsule => 'استيراد كبسولة';

  @override
  String get moveDevices => 'نقل الأجهزة';

  @override
  String get cloudSyncTitle => 'المزامنة السحابية';

  @override
  String get cloudSyncBody =>
      'انسخ أرشيفاً محمياً بكلمة مرور إلى VPS الخاص بك. الخادم يخزن ملف ZIP المقفل فقط، ومفتاح المزامنة الخاص بك يتحكم بالاستعادة.';

  @override
  String get vpsBadge => 'VPS';

  @override
  String get backUpNow => 'نسخ احتياطي الآن';

  @override
  String get unlockBackup => 'فتح النسخ الاحتياطي';

  @override
  String get restoreLatest => 'استعادة الأحدث';

  @override
  String get copyKey => 'نسخ المفتاح';

  @override
  String get useKey => 'استخدام المفتاح';

  @override
  String get deleteCloud => 'حذف السحابة';

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
      'اشتراك شهري: ذكريات غير محدودة، تصدير/استيراد أرشيف مشفر، نقل إلى جهاز آخر، مظاهر Premium، وتخطيطات متقدمة.';

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
  String get cloudBackupNeedsPassword => 'النسخ السحابي يحتاج كلمة مرور.';

  @override
  String cloudBackupSaved(int memoryCount) {
    return 'تم حفظ النسخ السحابي: $memoryCount ذكريات.';
  }

  @override
  String cloudBackupFailed(Object message) {
    return 'فشل النسخ السحابي: $message';
  }

  @override
  String cloudRestoreRejected(Object message) {
    return 'تم رفض استعادة السحابة: $message';
  }

  @override
  String cloudRestoreFailed(Object message) {
    return 'فشلت استعادة السحابة: $message';
  }

  @override
  String get syncKeyCopied => 'تم نسخ مفتاح المزامنة.';

  @override
  String get useSyncKeyTitle => 'استخدام مفتاح المزامنة';

  @override
  String get syncKeyLabel => 'مفتاح المزامنة';

  @override
  String get syncKeySaved => 'تم حفظ مفتاح المزامنة.';

  @override
  String get deleteCloudBackupTitle => 'حذف النسخة السحابية؟';

  @override
  String get deleteCloudBackupBody =>
      'هذا يحذف الأرشيف المشفر من VPS الخاص بك. الذكريات المحلية تبقى على هذا الجهاز.';

  @override
  String get cloudBackupDeleted => 'تم حذف النسخة السحابية.';

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
  String wallWelcome(String name) {
    return 'أهلاً، $name.';
  }

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
      'استخدم Cloud Sync أو نقل الأرشيف قبل تغيير الهاتف أو اختبار إصدار إنتاجي.';

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
  String get exportPremiumArchiveTitle => 'تصدير أرشيف Premium';

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
  String get archiveReadyToSend => 'الأرشيف جاهز للإرسال.';

  @override
  String get archiveSavedLater => 'تم حفظ الأرشيف. يمكنك مشاركته لاحقاً.';

  @override
  String get archiveSharingUnavailable =>
      'تم حفظ الأرشيف، لكن المشاركة غير متاحة.';

  @override
  String savedToPath(Object label, Object path) {
    return '$label تم الحفظ في $path';
  }

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
  String get headerSubtitle => 'ذكرياتك معلّقة معاً.';

  @override
  String get importBackupTooltip => 'استيراد نسخة';

  @override
  String get exportBackupTooltip => 'تصدير نسخة';

  @override
  String get displayWallTooltip => 'عرض الجدار';

  @override
  String get tutorialTooltip => 'الشرح';

  @override
  String get settingsTooltip => 'الإعدادات';

  @override
  String get hideControlsTooltip => 'إخفاء الأدوات';

  @override
  String get freeformLayout => 'حر';

  @override
  String get categoryLayout => 'تصنيف';

  @override
  String get locationLayout => 'مكان';

  @override
  String get wallControls => 'أدوات الجدار';

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
      'ينشئ Premium Archive ملف ZIP مشفراً قابلاً للنقل يحتوي على ذكرياتك وصورك وملاحظاتك وحبالك ومواقع الجدار والبيانات الوصفية. يمكن لـ Cloud Sync أيضاً حفظ هذا الملف المقفل على VPS للاستعادة على جهاز آخر.';

  @override
  String get archiveTransferStep1Title => 'تصدير أرشيف';

  @override
  String get archiveTransferStep1Body =>
      'افتح الإعدادات، اختر تصدير الأرشيف، وأضف كلمة مرور إذا أردت الحماية.';

  @override
  String get archiveTransferStep2Title => 'نقل أو مزامنة ZIP';

  @override
  String get archiveTransferStep2Body =>
      'انقله عبر AirDrop أو USB أو Drive أو البريد، أو استخدم Cloud Sync بمفتاح مزامنة خاص.';

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
  String get premiumHeroLockedTitle => 'انقل ذكرياتك بين الأجهزة بأمان.';

  @override
  String get premiumHeroActiveBody =>
      'اشتراك Premium مفعّل. تصدير الأرشيف المشفر والمظاهر المميزة والتخطيطات المتقدمة متاحة.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'المجاني يتضمن $limit ذكريات. يضيف Premium تصدير/استيراد مشفر، نقل آمن بين الأجهزة، مظاهر وتخطيطات متقدمة.';
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
  String get benefitArchivesTitle => 'أرشيفات مشفرة';

  @override
  String get benefitArchivesBody =>
      'صدّر واستورد ملف ZIP محمياً بكلمة مرور مع الصور والملاحظات والحبال والتخطيط والبيانات الوصفية.';

  @override
  String get benefitTransferTitle => 'النقل إلى جهاز آخر';

  @override
  String get benefitTransferBody =>
      'انقل جدار ذكرياتك الخاص إلى هاتف جديد دون مزامنة سحابية نشطة.';

  @override
  String get benefitThemesTitle => 'مظاهر جدار Premium';

  @override
  String get benefitThemesBody =>
      'افتح أجواء جدار أغنى للعائلة والسفر والأرشيف والمعرض.';

  @override
  String get benefitLayoutsTitle => 'تخطيطات متقدمة';

  @override
  String get benefitLayoutsBody =>
      'طرق أكثر لترتيب الخيوط والجداول الزمنية والمراسي ومجموعات الذكريات.';

  @override
  String get cloudSyncPlannedTitle => 'المزامنة السحابية مخططة لاحقاً';

  @override
  String get cloudSyncPlannedBody =>
      'Premium Archive هو ميزة النقل الآمنة الآن: صدّر، انقل ZIP، واستورد على جهاز آخر.';

  @override
  String get deviceTransferHow => 'كيف يعمل نقل الجهاز';

  @override
  String get lifetimeUnlock => 'اشتراك Premium';

  @override
  String get premiumActiveOnDevice => 'Premium مفعّل على هذا الجهاز.';

  @override
  String get onePurchaseBody =>
      'اشترك شهرياً لذكريات غير محدودة ونسخ احتياطية ومظاهر وتخطيطات متقدمة. يمكنك الإلغاء في أي وقت من Google Play أو App Store.';

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
  String get purchasesHandledByGooglePlay =>
      'الاشتراكات عبر Google Play أو App Store. يبقى Premium نشطاً طالما يتجدد اشتراكك.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/شهر';
  }

  @override
  String get loadingPlayStoreProduct => 'جار تحميل منتج Play Store...';

  @override
  String get playStoreUnavailable => 'Play Store غير متاح';

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
      'يفتح Premium قيمة محلية الآن. المزامنة السحابية مخططة لاحقاً وليست نشطة في هذه النسخة.';

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
  String get demoViennaTitle => 'مشي مساء في فيينا';

  @override
  String get demoViennaDescription =>
      'مساء هادئ في فيينا، من تلك اللحظات التي تبقى دافئة لأن شيئاً لم يكن بحاجة أن يكون مثالياً.';

  @override
  String get demoViennaLocation => 'فيينا، النمسا';

  @override
  String get demoLinzTitle => 'مطر وقهوة';

  @override
  String get demoLinzDescription =>
      'بعد ظهر بطيء في لينتس مع قهوة ومطر على النوافذ وصورة واحدة تشبه البيت.';

  @override
  String get demoLinzLocation => 'لينتس، النمسا';

  @override
  String get demoFamilyTitle => 'طاولة العائلة';

  @override
  String get demoFamilyDescription =>
      'طعام وضجيج ونكات صغيرة وشعور بأن هذا ما يجب تذكره.';

  @override
  String get demoHomeLocation => 'البيت';

  @override
  String get demoLaunchTitle => 'ليلة الإطلاق الأولى';

  @override
  String get demoLaunchDescription =>
      'الليلة التي تحولت فيها فكرة أخيراً إلى شيء حقيقي على الشاشة.';

  @override
  String get demoConnectionQuietDays => 'أيام هادئة';

  @override
  String get demoConnectionHomeFocus => 'تركيز البيت';

  @override
  String get demoConnectionWhyItMatters => 'لماذا يهم';
}
