// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get send => 'Отправить';

  @override
  String get preparing => 'Подготовка...';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get languageTitle => 'Язык';

  @override
  String get languageBody =>
      'Выбери язык приложения. «Системный» следует языку телефона, если LifeThreads его поддерживает.';

  @override
  String get systemLanguage => 'Системный';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return 'Язык изменён: $language.';
  }

  @override
  String get privacyTitle => 'Конфиденциальность';

  @override
  String get privacyBody =>
      'LifeThreads работает локально: без аккаунта и публичного профиля. Воспоминания остаются на этом устройстве, пока ты не экспортируешь резервную копию, не поделишься зашифрованной капсулой или не покажешь стену на другом экране.';

  @override
  String get viewPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsTitle => 'Условия использования';

  @override
  String get viewTerms => 'Открыть условия';

  @override
  String get betaFeedbackTitle => 'Отзыв о бета-версии';

  @override
  String get betaFeedbackBody =>
      'Отправь отзыв о бета-версии с безопасной диагностикой. В журналах только события приложения и типы сбоев — никогда текст воспоминаний, пути к фото, резервные копии или точное местоположение.';

  @override
  String get closedBetaBadge => 'Закрытая бета';

  @override
  String get sendFeedback => 'Отправить отзыв';

  @override
  String get backupArchiveBody =>
      'Сохрани всё — воспоминания, фото, заметки, нити и расположение — в один файл. Храни его на компьютере или в своём облаке и добавь пароль для шифрования.';

  @override
  String get backupArchiveTitle => 'Резервная копия';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Открыть';

  @override
  String get exportArchive => 'Экспорт архива';

  @override
  String get importArchive => 'Импорт архива';

  @override
  String get importCapsule => 'Импорт капсулы';

  @override
  String get moveDevices => 'Сменить устройство';

  @override
  String get themeTitle => 'Тема';

  @override
  String get themeBody =>
      'Выбери настроение своей личной стены. В бесплатной версии есть «Тёплая комната». Premium открывает все настроения.';

  @override
  String get oneFreeBadge => '1 бесплатно';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'Подписка Premium активна.';

  @override
  String get premiumLockedBody =>
      'На год или на месяц: безлимит воспоминаний, несколько стен, истории, темы и макеты.';

  @override
  String get activeBadge => 'Активна';

  @override
  String get openPremium => 'Открыть Premium';

  @override
  String get appVersionTitle => 'Версия приложения';

  @override
  String get clearAllDataTitle => 'Удалить все данные';

  @override
  String get clearAllDataBody =>
      'Удаляет с этого устройства все воспоминания, связи, заметки, гвоздики и скопированные фото.';

  @override
  String get clearData => 'Удалить данные';

  @override
  String exportFailed(Object error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String importRejected(Object message) {
    return 'Импорт отклонён: $message';
  }

  @override
  String importFailed(Object error) {
    return 'Ошибка импорта: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'Ошибка удаления: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'Капсула отклонена: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'Не удалось импортировать капсулу: $error';
  }

  @override
  String get clearAllDataQuestion => 'Удалить все данные?';

  @override
  String get clearAllDataQuestionBody =>
      'Все локальные данные LifeThreads на этом устройстве будут удалены навсегда. Если хочешь их сохранить, сначала экспортируй резервную копию.';

  @override
  String get clearAll => 'Удалить всё';

  @override
  String get allLocalDataCleared => 'Все локальные данные удалены.';

  @override
  String get feedbackGeneral => 'Общий отзыв';

  @override
  String get feedbackBug => 'Ошибка';

  @override
  String get feedbackCrash => 'Сбой';

  @override
  String get feedbackDesign => 'Проблема дизайна';

  @override
  String get feedbackMissingFeature => 'Не хватает функции';

  @override
  String get feedbackPerformance => 'Скорость работы';

  @override
  String get betaFeedbackIntro =>
      'Напиши, что случилось или что показалось странным. Мы приложим безопасную диагностику без личного содержимого воспоминаний.';

  @override
  String get feedbackType => 'Тип';

  @override
  String get feedbackLabel => 'Отзыв';

  @override
  String get feedbackHint =>
      'Например: нажал Добавить > Быстрое фото, и экран завис.';

  @override
  String get betaFeedbackNotIncluded =>
      'Не включается: названия воспоминаний, истории, заметки, пути к фото и резервным копиям, точное местоположение.';

  @override
  String get feedbackEmpty => 'Сначала напиши короткий отзыв.';

  @override
  String get feedbackCopied =>
      'Почтовое приложение не открылось. Отзыв скопирован в буфер обмена для info@gkcoding.dev.';

  @override
  String themeSelected(Object theme) {
    return 'Выбрана тема «$theme».';
  }

  @override
  String get onboardingHeadline => 'Создай свою живую стену.';

  @override
  String get onboardingBody =>
      'Личная комната воспоминаний, где фото, места, люди и маленькие заметки связаны нитями чувств.';

  @override
  String get onboardingPrivacy =>
      'Твои воспоминания по умолчанию приватны: без аккаунта и публичного профиля. Зашифрованный обмен через облако и резервные копии — только если ты сам их выберешь.';

  @override
  String get onboardingPrivacyShort =>
      'Без аккаунта и публичного профиля. Воспоминания остаются на этом устройстве, если ты не решишь иначе.';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingNameTitle => 'Как к тебе обращаться?';

  @override
  String get onboardingNameHint => 'Твоё имя';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'Приятно познакомиться, $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'С чего начнём?';

  @override
  String get onboardingGetStartedBody =>
      'Посмотри пример стены или начни с пустой и повесь свои воспоминания.';

  @override
  String get settingsNameTitle => 'Твоё имя';

  @override
  String get settingsNameBody => 'Показывается как приветствие на стене.';

  @override
  String get settingsNameHint => 'Твоё имя';

  @override
  String get settingsNameSaved => 'Имя обновлено.';

  @override
  String get storyPrivacyTitle => 'Воспоминания остаются приватными';

  @override
  String get storyConnectTitle => 'Связывай моменты';

  @override
  String get storyConnectText =>
      'Связывай воспоминания, заметки и места, чтобы у каждой главы был контекст.';

  @override
  String get storyWallTitle => 'Создай свою живую стену';

  @override
  String get storyWallText =>
      'Начни с одного фото, и стена будет расти, пока не оживёт.';

  @override
  String get previewDemoWall => 'Посмотреть пример';

  @override
  String get startFresh => 'Начать с нуля';

  @override
  String get optionalDemoPreview => 'Пример (по желанию)';

  @override
  String get quickTutorial => 'Краткое обучение';

  @override
  String get tutorialIntro =>
      'Сначала основы — сохранить, связать, расставить, — а потом всё остальное, что умеет твоя стена.';

  @override
  String get gotIt => 'Понятно';

  @override
  String get howItWorks => 'Как это работает';

  @override
  String get tutorialAddTitle => 'Добавь воспоминание';

  @override
  String get tutorialAddText =>
      'Нажми +, выбери «Воспоминание» или «Быстрое фото» и сохрани название, дату, людей и фото. Если уйдёшь, не сохранив, всё останется черновиком.';

  @override
  String get tutorialConnectTitle => 'Связывай воспоминания';

  @override
  String get tutorialConnectText =>
      'Открой карточку, нажми значок связи, выбери связанные воспоминания и добавь короткую причину.';

  @override
  String get tutorialArrangeTitle => 'Расставь стену';

  @override
  String get tutorialArrangeText =>
      'Перетаскивай карточки, заметки и гвоздики. Вид › Упорядочить сортирует их по дате, категории или месту — применяется кнопкой «Готово».';

  @override
  String get tutorialShowBoardTitle => 'Покажи доску';

  @override
  String get tutorialShowBoardText =>
      'Открой lifethreads.gkcoding.dev/display на другом экране, выбери Ещё › Показать стену и отсканируй код, чтобы показать временную доску только для просмотра.';

  @override
  String get tutorialBackupTitle => 'Приватность и резервные копии';

  @override
  String get tutorialBackupText =>
      'Настройки › Конфиденциальность › Блокировка открывает LifeThreads по Face ID. Перед сменой телефона экспортируй копию в Настройки › Копии и данные.';

  @override
  String get scanDisplayQr => 'Сканировать QR экрана';

  @override
  String get scannerHintTitle => 'Где QR-код?';

  @override
  String get addMemoryBeforeDisplay =>
      'Добавь воспоминание, прежде чем показывать стену.';

  @override
  String get notLifeThreadsDisplayQr => 'Это не QR-код экрана LifeThreads.';

  @override
  String get displayWallQuestion => 'Показать эту стену?';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads отправит временный снимок доски только для просмотра с воспоминаниями ($memoryCount) в отсканированную сессию браузера. Он откроется на lifethreads.gkcoding.dev/display и сам истечёт.';
  }

  @override
  String get displayAction => 'Показать';

  @override
  String get soon => 'скоро';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'Стена показывается с воспоминаниями ($memoryCount) до $expires.';
  }

  @override
  String get preparingWallDisplay => 'Подготовка показа стены...';

  @override
  String get open => 'Открыть';

  @override
  String get edit => 'Изменить';

  @override
  String get save => 'Сохранить';

  @override
  String get done => 'Готово';

  @override
  String get back => 'Назад';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get close => 'Закрыть';

  @override
  String get add => 'Добавить';

  @override
  String get saveReason => 'Сохранить причину';

  @override
  String get chooseBackup => 'Выбрать копию';

  @override
  String get chooseArchive => 'Выбрать архив';

  @override
  String get chooseCapsule => 'Выбрать капсулу';

  @override
  String get exportAction => 'Экспорт';

  @override
  String get addToWall => 'На стену';

  @override
  String get cinemaSkip => 'Пропустить';

  @override
  String get cinemaNotNow => 'Не сейчас';

  @override
  String get cinemaSharedChapter => 'Общая глава воспоминаний';

  @override
  String get cinemaConnectedThread => 'Связанная нить';

  @override
  String get cinemaInviteTitle => 'Добавить это воспоминание на твою стену?';

  @override
  String get useSelected => 'Использовать выбранное';

  @override
  String photoGridItem(String date) {
    return 'Фото от $date';
  }

  @override
  String get noPhotosFound => 'Фото не найдены.';

  @override
  String get manage => 'Управлять';

  @override
  String get manageAccess => 'Управлять доступом';

  @override
  String get saveNow => 'Сохранить';

  @override
  String get hangOnWall => 'Повесить на стену';

  @override
  String get placeHere => 'Разместить здесь';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get viewPremium => 'Смотреть Premium';

  @override
  String get memoryNotFound => 'Воспоминание не найдено';

  @override
  String get memoryTypeMoment => 'Момент';

  @override
  String get memoryTypeTrip => 'Поездка';

  @override
  String get memoryTypePerson => 'Человек';

  @override
  String get memoryTypePlace => 'Место';

  @override
  String get memoryTypeNote => 'Заметка';

  @override
  String get memoryTypeMomentDescription =>
      'Маленькая сцена, которую стоит сохранить';

  @override
  String get memoryTypeTripDescription => 'Путешествие или день вне дома';

  @override
  String get memoryTypePersonDescription => 'Кто-то важный';

  @override
  String get memoryTypePlaceDescription => 'Место со смыслом';

  @override
  String get memoryTypeNoteDescription => 'Мысль, цитата или напоминание';

  @override
  String get categoryPersonal => 'Личное';

  @override
  String get categoryFamily => 'Семья';

  @override
  String get categoryTravel => 'Путешествия';

  @override
  String get feelingWarm => 'Тепло';

  @override
  String get feelingNostalgic => 'Ностальгия';

  @override
  String get feelingProud => 'Гордость';

  @override
  String get feelingCalm => 'Спокойствие';

  @override
  String get feelingImportant => 'Важное';

  @override
  String get feelingWarmDescription => 'Нежно, близко, с любовью.';

  @override
  String get feelingNostalgicDescription =>
      'Воспоминание, которое тянет назад.';

  @override
  String get feelingProudDescription => 'Момент, который что-то доказал.';

  @override
  String get feelingCalmDescription => 'Тихо, надёжно, спокойно.';

  @override
  String get feelingImportantDescription =>
      'Воспоминание, которое изменило историю.';

  @override
  String get addPeopleHint =>
      'Добавь людей, которые были в этот момент. Контакты остаются на устройстве.';

  @override
  String get addPerson => 'Добавить человека';

  @override
  String get editPerson => 'Изменить человека';

  @override
  String get chooseFromContacts => 'Выбрать из контактов';

  @override
  String get personNameLabel => 'Имя';

  @override
  String get personNameHint => 'Начни вводить, чтобы найти сохранённых людей';

  @override
  String get relationshipLabel => 'Кем приходится';

  @override
  String get relationshipHint => 'Подруга, мама, партнёр...';

  @override
  String get phoneOptionalLabel => 'Телефон (необязательно)';

  @override
  String get emailOptionalLabel => 'Эл. почта (необязательно)';

  @override
  String get nameRelationshipRequired => 'Нужно указать имя и кем приходится.';

  @override
  String get contactAccessDenied => 'Доступ к контактам не предоставлен.';

  @override
  String get couldNotOpenContacts => 'Не удалось открыть контакты.';

  @override
  String get chooseContact => 'Выбрать контакт';

  @override
  String get searchContacts => 'Поиск контактов';

  @override
  String get noContactsFound => 'Контакты не найдены.';

  @override
  String get unnamedContact => 'Контакт без имени';

  @override
  String get contactRelationship => 'Контакт';

  @override
  String get couldNotLoadContacts => 'Не удалось загрузить контакты.';

  @override
  String get saveMomentTitle => 'Сохрани момент';

  @override
  String get todayEyebrow => 'Сегодня';

  @override
  String get addMemoryStepTitle =>
      'Что случилось такого, что не хочется потерять?';

  @override
  String get addMemoryStepSubtitle =>
      'Напиши одну строку, добавь фото, если есть, и сохрани. Детали подождут.';

  @override
  String get momentLabel => 'Момент';

  @override
  String get momentHint => 'Ужин с Ларой, первый релиз, тихая прогулка...';

  @override
  String get storyWorthLabel => 'Почему это стоит сохранить?';

  @override
  String get storyWorthHint => 'Хватит пары слов.';

  @override
  String get feelingEyebrow => 'Чувство';

  @override
  String get feelingStepTitle => 'Каким это должно ощущаться, когда вернётся?';

  @override
  String get feelingStepSubtitle => 'Так воспоминание будет проще найти потом.';

  @override
  String get contextEyebrow => 'Контекст';

  @override
  String get whenWasItTitle => 'Когда это было?';

  @override
  String get photoGpsStepSubtitle =>
      'Карта использует GPS, сохранённый в выбранных фото. Если в фото нет GPS, место не показывается.';

  @override
  String get peopleThreadsEyebrow => 'Люди и нити';

  @override
  String get peopleThreadsTitle => 'С кем или с чем это связано?';

  @override
  String get peopleThreadsSubtitle =>
      'Дополнительные детали превращают отдельные моменты в нить жизни.';

  @override
  String get connectExistingMemoryLabel =>
      'Связать с существующим воспоминанием';

  @override
  String get noConnectionYet => 'Пока без связи';

  @override
  String get connectionReasonLabel => 'Почему они связаны?';

  @override
  String get connectionReasonHint =>
      'Например: та же поездка, тот же человек, до / после...';

  @override
  String get writeMomentOrPhotoFirst => 'Сначала опиши момент или добавь фото.';

  @override
  String get todaysMoment => 'Момент дня';

  @override
  String get savedFromTodaysPrompt => 'Сохранено из вопроса дня.';

  @override
  String get saveItBeforeItFades => 'Сохрани, пока не забылось';

  @override
  String get chooseDate => 'Выбрать дату';

  @override
  String get dateLabel => 'Дата';

  @override
  String get untitledMemory => 'Без названия';

  @override
  String get organize => 'Упорядочить';

  @override
  String get memoryShape => 'Форма воспоминания';

  @override
  String get wallCategory => 'Категория на стене';

  @override
  String get privatePhotos => 'Личные фото';

  @override
  String get pick => 'Выбрать';

  @override
  String get addMore => 'Добавить ещё';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get takePhotosNow => 'Снять сейчас';

  @override
  String get takePhotosFabTooltip => 'Снять фото для нового воспоминания';

  @override
  String get takeAnotherPhoto => 'Ещё одно фото';

  @override
  String get continueWithPhotos => 'Продолжить с этими фото';

  @override
  String get addPhotosToMemory => 'Добавить к воспоминанию';

  @override
  String get takeAnotherOrContinueBody =>
      'Продолжай снимать для этого воспоминания или переходи дальше и добавь историю.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Снято $count фото',
      many: 'Снято $count фото',
      few: 'Снято $count фото',
      one: 'Снято $count фото',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads копирует выбранные фото в личное хранилище приложения и сохраняет дату и место, если они есть.';

  @override
  String get limitedPhotoAccessActive =>
      'Доступ к фото ограничен. Ты можешь разрешить больше фото.';

  @override
  String get selectPhotos => 'Выбрать фото';

  @override
  String get photoAccessOff => 'Доступ к фото выключен';

  @override
  String get photoAccessOffBody =>
      'Включи доступ к фото, чтобы выбирать воспоминания. Фото остаются на этом устройстве.';

  @override
  String get freeMemoryLimitReached => 'Бесплатный лимит исчерпан';

  @override
  String get freeMemoryLimitBody =>
      'Бесплатная стена вмещает 30 воспоминаний. Оформи Premium, чтобы стена росла дальше.';

  @override
  String get photoAccessNeeded => 'Сначала нужен доступ к фото.';

  @override
  String get quickPhotoMemory => 'Быстрое фото';

  @override
  String get quickPhotoDescription =>
      'Фото, которое стоит сохранить. Историю добавишь когда захочешь.';

  @override
  String get hangQuickPhoto => 'Повесить быстрое фото';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'Найден GPS фото: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'В фото нет GPS. Это воспоминание не появится на карте.';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • фото: $photoCount';
  }

  @override
  String metadataDates(int count, int total) {
    return 'Даты: $count/$total';
  }

  @override
  String metadataLocations(int count, int total) {
    return 'Места: $count/$total';
  }

  @override
  String metadataSizes(int count, int total) {
    return 'Размеры: $count/$total';
  }

  @override
  String newSelected(int count) {
    return 'Новых выбрано: $count';
  }

  @override
  String selectedCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get editMemoryTitle => 'Изменить воспоминание';

  @override
  String get storyPanel => 'История';

  @override
  String get memoryTitleLabel => 'Название воспоминания';

  @override
  String get addTitleValidation => 'Добавь название';

  @override
  String get storyDescriptionLabel => 'История / описание';

  @override
  String get addStoryValidation => 'Добавь короткую историю';

  @override
  String get shapeFeelingTitle => 'Форма и чувство';

  @override
  String get memoryTypeLabel => 'Тип воспоминания';

  @override
  String get feelingLabel => 'Чувство';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get timePhotoGpsTitle => 'Время и GPS фото';

  @override
  String get memoryDateLabel => 'Дата воспоминания';

  @override
  String get peopleTitle => 'Люди';

  @override
  String get galleryTitle => 'Галерея';

  @override
  String get addPhotos => 'Добавить фото';

  @override
  String get saveMemory => 'Сохранить воспоминание';

  @override
  String get memorySaveFailed =>
      'Не удалось сохранить воспоминание. Попробуй ещё раз.';

  @override
  String get passwordOnlySpaces =>
      'Пароль не может состоять только из пробелов.';

  @override
  String get somethingWentWrong => 'Что-то пошло не так. Попробуй ещё раз.';

  @override
  String get mapUnavailable => 'Карта сейчас недоступна.';

  @override
  String get coverPhoto => 'Обложка';

  @override
  String get galleryPhoto => 'Фото из галереи';

  @override
  String get setAsCover => 'Сделать обложкой';

  @override
  String get replacePhoto => 'Заменить фото';

  @override
  String get removePhoto => 'Убрать фото';

  @override
  String get choosePhoto => 'Выбрать фото';

  @override
  String get threadReasonsTitle => 'Причины нитей';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'Создай больше воспоминаний, прежде чем связывать их.';

  @override
  String get connectionHeaderBody =>
      'Связывай воспоминания с причиной. Нить должна объяснять, почему два момента вместе.';

  @override
  String get connectedMemory => 'связанное воспоминание';

  @override
  String get whyConnectedTitle => 'Почему они связаны?';

  @override
  String get exportPremiumArchiveTitle => 'Экспорт копии';

  @override
  String get importArchiveTitle => 'Импорт архива';

  @override
  String get archiveExportBody =>
      'Добавь пароль, чтобы зашифровать архив. Оставь пустым для обычного локального zip.';

  @override
  String get archiveImportBody =>
      'Если архив зашифрован, введи пароль. Для старых или незащищённых копий оставь пустым.';

  @override
  String get archivePasswordOptional => 'Пароль архива (необязательно)';

  @override
  String get archivePasswordLabel => 'Пароль архива';

  @override
  String get archivePasswordWarning =>
      'Храни пароль в надёжном месте. Если потеряешь, восстановить его нельзя.';

  @override
  String get sendArchiveTitle => 'Отправить архив LifeThreads';

  @override
  String get sendArchiveSubject => 'Архив воспоминаний LifeThreads';

  @override
  String get sendEncryptedArchiveText =>
      'Зашифрованный архив LifeThreads. Используй выбранный пароль, чтобы импортировать его на другом устройстве.';

  @override
  String get sendArchiveText =>
      'Архив LifeThreads. Импортируй его в LifeThreads, чтобы открыть стену воспоминаний на другом устройстве.';

  @override
  String get archiveReadyToSend =>
      'Копия готова. Храни её в надёжном месте, не на этом телефоне.';

  @override
  String get archiveNotSaved =>
      'Копия не сохранена. Экспортируй снова, когда будешь готов.';

  @override
  String get archiveSharingUnavailable =>
      'На этом устройстве нельзя поделиться.';

  @override
  String archiveShareFailed(Object error) {
    return 'Архив сохранён, но поделиться не удалось: $error';
  }

  @override
  String get archiveImportedTitle => 'Архив импортирован';

  @override
  String get memoriesLabel => 'Воспоминания';

  @override
  String get photosLabel => 'Фото';

  @override
  String get wallNotesNailsLabel => 'Заметки / гвоздики';

  @override
  String get connectionsLabel => 'Связи';

  @override
  String get archiveImportSummary =>
      'Твоя текущая стена сохранена. Импортированные воспоминания безопасно добавлены.';

  @override
  String get shareEncryptedCapsuleTitle => 'Поделиться зашифрованной капсулой';

  @override
  String get openSharedCapsuleTitle => 'Открыть общую капсулу';

  @override
  String get exportMemoryCapsuleTitle => 'Экспорт капсулы воспоминания';

  @override
  String get importCapsuleDialogTitle => 'Импорт капсулы';

  @override
  String get secureSharePasswordBody =>
      'Придумай пароль перед загрузкой капсулы. Отправь пароль получателю отдельно.';

  @override
  String get sharedCapsulePasswordBody =>
      'Введи пароль, который ты получил для этого воспоминания.';

  @override
  String get capsuleExportBody =>
      'Добавь пароль, если воспоминание нужно защитить перед отправкой. Оставь пустым для обычной капсулы.';

  @override
  String get capsuleImportBody =>
      'Если у капсулы есть пароль, введи его. Иначе оставь пустым.';

  @override
  String get capsulePasswordLabel => 'Пароль капсулы';

  @override
  String get sharedCapsulePasswordLabel => 'Пароль общей капсулы';

  @override
  String get capsulePasswordOptional => 'Пароль капсулы (необязательно)';

  @override
  String get capsulePasswordWarning =>
      'LifeThreads не сможет восстановить этот пароль.';

  @override
  String get passwordRequiredCloudSharing =>
      'Для обмена через облако нужен пароль.';

  @override
  String get createSecureShare => 'Создать защищённую ссылку';

  @override
  String get previewMemory => 'Предпросмотр';

  @override
  String get sendCapsuleTitle => 'Поделиться воспоминанием LifeThreads';

  @override
  String get sendCapsuleSubject => 'Капсула воспоминания LifeThreads';

  @override
  String get sendEncryptedCapsuleText =>
      'Привет! Я поделился с тобой защищённым воспоминанием в LifeThreads. Импортируй его с паролем, который я прислал.';

  @override
  String get sendCapsuleText =>
      'Привет! Я поделился с тобой воспоминанием в LifeThreads. Импортируй капсулу в LifeThreads, чтобы добавить его на свою стену.';

  @override
  String get capsuleReadyToSend => 'Капсула готова к отправке.';

  @override
  String get capsuleSavedLater => 'Капсула сохранена. Поделиться можно позже.';

  @override
  String get capsuleSharingUnavailable =>
      'Капсула сохранена, но поделиться нельзя.';

  @override
  String capsuleShareFailed(Object error) {
    return 'Капсула сохранена, но поделиться не удалось: $error';
  }

  @override
  String get importThisMemory => 'Импортировать это воспоминание?';

  @override
  String get noStoryTextIncluded => 'Текста истории нет.';

  @override
  String get placeLabel => 'Место';

  @override
  String get notesLabel => 'Заметки';

  @override
  String get capsulePasswordProtected => 'Эта капсула была защищена паролем.';

  @override
  String get openingSharedMemory => 'Открываем воспоминание...';

  @override
  String get lifeThreadsMemoryTitle => 'Воспоминание LifeThreads';

  @override
  String shareMemoryText(Object url) {
    return 'Привет! Я поделился с тобой воспоминанием в LifeThreads.\n\n$url';
  }

  @override
  String get shareLinkReady => 'Ссылка готова.';

  @override
  String get shareLinkCreated => 'Ссылка создана.';

  @override
  String get shareLinkUnavailable => 'Ссылка создана, но поделиться нельзя.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label Ссылка истечёт сама. Можно удалить её сейчас.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'Ошибка обмена через облако: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'Ссылка на воспоминание удалена.';

  @override
  String get creatingSecureMemoryLink => 'Создаём защищённую ссылку...';

  @override
  String get shareMemoryCapsule => 'Поделиться капсулой';

  @override
  String get editStory => 'Изменить историю';

  @override
  String get metaType => 'Тип';

  @override
  String get metaFeeling => 'Чувство';

  @override
  String get metaCategory => 'Категория';

  @override
  String get metaDate => 'Дата';

  @override
  String get storyEyebrow => 'История';

  @override
  String get whyMemoryMatters => 'Почему это воспоминание важно';

  @override
  String get galleryEyebrow => 'Галерея';

  @override
  String editSectionTooltip(String section) {
    return 'Изменить: $section';
  }

  @override
  String get openInMaps => 'Открыть в Картах';

  @override
  String get memoryChangesSaved => 'Изменения сохранены.';

  @override
  String get memoryDeletedToast => 'Воспоминание удалено.';

  @override
  String get noteDeletedToast => 'Заметка удалена.';

  @override
  String get nailDeletedToast => 'Гвоздик убран.';

  @override
  String get undo => 'Отменить';

  @override
  String photoPlaceDetected(String place) {
    return 'Место из фото: $place';
  }

  @override
  String get settingsGroupYou => 'Ты';

  @override
  String get settingsGroupReminders => 'Напоминания';

  @override
  String get settingsGroupMore => 'Ещё';

  @override
  String get backupDataTitle => 'Копии и данные';

  @override
  String get backupDataSubtitle =>
      'Резервная копия, восстановление, новый телефон';

  @override
  String get aboutHelpTitle => 'О приложении и помощь';

  @override
  String get aboutHelpSubtitle => 'Отзыв, конфиденциальность, музыка, версия';

  @override
  String get discardChangesTitle => 'Отменить изменения?';

  @override
  String get discardChangesBody => 'Твои изменения здесь пропадут.';

  @override
  String get discardChanges => 'Отменить';

  @override
  String get keepEditing => 'Продолжить';

  @override
  String get settingsGroupPrivacy => 'Конфиденциальность';

  @override
  String get appLockTitle => 'Блокировка';

  @override
  String get appLockSubtitle => 'Face ID или код для входа в LifeThreads';

  @override
  String get appLockReason => 'Открой свои воспоминания';

  @override
  String get appLockLockedTitle => 'LifeThreads заблокирован';

  @override
  String get appLockUnlock => 'Разблокировать';

  @override
  String get appLockUnavailable =>
      'Сначала настрой Face ID или код-пароль на этом телефоне.';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Тебя ждёт воспоминание $years года назад.',
      many: 'Тебя ждёт воспоминание $years лет назад.',
      few: 'Тебя ждёт воспоминание $years года назад.',
      one: 'Тебя ждёт воспоминание $years год назад.',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Поиск';

  @override
  String get searchHint => 'Название, место, человек или год';

  @override
  String get searchClear => 'Очистить поиск';

  @override
  String get searchNoResults => 'Ничего не найдено.';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count воспоминания',
      many: '$count воспоминаний',
      few: '$count воспоминания',
      one: '$count воспоминание',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => 'Искать воспоминания';

  @override
  String get premiumFeatureWalls => 'Больше стен';

  @override
  String get newWall => 'Новая стена';

  @override
  String get wallNameLabel => 'Название стены';

  @override
  String get newWallHint => 'напр. Поездки 2025';

  @override
  String get createWall => 'Создать';

  @override
  String get renameWall => 'Переименовать';

  @override
  String get deleteWall => 'Удалить стену';

  @override
  String deleteWallQuestion(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get deleteWallBody =>
      'Её воспоминания перейдут на «Мою стену» — ничего не пропадёт.';

  @override
  String get personalWallSubtitle => 'Твоя стена на этом устройстве';

  @override
  String get wallOptions => 'Параметры стены';

  @override
  String get moveToWall => 'Переместить на стену…';

  @override
  String movedToWall(String name) {
    return 'Перемещено: $name.';
  }

  @override
  String get hideMemory => 'Скрыть';

  @override
  String get unhideMemory => 'Показать снова';

  @override
  String get memoryHiddenToast =>
      'Скрыто. Найдёшь в Вид › Скрытые воспоминания.';

  @override
  String get showHiddenMemories => 'Скрытые воспоминания';

  @override
  String get showHiddenReason => 'Показать скрытые воспоминания';

  @override
  String get yearThreadFirstTitle => 'Твоя первая «Нить года»';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count из 3 воспоминаний',
      many: '$count из 3 воспоминаний',
      few: '$count из 3 воспоминаний',
      one: '$count из 3 воспоминаний',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => 'Или создай историю сейчас';

  @override
  String get moveMemoriesHere => 'Перенести сюда воспоминания';

  @override
  String get moveMemoriesTitle => 'Выбери воспоминания для переноса';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Перенести $count воспоминания',
      many: 'Перенести $count воспоминаний',
      few: 'Перенести $count воспоминания',
      one: 'Перенести $count воспоминание',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'Показать все';

  @override
  String get addAMemory => 'Добавить воспоминание';

  @override
  String get mapAddPhotoMemory => 'Добавь фото с местом';

  @override
  String get searchSuggestions => 'Попробуй своё';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'На этой неделе $years года назад',
      many: 'На этой неделе $years лет назад',
      few: 'На этой неделе $years года назад',
      one: 'На этой неделе $years год назад',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => 'Кто там был?';

  @override
  String get premiumPlanYearly => 'На год';

  @override
  String get premiumPlanMonthly => 'На месяц';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/год';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Выгода $percent%';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'Оплата списывается с аккаунта $store. Подписка продлевается автоматически каждый год, если не отменить её не позднее чем за 24 часа до конца текущего периода. Управлять подпиской или отменить её можно в настройках аккаунта $store.';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сохранённых фото',
      many: '$count сохранённых фото',
      few: '$count сохранённых фото',
      one: '$count сохранённое фото',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => 'Люди';

  @override
  String get partOfMemory => 'В этом воспоминании';

  @override
  String get notesEyebrow => 'Заметки';

  @override
  String get attachedThoughts => 'Прикреплённые мысли';

  @override
  String get stickyNote => 'Стикер';

  @override
  String get placeEyebrow => 'Место';

  @override
  String get threadsEyebrow => 'Нити';

  @override
  String get connectedMemories => 'Связанные воспоминания';

  @override
  String get noConnectedMemoriesYet =>
      'Пока нет связанных воспоминаний. Свяжи эту главу с другим моментом, чтобы начать видимую нить жизни.';

  @override
  String get backToWall => 'Назад к стене';

  @override
  String get addTextToWall => 'Добавить текст на стену';

  @override
  String get addTextAction => 'Добавить текст';

  @override
  String get textNoteHint =>
      'Напиши маленькое воспоминание, цитату или заметку...';

  @override
  String get placeTextNote => 'Разместить заметку';

  @override
  String get placeRopeAnchor => 'Разместить крепление';

  @override
  String get nailSubtitle =>
      'Гвоздик позволяет вручную натянуть нити между воспоминаниями.';

  @override
  String get clearDemoWallQuestion => 'Очистить пример?';

  @override
  String get clearDemoWallBody =>
      'Примеры воспоминаний будут удалены, и ты начнёшь с пустой личной стены.';

  @override
  String get importBackupQuestion => 'Импортировать копию?';

  @override
  String get importBackupBody =>
      'Воспоминания будут восстановлены из архива LifeThreads, а текущая стена останется.';

  @override
  String get deleteMemoryQuestion => 'Удалить воспоминание?';

  @override
  String get deleteMemoryBody =>
      'Воспоминание и все его связи на стене будут удалены.';

  @override
  String get editText => 'Изменить текст';

  @override
  String get editTextTitle => 'Изменить текст';

  @override
  String get connectRope => 'Натянуть нить';

  @override
  String get connectRopeSubtitle => 'Привяжи этот гвоздик к воспоминаниям.';

  @override
  String get deleteNail => 'Удалить гвоздик';

  @override
  String get connectNailTitle => 'Привязать гвоздик к воспоминаниям';

  @override
  String get connectNailSubtitle =>
      'Выбранные воспоминания будут висеть на этом креплении.';

  @override
  String get timelineTitle => 'Хронология';

  @override
  String get timelineSubtitle => 'Твои воспоминания по времени.';

  @override
  String get noMemoriesFilter => 'Нет воспоминаний в этом фильтре';

  @override
  String get noMemoriesFilterBody =>
      'Смени фильтр или добавь воспоминание, чтобы построить хронологию.';

  @override
  String get memoryMapTitle => 'Карта воспоминаний';

  @override
  String get memoryMapSubtitle => 'Твои воспоминания по местам.';

  @override
  String get noMappedMemories => 'На карте пока нет воспоминаний';

  @override
  String get displayWallTooltip => 'Показать стену';

  @override
  String get tutorialTooltip => 'Обучение';

  @override
  String get settingsTooltip => 'Настройки';

  @override
  String get freeformLayout => 'Свободно';

  @override
  String get categoryLayout => 'Категория';

  @override
  String get locationLayout => 'Место';

  @override
  String get saveToday => 'Сохранить сегодня';

  @override
  String get rememberThis => 'Запомнить';

  @override
  String get whatHappenedToday => 'Что сегодня случилось?';

  @override
  String get tapToOpenDrag => 'Нажми, чтобы открыть • тяни, чтобы переместить';

  @override
  String get demoWallPreview =>
      'Это пример стены. Очисти его, когда будешь готов начать с нуля.';

  @override
  String get clearDemo => 'Очистить пример';

  @override
  String get chooseQuickPhoto => 'Выбрать быстрое фото';

  @override
  String get wallView => 'Стена';

  @override
  String get timelineView => 'Хронология';

  @override
  String get mapView => 'Карта';

  @override
  String get wallFilterAll => 'Все';

  @override
  String get wallViewButton => 'Вид';

  @override
  String get wallShowAs => 'Показать как';

  @override
  String get wallArrange => 'Упорядочить';

  @override
  String get wallShowOnly => 'Показать';

  @override
  String get layoutByDate => 'По дате';

  @override
  String get moreActionsTooltip => 'Ещё';

  @override
  String get addToWallTitle => 'Добавить на стену';

  @override
  String get expandableMemory => 'Воспоминание';

  @override
  String get expandableMemorySubtitle => 'Полная история с подсказками';

  @override
  String get expandableQuickPhoto => 'Быстрое фото';

  @override
  String get expandableQuickPhotoSubtitle => 'Выбери фото и повесь';

  @override
  String get expandableTextNote => 'Заметка';

  @override
  String get expandableTextNoteSubtitle => 'Короткая мысль на стене';

  @override
  String get expandableNail => 'Гвоздик / крепление';

  @override
  String get expandableNailSubtitle => 'Ручная точка для нити';

  @override
  String get startWithOneThing => 'Начни с одного события дня';

  @override
  String get emptyWallBody =>
      'Сохрани момент, пока он не забылся. Хватит одной фразы или фото.';

  @override
  String get usePhoto => 'Взять фото';

  @override
  String get editMemoryTooltip => 'Изменить воспоминание';

  @override
  String get connectMemoryTooltip => 'Связать воспоминание';

  @override
  String get archiveTransferTitle => 'Открыть на другом устройстве';

  @override
  String get archiveTransferHeroTitle =>
      'Безопасно переноси воспоминания между устройствами.';

  @override
  String get archiveTransferHeroBody =>
      'Резервная копия — это один zip с воспоминаниями, фото, заметками, нитями, расположением на стене и метаданными, по желанию с паролем. Мы не храним копий: ты сам решаешь, куда её отправить.';

  @override
  String get archiveTransferStep1Title => 'Экспортируй архив';

  @override
  String get archiveTransferStep1Body =>
      'Открой Настройки, выбери «Экспорт архива» и добавь пароль, если нужна защита.';

  @override
  String get archiveTransferStep2Title => 'Перенеси zip';

  @override
  String get archiveTransferStep2Body =>
      'Передай его через AirDrop, USB, своё облако или почту.';

  @override
  String get archiveTransferStep3Title => 'Импортируй безопасно';

  @override
  String get archiveTransferStep3Body =>
      'Установи LifeThreads на другом устройстве, выбери «Импорт архива», при необходимости введи пароль и восстанови данные, ничего не удаляя.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled => 'Тестовый Premium включён.';

  @override
  String get lifetimeActive => 'Подписка активна';

  @override
  String get oneTimeLifetimeUnlock => 'На год или на месяц';

  @override
  String get premiumHeroActiveTitle => 'Твоя стена воспоминаний безгранична.';

  @override
  String get premiumHeroLockedTitle => 'Преврати воспоминания в истории.';

  @override
  String get premiumHeroActiveBody =>
      'Подписка Premium активна. Истории с музыкой, «Нить года», семейные стены и безлимит воспоминаний — всё твоё.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'Бесплатно: воспоминаний — $limit и полные резервные копии. Premium добавляет истории и фильмы с музыкой, «Нить года», семейные стены и безлимит воспоминаний.';
  }

  @override
  String get premiumMemories => 'Воспоминания Premium';

  @override
  String get freeMemories => 'Бесплатные воспоминания';

  @override
  String get unlimited => 'без ограничений';

  @override
  String get benefitUnlimitedTitle => 'Безлимит воспоминаний';

  @override
  String get benefitUnlimitedBody =>
      'Никакого потолка в 30 воспоминаний. Стена растёт вместе с жизнью.';

  @override
  String get benefitThemesTitle => 'Темы Premium';

  @override
  String get benefitThemesBody =>
      'Открой более богатые настроения, сезонные темы и «Авто по времени суток».';

  @override
  String get benefitLayoutsTitle => 'Расширенные макеты';

  @override
  String get benefitLayoutsBody =>
      'Больше способов расставить нити, хронологии, крепления и группы воспоминаний.';

  @override
  String get lifetimeUnlock => 'Подписка Premium';

  @override
  String get premiumActiveOnDevice => 'Premium активен на этом устройстве.';

  @override
  String onePurchaseBody(String store) {
    return 'Подпишись на год или на месяц: истории с музыкой, «Нить года», семейные стены и безлимит воспоминаний. Отменить можно в любой момент в настройках $store.';
  }

  @override
  String get premiumActiveButton => 'Premium активен';

  @override
  String get processing => 'Обработка...';

  @override
  String get unlockPremium => 'Оформить Premium';

  @override
  String get restorePurchase => 'Восстановить подписку';

  @override
  String get enableDebugMockUnlock => 'Включить тестовую разблокировку';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'Оплата списывается с аккаунта $store. Подписка продлевается автоматически каждый месяц, если не отменить её не позднее чем за 24 часа до конца текущего периода. Управлять подпиской или отменить её можно в настройках аккаунта $store.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'Не удалось обновить данные магазина. Попробуй ещё раз.';

  @override
  String get premiumMessageStoreUnavailable =>
      'Покупки на этом устройстве недоступны.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium пока нет в магазине. Попробуй позже.';

  @override
  String get premiumMessageLoadFailed =>
      'Не удалось загрузить Premium из магазина. Попробуй ещё раз.';

  @override
  String get premiumMessageOpeningCheckout => 'Открываем оплату…';

  @override
  String get premiumMessageCheckoutFailed =>
      'Не удалось открыть оплату. Попробуй ещё раз.';

  @override
  String get premiumMessageChecking => 'Проверяем подписку…';

  @override
  String get premiumMessageRestoreFailed =>
      'Не удалось восстановить. Попробуй ещё раз.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'Активная подписка Premium не найдена.';

  @override
  String get premiumMessagePending =>
      'Покупка ожидает подтверждения. Premium откроется после одобрения.';

  @override
  String get premiumMessagePurchaseFailed =>
      'Покупка не прошла. Попробуй ещё раз.';

  @override
  String get premiumMessageCanceled => 'Покупка отменена.';

  @override
  String get premiumMessageRestored => 'Подписка Premium восстановлена.';

  @override
  String get premiumMessageActive => 'Подписка Premium активна.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/мес.';
  }

  @override
  String get loadingPlayStoreProduct => 'Загружаем подписку…';

  @override
  String get playStoreUnavailable => 'Магазин сейчас недоступен';

  @override
  String get productNotConfigured => 'Premium сейчас недоступен';

  @override
  String get purchasePending => 'Покупка ожидает';

  @override
  String get purchased => 'Куплено';

  @override
  String get restored => 'Восстановлено';

  @override
  String get premiumTryAgain => 'Повторить';

  @override
  String get purchaseFailed => 'Покупка не удалась';

  @override
  String get preparingCheckout => 'Готовим оплату...';

  @override
  String get premiumLocalFirstTitle => 'Premium тоже локальный';

  @override
  String get premiumLocalFirstBody =>
      'Воспоминания остаются на твоём устройстве, а резервные копии бесплатны для всех.';

  @override
  String get noMappedMemoriesBody =>
      'Добавь фото с GPS-данными, чтобы увидеть воспоминания здесь.';

  @override
  String get peopleLabel => 'Люди';

  @override
  String get connect => 'Связать';

  @override
  String get themeWarmMemoryRoom => 'Тёплая комната';

  @override
  String get themeWarmMemoryRoomDescription =>
      'Мягкое тёмное тепло, золотой свет и глубина уютной комнаты.';

  @override
  String get themeMidnightArchive => 'Полуночный архив';

  @override
  String get themeMidnightArchiveDescription =>
      'Тёмно-синий архив с музейной тишиной.';

  @override
  String get themeSoftPaperWall => 'Мягкая бумага';

  @override
  String get themeSoftPaperWallDescription =>
      'Кремовая бумага, тени чернил и спокойствие скрапбука.';

  @override
  String get themeTravelCorkboard => 'Пробковая доска';

  @override
  String get themeTravelCorkboardDescription =>
      'Тёплая пробка с картографической сеткой для поездок и мест.';

  @override
  String get themeAutoTitle => 'Авто по времени суток';

  @override
  String get themeAutoDescription =>
      'Днём «Мягкая бумага», вечером «Тёплая комната», ночью «Полуночный архив».';

  @override
  String get themeAutoSelected => 'Теперь стена меняется по времени суток.';

  @override
  String get themeSeasonalTitle => 'Сезонные';

  @override
  String get themeSeasonalBody =>
      'Ограниченные темы Premium, каждая доступна только в свой сезон.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'До $dateString';
  }

  @override
  String get themeUseButton => 'Выбрать тему';

  @override
  String get themeInUse => 'Используется';

  @override
  String get themeUnlockButton => 'Открыть с Premium';

  @override
  String get themeAutumnHarvest => 'Осенний урожай';

  @override
  String get themeAutumnHarvestDescription =>
      'Янтарный свет, карточки из крафт-бумаги и блеск падающих листьев.';

  @override
  String get themeWinterLights => 'Зимние огни';

  @override
  String get themeWinterLightsDescription =>
      'Заиндевевшие карточки и тёплые гирлянды холодной синей ночью.';

  @override
  String get themeSpringBlossom => 'Весенний цвет';

  @override
  String get themeSpringBlossomDescription =>
      'Бледные цветочные карточки с мягким розовым сиянием.';

  @override
  String get themeSummerEvening => 'Летний вечер';

  @override
  String get themeSummerEveningDescription =>
      'Цвета заката и карточки моментальных фото.';

  @override
  String get themeYearRoundTitle => 'Всегда доступны';

  @override
  String get themeComingTitle => 'Скоро';

  @override
  String get themeComingBody =>
      'Загляни в следующие сезоны. Каждая тема открывается в первый день своего сезона.';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'С $dateString';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Все темы, $count для этого сезона',
      many: 'Все темы, $count для этого сезона',
      few: 'Все темы, $count для этого сезона',
      one: 'Все темы, $count для этого сезона',
      zero: 'Все темы',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => 'У моря';

  @override
  String get themeSeasideDescription =>
      'Бирюзовая вода, песочная бумага и тёплый летний свет.';

  @override
  String get themeSnowyCabin => 'Заснеженный домик';

  @override
  String get themeSnowyCabinDescription =>
      'Дерево у камина, заиндевевшие карточки и мягкий снег за окном.';

  @override
  String get themeSpringMeadow => 'Весенний луг';

  @override
  String get themeSpringMeadowDescription =>
      'Свежая зелень, светлые карточки и жёлтое солнце.';

  @override
  String get themeMistyForest => 'Туманный лес';

  @override
  String get themeMistyForestDescription =>
      'Тихие сосны, утренний туман и золотые листья.';

  @override
  String get demoFirstDanceTitle => 'Наш первый танец';

  @override
  String get demoFirstDanceStory =>
      'Группа заиграла нашу песню, и весь амбар затих. Я дважды наступил тебе на ногу, ты всё время смеялась, и три минуты вокруг не было никого.';

  @override
  String get demoFirstDancePlace => 'Зальцбург';

  @override
  String get demoNewbornTitle => 'С возвращением домой, Лина';

  @override
  String get demoNewbornStory =>
      'Вся её ладошка умещалась вокруг одного пальца. Первое тихое утро дома.';

  @override
  String get demoNewbornPlace => 'Вена';

  @override
  String get demoBeachSunsetTitle => 'Лето у моря';

  @override
  String get demoBeachSunsetStory =>
      'Босиком до самого заката, а на обратном пути Лина уснула у тебя на плечах.';

  @override
  String get demoBeachSunsetPlace => 'Сплит, Хорватия';

  @override
  String get demoGrandmaKitchenTitle => 'Бабушкина кухня';

  @override
  String get demoGrandmaKitchenStory =>
      'Её абрикосовый пирог наконец записан — и мука повсюду.';

  @override
  String get demoGrandmaKitchenPlace => 'Грац';

  @override
  String get demoGraduationTitle => 'Выпускной';

  @override
  String get demoGraduationStory =>
      'Папа заплакал ещё до того, как упали шапочки.';

  @override
  String get demoGraduationPlace => 'Инсбрук';

  @override
  String get demoFirstHomeTitle => 'Ключи от нашего первого дома';

  @override
  String get demoFirstHomeStory =>
      'Мебели ещё нет — только коробки, пицца на полу и куча планов.';

  @override
  String get demoFirstHomePlace => 'Линц';

  @override
  String get demoAlpineSummitTitle => 'Над облаками';

  @override
  String get demoAlpineSummitStory =>
      'Подъём в 4 утра ради этого. Каждый шаг того стоил.';

  @override
  String get demoAlpineSummitPlace => 'Гросглокнер';

  @override
  String get demoFirstBikeTitle => 'Первый заезд без рук';

  @override
  String get demoFirstBikeStory =>
      'Три оборота педалей, немного шатания — и он уехал. Такой гордый.';

  @override
  String get demoFirstBikePlace => 'Пратер, Вена';

  @override
  String get demoGardenDinnerTitle => 'Дедушке 80';

  @override
  String get demoGardenDinnerStory =>
      'Четыре поколения за одним длинным столом, а лучшие истории всё равно рассказывал он.';

  @override
  String get demoGardenDinnerPlace => 'Вахау';

  @override
  String get demoThreadFirstDanceToFirstHome => 'Наша история';

  @override
  String get demoThreadFirstHomeToNewborn => 'Потом появилась Лина';

  @override
  String get demoThreadNewbornToBeachSunset => 'Её первое лето';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'Семья';

  @override
  String get demoThreadGraduationToFirstHome => 'Новая глава';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'Маленькие приключения';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'Дедушка смотрел';

  @override
  String get demoRelationGrandpa => 'Дедушка';

  @override
  String get demoRelationGrandma => 'Бабушка';

  @override
  String get demoRelationDaughter => 'Дочь';

  @override
  String get demoRelationWife => 'Жена';

  @override
  String get demoRelationBestMan => 'Шафер';

  @override
  String get demoRelationMother => 'Мама';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Сохранено в $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count воспоминания ещё не в резервной копии.',
      many: '$count воспоминаний ещё не в резервной копии.',
      few: '$count воспоминания ещё не в резервной копии.',
      one: '$count воспоминание ещё не в резервной копии.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Позже';

  @override
  String get backUp => 'Сделать копию';

  @override
  String get onThisDayTitle => 'В этот день';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years года назад в этот день',
      many: '$years лет назад в этот день',
      few: '$years года назад в этот день',
      one: '$years год назад в этот день',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years года назад',
      many: '$years лет назад',
      few: '$years года назад',
      one: '$years год назад',
    );
    return 'В этот день · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'В дни, когда возвращается воспоминание из прошлых лет, LifeThreads присылает одно тихое напоминание.';

  @override
  String get onThisDayReminderSwitch => 'Ежедневное напоминание';

  @override
  String onThisDayReminderAt(String time) {
    return 'В $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'Уведомления LifeThreads выключены. Разреши их в настройках телефона.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years года назад в этот день: $title',
      many: '$years лет назад в этот день: $title',
      few: '$years года назад в этот день: $title',
      one: '$years год назад в этот день: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count воспоминания',
      many: '$count воспоминаний',
      few: '$count воспоминания',
      one: '$count воспоминание',
    );
    return '$title и ещё $_temp0 этого дня';
  }

  @override
  String get onThisDayChannelDescription =>
      'Воспоминание этого дня из прошлых лет.';

  @override
  String get benefitOnThisDayBody =>
      'Напоминание, когда возвращается воспоминание из прошлых лет, — открывается как отдельная глава.';

  @override
  String get premiumFeatureStoryImage => 'Картинки историй';

  @override
  String get premiumFeatureStoryVideo => 'Видео историй';

  @override
  String get premiumFeatureThreadOfTheYear => 'Нить года';

  @override
  String get premiumFeatureFamilyWall => 'Семейная стена';

  @override
  String premiumFeatureNotice(String feature) {
    return '«$feature» — часть Premium.';
  }

  @override
  String get yearThreadTitle => 'Нить года';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count воспоминания',
      many: '$count воспоминаний',
      few: '$count воспоминания',
      one: '$count воспоминание',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count места',
      many: '$count мест',
      few: '$count места',
      one: '$count место',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count человека',
      many: '$count человек',
      few: '$count человека',
      one: '$count человек',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count месяца',
      many: '$count месяцев',
      few: '$count месяца',
      one: '$count месяц',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'Чаще всего: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'Год на одной нити.';

  @override
  String get yearThreadMyYear => 'Мой год';

  @override
  String get yearThreadWallCardTitle => 'Твой год в воспоминаниях';

  @override
  String yearThreadWallCardBody(String year) {
    return 'Преврати $year год в короткий фильм.';
  }

  @override
  String get yearThreadDismiss => 'Не сейчас';

  @override
  String get yearThreadSettingsBody =>
      'Преврати любой год, где есть хотя бы 3 воспоминания, в короткий фильм — по порядку и связанный нитью.';

  @override
  String get yearThreadOpen => 'Создать фильм';

  @override
  String get yearThreadNoYears =>
      'Для «Нити года» нужен год хотя бы с 3 воспоминаниями. Сохраняй моменты и возвращайся.';

  @override
  String get yearThreadYear => 'Год';

  @override
  String get yearThreadLength => 'Длительность';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'Фильм · $seconds с';
  }

  @override
  String get yearThreadLengthStory => 'История · 20 с';

  @override
  String get yearThreadMusic => 'Музыка';

  @override
  String get yearThreadNoMusic => 'Без музыки';

  @override
  String get yearThreadInFilm => 'В фильме';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count из $max';
  }

  @override
  String get yearThreadAddMemory => 'Добавить воспоминание';

  @override
  String get yearThreadSwap => 'Заменить';

  @override
  String get yearThreadRemove => 'Убрать';

  @override
  String get yearThreadUseSuggestions => 'Взять предложенные';

  @override
  String yearThreadPickTitle(String year) {
    return 'Выбери воспоминание за $year';
  }

  @override
  String get yearThreadNoOthers => 'Все воспоминания этого года уже в фильме.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count воспоминания',
      many: '$count воспоминаний',
      few: '$count воспоминания',
      one: '$count воспоминание',
    );
    return 'Выбери хотя бы $_temp0.';
  }

  @override
  String get yearThreadPreview => 'Предпросмотр';

  @override
  String get yearThreadExportVideo => 'Экспорт видео';

  @override
  String get yearThreadExportImage => 'Экспорт картинки';

  @override
  String get yearThreadShare => 'Поделиться';

  @override
  String get yearThreadSave => 'Сохранить в Фото';

  @override
  String get yearThreadMakingFilm => 'Создаём фильм…';

  @override
  String get yearThreadMakingImage => 'Создаём картинку…';

  @override
  String get yearThreadFilmReady => 'Фильм готов';

  @override
  String get yearThreadImageReady => 'Картинка готова';

  @override
  String get yearThreadSaved => 'Сохранено в фото.';

  @override
  String get yearThreadExportFailed => 'Не получилось. Попробуй ещё раз.';

  @override
  String get yearThreadPlay => 'Воспроизвести';

  @override
  String get yearThreadPause => 'Пауза';

  @override
  String get createStory => 'Создать историю';

  @override
  String get storyPickTitle => 'Выбери воспоминания';

  @override
  String storyPickBody(int max) {
    return 'Выбери до $max воспоминаний для одной истории.';
  }

  @override
  String storyPickCount(int count, int max) {
    return 'Выбрано $count из $max';
  }

  @override
  String storyPickLimit(int max) {
    return 'В истории может быть до $max воспоминаний.';
  }

  @override
  String get storyPickContinue => 'Продолжить';

  @override
  String get storyNoMemories =>
      'Сначала сохрани воспоминание, а потом преврати его в историю.';

  @override
  String get storyEditorTitle => 'Твоя история';

  @override
  String get storyChangeMemories => 'Сменить воспоминания';

  @override
  String get storyTemplateSingle => 'По одному';

  @override
  String get storyTemplateThread => 'Стена с нитью';

  @override
  String get storyTemplateCollage => 'Коллаж';

  @override
  String get storyTemplateQuote => 'Слова';

  @override
  String get storySwipeHint => 'Листай, чтобы сменить вид';

  @override
  String get storyCaptionLabel => 'Подпись';

  @override
  String get storyCaptionHint => 'Одна строка твоей истории';

  @override
  String get storyVideoSwitch => 'Видео';

  @override
  String get storyVideoBody =>
      'Короткий фильм для Stories и Reels — с движением и музыкой.';

  @override
  String get storyMusicTitle => 'Музыка';

  @override
  String get storyMusicNone => 'Без музыки';

  @override
  String get storyMusicNoneHint =>
      'Музыку можно добавить и в Instagram при публикации.';

  @override
  String get storyMoodWarm => 'Тёплая';

  @override
  String get storyMoodJoyful => 'Радостная';

  @override
  String get storyMoodCalm => 'Спокойная';

  @override
  String get storyMoodNostalgic => 'Ностальгическая';

  @override
  String get storyMoodEpic => 'Эпичная';

  @override
  String get storyMoodEmotional => 'Трогательная';

  @override
  String get storyMusicTrimHint =>
      'Перетащи золотую рамку, чтобы выбрать часть песни';

  @override
  String get storySearchHint => 'Воспоминания, места, годы';

  @override
  String storySearchEmpty(String query) {
    return 'Ничего не найдено по запросу «$query».';
  }

  @override
  String get storyMemoriesInStory => 'В твоей истории';

  @override
  String get storyMemoriesReorderHint =>
      'Удерживай и перетаскивай, чтобы изменить порядок';

  @override
  String get storyAddMemory => 'Добавить';

  @override
  String get storyAddMemoryTitle => 'Добавить воспоминание';

  @override
  String storyRemoveMemory(String title) {
    return 'Убрать «$title» из истории';
  }

  @override
  String get storyAllMemoriesAdded => 'Все воспоминания уже в этой истории.';

  @override
  String get storyShare => 'Поделиться';

  @override
  String get storySaveToPhotos => 'Сохранить в Фото';

  @override
  String get storySaved => 'Сохранено в фото.';

  @override
  String get storySaveDenied =>
      'LifeThreads не может добавлять в твои фото. Разреши это в настройках телефона.';

  @override
  String storyExportFailed(String error) {
    return 'Не удалось создать историю: $error';
  }

  @override
  String get storyRenderingTitle => 'Создаём фильм';

  @override
  String get storyRenderingBody =>
      'Не закрывай LifeThreads — это займёт несколько секунд.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent %';
  }

  @override
  String get storyPreviewFree =>
      'Предпросмотр бесплатный. Делиться историями и сохранять их можно с Premium.';

  @override
  String get benefitStoriesTitle => 'Создать историю';

  @override
  String get benefitStoriesBody =>
      'Превращай воспоминания в картинки и короткие фильмы с музыкой для Instagram, WhatsApp и не только.';

  @override
  String get musicCreditsTitle => 'Авторы музыки';

  @override
  String get musicCreditsBody => 'Песни для видео-историй и их лицензии.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'Твой год в коротком фильме: важные моменты по порядку и с музыкой.';

  @override
  String get benefitFamilyTitle => 'Семейные стены';

  @override
  String get benefitFamilyBody =>
      'Общая стена для семьи со сквозным шифрованием. Каждый добавляет свои моменты.';

  @override
  String get myWall => 'Моя стена';

  @override
  String get myWallSubtitle => 'Личная, на этом устройстве';

  @override
  String get switchWall => 'Сменить стену';

  @override
  String get familyWallsTitle => 'Семейные стены';

  @override
  String get familyWallsSettingsBody =>
      'Делись одной стеной с семьёй или друзьями: все добавляют воспоминания, со сквозным шифрованием. «Моя стена» остаётся личной на этом устройстве.';

  @override
  String get familyWallsOpen => 'Открыть семейные стены';

  @override
  String get familyWallsManage => 'Управлять семейными стенами';

  @override
  String get familyWallsHeadline => 'Одна стена на всю семью';

  @override
  String get familyWallsIntro =>
      'Семейной стеной пользуются те, кого ты пригласишь. Воспоминания и фото шифруются на твоём телефоне до загрузки, открыть их могут только участники. «Моя стена» не публикуется и остаётся на этом устройстве.';

  @override
  String get familyUnavailableTitle => 'Пока недоступно';

  @override
  String get familyUnavailable =>
      'В этой версии LifeThreads семейных стен пока нет.';

  @override
  String get familySignInNeededTitle =>
      'Войди, чтобы пользоваться семейными стенами';

  @override
  String get familySignInNeededBody =>
      'Для общей стены нужен аккаунт, чтобы семья знала, кто что добавил. «Моя стена» работает без него.';

  @override
  String get familySignIn => 'Войти';

  @override
  String get familyLoadFailed => 'Не удалось загрузить';

  @override
  String get familyRetry => 'Повторить';

  @override
  String get familyNoWallsYet =>
      'Семейных стен пока нет. Создай свою или присоединись по ссылке-приглашению.';

  @override
  String get familyStartTitle => 'Создать или присоединиться';

  @override
  String get familyStartBody =>
      'Чтобы создать семейную стену, нужен Premium. Присоединиться можно бесплатно: Premium владельца действует на всю семью.';

  @override
  String get familyCreateAction => 'Создать семейную стену';

  @override
  String get familyCreateTitle => 'Новая семейная стена';

  @override
  String get familyNameLabel => 'Название стены';

  @override
  String get familyNameHint => 'напр. Ивановы';

  @override
  String get familyMyNameLabel => 'Твоё имя на этой стене';

  @override
  String get familyMyNameHelper =>
      'Участники видят его на твоих воспоминаниях. Оно зашифровано, как и всё на стене.';

  @override
  String get familyMyNameSaved => 'Имя сохранено.';

  @override
  String get familySetMyName => 'Моё имя';

  @override
  String get familyCheckingSubscription => 'Проверяем Premium…';

  @override
  String get familyCreating => 'Создаём стену…';

  @override
  String get familyJoinWithLink => 'Войти по ссылке';

  @override
  String get familyInviteLinkLabel => 'Ссылка-приглашение';

  @override
  String get familyJoinTitle => 'Присоединиться к этой семейной стене?';

  @override
  String get familyJoinBody =>
      'Участники увидят твоё имя и воспоминания, которые ты добавишь, а ты — их. Выйти можно в любой момент.';

  @override
  String get familyJoinAction => 'Присоединиться';

  @override
  String get familyJoining => 'Присоединяемся…';

  @override
  String familyJoined(String family) {
    return 'Ты присоединился к «$family».';
  }

  @override
  String get familyRoleOwner => 'Владелец';

  @override
  String get familyRoleMember => 'Участник';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участника',
      many: '$count участников',
      few: '$count участника',
      one: '$count участник',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'Настройки стены';

  @override
  String familyStorageUsed(String used, String total) {
    return 'Занято $used из $total';
  }

  @override
  String get familyRename => 'Переименовать';

  @override
  String get familyInviteTitle => 'Пригласить';

  @override
  String get familyInviteBody =>
      'Отправь ссылку тому, кому доверяешь. Каждая ссылка работает один раз и истекает через 7 дней.';

  @override
  String get familyInviteAction => 'Создать ссылку-приглашение';

  @override
  String get familyCreatingInvite => 'Создаём приглашение…';

  @override
  String get familyInviteReady => 'Ссылка-приглашение готова';

  @override
  String get familyInviteValidity =>
      'Работает один раз и истекает не позже чем через 7 дней.';

  @override
  String get familyInviteKeyWarning =>
      'В ссылке — ключ от стены: любой, кто её откроет, сможет присоединиться и читать стену. Отправляй её только тому, кого приглашаешь.';

  @override
  String get familyInviteShare => 'Поделиться ссылкой';

  @override
  String get familyInviteCopy => 'Копировать ссылку';

  @override
  String get familyInviteCopied => 'Ссылка скопирована.';

  @override
  String get familyInviteShareFailed => 'Поделиться нельзя. Скопируй ссылку.';

  @override
  String familyInviteSubject(String family) {
    return 'Присоединяйся к «$family» в LifeThreads';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'Присоединяйся к нашей семейной стене «$family» в LifeThreads: $link';
  }

  @override
  String get familyMembersTitle => 'Участники';

  @override
  String get familyMemberActions => 'Действия с участником';

  @override
  String get familyYou => 'Ты';

  @override
  String familyYouNamed(String name) {
    return '$name (ты)';
  }

  @override
  String get familyAMember => 'Участник';

  @override
  String get familyFormerMember => 'Бывший участник';

  @override
  String get familyBlocked => 'Заблокирован';

  @override
  String get familyBlock => 'Заблокировать';

  @override
  String get familyUnblock => 'Разблокировать';

  @override
  String familyBlockAuthor(String name) {
    return 'Заблокировать: $name';
  }

  @override
  String familyBlockQuestion(String name) {
    return 'Заблокировать: $name?';
  }

  @override
  String get familyBlockBody =>
      'Ты больше не увидишь воспоминаний этого человека ни на одной семейной стене. Ему не сообщат. Разблокировать можно в списке участников.';

  @override
  String get familyReport => 'Пожаловаться';

  @override
  String get familyRemoveMember => 'Убрать со стены';

  @override
  String familyRemoveQuestion(String name) {
    return 'Убрать: $name?';
  }

  @override
  String get familyRemoveBody =>
      'Человек потеряет доступ к этой стене. Чтобы вернуть его, пригласи снова.';

  @override
  String get familyRemoveDeleteContent =>
      'Также удалить добавленные им воспоминания';

  @override
  String get familyDeleteTitle => 'Удалить семейную стену';

  @override
  String get familyDeleteBody =>
      'Владелец не может выйти со стены, но может удалить её для всех.';

  @override
  String get familyDeleteAction => 'Удалить стену';

  @override
  String familyDeleteQuestion(String family) {
    return 'Удалить «$family»?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'Все воспоминания и фото на этой стене будут удалены с наших серверов для всех участников. Это нельзя отменить. Воспоминания на «Моей стене» не затронуты.';

  @override
  String get familyDeleting => 'Удаляем…';

  @override
  String get familyLeaveTitle => 'Выйти из семейной стены';

  @override
  String get familyLeaveBody =>
      'Ты больше не будешь видеть эту стену. Свои воспоминания можно оставить или удалить.';

  @override
  String get familyLeaveAction => 'Выйти';

  @override
  String familyLeaveQuestion(String family) {
    return 'Выйти из «$family»?';
  }

  @override
  String get familyLeaveConfirmBody =>
      'Чтобы вернуться, понадобится новое приглашение.';

  @override
  String get familyLeaveDeleteMine => 'Также удалить мои воспоминания';

  @override
  String get familyLeaving => 'Выходим…';

  @override
  String get familySignInTitle => 'Вход';

  @override
  String get familySignInHeadline => 'Аккаунт для семейных стен';

  @override
  String get familySignInWhy =>
      'Семейная стена общая, поэтому нужен аккаунт: участники видят, кто добавил каждое воспоминание, и только участники могут открыть стену.';

  @override
  String get familySignInMyWallStays =>
      '«Моей стене» аккаунт не нужен. Она остаётся личной на этом устройстве и никуда не загружается.';

  @override
  String get familySignInEncrypted =>
      'Семейные воспоминания и фото защищены сквозным шифрованием. GK Coding их хранит, но прочитать не может.';

  @override
  String get familySignInWhatWeGet =>
      'От Apple или Google мы берём только ID аккаунта — не контакты и не фото.';

  @override
  String get familySignInApple => 'Войти через Apple';

  @override
  String get familySignInGoogle => 'Войти через Google';

  @override
  String get familySignInFinePrint =>
      'Входя, ты принимаешь Условия использования и Политику конфиденциальности. Удалить аккаунт можно в приложении в любой момент.';

  @override
  String get familyAccountTitle => 'Аккаунт';

  @override
  String get familySignedOutTitle => 'Вход не выполнен';

  @override
  String get familySignedOutBody =>
      'Войди, чтобы видеть свои семейные стены. «Моя стена» работает без аккаунта.';

  @override
  String get familySignedInTitle => 'Вход выполнен';

  @override
  String get familySignedInBody =>
      'Аккаунт используется только для семейных стен.';

  @override
  String familyAccountId(String id) {
    return 'ID аккаунта: $id';
  }

  @override
  String get familySignOut => 'Выйти из аккаунта';

  @override
  String get familySignOutQuestion => 'Выйти из аккаунта?';

  @override
  String get familySignOutBody =>
      'Семейные стены и их ключи будут убраны с этого устройства до следующего входа. На сервере ничего не удаляется. «Моя стена» не затронута.';

  @override
  String get familySigningOut => 'Выходим…';

  @override
  String get familyDeleteAccountTitle => 'Удалить аккаунт';

  @override
  String get familyDeleteAccountBody =>
      'Удаляет твой аккаунт и данные семейных стен с наших серверов. «Моя стена» остаётся на этом устройстве.';

  @override
  String get familyDeleteAccount => 'Удалить аккаунт';

  @override
  String get familyDeleteAccountQuestion => 'Удалить аккаунт?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Твои семейные стены ($count) будут удалены для всех участников вместе со всеми воспоминаниями и фото.',
      many:
          'Твои семейные стены ($count) будут удалены для всех участников вместе со всеми воспоминаниями и фото.',
      few:
          'Твои семейные стены ($count) будут удалены для всех участников вместе со всеми воспоминаниями и фото.',
      one:
          'Твои семейные стены ($count) будут удалены для всех участников вместе со всеми воспоминаниями и фото.',
      zero: 'У тебя нет своих семейных стен.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'Воспоминания и фото, которые ты добавил на стены других семей, будут удалены, и ты выйдешь с этих стен.';

  @override
  String get familyDeleteAccountKeys =>
      'Ключи семейных стен и сохранённые фото будут удалены с этого устройства. Это нельзя отменить.';

  @override
  String get familyDeleteAccountMyWall =>
      '«Моя стена» не затронута: её воспоминания остаются на этом устройстве.';

  @override
  String get familyDeleteAccountSubscription =>
      'Подписка Premium при этом не отменяется — управляй ею в App Store или Google Play.';

  @override
  String get familyDeleteAccountUnderstood =>
      'Я понимаю, что аккаунт будет удалён навсегда.';

  @override
  String get familyDeletingAccount => 'Удаляем аккаунт…';

  @override
  String get familyAccountDeleted => 'Аккаунт удалён.';

  @override
  String get familyTermsTitle => 'Правила семейной стены';

  @override
  String get familyTermsHeadline => 'Прежде чем делиться';

  @override
  String get familyTermsIntro =>
      'Семейные стены — для тех, кого ты пригласишь. Чтобы они оставались безопасными, все принимают эти правила:';

  @override
  String get familyTermsZeroTolerance =>
      'Нулевая терпимость к недопустимому: никаких оскорблений и травли, ненависти, сексуального контента, насилия, самоповреждения, незаконного контента и чужих личных данных без согласия.';

  @override
  String get familyTermsOwnContent =>
      'Делись только теми фото и историями, которыми имеешь право делиться.';

  @override
  String get familyTermsReport =>
      'Пожаловаться можно на любое воспоминание или участника прямо со стены. GK Coding проверяет жалобы в течение 24 часов.';

  @override
  String get familyTermsBlock =>
      'Заблокируй участника, чтобы не видеть его воспоминаний.';

  @override
  String get familyTermsOwner =>
      'Владелец стены может убрать участников и их воспоминания.';

  @override
  String get familyTermsConsequences =>
      'Контент, нарушающий правила, удаляется, а аккаунты, которые его опубликовали, могут быть заблокированы или удалены.';

  @override
  String get familyTermsReadFull => 'Читать условия полностью';

  @override
  String get familyTermsAgree =>
      'Я принимаю Условия использования и эти правила.';

  @override
  String get familyTermsAccept => 'Принять и продолжить';

  @override
  String familyTermsVersion(String version) {
    return 'Версия условий $version';
  }

  @override
  String get familyWallEmptyTitle => 'Стена ждёт';

  @override
  String get familyWallEmptyBody =>
      'Добавь первое воспоминание. Его увидят все на этой стене.';

  @override
  String get familyWallGoneBody =>
      'Эта семейная стена тебе больше недоступна. Возможно, её удалили или тебя убрали.';

  @override
  String get familyAddMemory => 'Добавить воспоминание';

  @override
  String get familyRefresh => 'Обновить';

  @override
  String get familySyncing => 'Синхронизация…';

  @override
  String get familyOffline => 'Офлайн: показаны сохранённые воспоминания';

  @override
  String get familySyncFailed => 'Ошибка синхронизации';

  @override
  String get familyMemoryTitle => 'Воспоминание';

  @override
  String get familyMemoryGone => 'Этого воспоминания больше нет на стене.';

  @override
  String get familyMemoryActions => 'Действия с воспоминанием';

  @override
  String familyAddedBy(String name) {
    return 'Добавил(а): $name';
  }

  @override
  String get familyDeleteMemoryQuestion => 'Удалить это воспоминание?';

  @override
  String get familyDeleteMemoryBody =>
      'Оно исчезнет со стены у всех вместе с фото.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'Как владелец ты можешь убирать воспоминания с этой стены. Это воспоминание ($name) будет удалено у всех вместе с фото.';
  }

  @override
  String get familyDeletingMemory => 'Удаляем воспоминание…';

  @override
  String get familyNoPhotosYet => 'Фото пока нет';

  @override
  String get familyPostNote =>
      'Это воспоминание увидят все на стене. Фото уменьшаются и шифруются на твоём телефоне перед загрузкой.';

  @override
  String get familyPost => 'Опубликовать';

  @override
  String get familyPostMemory => 'Опубликовать на стене';

  @override
  String get familyUploading => 'Шифруем и загружаем…';

  @override
  String get familyMemorySaved => 'Сохранено на семейной стене.';

  @override
  String get familyConflictTitle => 'Изменено кем-то другим';

  @override
  String get familyConflictBody =>
      'Пока ты редактировал, это воспоминание изменили на другом устройстве. Загрузить последнюю версию и сохранить твои изменения поверх?';

  @override
  String get familyConflictRetry => 'Обновить и сохранить';

  @override
  String get familyQuotaTitle => 'Стена заполнена';

  @override
  String get familyReportMemoryTitle => 'Пожаловаться на воспоминание';

  @override
  String get familyReportPhotoTitle => 'Пожаловаться на фото';

  @override
  String get familyReportMemberTitle => 'Пожаловаться на участника';

  @override
  String get familyReportIntro =>
      'Расскажи, что не так. Жалоба уходит в GK Coding, а не тому, на кого ты жалуешься.';

  @override
  String get familyReportSpam => 'Спам или мошенничество';

  @override
  String get familyReportHarassment => 'Оскорбления или травля';

  @override
  String get familyReportHate => 'Язык вражды';

  @override
  String get familyReportSexual => 'Сексуальный контент или нагота';

  @override
  String get familyReportViolence => 'Насилие или угрозы';

  @override
  String get familyReportSelfHarm => 'Самоповреждение или суицид';

  @override
  String get familyReportIllegal => 'Незаконный контент';

  @override
  String get familyReportPrivacy => 'Личные данные без согласия';

  @override
  String get familyReportOther => 'Другое';

  @override
  String get familyReportDetailsLabel => 'Подробности (необязательно)';

  @override
  String get familyReportDetailsHint => 'Что нам стоит знать?';

  @override
  String familyReportAlsoBlock(String name) {
    return 'Также заблокировать: $name';
  }

  @override
  String get familyReportSend => 'Отправить жалобу';

  @override
  String get familyReportReviewNote =>
      'GK Coding проверяет каждую жалобу в течение 24 часов и удаляет контент и участников, нарушающих правила.';

  @override
  String get familyReportSentTitle => 'Спасибо';

  @override
  String get familyReportSentBody =>
      'Жалоба отправлена. GK Coding проверит её в течение 24 часов и примет меры против контента, нарушающего правила.';

  @override
  String get familyErrorGeneric => 'Что-то пошло не так. Попробуй ещё раз.';

  @override
  String get familyErrorOffline =>
      'Похоже, ты офлайн. Проверь соединение и попробуй снова.';

  @override
  String get familyErrorSubscriptionRequired =>
      'Нужна активная подписка Premium у владельца стены.';

  @override
  String get familyErrorInviteExpired =>
      'Срок приглашения истёк. Попроси новую ссылку.';

  @override
  String get familyErrorInviteUsed =>
      'Это приглашение уже использовано. Каждая ссылка работает один раз — попроси новую.';

  @override
  String get familyErrorInviteInvalid =>
      'Это не действующая ссылка-приглашение LifeThreads.';

  @override
  String get familyErrorAlreadyMember => 'Ты уже участник этой семейной стены.';

  @override
  String get familyErrorFamilyFull =>
      'На этой семейной стене достигнут лимит участников.';

  @override
  String get familyErrorQuotaExceeded =>
      'На этой семейной стене закончилось место. Удали часть воспоминаний или фото.';

  @override
  String get familyErrorVersionConflict =>
      'Кто-то изменил это воспоминание раньше. Обнови и попробуй снова.';

  @override
  String get familyErrorTermsRequired =>
      'Сначала прими правила семейной стены.';

  @override
  String get familyErrorSignedOut => 'Ты вышел из аккаунта. Войди снова.';

  @override
  String get familyErrorNotAllowed => 'На этой стене тебе нельзя это делать.';

  @override
  String get familyErrorNotFound => 'Семейная стена не найдена';

  @override
  String get familyErrorOwnerCannotLeave =>
      'Владелец не может выйти со стены, но может её удалить.';

  @override
  String get familyPaste => 'Вставить';

  @override
  String get familyErrorInviteRevoked =>
      'Это приглашение отозвано. Попроси новую ссылку.';

  @override
  String get familyErrorKeyMissing =>
      'На этом устройстве нет ключа от этой семейной стены (например, после переустановки или на новом телефоне). Попроси у участника новую ссылку-приглашение — открыв её, ты вернёшь доступ.';

  @override
  String get familyErrorSignInUnavailable =>
      'Вход на этом устройстве сейчас недоступен.';

  @override
  String get familyErrorNoPurchase =>
      'Для этого аккаунта App Store или Google Play не найдено покупки Premium. Сначала оформи Premium, потом попробуй снова.';

  @override
  String get familyErrorVerificationUnavailable =>
      'Сейчас не удаётся проверить твой Premium. Попробуй позже.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'Эта покупка Premium уже привязана к другому аккаунту семейной стены. Войди в тот аккаунт или напиши на info@gkcoding.dev.';

  @override
  String get familyErrorNameTooLong => 'Слишком длинное имя. Выбери покороче.';

  @override
  String get familyErrorContentNotAllowed =>
      'Здесь есть слова, запрещённые на семейных стенах. Измени текст и попробуй снова.';

  @override
  String get familyErrorPhotoUnreadable =>
      'Не удалось прочитать одно из фото. Убери его и попробуй снова.';

  @override
  String get familyErrorTooLarge =>
      'Слишком большой объём для загрузки. Попробуй меньше фото или фото поменьше.';

  @override
  String get familyReportEvidenceNote =>
      'Для проверки GK Coding получает вместе с жалобой название и историю этого воспоминания. Фото никогда не отправляются.';

  @override
  String get moveLeft => 'Сдвинуть влево';

  @override
  String get moveUp => 'Сдвинуть вверх';

  @override
  String get moveDown => 'Сдвинуть вниз';

  @override
  String get moveRight => 'Сдвинуть вправо';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get removePerson => 'Убрать человека';

  @override
  String get draftKept =>
      'Сохранено как черновик — в следующий раз будет здесь.';

  @override
  String get draftResumeTitle => 'Продолжить с того же места?';

  @override
  String draftResumeBody(String date) {
    return 'Ты начал воспоминание $date и ещё не сохранил его.';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фото',
      many: '$count фото',
      few: '$count фото',
      one: '$count фото',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => 'Продолжить черновик';

  @override
  String get draftStartNew => 'Начать заново';

  @override
  String get lookBackMenu => 'Оглянуться на месяц';

  @override
  String lookBackTitle(String month) {
    return 'Твой месяц: $month';
  }

  @override
  String get lookBackWallCardTitle => 'Твой месяц в воспоминаниях';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count воспоминания',
      many: '$count воспоминаний',
      few: '$count воспоминания',
      one: '$count воспоминание',
    );
    return '$month: $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count воспоминания',
      many: '$count воспоминаний',
      few: '$count воспоминания',
      one: '$count воспоминание',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count человека',
      many: '$count человек',
      few: '$count человека',
      one: '$count человек',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count места',
      many: '$count мест',
      few: '$count места',
      one: '$count место',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => 'Кто был рядом';

  @override
  String get lookBackPlacesHeading => 'Где ты был';

  @override
  String lookBackEmpty(String month) {
    return 'За $month пока ничего не сохранено.';
  }

  @override
  String get lookBackEmptyHint =>
      'Здесь появятся воспоминания с датами этого месяца.';

  @override
  String get lookBackPreviousMonth => 'Предыдущий месяц';

  @override
  String get lookBackNextMonth => 'Следующий месяц';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count воспоминания',
      many: '$count воспоминаний',
      few: '$count воспоминания',
      one: '$count воспоминание',
    );
    return '$month: $_temp0 — время оглянуться.';
  }

  @override
  String get lookBackNotificationPrivate => 'Твой месяц в воспоминаниях готов.';

  @override
  String get homeWidgetLocked =>
      'Открой LifeThreads, чтобы увидеть воспоминания.';

  @override
  String get homeWidgetSettingsTitle => 'Виджет на экране «Домой»';

  @override
  String get homeWidgetSettingsSubtitle => 'Какие воспоминания показывать';

  @override
  String get homeWidgetPreviewTitle => 'Сегодня в виджете';

  @override
  String get homeWidgetSourceTitle => 'Какие воспоминания';

  @override
  String get homeWidgetAllWalls => 'Все мои стены';

  @override
  String get homeWidgetOrderTitle => 'Сначала показывать';

  @override
  String get homeWidgetOnThisDayFirst => 'Сначала «В этот день»';

  @override
  String get homeWidgetOnThisDayFirstBody =>
      'Первым идёт воспоминание этого дня из прошлых лет.';

  @override
  String get homeWidgetPhotosFirst => 'Сначала воспоминания с фото';

  @override
  String get homeWidgetPhotosFirstBody =>
      'Остальные — только если ни у одного нет фото.';

  @override
  String get homeWidgetHowToTitle => 'Добавь его на экран «Домой»';

  @override
  String get homeWidgetHowToIos =>
      'Удерживай значок LifeThreads на экране «Домой» и выбери размер виджета. Или удерживай пустое место, нажми Изменить › Добавить виджет и выбери LifeThreads.';

  @override
  String get homeWidgetHowToAndroid =>
      'Удерживай пустое место на главном экране, нажми «Виджеты» и перетащи LifeThreads куда хочешь.';

  @override
  String get homeWidgetPrivacyNote =>
      'Скрытые воспоминания никогда не появляются в виджете. При включённой блокировке он не показывает ни одного воспоминания.';

  @override
  String get yearThreadAlmostThere => 'Почти готово';

  @override
  String get yearThreadMemoriesFrom => 'Воспоминания за';

  @override
  String yearThreadAddMemoryTo(String year) {
    return 'Добавь воспоминание за $year';
  }

  @override
  String get onboardingHangTitle => 'Вешай свои воспоминания';

  @override
  String get onboardingHangText =>
      'Фото, место, люди, которые были рядом, — стена растёт вместе с твоей жизнью.';

  @override
  String get onboardingConnectTitle => 'Связывай их нитями';

  @override
  String get onboardingConnectText =>
      'Скажи, почему два момента вместе. Нити покажут, как складывается твоя история.';

  @override
  String get onboardingComeBackTitle => 'Воспоминания возвращаются';

  @override
  String get onboardingComeBackText =>
      '«В этот день», месяц в воспоминаниях, год в фильме — и виджет на экране «Домой».';

  @override
  String get onboardingPrivateText =>
      'Без аккаунта. Всё остаётся на телефоне — по желанию с Face ID.';

  @override
  String get onboardingNameStaysHere =>
      'Только чтобы здороваться — остаётся на этом телефоне.';

  @override
  String get tutorialLookBackTitle => 'Ищи и оглядывайся';

  @override
  String get tutorialLookBackText =>
      'Ищи по названию, месту, человеку или году. Ещё › Оглянуться на месяц показывает воспоминания месяца; Ещё › Нить года превращает год в фильм.';

  @override
  String get tutorialStoryTitle => 'Создай историю';

  @override
  String get tutorialStoryText =>
      'Ещё › Создать историю: выбери воспоминания, шаблон и музыку, затем поделись картинкой или видео.';

  @override
  String get tutorialWallsTitle => 'Стены и скрытые воспоминания';

  @override
  String get tutorialWallsText =>
      'Ещё › Новая стена разделяет поездки или главы жизни (Premium). Удерживай карточку › Скрыть, чтобы убрать её с глаз; Вид › Скрытые воспоминания покажет её после Face ID.';

  @override
  String get tutorialFamilyTitle => 'Делись с семьёй';

  @override
  String get tutorialFamilyText =>
      'Ещё › Семейные стены: одна стена на всю семью со сквозным шифрованием. Приглашай других по ссылке.';

  @override
  String get tutorialWidgetTitle => 'Воспоминание на экране «Домой»';

  @override
  String get tutorialWidgetText =>
      'Добавь виджет LifeThreads: каждый день новое воспоминание. В Настройки › Виджет на экране «Домой» выбери, какие.';

  @override
  String photoNumber(int number) {
    return 'Фото $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'Не удалось сохранить твоё имя на этой стене. Его можно задать в настройках стены.';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'В ней $count воспоминания.',
      many: 'В ней $count воспоминаний.',
      few: 'В ней $count воспоминания.',
      one: 'В ней $count воспоминание.',
    );
    return '$_temp0 Воспоминания, которые уже есть на твоих стенах, сохранятся и не задвоятся.';
  }

  @override
  String get importAction => 'Импортировать';

  @override
  String get familyRemovingMember => 'Убираем и защищаем стену…';

  @override
  String get tourSkip => 'Пропустить';

  @override
  String get tourNext => 'Далее';

  @override
  String get tourDone => 'Готово';

  @override
  String get tourTapIt => 'Нажми';

  @override
  String get tourEnd => 'Завершить тур';

  @override
  String get tourShowMeHow => 'Покажи, как';

  @override
  String get tourShowMeHowSubtitle => 'Короткий тур с примерами воспоминаний';

  @override
  String get tourWelcomeTitle => 'Добро пожаловать на твою стену';

  @override
  String get tourWelcomeBody =>
      'Давай вместе пройдёмся по LifeThreads на примерах воспоминаний и фото. Следуй за золотым кольцом. В конце решишь, оставить ли их.';

  @override
  String get tourCardTitle => 'Каждая карточка — воспоминание';

  @override
  String get tourCardBody =>
      'Фото, история, место и чувства. Перетаскивай карточки, чтобы расставить их, разводи пальцы для зума. Нажми на эту, чтобы открыть.';

  @override
  String get tourConnectTitle => 'Связывай воспоминания';

  @override
  String get tourConnectBody =>
      'Нити соединяют моменты: поездку с человеком, место с чувством. Нажми «Связать».';

  @override
  String get tourConnectionsTitle => 'Выбери, что связано';

  @override
  String get tourConnectionsBody =>
      'Выбери другие воспоминания и напиши, почему они вместе. Тогда нить протянется между карточками на стене.';

  @override
  String get tourAddTitle => 'Сохрани новый момент';

  @override
  String get tourAddBody => 'Нажми +, чтобы добавить что-то на стену.';

  @override
  String get tourAddMemoryTitle => 'Воспоминание';

  @override
  String get tourAddMemoryBody =>
      'Выбери «Воспоминание». Можно также прикрепить заметку или гвоздик, чтобы сгруппировать карточки.';

  @override
  String get tourAddTextTitle => 'Хватит пары слов';

  @override
  String get tourAddTextBody =>
      'Мы добавили для тебя пример фото и название. Обычно ты выбираешь свои фото или делаешь новое. Дата и место берутся из фото.';

  @override
  String get tourSaveTitle => 'Повесь на стену';

  @override
  String get tourSaveBody =>
      'Нажми «Сохранить». Чувства, люди и нити могут подождать.';

  @override
  String get tourCameraTitle => 'Быстрое фото';

  @override
  String get tourCameraBody =>
      'Камера сохраняет момент сразу. Слова добавишь потом.';

  @override
  String get tourViewTitle => 'Разные виды';

  @override
  String get tourViewBody => 'Нажми «Вид».';

  @override
  String get tourViewModesTitle => 'Стена, хронология, карта';

  @override
  String get tourViewModesBody =>
      'Смотри на свою жизнь как на стену, хронологию или карту. Здесь можно фильтровать по категориям и показывать скрытые воспоминания (с Face ID).';

  @override
  String get tourViewDoneTitle => 'Назад к стене';

  @override
  String get tourViewDoneBody => 'Нажми «Готово».';

  @override
  String get tourSearchTitle => 'Найди любое воспоминание';

  @override
  String get tourSearchBody =>
      'Введи здесь имя, место, человека или год. Результаты появляются по мере ввода.';

  @override
  String get tourMoreTitle => 'Всё остальное';

  @override
  String get tourMoreBody =>
      'Истории, твой год, взгляд назад, другие стены и настройки — в этом меню. Нажми его.';

  @override
  String get tourStoryTitle => 'Создай историю';

  @override
  String get tourStoryBody => 'Нажми «Создать историю».';

  @override
  String get tourYearTitle => 'Нить года';

  @override
  String get tourYearBody =>
      'Твой год — короткий фильм с музыкой: воспоминания по порядку, а затем места, люди и чувства года (Premium).';

  @override
  String get tourLookBackTitle => 'Оглянуться на месяц';

  @override
  String get tourLookBackBody =>
      'Каждый месяц в воспоминаниях — с людьми и местами. «В этот день» напоминает о прошлых годах (Premium).';

  @override
  String get tourWallsTitle => 'Больше стен';

  @override
  String get tourWallsBody =>
      'По стене на каждого ребёнка, поездку или проект (Premium). Нажми на название вверху, чтобы сменить стену.';

  @override
  String get tourFamilyTitle => 'Семейные стены';

  @override
  String get tourFamilyBody =>
      'Общая стена, куда каждый добавляет свои моменты, со сквозным шифрованием. Premium нужен только создателю — семья присоединяется бесплатно.';

  @override
  String get tourSettingsTitle => 'Настройки';

  @override
  String get tourSettingsBody =>
      'Бесплатно сохраняй всё в резервную копию, блокируй приложение по Face ID, настрой виджет и «В этот день» и выбери язык.';

  @override
  String get tourFinishTitle => 'Вот и всё!';

  @override
  String get tourFinishBody => 'Теперь ты всё знаешь. Сделай эту стену своей.';

  @override
  String get tourDemoPhotoTitle => 'День у озера';

  @override
  String get tourRemoveDemoTitle => 'Начать свою стену?';

  @override
  String get tourRemoveDemoBody =>
      'В туре были примеры воспоминаний и фото. Убрать их сейчас и начать со своих фото?';

  @override
  String get tourRemoveDemoRemove => 'Убрать и начать';

  @override
  String get tourRemoveDemoKeep => 'Пока оставить';

  @override
  String get tourRemovedToast => 'Примеры убраны. Твоя стена готова.';

  @override
  String get storyTemplatePolaroid => 'Полароид';

  @override
  String get storyTemplateAlbum => 'Альбом';

  @override
  String get storyTemplateFilmstrip => 'Плёнка';

  @override
  String get storyTemplateTimeline => 'Машина времени';

  @override
  String get storyTemplatePostcard => 'Открытка';

  @override
  String get storyTemplateCinema => 'Кино';

  @override
  String get storyTemplateSingleHint =>
      'Каждое воспоминание на весь экран, одно за другим';

  @override
  String get storyTemplateThreadHint => 'Карточки на стене, связанные нитью';

  @override
  String get storyTemplateCollageHint => 'Все фото вместе в сетке';

  @override
  String get storyTemplateQuoteHint => 'Твои слова печатаются сами';

  @override
  String get storyTemplatePolaroidHint => 'Моментальные снимки падают в стопку';

  @override
  String get storyTemplateAlbumHint =>
      'Страницы листаются, по фото на страницу';

  @override
  String get storyTemplateFilmstripHint => 'Плёнка бежит и приближается';

  @override
  String get storyTemplateTimelineHint =>
      'Годы отсчитываются до каждого воспоминания';

  @override
  String get storyTemplatePostcardHint =>
      'Каждая открытка переворачивается к своей истории';

  @override
  String get storyTemplateCinemaHint =>
      'Титры, медленный зум и финальные титры';

  @override
  String get storyAnimationTitle => 'Анимация';

  @override
  String get storyAnimationPageTitle => 'Выбери анимацию';

  @override
  String get storyAnimationExamples =>
      'Показано на примерах фото. В твоей истории будут твои воспоминания.';

  @override
  String get storyMusicPageTitle => 'Музыка и длительность';

  @override
  String get storyLengthTitle => 'Длительность';

  @override
  String get storyLengthAuto => 'Авто';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds с';
  }

  @override
  String get storyMusicAll => 'Все';

  @override
  String get storyMusicPlay => 'Воспроизвести';

  @override
  String get storyMusicPause => 'Пауза';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return 'Песня $song ▸ Видео $video';
  }

  @override
  String get storyMusicSyncHint =>
      'Белая линия показывает, какая секунда песни звучит вместе с видео. Метки — начало каждого воспоминания.';

  @override
  String get storyMusicLengthHint =>
      '«Авто» подстраивается под число воспоминаний. Чем длиннее фильм, тем медленнее движение.';

  @override
  String get tourBack => 'Назад';

  @override
  String get tourStoryPickTitle => 'Выбери воспоминания';

  @override
  String get tourStoryPickBody =>
      'Мы выбрали три для тебя. Можно выбрать до шести. Нажми «Продолжить».';

  @override
  String get tourStoryAnimationTitle => 'Выбери движение';

  @override
  String get tourStoryAnimationBody =>
      'Анимации от «Полароида» до «Кино». Нажми «Анимация».';

  @override
  String get tourStoryStyleTitle => 'Попробуй «Полароид»';

  @override
  String get tourStoryStyleBody =>
      'Каждая плитка показывает превью. Нажми «Полароид».';

  @override
  String get tourStoryMusicTitle => 'Добавь музыку';

  @override
  String get tourStoryMusicBody =>
      'Выбери песню и длительность видео. Нажми «Музыка».';

  @override
  String get tourStoryTrimTitle => 'Песня и видео синхронно';

  @override
  String get tourStoryTrimBody =>
      'Перетащи золотую рамку, чтобы выбрать часть песни. Белая линия движется вместе с видео, так что видно, какая секунда когда звучит.';

  @override
  String get tourStoryMusicDoneTitle => 'Назад к истории';

  @override
  String get tourStoryMusicDoneBody => 'Нажми «Готово».';

  @override
  String get tourStoryShareTitle => 'Поделись или сохрани';

  @override
  String get tourStoryShareBody =>
      'Готово для Instagram, WhatsApp и не только. Сохранение и отправка — часть Premium.';

  @override
  String get tourMoreAgainTitle => 'Ещё больше в меню';

  @override
  String get tourMoreAgainBody => 'Открой меню ещё раз. Нажми его.';

  @override
  String get scannerStep1 =>
      'На телевизоре, компьютере или планшете открой браузер.';

  @override
  String scannerStep2(Object url) {
    return 'Перейди на $url. Там появится QR-код.';
  }

  @override
  String get scannerStep3 =>
      'Держи телефон так, чтобы код был внутри золотой рамки. Твоя стена появится там на время, только для просмотра.';

  @override
  String get scannerShareLink => 'Отправить ссылку';

  @override
  String get scannerCopyLink => 'Копировать ссылку';

  @override
  String get scannerLinkCopied => 'Ссылка скопирована';

  @override
  String get storyTemplateScrapbook => 'Скрапбук';

  @override
  String get storyTemplateMosaic => 'Мозаика';

  @override
  String get storyTemplateContactSheet => 'Контактный лист';

  @override
  String get storyTemplateWallFlight => 'Полёт по стене';

  @override
  String get storyTemplateCarousel => 'Карусель';

  @override
  String get storyTemplateJourney => 'Путешествие';

  @override
  String get storyTemplateScrapbookHint =>
      'Каждое фото приклеено скотчем к странице';

  @override
  String get storyTemplateMosaicHint => 'Одно большое фото, остальные вокруг';

  @override
  String get storyTemplateContactSheetHint =>
      'Каждое воспоминание — кадр плёнки';

  @override
  String get storyTemplateWallFlightHint =>
      'Летит по нити от карточки к карточке';

  @override
  String get storyTemplateCarouselHint =>
      'Карточки вращаются, по одной выходят вперёд';

  @override
  String get storyTemplateJourneyHint =>
      'Маршрут по карте, булавка в каждом месте';

  @override
  String get storyModePicture => 'Картинка';

  @override
  String get storyModeVideo => 'Видео';

  @override
  String get storyModePictureHint =>
      'Одна картинка со всеми воспоминаниями — для постов и историй.';

  @override
  String get storyModeVideoHint => 'Короткий фильм с движением и музыкой.';

  @override
  String get storyLayoutTitle => 'Макет';

  @override
  String get storyLayoutPageTitle => 'Выбери макет';

  @override
  String get storyChoosePhoto => 'Выбери фото для истории';

  @override
  String get wallTidyUp => 'Навести порядок на стене';

  @override
  String get wallTidyUpBody =>
      'Развесить все карточки ровными рядами, от самого старого воспоминания к новому? Заметки и гвозди останутся на месте.';

  @override
  String get wallTidyUpAction => 'Упорядочить';

  @override
  String get wallTidiedToast => 'На стене порядок.';

  @override
  String get storyFormatTitle => 'Формат';

  @override
  String get storyFormatStory => 'История 9:16';

  @override
  String get storyFormatPost => 'Пост 4:5';

  @override
  String get storyFormatSquare => 'Квадрат 1:1';
}
