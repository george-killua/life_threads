// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get send => 'Senden';

  @override
  String get preparing => 'Wird vorbereitet...';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get languageTitle => 'Sprache';

  @override
  String get languageBody =>
      'Wähle die App-Sprache. System folgt der Sprache deines Telefons, wenn LifeThreads sie unterstützt.';

  @override
  String get systemLanguage => 'System';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return 'Sprache geändert zu $language.';
  }

  @override
  String get privacyTitle => 'Datenschutz';

  @override
  String get privacyBody =>
      'LifeThreads ist lokal zuerst: kein Konto und kein öffentliches Profil. Deine Erinnerungen bleiben auf diesem Gerät, außer du exportierst ein Backup, teilst eine verschlüsselte Kapsel oder zeigst deine Wand auf einem anderen Bildschirm.';

  @override
  String get viewPrivacyPolicy => 'Datenschutzerklärung ansehen';

  @override
  String get termsTitle => 'Nutzungsbedingungen';

  @override
  String get viewTerms => 'Bedingungen ansehen';

  @override
  String get betaFeedbackTitle => 'Beta-Feedback';

  @override
  String get betaFeedbackBody =>
      'Sende Beta-Feedback mit sicheren Diagnosedaten. Logs enthalten nur App-Ereignisse und Absturzarten, niemals Erinnerungstexte, Fotopfade, Backups oder genaue Orte.';

  @override
  String get closedBetaBadge => 'Closed Beta';

  @override
  String get sendFeedback => 'Feedback senden';

  @override
  String get backupArchiveBody =>
      'Sichere alles – Erinnerungen, Fotos, Notizen, Fäden und Layout – in einer Datei. Bewahre sie auf deinem Computer oder in deiner eigenen Cloud auf und verschlüssle sie mit einem Passwort.';

  @override
  String get backupArchiveTitle => 'Backup';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Freischalten';

  @override
  String get exportArchive => 'Archiv exportieren';

  @override
  String get importArchive => 'Archiv importieren';

  @override
  String get importCapsule => 'Kapsel importieren';

  @override
  String get moveDevices => 'Geräte wechseln';

  @override
  String get themeTitle => 'Design';

  @override
  String get themeBody =>
      'Wähle, wie sich deine private Wand anfühlen soll. Kostenlose Nutzer erhalten Warm Memory Room. Premium schaltet alle Wandstimmungen frei.';

  @override
  String get oneFreeBadge => '1 gratis';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'Premium-Abo ist aktiv.';

  @override
  String get premiumLockedBody =>
      'Jährlich oder monatlich: unbegrenzte Erinnerungen, mehrere Wände, Storys, Designs und Layouts.';

  @override
  String get activeBadge => 'Aktiv';

  @override
  String get openPremium => 'Premium öffnen';

  @override
  String get appVersionTitle => 'App-Version';

  @override
  String get clearAllDataTitle => 'Alle Daten löschen';

  @override
  String get clearAllDataBody =>
      'Löscht alle Erinnerungen, Verbindungen, Wandnotizen, Nägel und kopierten Fotos von diesem Gerät.';

  @override
  String get clearData => 'Daten löschen';

  @override
  String exportFailed(Object error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String importRejected(Object message) {
    return 'Import abgelehnt: $message';
  }

  @override
  String importFailed(Object error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'Löschen fehlgeschlagen: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'Kapsel abgelehnt: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'Kapsel-Import fehlgeschlagen: $error';
  }

  @override
  String get clearAllDataQuestion => 'Alle Daten löschen?';

  @override
  String get clearAllDataQuestionBody =>
      'Das entfernt dauerhaft alle lokalen LifeThreads-Daten auf diesem Gerät. Exportiere zuerst ein Backup, wenn du sie behalten willst.';

  @override
  String get clearAll => 'Alles löschen';

  @override
  String get allLocalDataCleared => 'Alle lokalen Daten wurden gelöscht.';

  @override
  String get feedbackGeneral => 'Allgemeines Feedback';

  @override
  String get feedbackBug => 'Bug';

  @override
  String get feedbackCrash => 'Absturz';

  @override
  String get feedbackDesign => 'Designproblem';

  @override
  String get feedbackMissingFeature => 'Fehlende Funktion';

  @override
  String get feedbackPerformance => 'Performance';

  @override
  String get betaFeedbackIntro =>
      'Schreibe, was passiert ist oder was sich falsch angefühlt hat. Sichere Diagnosedaten werden ohne private Erinnerungsinhalte angehängt.';

  @override
  String get feedbackType => 'Typ';

  @override
  String get feedbackLabel => 'Feedback';

  @override
  String get feedbackHint =>
      'Beispiel: Ich habe Add > Quick photo getippt und der Bildschirm ist eingefroren.';

  @override
  String get betaFeedbackNotIncluded =>
      'Nicht enthalten: Erinnerungstitel, Geschichten, Notizen, Fotopfade, Backup-Pfade, genaue Orte.';

  @override
  String get feedbackEmpty => 'Schreibe zuerst eine kurze Feedback-Nachricht.';

  @override
  String get feedbackCopied =>
      'Keine E-Mail-App geöffnet. Feedback wurde für info@gkcoding.dev in die Zwischenablage kopiert.';

  @override
  String themeSelected(Object theme) {
    return '$theme ausgewählt.';
  }

  @override
  String get onboardingHeadline => 'Baue deine lebendige Wand.';

  @override
  String get onboardingBody =>
      'Ein privater Erinnerungsraum, in dem Fotos, Orte, Menschen und kleine Notizen mit emotionalen Fäden zusammenhängen.';

  @override
  String get onboardingPrivacy =>
      'Deine Erinnerungen bleiben standardmäßig privat: kein Konto und kein öffentliches Profil. Optionales verschlüsseltes Cloud-Sharing und Backup nur, wenn du es wählst.';

  @override
  String get onboardingPrivacyShort =>
      'Kein Konto und kein öffentliches Profil. Deine Erinnerungen bleiben auf diesem Gerät, bis du etwas anderes wählst.';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingNameTitle => 'Wie sollen wir dich nennen?';

  @override
  String get onboardingNameHint => 'Dein Name';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'Schön, dich kennenzulernen, $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'So möchtest du starten';

  @override
  String get onboardingGetStartedBody =>
      'Sieh dir eine Beispielwand an oder beginne leer und hänge deine eigenen Erinnerungen auf.';

  @override
  String get settingsNameTitle => 'Dein Name';

  @override
  String get settingsNameBody =>
      'Wird als Begrüßung auf deiner Wand angezeigt.';

  @override
  String get settingsNameHint => 'Dein Name';

  @override
  String get settingsNameSaved => 'Name aktualisiert.';

  @override
  String get storyPrivacyTitle => 'Deine Erinnerungen bleiben privat';

  @override
  String get storyConnectTitle => 'Momente verbinden';

  @override
  String get storyConnectText =>
      'Verbinde Erinnerungen, Notizen und Orte, damit jedes Kapitel Kontext bekommt.';

  @override
  String get storyWallTitle => 'Baue deine lebendige Wand';

  @override
  String get storyWallText =>
      'Beginne mit einem Foto und lass die Wand zu etwas wachsen, das lebendig wirkt.';

  @override
  String get previewDemoWall => 'Demo-Wand ansehen';

  @override
  String get startFresh => 'Neu starten';

  @override
  String get optionalDemoPreview => 'Optionale Demo-Vorschau';

  @override
  String get quickTutorial => 'Kurzes Tutorial';

  @override
  String get tutorialIntro =>
      'Zuerst die Grundlagen – speichern, verbinden, anordnen – dann alles, was deine Wand sonst noch kann.';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get howItWorks => 'So funktioniert es';

  @override
  String get tutorialAddTitle => 'Erinnerung hinzufügen';

  @override
  String get tutorialAddText =>
      'Tippe auf +, wähle Erinnerung oder Schnellfoto und speichere Titel, Datum, Personen und Foto. Gehst du vor dem Speichern, bleibt sie als Entwurf.';

  @override
  String get tutorialConnectTitle => 'Erinnerungen verbinden';

  @override
  String get tutorialConnectText =>
      'Öffne eine Karte, tippe auf das Verbindungsicon, wähle verwandte Erinnerungen und ergänze kurz den Grund.';

  @override
  String get tutorialArrangeTitle => 'Wand arrangieren';

  @override
  String get tutorialArrangeText =>
      'Ziehe Karten, Notizen und Nägel an ihren Platz. Ansicht › Anordnen sortiert nach Datum, Kategorie oder Ort – übernommen mit Fertig.';

  @override
  String get tutorialShowBoardTitle => 'Board anzeigen';

  @override
  String get tutorialShowBoardText =>
      'Öffne lifethreads.gkcoding.dev/display auf einem anderen Bildschirm, wähle Mehr › Wand anzeigen und scanne den Code, um ein temporäres schreibgeschütztes Board zu zeigen.';

  @override
  String get tutorialBackupTitle => 'Privatsphäre und Backup';

  @override
  String get tutorialBackupText =>
      'Einstellungen › Privatsphäre › App-Sperre öffnet LifeThreads mit Face ID. Bevor du das Handy wechselst, exportiere ein Backup unter Einstellungen › Sicherung & Daten.';

  @override
  String get scanDisplayQr => 'Display-QR scannen';

  @override
  String get scannerHintTitle =>
      'Öffne lifethreads.gkcoding.dev/display auf einem anderen Bildschirm.';

  @override
  String get scannerHintBody =>
      'Scanne den QR-Code von dieser Seite. LifeThreads sendet einen temporären schreibgeschützten Board-Snapshot an diese Browser-Sitzung.';

  @override
  String get addMemoryBeforeDisplay =>
      'Füge eine Erinnerung hinzu, bevor du eine Wand anzeigst.';

  @override
  String get notLifeThreadsDisplayQr => 'Das ist kein LifeThreads-Display-QR.';

  @override
  String get displayWallQuestion => 'Diese Wand anzeigen?';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads sendet einen temporären schreibgeschützten Board-Snapshot mit $memoryCount Erinnerungen an die Browser-Sitzung, die du gescannt hast. Er öffnet sich auf lifethreads.gkcoding.dev/display und läuft automatisch ab.';
  }

  @override
  String get displayAction => 'Anzeigen';

  @override
  String get soon => 'bald';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'Wandanzeige ist live mit $memoryCount Erinnerungen bis $expires.';
  }

  @override
  String get preparingWallDisplay => 'Wandanzeige wird vorbereitet...';

  @override
  String get open => 'Öffnen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get done => 'Fertig';

  @override
  String get back => 'Zurück';

  @override
  String get continueAction => 'Weiter';

  @override
  String get close => 'Schließen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get saveReason => 'Grund speichern';

  @override
  String get chooseBackup => 'Backup wählen';

  @override
  String get chooseArchive => 'Archiv wählen';

  @override
  String get chooseCapsule => 'Kapsel wählen';

  @override
  String get exportAction => 'Exportieren';

  @override
  String get addToWall => 'Zur Wand hinzufügen';

  @override
  String get cinemaSkip => 'Überspringen';

  @override
  String get cinemaNotNow => 'Nicht jetzt';

  @override
  String get cinemaSharedChapter => 'Ein geteiltes Erinnerungs-Kapitel';

  @override
  String get cinemaConnectedThread => 'Verbundener Faden';

  @override
  String get cinemaInviteTitle => 'Diese Erinnerung zu deiner Wand hinzufügen?';

  @override
  String get useSelected => 'Auswahl verwenden';

  @override
  String photoGridItem(String date) {
    return 'Foto vom $date';
  }

  @override
  String get noPhotosFound => 'Keine Fotos gefunden.';

  @override
  String get manage => 'Verwalten';

  @override
  String get manageAccess => 'Zugriff verwalten';

  @override
  String get saveNow => 'Jetzt speichern';

  @override
  String get hangOnWall => 'An die Wand hängen';

  @override
  String get placeHere => 'Hier platzieren';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get viewPremium => 'Premium ansehen';

  @override
  String get memoryNotFound => 'Erinnerung nicht gefunden';

  @override
  String get memoryTypeMoment => 'Moment';

  @override
  String get memoryTypeTrip => 'Reise';

  @override
  String get memoryTypePerson => 'Person';

  @override
  String get memoryTypePlace => 'Ort';

  @override
  String get memoryTypeNote => 'Notiz';

  @override
  String get memoryTypeMomentDescription =>
      'Eine kleine Szene, die bleiben soll';

  @override
  String get memoryTypeTripDescription => 'Eine Reise oder ein Tag unterwegs';

  @override
  String get memoryTypePersonDescription => 'Jemand Wichtiges';

  @override
  String get memoryTypePlaceDescription => 'Ein Ort mit Bedeutung';

  @override
  String get memoryTypeNoteDescription =>
      'Ein Gedanke, Zitat oder eine Erinnerung';

  @override
  String get categoryPersonal => 'Persönlich';

  @override
  String get categoryFamily => 'Familie';

  @override
  String get categoryTravel => 'Reise';

  @override
  String get feelingWarm => 'Warm';

  @override
  String get feelingNostalgic => 'Nostalgisch';

  @override
  String get feelingProud => 'Stolz';

  @override
  String get feelingCalm => 'Ruhig';

  @override
  String get feelingImportant => 'Wichtig';

  @override
  String get feelingWarmDescription => 'Sanft, nah, voller Liebe.';

  @override
  String get feelingNostalgicDescription =>
      'Eine Erinnerung, die dich zurückzieht.';

  @override
  String get feelingProudDescription => 'Ein Moment, der etwas bewiesen hat.';

  @override
  String get feelingCalmDescription => 'Leise, sicher, friedlich.';

  @override
  String get feelingImportantDescription =>
      'Eine Erinnerung, die die Geschichte verändert hat.';

  @override
  String get addPeopleHint =>
      'Füge Menschen hinzu, die zu diesem Moment gehören. Kontakte bleiben lokal.';

  @override
  String get addPerson => 'Person hinzufügen';

  @override
  String get editPerson => 'Person bearbeiten';

  @override
  String get chooseFromContacts => 'Aus Kontakten wählen';

  @override
  String get personNameLabel => 'Name';

  @override
  String get personNameHint => 'Gespeicherte Personen suchen';

  @override
  String get relationshipLabel => 'Beziehung';

  @override
  String get relationshipHint => 'Freund, Mutter, Partner...';

  @override
  String get phoneOptionalLabel => 'Telefon (optional)';

  @override
  String get emailOptionalLabel => 'E-Mail (optional)';

  @override
  String get nameRelationshipRequired =>
      'Name und Beziehung sind erforderlich.';

  @override
  String get contactAccessDenied => 'Kontaktzugriff wurde nicht gewährt.';

  @override
  String get couldNotOpenContacts => 'Kontakte konnten nicht geöffnet werden.';

  @override
  String get chooseContact => 'Kontakt wählen';

  @override
  String get searchContacts => 'Kontakte suchen';

  @override
  String get noContactsFound => 'Keine Kontakte gefunden.';

  @override
  String get unnamedContact => 'Unbenannter Kontakt';

  @override
  String get contactRelationship => 'Kontakt';

  @override
  String get couldNotLoadContacts => 'Kontakte konnten nicht geladen werden.';

  @override
  String get saveMomentTitle => 'Moment speichern';

  @override
  String get todayEyebrow => 'Heute';

  @override
  String get addMemoryStepTitle =>
      'Was ist passiert, das du nicht verlieren willst?';

  @override
  String get addMemoryStepSubtitle =>
      'Schreibe eine Zeile, füge ein Foto hinzu, wenn du eines hast, und speichere. Details können warten.';

  @override
  String get momentLabel => 'Moment';

  @override
  String get momentHint =>
      'Abendessen mit Lara, erster Launch, ruhiger Spaziergang...';

  @override
  String get storyWorthLabel => 'Was machte es bewahrenswert?';

  @override
  String get storyWorthHint => 'Ein paar Worte reichen.';

  @override
  String get feelingEyebrow => 'Gefühl';

  @override
  String get feelingStepTitle =>
      'Wie soll es sich anfühlen, wenn es zurückkommt?';

  @override
  String get feelingStepSubtitle =>
      'So findest du die Erinnerung später leichter wieder.';

  @override
  String get contextEyebrow => 'Kontext';

  @override
  String get whenWasItTitle => 'Wann war es?';

  @override
  String get photoGpsStepSubtitle =>
      'Die Karte nutzt GPS aus ausgewählten Fotos. Hat ein Foto kein GPS, wird kein Ort angezeigt.';

  @override
  String get peopleThreadsEyebrow => 'Menschen & Fäden';

  @override
  String get peopleThreadsTitle => 'Wer oder was gehört dazu?';

  @override
  String get peopleThreadsSubtitle =>
      'Optionale Details machen aus einzelnen Momenten einen Lebensfaden.';

  @override
  String get connectExistingMemoryLabel =>
      'Mit bestehender Erinnerung verbinden';

  @override
  String get noConnectionYet => 'Noch keine Verbindung';

  @override
  String get connectionReasonLabel => 'Warum sind sie verbunden?';

  @override
  String get connectionReasonHint =>
      'Beispiel: gleiche Reise, gleiche Person, davor / danach...';

  @override
  String get writeMomentOrPhotoFirst =>
      'Schreibe einen Moment oder füge zuerst ein Foto hinzu.';

  @override
  String get todaysMoment => 'Heutiger Moment';

  @override
  String get savedFromTodaysPrompt => 'Aus der heutigen Frage gespeichert.';

  @override
  String get saveItBeforeItFades => 'Speichere es, bevor es verblasst';

  @override
  String get chooseDate => 'Datum wählen';

  @override
  String get dateLabel => 'Datum';

  @override
  String get untitledMemory => 'Unbenannte Erinnerung';

  @override
  String get organize => 'Organisieren';

  @override
  String get memoryShape => 'Erinnerungsform';

  @override
  String get wallCategory => 'Wandkategorie';

  @override
  String get privatePhotos => 'Private Fotos';

  @override
  String get pick => 'Wählen';

  @override
  String get addMore => 'Mehr hinzufügen';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get takePhotosNow => 'Jetzt Fotos aufnehmen';

  @override
  String get takePhotosFabTooltip => 'Fotos für eine neue Erinnerung aufnehmen';

  @override
  String get takeAnotherPhoto => 'Weiteres Foto aufnehmen';

  @override
  String get continueWithPhotos => 'Mit diesen Fotos weiter';

  @override
  String get addPhotosToMemory => 'Zur Erinnerung hinzufügen';

  @override
  String get takeAnotherOrContinueBody =>
      'Nimm weitere Fotos für diese Erinnerung auf oder fahre fort und ergänze die Geschichte.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos aufgenommen',
      one: '1 Foto aufgenommen',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads kopiert ausgewählte Fotos in den privaten App-Speicher und behält Datum/Ort-Metadaten, wenn vorhanden.';

  @override
  String get limitedPhotoAccessActive =>
      'Eingeschränkter Fotozugriff ist aktiv. Du kannst weitere erlaubte Fotos hinzufügen.';

  @override
  String get selectPhotos => 'Fotos auswählen';

  @override
  String get photoAccessOff => 'Fotozugriff ist aus';

  @override
  String get photoAccessOffBody =>
      'Aktiviere Fotozugriff, um Erinnerungen auszuwählen. Deine Fotos bleiben auf diesem Gerät.';

  @override
  String get freeMemoryLimitReached => 'Kostenloses Erinnerungslimit erreicht';

  @override
  String get freeMemoryLimitBody =>
      'Kostenlose Wände enthalten 30 Erinnerungen. Upgrade, um deine lebendige Wand weiterzubauen.';

  @override
  String get photoAccessNeeded => 'Fotozugriff wird zuerst benötigt.';

  @override
  String get quickPhotoMemory => 'Schnellfoto-Erinnerung';

  @override
  String get quickPhotoDescription =>
      'Ein Foto, das bleiben soll. Füge die Geschichte später hinzu.';

  @override
  String get hangQuickPhoto => 'Schnellfoto aufhängen';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'Foto-GPS erkannt: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'Kein Foto-GPS erkannt. Diese Erinnerung erscheint nicht auf der Karte.';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • $photoCount Foto(s)';
  }

  @override
  String metadataDates(int count, int total) {
    return '$count/$total Daten';
  }

  @override
  String metadataLocations(int count, int total) {
    return '$count/$total Orte';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total Größen';
  }

  @override
  String newSelected(int count) {
    return '$count neu ausgewählt';
  }

  @override
  String selectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get editMemoryTitle => 'Erinnerung bearbeiten';

  @override
  String get storyPanel => 'Geschichte';

  @override
  String get memoryTitleLabel => 'Erinnerungstitel';

  @override
  String get addTitleValidation => 'Titel hinzufügen';

  @override
  String get storyDescriptionLabel => 'Geschichte / Beschreibung';

  @override
  String get addStoryValidation => 'Kurze Geschichte hinzufügen';

  @override
  String get shapeFeelingTitle => 'Form und Gefühl';

  @override
  String get memoryTypeLabel => 'Erinnerungstyp';

  @override
  String get feelingLabel => 'Gefühl';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get timePhotoGpsTitle => 'Zeit und Foto-GPS';

  @override
  String get memoryDateLabel => 'Erinnerungsdatum';

  @override
  String get peopleTitle => 'Menschen';

  @override
  String get galleryTitle => 'Galerie';

  @override
  String get addPhotos => 'Fotos hinzufügen';

  @override
  String get saveMemory => 'Erinnerung speichern';

  @override
  String get memorySaveFailed =>
      'Die Erinnerung konnte nicht gespeichert werden. Bitte versuche es erneut.';

  @override
  String get passwordOnlySpaces =>
      'Ein Passwort darf nicht nur aus Leerzeichen bestehen.';

  @override
  String get somethingWentWrong =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get mapUnavailable => 'Die Karte ist gerade nicht verfügbar.';

  @override
  String get coverPhoto => 'Titelbild';

  @override
  String get galleryPhoto => 'Galeriefoto';

  @override
  String get setAsCover => 'Als Titelbild setzen';

  @override
  String get replacePhoto => 'Foto ersetzen';

  @override
  String get removePhoto => 'Foto entfernen';

  @override
  String get choosePhoto => 'Foto wählen';

  @override
  String get threadReasonsTitle => 'Faden-Gründe';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'Erstelle mehr Erinnerungen, bevor du verknüpfst.';

  @override
  String get connectionHeaderBody =>
      'Verbinde Erinnerungen mit einem Grund. Das Seil soll erklären, warum zwei Momente zusammengehören.';

  @override
  String get connectedMemory => 'verbundene Erinnerung';

  @override
  String get whyConnectedTitle => 'Warum sind sie verbunden?';

  @override
  String get exportPremiumArchiveTitle => 'Backup exportieren';

  @override
  String get importArchiveTitle => 'Archiv importieren';

  @override
  String get archiveExportBody =>
      'Füge ein Passwort hinzu, um das Archiv zu verschlüsseln. Leer lassen für eine normale lokale ZIP.';

  @override
  String get archiveImportBody =>
      'Wenn dieses Archiv verschlüsselt ist, gib das Passwort ein. Leer lassen für ältere oder ungeschützte Backups.';

  @override
  String get archivePasswordOptional => 'Archivpasswort (optional)';

  @override
  String get archivePasswordLabel => 'Archivpasswort';

  @override
  String get archivePasswordWarning =>
      'Bewahre das Passwort sicher auf. Es kann nicht wiederhergestellt werden, wenn du es verlierst.';

  @override
  String get sendArchiveTitle => 'LifeThreads-Archiv senden';

  @override
  String get sendArchiveSubject => 'LifeThreads Erinnerungsarchiv';

  @override
  String get sendEncryptedArchiveText =>
      'LifeThreads verschlüsseltes Archiv. Nutze das gewählte Passwort, um es auf einem anderen Gerät zu importieren.';

  @override
  String get sendArchiveText =>
      'LifeThreads-Archiv. Importiere es in LifeThreads, um deine Erinnerungswand auf einem anderen Gerät zu öffnen.';

  @override
  String get archiveReadyToSend =>
      'Backup bereit. Bewahre es sicher auf – nicht nur auf diesem Handy.';

  @override
  String get archiveNotSaved =>
      'Backup nicht gespeichert. Exportiere es erneut, wenn du so weit bist.';

  @override
  String get archiveSharingUnavailable =>
      'Teilen ist auf diesem Gerät nicht verfügbar.';

  @override
  String archiveShareFailed(Object error) {
    return 'Archiv gespeichert, aber Teilen fehlgeschlagen: $error';
  }

  @override
  String get archiveImportedTitle => 'Archiv importiert';

  @override
  String get memoriesLabel => 'Erinnerungen';

  @override
  String get photosLabel => 'Fotos';

  @override
  String get wallNotesNailsLabel => 'Wandnotizen / Nägel';

  @override
  String get connectionsLabel => 'Verbindungen';

  @override
  String get archiveImportSummary =>
      'Deine aktuelle Wand wurde behalten. Importierte Erinnerungen wurden sicher hinzugefügt.';

  @override
  String get shareEncryptedCapsuleTitle => 'Verschlüsselte Kapsel teilen';

  @override
  String get openSharedCapsuleTitle => 'Geteilte Kapsel öffnen';

  @override
  String get exportMemoryCapsuleTitle => 'Erinnerungskapsel exportieren';

  @override
  String get importCapsuleDialogTitle => 'Kapsel importieren';

  @override
  String get secureSharePasswordBody =>
      'Erstelle ein Passwort, bevor du diese Kapsel hochlädst. Sende das Passwort separat an die empfangende Person.';

  @override
  String get sharedCapsulePasswordBody =>
      'Gib das Passwort ein, das du für diese geteilte Erinnerung erhalten hast.';

  @override
  String get capsuleExportBody =>
      'Füge ein Passwort hinzu, wenn diese Erinnerung geschützt werden soll. Leer lassen für eine normale Kapsel.';

  @override
  String get capsuleImportBody =>
      'Wenn diese Kapsel ein Passwort hat, gib es ein. Sonst leer lassen.';

  @override
  String get capsulePasswordLabel => 'Kapselpasswort';

  @override
  String get sharedCapsulePasswordLabel => 'Passwort der geteilten Kapsel';

  @override
  String get capsulePasswordOptional => 'Kapselpasswort (optional)';

  @override
  String get capsulePasswordWarning =>
      'LifeThreads kann dieses Passwort später nicht wiederherstellen.';

  @override
  String get passwordRequiredCloudSharing =>
      'Für Cloud-Teilen ist ein Passwort erforderlich.';

  @override
  String get createSecureShare => 'Sicheren Share erstellen';

  @override
  String get previewMemory => 'Erinnerung ansehen';

  @override
  String get sendCapsuleTitle => 'LifeThreads-Erinnerung teilen';

  @override
  String get sendCapsuleSubject => 'LifeThreads Erinnerungskapsel';

  @override
  String get sendEncryptedCapsuleText =>
      'Hey, ich habe eine geschützte LifeThreads-Erinnerung mit dir geteilt. Nutze das Passwort, das ich dir gesendet habe.';

  @override
  String get sendCapsuleText =>
      'Hey, ich habe eine LifeThreads-Erinnerung mit dir geteilt. Importiere die Kapsel in LifeThreads, um sie zu deiner Wand hinzuzufügen.';

  @override
  String get capsuleReadyToSend => 'Kapsel bereit zum Senden.';

  @override
  String get capsuleSavedLater =>
      'Kapsel gespeichert. Du kannst sie später teilen.';

  @override
  String get capsuleSharingUnavailable =>
      'Kapsel gespeichert, aber Teilen ist nicht verfügbar.';

  @override
  String capsuleShareFailed(Object error) {
    return 'Kapsel gespeichert, aber Teilen fehlgeschlagen: $error';
  }

  @override
  String get importThisMemory => 'Diese Erinnerung importieren?';

  @override
  String get noStoryTextIncluded => 'Kein Geschichtstext enthalten.';

  @override
  String get placeLabel => 'Ort';

  @override
  String get notesLabel => 'Notizen';

  @override
  String get capsulePasswordProtected => 'Diese Kapsel war passwortgeschützt.';

  @override
  String get openingSharedMemory => 'Geteilte Erinnerung wird geöffnet...';

  @override
  String get lifeThreadsMemoryTitle => 'LifeThreads-Erinnerung';

  @override
  String shareMemoryText(Object url) {
    return 'Hey, ich habe eine Erinnerung in LifeThreads mit dir geteilt.\n\n$url';
  }

  @override
  String get shareLinkReady => 'Teillink bereit.';

  @override
  String get shareLinkCreated => 'Teillink erstellt.';

  @override
  String get shareLinkUnavailable =>
      'Teillink erstellt, aber Teilen ist nicht verfügbar.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label Link läuft automatisch ab. Du kannst ihn jetzt löschen.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'Cloud-Teilen fehlgeschlagen: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'Geteilter Erinnerungslink gelöscht.';

  @override
  String get creatingSecureMemoryLink =>
      'Sicherer Erinnerungslink wird erstellt...';

  @override
  String get shareMemoryCapsule => 'Erinnerungskapsel teilen';

  @override
  String get editStory => 'Geschichte bearbeiten';

  @override
  String get metaType => 'Typ';

  @override
  String get metaFeeling => 'Gefühl';

  @override
  String get metaCategory => 'Kategorie';

  @override
  String get metaDate => 'Datum';

  @override
  String get storyEyebrow => 'Geschichte';

  @override
  String get whyMemoryMatters => 'Warum diese Erinnerung wichtig ist';

  @override
  String get galleryEyebrow => 'Galerie';

  @override
  String editSectionTooltip(String section) {
    return '$section bearbeiten';
  }

  @override
  String get openInMaps => 'In Karten öffnen';

  @override
  String get memoryChangesSaved => 'Änderungen gespeichert.';

  @override
  String get memoryDeletedToast => 'Erinnerung gelöscht.';

  @override
  String get noteDeletedToast => 'Notiz gelöscht.';

  @override
  String get nailDeletedToast => 'Nagel entfernt.';

  @override
  String get undo => 'Rückgängig';

  @override
  String photoPlaceDetected(String place) {
    return 'Ort aus dem Foto: $place';
  }

  @override
  String get settingsGroupYou => 'Du';

  @override
  String get settingsGroupReminders => 'Benachrichtigungen';

  @override
  String get settingsGroupMore => 'Mehr';

  @override
  String get backupDataTitle => 'Sicherung & Daten';

  @override
  String get backupDataSubtitle => 'Sichern, wiederherstellen, aufs neue Handy';

  @override
  String get aboutHelpTitle => 'Info & Hilfe';

  @override
  String get aboutHelpSubtitle => 'Feedback, Datenschutz, Musik, Version';

  @override
  String get discardChangesTitle => 'Änderungen verwerfen?';

  @override
  String get discardChangesBody => 'Was du hier geändert hast, geht verloren.';

  @override
  String get discardChanges => 'Verwerfen';

  @override
  String get keepEditing => 'Weiter bearbeiten';

  @override
  String get settingsGroupPrivacy => 'Privatsphäre';

  @override
  String get appLockTitle => 'App-Sperre';

  @override
  String get appLockSubtitle => 'Face ID oder Code zum Öffnen von LifeThreads';

  @override
  String get appLockReason => 'Entsperre deine Erinnerungen';

  @override
  String get appLockLockedTitle => 'LifeThreads ist gesperrt';

  @override
  String get appLockUnlock => 'Entsperren';

  @override
  String get appLockUnavailable =>
      'Richte zuerst Face ID oder einen Code auf diesem Handy ein.';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Eine Erinnerung von vor $years Jahren wartet.',
      one: 'Eine Erinnerung von vor 1 Jahr wartet.',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Suche';

  @override
  String get searchHint => 'Titel, Ort, Person oder Jahr';

  @override
  String get searchClear => 'Suche löschen';

  @override
  String get searchNoResults => 'Keine Erinnerung passt dazu.';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen',
      one: '1 Erinnerung',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => 'Erinnerungen suchen';

  @override
  String get premiumFeatureWalls => 'Weitere Wände';

  @override
  String get newWall => 'Neue Wand';

  @override
  String get wallNameLabel => 'Name der Wand';

  @override
  String get newWallHint => 'z. B. Reisen 2025';

  @override
  String get createWall => 'Erstellen';

  @override
  String get renameWall => 'Umbenennen';

  @override
  String get deleteWall => 'Wand löschen';

  @override
  String deleteWallQuestion(String name) {
    return '„$name“ löschen?';
  }

  @override
  String get deleteWallBody =>
      'Ihre Erinnerungen kommen auf Meine Wand; nichts geht verloren.';

  @override
  String get personalWallSubtitle => 'Deine Wand, auf diesem Gerät';

  @override
  String get wallOptions => 'Wand-Optionen';

  @override
  String get moveToWall => 'Auf andere Wand…';

  @override
  String movedToWall(String name) {
    return 'Auf $name verschoben.';
  }

  @override
  String get hideMemory => 'Ausblenden';

  @override
  String get unhideMemory => 'Wieder zeigen';

  @override
  String get memoryHiddenToast =>
      'Ausgeblendet. Zu finden unter Ansicht › Ausgeblendete Erinnerungen.';

  @override
  String get showHiddenMemories => 'Ausgeblendete Erinnerungen';

  @override
  String get showHiddenReason => 'Ausgeblendete Erinnerungen zeigen';

  @override
  String get yearThreadFirstTitle => 'Dein erster Faden des Jahres';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count von 3 Erinnerungen',
      one: '1 von 3 Erinnerungen',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => 'Oder jetzt eine Story machen';

  @override
  String get moveMemoriesHere => 'Erinnerungen hierher holen';

  @override
  String get moveMemoriesTitle => 'Erinnerungen zum Verschieben wählen';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen verschieben',
      one: '1 Erinnerung verschieben',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'Alle zeigen';

  @override
  String get addAMemory => 'Erinnerung hinzufügen';

  @override
  String get mapAddPhotoMemory => 'Foto mit Ort hinzufügen';

  @override
  String get searchSuggestions => 'Probier etwas von dir';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Diese Woche vor $years Jahren',
      one: 'Diese Woche vor 1 Jahr',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => 'Wer war dabei?';

  @override
  String get premiumPlanYearly => 'Jährlich';

  @override
  String get premiumPlanMonthly => 'Monatlich';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/Jahr';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Spare $percent %';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'Die Zahlung wird über deinen $store-Account abgerechnet. Das Abo verlängert sich automatisch jedes Jahr, wenn du es nicht spätestens 24 Stunden vor Ende des laufenden Zeitraums kündigst. Verwalten oder kündigen kannst du es in den Account-Einstellungen von $store.';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gespeicherte Fotos',
      one: '1 gespeichertes Foto',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => 'Menschen';

  @override
  String get partOfMemory => 'Teil dieser Erinnerung';

  @override
  String get notesEyebrow => 'Notizen';

  @override
  String get attachedThoughts => 'Angehängte Gedanken';

  @override
  String get stickyNote => 'Sticky Note';

  @override
  String get placeEyebrow => 'Ort';

  @override
  String get threadsEyebrow => 'Fäden';

  @override
  String get connectedMemories => 'Verbundene Erinnerungen';

  @override
  String get noConnectedMemoriesYet =>
      'Noch keine verbundenen Erinnerungen. Verbinde dieses Kapitel mit einem anderen Moment, um einen sichtbaren Lebensfaden zu starten.';

  @override
  String get backToWall => 'Zurück zur Wand';

  @override
  String get addTextToWall => 'Text zur Wand hinzufügen';

  @override
  String get addTextAction => 'Text hinzufügen';

  @override
  String get textNoteHint =>
      'Schreibe eine kleine Erinnerung, ein Zitat oder eine Notiz...';

  @override
  String get placeTextNote => 'Textnotiz platzieren';

  @override
  String get placeRopeAnchor => 'Seilanker platzieren';

  @override
  String get nailSubtitle =>
      'Ein Nagel kann Seile manuell zwischen Erinnerungen verbinden.';

  @override
  String get clearDemoWallQuestion => 'Demo-Wand leeren?';

  @override
  String get clearDemoWallBody =>
      'Das entfernt die Beispielerinnerungen, damit du mit einer leeren privaten Wand starten kannst.';

  @override
  String get importBackupQuestion => 'Backup importieren?';

  @override
  String get importBackupBody =>
      'Das stellt Erinnerungen aus einem LifeThreads-Archiv wieder her und behält deine aktuelle Wand.';

  @override
  String get deleteMemoryQuestion => 'Erinnerung löschen?';

  @override
  String get deleteMemoryBody =>
      'Das entfernt die Erinnerung und alle Wandverbindungen.';

  @override
  String get editText => 'Text bearbeiten';

  @override
  String get editTextTitle => 'Text bearbeiten';

  @override
  String get connectRope => 'Seil verbinden';

  @override
  String get connectRopeSubtitle => 'Diesen Nagel mit Erinnerungen verbinden.';

  @override
  String get deleteNail => 'Nagel löschen';

  @override
  String get connectNailTitle => 'Nagel mit Erinnerungen verbinden';

  @override
  String get connectNailSubtitle =>
      'Ausgewählte Erinnerungen hängen an diesem Anker.';

  @override
  String get timelineTitle => 'Zeitleiste';

  @override
  String get timelineSubtitle => 'Deine Erinnerungen nach Zeit sortiert.';

  @override
  String get noMemoriesFilter => 'Keine Erinnerungen in diesem Filter';

  @override
  String get noMemoriesFilterBody =>
      'Wechsle den Filter oder füge eine Erinnerung hinzu, um die Zeitleiste aufzubauen.';

  @override
  String get memoryMapTitle => 'Erinnerungskarte';

  @override
  String get memoryMapSubtitle => 'Deine Erinnerungen nach Ort gruppiert.';

  @override
  String get noMappedMemories => 'Noch keine kartierten Erinnerungen';

  @override
  String get displayWallTooltip => 'Wand anzeigen';

  @override
  String get tutorialTooltip => 'Tutorial';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get freeformLayout => 'Frei';

  @override
  String get categoryLayout => 'Kategorie';

  @override
  String get locationLayout => 'Ort';

  @override
  String get saveToday => 'Heute speichern';

  @override
  String get rememberThis => 'Daran erinnern';

  @override
  String get whatHappenedToday => 'Was ist heute passiert?';

  @override
  String get tapToOpenDrag => 'Tippen zum Öffnen • ziehen zum Bewegen';

  @override
  String get demoWallPreview =>
      'Demo-Wandvorschau. Leere sie, wenn du bereit bist, frisch zu starten.';

  @override
  String get clearDemo => 'Demo leeren';

  @override
  String get chooseQuickPhoto => 'Schnellfoto wählen';

  @override
  String get wallView => 'Wand';

  @override
  String get timelineView => 'Zeitleiste';

  @override
  String get mapView => 'Karte';

  @override
  String get wallFilterAll => 'Alle';

  @override
  String get wallViewButton => 'Ansicht';

  @override
  String get wallShowAs => 'Anzeigen als';

  @override
  String get wallArrange => 'Anordnen';

  @override
  String get wallShowOnly => 'Zeigen';

  @override
  String get layoutByDate => 'Nach Datum';

  @override
  String get moreActionsTooltip => 'Mehr';

  @override
  String get addToWallTitle => 'Zu deiner Wand hinzufügen';

  @override
  String get expandableMemory => 'Erinnerung';

  @override
  String get expandableMemorySubtitle => 'Geführte Geschichte';

  @override
  String get expandableQuickPhoto => 'Schnellfoto-Erinnerung';

  @override
  String get expandableQuickPhotoSubtitle => 'Foto wählen und aufhängen';

  @override
  String get expandableTextNote => 'Textnotiz';

  @override
  String get expandableTextNoteSubtitle => 'Kleiner Gedanke an der Wand';

  @override
  String get expandableNail => 'Nagel / Seilanker';

  @override
  String get expandableNailSubtitle => 'Manueller Seilpunkt';

  @override
  String get startWithOneThing => 'Beginne mit einer Sache von heute';

  @override
  String get emptyWallBody =>
      'Speichere einen Moment, bevor er verblasst. Ein Satz oder ein Foto reicht.';

  @override
  String get usePhoto => 'Foto verwenden';

  @override
  String get editMemoryTooltip => 'Erinnerung bearbeiten';

  @override
  String get connectMemoryTooltip => 'Erinnerung verbinden';

  @override
  String get archiveTransferTitle => 'Auf anderem Gerät öffnen';

  @override
  String get archiveTransferHeroTitle =>
      'Verschiebe deine Erinnerungen sicher zwischen Geräten.';

  @override
  String get archiveTransferHeroBody =>
      'Ein Backup ist eine ZIP mit Erinnerungen, Fotos, Notizen, Fäden, Wandpositionen und Metadaten, auf Wunsch mit Passwort verschlüsselt. Wir behalten keine Kopie: du entscheidest, wo sie landet.';

  @override
  String get archiveTransferStep1Title => 'Archiv exportieren';

  @override
  String get archiveTransferStep1Body =>
      'Öffne Einstellungen, wähle Archiv exportieren und füge ein Passwort hinzu, wenn du Schutz willst.';

  @override
  String get archiveTransferStep2Title => 'ZIP verschieben';

  @override
  String get archiveTransferStep2Body =>
      'Übertrage sie mit AirDrop, USB, deinem eigenen Cloud-Speicher oder per E-Mail.';

  @override
  String get archiveTransferStep3Title => 'Sicher importieren';

  @override
  String get archiveTransferStep3Body =>
      'Installiere LifeThreads auf dem anderen Gerät, wähle Archiv importieren, gib bei Bedarf das Passwort ein und stelle wieder her, ohne bestehende Daten zu löschen.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled =>
      'Entwicklungs-Premium-Freischaltung aktiviert.';

  @override
  String get lifetimeActive => 'Abo aktiv';

  @override
  String get oneTimeLifetimeUnlock => 'Jährlich oder monatlich';

  @override
  String get premiumHeroActiveTitle => 'Deine Erinnerungswand ist unbegrenzt.';

  @override
  String get premiumHeroLockedTitle =>
      'Mach aus deinen Erinnerungen Geschichten.';

  @override
  String get premiumHeroActiveBody =>
      'Dein Premium-Abo ist aktiv. Storys mit Musik, der Faden des Jahres, Familienwände und unbegrenzte Erinnerungen gehören dir.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'Gratis sind $limit Erinnerungen und vollständige Backups. Premium bringt Storys und Filme mit Musik, den Faden des Jahres, Familienwände und unbegrenzte Erinnerungen.';
  }

  @override
  String get premiumMemories => 'Premium-Erinnerungen';

  @override
  String get freeMemories => 'Kostenlose Erinnerungen';

  @override
  String get unlimited => 'unbegrenzt';

  @override
  String get benefitUnlimitedTitle => 'Unbegrenzte Erinnerungen';

  @override
  String get benefitUnlimitedBody =>
      'Kein 30-Erinnerungen-Limit. Baue die Wand weiter, während das Leben wächst.';

  @override
  String get benefitThemesTitle => 'Premium-Wanddesigns';

  @override
  String get benefitThemesBody =>
      'Schalte reichere Wandstimmungen, limitierte saisonale Themes und den automatischen Wechsel nach Tageszeit frei.';

  @override
  String get benefitLayoutsTitle => 'Erweiterte Layouts';

  @override
  String get benefitLayoutsBody =>
      'Mehr Möglichkeiten, Fäden, Zeitleisten, Anker und Erinnerungscluster zu arrangieren.';

  @override
  String get lifetimeUnlock => 'Premium-Abo';

  @override
  String get premiumActiveOnDevice => 'Premium ist auf diesem Gerät aktiv.';

  @override
  String onePurchaseBody(String store) {
    return 'Jährliches oder monatliches Abo für Storys mit Musik, den Faden des Jahres, Familienwände und unbegrenzte Erinnerungen. Jederzeit in den Einstellungen von $store kündbar.';
  }

  @override
  String get premiumActiveButton => 'Premium aktiv';

  @override
  String get processing => 'Wird verarbeitet...';

  @override
  String get unlockPremium => 'Premium abonnieren';

  @override
  String get restorePurchase => 'Abo wiederherstellen';

  @override
  String get enableDebugMockUnlock => 'Debug-Mock-Unlock aktivieren';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'Die Zahlung wird über deinen $store-Account abgerechnet. Das Abo verlängert sich automatisch jeden Monat, wenn du es nicht spätestens 24 Stunden vor Ende des laufenden Zeitraums kündigst. Verwalten oder kündigen kannst du es in den Account-Einstellungen von $store.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'Die Aktualisierung vom Store ist fehlgeschlagen. Bitte versuch es nochmal.';

  @override
  String get premiumMessageStoreUnavailable =>
      'Käufe sind auf diesem Gerät nicht verfügbar.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium ist im Store noch nicht verfügbar. Bitte versuch es später nochmal.';

  @override
  String get premiumMessageLoadFailed =>
      'Premium konnte nicht aus dem Store geladen werden. Bitte versuch es nochmal.';

  @override
  String get premiumMessageOpeningCheckout => 'Kauf wird geöffnet …';

  @override
  String get premiumMessageCheckoutFailed =>
      'Der Kauf konnte nicht geöffnet werden. Bitte versuch es nochmal.';

  @override
  String get premiumMessageChecking => 'Dein Abo wird geprüft …';

  @override
  String get premiumMessageRestoreFailed =>
      'Wiederherstellen fehlgeschlagen. Bitte versuch es nochmal.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'Kein aktives Premium-Abo gefunden.';

  @override
  String get premiumMessagePending =>
      'Dein Kauf wartet auf Bestätigung. Premium wird danach freigeschaltet.';

  @override
  String get premiumMessagePurchaseFailed =>
      'Der Kauf hat nicht geklappt. Bitte versuch es nochmal.';

  @override
  String get premiumMessageCanceled => 'Kauf abgebrochen.';

  @override
  String get premiumMessageRestored =>
      'Dein Premium-Abo wurde wiederhergestellt.';

  @override
  String get premiumMessageActive => 'Dein Premium-Abo ist aktiv.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/Monat';
  }

  @override
  String get loadingPlayStoreProduct => 'Abo wird geladen …';

  @override
  String get playStoreUnavailable => 'Der Store ist gerade nicht erreichbar';

  @override
  String get productNotConfigured => 'Premium ist gerade nicht verfügbar';

  @override
  String get purchasePending => 'Kauf ausstehend';

  @override
  String get purchased => 'Gekauft';

  @override
  String get restored => 'Wiederhergestellt';

  @override
  String get premiumTryAgain => 'Nochmal versuchen';

  @override
  String get purchaseFailed => 'Kauf fehlgeschlagen';

  @override
  String get preparingCheckout => 'Checkout wird vorbereitet...';

  @override
  String get premiumLocalFirstTitle => 'Premium ist local-first';

  @override
  String get premiumLocalFirstBody =>
      'Deine Erinnerungen bleiben auf deinem Gerät, und Backups sind für alle kostenlos.';

  @override
  String get noMappedMemoriesBody =>
      'Füge Fotos mit GPS-Metadaten hinzu, um Erinnerungen hier zu sehen.';

  @override
  String get peopleLabel => 'Menschen';

  @override
  String get connect => 'Verbinden';

  @override
  String get themeWarmMemoryRoom => 'Warmer Erinnerungsraum';

  @override
  String get themeWarmMemoryRoomDescription =>
      'Sanfte dunkle Wärme, goldenes Licht und private Raumtiefe.';

  @override
  String get themeMidnightArchive => 'Mitternachtsarchiv';

  @override
  String get themeMidnightArchiveDescription =>
      'Tiefblauer Archivraum mit ruhigem Museumsfokus.';

  @override
  String get themeSoftPaperWall => 'Weiche Papierwand';

  @override
  String get themeSoftPaperWallDescription =>
      'Cremefarbenes Papier, Tintenschatten und ruhiges Scrapbook-Gefühl.';

  @override
  String get themeTravelCorkboard => 'Reise-Korkwand';

  @override
  String get themeTravelCorkboardDescription =>
      'Korkwandwärme mit Kartenraster-Hinweisen für Reisen und Orte.';

  @override
  String get themeAutoTitle => 'Automatisch nach Tageszeit';

  @override
  String get themeAutoDescription =>
      'Tagsüber Weiche Papierwand, abends Warmer Erinnerungsraum, nachts Mitternachtsarchiv.';

  @override
  String get themeAutoSelected => 'Deine Wand folgt jetzt der Tageszeit.';

  @override
  String get themeSeasonalTitle => 'Saisonal';

  @override
  String get themeSeasonalBody =>
      'Limitierte Premium-Themes, jeweils nur in ihrer Jahreszeit verfügbar.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Bis $dateString';
  }

  @override
  String get themeUseButton => 'Dieses Theme verwenden';

  @override
  String get themeInUse => 'Aktiv';

  @override
  String get themeUnlockButton => 'Mit Premium freischalten';

  @override
  String get themeAutumnHarvest => 'Herbsternte';

  @override
  String get themeAutumnHarvestDescription =>
      'Bernsteinlicht, Kraftpapier-Karten und das Leuchten fallender Blätter.';

  @override
  String get themeWinterLights => 'Winterlichter';

  @override
  String get themeWinterLightsDescription =>
      'Bereifte Karten und warme Lichterketten in einer kalten blauen Nacht.';

  @override
  String get themeSpringBlossom => 'Frühlingsblüte';

  @override
  String get themeSpringBlossomDescription =>
      'Zarte Blütenkarten mit sanftem rosa Schimmer.';

  @override
  String get themeSummerEvening => 'Sommerabend';

  @override
  String get themeSummerEveningDescription =>
      'Sonnenuntergangsfarben und Sofortbild-Karten.';

  @override
  String get themeYearRoundTitle => 'Immer verfügbar';

  @override
  String get themeComingTitle => 'Demnächst';

  @override
  String get themeComingBody =>
      'Schau dir die nächsten Jahreszeiten an. Jedes Theme startet am ersten Tag seiner Jahreszeit.';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Ab $dateString';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle Themes ansehen, $count davon für diese Jahreszeit',
      one: 'Alle Themes ansehen, 1 davon für diese Jahreszeit',
      zero: 'Alle Themes ansehen',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => 'Am Meer';

  @override
  String get themeSeasideDescription =>
      'Türkises Wasser, sandfarbenes Papier und warmes Sommerlicht.';

  @override
  String get themeSnowyCabin => 'Verschneite Hütte';

  @override
  String get themeSnowyCabinDescription =>
      'Holz am Kamin, bereifte Karten und leiser Schnee draußen.';

  @override
  String get themeSpringMeadow => 'Frühlingswiese';

  @override
  String get themeSpringMeadowDescription =>
      'Frisches grünes Gras, helle Karten und gelber Sonnenschein.';

  @override
  String get themeMistyForest => 'Nebelwald';

  @override
  String get themeMistyForestDescription =>
      'Stille Kiefern, Morgennebel und goldene Blätter.';

  @override
  String get demoFirstDanceTitle => 'Unser erster Tanz';

  @override
  String get demoFirstDanceStory =>
      'Die Band spielte unser Lied und die ganze Scheune wurde still. Ich bin dir zweimal auf den Fuß getreten, du hast die ganze Zeit gelacht – und drei Minuten lang gab es nur uns.';

  @override
  String get demoFirstDancePlace => 'Salzburg';

  @override
  String get demoNewbornTitle => 'Willkommen daheim, Lina';

  @override
  String get demoNewbornStory =>
      'Ihre ganze Hand passte um einen Finger. Der erste ruhige Morgen zu Hause.';

  @override
  String get demoNewbornPlace => 'Wien';

  @override
  String get demoBeachSunsetTitle => 'Sommer am Meer';

  @override
  String get demoBeachSunsetStory =>
      'Barfuß bis die Sonne unterging, auf dem Rückweg schlief Lina auf deinen Schultern.';

  @override
  String get demoBeachSunsetPlace => 'Split, Kroatien';

  @override
  String get demoGrandmaKitchenTitle => 'In Omas Küche';

  @override
  String get demoGrandmaKitchenStory =>
      'Ihr Marillenkuchen, endlich aufgeschrieben – und überall Mehl.';

  @override
  String get demoGrandmaKitchenPlace => 'Graz';

  @override
  String get demoGraduationTitle => 'Der Tag der Sponsion';

  @override
  String get demoGraduationStory =>
      'Papa hat geweint, bevor die Hüte gelandet waren.';

  @override
  String get demoGraduationPlace => 'Innsbruck';

  @override
  String get demoFirstHomeTitle => 'Schlüssel zum ersten Zuhause';

  @override
  String get demoFirstHomeStory =>
      'Noch keine Möbel, nur Kisten, Pizza am Boden und viele Pläne.';

  @override
  String get demoFirstHomePlace => 'Linz';

  @override
  String get demoAlpineSummitTitle => 'Über den Wolken';

  @override
  String get demoAlpineSummitStory =>
      'Um vier Uhr früh los – jeder Schritt hat sich gelohnt.';

  @override
  String get demoAlpineSummitPlace => 'Großglockner';

  @override
  String get demoFirstBikeTitle => 'Die erste Runde allein';

  @override
  String get demoFirstBikeStory =>
      'Drei Tritte, ein Wackler, dann war er weg – und so stolz.';

  @override
  String get demoFirstBikePlace => 'Prater, Wien';

  @override
  String get demoGardenDinnerTitle => 'Opas 80. Geburtstag';

  @override
  String get demoGardenDinnerStory =>
      'Vier Generationen an einem langen Tisch, und er hat immer noch die besten Geschichten erzählt.';

  @override
  String get demoGardenDinnerPlace => 'Wachau';

  @override
  String get demoThreadFirstDanceToFirstHome => 'Unsere Geschichte';

  @override
  String get demoThreadFirstHomeToNewborn => 'Dann kam Lina';

  @override
  String get demoThreadNewbornToBeachSunset => 'Ihr erster Sommer';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'Familie';

  @override
  String get demoThreadGraduationToFirstHome => 'Neues Kapitel';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'Kleine Abenteuer';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'Opa hat zugeschaut';

  @override
  String get demoRelationGrandpa => 'Opa';

  @override
  String get demoRelationGrandma => 'Oma';

  @override
  String get demoRelationDaughter => 'Tochter';

  @override
  String get demoRelationWife => 'Ehefrau';

  @override
  String get demoRelationBestMan => 'Trauzeuge';

  @override
  String get demoRelationMother => 'Mutter';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Gespeichert unter $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen sind noch in keinem Backup.',
      one: '1 Erinnerung ist noch in keinem Backup.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Später';

  @override
  String get backUp => 'Sichern';

  @override
  String get onThisDayTitle => 'An diesem Tag';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Heute vor $years Jahren',
      one: 'Heute vor einem Jahr',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'vor $years Jahren',
      one: 'vor einem Jahr',
    );
    return 'An diesem Tag · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'An Tagen, an denen eine Erinnerung aus einem früheren Jahr zurückkommt, schickt LifeThreads eine leise Erinnerung.';

  @override
  String get onThisDayReminderSwitch => 'Tägliche Erinnerung';

  @override
  String onThisDayReminderAt(String time) {
    return 'Um $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'Mitteilungen sind für LifeThreads aus. Erlaube sie in den Einstellungen deines Handys.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Heute vor $years Jahren: $title',
      one: 'Heute vor einem Jahr: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weitere Erinnerungen',
      one: 'eine weitere Erinnerung',
    );
    return '$title und $_temp0 von diesem Tag';
  }

  @override
  String get onThisDayChannelDescription =>
      'Eine Erinnerung von diesem Tag aus einem früheren Jahr.';

  @override
  String get benefitOnThisDayBody =>
      'Eine Erinnerung, wenn ein Moment aus einem früheren Jahr zurückkommt, geöffnet als eigenes Kapitel.';

  @override
  String get premiumFeatureStoryImage => 'Story-Bilder';

  @override
  String get premiumFeatureStoryVideo => 'Story-Videos';

  @override
  String get premiumFeatureThreadOfTheYear => 'Faden des Jahres';

  @override
  String get premiumFeatureFamilyWall => 'Familienwand';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature ist Teil von Premium.';
  }

  @override
  String get yearThreadTitle => 'Faden des Jahres';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen',
      one: '1 Erinnerung',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Orte',
      one: '1 Ort',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Personen',
      one: '1 Person',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Monate',
      one: '1 Monat',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'Am meisten gefühlt: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'Ein Jahr, verbunden.';

  @override
  String get yearThreadMyYear => 'Mein Jahr';

  @override
  String get yearThreadWallCardTitle => 'Dein Jahr in Erinnerungen';

  @override
  String yearThreadWallCardBody(String year) {
    return 'Mach aus $year einen kurzen Film.';
  }

  @override
  String get yearThreadDismiss => 'Nicht jetzt';

  @override
  String get yearThreadSettingsBody =>
      'Mach aus jedem Jahr mit mindestens 3 Erinnerungen einen kurzen Film – in der richtigen Reihenfolge und durch den Faden verbunden.';

  @override
  String get yearThreadOpen => 'Film erstellen';

  @override
  String get yearThreadNoYears =>
      'Für den Faden des Jahres braucht ein Jahr mindestens 3 Erinnerungen. Halte weiter Momente fest und schau dann wieder vorbei.';

  @override
  String get yearThreadYear => 'Jahr';

  @override
  String get yearThreadLength => 'Länge';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'Film · $seconds s';
  }

  @override
  String get yearThreadLengthStory => 'Story · 20 s';

  @override
  String get yearThreadMusic => 'Musik';

  @override
  String get yearThreadNoMusic => 'Keine Musik';

  @override
  String get yearThreadInFilm => 'Im Film';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count von $max';
  }

  @override
  String get yearThreadAddMemory => 'Erinnerung hinzufügen';

  @override
  String get yearThreadSwap => 'Tauschen';

  @override
  String get yearThreadRemove => 'Entfernen';

  @override
  String get yearThreadUseSuggestions => 'Vorschläge verwenden';

  @override
  String yearThreadPickTitle(String year) {
    return 'Wähle eine Erinnerung aus $year';
  }

  @override
  String get yearThreadNoOthers =>
      'Alle Erinnerungen aus diesem Jahr sind schon im Film.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen',
      one: '1 Erinnerung',
    );
    return 'Wähle mindestens $_temp0.';
  }

  @override
  String get yearThreadPreview => 'Vorschau';

  @override
  String get yearThreadExportVideo => 'Video exportieren';

  @override
  String get yearThreadExportImage => 'Bild exportieren';

  @override
  String get yearThreadShare => 'Teilen';

  @override
  String get yearThreadSave => 'In Fotos sichern';

  @override
  String get yearThreadMakingFilm => 'Dein Film entsteht …';

  @override
  String get yearThreadMakingImage => 'Dein Bild entsteht …';

  @override
  String get yearThreadFilmReady => 'Dein Film ist fertig';

  @override
  String get yearThreadImageReady => 'Dein Bild ist fertig';

  @override
  String get yearThreadSaved => 'In deinen Fotos gesichert.';

  @override
  String get yearThreadExportFailed =>
      'Das hat nicht geklappt. Bitte versuche es noch einmal.';

  @override
  String get yearThreadPlay => 'Abspielen';

  @override
  String get yearThreadPause => 'Pause';

  @override
  String get createStory => 'Story erstellen';

  @override
  String get storyPickTitle => 'Erinnerungen auswählen';

  @override
  String storyPickBody(int max) {
    return 'Wähle bis zu $max Erinnerungen für eine Story.';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$count von $max ausgewählt';
  }

  @override
  String storyPickLimit(int max) {
    return 'Eine Story fasst bis zu $max Erinnerungen.';
  }

  @override
  String get storyPickContinue => 'Weiter';

  @override
  String get storyNoMemories =>
      'Speichere zuerst eine Erinnerung und mach dann eine Story daraus.';

  @override
  String get storyEditorTitle => 'Deine Story';

  @override
  String get storyChangeMemories => 'Erinnerungen ändern';

  @override
  String get storyTemplateSingle => 'Eine Erinnerung';

  @override
  String get storyTemplateThread => 'Faden';

  @override
  String get storyTemplateCollage => 'Collage';

  @override
  String get storyTemplateQuote => 'Zitat';

  @override
  String get storySwipeHint => 'Wische für einen anderen Look';

  @override
  String get storyCaptionLabel => 'Bildtext';

  @override
  String get storyCaptionHint => 'Eine Zeile deiner Geschichte';

  @override
  String get storyVideoSwitch => 'Video';

  @override
  String get storyVideoBody =>
      'Ein kurzer Film für Stories und Reels: Fotos gleiten, der Faden zieht sich, Titel blenden ein.';

  @override
  String get storyMusicTitle => 'Musik';

  @override
  String get storyMusicNone => 'Keine Musik';

  @override
  String get storyMusicNoneHint =>
      'Beim Posten kannst du in Instagram einen Song aus der Instagram-Musikbibliothek hinzufügen.';

  @override
  String get storyMoodWarm => 'Warm';

  @override
  String get storyMoodJoyful => 'Fröhlich';

  @override
  String get storyMoodCalm => 'Ruhig';

  @override
  String get storyMoodNostalgic => 'Nostalgisch';

  @override
  String get storyMoodEpic => 'Episch';

  @override
  String get storyMoodEmotional => 'Gefühlvoll';

  @override
  String get storyMusicTrimHint => 'Ziehen, um den Teil zu wählen';

  @override
  String get storySearchHint => 'Erinnerungen, Orte, Jahre suchen';

  @override
  String storySearchEmpty(String query) {
    return 'Keine Erinnerung passt zu „$query“.';
  }

  @override
  String get storyMemoriesInStory => 'In deiner Story';

  @override
  String get storyMemoriesReorderHint =>
      'Gedrückt halten und ziehen, um die Reihenfolge zu ändern';

  @override
  String get storyAddMemory => 'Hinzufügen';

  @override
  String get storyAddMemoryTitle => 'Erinnerung hinzufügen';

  @override
  String storyRemoveMemory(String title) {
    return '$title aus der Story entfernen';
  }

  @override
  String get storyAllMemoriesAdded =>
      'Alle Erinnerungen sind schon in dieser Story.';

  @override
  String get storyShare => 'Teilen';

  @override
  String get storySaveToPhotos => 'In Fotos sichern';

  @override
  String get storySaved => 'In deinen Fotos gesichert.';

  @override
  String get storySaveDenied =>
      'LifeThreads darf nichts zu deinen Fotos hinzufügen. Erlaube es in den Einstellungen deines Telefons.';

  @override
  String storyExportFailed(String error) {
    return 'Die Story konnte nicht erstellt werden: $error';
  }

  @override
  String get storyRenderingTitle => 'Dein Film entsteht';

  @override
  String get storyRenderingBody =>
      'Lass LifeThreads geöffnet, das dauert ein paar Sekunden.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent %';
  }

  @override
  String get storyPreviewFree =>
      'Die Vorschau ist kostenlos. Stories teilen und sichern ist Teil von Premium.';

  @override
  String get benefitStoriesTitle => 'Story erstellen';

  @override
  String get benefitStoriesBody =>
      'Mach aus Erinnerungen Story-Bilder und kurze Filme mit Musik für Instagram, WhatsApp und mehr.';

  @override
  String get musicCreditsTitle => 'Musik-Credits';

  @override
  String get musicCreditsBody => 'Songs für Story-Videos, mit ihren Lizenzen.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'Dein Jahr als Kurzfilm: die Momente, die gezählt haben, der Reihe nach verbunden, mit Musik.';

  @override
  String get benefitFamilyTitle => 'Familienwände';

  @override
  String get benefitFamilyBody =>
      'Eine gemeinsame Wand für deine Familie, Ende-zu-Ende-verschlüsselt. Alle fügen ihre Momente hinzu.';

  @override
  String get myWall => 'Meine Wand';

  @override
  String get myWallSubtitle => 'Privat, auf diesem Gerät';

  @override
  String get switchWall => 'Wand wechseln';

  @override
  String get familyWallsTitle => 'Familienwände';

  @override
  String get familyWallsSettingsBody =>
      'Teile eine Wand mit Familie oder Freunden: Alle fügen Erinnerungen hinzu, Ende-zu-Ende-verschlüsselt. Meine Wand bleibt privat auf diesem Gerät.';

  @override
  String get familyWallsOpen => 'Familienwände öffnen';

  @override
  String get familyWallsManage => 'Familienwände verwalten';

  @override
  String get familyWallsHeadline => 'Eine Wand für die ganze Familie';

  @override
  String get familyWallsIntro =>
      'Eine Familienwand teilst du mit den Menschen, die du einlädst. Erinnerungen und Fotos werden auf deinem Handy verschlüsselt, bevor sie hochgeladen werden; nur Mitglieder können sie öffnen. Meine Wand wird nicht geteilt und bleibt auf diesem Gerät.';

  @override
  String get familyUnavailableTitle => 'Noch nicht verfügbar';

  @override
  String get familyUnavailable =>
      'Familienwände sind in dieser Version von LifeThreads noch nicht verfügbar.';

  @override
  String get familySignInNeededTitle =>
      'Melde dich an, um Familienwände zu nutzen';

  @override
  String get familySignInNeededBody =>
      'Eine geteilte Wand braucht ein Konto, damit die Familie weiß, wer was hinzugefügt hat. Meine Wand funktioniert ohne.';

  @override
  String get familySignIn => 'Anmelden';

  @override
  String get familyLoadFailed => 'Konnte nicht geladen werden';

  @override
  String get familyRetry => 'Erneut versuchen';

  @override
  String get familyNoWallsYet =>
      'Noch keine Familienwände. Starte eine oder tritt mit einem Einladungslink bei.';

  @override
  String get familyStartTitle => 'Starten oder beitreten';

  @override
  String get familyStartBody =>
      'Eine Familienwand zu starten braucht Premium. Beitreten ist kostenlos: Das Premium der Person, der die Wand gehört, deckt die Familie ab.';

  @override
  String get familyCreateAction => 'Familienwand erstellen';

  @override
  String get familyCreateTitle => 'Neue Familienwand';

  @override
  String get familyNameLabel => 'Name der Wand';

  @override
  String get familyNameHint => 'z. B. Familie Müller';

  @override
  String get familyMyNameLabel => 'Dein Name auf dieser Wand';

  @override
  String get familyMyNameHelper =>
      'Mitglieder sehen ihn bei deinen Erinnerungen. Er ist verschlüsselt wie alles auf der Wand.';

  @override
  String get familyMyNameSaved => 'Name gespeichert.';

  @override
  String get familySetMyName => 'Mein Name';

  @override
  String get familyCheckingSubscription => 'Premium wird geprüft …';

  @override
  String get familyCreating => 'Wand wird erstellt …';

  @override
  String get familyJoinWithLink => 'Mit Link beitreten';

  @override
  String get familyInviteLinkLabel => 'Einladungslink';

  @override
  String get familyJoinTitle => 'Dieser Familienwand beitreten?';

  @override
  String get familyJoinBody =>
      'Mitglieder sehen deinen Namen und die Erinnerungen, die du hinzufügst, und du ihre. Du kannst jederzeit austreten.';

  @override
  String get familyJoinAction => 'Beitreten';

  @override
  String get familyJoining => 'Beitreten …';

  @override
  String familyJoined(String family) {
    return 'Du bist $family beigetreten.';
  }

  @override
  String get familyRoleOwner => 'Inhaber';

  @override
  String get familyRoleMember => 'Mitglied';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'Wand-Einstellungen';

  @override
  String familyStorageUsed(String used, String total) {
    return '$used von $total belegt';
  }

  @override
  String get familyRename => 'Umbenennen';

  @override
  String get familyInviteTitle => 'Einladen';

  @override
  String get familyInviteBody =>
      'Schicke einen Link an jemanden, dem du vertraust. Jeder Link funktioniert einmal und läuft nach 7 Tagen ab.';

  @override
  String get familyInviteAction => 'Einladungslink erstellen';

  @override
  String get familyCreatingInvite => 'Einladung wird erstellt …';

  @override
  String get familyInviteReady => 'Einladungslink bereit';

  @override
  String get familyInviteValidity =>
      'Funktioniert einmal und läuft spätestens nach 7 Tagen ab.';

  @override
  String get familyInviteKeyWarning =>
      'Der Link enthält den Schlüssel der Wand: Wer ihn öffnet, kann beitreten und die Wand lesen. Schicke ihn nur an die eingeladene Person.';

  @override
  String get familyInviteShare => 'Link teilen';

  @override
  String get familyInviteCopy => 'Link kopieren';

  @override
  String get familyInviteCopied => 'Link kopiert.';

  @override
  String get familyInviteShareFailed =>
      'Teilen ist nicht verfügbar. Kopiere stattdessen den Link.';

  @override
  String familyInviteSubject(String family) {
    return 'Tritt $family auf LifeThreads bei';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'Tritt unserer Familienwand „$family“ auf LifeThreads bei: $link';
  }

  @override
  String get familyMembersTitle => 'Mitglieder';

  @override
  String get familyMemberActions => 'Aktionen für Mitglied';

  @override
  String get familyYou => 'Du';

  @override
  String familyYouNamed(String name) {
    return '$name (du)';
  }

  @override
  String get familyAMember => 'Ein Mitglied';

  @override
  String get familyFormerMember => 'Ehemaliges Mitglied';

  @override
  String get familyBlocked => 'Blockiert';

  @override
  String get familyBlock => 'Blockieren';

  @override
  String get familyUnblock => 'Blockierung aufheben';

  @override
  String familyBlockAuthor(String name) {
    return '$name blockieren';
  }

  @override
  String familyBlockQuestion(String name) {
    return '$name blockieren?';
  }

  @override
  String get familyBlockBody =>
      'Du siehst ihre Erinnerungen auf keiner Familienwand mehr. Die Person wird nicht benachrichtigt. Du kannst die Blockierung in der Mitgliederliste aufheben.';

  @override
  String get familyReport => 'Melden';

  @override
  String get familyRemoveMember => 'Von der Wand entfernen';

  @override
  String familyRemoveQuestion(String name) {
    return '$name entfernen?';
  }

  @override
  String get familyRemoveBody =>
      'Die Person verliert den Zugang zu dieser Wand. Lade sie erneut ein, um sie zurückzuholen.';

  @override
  String get familyRemoveDeleteContent =>
      'Auch die Erinnerungen löschen, die die Person hinzugefügt hat';

  @override
  String get familyDeleteTitle => 'Familienwand löschen';

  @override
  String get familyDeleteBody =>
      'Als Inhaber kannst du die Wand nicht verlassen; du kannst sie für alle löschen.';

  @override
  String get familyDeleteAction => 'Wand löschen';

  @override
  String familyDeleteQuestion(String family) {
    return '$family löschen?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'Alle Erinnerungen und Fotos dieser Wand werden für alle Mitglieder von unseren Servern gelöscht. Das lässt sich nicht rückgängig machen. Erinnerungen auf Meine Wand sind nicht betroffen.';

  @override
  String get familyDeleting => 'Wird gelöscht …';

  @override
  String get familyLeaveTitle => 'Familienwand verlassen';

  @override
  String get familyLeaveBody =>
      'Du siehst diese Wand nicht mehr. Deine Erinnerungen kannst du behalten oder löschen.';

  @override
  String get familyLeaveAction => 'Verlassen';

  @override
  String familyLeaveQuestion(String family) {
    return '$family verlassen?';
  }

  @override
  String get familyLeaveConfirmBody =>
      'Um zurückzukommen, brauchst du eine neue Einladung.';

  @override
  String get familyLeaveDeleteMine =>
      'Auch meine hinzugefügten Erinnerungen löschen';

  @override
  String get familyLeaving => 'Wird verlassen …';

  @override
  String get familySignInTitle => 'Anmelden';

  @override
  String get familySignInHeadline => 'Ein Konto für Familienwände';

  @override
  String get familySignInWhy =>
      'Eine Familienwand wird geteilt und braucht daher ein Konto: Mitglieder sehen, wer welche Erinnerung hinzugefügt hat, und nur Mitglieder können die Wand öffnen.';

  @override
  String get familySignInMyWallStays =>
      'Meine Wand braucht kein Konto. Sie bleibt privat auf diesem Gerät und wird nie hochgeladen.';

  @override
  String get familySignInEncrypted =>
      'Familienerinnerungen und -fotos sind Ende-zu-Ende-verschlüsselt. GK Coding speichert sie, kann sie aber nicht lesen.';

  @override
  String get familySignInWhatWeGet =>
      'Von Apple oder Google nutzen wir nur eine Konto-ID, nicht deine Kontakte oder Fotos.';

  @override
  String get familySignInApple => 'Mit Apple anmelden';

  @override
  String get familySignInGoogle => 'Mit Google anmelden';

  @override
  String get familySignInFinePrint =>
      'Mit der Anmeldung stimmst du den Nutzungsbedingungen und der Datenschutzerklärung zu. Du kannst dein Konto jederzeit in der App löschen.';

  @override
  String get familyAccountTitle => 'Konto';

  @override
  String get familySignedOutTitle => 'Nicht angemeldet';

  @override
  String get familySignedOutBody =>
      'Melde dich an, um deine Familienwände zu sehen. Meine Wand funktioniert ohne Konto.';

  @override
  String get familySignedInTitle => 'Angemeldet';

  @override
  String get familySignedInBody =>
      'Dein Konto wird nur für Familienwände genutzt.';

  @override
  String familyAccountId(String id) {
    return 'Konto-ID: $id';
  }

  @override
  String get familySignOut => 'Abmelden';

  @override
  String get familySignOutQuestion => 'Abmelden?';

  @override
  String get familySignOutBody =>
      'Familienwände und ihre Schlüssel werden von diesem Gerät entfernt, bis du dich wieder anmeldest. Auf dem Server wird nichts gelöscht. Meine Wand ist nicht betroffen.';

  @override
  String get familySigningOut => 'Abmelden …';

  @override
  String get familyDeleteAccountTitle => 'Konto löschen';

  @override
  String get familyDeleteAccountBody =>
      'Löscht dein Konto und deine Familienwand-Daten von unseren Servern. Meine Wand bleibt auf diesem Gerät.';

  @override
  String get familyDeleteAccount => 'Konto löschen';

  @override
  String get familyDeleteAccountQuestion => 'Konto löschen?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Die $count Familienwände, die dir gehören, werden für alle Mitglieder gelöscht, mit allen Erinnerungen und Fotos.',
      one:
          'Die Familienwand, die dir gehört, wird für alle Mitglieder gelöscht, mit allen Erinnerungen und Fotos.',
      zero: 'Dir gehört keine Familienwand.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'Die Erinnerungen und Fotos, die du auf Wänden anderer Familien hinzugefügt hast, werden gelöscht, und du verlässt diese Wände.';

  @override
  String get familyDeleteAccountKeys =>
      'Schlüssel und zwischengespeicherte Fotos der Familienwände werden von diesem Gerät entfernt. Das lässt sich nicht rückgängig machen.';

  @override
  String get familyDeleteAccountMyWall =>
      'Meine Wand ist nicht betroffen: Ihre Erinnerungen bleiben auf diesem Gerät.';

  @override
  String get familyDeleteAccountSubscription =>
      'Ein Premium-Abo wird dadurch nicht gekündigt; verwalte es im App Store oder bei Google Play.';

  @override
  String get familyDeleteAccountUnderstood =>
      'Mir ist klar, dass mein Konto endgültig gelöscht wird.';

  @override
  String get familyDeletingAccount => 'Konto wird gelöscht …';

  @override
  String get familyAccountDeleted => 'Dein Konto wurde gelöscht.';

  @override
  String get familyTermsTitle => 'Regeln für Familienwände';

  @override
  String get familyTermsHeadline => 'Bevor du teilst';

  @override
  String get familyTermsIntro =>
      'Familienwände sind für die Menschen, die du einlädst. Damit sie sicher bleiben, akzeptieren alle diese Regeln:';

  @override
  String get familyTermsZeroTolerance =>
      'Null Toleranz für anstößige Inhalte: keine Belästigung, kein Hass, keine sexuellen Inhalte, keine Gewalt, keine Selbstverletzung, keine illegalen Inhalte und keine privaten Informationen anderer ohne deren Zustimmung.';

  @override
  String get familyTermsOwnContent =>
      'Teile nur Fotos und Geschichten, die du teilen darfst.';

  @override
  String get familyTermsReport =>
      'Melde jede Erinnerung oder jedes Mitglied direkt auf der Wand. GK Coding prüft Meldungen innerhalb von 24 Stunden.';

  @override
  String get familyTermsBlock =>
      'Blockiere ein Mitglied, um seine Erinnerungen nicht mehr zu sehen.';

  @override
  String get familyTermsOwner =>
      'Die Person, der eine Wand gehört, kann Mitglieder und ihre Erinnerungen entfernen.';

  @override
  String get familyTermsConsequences =>
      'Inhalte, die gegen diese Regeln verstoßen, werden entfernt, und die Konten, die sie gepostet haben, können gesperrt oder gelöscht werden.';

  @override
  String get familyTermsReadFull => 'Vollständige Bedingungen lesen';

  @override
  String get familyTermsAgree =>
      'Ich stimme den Nutzungsbedingungen und diesen Regeln zu.';

  @override
  String get familyTermsAccept => 'Akzeptieren und weiter';

  @override
  String familyTermsVersion(String version) {
    return 'Version der Bedingungen $version';
  }

  @override
  String get familyWallEmptyTitle => 'Die Wand wartet';

  @override
  String get familyWallEmptyBody =>
      'Füge die erste Erinnerung hinzu. Alle auf dieser Wand sehen sie.';

  @override
  String get familyWallGoneBody =>
      'Diese Familienwand ist für dich nicht mehr verfügbar. Vielleicht wurde sie gelöscht oder du wurdest entfernt.';

  @override
  String get familyAddMemory => 'Erinnerung hinzufügen';

  @override
  String get familyRefresh => 'Aktualisieren';

  @override
  String get familySyncing => 'Wird synchronisiert …';

  @override
  String get familyOffline => 'Offline: gespeicherte Erinnerungen';

  @override
  String get familySyncFailed => 'Synchronisierung fehlgeschlagen';

  @override
  String get familyMemoryTitle => 'Erinnerung';

  @override
  String get familyMemoryGone =>
      'Diese Erinnerung ist nicht mehr auf der Wand.';

  @override
  String get familyMemoryActions => 'Aktionen für Erinnerung';

  @override
  String familyAddedBy(String name) {
    return 'Hinzugefügt von $name';
  }

  @override
  String get familyDeleteMemoryQuestion => 'Diese Erinnerung löschen?';

  @override
  String get familyDeleteMemoryBody =>
      'Sie wird mit ihren Fotos für alle von der Wand entfernt.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'Als Inhaber kannst du Erinnerungen von dieser Wand entfernen. Diese Erinnerung von $name wird mit ihren Fotos für alle entfernt.';
  }

  @override
  String get familyDeletingMemory => 'Erinnerung wird gelöscht …';

  @override
  String get familyNoPhotosYet => 'Noch keine Fotos';

  @override
  String get familyPostNote =>
      'Alle auf dieser Wand sehen diese Erinnerung. Fotos werden auf deinem Handy verkleinert und verschlüsselt, bevor sie hochgeladen werden.';

  @override
  String get familyPost => 'Posten';

  @override
  String get familyPostMemory => 'Auf die Wand posten';

  @override
  String get familyUploading => 'Wird verschlüsselt und hochgeladen …';

  @override
  String get familyMemorySaved => 'Auf der Familienwand gespeichert.';

  @override
  String get familyConflictTitle => 'Von jemand anderem geändert';

  @override
  String get familyConflictBody =>
      'Diese Erinnerung wurde auf einem anderen Gerät geändert, während du sie bearbeitet hast. Neueste Version laden und deine Änderungen darüber speichern?';

  @override
  String get familyConflictRetry => 'Aktualisieren und speichern';

  @override
  String get familyQuotaTitle => 'Die Wand ist voll';

  @override
  String get familyReportMemoryTitle => 'Erinnerung melden';

  @override
  String get familyReportPhotoTitle => 'Foto melden';

  @override
  String get familyReportMemberTitle => 'Mitglied melden';

  @override
  String get familyReportIntro =>
      'Sag uns, was nicht stimmt. Deine Meldung geht an GK Coding, nicht an die gemeldete Person.';

  @override
  String get familyReportSpam => 'Spam oder Betrug';

  @override
  String get familyReportHarassment => 'Belästigung oder Mobbing';

  @override
  String get familyReportHate => 'Hassrede';

  @override
  String get familyReportSexual => 'Sexuelle Inhalte oder Nacktheit';

  @override
  String get familyReportViolence => 'Gewalt oder Drohungen';

  @override
  String get familyReportSelfHarm => 'Selbstverletzung oder Suizid';

  @override
  String get familyReportIllegal => 'Illegale Inhalte';

  @override
  String get familyReportPrivacy =>
      'Private Informationen ohne Zustimmung geteilt';

  @override
  String get familyReportOther => 'Etwas anderes';

  @override
  String get familyReportDetailsLabel => 'Details (optional)';

  @override
  String get familyReportDetailsHint => 'Was sollten wir wissen?';

  @override
  String familyReportAlsoBlock(String name) {
    return 'Auch $name blockieren';
  }

  @override
  String get familyReportSend => 'Meldung senden';

  @override
  String get familyReportReviewNote =>
      'GK Coding prüft jede Meldung innerhalb von 24 Stunden und entfernt Inhalte und Mitglieder, die gegen die Regeln verstoßen.';

  @override
  String get familyReportSentTitle => 'Danke';

  @override
  String get familyReportSentBody =>
      'Deine Meldung wurde gesendet. GK Coding prüft sie innerhalb von 24 Stunden und geht gegen Inhalte vor, die gegen die Regeln verstoßen.';

  @override
  String get familyErrorGeneric =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get familyErrorOffline =>
      'Du scheinst offline zu sein. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get familyErrorSubscriptionRequired =>
      'Dafür braucht die Person, der die Wand gehört, ein aktives Premium-Abo.';

  @override
  String get familyErrorInviteExpired =>
      'Diese Einladung ist abgelaufen. Bitte um einen neuen Link.';

  @override
  String get familyErrorInviteUsed =>
      'Diese Einladung wurde schon verwendet. Jeder Link funktioniert einmal; bitte um einen neuen.';

  @override
  String get familyErrorInviteInvalid =>
      'Das ist kein gültiger LifeThreads-Einladungslink.';

  @override
  String get familyErrorAlreadyMember =>
      'Du bist bereits Mitglied dieser Familienwand.';

  @override
  String get familyErrorFamilyFull =>
      'Diese Familienwand hat die maximale Mitgliederzahl erreicht.';

  @override
  String get familyErrorQuotaExceeded =>
      'Diese Familienwand hat keinen Speicher mehr frei. Lösche einige Erinnerungen oder Fotos, um Platz zu schaffen.';

  @override
  String get familyErrorVersionConflict =>
      'Jemand hat diese Erinnerung zuerst geändert. Aktualisiere und versuche es erneut.';

  @override
  String get familyErrorTermsRequired =>
      'Bitte akzeptiere zuerst die Regeln für Familienwände.';

  @override
  String get familyErrorSignedOut =>
      'Du wurdest abgemeldet. Bitte melde dich erneut an.';

  @override
  String get familyErrorNotAllowed => 'Das darfst du auf dieser Wand nicht.';

  @override
  String get familyErrorNotFound => 'Familienwand nicht gefunden';

  @override
  String get familyErrorOwnerCannotLeave =>
      'Der Inhaber kann die Wand nicht verlassen, aber löschen.';

  @override
  String get familyPaste => 'Einfügen';

  @override
  String get familyErrorInviteRevoked =>
      'Diese Einladung wurde zurückgezogen. Bitte um einen neuen Link.';

  @override
  String get familyErrorKeyMissing =>
      'Dieses Gerät hat den Schlüssel für diese Familienwand nicht (zum Beispiel nach einer Neuinstallation oder auf einem neuen Handy). Bitte ein Mitglied um einen neuen Einladungslink: Ihn zu öffnen stellt den Zugang wieder her.';

  @override
  String get familyErrorSignInUnavailable =>
      'Die Anmeldung ist auf diesem Gerät gerade nicht verfügbar.';

  @override
  String get familyErrorNoPurchase =>
      'Für dieses App-Store- oder Google-Play-Konto wurde kein Premium-Kauf gefunden. Hol dir zuerst Premium und versuche es dann erneut.';

  @override
  String get familyErrorVerificationUnavailable =>
      'Dein Premium konnte gerade nicht geprüft werden. Bitte versuche es später erneut.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'Dieser Premium-Kauf ist schon mit einem anderen Familienwand-Konto verknüpft. Melde dich mit diesem Konto an oder schreib an info@gkcoding.dev.';

  @override
  String get familyErrorNameTooLong =>
      'Dieser Name ist zu lang. Bitte nimm einen kürzeren.';

  @override
  String get familyErrorPhotoUnreadable =>
      'Eines der Fotos konnte nicht gelesen werden. Entferne es und versuche es erneut.';

  @override
  String get familyErrorTooLarge =>
      'Das ist zu groß zum Hochladen. Versuche es mit weniger oder kleineren Fotos.';

  @override
  String get familyReportEvidenceNote =>
      'Zur Prüfung erhält GK Coding mit deiner Meldung den Titel und die Geschichte dieser Erinnerung. Ihre Fotos werden nie gesendet.';

  @override
  String get moveLeft => 'Nach links';

  @override
  String get moveUp => 'Nach oben';

  @override
  String get moveDown => 'Nach unten';

  @override
  String get moveRight => 'Nach rechts';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String get removePerson => 'Person entfernen';

  @override
  String get draftKept =>
      'Als Entwurf behalten – beim nächsten Mal ist er wieder da.';

  @override
  String get draftResumeTitle => 'Weitermachen, wo du aufgehört hast?';

  @override
  String draftResumeBody(String date) {
    return 'Du hast am $date eine Erinnerung begonnen und noch nicht gespeichert.';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos',
      one: '1 Foto',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => 'Entwurf fortsetzen';

  @override
  String get draftStartNew => 'Neu beginnen';

  @override
  String get lookBackMenu => 'Monatsrückblick';

  @override
  String lookBackTitle(String month) {
    return 'Dein $month';
  }

  @override
  String get lookBackWallCardTitle => 'Dein Monat in Erinnerungen';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen',
      one: '1 Erinnerung',
    );
    return '$month: $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen',
      one: '1 Erinnerung',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Personen',
      one: '1 Person',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Orte',
      one: '1 Ort',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => 'Wer dabei war';

  @override
  String get lookBackPlacesHeading => 'Wo du warst';

  @override
  String lookBackEmpty(String month) {
    return 'Aus $month ist noch nichts gespeichert.';
  }

  @override
  String get lookBackEmptyHint =>
      'Erinnerungen mit einem Datum in diesem Monat erscheinen hier.';

  @override
  String get lookBackPreviousMonth => 'Vorheriger Monat';

  @override
  String get lookBackNextMonth => 'Nächster Monat';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen',
      one: '1 Erinnerung',
    );
    return '$month: $_temp0 zum Zurückblicken.';
  }

  @override
  String get lookBackNotificationPrivate =>
      'Dein Monat in Erinnerungen ist bereit.';

  @override
  String get homeWidgetLocked =>
      'Öffne LifeThreads, um deine Erinnerungen zu sehen.';

  @override
  String get homeWidgetSettingsTitle => 'Widget auf dem Home-Bildschirm';

  @override
  String get homeWidgetSettingsSubtitle => 'Welche Erinnerungen es zeigt';

  @override
  String get homeWidgetPreviewTitle => 'Heute auf deinem Widget';

  @override
  String get homeWidgetSourceTitle => 'Welche Erinnerungen';

  @override
  String get homeWidgetAllWalls => 'Alle meine Wände';

  @override
  String get homeWidgetOrderTitle => 'Zuerst gezeigt';

  @override
  String get homeWidgetOnThisDayFirst => 'An diesem Tag zuerst';

  @override
  String get homeWidgetOnThisDayFirstBody =>
      'Eine Erinnerung von diesem Tag in einem früheren Jahr kommt zuerst.';

  @override
  String get homeWidgetPhotosFirst => 'Erinnerungen mit Fotos zuerst';

  @override
  String get homeWidgetPhotosFirstBody =>
      'Andere nur, wenn keine ein Foto hat.';

  @override
  String get homeWidgetHowToTitle => 'Zum Home-Bildschirm hinzufügen';

  @override
  String get homeWidgetHowToIos =>
      'Halte das LifeThreads-Icon auf dem Home-Bildschirm gedrückt und wähle eine Widget-Größe. Oder halte eine freie Stelle gedrückt, tippe auf Bearbeiten › Widget hinzufügen und wähle LifeThreads.';

  @override
  String get homeWidgetHowToAndroid =>
      'Halte eine freie Stelle auf dem Home-Bildschirm gedrückt, tippe auf Widgets und ziehe LifeThreads an die gewünschte Stelle.';

  @override
  String get homeWidgetPrivacyNote =>
      'Ausgeblendete Erinnerungen erscheinen nie auf dem Widget. Mit App-Sperre zeigt es keine Erinnerung.';

  @override
  String get yearThreadAlmostThere => 'Fast geschafft';

  @override
  String get yearThreadMemoriesFrom => 'Erinnerungen von';

  @override
  String yearThreadAddMemoryTo(String year) {
    return 'Erinnerung zu $year hinzufügen';
  }

  @override
  String get onboardingHangTitle => 'Erinnerungen aufhängen';

  @override
  String get onboardingHangText =>
      'Ein Foto, ein Ort, die Menschen, die dabei waren – deine Wand wächst mit deinem Leben.';

  @override
  String get onboardingConnectTitle => 'Mit Fäden verbinden';

  @override
  String get onboardingConnectText =>
      'Sag, warum zwei Momente zusammengehören. Die Fäden zeigen, wie deine Geschichte zusammenhängt.';

  @override
  String get onboardingComeBackTitle => 'Erinnerungen kommen zu dir zurück';

  @override
  String get onboardingComeBackText =>
      'An diesem Tag, dein Monat im Rückblick, dein Jahr als Film – und ein Widget auf dem Home-Bildschirm.';

  @override
  String get onboardingPrivateText =>
      'Kein Konto. Alles bleibt auf deinem Handy – mit Face ID, wenn du möchtest.';

  @override
  String get onboardingNameStaysHere =>
      'Nur für die Begrüßung – er bleibt auf diesem Handy.';

  @override
  String get tutorialLookBackTitle => 'Finden und zurückblicken';

  @override
  String get tutorialLookBackText =>
      'Suche nach Titel, Ort, Person oder Jahr. Mehr › Monatsrückblick zeigt die Erinnerungen eines Monats; Mehr › Faden des Jahres macht aus einem Jahr einen Film.';

  @override
  String get tutorialStoryTitle => 'Eine Story machen';

  @override
  String get tutorialStoryText =>
      'Mehr › Story erstellen: Erinnerungen, Vorlage und Musik wählen, dann als Bild oder Video teilen.';

  @override
  String get tutorialWallsTitle => 'Wände und ausgeblendete Erinnerungen';

  @override
  String get tutorialWallsText =>
      'Mehr › Neue Wand trennt Reisen oder Lebensabschnitte (Premium). Karte gedrückt halten › Ausblenden versteckt sie; Ansicht › Ausgeblendete Erinnerungen zeigt sie nach Face ID.';

  @override
  String get tutorialFamilyTitle => 'Mit der Familie teilen';

  @override
  String get tutorialFamilyText =>
      'Mehr › Familienwände: eine Wand für die ganze Familie, Ende-zu-Ende-verschlüsselt. Andere per Link einladen.';

  @override
  String get tutorialWidgetTitle => 'Eine Erinnerung auf dem Home-Bildschirm';

  @override
  String get tutorialWidgetText =>
      'Füge das LifeThreads-Widget hinzu: jeden Tag eine andere Erinnerung. Einstellungen › Widget auf dem Home-Bildschirm wählt, welche.';

  @override
  String photoNumber(int number) {
    return 'Foto $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'Dein Name auf dieser Wand konnte nicht gespeichert werden. Du kannst ihn in den Einstellungen der Wand festlegen.';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Es enthält $count Erinnerungen.',
      one: 'Es enthält 1 Erinnerung.',
    );
    return '$_temp0 Erinnerungen, die schon auf deinen Wänden sind, bleiben und werden nicht doppelt hinzugefügt.';
  }

  @override
  String get importAction => 'Importieren';
}
