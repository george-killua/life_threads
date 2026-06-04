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
      'LifeThreads ist lokal zuerst. Deine Erinnerungen, Fotos, Notizen, Orte und Verbindungen bleiben auf diesem Gerät, außer du exportierst selbst ein Backup.';

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
  String get premiumArchiveTitle => 'Premium-Archiv';

  @override
  String get premiumArchiveBody =>
      'Verschiebe deine Erinnerungen sicher zwischen Geräten. Exportiere ein Archiv mit Erinnerungen, Fotos, Notizen, Seilen, Wandlayout und Metadaten. Schütze es bei Bedarf mit einem Passwort.';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Freischalten';

  @override
  String get exportArchive => 'Archiv exportieren';

  @override
  String get unlockExport => 'Export freischalten';

  @override
  String get importArchive => 'Archiv importieren';

  @override
  String get importCapsule => 'Kapsel importieren';

  @override
  String get moveDevices => 'Geräte wechseln';

  @override
  String get cloudSyncTitle => 'Cloud-Sync';

  @override
  String get cloudSyncBody =>
      'Sichere ein passwortgeschütztes Archiv auf deinem VPS. Der Server speichert nur die verschlüsselte ZIP-Datei und dein privater Sync-Schlüssel steuert die Wiederherstellung.';

  @override
  String get vpsBadge => 'VPS';

  @override
  String get backUpNow => 'Jetzt sichern';

  @override
  String get unlockBackup => 'Backup freischalten';

  @override
  String get restoreLatest => 'Letztes wiederherstellen';

  @override
  String get copyKey => 'Schlüssel kopieren';

  @override
  String get useKey => 'Schlüssel verwenden';

  @override
  String get deleteCloud => 'Cloud löschen';

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
  String get premiumActiveBody => 'Premium Lifetime Unlock ist aktiv.';

  @override
  String get premiumLockedBody =>
      'Einmalige Freischaltung: unbegrenzte Erinnerungen, verschlüsselter Archiv-Export/Import, Gerätewechsel, Premium-Designs und erweiterte Layouts.';

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
  String get cloudBackupNeedsPassword => 'Cloud-Backup braucht ein Passwort.';

  @override
  String cloudBackupSaved(int memoryCount) {
    return 'Cloud-Backup gespeichert: $memoryCount Erinnerungen.';
  }

  @override
  String cloudBackupFailed(Object message) {
    return 'Cloud-Backup fehlgeschlagen: $message';
  }

  @override
  String cloudRestoreRejected(Object message) {
    return 'Cloud-Wiederherstellung abgelehnt: $message';
  }

  @override
  String cloudRestoreFailed(Object message) {
    return 'Cloud-Wiederherstellung fehlgeschlagen: $message';
  }

  @override
  String get syncKeyCopied => 'Sync-Schlüssel kopiert.';

  @override
  String get useSyncKeyTitle => 'Sync-Schlüssel verwenden';

  @override
  String get syncKeyLabel => 'Sync-Schlüssel';

  @override
  String get syncKeySaved => 'Sync-Schlüssel gespeichert.';

  @override
  String get deleteCloudBackupTitle => 'Cloud-Backup löschen?';

  @override
  String get deleteCloudBackupBody =>
      'Das löscht das verschlüsselte Archiv von deinem VPS. Lokale Erinnerungen bleiben auf diesem Gerät.';

  @override
  String get cloudBackupDeleted => 'Cloud-Backup gelöscht.';

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
      'Deine Erinnerungen bleiben privat: kein Konto und kein Cloud-Upload in diesem MVP.';

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
      'Der Grundablauf: Erinnerungen speichern, verwandte verbinden und dann die Wand arrangieren.';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get howItWorks => 'So funktioniert es';

  @override
  String get tutorialAddTitle => 'Erinnerung hinzufügen';

  @override
  String get tutorialAddText =>
      'Tippe auf Hinzufügen, wähle Erinnerung oder Schnellfoto und speichere Titel, Datum, Personen und Foto.';

  @override
  String get tutorialConnectTitle => 'Erinnerungen verbinden';

  @override
  String get tutorialConnectText =>
      'Öffne eine Karte, tippe auf das Verbindungsicon, wähle verwandte Erinnerungen und ergänze kurz den Grund.';

  @override
  String get tutorialArrangeTitle => 'Wand arrangieren';

  @override
  String get tutorialArrangeText =>
      'Ziehe Karten, Notizen und Nägel an ihren Platz. Echte Verbindungen zeichnen Seile hinter den Elementen.';

  @override
  String get tutorialShowBoardTitle => 'Board anzeigen';

  @override
  String get tutorialShowBoardText =>
      'Öffne lifethreads.gkcoding.dev/display auf einem anderen Bildschirm, tippe in den Wand-Steuerungen auf QR und scanne den Code, um ein temporäres schreibgeschütztes Board zu zeigen.';

  @override
  String get tutorialBackupTitle => 'Backup behalten';

  @override
  String get tutorialBackupText =>
      'Nutze Cloud-Sync oder Archivtransfer, bevor du das Telefon wechselst oder einen Produktionsbuild testest.';

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
  String get useSelected => 'Auswahl verwenden';

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
  String get exportPremiumArchiveTitle => 'Premium-Archiv exportieren';

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
  String get archiveReadyToSend => 'Archiv bereit zum Senden.';

  @override
  String get archiveSavedLater =>
      'Archiv gespeichert. Du kannst es später teilen.';

  @override
  String get archiveSharingUnavailable =>
      'Archiv gespeichert, aber Teilen ist nicht verfügbar.';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Gespeichert unter $path';
  }

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
  String savedPhotosTitle(int count) {
    return '$count gespeicherte Foto(s)';
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
  String get headerSubtitle => 'Deine Erinnerungen, zusammen aufgehängt.';

  @override
  String get importBackupTooltip => 'Backup importieren';

  @override
  String get exportBackupTooltip => 'Backup exportieren';

  @override
  String get displayWallTooltip => 'Wand anzeigen';

  @override
  String get tutorialTooltip => 'Tutorial';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get hideControlsTooltip => 'Steuerung ausblenden';

  @override
  String get freeformLayout => 'Frei';

  @override
  String get categoryLayout => 'Kategorie';

  @override
  String get locationLayout => 'Ort';

  @override
  String get wallControls => 'Wandsteuerung';

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
      'Premium Archive erstellt eine portable verschlüsselte ZIP mit Erinnerungen, Fotos, Notizen, Seilen, Wandpositionen und Metadaten. Cloud Sync kann diese gesperrte ZIP auch auf deinem VPS speichern.';

  @override
  String get archiveTransferStep1Title => 'Archiv exportieren';

  @override
  String get archiveTransferStep1Body =>
      'Öffne Einstellungen, wähle Archiv exportieren und füge ein Passwort hinzu, wenn du Schutz willst.';

  @override
  String get archiveTransferStep2Title => 'ZIP verschieben oder syncen';

  @override
  String get archiveTransferStep2Body =>
      'Übertrage sie mit AirDrop, USB, Drive, E-Mail oder nutze Cloud Sync mit privatem Sync-Schlüssel.';

  @override
  String get archiveTransferStep3Title => 'Sicher importieren';

  @override
  String get archiveTransferStep3Body =>
      'Installiere LifeThreads auf dem anderen Gerät, wähle Archiv importieren, gib bei Bedarf das Passwort ein und stelle wieder her, ohne bestehende Daten zu löschen.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled =>
      'Entwicklungs-Lifetime-Unlock aktiviert.';

  @override
  String get lifetimeActive => 'Lifetime aktiv';

  @override
  String get oneTimeLifetimeUnlock => 'Einmaliger Lifetime-Unlock';

  @override
  String get premiumHeroActiveTitle => 'Deine Erinnerungswand ist unbegrenzt.';

  @override
  String get premiumHeroLockedTitle =>
      'Verschiebe deine Erinnerungen sicher zwischen Geräten.';

  @override
  String get premiumHeroActiveBody =>
      'Premium Lifetime Unlock ist aktiv. Verschlüsselter Archivexport, Premium-Designs und erweiterte Layouts sind verfügbar.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'Kostenlos enthält $limit Erinnerungen. Premium ergänzt verschlüsselten Export/Import, sicheren Gerätewechsel, Designs und erweiterte Layouts.';
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
  String get benefitArchivesTitle => 'Verschlüsselte Archive';

  @override
  String get benefitArchivesBody =>
      'Exportiere und importiere eine passwortgeschützte ZIP mit Fotos, Notizen, Seilen, Layout und Metadaten.';

  @override
  String get benefitTransferTitle => 'Auf ein anderes Gerät wechseln';

  @override
  String get benefitTransferBody =>
      'Nimm deine private Erinnerungswand ohne aktive Cloud-Sync auf ein neues Telefon mit.';

  @override
  String get benefitThemesTitle => 'Premium-Wanddesigns';

  @override
  String get benefitThemesBody =>
      'Schalte reichere Wandstimmungen für Familie, Reisen, Archiv und Galerie frei.';

  @override
  String get benefitLayoutsTitle => 'Erweiterte Layouts';

  @override
  String get benefitLayoutsBody =>
      'Mehr Möglichkeiten, Fäden, Zeitleisten, Anker und Erinnerungscluster zu arrangieren.';

  @override
  String get cloudSyncPlannedTitle => 'Cloud-Sync ist später geplant';

  @override
  String get cloudSyncPlannedBody =>
      'Premium Archive ist jetzt die sichere Transferfunktion: exportieren, ZIP verschieben und auf anderem Gerät importieren.';

  @override
  String get deviceTransferHow => 'So funktioniert Gerätewechsel';

  @override
  String get lifetimeUnlock => 'Lifetime Unlock';

  @override
  String get premiumActiveOnDevice => 'Premium ist auf diesem Gerät aktiv.';

  @override
  String get onePurchaseBody =>
      'Ein Kauf. Kein Monatsabo für die erste Premium-Version. Behalte, schütze und verschiebe deine Erinnerungswand.';

  @override
  String get premiumActiveButton => 'Premium aktiv';

  @override
  String get processing => 'Wird verarbeitet...';

  @override
  String get unlockPremium => 'Premium freischalten';

  @override
  String get restorePurchase => 'Kauf wiederherstellen';

  @override
  String get enableDebugMockUnlock => 'Debug-Mock-Unlock aktivieren';

  @override
  String get purchasesHandledByGooglePlay =>
      'Käufe werden über Google Play abgewickelt. Die Freischaltung wird nach Kauf oder Wiederherstellung lokal gespeichert.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Lifetime Unlock • $price';
  }

  @override
  String get loadingPlayStoreProduct => 'Play-Store-Produkt wird geladen...';

  @override
  String get playStoreUnavailable => 'Play Store nicht verfügbar';

  @override
  String get productNotConfigured => 'Produkt nicht konfiguriert';

  @override
  String get purchasePending => 'Kauf ausstehend';

  @override
  String get purchased => 'Gekauft';

  @override
  String get restored => 'Wiederhergestellt';

  @override
  String get purchaseFailed => 'Kauf fehlgeschlagen';

  @override
  String get preparingCheckout => 'Checkout wird vorbereitet...';

  @override
  String get premiumLocalFirstTitle => 'Premium ist local-first';

  @override
  String get premiumLocalFirstBody =>
      'Premium schaltet jetzt local-first Wert frei. Cloud-Sync ist später geplant und in dieser Version nicht aktiv.';

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
  String get demoViennaTitle => 'Wiener Abendspaziergang';

  @override
  String get demoViennaDescription =>
      'Ein ruhiger Abend in Wien, so ein Moment, der warm bleibt, weil nichts perfekt sein musste.';

  @override
  String get demoViennaLocation => 'Wien, Österreich';

  @override
  String get demoLinzTitle => 'Regen und Kaffee';

  @override
  String get demoLinzDescription =>
      'Ein langsamer Nachmittag in Linz mit Kaffee, Regen am Fenster und einem Foto, das sich wie Zuhause anfühlt.';

  @override
  String get demoLinzLocation => 'Linz, Österreich';

  @override
  String get demoFamilyTitle => 'Familientisch';

  @override
  String get demoFamilyDescription =>
      'Essen, Stimmen, kleine Witze und das Gefühl, dass genau das erinnert werden sollte.';

  @override
  String get demoHomeLocation => 'Zuhause';

  @override
  String get demoLaunchTitle => 'Erste Launch-Nacht';

  @override
  String get demoLaunchDescription =>
      'Die Nacht, in der eine Idee endlich zu etwas Echtem auf einem Bildschirm wurde.';

  @override
  String get demoConnectionQuietDays => 'ruhige Tage';

  @override
  String get demoConnectionHomeFocus => 'Fokus zuhause';

  @override
  String get demoConnectionWhyItMatters => 'warum es zählt';
}
