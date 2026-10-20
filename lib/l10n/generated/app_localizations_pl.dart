// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get send => 'Wyślij';

  @override
  String get preparing => 'Przygotowuję...';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get languageTitle => 'Język';

  @override
  String get languageBody =>
      'Wybierz język aplikacji. Systemowy używa języka telefonu, jeśli LifeThreads go obsługuje.';

  @override
  String get systemLanguage => 'Systemowy';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return 'Zmieniono język na: $language.';
  }

  @override
  String get privacyTitle => 'Prywatność';

  @override
  String get privacyBody =>
      'LifeThreads działa lokalnie: bez konta i bez publicznego profilu. Twoje wspomnienia zostają na tym urządzeniu, chyba że wyeksportujesz kopię, udostępnisz zaszyfrowaną kapsułę albo pokażesz ścianę na innym ekranie.';

  @override
  String get viewPrivacyPolicy => 'Zobacz politykę prywatności';

  @override
  String get termsTitle => 'Warunki korzystania';

  @override
  String get viewTerms => 'Zobacz warunki';

  @override
  String get betaFeedbackTitle => 'Opinia o becie';

  @override
  String get betaFeedbackBody =>
      'Wyślij opinię o becie z bezpieczną diagnostyką. Logi zawierają tylko zdarzenia aplikacji i typy awarii, nigdy treść wspomnień, ścieżki zdjęć, kopie zapasowe ani dokładne lokalizacje.';

  @override
  String get closedBetaBadge => 'Zamknięta beta';

  @override
  String get sendFeedback => 'Wyślij opinię';

  @override
  String get backupArchiveBody =>
      'Zapisz wszystko – wspomnienia, zdjęcia, notatki, nici i układ – w jednym pliku. Trzymaj go na komputerze lub we własnej chmurze i dodaj hasło, by go zaszyfrować.';

  @override
  String get backupArchiveTitle => 'Kopia zapasowa';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Odblokuj';

  @override
  String get exportArchive => 'Eksportuj archiwum';

  @override
  String get importArchive => 'Importuj archiwum';

  @override
  String get importCapsule => 'Importuj kapsułę';

  @override
  String get moveDevices => 'Zmień urządzenie';

  @override
  String get themeTitle => 'Motyw';

  @override
  String get themeBody =>
      'Wybierz klimat swojej prywatnej ściany. W wersji darmowej jest Ciepły pokój. Premium odblokowuje wszystkie klimaty.';

  @override
  String get oneFreeBadge => '1 za darmo';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'Subskrypcja Premium jest aktywna.';

  @override
  String get premiumLockedBody =>
      'Rocznie lub miesięcznie: bez limitu wspomnień, kilka ścian, historie, motywy i układy.';

  @override
  String get activeBadge => 'Aktywna';

  @override
  String get openPremium => 'Otwórz Premium';

  @override
  String get appVersionTitle => 'Wersja aplikacji';

  @override
  String get clearAllDataTitle => 'Wyczyść wszystkie dane';

  @override
  String get clearAllDataBody =>
      'Usuń z tego urządzenia wszystkie wspomnienia, połączenia, notatki, gwoździki i skopiowane zdjęcia.';

  @override
  String get clearData => 'Wyczyść dane';

  @override
  String exportFailed(Object error) {
    return 'Eksport nieudany: $error';
  }

  @override
  String importRejected(Object message) {
    return 'Import odrzucony: $message';
  }

  @override
  String importFailed(Object error) {
    return 'Import nieudany: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'Usuwanie nieudane: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'Kapsuła odrzucona: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'Nie udało się zaimportować kapsuły: $error';
  }

  @override
  String get clearAllDataQuestion => 'Wyczyścić wszystkie dane?';

  @override
  String get clearAllDataQuestionBody =>
      'To trwale usunie wszystkie lokalne dane LifeThreads z tego urządzenia. Jeśli chcesz je zachować, najpierw wyeksportuj kopię.';

  @override
  String get clearAll => 'Wyczyść wszystko';

  @override
  String get allLocalDataCleared => 'Wyczyszczono wszystkie dane lokalne.';

  @override
  String get feedbackGeneral => 'Ogólna opinia';

  @override
  String get feedbackBug => 'Błąd';

  @override
  String get feedbackCrash => 'Awaria';

  @override
  String get feedbackDesign => 'Problem z wyglądem';

  @override
  String get feedbackMissingFeature => 'Brakująca funkcja';

  @override
  String get feedbackPerformance => 'Wydajność';

  @override
  String get betaFeedbackIntro =>
      'Napisz, co się stało albo co było nie tak. Dołączymy bezpieczną diagnostykę bez prywatnej treści wspomnień.';

  @override
  String get feedbackType => 'Rodzaj';

  @override
  String get feedbackLabel => 'Opinia';

  @override
  String get feedbackHint =>
      'Przykład: stuknąłem Dodaj > Szybkie zdjęcie i ekran się zawiesił.';

  @override
  String get betaFeedbackNotIncluded =>
      'Nie dołączamy: tytułów wspomnień, historii, notatek, ścieżek zdjęć i kopii, dokładnych lokalizacji.';

  @override
  String get feedbackEmpty => 'Najpierw napisz krótką wiadomość.';

  @override
  String get feedbackCopied =>
      'Nie otworzyła się aplikacja poczty. Opinię skopiowano do schowka – wyślij ją na info@gkcoding.dev.';

  @override
  String themeSelected(Object theme) {
    return 'Wybrano: $theme.';
  }

  @override
  String get onboardingHeadline => 'Zbuduj swoją żywą ścianę.';

  @override
  String get onboardingBody =>
      'Prywatny pokój wspomnień, w którym zdjęcia, miejsca, ludzie i małe notatki łączą się nićmi uczuć.';

  @override
  String get onboardingPrivacy =>
      'Twoje wspomnienia są domyślnie prywatne: bez konta i bez publicznego profilu. Szyfrowane udostępnianie w chmurze i kopie zapasowe dzieją się tylko, gdy je wybierzesz.';

  @override
  String get onboardingPrivacyShort =>
      'Bez konta i bez publicznego profilu. Wspomnienia zostają na tym urządzeniu, chyba że zdecydujesz inaczej.';

  @override
  String get onboardingNext => 'Dalej';

  @override
  String get onboardingNameTitle => 'Jak mamy się do ciebie zwracać?';

  @override
  String get onboardingNameHint => 'Twoje imię';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'Miło cię poznać, $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'Wybierz, jak zacząć';

  @override
  String get onboardingGetStartedBody =>
      'Zobacz przykładową ścianę albo zacznij od pustej i zawieś własne wspomnienia.';

  @override
  String get settingsNameTitle => 'Twoje imię';

  @override
  String get settingsNameBody => 'Wyświetla się jako powitanie na ścianie.';

  @override
  String get settingsNameHint => 'Twoje imię';

  @override
  String get settingsNameSaved => 'Imię zaktualizowane.';

  @override
  String get storyPrivacyTitle => 'Wspomnienia zostają prywatne';

  @override
  String get storyConnectTitle => 'Łącz chwile';

  @override
  String get storyConnectText =>
      'Łącz wspomnienia, notatki i miejsca, by każdy rozdział miał kontekst.';

  @override
  String get storyWallTitle => 'Zbuduj swoją żywą ścianę';

  @override
  String get storyWallText =>
      'Zacznij od jednego zdjęcia, a ściana będzie rosnąć, aż nabierze życia.';

  @override
  String get previewDemoWall => 'Zobacz przykład';

  @override
  String get startFresh => 'Zacznij od zera';

  @override
  String get optionalDemoPreview => 'Opcjonalny przykład';

  @override
  String get quickTutorial => 'Szybki samouczek';

  @override
  String get tutorialIntro =>
      'Najpierw podstawy – zapisz, połącz, ułóż – a potem wszystko inne, co potrafi twoja ściana.';

  @override
  String get gotIt => 'Rozumiem';

  @override
  String get howItWorks => 'Jak to działa';

  @override
  String get tutorialAddTitle => 'Dodaj wspomnienie';

  @override
  String get tutorialAddText =>
      'Stuknij +, wybierz Wspomnienie lub Szybkie zdjęcie i zapisz tytuł, datę, osoby i zdjęcie. Jeśli wyjdziesz przed zapisaniem, zostanie szkic.';

  @override
  String get tutorialConnectTitle => 'Łącz wspomnienia';

  @override
  String get tutorialConnectText =>
      'Otwórz kartę, stuknij ikonę łączenia, wybierz powiązane wspomnienia i dodaj krótki powód.';

  @override
  String get tutorialArrangeTitle => 'Ułóż ścianę';

  @override
  String get tutorialArrangeText =>
      'Przeciągaj karty, notatki i gwoździki. Widok › Ułóż sortuje je według daty, kategorii lub miejsca – zatwierdzasz przyciskiem Gotowe.';

  @override
  String get tutorialShowBoardTitle => 'Pokaż tablicę';

  @override
  String get tutorialShowBoardText =>
      'Otwórz lifethreads.gkcoding.dev/display na innym ekranie, wybierz Więcej › Pokaż ścianę i zeskanuj kod, by wyświetlić tymczasową tablicę tylko do odczytu.';

  @override
  String get tutorialBackupTitle => 'Prywatność i kopie';

  @override
  String get tutorialBackupText =>
      'Ustawienia › Prywatność › Blokada aplikacji otwiera LifeThreads przez Face ID. Przed zmianą telefonu wyeksportuj kopię w Ustawienia › Kopia i dane.';

  @override
  String get scanDisplayQr => 'Skanuj kod QR ekranu';

  @override
  String get scannerHintTitle => 'Gdzie jest kod QR?';

  @override
  String get addMemoryBeforeDisplay =>
      'Dodaj wspomnienie, zanim pokażesz ścianę.';

  @override
  String get notLifeThreadsDisplayQr =>
      'To nie jest kod QR ekranu LifeThreads.';

  @override
  String get displayWallQuestion => 'Pokazać tę ścianę?';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads wyśle tymczasowy podgląd tablicy tylko do odczytu (wspomnienia: $memoryCount) do zeskanowanej sesji przeglądarki. Otwiera się na lifethreads.gkcoding.dev/display i wygasa sam.';
  }

  @override
  String get displayAction => 'Pokaż';

  @override
  String get soon => 'wkrótce';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'Ściana jest wyświetlana (wspomnienia: $memoryCount) do $expires.';
  }

  @override
  String get preparingWallDisplay => 'Przygotowuję wyświetlanie ściany...';

  @override
  String get open => 'Otwórz';

  @override
  String get edit => 'Edytuj';

  @override
  String get save => 'Zapisz';

  @override
  String get done => 'Gotowe';

  @override
  String get back => 'Wstecz';

  @override
  String get continueAction => 'Dalej';

  @override
  String get close => 'Zamknij';

  @override
  String get add => 'Dodaj';

  @override
  String get saveReason => 'Zapisz powód';

  @override
  String get chooseBackup => 'Wybierz kopię';

  @override
  String get chooseArchive => 'Wybierz archiwum';

  @override
  String get chooseCapsule => 'Wybierz kapsułę';

  @override
  String get exportAction => 'Eksportuj';

  @override
  String get addToWall => 'Dodaj do ściany';

  @override
  String get cinemaSkip => 'Pomiń';

  @override
  String get cinemaNotNow => 'Nie teraz';

  @override
  String get cinemaSharedChapter => 'Wspólny rozdział wspomnień';

  @override
  String get cinemaConnectedThread => 'Połączona nić';

  @override
  String get cinemaInviteTitle => 'Dodać to wspomnienie do twojej ściany?';

  @override
  String get useSelected => 'Użyj wybranych';

  @override
  String photoGridItem(String date) {
    return 'Zdjęcie z $date';
  }

  @override
  String get noPhotosFound => 'Nie znaleziono zdjęć.';

  @override
  String get manage => 'Zarządzaj';

  @override
  String get manageAccess => 'Zarządzaj dostępem';

  @override
  String get saveNow => 'Zapisz teraz';

  @override
  String get hangOnWall => 'Powieś na ścianie';

  @override
  String get placeHere => 'Umieść tutaj';

  @override
  String get openSettings => 'Otwórz Ustawienia';

  @override
  String get viewPremium => 'Zobacz Premium';

  @override
  String get memoryNotFound => 'Nie znaleziono wspomnienia';

  @override
  String get memoryTypeMoment => 'Chwila';

  @override
  String get memoryTypeTrip => 'Podróż';

  @override
  String get memoryTypePerson => 'Osoba';

  @override
  String get memoryTypePlace => 'Miejsce';

  @override
  String get memoryTypeNote => 'Notatka';

  @override
  String get memoryTypeMomentDescription => 'Mała scena warta zachowania';

  @override
  String get memoryTypeTripDescription => 'Podróż albo dzień poza domem';

  @override
  String get memoryTypePersonDescription => 'Ktoś ważny';

  @override
  String get memoryTypePlaceDescription => 'Miejsce, które coś znaczy';

  @override
  String get memoryTypeNoteDescription => 'Myśl, cytat albo przypomnienie';

  @override
  String get categoryPersonal => 'Osobiste';

  @override
  String get categoryFamily => 'Rodzina';

  @override
  String get categoryTravel => 'Podróże';

  @override
  String get feelingWarm => 'Ciepło';

  @override
  String get feelingNostalgic => 'Nostalgia';

  @override
  String get feelingProud => 'Duma';

  @override
  String get feelingCalm => 'Spokój';

  @override
  String get feelingImportant => 'Ważne';

  @override
  String get feelingWarmDescription => 'Miękko, blisko, z miłością.';

  @override
  String get feelingNostalgicDescription =>
      'Wspomnienie, które przenosi w przeszłość.';

  @override
  String get feelingProudDescription => 'Chwila, która czegoś dowiodła.';

  @override
  String get feelingCalmDescription => 'Cicho, bezpiecznie, spokojnie.';

  @override
  String get feelingImportantDescription =>
      'Wspomnienie, które zmieniło historię.';

  @override
  String get addPeopleHint =>
      'Dodaj osoby z tej chwili. Kontakty zostają na urządzeniu.';

  @override
  String get addPerson => 'Dodaj osobę';

  @override
  String get editPerson => 'Edytuj osobę';

  @override
  String get chooseFromContacts => 'Wybierz z kontaktów';

  @override
  String get personNameLabel => 'Imię';

  @override
  String get personNameHint => 'Pisz, by wyszukać zapisane osoby';

  @override
  String get relationshipLabel => 'Relacja';

  @override
  String get relationshipHint => 'Przyjaciółka, mama, partner...';

  @override
  String get phoneOptionalLabel => 'Telefon (opcjonalnie)';

  @override
  String get emailOptionalLabel => 'E-mail (opcjonalnie)';

  @override
  String get nameRelationshipRequired => 'Imię i relacja są wymagane.';

  @override
  String get contactAccessDenied => 'Nie przyznano dostępu do kontaktów.';

  @override
  String get couldNotOpenContacts => 'Nie udało się otworzyć kontaktów.';

  @override
  String get chooseContact => 'Wybierz kontakt';

  @override
  String get searchContacts => 'Szukaj kontaktów';

  @override
  String get noContactsFound => 'Nie znaleziono kontaktów.';

  @override
  String get unnamedContact => 'Kontakt bez nazwy';

  @override
  String get contactRelationship => 'Kontakt';

  @override
  String get couldNotLoadContacts => 'Nie udało się wczytać kontaktów.';

  @override
  String get saveMomentTitle => 'Zapisz chwilę';

  @override
  String get todayEyebrow => 'Dziś';

  @override
  String get addMemoryStepTitle =>
      'Co się wydarzyło, czego nie chcesz stracić?';

  @override
  String get addMemoryStepSubtitle =>
      'Napisz jedno zdanie, dodaj zdjęcie, jeśli masz, i zapisz. Szczegóły mogą poczekać.';

  @override
  String get momentLabel => 'Chwila';

  @override
  String get momentHint =>
      'Kolacja z Larą, pierwsza premiera, spokojny spacer...';

  @override
  String get storyWorthLabel => 'Dlaczego warto to zachować?';

  @override
  String get storyWorthHint => 'Wystarczy kilka słów.';

  @override
  String get feelingEyebrow => 'Uczucie';

  @override
  String get feelingStepTitle => 'Jak ma się to czuć, gdy wróci?';

  @override
  String get feelingStepSubtitle =>
      'Dzięki temu łatwiej będzie później odnaleźć to wspomnienie.';

  @override
  String get contextEyebrow => 'Kontekst';

  @override
  String get whenWasItTitle => 'Kiedy to było?';

  @override
  String get photoGpsStepSubtitle =>
      'Mapa korzysta z GPS zapisanego w wybranych zdjęciach. Jeśli zdjęcie nie ma GPS, miejsce się nie pokaże.';

  @override
  String get peopleThreadsEyebrow => 'Osoby i nici';

  @override
  String get peopleThreadsTitle => 'Z kim lub z czym to się łączy?';

  @override
  String get peopleThreadsSubtitle =>
      'Opcjonalne szczegóły zamieniają pojedyncze chwile w nić życia.';

  @override
  String get connectExistingMemoryLabel => 'Połącz z istniejącym wspomnieniem';

  @override
  String get noConnectionYet => 'Jeszcze bez połączenia';

  @override
  String get connectionReasonLabel => 'Dlaczego są połączone?';

  @override
  String get connectionReasonHint =>
      'Przykład: ta sama podróż, ta sama osoba, przed / po...';

  @override
  String get writeMomentOrPhotoFirst =>
      'Najpierw opisz chwilę albo dodaj zdjęcie.';

  @override
  String get todaysMoment => 'Chwila dnia';

  @override
  String get savedFromTodaysPrompt => 'Zapisano z pytania dnia.';

  @override
  String get saveItBeforeItFades => 'Zapisz, zanim wyblaknie';

  @override
  String get chooseDate => 'Wybierz datę';

  @override
  String get dateLabel => 'Data';

  @override
  String get untitledMemory => 'Wspomnienie bez tytułu';

  @override
  String get organize => 'Porządkuj';

  @override
  String get memoryShape => 'Forma wspomnienia';

  @override
  String get wallCategory => 'Kategoria na ścianie';

  @override
  String get privatePhotos => 'Prywatne zdjęcia';

  @override
  String get pick => 'Wybierz';

  @override
  String get addMore => 'Dodaj więcej';

  @override
  String get takePhoto => 'Zrób zdjęcie';

  @override
  String get takePhotosNow => 'Zrób zdjęcia teraz';

  @override
  String get takePhotosFabTooltip => 'Zrób zdjęcia do nowego wspomnienia';

  @override
  String get takeAnotherPhoto => 'Zrób kolejne zdjęcie';

  @override
  String get continueWithPhotos => 'Dalej z tymi zdjęciami';

  @override
  String get addPhotosToMemory => 'Dodaj do wspomnienia';

  @override
  String get takeAnotherOrContinueBody =>
      'Rób dalej zdjęcia do tego wspomnienia albo przejdź dalej i dodaj historię.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zrobiono $count zdjęcia',
      many: 'Zrobiono $count zdjęć',
      few: 'Zrobiono $count zdjęcia',
      one: 'Zrobiono $count zdjęcie',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads kopiuje wybrane zdjęcia do prywatnej pamięci aplikacji i zachowuje datę oraz lokalizację, jeśli są dostępne.';

  @override
  String get limitedPhotoAccessActive =>
      'Dostęp do zdjęć jest ograniczony. Możesz zezwolić na więcej zdjęć.';

  @override
  String get selectPhotos => 'Wybierz zdjęcia';

  @override
  String get photoAccessOff => 'Dostęp do zdjęć jest wyłączony';

  @override
  String get photoAccessOffBody =>
      'Włącz dostęp do zdjęć, by wybierać wspomnienia. Zdjęcia zostają na tym urządzeniu.';

  @override
  String get freeMemoryLimitReached => 'Osiągnięto darmowy limit';

  @override
  String get freeMemoryLimitBody =>
      'Darmowe ściany mieszczą 30 wspomnień. Przejdź na Premium, by dalej budować swoją żywą ścianę.';

  @override
  String get photoAccessNeeded => 'Najpierw potrzebny jest dostęp do zdjęć.';

  @override
  String get quickPhotoMemory => 'Szybkie zdjęcie';

  @override
  String get quickPhotoDescription =>
      'Zdjęcie warte zachowania. Historię dodasz, kiedy zechcesz.';

  @override
  String get hangQuickPhoto => 'Powieś szybkie zdjęcie';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'Wykryto GPS zdjęcia: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'Zdjęcie nie ma GPS. To wspomnienie nie pojawi się na mapie.';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • zdjęcia: $photoCount';
  }

  @override
  String metadataDates(int count, int total) {
    return 'Daty: $count/$total';
  }

  @override
  String metadataLocations(int count, int total) {
    return 'Lokalizacje: $count/$total';
  }

  @override
  String metadataSizes(int count, int total) {
    return 'Rozmiary: $count/$total';
  }

  @override
  String newSelected(int count) {
    return 'Nowe wybrane: $count';
  }

  @override
  String selectedCount(int count) {
    return 'Wybrane: $count';
  }

  @override
  String get editMemoryTitle => 'Edytuj wspomnienie';

  @override
  String get storyPanel => 'Historia';

  @override
  String get memoryTitleLabel => 'Tytuł wspomnienia';

  @override
  String get addTitleValidation => 'Dodaj tytuł';

  @override
  String get storyDescriptionLabel => 'Historia / opis';

  @override
  String get addStoryValidation => 'Dodaj krótką historię';

  @override
  String get shapeFeelingTitle => 'Forma i uczucie';

  @override
  String get memoryTypeLabel => 'Rodzaj wspomnienia';

  @override
  String get feelingLabel => 'Uczucie';

  @override
  String get categoryLabel => 'Kategoria';

  @override
  String get timePhotoGpsTitle => 'Czas i GPS zdjęcia';

  @override
  String get memoryDateLabel => 'Data wspomnienia';

  @override
  String get peopleTitle => 'Osoby';

  @override
  String get galleryTitle => 'Galeria';

  @override
  String get addPhotos => 'Dodaj zdjęcia';

  @override
  String get saveMemory => 'Zapisz wspomnienie';

  @override
  String get memorySaveFailed =>
      'Nie udało się zapisać wspomnienia. Spróbuj ponownie.';

  @override
  String get passwordOnlySpaces =>
      'Hasło nie może składać się z samych spacji.';

  @override
  String get somethingWentWrong => 'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String get mapUnavailable => 'Mapa jest teraz niedostępna.';

  @override
  String get coverPhoto => 'Zdjęcie okładki';

  @override
  String get galleryPhoto => 'Zdjęcie z galerii';

  @override
  String get setAsCover => 'Ustaw jako okładkę';

  @override
  String get replacePhoto => 'Zamień zdjęcie';

  @override
  String get removePhoto => 'Usuń zdjęcie';

  @override
  String get choosePhoto => 'Wybierz zdjęcie';

  @override
  String get threadReasonsTitle => 'Powody nici';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'Utwórz więcej wspomnień, zanim je połączysz.';

  @override
  String get connectionHeaderBody =>
      'Łącz wspomnienia z powodem. Lina powinna wyjaśniać, dlaczego dwie chwile należą do siebie.';

  @override
  String get connectedMemory => 'połączone wspomnienie';

  @override
  String get whyConnectedTitle => 'Dlaczego są połączone?';

  @override
  String get exportPremiumArchiveTitle => 'Eksportuj kopię';

  @override
  String get importArchiveTitle => 'Importuj archiwum';

  @override
  String get archiveExportBody =>
      'Dodaj hasło, by zaszyfrować archiwum. Zostaw puste dla zwykłego lokalnego zipa.';

  @override
  String get archiveImportBody =>
      'Jeśli archiwum jest zaszyfrowane, wpisz hasło. Zostaw puste dla starszych lub niezabezpieczonych kopii.';

  @override
  String get archivePasswordOptional => 'Hasło archiwum (opcjonalnie)';

  @override
  String get archivePasswordLabel => 'Hasło archiwum';

  @override
  String get archivePasswordWarning =>
      'Przechowuj hasło w bezpiecznym miejscu. Jeśli je zgubisz, nie da się go odzyskać.';

  @override
  String get sendArchiveTitle => 'Wyślij archiwum LifeThreads';

  @override
  String get sendArchiveSubject => 'Archiwum wspomnień LifeThreads';

  @override
  String get sendEncryptedArchiveText =>
      'Zaszyfrowane archiwum LifeThreads. Użyj wybranego hasła, by zaimportować je na innym urządzeniu.';

  @override
  String get sendArchiveText =>
      'Archiwum LifeThreads. Zaimportuj je w LifeThreads, by otworzyć ścianę wspomnień na innym urządzeniu.';

  @override
  String get archiveReadyToSend =>
      'Kopia gotowa. Trzymaj ją w bezpiecznym miejscu, poza tym telefonem.';

  @override
  String get archiveNotSaved =>
      'Kopia nie została zapisana. Wyeksportuj ponownie, gdy będziesz gotowy.';

  @override
  String get archiveSharingUnavailable =>
      'Udostępnianie nie jest dostępne na tym urządzeniu.';

  @override
  String archiveShareFailed(Object error) {
    return 'Archiwum zapisane, ale udostępnianie się nie powiodło: $error';
  }

  @override
  String get archiveImportedTitle => 'Zaimportowano archiwum';

  @override
  String get memoriesLabel => 'Wspomnienia';

  @override
  String get photosLabel => 'Zdjęcia';

  @override
  String get wallNotesNailsLabel => 'Notatki / gwoździki';

  @override
  String get connectionsLabel => 'Połączenia';

  @override
  String get archiveImportSummary =>
      'Twoja obecna ściana została zachowana. Zaimportowane wspomnienia dodano bezpiecznie.';

  @override
  String get shareEncryptedCapsuleTitle => 'Udostępnij zaszyfrowaną kapsułę';

  @override
  String get openSharedCapsuleTitle => 'Otwórz udostępnioną kapsułę';

  @override
  String get exportMemoryCapsuleTitle => 'Eksportuj kapsułę wspomnienia';

  @override
  String get importCapsuleDialogTitle => 'Importuj kapsułę';

  @override
  String get secureSharePasswordBody =>
      'Utwórz hasło przed wysłaniem kapsuły. Wyślij hasło osobno osobie, która ją dostanie.';

  @override
  String get sharedCapsulePasswordBody =>
      'Wpisz hasło otrzymane do tego wspomnienia.';

  @override
  String get capsuleExportBody =>
      'Dodaj hasło, jeśli to wspomnienie ma być chronione przed wysłaniem. Zostaw puste dla zwykłej kapsuły.';

  @override
  String get capsuleImportBody =>
      'Jeśli kapsuła ma hasło, wpisz je. W przeciwnym razie zostaw puste.';

  @override
  String get capsulePasswordLabel => 'Hasło kapsuły';

  @override
  String get sharedCapsulePasswordLabel => 'Hasło udostępnionej kapsuły';

  @override
  String get capsulePasswordOptional => 'Hasło kapsuły (opcjonalnie)';

  @override
  String get capsulePasswordWarning =>
      'LifeThreads nie odzyska później tego hasła.';

  @override
  String get passwordRequiredCloudSharing =>
      'Do udostępniania w chmurze potrzebne jest hasło.';

  @override
  String get createSecureShare => 'Utwórz bezpieczny link';

  @override
  String get previewMemory => 'Podgląd wspomnienia';

  @override
  String get sendCapsuleTitle => 'Udostępnij wspomnienie LifeThreads';

  @override
  String get sendCapsuleSubject => 'Kapsuła wspomnienia LifeThreads';

  @override
  String get sendEncryptedCapsuleText =>
      'Hej, udostępniłem ci chronione wspomnienie z LifeThreads. Użyj hasła, które ci wysłałem, by je zaimportować.';

  @override
  String get sendCapsuleText =>
      'Hej, udostępniłem ci wspomnienie z LifeThreads. Zaimportuj kapsułę w LifeThreads, by dodać je do swojej ściany.';

  @override
  String get capsuleReadyToSend => 'Kapsuła gotowa do wysłania.';

  @override
  String get capsuleSavedLater =>
      'Kapsuła zapisana. Możesz ją udostępnić później.';

  @override
  String get capsuleSharingUnavailable =>
      'Kapsuła zapisana, ale udostępnianie jest niedostępne.';

  @override
  String capsuleShareFailed(Object error) {
    return 'Kapsuła zapisana, ale udostępnianie się nie powiodło: $error';
  }

  @override
  String get importThisMemory => 'Zaimportować to wspomnienie?';

  @override
  String get noStoryTextIncluded => 'Brak tekstu historii.';

  @override
  String get placeLabel => 'Miejsce';

  @override
  String get notesLabel => 'Notatki';

  @override
  String get capsulePasswordProtected => 'Ta kapsuła była chroniona hasłem.';

  @override
  String get openingSharedMemory => 'Otwieram udostępnione wspomnienie...';

  @override
  String get lifeThreadsMemoryTitle => 'Wspomnienie LifeThreads';

  @override
  String shareMemoryText(Object url) {
    return 'Hej, udostępniłem ci wspomnienie w LifeThreads.\n\n$url';
  }

  @override
  String get shareLinkReady => 'Link gotowy.';

  @override
  String get shareLinkCreated => 'Link utworzony.';

  @override
  String get shareLinkUnavailable =>
      'Link utworzony, ale udostępnianie jest niedostępne.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label Link wygaśnie sam. Możesz go teraz usunąć.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'Udostępnianie w chmurze nieudane: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'Usunięto link do wspomnienia.';

  @override
  String get creatingSecureMemoryLink => 'Tworzę bezpieczny link...';

  @override
  String get shareMemoryCapsule => 'Udostępnij kapsułę';

  @override
  String get editStory => 'Edytuj historię';

  @override
  String get metaType => 'Rodzaj';

  @override
  String get metaFeeling => 'Uczucie';

  @override
  String get metaCategory => 'Kategoria';

  @override
  String get metaDate => 'Data';

  @override
  String get storyEyebrow => 'Historia';

  @override
  String get whyMemoryMatters => 'Dlaczego to wspomnienie jest ważne';

  @override
  String get galleryEyebrow => 'Galeria';

  @override
  String editSectionTooltip(String section) {
    return 'Edytuj: $section';
  }

  @override
  String get openInMaps => 'Otwórz w Mapach';

  @override
  String get memoryChangesSaved => 'Zmiany zapisane.';

  @override
  String get memoryDeletedToast => 'Wspomnienie usunięte.';

  @override
  String get noteDeletedToast => 'Notatka usunięta.';

  @override
  String get nailDeletedToast => 'Gwoździk usunięty.';

  @override
  String get undo => 'Cofnij';

  @override
  String photoPlaceDetected(String place) {
    return 'Miejsce ze zdjęcia: $place';
  }

  @override
  String get settingsGroupYou => 'Ty';

  @override
  String get settingsGroupReminders => 'Przypomnienia';

  @override
  String get settingsGroupMore => 'Więcej';

  @override
  String get backupDataTitle => 'Kopia i dane';

  @override
  String get backupDataSubtitle => 'Kopia, przywracanie, nowy telefon';

  @override
  String get aboutHelpTitle => 'Informacje i pomoc';

  @override
  String get aboutHelpSubtitle => 'Opinie, prywatność, muzyka, wersja';

  @override
  String get discardChangesTitle => 'Odrzucić zmiany?';

  @override
  String get discardChangesBody => 'Zmiany wprowadzone tutaj zostaną utracone.';

  @override
  String get discardChanges => 'Odrzuć';

  @override
  String get keepEditing => 'Edytuj dalej';

  @override
  String get settingsGroupPrivacy => 'Prywatność';

  @override
  String get appLockTitle => 'Blokada aplikacji';

  @override
  String get appLockSubtitle => 'Face ID lub kod do otwierania LifeThreads';

  @override
  String get appLockReason => 'Odblokuj swoje wspomnienia';

  @override
  String get appLockLockedTitle => 'LifeThreads jest zablokowany';

  @override
  String get appLockUnlock => 'Odblokuj';

  @override
  String get appLockUnavailable =>
      'Najpierw skonfiguruj Face ID lub kod na tym telefonie.';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Czeka na ciebie wspomnienie sprzed $years roku.',
      many: 'Czeka na ciebie wspomnienie sprzed $years lat.',
      few: 'Czeka na ciebie wspomnienie sprzed $years lat.',
      one: 'Czeka na ciebie wspomnienie sprzed $years roku.',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Szukaj';

  @override
  String get searchHint => 'Tytuł, miejsce, osoba lub rok';

  @override
  String get searchClear => 'Wyczyść wyszukiwanie';

  @override
  String get searchNoResults => 'Żadne wspomnienie nie pasuje.';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wspomnienia',
      many: '$count wspomnień',
      few: '$count wspomnienia',
      one: '$count wspomnienie',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => 'Szukaj wspomnień';

  @override
  String get premiumFeatureWalls => 'Więcej ścian';

  @override
  String get newWall => 'Nowa ściana';

  @override
  String get wallNameLabel => 'Nazwa ściany';

  @override
  String get newWallHint => 'np. Podróże 2025';

  @override
  String get createWall => 'Utwórz';

  @override
  String get renameWall => 'Zmień nazwę';

  @override
  String get deleteWall => 'Usuń ścianę';

  @override
  String deleteWallQuestion(String name) {
    return 'Usunąć „$name”?';
  }

  @override
  String get deleteWallBody =>
      'Jej wspomnienia trafią na Moją ścianę; nic nie zginie.';

  @override
  String get personalWallSubtitle => 'Twoja ściana, na tym urządzeniu';

  @override
  String get wallOptions => 'Opcje ściany';

  @override
  String get moveToWall => 'Przenieś na ścianę…';

  @override
  String movedToWall(String name) {
    return 'Przeniesiono: $name.';
  }

  @override
  String get hideMemory => 'Ukryj';

  @override
  String get unhideMemory => 'Pokaż ponownie';

  @override
  String get memoryHiddenToast =>
      'Ukryto. Znajdziesz je w Widok › Ukryte wspomnienia.';

  @override
  String get showHiddenMemories => 'Ukryte wspomnienia';

  @override
  String get showHiddenReason => 'Pokaż ukryte wspomnienia';

  @override
  String get yearThreadFirstTitle => 'Twoja pierwsza Nić roku';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count z 3 wspomnień',
      many: '$count z 3 wspomnień',
      few: '$count z 3 wspomnień',
      one: '$count z 3 wspomnień',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => 'Albo utwórz teraz historię';

  @override
  String get moveMemoriesHere => 'Przenieś tu wspomnienia';

  @override
  String get moveMemoriesTitle => 'Wybierz wspomnienia do przeniesienia';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Przenieś $count wspomnienia',
      many: 'Przenieś $count wspomnień',
      few: 'Przenieś $count wspomnienia',
      one: 'Przenieś $count wspomnienie',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'Pokaż wszystko';

  @override
  String get addAMemory => 'Dodaj wspomnienie';

  @override
  String get mapAddPhotoMemory => 'Dodaj zdjęcie z miejscem';

  @override
  String get searchSuggestions => 'Spróbuj jednego ze swoich';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'W tym tygodniu $years roku temu',
      many: 'W tym tygodniu $years lat temu',
      few: 'W tym tygodniu $years lata temu',
      one: 'W tym tygodniu $years rok temu',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => 'Kto tam był?';

  @override
  String get premiumPlanYearly => 'Rocznie';

  @override
  String get premiumPlanMonthly => 'Miesięcznie';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/rok';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Oszczędzasz $percent%';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'Płatność jest pobierana z konta $store. Subskrypcja odnawia się automatycznie co rok, chyba że anulujesz ją co najmniej 24 godziny przed końcem bieżącego okresu. Zarządzaj nią lub anuluj w ustawieniach konta $store.';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zapisanego zdjęcia',
      many: '$count zapisanych zdjęć',
      few: '$count zapisane zdjęcia',
      one: '$count zapisane zdjęcie',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => 'Osoby';

  @override
  String get partOfMemory => 'W tym wspomnieniu';

  @override
  String get notesEyebrow => 'Notatki';

  @override
  String get attachedThoughts => 'Dołączone myśli';

  @override
  String get stickyNote => 'Karteczka';

  @override
  String get placeEyebrow => 'Miejsce';

  @override
  String get threadsEyebrow => 'Nici';

  @override
  String get connectedMemories => 'Połączone wspomnienia';

  @override
  String get noConnectedMemoriesYet =>
      'Brak połączonych wspomnień. Połącz ten rozdział z inną chwilą, by zacząć widoczną nić życia.';

  @override
  String get backToWall => 'Wróć do ściany';

  @override
  String get addTextToWall => 'Dodaj tekst do ściany';

  @override
  String get addTextAction => 'Dodaj tekst';

  @override
  String get textNoteHint => 'Napisz małe wspomnienie, cytat albo notatkę...';

  @override
  String get placeTextNote => 'Umieść notatkę';

  @override
  String get placeRopeAnchor => 'Umieść zaczep';

  @override
  String get nailSubtitle =>
      'Gwoździk pozwala ręcznie łączyć liny między wspomnieniami.';

  @override
  String get clearDemoWallQuestion => 'Wyczyścić przykładową ścianę?';

  @override
  String get clearDemoWallBody =>
      'To usunie przykładowe wspomnienia, żebyś mógł zacząć od pustej, prywatnej ściany.';

  @override
  String get importBackupQuestion => 'Zaimportować kopię?';

  @override
  String get importBackupBody =>
      'To przywraca wspomnienia z archiwum LifeThreads i zachowuje twoją obecną ścianę.';

  @override
  String get deleteMemoryQuestion => 'Usunąć wspomnienie?';

  @override
  String get deleteMemoryBody =>
      'To usuwa wspomnienie i wszystkie jego połączenia na ścianie.';

  @override
  String get editText => 'Edytuj tekst';

  @override
  String get editTextTitle => 'Edytuj tekst';

  @override
  String get connectRope => 'Połącz linę';

  @override
  String get connectRopeSubtitle => 'Przywiąż ten gwoździk do wspomnień.';

  @override
  String get deleteNail => 'Usuń gwoździk';

  @override
  String get connectNailTitle => 'Połącz gwoździk ze wspomnieniami';

  @override
  String get connectNailSubtitle =>
      'Wybrane wspomnienia zawisną na tym zaczepie.';

  @override
  String get timelineTitle => 'Oś czasu';

  @override
  String get timelineSubtitle => 'Twoje wspomnienia według czasu.';

  @override
  String get noMemoriesFilter => 'Brak wspomnień w tym filtrze';

  @override
  String get noMemoriesFilterBody =>
      'Zmień filtr albo dodaj wspomnienie, by zbudować oś czasu.';

  @override
  String get memoryMapTitle => 'Mapa wspomnień';

  @override
  String get memoryMapSubtitle => 'Twoje wspomnienia według miejsc.';

  @override
  String get noMappedMemories => 'Brak wspomnień na mapie';

  @override
  String get displayWallTooltip => 'Pokaż ścianę';

  @override
  String get tutorialTooltip => 'Samouczek';

  @override
  String get settingsTooltip => 'Ustawienia';

  @override
  String get freeformLayout => 'Swobodnie';

  @override
  String get categoryLayout => 'Kategoria';

  @override
  String get locationLayout => 'Miejsce';

  @override
  String get saveToday => 'Zapisz dzień';

  @override
  String get rememberThis => 'Zapamiętaj to';

  @override
  String get whatHappenedToday => 'Co się dziś wydarzyło?';

  @override
  String get tapToOpenDrag =>
      'Stuknij, by otworzyć • przeciągnij, by przesunąć';

  @override
  String get demoWallPreview =>
      'Przykładowa ściana. Wyczyść ją, gdy zechcesz zacząć od zera.';

  @override
  String get clearDemo => 'Wyczyść przykład';

  @override
  String get chooseQuickPhoto => 'Wybierz szybkie zdjęcie';

  @override
  String get wallView => 'Ściana';

  @override
  String get timelineView => 'Oś czasu';

  @override
  String get mapView => 'Mapa';

  @override
  String get wallFilterAll => 'Wszystko';

  @override
  String get wallViewButton => 'Widok';

  @override
  String get wallShowAs => 'Pokaż jako';

  @override
  String get wallArrange => 'Ułóż';

  @override
  String get wallShowOnly => 'Pokaż';

  @override
  String get layoutByDate => 'Według daty';

  @override
  String get moreActionsTooltip => 'Więcej';

  @override
  String get addToWallTitle => 'Dodaj do ściany';

  @override
  String get expandableMemory => 'Wspomnienie';

  @override
  String get expandableMemorySubtitle => 'Pełna historia z podpowiedziami';

  @override
  String get expandableQuickPhoto => 'Szybkie zdjęcie';

  @override
  String get expandableQuickPhotoSubtitle => 'Wybierz zdjęcie i powieś';

  @override
  String get expandableTextNote => 'Notatka';

  @override
  String get expandableTextNoteSubtitle => 'Krótka myśl na ścianie';

  @override
  String get expandableNail => 'Gwoździk / zaczep';

  @override
  String get expandableNailSubtitle => 'Ręczny punkt dla liny';

  @override
  String get startWithOneThing => 'Zacznij od jednej rzeczy z dziś';

  @override
  String get emptyWallBody =>
      'Zapisz chwilę, zanim wyblaknie. Wystarczy jedno zdanie albo zdjęcie.';

  @override
  String get usePhoto => 'Użyj zdjęcia';

  @override
  String get editMemoryTooltip => 'Edytuj wspomnienie';

  @override
  String get connectMemoryTooltip => 'Połącz wspomnienie';

  @override
  String get archiveTransferTitle => 'Otwórz na innym urządzeniu';

  @override
  String get archiveTransferHeroTitle =>
      'Bezpiecznie przenoś wspomnienia między urządzeniami.';

  @override
  String get archiveTransferHeroBody =>
      'Kopia to jeden zip ze wspomnieniami, zdjęciami, notatkami, nićmi, pozycjami na ścianie i metadanymi, opcjonalnie zabezpieczony hasłem. Nie trzymamy żadnej kopii: ty decydujesz, gdzie trafi.';

  @override
  String get archiveTransferStep1Title => 'Eksportuj archiwum';

  @override
  String get archiveTransferStep1Body =>
      'Otwórz Ustawienia, wybierz Eksportuj archiwum i dodaj hasło, jeśli chcesz je zabezpieczyć.';

  @override
  String get archiveTransferStep2Title => 'Przenieś zip';

  @override
  String get archiveTransferStep2Body =>
      'Prześlij go przez AirDrop, USB, własną chmurę albo e-mail.';

  @override
  String get archiveTransferStep3Title => 'Importuj bezpiecznie';

  @override
  String get archiveTransferStep3Body =>
      'Zainstaluj LifeThreads na drugim urządzeniu, wybierz Importuj archiwum, w razie potrzeby wpisz hasło i przywróć dane bez usuwania istniejących.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled =>
      'Włączono testowe odblokowanie Premium.';

  @override
  String get lifetimeActive => 'Subskrypcja aktywna';

  @override
  String get oneTimeLifetimeUnlock => 'Rocznie lub miesięcznie';

  @override
  String get premiumHeroActiveTitle => 'Twoja ściana wspomnień nie ma limitu.';

  @override
  String get premiumHeroLockedTitle => 'Zamień wspomnienia w historie.';

  @override
  String get premiumHeroActiveBody =>
      'Twoja subskrypcja Premium jest aktywna. Historie z muzyką, Nić roku, ściany rodzinne i nielimitowane wspomnienia są twoje.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'Za darmo: $limit wspomnień i pełne kopie zapasowe. Premium dodaje historie i filmy z muzyką, Nić roku, ściany rodzinne i nielimitowane wspomnienia.';
  }

  @override
  String get premiumMemories => 'Wspomnienia Premium';

  @override
  String get freeMemories => 'Darmowe wspomnienia';

  @override
  String get unlimited => 'bez limitu';

  @override
  String get benefitUnlimitedTitle => 'Nielimitowane wspomnienia';

  @override
  String get benefitUnlimitedBody =>
      'Bez limitu 30 wspomnień. Buduj ścianę, gdy życie rośnie.';

  @override
  String get benefitThemesTitle => 'Motywy Premium';

  @override
  String get benefitThemesBody =>
      'Odblokuj bogatsze klimaty, sezonowe motywy i tryb Auto według pory dnia.';

  @override
  String get benefitLayoutsTitle => 'Zaawansowane układy';

  @override
  String get benefitLayoutsBody =>
      'Więcej sposobów na układanie nici, osi czasu, zaczepów i grup wspomnień.';

  @override
  String get lifetimeUnlock => 'Subskrypcja Premium';

  @override
  String get premiumActiveOnDevice => 'Premium jest aktywne na tym urządzeniu.';

  @override
  String onePurchaseBody(String store) {
    return 'Subskrybuj rocznie lub miesięcznie: historie z muzyką, Nić roku, ściany rodzinne i nielimitowane wspomnienia. Anuluj w dowolnej chwili w ustawieniach $store.';
  }

  @override
  String get premiumActiveButton => 'Premium aktywne';

  @override
  String get processing => 'Przetwarzam...';

  @override
  String get unlockPremium => 'Subskrybuj Premium';

  @override
  String get restorePurchase => 'Przywróć subskrypcję';

  @override
  String get enableDebugMockUnlock => 'Włącz testowe odblokowanie';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'Płatność jest pobierana z konta $store. Subskrypcja odnawia się automatycznie co miesiąc, chyba że anulujesz ją co najmniej 24 godziny przed końcem bieżącego okresu. Zarządzaj nią lub anuluj w ustawieniach konta $store.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'Aktualizacja sklepu nie powiodła się. Spróbuj ponownie.';

  @override
  String get premiumMessageStoreUnavailable =>
      'Zakupy nie są dostępne na tym urządzeniu.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium nie jest jeszcze dostępne w sklepie. Spróbuj później.';

  @override
  String get premiumMessageLoadFailed =>
      'Nie udało się wczytać Premium ze sklepu. Spróbuj ponownie.';

  @override
  String get premiumMessageOpeningCheckout => 'Otwieram płatność…';

  @override
  String get premiumMessageCheckoutFailed =>
      'Nie udało się otworzyć płatności. Spróbuj ponownie.';

  @override
  String get premiumMessageChecking => 'Sprawdzam subskrypcję…';

  @override
  String get premiumMessageRestoreFailed =>
      'Przywracanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'Nie znaleziono aktywnej subskrypcji Premium.';

  @override
  String get premiumMessagePending =>
      'Zakup czeka na zatwierdzenie. Premium odblokuje się po akceptacji.';

  @override
  String get premiumMessagePurchaseFailed =>
      'Zakup się nie udał. Spróbuj ponownie.';

  @override
  String get premiumMessageCanceled => 'Zakup anulowany.';

  @override
  String get premiumMessageRestored =>
      'Twoja subskrypcja Premium została przywrócona.';

  @override
  String get premiumMessageActive => 'Twoja subskrypcja Premium jest aktywna.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/mies.';
  }

  @override
  String get loadingPlayStoreProduct => 'Wczytuję subskrypcję…';

  @override
  String get playStoreUnavailable => 'Sklep jest teraz niedostępny';

  @override
  String get productNotConfigured => 'Premium jest teraz niedostępne';

  @override
  String get purchasePending => 'Zakup oczekuje';

  @override
  String get purchased => 'Kupiono';

  @override
  String get restored => 'Przywrócono';

  @override
  String get premiumTryAgain => 'Spróbuj ponownie';

  @override
  String get purchaseFailed => 'Zakup nieudany';

  @override
  String get preparingCheckout => 'Przygotowuję płatność...';

  @override
  String get premiumLocalFirstTitle => 'Premium też działa lokalnie';

  @override
  String get premiumLocalFirstBody =>
      'Twoje wspomnienia zostają na urządzeniu, a kopie zapasowe są darmowe dla wszystkich.';

  @override
  String get noMappedMemoriesBody =>
      'Dodaj zdjęcia z danymi GPS, by zobaczyć tu wspomnienia.';

  @override
  String get peopleLabel => 'Osoby';

  @override
  String get connect => 'Połącz';

  @override
  String get themeWarmMemoryRoom => 'Ciepły pokój';

  @override
  String get themeWarmMemoryRoomDescription =>
      'Miękkie, ciemne ciepło, złote światło i głębia prywatnego pokoju.';

  @override
  String get themeMidnightArchive => 'Archiwum o północy';

  @override
  String get themeMidnightArchiveDescription =>
      'Granatowe archiwum z muzealnym spokojem.';

  @override
  String get themeSoftPaperWall => 'Miękki papier';

  @override
  String get themeSoftPaperWallDescription =>
      'Kremowy papier, cienie atramentu i spokój scrapbooka.';

  @override
  String get themeTravelCorkboard => 'Korkowa tablica podróży';

  @override
  String get themeTravelCorkboardDescription =>
      'Ciepło korka z siatką mapy dla podróży i miejsc.';

  @override
  String get themeAutoTitle => 'Auto według pory dnia';

  @override
  String get themeAutoDescription =>
      'Miękki papier w dzień, Ciepły pokój wieczorem, Archiwum o północy w nocy.';

  @override
  String get themeAutoSelected => 'Twoja ściana zmienia się teraz z porą dnia.';

  @override
  String get themeSeasonalTitle => 'Sezonowe';

  @override
  String get themeSeasonalBody =>
      'Limitowane motywy Premium, każdy dostępny tylko w swoim sezonie.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Do $dateString';
  }

  @override
  String get themeUseButton => 'Użyj tego motywu';

  @override
  String get themeInUse => 'W użyciu';

  @override
  String get themeUnlockButton => 'Odblokuj z Premium';

  @override
  String get themeAutumnHarvest => 'Jesienne zbiory';

  @override
  String get themeAutumnHarvestDescription =>
      'Bursztynowe światło, karty z papieru pakowego i blask spadających liści.';

  @override
  String get themeWinterLights => 'Zimowe światła';

  @override
  String get themeWinterLightsDescription =>
      'Oszronione karty i ciepłe lampki w mroźną, niebieską noc.';

  @override
  String get themeSpringBlossom => 'Wiosenne kwiaty';

  @override
  String get themeSpringBlossomDescription =>
      'Blade kwiatowe karty z delikatnym różowym blaskiem.';

  @override
  String get themeSummerEvening => 'Letni wieczór';

  @override
  String get themeSummerEveningDescription =>
      'Kolory zachodu słońca i karty jak zdjęcia natychmiastowe.';

  @override
  String get themeYearRoundTitle => 'Zawsze dostępne';

  @override
  String get themeComingTitle => 'Wkrótce';

  @override
  String get themeComingBody =>
      'Zajrzyj do kolejnych sezonów. Każdy motyw otwiera się pierwszego dnia swojego sezonu.';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Od $dateString';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zobacz wszystkie motywy, $count na ten sezon',
      many: 'Zobacz wszystkie motywy, $count na ten sezon',
      few: 'Zobacz wszystkie motywy, $count na ten sezon',
      one: 'Zobacz wszystkie motywy, $count na ten sezon',
      zero: 'Zobacz wszystkie motywy',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => 'Nad morzem';

  @override
  String get themeSeasideDescription =>
      'Turkusowa woda, piaskowy papier i ciepłe letnie światło.';

  @override
  String get themeSnowyCabin => 'Zaśnieżona chatka';

  @override
  String get themeSnowyCabinDescription =>
      'Drewno przy kominku, oszronione karty i miękki śnieg za oknem.';

  @override
  String get themeSpringMeadow => 'Wiosenna łąka';

  @override
  String get themeSpringMeadowDescription =>
      'Świeża trawa, jasne karty i żółte słońce.';

  @override
  String get themeMistyForest => 'Mglisty las';

  @override
  String get themeMistyForestDescription =>
      'Ciche sosny, poranna mgła i złote liście.';

  @override
  String get demoFirstDanceTitle => 'Nasz pierwszy taniec';

  @override
  String get demoFirstDanceStory =>
      'Zespół zagrał naszą piosenkę i cała stodoła ucichła. Dwa razy nadepnąłem ci na stopę, śmiałaś się cały czas, a przez trzy minuty nie było nikogo poza nami.';

  @override
  String get demoFirstDancePlace => 'Salzburg';

  @override
  String get demoNewbornTitle => 'Witaj w domu, Lino';

  @override
  String get demoNewbornStory =>
      'Cała jej rączka obejmowała jeden palec. Pierwszy cichy poranek w domu.';

  @override
  String get demoNewbornPlace => 'Wiedeń';

  @override
  String get demoBeachSunsetTitle => 'Lato nad morzem';

  @override
  String get demoBeachSunsetStory =>
      'Boso aż do zachodu słońca, w drodze powrotnej Lina zasnęła ci na ramionach.';

  @override
  String get demoBeachSunsetPlace => 'Split, Chorwacja';

  @override
  String get demoGrandmaKitchenTitle => 'Kuchnia babci';

  @override
  String get demoGrandmaKitchenStory =>
      'Jej ciasto morelowe w końcu spisane – i mąka wszędzie.';

  @override
  String get demoGrandmaKitchenPlace => 'Graz';

  @override
  String get demoGraduationTitle => 'Dzień dyplomu';

  @override
  String get demoGraduationStory =>
      'Tata płakał, zanim biretom udało się wylądować.';

  @override
  String get demoGraduationPlace => 'Innsbruck';

  @override
  String get demoFirstHomeTitle => 'Klucze do naszego pierwszego domu';

  @override
  String get demoFirstHomeStory =>
      'Jeszcze bez mebli, tylko kartony, pizza na podłodze i mnóstwo planów.';

  @override
  String get demoFirstHomePlace => 'Linz';

  @override
  String get demoAlpineSummitTitle => 'Ponad chmurami';

  @override
  String get demoAlpineSummitStory =>
      'Pobudka o 4 rano dla tego widoku. Każdy krok był tego wart.';

  @override
  String get demoAlpineSummitPlace => 'Grossglockner';

  @override
  String get demoFirstBikeTitle => 'Pierwsza jazda bez trzymanki';

  @override
  String get demoFirstBikeStory =>
      'Trzy obroty pedałami, chwiejnie, i już pojechał – taki dumny.';

  @override
  String get demoFirstBikePlace => 'Prater, Wiedeń';

  @override
  String get demoGardenDinnerTitle => '80. urodziny dziadka';

  @override
  String get demoGardenDinnerStory =>
      'Cztery pokolenia przy jednym długim stole, a najlepsze historie i tak opowiadał on.';

  @override
  String get demoGardenDinnerPlace => 'Wachau';

  @override
  String get demoThreadFirstDanceToFirstHome => 'Nasza historia';

  @override
  String get demoThreadFirstHomeToNewborn => 'Potem przyszła Lina';

  @override
  String get demoThreadNewbornToBeachSunset => 'Jej pierwsze lato';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'Rodzina';

  @override
  String get demoThreadGraduationToFirstHome => 'Nowy rozdział';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'Małe przygody';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'Dziadek patrzył';

  @override
  String get demoRelationGrandpa => 'Dziadek';

  @override
  String get demoRelationGrandma => 'Babcia';

  @override
  String get demoRelationDaughter => 'Córka';

  @override
  String get demoRelationWife => 'Żona';

  @override
  String get demoRelationBestMan => 'Świadek';

  @override
  String get demoRelationMother => 'Mama';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Zapisano w $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wspomnienia nie ma jeszcze kopii.',
      many: '$count wspomnień nie ma jeszcze kopii.',
      few: '$count wspomnienia nie mają jeszcze kopii.',
      one: '$count wspomnienie nie ma jeszcze kopii.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Później';

  @override
  String get backUp => 'Zrób kopię';

  @override
  String get onThisDayTitle => 'Tego dnia';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Dziś $years roku temu',
      many: 'Dziś $years lat temu',
      few: 'Dziś $years lata temu',
      one: 'Dziś $years rok temu',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years roku temu',
      many: '$years lat temu',
      few: '$years lata temu',
      one: '$years rok temu',
    );
    return 'Tego dnia · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'W dni, gdy wraca wspomnienie z wcześniejszego roku, LifeThreads wysyła jedno ciche przypomnienie.';

  @override
  String get onThisDayReminderSwitch => 'Codzienne przypomnienie';

  @override
  String onThisDayReminderAt(String time) {
    return 'O $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'Powiadomienia LifeThreads są wyłączone. Włącz je w ustawieniach telefonu.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Dziś $years roku temu: $title',
      many: 'Dziś $years lat temu: $title',
      few: 'Dziś $years lata temu: $title',
      one: 'Dziś $years rok temu: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jeszcze $count wspomnienia',
      many: 'jeszcze $count wspomnień',
      few: 'jeszcze $count wspomnienia',
      one: 'jeszcze $count wspomnienie',
    );
    return '$title i $_temp0 z tego dnia';
  }

  @override
  String get onThisDayChannelDescription =>
      'Wspomnienie z tego dnia z wcześniejszego roku.';

  @override
  String get benefitOnThisDayBody =>
      'Przypomnienie, gdy wraca wspomnienie z wcześniejszego roku, otwierane jako osobny rozdział.';

  @override
  String get premiumFeatureStoryImage => 'Obrazy historii';

  @override
  String get premiumFeatureStoryVideo => 'Filmy historii';

  @override
  String get premiumFeatureThreadOfTheYear => 'Nić roku';

  @override
  String get premiumFeatureFamilyWall => 'Ściana rodzinna';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature to część Premium.';
  }

  @override
  String get yearThreadTitle => 'Nić roku';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wspomnienia',
      many: '$count wspomnień',
      few: '$count wspomnienia',
      one: '$count wspomnienie',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miejsca',
      many: '$count miejsc',
      few: '$count miejsca',
      one: '$count miejsce',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osoby',
      many: '$count osób',
      few: '$count osoby',
      one: '$count osoba',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miesiąca',
      many: '$count miesięcy',
      few: '$count miesiące',
      one: '$count miesiąc',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'Najczęstsze uczucie: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'Rok na jednej nici.';

  @override
  String get yearThreadMyYear => 'Mój rok';

  @override
  String get yearThreadWallCardTitle => 'Twój rok we wspomnieniach';

  @override
  String yearThreadWallCardBody(String year) {
    return 'Zamień rok $year w krótki film.';
  }

  @override
  String get yearThreadDismiss => 'Nie teraz';

  @override
  String get yearThreadSettingsBody =>
      'Zamień każdy rok z co najmniej 3 wspomnieniami w krótki film, opowiedziany po kolei i połączony nicią.';

  @override
  String get yearThreadOpen => 'Zrób film';

  @override
  String get yearThreadNoYears =>
      'Nić roku potrzebuje roku z co najmniej 3 wspomnieniami. Zapisuj chwile i wróć tu.';

  @override
  String get yearThreadYear => 'Rok';

  @override
  String get yearThreadLength => 'Długość';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'Film · $seconds s';
  }

  @override
  String get yearThreadLengthStory => 'Historia · 20 s';

  @override
  String get yearThreadMusic => 'Muzyka';

  @override
  String get yearThreadNoMusic => 'Bez muzyki';

  @override
  String get yearThreadInFilm => 'W filmie';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count z $max';
  }

  @override
  String get yearThreadAddMemory => 'Dodaj wspomnienie';

  @override
  String get yearThreadSwap => 'Zamień';

  @override
  String get yearThreadRemove => 'Usuń';

  @override
  String get yearThreadUseSuggestions => 'Użyj propozycji';

  @override
  String yearThreadPickTitle(String year) {
    return 'Wybierz wspomnienie z $year';
  }

  @override
  String get yearThreadNoOthers =>
      'Wszystkie wspomnienia z tego roku są już w filmie.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wspomnienia',
      many: '$count wspomnień',
      few: '$count wspomnienia',
      one: '$count wspomnienie',
    );
    return 'Wybierz co najmniej $_temp0.';
  }

  @override
  String get yearThreadPreview => 'Podgląd';

  @override
  String get yearThreadExportVideo => 'Eksportuj film';

  @override
  String get yearThreadExportImage => 'Eksportuj obraz';

  @override
  String get yearThreadShare => 'Udostępnij';

  @override
  String get yearThreadSave => 'Zapisz w Zdjęciach';

  @override
  String get yearThreadMakingFilm => 'Tworzę twój film…';

  @override
  String get yearThreadMakingImage => 'Tworzę twój obraz…';

  @override
  String get yearThreadFilmReady => 'Twój film jest gotowy';

  @override
  String get yearThreadImageReady => 'Twój obraz jest gotowy';

  @override
  String get yearThreadSaved => 'Zapisano w zdjęciach.';

  @override
  String get yearThreadExportFailed => 'Nie udało się. Spróbuj ponownie.';

  @override
  String get yearThreadPlay => 'Odtwórz';

  @override
  String get yearThreadPause => 'Pauza';

  @override
  String get createStory => 'Utwórz historię';

  @override
  String get storyPickTitle => 'Wybierz wspomnienia';

  @override
  String storyPickBody(int max) {
    return 'Wybierz do $max wspomnień na jedną historię.';
  }

  @override
  String storyPickCount(int count, int max) {
    return 'Wybrano $count z $max';
  }

  @override
  String storyPickLimit(int max) {
    return 'Historia mieści do $max wspomnień.';
  }

  @override
  String get storyPickContinue => 'Dalej';

  @override
  String get storyNoMemories =>
      'Najpierw zapisz wspomnienie, potem zamień je w historię.';

  @override
  String get storyEditorTitle => 'Twoja historia';

  @override
  String get storyChangeMemories => 'Zmień wspomnienia';

  @override
  String get storyTemplateSingle => 'Pojedynczo';

  @override
  String get storyTemplateThread => 'Ściana z nicią';

  @override
  String get storyTemplateCollage => 'Kolaż';

  @override
  String get storyTemplateQuote => 'Słowa';

  @override
  String get storySwipeHint => 'Przesuń, by zobaczyć inny wygląd';

  @override
  String get storyCaptionLabel => 'Podpis';

  @override
  String get storyCaptionHint => 'Jedno zdanie twojej historii';

  @override
  String get storyVideoSwitch => 'Wideo';

  @override
  String get storyVideoBody =>
      'Krótki film do relacji i rolek, z ruchem i muzyką.';

  @override
  String get storyMusicTitle => 'Muzyka';

  @override
  String get storyMusicNone => 'Bez muzyki';

  @override
  String get storyMusicNoneHint =>
      'Muzykę możesz też dodać w Instagramie przy publikowaniu.';

  @override
  String get storyMoodWarm => 'Ciepła';

  @override
  String get storyMoodJoyful => 'Radosna';

  @override
  String get storyMoodCalm => 'Spokojna';

  @override
  String get storyMoodNostalgic => 'Nostalgiczna';

  @override
  String get storyMoodEpic => 'Epicka';

  @override
  String get storyMoodEmotional => 'Wzruszająca';

  @override
  String get storyMusicTrimHint =>
      'Przeciągnij złotą ramkę, by wybrać fragment piosenki';

  @override
  String get storySearchHint => 'Szukaj wspomnień, miejsc, lat';

  @override
  String storySearchEmpty(String query) {
    return 'Żadne wspomnienie nie pasuje do „$query”.';
  }

  @override
  String get storyMemoriesInStory => 'W twojej historii';

  @override
  String get storyMemoriesReorderHint =>
      'Przytrzymaj i przeciągnij, by zmienić kolejność';

  @override
  String get storyAddMemory => 'Dodaj';

  @override
  String get storyAddMemoryTitle => 'Dodaj wspomnienie';

  @override
  String storyRemoveMemory(String title) {
    return 'Usuń $title z historii';
  }

  @override
  String get storyAllMemoriesAdded =>
      'Wszystkie wspomnienia są już w tej historii.';

  @override
  String get storyShare => 'Udostępnij';

  @override
  String get storySaveToPhotos => 'Zapisz w Zdjęciach';

  @override
  String get storySaved => 'Zapisano w zdjęciach.';

  @override
  String get storySaveDenied =>
      'LifeThreads nie może dodawać do twoich zdjęć. Zezwól na to w ustawieniach telefonu.';

  @override
  String storyExportFailed(String error) {
    return 'Nie udało się utworzyć historii: $error';
  }

  @override
  String get storyRenderingTitle => 'Tworzę twój film';

  @override
  String get storyRenderingBody =>
      'Nie zamykaj LifeThreads, to potrwa kilka sekund.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent%';
  }

  @override
  String get storyPreviewFree =>
      'Podgląd jest darmowy. Udostępnianie i zapisywanie historii to część Premium.';

  @override
  String get benefitStoriesTitle => 'Utwórz historię';

  @override
  String get benefitStoriesBody =>
      'Zamieniaj wspomnienia w obrazy i krótkie filmy z muzyką na Instagram, WhatsApp i nie tylko.';

  @override
  String get musicCreditsTitle => 'Autorzy muzyki';

  @override
  String get musicCreditsBody =>
      'Utwory dołączone do filmów historii, wraz z licencjami.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'Twój rok jako krótki film: ważne chwile po kolei, z muzyką.';

  @override
  String get benefitFamilyTitle => 'Ściany rodzinne';

  @override
  String get benefitFamilyBody =>
      'Wspólna ściana dla rodziny, szyfrowana end-to-end. Każdy dodaje swoje chwile.';

  @override
  String get myWall => 'Moja ściana';

  @override
  String get myWallSubtitle => 'Prywatna, na tym urządzeniu';

  @override
  String get switchWall => 'Zmień ścianę';

  @override
  String get familyWallsTitle => 'Ściany rodzinne';

  @override
  String get familyWallsSettingsBody =>
      'Dziel jedną ścianę z rodziną lub przyjaciółmi: każdy dodaje wspomnienia, szyfrowane end-to-end. Moja ściana zostaje prywatna na tym urządzeniu.';

  @override
  String get familyWallsOpen => 'Otwórz ściany rodzinne';

  @override
  String get familyWallsManage => 'Zarządzaj ścianami rodzinnymi';

  @override
  String get familyWallsHeadline => 'Jedna ściana, cała rodzina';

  @override
  String get familyWallsIntro =>
      'Ściana rodzinna jest wspólna z osobami, które zaprosisz. Wspomnienia i zdjęcia są szyfrowane na twoim telefonie przed wysłaniem; otworzyć je mogą tylko członkowie. Moja ściana nie jest udostępniana i zostaje na tym urządzeniu.';

  @override
  String get familyUnavailableTitle => 'Jeszcze niedostępne';

  @override
  String get familyUnavailable =>
      'Ściany rodzinne nie są jeszcze dostępne w tej wersji LifeThreads.';

  @override
  String get familySignInNeededTitle =>
      'Zaloguj się, by korzystać ze ścian rodzinnych';

  @override
  String get familySignInNeededBody =>
      'Wspólna ściana wymaga konta, żeby rodzina wiedziała, kto co dodał. Moja ściana działa bez niego.';

  @override
  String get familySignIn => 'Zaloguj się';

  @override
  String get familyLoadFailed => 'Nie udało się wczytać';

  @override
  String get familyRetry => 'Spróbuj ponownie';

  @override
  String get familyNoWallsYet =>
      'Brak ścian rodzinnych. Utwórz własną albo dołącz przez link z zaproszeniem.';

  @override
  String get familyStartTitle => 'Utwórz lub dołącz';

  @override
  String get familyStartBody =>
      'Utworzenie ściany rodzinnej wymaga Premium. Dołączenie jest darmowe: Premium właściciela obejmuje całą rodzinę.';

  @override
  String get familyCreateAction => 'Utwórz ścianę rodzinną';

  @override
  String get familyCreateTitle => 'Nowa ściana rodzinna';

  @override
  String get familyNameLabel => 'Nazwa ściany';

  @override
  String get familyNameHint => 'np. Kowalscy';

  @override
  String get familyMyNameLabel => 'Twoje imię na tej ścianie';

  @override
  String get familyMyNameHelper =>
      'Członkowie widzą je przy twoich wspomnieniach. Jest zaszyfrowane jak wszystko na ścianie.';

  @override
  String get familyMyNameSaved => 'Imię zapisane.';

  @override
  String get familySetMyName => 'Moje imię';

  @override
  String get familyCheckingSubscription => 'Sprawdzam twoje Premium…';

  @override
  String get familyCreating => 'Tworzę ścianę…';

  @override
  String get familyJoinWithLink => 'Dołącz przez link';

  @override
  String get familyInviteLinkLabel => 'Link z zaproszeniem';

  @override
  String get familyJoinTitle => 'Dołączyć do tej ściany rodzinnej?';

  @override
  String get familyJoinBody =>
      'Członkowie zobaczą twoje imię i dodane przez ciebie wspomnienia, a ty ich. Możesz odejść w każdej chwili.';

  @override
  String get familyJoinAction => 'Dołącz';

  @override
  String get familyJoining => 'Dołączam…';

  @override
  String familyJoined(String family) {
    return 'Dołączono do: $family.';
  }

  @override
  String get familyRoleOwner => 'Właściciel';

  @override
  String get familyRoleMember => 'Członek';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count członka',
      many: '$count członków',
      few: '$count członków',
      one: '$count członek',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'Ustawienia ściany';

  @override
  String familyStorageUsed(String used, String total) {
    return 'Użyto $used z $total';
  }

  @override
  String get familyRename => 'Zmień nazwę';

  @override
  String get familyInviteTitle => 'Zaproś';

  @override
  String get familyInviteBody =>
      'Wyślij link komuś zaufanemu. Każdy link działa raz i wygasa po 7 dniach.';

  @override
  String get familyInviteAction => 'Utwórz link z zaproszeniem';

  @override
  String get familyCreatingInvite => 'Tworzę zaproszenie…';

  @override
  String get familyInviteReady => 'Link z zaproszeniem gotowy';

  @override
  String get familyInviteValidity =>
      'Działa raz i wygasa najpóźniej po 7 dniach.';

  @override
  String get familyInviteKeyWarning =>
      'Link zawiera klucz do ściany: każdy, kto go otworzy, może dołączyć i czytać ścianę. Wyślij go tylko osobie, którą zapraszasz.';

  @override
  String get familyInviteShare => 'Udostępnij link';

  @override
  String get familyInviteCopy => 'Kopiuj link';

  @override
  String get familyInviteCopied => 'Link skopiowany.';

  @override
  String get familyInviteShareFailed =>
      'Udostępnianie jest niedostępne. Skopiuj link.';

  @override
  String familyInviteSubject(String family) {
    return 'Dołącz do: $family w LifeThreads';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'Dołącz do naszej ściany rodzinnej „$family” w LifeThreads: $link';
  }

  @override
  String get familyMembersTitle => 'Członkowie';

  @override
  String get familyMemberActions => 'Działania dla członka';

  @override
  String get familyYou => 'Ty';

  @override
  String familyYouNamed(String name) {
    return '$name (ty)';
  }

  @override
  String get familyAMember => 'Członek';

  @override
  String get familyFormerMember => 'Były członek';

  @override
  String get familyBlocked => 'Zablokowany';

  @override
  String get familyBlock => 'Zablokuj';

  @override
  String get familyUnblock => 'Odblokuj';

  @override
  String familyBlockAuthor(String name) {
    return 'Zablokuj: $name';
  }

  @override
  String familyBlockQuestion(String name) {
    return 'Zablokować: $name?';
  }

  @override
  String get familyBlockBody =>
      'Nie zobaczysz już wspomnień tej osoby na żadnej ścianie rodzinnej. Nie zostanie o tym powiadomiona. Możesz ją odblokować na liście członków.';

  @override
  String get familyReport => 'Zgłoś';

  @override
  String get familyRemoveMember => 'Usuń ze ściany';

  @override
  String familyRemoveQuestion(String name) {
    return 'Usunąć: $name?';
  }

  @override
  String get familyRemoveBody =>
      'Ta osoba straci dostęp do tej ściany. Zaproś ją ponownie, by wróciła.';

  @override
  String get familyRemoveDeleteContent =>
      'Usuń też dodane przez nią wspomnienia';

  @override
  String get familyDeleteTitle => 'Usuń ścianę rodzinną';

  @override
  String get familyDeleteBody =>
      'Jako właściciel nie możesz opuścić ściany; możesz ją usunąć dla wszystkich.';

  @override
  String get familyDeleteAction => 'Usuń ścianę';

  @override
  String familyDeleteQuestion(String family) {
    return 'Usunąć: $family?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'Wszystkie wspomnienia i zdjęcia z tej ściany zostaną usunięte z naszych serwerów dla każdego członka. Nie da się tego cofnąć. Wspomnienia z Mojej ściany pozostaną nienaruszone.';

  @override
  String get familyDeleting => 'Usuwam…';

  @override
  String get familyLeaveTitle => 'Opuść ścianę rodzinną';

  @override
  String get familyLeaveBody =>
      'Przestaniesz widzieć tę ścianę. Dodane przez siebie wspomnienia możesz zachować lub usunąć.';

  @override
  String get familyLeaveAction => 'Opuść';

  @override
  String familyLeaveQuestion(String family) {
    return 'Opuścić: $family?';
  }

  @override
  String get familyLeaveConfirmBody =>
      'Aby wrócić, potrzebujesz nowego zaproszenia.';

  @override
  String get familyLeaveDeleteMine => 'Usuń też dodane przeze mnie wspomnienia';

  @override
  String get familyLeaving => 'Opuszczam…';

  @override
  String get familySignInTitle => 'Logowanie';

  @override
  String get familySignInHeadline => 'Konto do ścian rodzinnych';

  @override
  String get familySignInWhy =>
      'Ściana rodzinna jest wspólna, więc potrzebuje konta: członkowie widzą, kto dodał każde wspomnienie, i tylko członkowie mogą ją otworzyć.';

  @override
  String get familySignInMyWallStays =>
      'Moja ściana nie potrzebuje konta. Zostaje prywatna na tym urządzeniu i nigdy nie jest wysyłana.';

  @override
  String get familySignInEncrypted =>
      'Rodzinne wspomnienia i zdjęcia są szyfrowane end-to-end. GK Coding je przechowuje, ale nie może ich odczytać.';

  @override
  String get familySignInWhatWeGet =>
      'Od Apple lub Google bierzemy tylko identyfikator konta, a nie kontakty czy zdjęcia.';

  @override
  String get familySignInApple => 'Zaloguj się przez Apple';

  @override
  String get familySignInGoogle => 'Zaloguj się przez Google';

  @override
  String get familySignInFinePrint =>
      'Logując się, akceptujesz Warunki korzystania i Politykę prywatności. Konto możesz w każdej chwili usunąć w aplikacji.';

  @override
  String get familyAccountTitle => 'Konto';

  @override
  String get familySignedOutTitle => 'Nie zalogowano';

  @override
  String get familySignedOutBody =>
      'Zaloguj się, by zobaczyć swoje ściany rodzinne. Moja ściana działa bez konta.';

  @override
  String get familySignedInTitle => 'Zalogowano';

  @override
  String get familySignedInBody =>
      'Twoje konto służy tylko do ścian rodzinnych.';

  @override
  String familyAccountId(String id) {
    return 'ID konta: $id';
  }

  @override
  String get familySignOut => 'Wyloguj się';

  @override
  String get familySignOutQuestion => 'Wylogować się?';

  @override
  String get familySignOutBody =>
      'Ściany rodzinne i ich klucze znikną z tego urządzenia do ponownego zalogowania. Na serwerze nic nie jest usuwane. Moja ściana pozostaje nienaruszona.';

  @override
  String get familySigningOut => 'Wylogowuję…';

  @override
  String get familyDeleteAccountTitle => 'Usuń konto';

  @override
  String get familyDeleteAccountBody =>
      'Usuwa twoje konto i dane ścian rodzinnych z naszych serwerów. Moja ściana zostaje na tym urządzeniu.';

  @override
  String get familyDeleteAccount => 'Usuń konto';

  @override
  String get familyDeleteAccountQuestion => 'Usunąć konto?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Twoje ściany rodzinne ($count) zostaną usunięte dla wszystkich członków, ze wszystkimi wspomnieniami i zdjęciami.',
      many:
          'Twoje ściany rodzinne ($count) zostaną usunięte dla wszystkich członków, ze wszystkimi wspomnieniami i zdjęciami.',
      few:
          'Twoje ściany rodzinne ($count) zostaną usunięte dla wszystkich członków, ze wszystkimi wspomnieniami i zdjęciami.',
      one:
          'Twoje ściany rodzinne ($count) zostaną usunięte dla wszystkich członków, ze wszystkimi wspomnieniami i zdjęciami.',
      zero: 'Nie jesteś właścicielem żadnej ściany rodzinnej.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'Wspomnienia i zdjęcia dodane przez ciebie na ściany innych rodzin zostaną usunięte, a ty opuścisz te ściany.';

  @override
  String get familyDeleteAccountKeys =>
      'Klucze ścian rodzinnych i zapisane zdjęcia znikną z tego urządzenia. Nie da się tego cofnąć.';

  @override
  String get familyDeleteAccountMyWall =>
      'Moja ściana pozostaje nienaruszona: jej wspomnienia zostają na tym urządzeniu.';

  @override
  String get familyDeleteAccountSubscription =>
      'To nie anuluje subskrypcji Premium; zarządzaj nią w App Store lub Google Play.';

  @override
  String get familyDeleteAccountUnderstood =>
      'Rozumiem, że to usunie moje konto na zawsze.';

  @override
  String get familyDeletingAccount => 'Usuwam twoje konto…';

  @override
  String get familyAccountDeleted => 'Twoje konto zostało usunięte.';

  @override
  String get familyTermsTitle => 'Zasady ściany rodzinnej';

  @override
  String get familyTermsHeadline => 'Zanim udostępnisz';

  @override
  String get familyTermsIntro =>
      'Ściany rodzinne są dla osób, które zapraszasz. Aby były bezpieczne, każdy akceptuje te zasady:';

  @override
  String get familyTermsZeroTolerance =>
      'Zero tolerancji dla niestosownych treści: żadnego nękania, nienawiści, treści seksualnych, przemocy, samookaleczeń, treści nielegalnych ani cudzych prywatnych danych bez zgody.';

  @override
  String get familyTermsOwnContent =>
      'Udostępniaj tylko zdjęcia i historie, do których masz prawo.';

  @override
  String get familyTermsReport =>
      'Zgłoś dowolne wspomnienie lub członka prosto ze ściany. GK Coding sprawdza zgłoszenia w ciągu 24 godzin.';

  @override
  String get familyTermsBlock =>
      'Zablokuj członka, by nie widzieć jego wspomnień.';

  @override
  String get familyTermsOwner =>
      'Właściciel ściany może usuwać członków i ich wspomnienia.';

  @override
  String get familyTermsConsequences =>
      'Treści łamiące te zasady są usuwane, a konta, które je opublikowały, mogą zostać zawieszone lub usunięte.';

  @override
  String get familyTermsReadFull => 'Przeczytaj pełne warunki';

  @override
  String get familyTermsAgree => 'Akceptuję Warunki korzystania i te zasady.';

  @override
  String get familyTermsAccept => 'Akceptuj i kontynuuj';

  @override
  String familyTermsVersion(String version) {
    return 'Wersja warunków $version';
  }

  @override
  String get familyWallEmptyTitle => 'Ściana czeka';

  @override
  String get familyWallEmptyBody =>
      'Dodaj pierwsze wspomnienie. Zobaczą je wszyscy na tej ścianie.';

  @override
  String get familyWallGoneBody =>
      'Ta ściana rodzinna nie jest już dla ciebie dostępna. Mogła zostać usunięta albo usunięto cię z niej.';

  @override
  String get familyAddMemory => 'Dodaj wspomnienie';

  @override
  String get familyRefresh => 'Odśwież';

  @override
  String get familySyncing => 'Synchronizuję…';

  @override
  String get familyOffline => 'Offline: pokazuję zapisane wspomnienia';

  @override
  String get familySyncFailed => 'Synchronizacja nieudana';

  @override
  String get familyMemoryTitle => 'Wspomnienie';

  @override
  String get familyMemoryGone => 'Tego wspomnienia nie ma już na ścianie.';

  @override
  String get familyMemoryActions => 'Działania dla wspomnienia';

  @override
  String familyAddedBy(String name) {
    return 'Dodane przez: $name';
  }

  @override
  String get familyDeleteMemoryQuestion => 'Usunąć to wspomnienie?';

  @override
  String get familyDeleteMemoryBody =>
      'Zniknie ze ściany dla wszystkich, razem ze zdjęciami.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'Jako właściciel możesz usuwać wspomnienia z tej ściany. To wspomnienie ($name) zniknie dla wszystkich, razem ze zdjęciami.';
  }

  @override
  String get familyDeletingMemory => 'Usuwam wspomnienie…';

  @override
  String get familyNoPhotosYet => 'Brak zdjęć';

  @override
  String get familyPostNote =>
      'To wspomnienie zobaczą wszyscy na tej ścianie. Zdjęcia są zmniejszane i szyfrowane na twoim telefonie przed wysłaniem.';

  @override
  String get familyPost => 'Opublikuj';

  @override
  String get familyPostMemory => 'Opublikuj na ścianie';

  @override
  String get familyUploading => 'Szyfruję i wysyłam…';

  @override
  String get familyMemorySaved => 'Zapisano na ścianie rodzinnej.';

  @override
  String get familyConflictTitle => 'Zmienione przez kogoś innego';

  @override
  String get familyConflictBody =>
      'To wspomnienie zmieniło się na innym urządzeniu, gdy je edytowałeś. Wczytać najnowszą wersję i zapisać na niej twoje zmiany?';

  @override
  String get familyConflictRetry => 'Odśwież i zapisz';

  @override
  String get familyQuotaTitle => 'Ściana jest pełna';

  @override
  String get familyReportMemoryTitle => 'Zgłoś wspomnienie';

  @override
  String get familyReportPhotoTitle => 'Zgłoś zdjęcie';

  @override
  String get familyReportMemberTitle => 'Zgłoś członka';

  @override
  String get familyReportIntro =>
      'Powiedz, co jest nie tak. Zgłoszenie trafia do GK Coding, a nie do zgłaszanej osoby.';

  @override
  String get familyReportSpam => 'Spam lub oszustwo';

  @override
  String get familyReportHarassment => 'Nękanie lub dręczenie';

  @override
  String get familyReportHate => 'Mowa nienawiści';

  @override
  String get familyReportSexual => 'Treści seksualne lub nagość';

  @override
  String get familyReportViolence => 'Przemoc lub groźby';

  @override
  String get familyReportSelfHarm => 'Samookaleczenie lub samobójstwo';

  @override
  String get familyReportIllegal => 'Treści nielegalne';

  @override
  String get familyReportPrivacy => 'Prywatne dane udostępnione bez zgody';

  @override
  String get familyReportOther => 'Coś innego';

  @override
  String get familyReportDetailsLabel => 'Szczegóły (opcjonalnie)';

  @override
  String get familyReportDetailsHint => 'Co powinniśmy wiedzieć?';

  @override
  String familyReportAlsoBlock(String name) {
    return 'Zablokuj też: $name';
  }

  @override
  String get familyReportSend => 'Wyślij zgłoszenie';

  @override
  String get familyReportReviewNote =>
      'GK Coding sprawdza każde zgłoszenie w ciągu 24 godzin i usuwa treści oraz członków łamiących zasady.';

  @override
  String get familyReportSentTitle => 'Dziękujemy';

  @override
  String get familyReportSentBody =>
      'Zgłoszenie wysłane. GK Coding sprawdzi je w ciągu 24 godzin i zareaguje na treści łamiące zasady.';

  @override
  String get familyErrorGeneric => 'Coś poszło nie tak. Spróbuj ponownie.';

  @override
  String get familyErrorOffline =>
      'Wygląda na to, że jesteś offline. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get familyErrorSubscriptionRequired =>
      'To wymaga aktywnej subskrypcji Premium właściciela ściany.';

  @override
  String get familyErrorInviteExpired =>
      'To zaproszenie wygasło. Poproś o nowy link.';

  @override
  String get familyErrorInviteUsed =>
      'To zaproszenie zostało już użyte. Każdy link działa raz; poproś o nowy.';

  @override
  String get familyErrorInviteInvalid =>
      'To nie jest prawidłowy link z zaproszeniem LifeThreads.';

  @override
  String get familyErrorAlreadyMember =>
      'Jesteś już członkiem tej ściany rodzinnej.';

  @override
  String get familyErrorFamilyFull =>
      'Ta ściana rodzinna osiągnęła limit członków.';

  @override
  String get familyErrorQuotaExceeded =>
      'Na tej ścianie rodzinnej nie ma już miejsca. Usuń część wspomnień lub zdjęć.';

  @override
  String get familyErrorVersionConflict =>
      'Ktoś zmienił to wspomnienie wcześniej. Odśwież i spróbuj ponownie.';

  @override
  String get familyErrorTermsRequired =>
      'Najpierw zaakceptuj zasady ściany rodzinnej.';

  @override
  String get familyErrorSignedOut => 'Wylogowano cię. Zaloguj się ponownie.';

  @override
  String get familyErrorNotAllowed => 'Nie możesz tego zrobić na tej ścianie.';

  @override
  String get familyErrorNotFound => 'Nie znaleziono ściany rodzinnej';

  @override
  String get familyErrorOwnerCannotLeave =>
      'Właściciel nie może opuścić ściany, ale może ją usunąć.';

  @override
  String get familyPaste => 'Wklej';

  @override
  String get familyErrorInviteRevoked =>
      'To zaproszenie zostało wycofane. Poproś o nowy link.';

  @override
  String get familyErrorKeyMissing =>
      'To urządzenie nie ma klucza do tej ściany rodzinnej (np. po ponownej instalacji lub na nowym telefonie). Poproś członka o nowy link z zaproszeniem: po jego otwarciu odzyskasz dostęp.';

  @override
  String get familyErrorSignInUnavailable =>
      'Logowanie nie jest teraz dostępne na tym urządzeniu.';

  @override
  String get familyErrorNoPurchase =>
      'Nie znaleziono zakupu Premium na tym koncie App Store lub Google Play. Najpierw kup Premium, potem spróbuj ponownie.';

  @override
  String get familyErrorVerificationUnavailable =>
      'Nie można teraz sprawdzić twojego Premium. Spróbuj później.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'Ten zakup Premium jest już powiązany z innym kontem ściany rodzinnej. Zaloguj się na to konto lub napisz na info@gkcoding.dev.';

  @override
  String get familyErrorNameTooLong => 'Ta nazwa jest za długa. Użyj krótszej.';

  @override
  String get familyErrorContentNotAllowed =>
      'Tekst zawiera słowa niedozwolone na ścianach rodzinnych. Zmień go i spróbuj ponownie.';

  @override
  String get familyErrorPhotoUnreadable =>
      'Nie udało się odczytać jednego ze zdjęć. Usuń je i spróbuj ponownie.';

  @override
  String get familyErrorTooLarge =>
      'To za dużo, by wysłać. Spróbuj z mniejszą liczbą lub mniejszymi zdjęciami.';

  @override
  String get familyReportEvidenceNote =>
      'Do weryfikacji GK Coding otrzymuje wraz ze zgłoszeniem tytuł i historię tego wspomnienia. Zdjęcia nigdy nie są wysyłane.';

  @override
  String get moveLeft => 'Przesuń w lewo';

  @override
  String get moveUp => 'Przesuń w górę';

  @override
  String get moveDown => 'Przesuń w dół';

  @override
  String get moveRight => 'Przesuń w prawo';

  @override
  String get showPassword => 'Pokaż hasło';

  @override
  String get hidePassword => 'Ukryj hasło';

  @override
  String get removePerson => 'Usuń osobę';

  @override
  String get draftKept => 'Zachowano jako szkic – będzie tu następnym razem.';

  @override
  String get draftResumeTitle => 'Kontynuować od miejsca, w którym skończyłeś?';

  @override
  String draftResumeBody(String date) {
    return 'Zacząłeś wspomnienie $date i jeszcze go nie zapisałeś.';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zdjęcia',
      many: '$count zdjęć',
      few: '$count zdjęcia',
      one: '$count zdjęcie',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => 'Kontynuuj szkic';

  @override
  String get draftStartNew => 'Zacznij od nowa';

  @override
  String get lookBackMenu => 'Wróć do miesiąca';

  @override
  String lookBackTitle(String month) {
    return 'Twój miesiąc: $month';
  }

  @override
  String get lookBackWallCardTitle => 'Twój miesiąc we wspomnieniach';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wspomnienia',
      many: '$count wspomnień',
      few: '$count wspomnienia',
      one: '$count wspomnienie',
    );
    return '$month: $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wspomnienia',
      many: '$count wspomnień',
      few: '$count wspomnienia',
      one: '$count wspomnienie',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osoby',
      many: '$count osób',
      few: '$count osoby',
      one: '$count osoba',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miejsca',
      many: '$count miejsc',
      few: '$count miejsca',
      one: '$count miejsce',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => 'Kto był obok';

  @override
  String get lookBackPlacesHeading => 'Gdzie byłeś';

  @override
  String lookBackEmpty(String month) {
    return 'Brak zapisów z okresu: $month.';
  }

  @override
  String get lookBackEmptyHint =>
      'Tu pojawią się wspomnienia z datą z tego miesiąca.';

  @override
  String get lookBackPreviousMonth => 'Poprzedni miesiąc';

  @override
  String get lookBackNextMonth => 'Następny miesiąc';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wspomnienia',
      many: '$count wspomnień',
      few: '$count wspomnienia',
      one: '$count wspomnienie',
    );
    return '$month: $_temp0 do przypomnienia.';
  }

  @override
  String get lookBackNotificationPrivate =>
      'Twój miesiąc we wspomnieniach jest gotowy.';

  @override
  String get homeWidgetLocked => 'Otwórz LifeThreads, by zobaczyć wspomnienia.';

  @override
  String get homeWidgetSettingsTitle => 'Widżet na ekranie głównym';

  @override
  String get homeWidgetSettingsSubtitle => 'Które wspomnienia pokazuje';

  @override
  String get homeWidgetPreviewTitle => 'Dziś w twoim widżecie';

  @override
  String get homeWidgetSourceTitle => 'Które wspomnienia';

  @override
  String get homeWidgetAllWalls => 'Wszystkie moje ściany';

  @override
  String get homeWidgetOrderTitle => 'Najpierw pokazuj';

  @override
  String get homeWidgetOnThisDayFirst => 'Najpierw Tego dnia';

  @override
  String get homeWidgetOnThisDayFirstBody =>
      'Najpierw wspomnienie z tego dnia z wcześniejszego roku.';

  @override
  String get homeWidgetPhotosFirst => 'Najpierw wspomnienia ze zdjęciami';

  @override
  String get homeWidgetPhotosFirstBody =>
      'Inne tylko wtedy, gdy żadne nie ma zdjęcia.';

  @override
  String get homeWidgetHowToTitle => 'Dodaj go do ekranu głównego';

  @override
  String get homeWidgetHowToIos =>
      'Przytrzymaj ikonę LifeThreads na ekranie głównym i wybierz rozmiar widżetu. Albo przytrzymaj puste miejsce, stuknij Edytuj › Dodaj widżet i wybierz LifeThreads.';

  @override
  String get homeWidgetHowToAndroid =>
      'Przytrzymaj puste miejsce na ekranie głównym, stuknij Widżety i przeciągnij LifeThreads, gdzie chcesz.';

  @override
  String get homeWidgetPrivacyNote =>
      'Ukryte wspomnienia nigdy nie pojawiają się w widżecie. Przy włączonej blokadzie aplikacji nie pokazuje żadnego wspomnienia.';

  @override
  String get yearThreadAlmostThere => 'Już prawie';

  @override
  String get yearThreadMemoriesFrom => 'Wspomnienia z';

  @override
  String yearThreadAddMemoryTo(String year) {
    return 'Dodaj wspomnienie do roku $year';
  }

  @override
  String get onboardingHangTitle => 'Wieszaj wspomnienia';

  @override
  String get onboardingHangText =>
      'Zdjęcie, miejsce, ludzie, którzy tam byli – twoja ściana rośnie razem z życiem.';

  @override
  String get onboardingConnectTitle => 'Połącz je nićmi';

  @override
  String get onboardingConnectText =>
      'Powiedz, dlaczego dwie chwile należą do siebie. Nici pokażą, jak układa się twoja historia.';

  @override
  String get onboardingComeBackTitle => 'Wspomnienia wracają';

  @override
  String get onboardingComeBackText =>
      'Tego dnia, twój miesiąc we wspomnieniach, twój rok jako film – i widżet na ekranie głównym.';

  @override
  String get onboardingPrivateText =>
      'Bez konta. Wszystko zostaje na telefonie – jeśli chcesz, z Face ID.';

  @override
  String get onboardingNameStaysHere =>
      'Tylko do powitania – zostaje na tym telefonie.';

  @override
  String get tutorialLookBackTitle => 'Szukaj i wracaj';

  @override
  String get tutorialLookBackText =>
      'Szukaj po tytule, miejscu, osobie lub roku. Więcej › Wróć do miesiąca pokazuje wspomnienia z miesiąca; Więcej › Nić roku zamienia rok w film.';

  @override
  String get tutorialStoryTitle => 'Utwórz historię';

  @override
  String get tutorialStoryText =>
      'Więcej › Utwórz historię: wybierz wspomnienia, szablon i muzykę, a potem udostępnij jako obraz lub wideo.';

  @override
  String get tutorialWallsTitle => 'Ściany i ukryte wspomnienia';

  @override
  String get tutorialWallsText =>
      'Więcej › Nowa ściana oddziela podróże lub etapy życia (Premium). Przytrzymaj kartę › Ukryj, by zniknęła z widoku; Widok › Ukryte wspomnienia pokaże ją po Face ID.';

  @override
  String get tutorialFamilyTitle => 'Dziel się z rodziną';

  @override
  String get tutorialFamilyText =>
      'Więcej › Ściany rodzinne: jedna ściana dla całej rodziny, szyfrowana end-to-end. Zapraszaj innych linkiem.';

  @override
  String get tutorialWidgetTitle => 'Wspomnienie na ekranie głównym';

  @override
  String get tutorialWidgetText =>
      'Dodaj widżet LifeThreads: każdego dnia inne wspomnienie. W Ustawienia › Widżet na ekranie głównym wybierzesz, które.';

  @override
  String photoNumber(int number) {
    return 'Zdjęcie $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'Nie udało się zapisać twojego imienia na tej ścianie. Możesz je ustawić w ustawieniach ściany.';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zawiera $count wspomnienia.',
      many: 'Zawiera $count wspomnień.',
      few: 'Zawiera $count wspomnienia.',
      one: 'Zawiera $count wspomnienie.',
    );
    return '$_temp0 Wspomnienia, które już są na twoich ścianach, zostaną i nie zdublują się.';
  }

  @override
  String get importAction => 'Importuj';

  @override
  String get familyRemovingMember => 'Usuwam i zabezpieczam ścianę…';

  @override
  String get tourSkip => 'Pomiń';

  @override
  String get tourNext => 'Dalej';

  @override
  String get tourDone => 'Gotowe';

  @override
  String get tourTapIt => 'Stuknij';

  @override
  String get tourEnd => 'Zakończ przewodnik';

  @override
  String get tourShowMeHow => 'Pokaż mi';

  @override
  String get tourShowMeHowSubtitle =>
      'Krótki przewodnik z przykładowymi wspomnieniami';

  @override
  String get tourWelcomeTitle => 'Witaj na swojej ścianie';

  @override
  String get tourWelcomeBody =>
      'Przejdźmy razem przez LifeThreads z przykładowymi wspomnieniami i zdjęciami. Podążaj za złotym kółkiem. Na końcu zdecydujesz, czy je zostawić.';

  @override
  String get tourCardTitle => 'Każda karta to wspomnienie';

  @override
  String get tourCardBody =>
      'Zdjęcia, historia, miejsce i to, jak się czułeś. Przeciągaj karty, by je układać, rozsuń palce, by przybliżyć. Stuknij tę, by ją otworzyć.';

  @override
  String get tourConnectTitle => 'Łącz wspomnienia';

  @override
  String get tourConnectBody =>
      'Nici wiążą chwile: podróż z osobą, miejsce z uczuciem. Stuknij Połącz.';

  @override
  String get tourConnectionsTitle => 'Wybierz, co do siebie pasuje';

  @override
  String get tourConnectionsBody =>
      'Wybierz inne wspomnienia i napisz, dlaczego należą do siebie. Wtedy nić zawiśnie między kartami na twojej ścianie.';

  @override
  String get tourAddTitle => 'Zapisz nową chwilę';

  @override
  String get tourAddBody => 'Stuknij +, by dodać coś do ściany.';

  @override
  String get tourAddMemoryTitle => 'Wspomnienie';

  @override
  String get tourAddMemoryBody =>
      'Wybierz Wspomnienie. Możesz też przypiąć notatkę lub gwoździk, by pogrupować karty.';

  @override
  String get tourAddTextTitle => 'Wystarczy kilka słów';

  @override
  String get tourAddTextBody =>
      'Dodaliśmy dla ciebie przykładowe zdjęcie i tytuł. Zwykle wybierasz własne zdjęcia albo robisz nowe. Data i miejsce pochodzą ze zdjęcia.';

  @override
  String get tourSaveTitle => 'Powieś na ścianie';

  @override
  String get tourSaveBody =>
      'Stuknij Zapisz teraz. Uczucia, osoby i nici mogą przyjść później.';

  @override
  String get tourCameraTitle => 'Szybkie zdjęcie';

  @override
  String get tourCameraBody =>
      'Aparat od razu zapisuje chwilę. Słowa dodasz później.';

  @override
  String get tourViewTitle => 'Różne widoki';

  @override
  String get tourViewBody => 'Stuknij Widok.';

  @override
  String get tourViewModesTitle => 'Ściana, oś czasu, mapa';

  @override
  String get tourViewModesBody =>
      'Zobacz swoje życie jako ścianę, oś czasu albo na mapie. Tu filtrujesz według kategorii i pokazujesz ukryte wspomnienia (z Face ID).';

  @override
  String get tourViewDoneTitle => 'Wróć do ściany';

  @override
  String get tourViewDoneBody => 'Stuknij Gotowe.';

  @override
  String get tourSearchTitle => 'Znajdź każde wspomnienie';

  @override
  String get tourSearchBody =>
      'Wpisz tu imię, miejsce, osobę lub rok. Wyniki pojawiają się w trakcie pisania.';

  @override
  String get tourMoreTitle => 'Wszystko inne';

  @override
  String get tourMoreBody =>
      'Historie, twój rok, powroty, kolejne ściany i ustawienia są w tym menu. Stuknij je.';

  @override
  String get tourStoryTitle => 'Utwórz historię';

  @override
  String get tourStoryBody => 'Stuknij Utwórz historię.';

  @override
  String get tourYearTitle => 'Nić roku';

  @override
  String get tourYearBody =>
      'Twój rok jako krótki film z muzyką: wspomnienia po kolei, a potem miejsca, osoby i uczucia roku (Premium).';

  @override
  String get tourLookBackTitle => 'Wróć do miesiąca';

  @override
  String get tourLookBackBody =>
      'Każdy miesiąc we wspomnieniach, z osobami i miejscami. Tego dnia przypomina ci wcześniejsze lata (Premium).';

  @override
  String get tourWallsTitle => 'Więcej ścian';

  @override
  String get tourWallsBody =>
      'Ściana dla każdego dziecka, podróży czy projektu (Premium). Stuknij nazwę na górze, by zmienić ścianę.';

  @override
  String get tourFamilyTitle => 'Ściany rodzinne';

  @override
  String get tourFamilyBody =>
      'Wspólna ściana, na której każdy dodaje swoje chwile, szyfrowana end-to-end. Premium potrzebuje tylko twórca; rodzina dołącza za darmo.';

  @override
  String get tourSettingsTitle => 'Ustawienia';

  @override
  String get tourSettingsBody =>
      'Zrób darmową kopię wszystkiego, zablokuj aplikację Face ID, ustaw widżet i Tego dnia, i wybierz język.';

  @override
  String get tourFinishTitle => 'To wszystko!';

  @override
  String get tourFinishBody =>
      'Już wiesz, jak się poruszać. Teraz zrób tę ścianę swoją.';

  @override
  String get tourDemoPhotoTitle => 'Dzień nad jeziorem';

  @override
  String get tourRemoveDemoTitle => 'Zacząć własną ścianę?';

  @override
  String get tourRemoveDemoBody =>
      'Przewodnik użył przykładowych wspomnień i zdjęć. Usunąć je teraz i zacząć od własnych zdjęć?';

  @override
  String get tourRemoveDemoRemove => 'Usuń i zacznij';

  @override
  String get tourRemoveDemoKeep => 'Na razie zostaw';

  @override
  String get tourRemovedToast =>
      'Przykłady usunięte. Twoja ściana jest gotowa.';

  @override
  String get storyTemplatePolaroid => 'Polaroid';

  @override
  String get storyTemplateAlbum => 'Album';

  @override
  String get storyTemplateFilmstrip => 'Taśma filmowa';

  @override
  String get storyTemplateTimeline => 'Podróż w czasie';

  @override
  String get storyTemplatePostcard => 'Pocztówka';

  @override
  String get storyTemplateCinema => 'Kino';

  @override
  String get storyTemplateSingleHint =>
      'Każde wspomnienie na pełnym ekranie, jedno po drugim';

  @override
  String get storyTemplateThreadHint => 'Karty na ścianie połączone nicią';

  @override
  String get storyTemplateCollageHint => 'Wszystkie zdjęcia razem w siatce';

  @override
  String get storyTemplateQuoteHint => 'Twoje słowa piszą się same';

  @override
  String get storyTemplatePolaroidHint =>
      'Zdjęcia natychmiastowe spadają na stos';

  @override
  String get storyTemplateAlbumHint =>
      'Strony się przewracają, jedno zdjęcie na stronę';

  @override
  String get storyTemplateFilmstripHint => 'Taśma przesuwa się i przybliża';

  @override
  String get storyTemplateTimelineHint =>
      'Lata odliczają do każdego wspomnienia';

  @override
  String get storyTemplatePostcardHint =>
      'Każda pocztówka odwraca się do swojej historii';

  @override
  String get storyTemplateCinemaHint =>
      'Plansze tytułowe, powolny zoom i napisy końcowe';

  @override
  String get storyAnimationTitle => 'Animacja';

  @override
  String get storyAnimationPageTitle => 'Wybierz animację';

  @override
  String get storyAnimationExamples =>
      'Pokazane na przykładowych zdjęciach. Twoja historia użyje twoich wspomnień.';

  @override
  String get storyMusicPageTitle => 'Muzyka i długość';

  @override
  String get storyLengthTitle => 'Długość';

  @override
  String get storyLengthAuto => 'Auto';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds s';
  }

  @override
  String get storyMusicAll => 'Wszystkie';

  @override
  String get storyMusicPlay => 'Odtwórz';

  @override
  String get storyMusicPause => 'Pauza';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return 'Piosenka $song ▸ Wideo $video';
  }

  @override
  String get storyMusicSyncHint =>
      'Biała linia pokazuje, która sekunda piosenki gra z filmem. Znaczniki to miejsca, gdzie zaczyna się każde wspomnienie.';

  @override
  String get storyMusicLengthHint =>
      'Auto dopasowuje się do liczby wspomnień. Dłuższe filmy płyną wolniej.';

  @override
  String get tourBack => 'Wstecz';

  @override
  String get tourStoryPickTitle => 'Wybierz wspomnienia';

  @override
  String get tourStoryPickBody =>
      'Wybraliśmy dla ciebie trzy. Możesz wybrać do sześciu. Stuknij Dalej.';

  @override
  String get tourStoryAnimationTitle => 'Wybierz ruch';

  @override
  String get tourStoryAnimationBody =>
      'Animacje od Polaroidu po Kino. Stuknij Animacja.';

  @override
  String get tourStoryStyleTitle => 'Wypróbuj Polaroid';

  @override
  String get tourStoryStyleBody =>
      'Każdy kafelek odtwarza podgląd. Stuknij Polaroid.';

  @override
  String get tourStoryMusicTitle => 'Dodaj muzykę';

  @override
  String get tourStoryMusicBody =>
      'Wybierz piosenkę i długość filmu. Stuknij Muzyka.';

  @override
  String get tourStoryTrimTitle => 'Piosenka i film w zgodzie';

  @override
  String get tourStoryTrimBody =>
      'Przeciągnij złotą ramkę, by wybrać fragment piosenki. Biała linia przesuwa się z filmem, więc widzisz, która sekunda gra w danej chwili.';

  @override
  String get tourStoryMusicDoneTitle => 'Wróć do historii';

  @override
  String get tourStoryMusicDoneBody => 'Stuknij Gotowe.';

  @override
  String get tourStoryShareTitle => 'Udostępnij lub zapisz';

  @override
  String get tourStoryShareBody =>
      'Gotowe na Instagram, WhatsApp i nie tylko. Zapisywanie i udostępnianie to część Premium.';

  @override
  String get tourMoreAgainTitle => 'Więcej w menu';

  @override
  String get tourMoreAgainBody => 'Otwórz menu jeszcze raz. Stuknij je.';

  @override
  String get scannerStep1 =>
      'Na telewizorze, komputerze lub tablecie otwórz przeglądarkę.';

  @override
  String scannerStep2(Object url) {
    return 'Wejdź na $url. Pojawi się tam kod QR.';
  }

  @override
  String get scannerStep3 =>
      'Trzymaj telefon tak, by kod był w złotej ramce. Twoja ściana pojawi się tam na chwilę, tylko do oglądania.';

  @override
  String get scannerShareLink => 'Wyślij link';

  @override
  String get scannerCopyLink => 'Kopiuj link';

  @override
  String get scannerLinkCopied => 'Link skopiowany';

  @override
  String get storyTemplateScrapbook => 'Scrapbook';

  @override
  String get storyTemplateMosaic => 'Mozaika';

  @override
  String get storyTemplateContactSheet => 'Stykówka';

  @override
  String get storyTemplateWallFlight => 'Lot po ścianie';

  @override
  String get storyTemplateCarousel => 'Karuzela';

  @override
  String get storyTemplateJourney => 'Podróż';

  @override
  String get storyTemplateScrapbookHint =>
      'Każde zdjęcie przyklejone taśmą do strony';

  @override
  String get storyTemplateMosaicHint => 'Jedno duże zdjęcie, reszta dookoła';

  @override
  String get storyTemplateContactSheetHint =>
      'Każde wspomnienie to klatka filmu';

  @override
  String get storyTemplateWallFlightHint =>
      'Leci wzdłuż nici od karty do karty';

  @override
  String get storyTemplateCarouselHint =>
      'Karty się obracają, po jednej na przodzie';

  @override
  String get storyTemplateJourneyHint =>
      'Trasa na mapie, pinezka w każdym miejscu';

  @override
  String get storyModePicture => 'Obraz';

  @override
  String get storyModeVideo => 'Wideo';

  @override
  String get storyModePictureHint =>
      'Jeden obraz ze wszystkimi wspomnieniami, do postów i relacji.';

  @override
  String get storyModeVideoHint => 'Krótki film z ruchem i muzyką.';

  @override
  String get storyLayoutTitle => 'Układ';

  @override
  String get storyLayoutPageTitle => 'Wybierz układ';

  @override
  String get storyChoosePhoto => 'Wybierz zdjęcie do relacji';

  @override
  String get wallTidyUp => 'Uporządkuj ścianę';

  @override
  String get wallTidyUpBody =>
      'Powiesić wszystkie karty równo w rzędach, od najstarszego wspomnienia do najnowszego? Notatki i gwoździe zostaną na miejscu.';

  @override
  String get wallTidyUpAction => 'Uporządkuj';

  @override
  String get wallTidiedToast => 'Twoja ściana jest uporządkowana.';

  @override
  String get storyFormatTitle => 'Format';

  @override
  String get storyFormatStory => 'Relacja 9:16';

  @override
  String get storyFormatPost => 'Post 4:5';

  @override
  String get storyFormatSquare => 'Kwadrat 1:1';
}
