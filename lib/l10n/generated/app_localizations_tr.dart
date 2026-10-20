// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get delete => 'Sil';

  @override
  String get send => 'Gönder';

  @override
  String get preparing => 'Hazırlanıyor...';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get languageTitle => 'Dil';

  @override
  String get languageBody =>
      'Uygulamanın dilini seç. Sistem, LifeThreads destekliyorsa telefonunun dilini kullanır.';

  @override
  String get systemLanguage => 'Sistem';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return 'Dil değiştirildi: $language.';
  }

  @override
  String get privacyTitle => 'Gizlilik';

  @override
  String get privacyBody =>
      'LifeThreads yerel çalışır: hesap yok, herkese açık profil yok. Yedek dışa aktarmadıkça, şifreli bir kapsül paylaşmadıkça veya duvarını başka bir ekranda göstermedikçe anıların bu cihazda kalır.';

  @override
  String get viewPrivacyPolicy => 'Gizlilik politikasını gör';

  @override
  String get termsTitle => 'Kullanım koşulları';

  @override
  String get viewTerms => 'Koşulları gör';

  @override
  String get betaFeedbackTitle => 'Beta geri bildirimi';

  @override
  String get betaFeedbackBody =>
      'Güvenli tanılama bilgileriyle beta geri bildirimi gönder. Kayıtlar yalnızca uygulama olaylarını ve çökme türlerini içerir; anı metinleri, fotoğraf yolları, yedekler veya tam konumlar asla yer almaz.';

  @override
  String get closedBetaBadge => 'Kapalı beta';

  @override
  String get sendFeedback => 'Geri bildirim gönder';

  @override
  String get backupArchiveBody =>
      'Her şeyi – anılar, fotoğraflar, notlar, ipler ve düzen – tek bir dosyada sakla. Bilgisayarında ya da kendi bulutunda tut, şifrelemek için parola ekle.';

  @override
  String get backupArchiveTitle => 'Yedek';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Kilidi aç';

  @override
  String get exportArchive => 'Arşivi dışa aktar';

  @override
  String get importArchive => 'Arşivi içe aktar';

  @override
  String get importCapsule => 'Kapsülü içe aktar';

  @override
  String get moveDevices => 'Cihaz değiştir';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeBody =>
      'Özel duvarının havasını seç. Ücretsiz sürümde Sıcak Anı Odası var. Premium tüm havaları açar.';

  @override
  String get oneFreeBadge => '1 ücretsiz';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'Premium aboneliği etkin.';

  @override
  String get premiumLockedBody =>
      'Yıllık veya aylık: sınırsız anı, birden çok duvar, hikayeler, temalar ve düzenler.';

  @override
  String get activeBadge => 'Etkin';

  @override
  String get openPremium => 'Premium\'u aç';

  @override
  String get appVersionTitle => 'Uygulama sürümü';

  @override
  String get clearAllDataTitle => 'Tüm verileri sil';

  @override
  String get clearAllDataBody =>
      'Bu cihazdaki tüm anıları, bağlantıları, notları, çivileri ve kopyalanmış fotoğrafları siler.';

  @override
  String get clearData => 'Verileri sil';

  @override
  String exportFailed(Object error) {
    return 'Dışa aktarma başarısız: $error';
  }

  @override
  String importRejected(Object message) {
    return 'İçe aktarma reddedildi: $message';
  }

  @override
  String importFailed(Object error) {
    return 'İçe aktarma başarısız: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'Silme başarısız: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'Kapsül reddedildi: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'Kapsül içe aktarılamadı: $error';
  }

  @override
  String get clearAllDataQuestion => 'Tüm veriler silinsin mi?';

  @override
  String get clearAllDataQuestionBody =>
      'Bu, bu cihazdaki tüm yerel LifeThreads verilerini kalıcı olarak siler. Saklamak istiyorsan önce bir yedek dışa aktar.';

  @override
  String get clearAll => 'Tümünü sil';

  @override
  String get allLocalDataCleared => 'Tüm yerel veriler silindi.';

  @override
  String get feedbackGeneral => 'Genel geri bildirim';

  @override
  String get feedbackBug => 'Hata';

  @override
  String get feedbackCrash => 'Çökme';

  @override
  String get feedbackDesign => 'Tasarım sorunu';

  @override
  String get feedbackMissingFeature => 'Eksik özellik';

  @override
  String get feedbackPerformance => 'Performans';

  @override
  String get betaFeedbackIntro =>
      'Ne olduğunu ya da neyin tuhaf geldiğini yaz. Özel anı içeriği olmadan güvenli tanılama bilgileri eklenecek.';

  @override
  String get feedbackType => 'Tür';

  @override
  String get feedbackLabel => 'Geri bildirim';

  @override
  String get feedbackHint =>
      'Örnek: Ekle > Hızlı fotoğraf\'a dokundum ve ekran dondu.';

  @override
  String get betaFeedbackNotIncluded =>
      'Dahil değil: anı başlıkları, hikayeler, notlar, fotoğraf yolları, yedek yolları, tam konumlar.';

  @override
  String get feedbackEmpty => 'Önce kısa bir mesaj yaz.';

  @override
  String get feedbackCopied =>
      'E-posta uygulaması açılmadı. Geri bildirim info@gkcoding.dev için panoya kopyalandı.';

  @override
  String themeSelected(Object theme) {
    return '$theme seçildi.';
  }

  @override
  String get onboardingHeadline => 'Canlı duvarını kur.';

  @override
  String get onboardingBody =>
      'Fotoğrafların, yerlerin, insanların ve küçük notların duygusal iplerle birbirine bağlandığı özel bir anı odası.';

  @override
  String get onboardingPrivacy =>
      'Anıların varsayılan olarak özeldir: hesap yok, herkese açık profil yok. Şifreli bulut paylaşımı ve yedekleme yalnızca sen seçersen olur.';

  @override
  String get onboardingPrivacyShort =>
      'Hesap yok, herkese açık profil yok. Sen başka türlü seçmedikçe anıların bu cihazda kalır.';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get onboardingNameTitle => 'Sana nasıl hitap edelim?';

  @override
  String get onboardingNameHint => 'Adın';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'Tanıştığımıza memnun olduk, $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'Nasıl başlamak istersin?';

  @override
  String get onboardingGetStartedBody =>
      'Örnek bir duvara göz at ya da boş bir duvarla başlayıp kendi anılarını as.';

  @override
  String get settingsNameTitle => 'Adın';

  @override
  String get settingsNameBody => 'Duvarında selamlama olarak görünür.';

  @override
  String get settingsNameHint => 'Adın';

  @override
  String get settingsNameSaved => 'Ad güncellendi.';

  @override
  String get storyPrivacyTitle => 'Anıların özel kalır';

  @override
  String get storyConnectTitle => 'Anları bağla';

  @override
  String get storyConnectText =>
      'Anıları, notları ve yerleri bağla; her bölümün bir bağlamı olsun.';

  @override
  String get storyWallTitle => 'Canlı duvarını kur';

  @override
  String get storyWallText =>
      'Bir fotoğrafla başla, sonra duvarın canlı bir şeye dönüşene kadar büyüsün.';

  @override
  String get previewDemoWall => 'Örnek duvara bak';

  @override
  String get startFresh => 'Sıfırdan başla';

  @override
  String get optionalDemoPreview => 'İsteğe bağlı önizleme';

  @override
  String get quickTutorial => 'Hızlı rehber';

  @override
  String get tutorialIntro =>
      'Önce temeller – kaydet, bağla, düzenle – sonra duvarının yapabildiği her şey.';

  @override
  String get gotIt => 'Anladım';

  @override
  String get howItWorks => 'Nasıl çalışır';

  @override
  String get tutorialAddTitle => 'Anı ekle';

  @override
  String get tutorialAddText =>
      '+\'ya dokun, Anı veya Hızlı fotoğraf\'ı seç, sonra başlığı, tarihi, kişileri ve fotoğrafı kaydet. Kaydetmeden çıkarsan taslak olarak saklanır.';

  @override
  String get tutorialConnectTitle => 'Anıları bağla';

  @override
  String get tutorialConnectText =>
      'Bir kartı aç, bağla simgesine dokun, ilgili anıları seç ve kısa bir neden ekle.';

  @override
  String get tutorialArrangeTitle => 'Duvarı düzenle';

  @override
  String get tutorialArrangeText =>
      'Kartları, notları ve çivileri yerlerine sürükle. Görünüm › Düzenle onları tarihe, kategoriye veya yere göre sıralar – Bitti ile uygulanır.';

  @override
  String get tutorialShowBoardTitle => 'Panoyu göster';

  @override
  String get tutorialShowBoardText =>
      'Başka bir ekranda lifethreads.gkcoding.dev/display adresini aç, Daha fazla › Duvarı göster\'i seç ve kodu tarayarak geçici, salt okunur bir pano göster.';

  @override
  String get tutorialBackupTitle => 'Gizlilik ve yedek';

  @override
  String get tutorialBackupText =>
      'Ayarlar › Gizlilik › Uygulama kilidi, LifeThreads\'i Face ID ile açar. Telefon değiştirmeden önce Ayarlar › Yedek ve veriler\'den bir yedek dışa aktar.';

  @override
  String get scanDisplayQr => 'Ekran QR\'ını tara';

  @override
  String get scannerHintTitle => 'QR kod nerede?';

  @override
  String get addMemoryBeforeDisplay => 'Duvarı göstermeden önce bir anı ekle.';

  @override
  String get notLifeThreadsDisplayQr => 'Bu bir LifeThreads ekran QR\'ı değil.';

  @override
  String get displayWallQuestion => 'Bu duvar gösterilsin mi?';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads, taradığın tarayıcı oturumuna $memoryCount anı içeren geçici, salt okunur bir pano görüntüsü gönderecek. lifethreads.gkcoding.dev/display adresinde açılır ve süresi kendiliğinden dolar.';
  }

  @override
  String get displayAction => 'Göster';

  @override
  String get soon => 'yakında';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'Duvar $memoryCount anıyla $expires saatine kadar gösteriliyor.';
  }

  @override
  String get preparingWallDisplay => 'Duvar gösterimi hazırlanıyor...';

  @override
  String get open => 'Aç';

  @override
  String get edit => 'Düzenle';

  @override
  String get save => 'Kaydet';

  @override
  String get done => 'Bitti';

  @override
  String get back => 'Geri';

  @override
  String get continueAction => 'Devam';

  @override
  String get close => 'Kapat';

  @override
  String get add => 'Ekle';

  @override
  String get saveReason => 'Nedeni kaydet';

  @override
  String get chooseBackup => 'Yedek seç';

  @override
  String get chooseArchive => 'Arşiv seç';

  @override
  String get chooseCapsule => 'Kapsül seç';

  @override
  String get exportAction => 'Dışa aktar';

  @override
  String get addToWall => 'Duvara ekle';

  @override
  String get cinemaSkip => 'Geç';

  @override
  String get cinemaNotNow => 'Şimdi değil';

  @override
  String get cinemaSharedChapter => 'Paylaşılan bir anı bölümü';

  @override
  String get cinemaConnectedThread => 'Bağlı ip';

  @override
  String get cinemaInviteTitle => 'Bu anı duvarına eklensin mi?';

  @override
  String get useSelected => 'Seçilenleri kullan';

  @override
  String photoGridItem(String date) {
    return '$date tarihli fotoğraf';
  }

  @override
  String get noPhotosFound => 'Fotoğraf bulunamadı.';

  @override
  String get manage => 'Yönet';

  @override
  String get manageAccess => 'Erişimi yönet';

  @override
  String get saveNow => 'Şimdi kaydet';

  @override
  String get hangOnWall => 'Duvara as';

  @override
  String get placeHere => 'Buraya koy';

  @override
  String get openSettings => 'Ayarları aç';

  @override
  String get viewPremium => 'Premium\'u gör';

  @override
  String get memoryNotFound => 'Anı bulunamadı';

  @override
  String get memoryTypeMoment => 'An';

  @override
  String get memoryTypeTrip => 'Gezi';

  @override
  String get memoryTypePerson => 'Kişi';

  @override
  String get memoryTypePlace => 'Yer';

  @override
  String get memoryTypeNote => 'Not';

  @override
  String get memoryTypeMomentDescription => 'Saklamaya değer küçük bir sahne';

  @override
  String get memoryTypeTripDescription =>
      'Bir yolculuk ya da bir günlük kaçamak';

  @override
  String get memoryTypePersonDescription => 'Önemli biri';

  @override
  String get memoryTypePlaceDescription => 'Anlamı olan bir yer';

  @override
  String get memoryTypeNoteDescription =>
      'Bir düşünce, alıntı ya da hatırlatma';

  @override
  String get categoryPersonal => 'Kişisel';

  @override
  String get categoryFamily => 'Aile';

  @override
  String get categoryTravel => 'Seyahat';

  @override
  String get feelingWarm => 'Sıcak';

  @override
  String get feelingNostalgic => 'Nostaljik';

  @override
  String get feelingProud => 'Gururlu';

  @override
  String get feelingCalm => 'Huzurlu';

  @override
  String get feelingImportant => 'Önemli';

  @override
  String get feelingWarmDescription => 'Yumuşak, yakın, sevgi dolu.';

  @override
  String get feelingNostalgicDescription => 'Seni geçmişe götüren bir anı.';

  @override
  String get feelingProudDescription => 'Bir şeyi kanıtlayan bir an.';

  @override
  String get feelingCalmDescription => 'Sessiz, güvenli, huzurlu.';

  @override
  String get feelingImportantDescription => 'Hikâyeyi değiştiren bir anı.';

  @override
  String get addPeopleHint =>
      'Bu ana ait kişileri ekle. Kişiler cihazında kalır.';

  @override
  String get addPerson => 'Kişi ekle';

  @override
  String get editPerson => 'Kişiyi düzenle';

  @override
  String get chooseFromContacts => 'Kişilerden seç';

  @override
  String get personNameLabel => 'Ad';

  @override
  String get personNameHint => 'Kayıtlı kişileri aramak için yaz';

  @override
  String get relationshipLabel => 'Yakınlık';

  @override
  String get relationshipHint => 'Arkadaş, anne, partner...';

  @override
  String get phoneOptionalLabel => 'Telefon (isteğe bağlı)';

  @override
  String get emailOptionalLabel => 'E-posta (isteğe bağlı)';

  @override
  String get nameRelationshipRequired => 'Ad ve yakınlık zorunlu.';

  @override
  String get contactAccessDenied => 'Kişilere erişim izni verilmedi.';

  @override
  String get couldNotOpenContacts => 'Kişiler açılamadı.';

  @override
  String get chooseContact => 'Kişi seç';

  @override
  String get searchContacts => 'Kişilerde ara';

  @override
  String get noContactsFound => 'Kişi bulunamadı.';

  @override
  String get unnamedContact => 'Adsız kişi';

  @override
  String get contactRelationship => 'Kişi';

  @override
  String get couldNotLoadContacts => 'Kişiler yüklenemedi.';

  @override
  String get saveMomentTitle => 'Bir anı kaydet';

  @override
  String get todayEyebrow => 'Bugün';

  @override
  String get addMemoryStepTitle => 'Kaybetmek istemediğin ne oldu?';

  @override
  String get addMemoryStepSubtitle =>
      'Bir satır yaz, varsa bir fotoğraf ekle ve kaydet. Ayrıntılar bekleyebilir.';

  @override
  String get momentLabel => 'An';

  @override
  String get momentHint =>
      'Lara ile akşam yemeği, ilk lansman, sakin yürüyüş...';

  @override
  String get storyWorthLabel => 'Neden saklamaya değer?';

  @override
  String get storyWorthHint => 'Birkaç kelime yeter.';

  @override
  String get feelingEyebrow => 'Duygu';

  @override
  String get feelingStepTitle => 'Geri döndüğünde nasıl hissettirmeli?';

  @override
  String get feelingStepSubtitle =>
      'Böylece anıyı sonra yeniden bulmak kolaylaşır.';

  @override
  String get contextEyebrow => 'Bağlam';

  @override
  String get whenWasItTitle => 'Ne zamandı?';

  @override
  String get photoGpsStepSubtitle =>
      'Harita, seçilen fotoğraflarda kayıtlı GPS\'i kullanır. Fotoğrafta GPS yoksa yer gösterilmez.';

  @override
  String get peopleThreadsEyebrow => 'Kişiler ve ipler';

  @override
  String get peopleThreadsTitle => 'Bu kime ya da neye bağlı?';

  @override
  String get peopleThreadsSubtitle =>
      'İsteğe bağlı ayrıntılar tek tek anları bir hayat ipine dönüştürür.';

  @override
  String get connectExistingMemoryLabel => 'Var olan bir anıya bağla';

  @override
  String get noConnectionYet => 'Henüz bağlantı yok';

  @override
  String get connectionReasonLabel => 'Neden bağlılar?';

  @override
  String get connectionReasonHint =>
      'Örnek: aynı gezi, aynı kişi, önce / sonra...';

  @override
  String get writeMomentOrPhotoFirst => 'Önce bir an yaz ya da fotoğraf ekle.';

  @override
  String get todaysMoment => 'Bugünün anı';

  @override
  String get savedFromTodaysPrompt => 'Bugünün sorusundan kaydedildi.';

  @override
  String get saveItBeforeItFades => 'Solmadan kaydet';

  @override
  String get chooseDate => 'Tarih seç';

  @override
  String get dateLabel => 'Tarih';

  @override
  String get untitledMemory => 'Başlıksız anı';

  @override
  String get organize => 'Düzenle';

  @override
  String get memoryShape => 'Anının biçimi';

  @override
  String get wallCategory => 'Duvar kategorisi';

  @override
  String get privatePhotos => 'Özel fotoğraflar';

  @override
  String get pick => 'Seç';

  @override
  String get addMore => 'Daha ekle';

  @override
  String get takePhoto => 'Fotoğraf çek';

  @override
  String get takePhotosNow => 'Şimdi fotoğraf çek';

  @override
  String get takePhotosFabTooltip => 'Yeni bir anı için fotoğraf çek';

  @override
  String get takeAnotherPhoto => 'Bir fotoğraf daha çek';

  @override
  String get continueWithPhotos => 'Bu fotoğraflarla devam et';

  @override
  String get addPhotosToMemory => 'Anıya ekle';

  @override
  String get takeAnotherOrContinueBody =>
      'Bu anı için çekmeye devam et ya da ilerleyip hikâyeyi ekle.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotoğraf çekildi',
      one: '1 fotoğraf çekildi',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads seçilen fotoğrafları uygulamanın özel alanına kopyalar ve varsa tarih/konum bilgisini korur.';

  @override
  String get limitedPhotoAccessActive =>
      'Sınırlı fotoğraf erişimi etkin. Daha fazla fotoğrafa izin verebilirsin.';

  @override
  String get selectPhotos => 'Fotoğraf seç';

  @override
  String get photoAccessOff => 'Fotoğraf erişimi kapalı';

  @override
  String get photoAccessOffBody =>
      'Anı seçmek için fotoğraf erişimini aç. Fotoğrafların bu cihazda kalır.';

  @override
  String get freeMemoryLimitReached => 'Ücretsiz anı sınırına ulaşıldı';

  @override
  String get freeMemoryLimitBody =>
      'Ücretsiz duvarlar 30 anı içerir. Canlı duvarını büyütmeye devam etmek için yükselt.';

  @override
  String get photoAccessNeeded => 'Önce fotoğraf erişimi gerekiyor.';

  @override
  String get quickPhotoMemory => 'Hızlı fotoğraf anısı';

  @override
  String get quickPhotoDescription =>
      'Saklamaya değer bir fotoğraf. Hikâyeyi istediğin zaman ekle.';

  @override
  String get hangQuickPhoto => 'Hızlı fotoğrafı as';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'Fotoğraf GPS\'i bulundu: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'Fotoğrafta GPS bulunamadı. Bu anı haritada görünmeyecek.';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • $photoCount fotoğraf';
  }

  @override
  String metadataDates(int count, int total) {
    return '$count/$total tarih';
  }

  @override
  String metadataLocations(int count, int total) {
    return '$count/$total konum';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total boyut';
  }

  @override
  String newSelected(int count) {
    return '$count yeni seçildi';
  }

  @override
  String selectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get editMemoryTitle => 'Anıyı düzenle';

  @override
  String get storyPanel => 'Hikâye';

  @override
  String get memoryTitleLabel => 'Anı başlığı';

  @override
  String get addTitleValidation => 'Başlık ekle';

  @override
  String get storyDescriptionLabel => 'Hikâye / açıklama';

  @override
  String get addStoryValidation => 'Kısa bir hikâye ekle';

  @override
  String get shapeFeelingTitle => 'Biçim ve duygu';

  @override
  String get memoryTypeLabel => 'Anı türü';

  @override
  String get feelingLabel => 'Duygu';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get timePhotoGpsTitle => 'Zaman ve fotoğraf GPS\'i';

  @override
  String get memoryDateLabel => 'Anı tarihi';

  @override
  String get peopleTitle => 'Kişiler';

  @override
  String get galleryTitle => 'Galeri';

  @override
  String get addPhotos => 'Fotoğraf ekle';

  @override
  String get saveMemory => 'Anıyı kaydet';

  @override
  String get memorySaveFailed => 'Bu anı kaydedilemedi. Lütfen tekrar dene.';

  @override
  String get passwordOnlySpaces => 'Parola yalnızca boşluktan oluşamaz.';

  @override
  String get somethingWentWrong => 'Bir şeyler ters gitti. Lütfen tekrar dene.';

  @override
  String get mapUnavailable => 'Harita şu anda kullanılamıyor.';

  @override
  String get coverPhoto => 'Kapak fotoğrafı';

  @override
  String get galleryPhoto => 'Galeri fotoğrafı';

  @override
  String get setAsCover => 'Kapak yap';

  @override
  String get replacePhoto => 'Fotoğrafı değiştir';

  @override
  String get removePhoto => 'Fotoğrafı kaldır';

  @override
  String get choosePhoto => 'Fotoğraf seç';

  @override
  String get threadReasonsTitle => 'İp nedenleri';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'Bağlamadan önce daha fazla anı oluştur.';

  @override
  String get connectionHeaderBody =>
      'Anıları bir nedenle bağla. İp, iki anın neden birlikte olduğunu anlatmalı.';

  @override
  String get connectedMemory => 'bağlı anı';

  @override
  String get whyConnectedTitle => 'Neden bağlılar?';

  @override
  String get exportPremiumArchiveTitle => 'Yedeği dışa aktar';

  @override
  String get importArchiveTitle => 'Arşivi içe aktar';

  @override
  String get archiveExportBody =>
      'Arşivi şifrelemek için parola ekle. Normal bir yerel zip için boş bırak.';

  @override
  String get archiveImportBody =>
      'Arşiv şifreliyse parolasını gir. Eski veya korumasız yedekler için boş bırak.';

  @override
  String get archivePasswordOptional => 'Arşiv parolası (isteğe bağlı)';

  @override
  String get archivePasswordLabel => 'Arşiv parolası';

  @override
  String get archivePasswordWarning =>
      'Parolayı güvenli bir yerde sakla. Kaybedersen kurtarılamaz.';

  @override
  String get sendArchiveTitle => 'LifeThreads arşivini gönder';

  @override
  String get sendArchiveSubject => 'LifeThreads anı arşivi';

  @override
  String get sendEncryptedArchiveText =>
      'Şifreli LifeThreads arşivi. Başka bir cihaza aktarmak için seçtiğin parolayı kullan.';

  @override
  String get sendArchiveText =>
      'LifeThreads arşivi. Anı duvarını başka bir cihazda açmak için LifeThreads\'e aktar.';

  @override
  String get archiveReadyToSend =>
      'Yedek hazır. Bu telefonun dışında, güvenli bir yerde sakla.';

  @override
  String get archiveNotSaved =>
      'Yedek kaydedilmedi. Hazır olduğunda yeniden dışa aktar.';

  @override
  String get archiveSharingUnavailable => 'Bu cihazda paylaşım kullanılamıyor.';

  @override
  String archiveShareFailed(Object error) {
    return 'Arşiv kaydedildi ama paylaşılamadı: $error';
  }

  @override
  String get archiveImportedTitle => 'Arşiv içe aktarıldı';

  @override
  String get memoriesLabel => 'Anılar';

  @override
  String get photosLabel => 'Fotoğraflar';

  @override
  String get wallNotesNailsLabel => 'Duvar notları / çiviler';

  @override
  String get connectionsLabel => 'Bağlantılar';

  @override
  String get archiveImportSummary =>
      'Mevcut duvarın korundu. İçe aktarılan anılar güvenle eklendi.';

  @override
  String get shareEncryptedCapsuleTitle => 'Şifreli kapsül paylaş';

  @override
  String get openSharedCapsuleTitle => 'Paylaşılan kapsülü aç';

  @override
  String get exportMemoryCapsuleTitle => 'Anı kapsülünü dışa aktar';

  @override
  String get importCapsuleDialogTitle => 'Kapsülü içe aktar';

  @override
  String get secureSharePasswordBody =>
      'Bu kapsülü yüklemeden önce bir parola oluştur. Parolayı alacak kişiye ayrıca gönder.';

  @override
  String get sharedCapsulePasswordBody =>
      'Bu paylaşılan anı için aldığın parolayı gir.';

  @override
  String get capsuleExportBody =>
      'Bu anı göndermeden önce korunmalıysa parola ekle. Normal bir kapsül için boş bırak.';

  @override
  String get capsuleImportBody =>
      'Kapsülün parolası varsa gir. Yoksa boş bırak.';

  @override
  String get capsulePasswordLabel => 'Kapsül parolası';

  @override
  String get sharedCapsulePasswordLabel => 'Paylaşılan kapsül parolası';

  @override
  String get capsulePasswordOptional => 'Kapsül parolası (isteğe bağlı)';

  @override
  String get capsulePasswordWarning =>
      'LifeThreads bu parolayı sonradan kurtaramaz.';

  @override
  String get passwordRequiredCloudSharing =>
      'Bulut paylaşımı için parola gerekli.';

  @override
  String get createSecureShare => 'Güvenli paylaşım oluştur';

  @override
  String get previewMemory => 'Anıyı önizle';

  @override
  String get sendCapsuleTitle => 'LifeThreads anısı paylaş';

  @override
  String get sendCapsuleSubject => 'LifeThreads anı kapsülü';

  @override
  String get sendEncryptedCapsuleText =>
      'Selam, seninle korumalı bir LifeThreads anısı paylaştım. İçe aktarmak için sana gönderdiğim parolayı kullan.';

  @override
  String get sendCapsuleText =>
      'Selam, seninle bir LifeThreads anısı paylaştım. Duvarına eklemek için kapsülü LifeThreads\'e aktar.';

  @override
  String get capsuleReadyToSend => 'Kapsül gönderilmeye hazır.';

  @override
  String get capsuleSavedLater => 'Kapsül kaydedildi. Sonra paylaşabilirsin.';

  @override
  String get capsuleSharingUnavailable =>
      'Kapsül kaydedildi ama paylaşım kullanılamıyor.';

  @override
  String capsuleShareFailed(Object error) {
    return 'Kapsül kaydedildi ama paylaşılamadı: $error';
  }

  @override
  String get importThisMemory => 'Bu anı içe aktarılsın mı?';

  @override
  String get noStoryTextIncluded => 'Hikâye metni yok.';

  @override
  String get placeLabel => 'Yer';

  @override
  String get notesLabel => 'Notlar';

  @override
  String get capsulePasswordProtected => 'Bu kapsül parola korumalıydı.';

  @override
  String get openingSharedMemory => 'Paylaşılan anı açılıyor...';

  @override
  String get lifeThreadsMemoryTitle => 'LifeThreads anısı';

  @override
  String shareMemoryText(Object url) {
    return 'Selam, LifeThreads\'te seninle bir anı paylaştım.\n\n$url';
  }

  @override
  String get shareLinkReady => 'Paylaşım bağlantısı hazır.';

  @override
  String get shareLinkCreated => 'Paylaşım bağlantısı oluşturuldu.';

  @override
  String get shareLinkUnavailable =>
      'Bağlantı oluşturuldu ama paylaşım kullanılamıyor.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label Bağlantının süresi kendiliğinden dolar. İstersen şimdi silebilirsin.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'Bulut paylaşımı başarısız: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'Paylaşılan anı bağlantısı silindi.';

  @override
  String get creatingSecureMemoryLink =>
      'Güvenli anı bağlantısı oluşturuluyor...';

  @override
  String get shareMemoryCapsule => 'Anı kapsülünü paylaş';

  @override
  String get editStory => 'Hikâyeyi düzenle';

  @override
  String get metaType => 'Tür';

  @override
  String get metaFeeling => 'Duygu';

  @override
  String get metaCategory => 'Kategori';

  @override
  String get metaDate => 'Tarih';

  @override
  String get storyEyebrow => 'Hikâye';

  @override
  String get whyMemoryMatters => 'Bu anı neden önemli';

  @override
  String get galleryEyebrow => 'Galeri';

  @override
  String editSectionTooltip(String section) {
    return 'Düzenle: $section';
  }

  @override
  String get openInMaps => 'Haritalar\'da aç';

  @override
  String get memoryChangesSaved => 'Değişiklikler kaydedildi.';

  @override
  String get memoryDeletedToast => 'Anı silindi.';

  @override
  String get noteDeletedToast => 'Not silindi.';

  @override
  String get nailDeletedToast => 'Çivi kaldırıldı.';

  @override
  String get undo => 'Geri al';

  @override
  String photoPlaceDetected(String place) {
    return 'Fotoğraftaki yer: $place';
  }

  @override
  String get settingsGroupYou => 'Sen';

  @override
  String get settingsGroupReminders => 'Hatırlatıcılar';

  @override
  String get settingsGroupMore => 'Diğer';

  @override
  String get backupDataTitle => 'Yedek ve veriler';

  @override
  String get backupDataSubtitle => 'Yedekle, geri yükle, yeni telefona geç';

  @override
  String get aboutHelpTitle => 'Hakkında ve yardım';

  @override
  String get aboutHelpSubtitle => 'Geri bildirim, gizlilik, müzik, sürüm';

  @override
  String get discardChangesTitle => 'Değişiklikler silinsin mi?';

  @override
  String get discardChangesBody => 'Burada değiştirdiklerin kaybolacak.';

  @override
  String get discardChanges => 'Vazgeç';

  @override
  String get keepEditing => 'Düzenlemeye devam et';

  @override
  String get settingsGroupPrivacy => 'Gizlilik';

  @override
  String get appLockTitle => 'Uygulama kilidi';

  @override
  String get appLockSubtitle => 'LifeThreads\'i açmak için Face ID veya kod';

  @override
  String get appLockReason => 'Anılarının kilidini aç';

  @override
  String get appLockLockedTitle => 'LifeThreads kilitli';

  @override
  String get appLockUnlock => 'Kilidi aç';

  @override
  String get appLockUnavailable =>
      'Önce bu telefonda Face ID veya bir kod ayarla.';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years yıl önceki bir anı seni bekliyor.',
      one: '1 yıl önceki bir anı seni bekliyor.',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Ara';

  @override
  String get searchHint => 'Başlık, yer, kişi veya yıl';

  @override
  String get searchClear => 'Aramayı temizle';

  @override
  String get searchNoResults => 'Eşleşen anı yok.';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı',
      one: '1 anı',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => 'Anılarda ara';

  @override
  String get premiumFeatureWalls => 'Daha fazla duvar';

  @override
  String get newWall => 'Yeni duvar';

  @override
  String get wallNameLabel => 'Duvar adı';

  @override
  String get newWallHint => 'örn. Gezi 2025';

  @override
  String get createWall => 'Oluştur';

  @override
  String get renameWall => 'Yeniden adlandır';

  @override
  String get deleteWall => 'Duvarı sil';

  @override
  String deleteWallQuestion(String name) {
    return '“$name” silinsin mi?';
  }

  @override
  String get deleteWallBody =>
      'Anıları Duvarım\'a taşınır; hiçbir şey kaybolmaz.';

  @override
  String get personalWallSubtitle => 'Duvarın, bu cihazda';

  @override
  String get wallOptions => 'Duvar seçenekleri';

  @override
  String get moveToWall => 'Duvara taşı…';

  @override
  String movedToWall(String name) {
    return 'Taşındı: $name.';
  }

  @override
  String get hideMemory => 'Gizle';

  @override
  String get unhideMemory => 'Yeniden göster';

  @override
  String get memoryHiddenToast =>
      'Gizlendi. Görünüm › Gizli anılar altında bulabilirsin.';

  @override
  String get showHiddenMemories => 'Gizli anılar';

  @override
  String get showHiddenReason => 'Gizli anıları göster';

  @override
  String get yearThreadFirstTitle => 'İlk Yılın İpliği';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '3 anıdan $count',
      one: '3 anıdan 1\'i',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => 'Ya da şimdi bir hikaye oluştur';

  @override
  String get moveMemoriesHere => 'Anıları buraya taşı';

  @override
  String get moveMemoriesTitle => 'Buraya taşınacak anıları seç';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anıyı taşı',
      one: '1 anıyı taşı',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'Tümünü göster';

  @override
  String get addAMemory => 'Anı ekle';

  @override
  String get mapAddPhotoMemory => 'Yeriyle birlikte bir fotoğraf ekle';

  @override
  String get searchSuggestions => 'Kendi anılarından birini dene';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Bu hafta, $years yıl önce',
      one: 'Bu hafta, 1 yıl önce',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => 'Kimler vardı?';

  @override
  String get premiumPlanYearly => 'Yıllık';

  @override
  String get premiumPlanMonthly => 'Aylık';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/yıl';
  }

  @override
  String premiumSavePercent(int percent) {
    return '%$percent tasarruf';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'Ödeme $store hesabından alınır. Abonelik, mevcut dönemin bitiminden en az 24 saat önce iptal edilmezse her yıl otomatik olarak yenilenir. $store hesap ayarlarından yönetebilir veya iptal edebilirsin.';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıtlı fotoğraf',
      one: '1 kayıtlı fotoğraf',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => 'Kişiler';

  @override
  String get partOfMemory => 'Bu anının parçası';

  @override
  String get notesEyebrow => 'Notlar';

  @override
  String get attachedThoughts => 'Eklenen düşünceler';

  @override
  String get stickyNote => 'Yapışkan not';

  @override
  String get placeEyebrow => 'Yer';

  @override
  String get threadsEyebrow => 'İpler';

  @override
  String get connectedMemories => 'Bağlı anılar';

  @override
  String get noConnectedMemoriesYet =>
      'Henüz bağlı anı yok. Görünür bir hayat ipi başlatmak için bu bölümü başka bir ana bağla.';

  @override
  String get backToWall => 'Duvara dön';

  @override
  String get addTextToWall => 'Duvara metin ekle';

  @override
  String get addTextAction => 'Metin ekle';

  @override
  String get textNoteHint => 'Küçük bir anı, alıntı ya da not yaz...';

  @override
  String get placeTextNote => 'Metin notunu yerleştir';

  @override
  String get placeRopeAnchor => 'İp çapasını yerleştir';

  @override
  String get nailSubtitle => 'Çivi, anılar arasında ipleri elle bağlayabilir.';

  @override
  String get clearDemoWallQuestion => 'Örnek duvar silinsin mi?';

  @override
  String get clearDemoWallBody =>
      'Örnek anılar kaldırılır, böylece boş ve özel bir duvarla başlarsın.';

  @override
  String get importBackupQuestion => 'Yedek içe aktarılsın mı?';

  @override
  String get importBackupBody =>
      'Bu, anıları bir LifeThreads arşivinden geri yükler ve mevcut duvarını korur.';

  @override
  String get deleteMemoryQuestion => 'Anı silinsin mi?';

  @override
  String get deleteMemoryBody =>
      'Anı ve duvardaki tüm bağlantıları kaldırılır.';

  @override
  String get editText => 'Metni düzenle';

  @override
  String get editTextTitle => 'Metni düzenle';

  @override
  String get connectRope => 'İp bağla';

  @override
  String get connectRopeSubtitle => 'Bu çiviyi anılara bağla.';

  @override
  String get deleteNail => 'Çiviyi sil';

  @override
  String get connectNailTitle => 'Çiviyi anılara bağla';

  @override
  String get connectNailSubtitle => 'Seçilen anılar bu çapaya asılır.';

  @override
  String get timelineTitle => 'Zaman çizelgesi';

  @override
  String get timelineSubtitle => 'Anıların zamana göre sıralı.';

  @override
  String get noMemoriesFilter => 'Bu filtrede anı yok';

  @override
  String get noMemoriesFilterBody =>
      'Zaman çizelgesi için filtreyi değiştir ya da bir anı ekle.';

  @override
  String get memoryMapTitle => 'Anı haritası';

  @override
  String get memoryMapSubtitle => 'Anıların yere göre gruplu.';

  @override
  String get noMappedMemories => 'Haritada henüz anı yok';

  @override
  String get displayWallTooltip => 'Duvarı göster';

  @override
  String get tutorialTooltip => 'Rehber';

  @override
  String get settingsTooltip => 'Ayarlar';

  @override
  String get freeformLayout => 'Serbest';

  @override
  String get categoryLayout => 'Kategori';

  @override
  String get locationLayout => 'Konum';

  @override
  String get saveToday => 'Bugünü kaydet';

  @override
  String get rememberThis => 'Bunu hatırla';

  @override
  String get whatHappenedToday => 'Bugün ne oldu?';

  @override
  String get tapToOpenDrag => 'Açmak için dokun • taşımak için sürükle';

  @override
  String get demoWallPreview =>
      'Örnek duvar önizlemesi. Sıfırdan başlamaya hazır olunca sil.';

  @override
  String get clearDemo => 'Örneği sil';

  @override
  String get chooseQuickPhoto => 'Hızlı fotoğraf seç';

  @override
  String get wallView => 'Duvar';

  @override
  String get timelineView => 'Zaman çizelgesi';

  @override
  String get mapView => 'Harita';

  @override
  String get wallFilterAll => 'Tümü';

  @override
  String get wallViewButton => 'Görünüm';

  @override
  String get wallShowAs => 'Şöyle göster';

  @override
  String get wallArrange => 'Düzenle';

  @override
  String get wallShowOnly => 'Göster';

  @override
  String get layoutByDate => 'Tarihe göre';

  @override
  String get moreActionsTooltip => 'Daha fazla';

  @override
  String get addToWallTitle => 'Duvarına ekle';

  @override
  String get expandableMemory => 'Anı';

  @override
  String get expandableMemorySubtitle => 'Rehberli tam hikâye';

  @override
  String get expandableQuickPhoto => 'Hızlı fotoğraf anısı';

  @override
  String get expandableQuickPhotoSubtitle => 'Fotoğraf seç ve as';

  @override
  String get expandableTextNote => 'Metin notu';

  @override
  String get expandableTextNoteSubtitle => 'Duvarda küçük bir düşünce';

  @override
  String get expandableNail => 'Çivi / ip çapası';

  @override
  String get expandableNailSubtitle => 'Elle ip noktası';

  @override
  String get startWithOneThing => 'Bugünden bir şeyle başla';

  @override
  String get emptyWallBody =>
      'Bir anı solmadan kaydet. Bir cümle ya da bir fotoğraf yeter.';

  @override
  String get usePhoto => 'Fotoğraf kullan';

  @override
  String get editMemoryTooltip => 'Anıyı düzenle';

  @override
  String get connectMemoryTooltip => 'Anıyı bağla';

  @override
  String get archiveTransferTitle => 'Başka bir cihazda aç';

  @override
  String get archiveTransferHeroTitle =>
      'Anılarını cihazlar arasında güvenle taşı.';

  @override
  String get archiveTransferHeroBody =>
      'Yedek; anıların, fotoğrafların, notların, iplerin, duvardaki konumlar ve meta verilerle tek bir zip dosyasıdır, istersen parolalı. Kopyasını saklamayız: nereye gideceğine sen karar verirsin.';

  @override
  String get archiveTransferStep1Title => 'Arşiv dışa aktar';

  @override
  String get archiveTransferStep1Body =>
      'Ayarlar\'ı aç, Arşivi dışa aktar\'ı seç ve parola koruması istersen parola ekle.';

  @override
  String get archiveTransferStep2Title => 'Zip\'i taşı';

  @override
  String get archiveTransferStep2Body =>
      'AirDrop, USB, kendi bulut alanın ya da e-postayla aktar.';

  @override
  String get archiveTransferStep3Title => 'Güvenle içe aktar';

  @override
  String get archiveTransferStep3Body =>
      'Diğer cihaza LifeThreads\'i yükle, Arşivi içe aktar\'ı seç, gerekirse parolayı gir ve mevcut verileri silmeden geri yükle.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled =>
      'Geliştirme için Premium kilidi açıldı.';

  @override
  String get lifetimeActive => 'Abonelik etkin';

  @override
  String get oneTimeLifetimeUnlock => 'Yıllık veya aylık';

  @override
  String get premiumHeroActiveTitle => 'Anı duvarın sınırsız.';

  @override
  String get premiumHeroLockedTitle => 'Anılarını hikayelere dönüştür.';

  @override
  String get premiumHeroActiveBody =>
      'Premium aboneliğin etkin. Müzikli hikayeler, Yılın İpliği, aile duvarları ve sınırsız anı artık senin.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'Ücretsiz sürümde $limit anı ve tam yedekleme var. Premium; müzikli hikayeler ve filmler, Yılın İpliği, aile duvarları ve sınırsız anı ekler.';
  }

  @override
  String get premiumMemories => 'Premium anılar';

  @override
  String get freeMemories => 'Ücretsiz anılar';

  @override
  String get unlimited => 'sınırsız';

  @override
  String get benefitUnlimitedTitle => 'Sınırsız anı';

  @override
  String get benefitUnlimitedBody =>
      '30 anı sınırı yok. Hayat büyüdükçe duvarını büyütmeye devam et.';

  @override
  String get benefitThemesTitle => 'Premium duvar temaları';

  @override
  String get benefitThemesBody =>
      'Daha zengin havaları, sınırlı mevsim temalarını ve günün saatine göre Otomatik\'i aç.';

  @override
  String get benefitLayoutsTitle => 'Gelişmiş düzenler';

  @override
  String get benefitLayoutsBody =>
      'İpleri, zaman çizelgelerini, çapaları ve anı gruplarını düzenlemenin daha fazla yolu.';

  @override
  String get lifetimeUnlock => 'Premium abonelik';

  @override
  String get premiumActiveOnDevice => 'Premium bu cihazda etkin.';

  @override
  String onePurchaseBody(String store) {
    return 'Müzikli hikayeler, Yılın İpliği, aile duvarları ve sınırsız anı için yıllık veya aylık abone ol. $store ayarlarından istediğin zaman iptal et.';
  }

  @override
  String get premiumActiveButton => 'Premium etkin';

  @override
  String get processing => 'İşleniyor...';

  @override
  String get unlockPremium => 'Premium\'a abone ol';

  @override
  String get restorePurchase => 'Aboneliği geri yükle';

  @override
  String get enableDebugMockUnlock => 'Test kilidini aç';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'Ödeme $store hesabından alınır. Abonelik, mevcut dönemin bitiminden en az 24 saat önce iptal edilmezse her ay otomatik olarak yenilenir. $store hesap ayarlarından yönetebilir veya iptal edebilirsin.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'Mağaza güncellemesi başarısız. Lütfen tekrar dene.';

  @override
  String get premiumMessageStoreUnavailable =>
      'Bu cihazda satın alma kullanılamıyor.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium henüz mağazada yok. Lütfen daha sonra tekrar dene.';

  @override
  String get premiumMessageLoadFailed =>
      'Premium mağazadan yüklenemedi. Lütfen tekrar dene.';

  @override
  String get premiumMessageOpeningCheckout => 'Ödeme açılıyor…';

  @override
  String get premiumMessageCheckoutFailed =>
      'Ödeme açılamadı. Lütfen tekrar dene.';

  @override
  String get premiumMessageChecking => 'Aboneliğin kontrol ediliyor…';

  @override
  String get premiumMessageRestoreFailed =>
      'Geri yükleme başarısız. Lütfen tekrar dene.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'Etkin bir Premium aboneliği bulunamadı.';

  @override
  String get premiumMessagePending =>
      'Satın alman beklemede. Onaylanınca Premium açılır.';

  @override
  String get premiumMessagePurchaseFailed =>
      'Satın alma tamamlanmadı. Lütfen tekrar dene.';

  @override
  String get premiumMessageCanceled => 'Satın alma iptal edildi.';

  @override
  String get premiumMessageRestored => 'Premium aboneliğin geri yüklendi.';

  @override
  String get premiumMessageActive => 'Premium aboneliğin etkin.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/ay';
  }

  @override
  String get loadingPlayStoreProduct => 'Abonelik yükleniyor…';

  @override
  String get playStoreUnavailable => 'Mağaza şu anda kullanılamıyor';

  @override
  String get productNotConfigured => 'Premium şu anda kullanılamıyor';

  @override
  String get purchasePending => 'Satın alma beklemede';

  @override
  String get purchased => 'Satın alındı';

  @override
  String get restored => 'Geri yüklendi';

  @override
  String get premiumTryAgain => 'Tekrar dene';

  @override
  String get purchaseFailed => 'Satın alma başarısız';

  @override
  String get preparingCheckout => 'Ödeme hazırlanıyor...';

  @override
  String get premiumLocalFirstTitle => 'Premium da yerel';

  @override
  String get premiumLocalFirstBody =>
      'Anıların cihazında kalır ve yedekleme herkes için ücretsizdir.';

  @override
  String get noMappedMemoriesBody =>
      'Anıları burada görmek için GPS bilgisi olan fotoğraflar ekle.';

  @override
  String get peopleLabel => 'Kişiler';

  @override
  String get connect => 'Bağla';

  @override
  String get themeWarmMemoryRoom => 'Sıcak Anı Odası';

  @override
  String get themeWarmMemoryRoomDescription =>
      'Yumuşak koyu sıcaklık, altın ışık ve özel bir oda derinliği.';

  @override
  String get themeMidnightArchive => 'Gece Yarısı Arşivi';

  @override
  String get themeMidnightArchiveDescription =>
      'Müze sessizliğinde koyu mavi bir arşiv odası.';

  @override
  String get themeSoftPaperWall => 'Yumuşak Kâğıt Duvar';

  @override
  String get themeSoftPaperWallDescription =>
      'Krem kâğıt, mürekkep gölgeleri ve sakin bir albüm havası.';

  @override
  String get themeTravelCorkboard => 'Seyahat Mantar Panosu';

  @override
  String get themeTravelCorkboardDescription =>
      'Geziler ve yerler için harita izli sıcak mantar pano.';

  @override
  String get themeAutoTitle => 'Günün saatine göre otomatik';

  @override
  String get themeAutoDescription =>
      'Gündüz Yumuşak Kâğıt Duvar, akşam Sıcak Anı Odası, gece Gece Yarısı Arşivi.';

  @override
  String get themeAutoSelected => 'Duvarın artık günün saatini izliyor.';

  @override
  String get themeSeasonalTitle => 'Mevsimlik';

  @override
  String get themeSeasonalBody =>
      'Sınırlı Premium temaları, her biri yalnızca kendi mevsiminde.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString tarihine kadar';
  }

  @override
  String get themeUseButton => 'Bu temayı kullan';

  @override
  String get themeInUse => 'Kullanımda';

  @override
  String get themeUnlockButton => 'Premium ile aç';

  @override
  String get themeAutumnHarvest => 'Sonbahar Hasadı';

  @override
  String get themeAutumnHarvestDescription =>
      'Kehribar ışık, kraft kâğıt kartlar ve düşen yaprakların parıltısı.';

  @override
  String get themeWinterLights => 'Kış Işıkları';

  @override
  String get themeWinterLightsDescription =>
      'Buzlu kartlar ve soğuk mavi bir gecede sıcak ışık zincirleri.';

  @override
  String get themeSpringBlossom => 'Bahar Çiçeği';

  @override
  String get themeSpringBlossomDescription =>
      'Yumuşak pembe ışıltılı soluk çiçek kartları.';

  @override
  String get themeSummerEvening => 'Yaz Akşamı';

  @override
  String get themeSummerEveningDescription =>
      'Gün batımı renkleri ve şipşak fotoğraf kartları.';

  @override
  String get themeYearRoundTitle => 'Her zaman açık';

  @override
  String get themeComingTitle => 'Yakında';

  @override
  String get themeComingBody =>
      'Gelecek mevsimlere göz at. Her tema kendi mevsiminin ilk günü açılır.';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString itibarıyla';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tüm temaları gör, $count tanesi bu mevsime özel',
      one: 'Tüm temaları gör, 1 tanesi bu mevsime özel',
      zero: 'Tüm temaları gör',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => 'Deniz Kenarı';

  @override
  String get themeSeasideDescription =>
      'Turkuaz su, kum renkli kâğıt ve sıcak yaz ışığı.';

  @override
  String get themeSnowyCabin => 'Karlı Kulübe';

  @override
  String get themeSnowyCabinDescription =>
      'Şömine başında ahşap, buzlu kartlar ve dışarıda yumuşak kar.';

  @override
  String get themeSpringMeadow => 'Bahar Çayırı';

  @override
  String get themeSpringMeadowDescription =>
      'Taze yeşil çimen, açık renk kartlar ve sarı güneş.';

  @override
  String get themeMistyForest => 'Sisli Orman';

  @override
  String get themeMistyForestDescription =>
      'Sessiz çamlar, sabah sisi ve altın yapraklar.';

  @override
  String get demoFirstDanceTitle => 'İlk dansımız';

  @override
  String get demoFirstDanceStory =>
      'Grup bizim şarkımızı çaldı ve bütün ahır sessizleşti. İki kez ayağına bastım, sen baştan sona güldün ve üç dakika boyunca başka kimse yoktu.';

  @override
  String get demoFirstDancePlace => 'Salzburg';

  @override
  String get demoNewbornTitle => 'Evine hoş geldin, Lina';

  @override
  String get demoNewbornStory =>
      'Bütün eli tek bir parmağı sarıyordu. Evdeki ilk sessiz sabah.';

  @override
  String get demoNewbornPlace => 'Viyana';

  @override
  String get demoBeachSunsetTitle => 'Deniz kenarında yaz';

  @override
  String get demoBeachSunsetStory =>
      'Güneş batana kadar yalınayak, dönüş yolunda Lina omuzlarında uyuyor.';

  @override
  String get demoBeachSunsetPlace => 'Split, Hırvatistan';

  @override
  String get demoGrandmaKitchenTitle => 'Büyükannemin mutfağı';

  @override
  String get demoGrandmaKitchenStory =>
      'Kayısılı keki, sonunda yazıya geçti – ve her yer un.';

  @override
  String get demoGrandmaKitchenPlace => 'Graz';

  @override
  String get demoGraduationTitle => 'Mezuniyet günü';

  @override
  String get demoGraduationStory => 'Kepler daha yere düşmeden babam ağladı.';

  @override
  String get demoGraduationPlace => 'Innsbruck';

  @override
  String get demoFirstHomeTitle => 'İlk evimizin anahtarları';

  @override
  String get demoFirstHomeStory =>
      'Henüz mobilya yok, sadece kutular, yerde pizza ve bir sürü plan.';

  @override
  String get demoFirstHomePlace => 'Linz';

  @override
  String get demoAlpineSummitTitle => 'Bulutların üstünde';

  @override
  String get demoAlpineSummitStory =>
      'Bunun için sabah 4\'te kalktık. Her adımına değdi.';

  @override
  String get demoAlpineSummitPlace => 'Grossglockner';

  @override
  String get demoFirstBikeTitle => 'İlk tur, eller serbest';

  @override
  String get demoFirstBikeStory =>
      'Üç pedal, biraz sallanma, sonra gitti – hem de ne gururlu.';

  @override
  String get demoFirstBikePlace => 'Prater, Viyana';

  @override
  String get demoGardenDinnerTitle => 'Dedemin 80. yaşı';

  @override
  String get demoGardenDinnerStory =>
      'Uzun bir masada dört kuşak, en güzel hikâyeleri yine o anlattı.';

  @override
  String get demoGardenDinnerPlace => 'Wachau';

  @override
  String get demoThreadFirstDanceToFirstHome => 'Bizim hikâyemiz';

  @override
  String get demoThreadFirstHomeToNewborn => 'Sonra Lina geldi';

  @override
  String get demoThreadNewbornToBeachSunset => 'İlk yazı';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'Aile';

  @override
  String get demoThreadGraduationToFirstHome => 'Yeni bölüm';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'Küçük maceralar';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'Dede izliyordu';

  @override
  String get demoRelationGrandpa => 'Dede';

  @override
  String get demoRelationGrandma => 'Büyükanne';

  @override
  String get demoRelationDaughter => 'Kız';

  @override
  String get demoRelationWife => 'Eş';

  @override
  String get demoRelationBestMan => 'Sağdıç';

  @override
  String get demoRelationMother => 'Anne';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Kaydedildi: $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı henüz yedeklenmedi.',
      one: '1 anı henüz yedeklenmedi.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Sonra';

  @override
  String get backUp => 'Yedekle';

  @override
  String get onThisDayTitle => 'Bugün geçmişte';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years yıl önce bugün',
      one: '1 yıl önce bugün',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years yıl önce',
      one: '1 yıl önce',
    );
    return 'Bugün geçmişte · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'Önceki yıllardan bir anının geri geldiği günlerde LifeThreads sessiz bir hatırlatma gönderir.';

  @override
  String get onThisDayReminderSwitch => 'Günlük hatırlatma';

  @override
  String onThisDayReminderAt(String time) {
    return 'Saat $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'LifeThreads bildirimleri kapalı. Telefonunun ayarlarından izin ver.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years yıl önce bugün: $title',
      one: '1 yıl önce bugün: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı daha',
      one: '1 anı daha',
    );
    return '$title ve bu günden $_temp0';
  }

  @override
  String get onThisDayChannelDescription =>
      'Önceki bir yılda bugünden bir anı.';

  @override
  String get benefitOnThisDayBody =>
      'Önceki bir yıldan bir anı geri geldiğinde, kendi bölümü olarak açılan bir hatırlatma.';

  @override
  String get premiumFeatureStoryImage => 'Hikaye görselleri';

  @override
  String get premiumFeatureStoryVideo => 'Hikaye videoları';

  @override
  String get premiumFeatureThreadOfTheYear => 'Yılın İpliği';

  @override
  String get premiumFeatureFamilyWall => 'Aile duvarı';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature Premium\'a dahildir.';
  }

  @override
  String get yearThreadTitle => 'Yılın İpliği';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı',
      one: '1 anı',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yer',
      one: '1 yer',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kişi',
      one: '1 kişi',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ay',
      one: '1 ay',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'En çok hissedilen: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'Bir yıl, ipe dizildi.';

  @override
  String get yearThreadMyYear => 'Benim yılım';

  @override
  String get yearThreadWallCardTitle => 'Anılarla yılın';

  @override
  String yearThreadWallCardBody(String year) {
    return '$year yılını kısa bir filme dönüştür.';
  }

  @override
  String get yearThreadDismiss => 'Şimdi değil';

  @override
  String get yearThreadSettingsBody =>
      'En az 3 anısı olan her yılı, sırayla anlatılan ve iple birleşen kısa bir filme dönüştür.';

  @override
  String get yearThreadOpen => 'Filmi yap';

  @override
  String get yearThreadNoYears =>
      'Yılın İpliği için en az 3 anısı olan bir yıl gerekiyor. Anları kaydetmeye devam et ve geri gel.';

  @override
  String get yearThreadYear => 'Yıl';

  @override
  String get yearThreadLength => 'Süre';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'Film · $seconds sn';
  }

  @override
  String get yearThreadLengthStory => 'Hikaye · 20 sn';

  @override
  String get yearThreadMusic => 'Müzik';

  @override
  String get yearThreadNoMusic => 'Müzik yok';

  @override
  String get yearThreadInFilm => 'Filmde';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count / $max';
  }

  @override
  String get yearThreadAddMemory => 'Anı ekle';

  @override
  String get yearThreadSwap => 'Değiştir';

  @override
  String get yearThreadRemove => 'Kaldır';

  @override
  String get yearThreadUseSuggestions => 'Önerileri kullan';

  @override
  String yearThreadPickTitle(String year) {
    return '$year yılından bir anı seç';
  }

  @override
  String get yearThreadNoOthers => 'Bu yılın tüm anıları zaten filmde.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı',
      one: '1 anı',
    );
    return 'En az $_temp0 seç.';
  }

  @override
  String get yearThreadPreview => 'Önizleme';

  @override
  String get yearThreadExportVideo => 'Videoyu dışa aktar';

  @override
  String get yearThreadExportImage => 'Görseli dışa aktar';

  @override
  String get yearThreadShare => 'Paylaş';

  @override
  String get yearThreadSave => 'Fotoğraflar\'a kaydet';

  @override
  String get yearThreadMakingFilm => 'Filmin hazırlanıyor…';

  @override
  String get yearThreadMakingImage => 'Görselin hazırlanıyor…';

  @override
  String get yearThreadFilmReady => 'Filmin hazır';

  @override
  String get yearThreadImageReady => 'Görselin hazır';

  @override
  String get yearThreadSaved => 'Fotoğraflarına kaydedildi.';

  @override
  String get yearThreadExportFailed => 'Olmadı. Lütfen tekrar dene.';

  @override
  String get yearThreadPlay => 'Oynat';

  @override
  String get yearThreadPause => 'Duraklat';

  @override
  String get createStory => 'Hikaye oluştur';

  @override
  String get storyPickTitle => 'Anıları seç';

  @override
  String storyPickBody(int max) {
    return 'Bir hikaye için en fazla $max anı seç.';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$count / $max seçildi';
  }

  @override
  String storyPickLimit(int max) {
    return 'Bir hikayede en fazla $max anı olabilir.';
  }

  @override
  String get storyPickContinue => 'Devam';

  @override
  String get storyNoMemories =>
      'Önce bir anı kaydet, sonra onu hikayeye dönüştür.';

  @override
  String get storyEditorTitle => 'Hikayen';

  @override
  String get storyChangeMemories => 'Anıları değiştir';

  @override
  String get storyTemplateSingle => 'Tek anı';

  @override
  String get storyTemplateThread => 'İpli duvar';

  @override
  String get storyTemplateCollage => 'Kolaj';

  @override
  String get storyTemplateQuote => 'Sözler';

  @override
  String get storySwipeHint => 'Başka bir görünüm için kaydır';

  @override
  String get storyCaptionLabel => 'Açıklama';

  @override
  String get storyCaptionHint => 'Hikâyenden bir satır';

  @override
  String get storyVideoSwitch => 'Video';

  @override
  String get storyVideoBody =>
      'Hikayeler ve Reels için hareketli ve müzikli kısa bir film.';

  @override
  String get storyMusicTitle => 'Müzik';

  @override
  String get storyMusicNone => 'Müzik yok';

  @override
  String get storyMusicNoneHint =>
      'Paylaşırken Instagram\'da da müzik ekleyebilirsin.';

  @override
  String get storyMoodWarm => 'Sıcak';

  @override
  String get storyMoodJoyful => 'Neşeli';

  @override
  String get storyMoodCalm => 'Sakin';

  @override
  String get storyMoodNostalgic => 'Nostaljik';

  @override
  String get storyMoodEpic => 'Destansı';

  @override
  String get storyMoodEmotional => 'Duygusal';

  @override
  String get storyMusicTrimHint =>
      'Şarkının bölümünü seçmek için altın kutuyu sürükle';

  @override
  String get storySearchHint => 'Anı, yer, yıl ara';

  @override
  String storySearchEmpty(String query) {
    return '“$query” ile eşleşen anı yok.';
  }

  @override
  String get storyMemoriesInStory => 'Hikayende';

  @override
  String get storyMemoriesReorderHint =>
      'Sırayı değiştirmek için basılı tut ve sürükle';

  @override
  String get storyAddMemory => 'Ekle';

  @override
  String get storyAddMemoryTitle => 'Anı ekle';

  @override
  String storyRemoveMemory(String title) {
    return 'Hikayeden kaldır: $title';
  }

  @override
  String get storyAllMemoriesAdded => 'Tüm anılar zaten bu hikayede.';

  @override
  String get storyShare => 'Paylaş';

  @override
  String get storySaveToPhotos => 'Fotoğraflar\'a kaydet';

  @override
  String get storySaved => 'Fotoğraflarına kaydedildi.';

  @override
  String get storySaveDenied =>
      'LifeThreads fotoğraflarına ekleme yapamıyor. Telefonunun ayarlarından izin ver.';

  @override
  String storyExportFailed(String error) {
    return 'Hikaye oluşturulamadı: $error';
  }

  @override
  String get storyRenderingTitle => 'Filmin hazırlanıyor';

  @override
  String get storyRenderingBody =>
      'LifeThreads\'i açık tut, birkaç saniye sürer.';

  @override
  String storyRenderingPercent(int percent) {
    return '%$percent';
  }

  @override
  String get storyPreviewFree =>
      'Önizleme ücretsiz. Hikayeleri paylaşmak ve kaydetmek Premium\'a dahildir.';

  @override
  String get benefitStoriesTitle => 'Hikaye oluştur';

  @override
  String get benefitStoriesBody =>
      'Anılarını Instagram, WhatsApp ve dahası için hikaye görsellerine ve müzikli kısa filmlere dönüştür.';

  @override
  String get musicCreditsTitle => 'Müzik künyesi';

  @override
  String get musicCreditsBody =>
      'Hikaye videoları için eklenen şarkılar ve lisansları.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'Yılın kısa bir film olarak: önemli anlar, sırayla, müzikle.';

  @override
  String get benefitFamilyTitle => 'Aile duvarları';

  @override
  String get benefitFamilyBody =>
      'Ailen için uçtan uca şifreli, ortak bir duvar. Herkes kendi anlarını ekler.';

  @override
  String get myWall => 'Duvarım';

  @override
  String get myWallSubtitle => 'Özel, bu cihazda';

  @override
  String get switchWall => 'Duvar değiştir';

  @override
  String get familyWallsTitle => 'Aile duvarları';

  @override
  String get familyWallsSettingsBody =>
      'Bir duvarı ailen ya da arkadaşlarınla paylaş: herkes anı ekler, uçtan uca şifreli. Duvarım bu cihazda özel kalır.';

  @override
  String get familyWallsOpen => 'Aile duvarlarını aç';

  @override
  String get familyWallsManage => 'Aile duvarlarını yönet';

  @override
  String get familyWallsHeadline => 'Tek duvar, tüm aile';

  @override
  String get familyWallsIntro =>
      'Aile duvarı, davet ettiğin kişilerle paylaşılır. Anılar ve fotoğraflar yüklenmeden önce telefonunda şifrelenir; yalnızca üyeler açabilir. Duvarım paylaşılmaz ve bu cihazda kalır.';

  @override
  String get familyUnavailableTitle => 'Henüz kullanılamıyor';

  @override
  String get familyUnavailable =>
      'Aile duvarları LifeThreads\'in bu sürümünde henüz yok.';

  @override
  String get familySignInNeededTitle => 'Aile duvarları için giriş yap';

  @override
  String get familySignInNeededBody =>
      'Ortak bir duvar için hesap gerekir, böylece aile kimin ne eklediğini bilir. Duvarım hesapsız çalışır.';

  @override
  String get familySignIn => 'Giriş yap';

  @override
  String get familyLoadFailed => 'Yüklenemedi';

  @override
  String get familyRetry => 'Tekrar dene';

  @override
  String get familyNoWallsYet =>
      'Henüz aile duvarı yok. Bir tane oluştur ya da davet bağlantısıyla katıl.';

  @override
  String get familyStartTitle => 'Oluştur veya katıl';

  @override
  String get familyStartBody =>
      'Aile duvarı oluşturmak için Premium gerekir. Katılmak ücretsiz: sahibin Premium\'u tüm aileyi kapsar.';

  @override
  String get familyCreateAction => 'Aile duvarı oluştur';

  @override
  String get familyCreateTitle => 'Yeni aile duvarı';

  @override
  String get familyNameLabel => 'Duvarın adı';

  @override
  String get familyNameHint => 'örn. Yılmaz Ailesi';

  @override
  String get familyMyNameLabel => 'Bu duvardaki adın';

  @override
  String get familyMyNameHelper =>
      'Üyeler onu anılarında görür. Duvardaki her şey gibi şifrelidir.';

  @override
  String get familyMyNameSaved => 'Ad kaydedildi.';

  @override
  String get familySetMyName => 'Adım';

  @override
  String get familyCheckingSubscription => 'Premium\'un kontrol ediliyor…';

  @override
  String get familyCreating => 'Duvar oluşturuluyor…';

  @override
  String get familyJoinWithLink => 'Bağlantıyla katıl';

  @override
  String get familyInviteLinkLabel => 'Davet bağlantısı';

  @override
  String get familyJoinTitle => 'Bu aile duvarına katılmak ister misin?';

  @override
  String get familyJoinBody =>
      'Üyeler adını ve eklediğin anıları görür, sen de onlarınkini. İstediğin zaman ayrılabilirsin.';

  @override
  String get familyJoinAction => 'Katıl';

  @override
  String get familyJoining => 'Katılınıyor…';

  @override
  String familyJoined(String family) {
    return 'Katıldın: $family.';
  }

  @override
  String get familyRoleOwner => 'Sahip';

  @override
  String get familyRoleMember => 'Üye';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count üye',
      one: '1 üye',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'Duvar ayarları';

  @override
  String familyStorageUsed(String used, String total) {
    return '$used / $total kullanıldı';
  }

  @override
  String get familyRename => 'Yeniden adlandır';

  @override
  String get familyInviteTitle => 'Davet et';

  @override
  String get familyInviteBody =>
      'Güvendiğin birine bağlantı gönder. Her bağlantı bir kez çalışır ve 7 gün sonra sona erer.';

  @override
  String get familyInviteAction => 'Davet bağlantısı oluştur';

  @override
  String get familyCreatingInvite => 'Davet oluşturuluyor…';

  @override
  String get familyInviteReady => 'Davet bağlantısı hazır';

  @override
  String get familyInviteValidity =>
      'Bir kez çalışır ve en geç 7 gün sonra sona erer.';

  @override
  String get familyInviteKeyWarning =>
      'Bağlantı duvarın anahtarını taşır: açan herkes katılıp duvarı okuyabilir. Yalnızca davet ettiğin kişiye gönder.';

  @override
  String get familyInviteShare => 'Bağlantıyı paylaş';

  @override
  String get familyInviteCopy => 'Bağlantıyı kopyala';

  @override
  String get familyInviteCopied => 'Bağlantı kopyalandı.';

  @override
  String get familyInviteShareFailed =>
      'Paylaşım kullanılamıyor. Bunun yerine bağlantıyı kopyala.';

  @override
  String familyInviteSubject(String family) {
    return 'LifeThreads\'te $family duvarına katıl';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'LifeThreads\'teki “$family” aile duvarımıza katıl: $link';
  }

  @override
  String get familyMembersTitle => 'Üyeler';

  @override
  String get familyMemberActions => 'Üye işlemleri';

  @override
  String get familyYou => 'Sen';

  @override
  String familyYouNamed(String name) {
    return '$name (sen)';
  }

  @override
  String get familyAMember => 'Bir üye';

  @override
  String get familyFormerMember => 'Eski üye';

  @override
  String get familyBlocked => 'Engellendi';

  @override
  String get familyBlock => 'Engelle';

  @override
  String get familyUnblock => 'Engeli kaldır';

  @override
  String familyBlockAuthor(String name) {
    return 'Engelle: $name';
  }

  @override
  String familyBlockQuestion(String name) {
    return '$name engellensin mi?';
  }

  @override
  String get familyBlockBody =>
      'Bu kişinin anılarını artık hiçbir aile duvarında görmezsin. Kendisine haber verilmez. Engeli üye listesinden kaldırabilirsin.';

  @override
  String get familyReport => 'Bildir';

  @override
  String get familyRemoveMember => 'Duvardan çıkar';

  @override
  String familyRemoveQuestion(String name) {
    return '$name çıkarılsın mı?';
  }

  @override
  String get familyRemoveBody =>
      'Bu duvara erişimini kaybeder. Geri getirmek için yeniden davet et.';

  @override
  String get familyRemoveDeleteContent => 'Eklediği anıları da sil';

  @override
  String get familyDeleteTitle => 'Aile duvarını sil';

  @override
  String get familyDeleteBody =>
      'Sahip olarak duvardan ayrılamazsın; herkes için silebilirsin.';

  @override
  String get familyDeleteAction => 'Duvarı sil';

  @override
  String familyDeleteQuestion(String family) {
    return '$family silinsin mi?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'Bu duvardaki tüm anılar ve fotoğraflar tüm üyeler için sunucularımızdan silinir. Geri alınamaz. Duvarım\'daki anılar etkilenmez.';

  @override
  String get familyDeleting => 'Siliniyor…';

  @override
  String get familyLeaveTitle => 'Aile duvarından ayrıl';

  @override
  String get familyLeaveBody =>
      'Bu duvarı artık görmezsin. Eklediğin anıları tutabilir ya da silebilirsin.';

  @override
  String get familyLeaveAction => 'Ayrıl';

  @override
  String familyLeaveQuestion(String family) {
    return '$family duvarından ayrılınsın mı?';
  }

  @override
  String get familyLeaveConfirmBody =>
      'Geri dönmek için yeni bir davet gerekir.';

  @override
  String get familyLeaveDeleteMine => 'Eklediğim anıları da sil';

  @override
  String get familyLeaving => 'Ayrılınıyor…';

  @override
  String get familySignInTitle => 'Giriş yap';

  @override
  String get familySignInHeadline => 'Aile duvarları için bir hesap';

  @override
  String get familySignInWhy =>
      'Aile duvarı ortaktır, bu yüzden hesap gerekir: üyeler her anıyı kimin eklediğini görür ve duvarı yalnızca üyeler açabilir.';

  @override
  String get familySignInMyWallStays =>
      'Duvarım hesap gerektirmez. Bu cihazda özel kalır ve asla yüklenmez.';

  @override
  String get familySignInEncrypted =>
      'Aile anıları ve fotoğrafları uçtan uca şifrelidir. GK Coding onları saklar ama okuyamaz.';

  @override
  String get familySignInWhatWeGet =>
      'Apple veya Google\'dan yalnızca bir hesap kimliği kullanırız; kişilerini veya fotoğraflarını değil.';

  @override
  String get familySignInApple => 'Apple ile giriş yap';

  @override
  String get familySignInGoogle => 'Google ile giriş yap';

  @override
  String get familySignInFinePrint =>
      'Giriş yaparak Kullanım Koşulları\'nı ve Gizlilik Politikası\'nı kabul edersin. Hesabını uygulamada istediğin zaman silebilirsin.';

  @override
  String get familyAccountTitle => 'Hesap';

  @override
  String get familySignedOutTitle => 'Giriş yapılmadı';

  @override
  String get familySignedOutBody =>
      'Aile duvarlarını görmek için giriş yap. Duvarım hesapsız çalışır.';

  @override
  String get familySignedInTitle => 'Giriş yapıldı';

  @override
  String get familySignedInBody =>
      'Hesabın yalnızca aile duvarları için kullanılır.';

  @override
  String familyAccountId(String id) {
    return 'Hesap kimliği: $id';
  }

  @override
  String get familySignOut => 'Çıkış yap';

  @override
  String get familySignOutQuestion => 'Çıkış yapılsın mı?';

  @override
  String get familySignOutBody =>
      'Aile duvarları ve anahtarları, yeniden giriş yapana kadar bu cihazdan kaldırılır. Sunucuda hiçbir şey silinmez. Duvarım etkilenmez.';

  @override
  String get familySigningOut => 'Çıkış yapılıyor…';

  @override
  String get familyDeleteAccountTitle => 'Hesabı sil';

  @override
  String get familyDeleteAccountBody =>
      'Hesabını ve aile duvarı verilerini sunucularımızdan siler. Duvarım bu cihazda kalır.';

  @override
  String get familyDeleteAccount => 'Hesabı sil';

  @override
  String get familyDeleteAccountQuestion => 'Hesabın silinsin mi?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Sahibi olduğun $count aile duvarı, tüm anı ve fotoğraflarıyla birlikte tüm üyeler için silinir.',
      one:
          'Sahibi olduğun aile duvarı, tüm anı ve fotoğraflarıyla birlikte tüm üyeler için silinir.',
      zero: 'Sahibi olduğun aile duvarı yok.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'Diğer ailelerin duvarlarına eklediğin anılar ve fotoğraflar silinir ve o duvarlardan ayrılırsın.';

  @override
  String get familyDeleteAccountKeys =>
      'Aile duvarı anahtarları ve önbellekteki fotoğraflar bu cihazdan kaldırılır. Geri alınamaz.';

  @override
  String get familyDeleteAccountMyWall =>
      'Duvarım etkilenmez: anıları bu cihazda kalır.';

  @override
  String get familyDeleteAccountSubscription =>
      'Bu işlem Premium aboneliğini iptal etmez; onu App Store\'dan veya Google Play\'den yönet.';

  @override
  String get familyDeleteAccountUnderstood =>
      'Bunun hesabımı kalıcı olarak sileceğini anlıyorum.';

  @override
  String get familyDeletingAccount => 'Hesabın siliniyor…';

  @override
  String get familyAccountDeleted => 'Hesabın silindi.';

  @override
  String get familyTermsTitle => 'Aile duvarı kuralları';

  @override
  String get familyTermsHeadline => 'Paylaşmadan önce';

  @override
  String get familyTermsIntro =>
      'Aile duvarları davet ettiğin kişiler içindir. Güvenli kalmaları için herkes şu kuralları kabul eder:';

  @override
  String get familyTermsZeroTolerance =>
      'Uygunsuz içeriğe sıfır tolerans: taciz, nefret, cinsel içerik, şiddet, kendine zarar verme, yasa dışı içerik ya da başkalarının özel bilgilerini izinsiz paylaşmak yok.';

  @override
  String get familyTermsOwnContent =>
      'Yalnızca paylaşma hakkın olan fotoğrafları ve hikâyeleri paylaş.';

  @override
  String get familyTermsReport =>
      'Herhangi bir anıyı veya üyeyi duvardan bildir. GK Coding bildirimleri 24 saat içinde inceler.';

  @override
  String get familyTermsBlock => 'Anılarını görmemek için bir üyeyi engelle.';

  @override
  String get familyTermsOwner =>
      'Duvarın sahibi üyeleri ve anılarını kaldırabilir.';

  @override
  String get familyTermsConsequences =>
      'Bu kuralları çiğneyen içerik kaldırılır; paylaşan hesaplar askıya alınabilir veya silinebilir.';

  @override
  String get familyTermsReadFull => 'Koşulların tamamını oku';

  @override
  String get familyTermsAgree =>
      'Kullanım Koşulları\'nı ve bu kuralları kabul ediyorum.';

  @override
  String get familyTermsAccept => 'Kabul et ve devam et';

  @override
  String familyTermsVersion(String version) {
    return 'Koşullar sürümü $version';
  }

  @override
  String get familyWallEmptyTitle => 'Duvar seni bekliyor';

  @override
  String get familyWallEmptyBody =>
      'İlk anıyı ekle. Bu duvardaki herkes onu görecek.';

  @override
  String get familyWallGoneBody =>
      'Bu aile duvarı artık sana açık değil. Silinmiş ya da çıkarılmış olabilirsin.';

  @override
  String get familyAddMemory => 'Anı ekle';

  @override
  String get familyRefresh => 'Yenile';

  @override
  String get familySyncing => 'Eşitleniyor…';

  @override
  String get familyOffline => 'Çevrimdışı: kayıtlı anılar gösteriliyor';

  @override
  String get familySyncFailed => 'Eşitleme başarısız';

  @override
  String get familyMemoryTitle => 'Anı';

  @override
  String get familyMemoryGone => 'Bu anı artık duvarda değil.';

  @override
  String get familyMemoryActions => 'Anı işlemleri';

  @override
  String familyAddedBy(String name) {
    return 'Ekleyen: $name';
  }

  @override
  String get familyDeleteMemoryQuestion => 'Bu anı silinsin mi?';

  @override
  String get familyDeleteMemoryBody =>
      'Fotoğraflarıyla birlikte herkes için duvardan kaldırılır.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'Sahip olarak bu duvardan anı kaldırabilirsin. $name tarafından eklenen bu anı, fotoğraflarıyla birlikte herkes için kaldırılır.';
  }

  @override
  String get familyDeletingMemory => 'Anı siliniyor…';

  @override
  String get familyNoPhotosYet => 'Henüz fotoğraf yok';

  @override
  String get familyPostNote =>
      'Bu duvardaki herkes bu anıyı görecek. Fotoğraflar yüklenmeden önce telefonunda küçültülür ve şifrelenir.';

  @override
  String get familyPost => 'Paylaş';

  @override
  String get familyPostMemory => 'Duvarda paylaş';

  @override
  String get familyUploading => 'Şifreleniyor ve yükleniyor…';

  @override
  String get familyMemorySaved => 'Aile duvarına kaydedildi.';

  @override
  String get familyConflictTitle => 'Başka biri değiştirdi';

  @override
  String get familyConflictBody =>
      'Sen düzenlerken bu anı başka bir cihazda değişti. En son sürüm yüklenip değişikliklerin onun üzerine kaydedilsin mi?';

  @override
  String get familyConflictRetry => 'Yenile ve kaydet';

  @override
  String get familyQuotaTitle => 'Duvar dolu';

  @override
  String get familyReportMemoryTitle => 'Anıyı bildir';

  @override
  String get familyReportPhotoTitle => 'Fotoğrafı bildir';

  @override
  String get familyReportMemberTitle => 'Üyeyi bildir';

  @override
  String get familyReportIntro =>
      'Neyin yanlış olduğunu anlat. Bildirimin bildirdiğin kişiye değil, GK Coding\'e gider.';

  @override
  String get familyReportSpam => 'Spam veya dolandırıcılık';

  @override
  String get familyReportHarassment => 'Taciz veya zorbalık';

  @override
  String get familyReportHate => 'Nefret söylemi';

  @override
  String get familyReportSexual => 'Cinsel içerik veya çıplaklık';

  @override
  String get familyReportViolence => 'Şiddet veya tehdit';

  @override
  String get familyReportSelfHarm => 'Kendine zarar verme veya intihar';

  @override
  String get familyReportIllegal => 'Yasa dışı içerik';

  @override
  String get familyReportPrivacy => 'İzinsiz paylaşılan özel bilgiler';

  @override
  String get familyReportOther => 'Başka bir şey';

  @override
  String get familyReportDetailsLabel => 'Ayrıntılar (isteğe bağlı)';

  @override
  String get familyReportDetailsHint => 'Bilmemiz gereken ne?';

  @override
  String familyReportAlsoBlock(String name) {
    return '$name kişisini de engelle';
  }

  @override
  String get familyReportSend => 'Bildirimi gönder';

  @override
  String get familyReportReviewNote =>
      'GK Coding her bildirimi 24 saat içinde inceler ve kuralları çiğneyen içerik ve üyeleri kaldırır.';

  @override
  String get familyReportSentTitle => 'Teşekkürler';

  @override
  String get familyReportSentBody =>
      'Bildirimin gönderildi. GK Coding onu 24 saat içinde inceler ve kuralları çiğneyen içerikle ilgili işlem yapar.';

  @override
  String get familyErrorGeneric => 'Bir şeyler ters gitti. Lütfen tekrar dene.';

  @override
  String get familyErrorOffline =>
      'Çevrimdışı görünüyorsun. Bağlantını kontrol edip tekrar dene.';

  @override
  String get familyErrorSubscriptionRequired =>
      'Bunun için duvar sahibinin etkin bir Premium aboneliği gerekir.';

  @override
  String get familyErrorInviteExpired =>
      'Bu davetin süresi doldu. Yeni bir bağlantı iste.';

  @override
  String get familyErrorInviteUsed =>
      'Bu davet zaten kullanıldı. Her bağlantı bir kez çalışır; yenisini iste.';

  @override
  String get familyErrorInviteInvalid =>
      'Bu geçerli bir LifeThreads davet bağlantısı değil.';

  @override
  String get familyErrorAlreadyMember => 'Bu aile duvarının zaten üyesisin.';

  @override
  String get familyErrorFamilyFull => 'Bu aile duvarı üye sınırına ulaştı.';

  @override
  String get familyErrorQuotaExceeded =>
      'Bu aile duvarında yer kalmadı. Yer açmak için bazı anıları veya fotoğrafları sil.';

  @override
  String get familyErrorVersionConflict =>
      'Bu anıyı senden önce biri değiştirdi. Yenile ve tekrar dene.';

  @override
  String get familyErrorTermsRequired =>
      'Lütfen önce aile duvarı kurallarını kabul et.';

  @override
  String get familyErrorSignedOut =>
      'Oturumun kapandı. Lütfen yeniden giriş yap.';

  @override
  String get familyErrorNotAllowed => 'Bu duvarda bunu yapma iznin yok.';

  @override
  String get familyErrorNotFound => 'Aile duvarı bulunamadı';

  @override
  String get familyErrorOwnerCannotLeave =>
      'Sahip duvardan ayrılamaz ama duvarı silebilir.';

  @override
  String get familyPaste => 'Yapıştır';

  @override
  String get familyErrorInviteRevoked =>
      'Bu davet geri çekildi. Yeni bir bağlantı iste.';

  @override
  String get familyErrorKeyMissing =>
      'Bu cihazda bu aile duvarının anahtarı yok (örneğin yeniden yüklemeden sonra ya da yeni bir telefonda). Bir üyeden yeni bir davet bağlantısı iste: açınca erişim geri gelir.';

  @override
  String get familyErrorSignInUnavailable =>
      'Bu cihazda şu anda giriş yapılamıyor.';

  @override
  String get familyErrorNoPurchase =>
      'Bu App Store veya Google Play hesabında Premium satın alımı bulunamadı. Önce Premium al, sonra tekrar dene.';

  @override
  String get familyErrorVerificationUnavailable =>
      'Premium\'un şu anda kontrol edilemedi. Lütfen daha sonra tekrar dene.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'Bu Premium satın alımı zaten başka bir aile duvarı hesabına bağlı. O hesapla giriş yap ya da info@gkcoding.dev adresine yaz.';

  @override
  String get familyErrorNameTooLong =>
      'Bu ad çok uzun. Lütfen daha kısa bir ad kullan.';

  @override
  String get familyErrorContentNotAllowed =>
      'Metinde aile duvarlarında izin verilmeyen kelimeler var. Metni değiştirip tekrar dene.';

  @override
  String get familyErrorPhotoUnreadable =>
      'Fotoğraflardan biri okunamadı. Onu kaldırıp tekrar dene.';

  @override
  String get familyErrorTooLarge =>
      'Yüklemek için çok büyük. Daha az ya da daha küçük fotoğraf dene.';

  @override
  String get familyReportEvidenceNote =>
      'İnceleme için GK Coding, bildiriminle birlikte bu anının başlığını ve hikâyesini alır. Fotoğrafları asla gönderilmez.';

  @override
  String get moveLeft => 'Sola taşı';

  @override
  String get moveUp => 'Yukarı taşı';

  @override
  String get moveDown => 'Aşağı taşı';

  @override
  String get moveRight => 'Sağa taşı';

  @override
  String get showPassword => 'Parolayı göster';

  @override
  String get hidePassword => 'Parolayı gizle';

  @override
  String get removePerson => 'Kişiyi kaldır';

  @override
  String get draftKept =>
      'Taslak olarak saklandı – bir dahaki sefere burada olacak.';

  @override
  String get draftResumeTitle => 'Kaldığın yerden devam etmek ister misin?';

  @override
  String draftResumeBody(String date) {
    return '$date tarihinde bir anıya başladın ve henüz kaydetmedin.';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotoğraf',
      one: '1 fotoğraf',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => 'Taslağa devam et';

  @override
  String get draftStartNew => 'Yeniden başla';

  @override
  String get lookBackMenu => 'Bir aya dönüp bak';

  @override
  String lookBackTitle(String month) {
    return '$month ayın';
  }

  @override
  String get lookBackWallCardTitle => 'Anılarla ayın';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı',
      one: '1 anı',
    );
    return '$month: $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı',
      one: '1 anı',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kişi',
      one: '1 kişi',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yer',
      one: '1 yer',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => 'Kimler vardı';

  @override
  String get lookBackPlacesHeading => 'Neredeydin';

  @override
  String lookBackEmpty(String month) {
    return '$month ayından henüz kayıt yok.';
  }

  @override
  String get lookBackEmptyHint => 'Bu ayın tarihli anıları burada görünür.';

  @override
  String get lookBackPreviousMonth => 'Önceki ay';

  @override
  String get lookBackNextMonth => 'Sonraki ay';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anı',
      one: '1 anı',
    );
    return '$month: dönüp bakılacak $_temp0.';
  }

  @override
  String get lookBackNotificationPrivate => 'Anılarla ayın hazır.';

  @override
  String get homeWidgetLocked => 'Anılarını görmek için LifeThreads\'i aç.';

  @override
  String get homeWidgetSettingsTitle => 'Ana ekran widget\'ı';

  @override
  String get homeWidgetSettingsSubtitle => 'Hangi anıları gösterdiği';

  @override
  String get homeWidgetPreviewTitle => 'Bugün widget\'ında';

  @override
  String get homeWidgetSourceTitle => 'Hangi anılar';

  @override
  String get homeWidgetAllWalls => 'Tüm duvarlarım';

  @override
  String get homeWidgetOrderTitle => 'Önce gösterilen';

  @override
  String get homeWidgetOnThisDayFirst => 'Önce bugün geçmişte';

  @override
  String get homeWidgetOnThisDayFirstBody =>
      'Önceki bir yılda bugünden bir anı önce gelir.';

  @override
  String get homeWidgetPhotosFirst => 'Önce fotoğraflı anılar';

  @override
  String get homeWidgetPhotosFirstBody =>
      'Diğerleri yalnızca hiçbirinde fotoğraf yoksa.';

  @override
  String get homeWidgetHowToTitle => 'Ana ekranına ekle';

  @override
  String get homeWidgetHowToIos =>
      'Ana ekranındaki LifeThreads simgesine basılı tut ve bir widget boyutu seç. Ya da boş bir yere basılı tut, Düzenle › Widget Ekle\'ye dokun ve LifeThreads\'i seç.';

  @override
  String get homeWidgetHowToAndroid =>
      'Ana ekranında boş bir yere basılı tut, Widget\'lar\'a dokun ve LifeThreads\'i istediğin yere sürükle.';

  @override
  String get homeWidgetPrivacyNote =>
      'Gizli anılar widget\'ta asla görünmez. Uygulama kilidi açıkken hiçbir anı göstermez.';

  @override
  String get yearThreadAlmostThere => 'Az kaldı';

  @override
  String get yearThreadMemoriesFrom => 'Şu yıldan anılar';

  @override
  String yearThreadAddMemoryTo(String year) {
    return '$year yılına bir anı ekle';
  }

  @override
  String get onboardingHangTitle => 'Anılarını as';

  @override
  String get onboardingHangText =>
      'Bir fotoğraf, bir yer, orada olan insanlar – duvarın hayatınla birlikte büyür.';

  @override
  String get onboardingConnectTitle => 'Onları iplerle bağla';

  @override
  String get onboardingConnectText =>
      'İki anın neden birlikte olduğunu söyle. İpler hikâyenin nasıl birleştiğini gösterir.';

  @override
  String get onboardingComeBackTitle => 'Anılar sana geri döner';

  @override
  String get onboardingComeBackText =>
      'Bugün geçmişte, dönüp baktığın ayın, film olarak yılın – ve ana ekranında bir widget.';

  @override
  String get onboardingPrivateText =>
      'Hesap yok. Her şey telefonunda kalır – istersen Face ID ile.';

  @override
  String get onboardingNameStaysHere =>
      'Sadece seni selamlamak için – bu telefonda kalır.';

  @override
  String get tutorialLookBackTitle => 'Bul ve dönüp bak';

  @override
  String get tutorialLookBackText =>
      'Başlığa, yere, kişiye veya yıla göre ara. Daha fazla › Bir aya dönüp bak bir ayın anılarını gösterir; Daha fazla › Yılın İpliği bir yılı filme dönüştürür.';

  @override
  String get tutorialStoryTitle => 'Hikaye oluştur';

  @override
  String get tutorialStoryText =>
      'Daha fazla › Hikaye oluştur: anıları, bir şablonu ve müziği seç, sonra görsel ya da video olarak paylaş.';

  @override
  String get tutorialWallsTitle => 'Duvarlar ve gizli anılar';

  @override
  String get tutorialWallsText =>
      'Daha fazla › Yeni duvar gezileri veya dönemleri ayrı tutar (Premium). Bir karta basılı tut › Gizle onu gözden kaldırır; Görünüm › Gizli anılar onu Face ID\'den sonra gösterir.';

  @override
  String get tutorialFamilyTitle => 'Ailenle paylaş';

  @override
  String get tutorialFamilyText =>
      'Daha fazla › Aile duvarları: tüm aile için uçtan uca şifreli tek bir duvar. Başkalarını bir bağlantıyla davet et.';

  @override
  String get tutorialWidgetTitle => 'Ana ekranında bir anı';

  @override
  String get tutorialWidgetText =>
      'LifeThreads widget\'ını ekle: her gün farklı bir anı. Hangilerinin görüneceğini Ayarlar › Ana ekran widget\'ı\'ndan seç.';

  @override
  String photoNumber(int number) {
    return 'Fotoğraf $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'Bu duvardaki adın kaydedilemedi. Duvarın ayarlarından belirleyebilirsin.';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'İçinde $count anı var.',
      one: 'İçinde 1 anı var.',
    );
    return '$_temp0 Duvarlarında zaten olan anılar korunur ve iki kez eklenmez.';
  }

  @override
  String get importAction => 'İçe aktar';

  @override
  String get familyRemovingMember => 'Çıkarılıyor ve duvar güvenceye alınıyor…';

  @override
  String get tourSkip => 'Geç';

  @override
  String get tourNext => 'İleri';

  @override
  String get tourDone => 'Bitti';

  @override
  String get tourTapIt => 'Dokun';

  @override
  String get tourEnd => 'Turu bitir';

  @override
  String get tourShowMeHow => 'Bana göster';

  @override
  String get tourShowMeHowSubtitle => 'Örnek anılarla kısa bir tur';

  @override
  String get tourWelcomeTitle => 'Duvarına hoş geldin';

  @override
  String get tourWelcomeBody =>
      'LifeThreads\'i örnek anılar ve fotoğraflarla birlikte gezelim. Altın halkayı takip et. Sonunda onları tutup tutmayacağına sen karar verirsin.';

  @override
  String get tourCardTitle => 'Her kart bir anı';

  @override
  String get tourCardBody =>
      'Fotoğraflar, bir hikâye, yer ve nasıl hissettirdiği. Kartları sürükleyerek düzenle, yakınlaştırmak için iki parmakla aç. Açmak için buna dokun.';

  @override
  String get tourConnectTitle => 'Anıları bağla';

  @override
  String get tourConnectBody =>
      'İpler anları birbirine bağlar: bir geziyi bir kişiye, bir yeri bir duyguya. Bağla\'ya dokun.';

  @override
  String get tourConnectionsTitle => 'Birbirine ait olanları seç';

  @override
  String get tourConnectionsBody =>
      'Başka anılar seç ve neden birlikte olduklarını yaz. İp sonra duvarındaki kartların arasında asılı durur.';

  @override
  String get tourAddTitle => 'Yeni bir an kaydet';

  @override
  String get tourAddBody => 'Duvarına bir şey eklemek için +\'ya dokun.';

  @override
  String get tourAddMemoryTitle => 'Bir anı';

  @override
  String get tourAddMemoryBody =>
      'Anı\'yı seç. Kartları gruplamak için bir not veya çivi de iliştirebilirsin.';

  @override
  String get tourAddTextTitle => 'Birkaç kelime yeter';

  @override
  String get tourAddTextBody =>
      'Senin için örnek bir fotoğraf ve başlık ekledik. Normalde kendi fotoğraflarını seçer ya da bir tane çekersin. Tarih ve yer fotoğraftan gelir.';

  @override
  String get tourSaveTitle => 'Duvara as';

  @override
  String get tourSaveBody =>
      'Şimdi kaydet\'e dokun. Duygular, kişiler ve ipler sonra eklenebilir.';

  @override
  String get tourCameraTitle => 'Hızlı fotoğraf';

  @override
  String get tourCameraBody =>
      'Kamera bir anı hemen kaydeder. Kelimeleri sonra eklersin.';

  @override
  String get tourViewTitle => 'Farklı görünümler';

  @override
  String get tourViewBody => 'Görünüm\'e dokun.';

  @override
  String get tourViewModesTitle => 'Duvar, zaman çizelgesi, harita';

  @override
  String get tourViewModesBody =>
      'Hayatını duvar, zaman çizelgesi ya da harita olarak gör. Burada kategoriye göre filtrele ve gizli anıları göster (Face ID ile).';

  @override
  String get tourViewDoneTitle => 'Duvara dön';

  @override
  String get tourViewDoneBody => 'Bitti\'ye dokun.';

  @override
  String get tourSearchTitle => 'Her anıyı bul';

  @override
  String get tourSearchBody =>
      'Buraya bir ad, yer, kişi veya yıl yaz. Sonuçlar sen yazarken görünür.';

  @override
  String get tourMoreTitle => 'Geri kalan her şey';

  @override
  String get tourMoreBody =>
      'Hikayeler, yılın, dönüp bakma, diğer duvarlar ve ayarlar bu menüde. Dokun.';

  @override
  String get tourStoryTitle => 'Hikaye oluştur';

  @override
  String get tourStoryBody => 'Hikaye oluştur\'a dokun.';

  @override
  String get tourYearTitle => 'Yılın İpliği';

  @override
  String get tourYearBody =>
      'Yılın müzikli kısa bir film olarak: anıların sırayla, ardından yılın yerleri, insanları ve duyguları (Premium).';

  @override
  String get tourLookBackTitle => 'Bir aya dönüp bak';

  @override
  String get tourLookBackBody =>
      'Her ay anılarla, içindeki insanlar ve yerlerle. Bugün geçmişte sana önceki yılları hatırlatır (Premium).';

  @override
  String get tourWallsTitle => 'Daha fazla duvar';

  @override
  String get tourWallsBody =>
      'Her çocuk, gezi veya proje için bir duvar (Premium). Duvar değiştirmek için üstteki ada dokun.';

  @override
  String get tourFamilyTitle => 'Aile duvarları';

  @override
  String get tourFamilyBody =>
      'Herkesin kendi anlarını eklediği, uçtan uca şifreli ortak bir duvar. Yalnızca oluşturan kişinin Premium\'a ihtiyacı var; aile ücretsiz katılır.';

  @override
  String get tourSettingsTitle => 'Ayarlar';

  @override
  String get tourSettingsBody =>
      'Her şeyi ücretsiz yedekle, uygulamayı Face ID ile kilitle, ana ekran widget\'ını ve Bugün geçmişte\'yi ayarla, dilini seç.';

  @override
  String get tourFinishTitle => 'Hepsi bu!';

  @override
  String get tourFinishBody =>
      'Artık yolunu biliyorsun. Şimdi duvarı kendine ait kıl.';

  @override
  String get tourDemoPhotoTitle => 'Gölde bir gün';

  @override
  String get tourRemoveDemoTitle => 'Kendi duvarına başlamak ister misin?';

  @override
  String get tourRemoveDemoBody =>
      'Tur, örnek anılar ve fotoğraflar kullandı. Şimdi kaldırıp kendi fotoğraflarınla başlamak ister misin?';

  @override
  String get tourRemoveDemoRemove => 'Kaldır ve başla';

  @override
  String get tourRemoveDemoKeep => 'Şimdilik kalsın';

  @override
  String get tourRemovedToast => 'Örnek anılar kaldırıldı. Duvarın hazır.';

  @override
  String get storyTemplatePolaroid => 'Polaroid';

  @override
  String get storyTemplateAlbum => 'Albüm';

  @override
  String get storyTemplateFilmstrip => 'Film şeridi';

  @override
  String get storyTemplateTimeline => 'Zaman yolculuğu';

  @override
  String get storyTemplatePostcard => 'Kartpostal';

  @override
  String get storyTemplateCinema => 'Sinema';

  @override
  String get storyTemplateSingleHint => 'Her anı tam ekran, birbiri ardına';

  @override
  String get storyTemplateThreadHint => 'Duvardaki kartlar, iple birleşmiş';

  @override
  String get storyTemplateCollageHint => 'Tüm fotoğraflar bir ızgarada';

  @override
  String get storyTemplateQuoteHint => 'Sözlerin kendiliğinden yazılır';

  @override
  String get storyTemplatePolaroidHint => 'Şipşak fotoğraflar bir yığına düşer';

  @override
  String get storyTemplateAlbumHint =>
      'Sayfalar çevrilir, her sayfada bir fotoğraf';

  @override
  String get storyTemplateFilmstripHint => 'Bir film akar ve yakınlaşır';

  @override
  String get storyTemplateTimelineHint => 'Yıllar her anıya kadar sayar';

  @override
  String get storyTemplatePostcardHint =>
      'Her kartpostal dönüp hikâyesini gösterir';

  @override
  String get storyTemplateCinemaHint =>
      'Başlık kartları, yavaş zoom ve jenerik';

  @override
  String get storyAnimationTitle => 'Animasyon';

  @override
  String get storyAnimationPageTitle => 'Bir animasyon seç';

  @override
  String get storyAnimationExamples =>
      'Örnek fotoğraflarla gösteriliyor. Hikayen senin anılarını kullanır.';

  @override
  String get storyMusicPageTitle => 'Müzik ve süre';

  @override
  String get storyLengthTitle => 'Süre';

  @override
  String get storyLengthAuto => 'Otomatik';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds sn';
  }

  @override
  String get storyMusicAll => 'Tümü';

  @override
  String get storyMusicPlay => 'Oynat';

  @override
  String get storyMusicPause => 'Duraklat';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return 'Şarkı $song ▸ Video $video';
  }

  @override
  String get storyMusicSyncHint =>
      'Beyaz çizgi, şarkının hangi saniyesinin videoyla çaldığını gösterir. İşaretler her anının başladığı yerdir.';

  @override
  String get storyMusicLengthHint =>
      'Otomatik, anı sayısına uyar. Uzun filmler daha yavaş akar.';

  @override
  String get tourBack => 'Geri';

  @override
  String get tourStoryPickTitle => 'Anıları seç';

  @override
  String get tourStoryPickBody =>
      'Senin için üç tane seçtik. En fazla altı seçebilirsin. Devam\'a dokun.';

  @override
  String get tourStoryAnimationTitle => 'Nasıl hareket edeceğini seç';

  @override
  String get tourStoryAnimationBody =>
      'Polaroid\'den Sinema\'ya animasyonlar. Animasyon\'a dokun.';

  @override
  String get tourStoryStyleTitle => 'Polaroid\'i dene';

  @override
  String get tourStoryStyleBody =>
      'Her kutu bir önizleme oynatır. Polaroid\'e dokun.';

  @override
  String get tourStoryMusicTitle => 'Müzik ekle';

  @override
  String get tourStoryMusicBody =>
      'Bir şarkı ve videonun süresini seç. Müzik\'e dokun.';

  @override
  String get tourStoryTrimTitle => 'Şarkı ve video uyumlu';

  @override
  String get tourStoryTrimBody =>
      'Şarkının bölümünü seçmek için altın kutuyu sürükle. Beyaz çizgi videoyla ilerler, böylece hangi saniyenin ne zaman çaldığını görürsün.';

  @override
  String get tourStoryMusicDoneTitle => 'Hikayene dön';

  @override
  String get tourStoryMusicDoneBody => 'Bitti\'ye dokun.';

  @override
  String get tourStoryShareTitle => 'Paylaş ya da kaydet';

  @override
  String get tourStoryShareBody =>
      'Instagram, WhatsApp ve dahası için hazır. Kaydetmek ve paylaşmak Premium\'a dahildir.';

  @override
  String get tourMoreAgainTitle => 'Menüde daha fazlası';

  @override
  String get tourMoreAgainBody => 'Menüyü bir kez daha aç. Dokun.';

  @override
  String get scannerStep1 =>
      'Bir TV, bilgisayar veya tablette web tarayıcısını aç.';

  @override
  String scannerStep2(Object url) {
    return '$url adresine git. Orada bir QR kod görünür.';
  }

  @override
  String get scannerStep3 =>
      'Telefonu kod altın çerçevenin içinde kalacak şekilde tut. Duvarın orada bir süre, yalnızca izlemek için görünür.';

  @override
  String get scannerShareLink => 'Bağlantı gönder';

  @override
  String get scannerCopyLink => 'Bağlantıyı kopyala';

  @override
  String get scannerLinkCopied => 'Bağlantı kopyalandı';

  @override
  String get storyTemplateScrapbook => 'Karalama defteri';

  @override
  String get storyTemplateMosaic => 'Mozaik';

  @override
  String get storyTemplateContactSheet => 'Kontakt baskı';

  @override
  String get storyTemplateWallFlight => 'Duvar uçuşu';

  @override
  String get storyTemplateCarousel => 'Atlıkarınca';

  @override
  String get storyTemplateJourney => 'Yolculuk';

  @override
  String get storyTemplateScrapbookHint =>
      'Her fotoğraf bir sayfaya bantlanmış';

  @override
  String get storyTemplateMosaicHint =>
      'Bir büyük fotoğraf, diğerleri çevresinde';

  @override
  String get storyTemplateContactSheetHint => 'Her anı filmde bir kare';

  @override
  String get storyTemplateWallFlightHint => 'İp boyunca karttan karta uçar';

  @override
  String get storyTemplateCarouselHint =>
      'Kartlar döner, her seferinde biri öne gelir';

  @override
  String get storyTemplateJourneyHint =>
      'Haritada bir rota, her yerde bir iğne';

  @override
  String get storyModePicture => 'Görsel';

  @override
  String get storyModeVideo => 'Video';

  @override
  String get storyModePictureHint =>
      'Tüm anılarınla tek bir görsel, gönderiler ve hikayeler için.';

  @override
  String get storyModeVideoHint => 'Hareketli ve müzikli kısa bir film.';

  @override
  String get storyLayoutTitle => 'Düzen';

  @override
  String get storyLayoutPageTitle => 'Bir düzen seç';

  @override
  String get storyChoosePhoto => 'Hikâye için fotoğrafı seç';

  @override
  String get wallTidyUp => 'Duvarı düzenle';

  @override
  String get wallTidyUpBody =>
      'Tüm kartlar en eski anıdan en yenisine sıralar hâlinde düzgünce asılsın mı? Notlar ve çiviler yerinde kalır.';

  @override
  String get wallTidyUpAction => 'Düzenle';

  @override
  String get wallTidiedToast => 'Duvarın düzenlendi.';

  @override
  String get storyFormatTitle => 'Biçim';

  @override
  String get storyFormatStory => 'Hikâye 9:16';

  @override
  String get storyFormatPost => 'Gönderi 4:5';

  @override
  String get storyFormatSquare => 'Kare 1:1';
}
