// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get send => 'Invia';

  @override
  String get preparing => 'Preparazione...';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get languageTitle => 'Lingua';

  @override
  String get languageBody =>
      'Scegli la lingua dell\'app. Sistema segue la lingua del telefono, se LifeThreads la supporta.';

  @override
  String get systemLanguage => 'Sistema';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return 'Lingua cambiata in $language.';
  }

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyBody =>
      'LifeThreads funziona in locale: nessun account e nessun profilo pubblico. I tuoi ricordi restano su questo dispositivo, a meno che tu non esporti un backup, condivida una capsula crittografata o mostri la bacheca su un altro schermo.';

  @override
  String get viewPrivacyPolicy => 'Leggi l\'informativa sulla privacy';

  @override
  String get termsTitle => 'Condizioni d\'uso';

  @override
  String get viewTerms => 'Leggi le condizioni';

  @override
  String get betaFeedbackTitle => 'Feedback sulla beta';

  @override
  String get betaFeedbackBody =>
      'Invia un feedback sulla beta con diagnostica sicura. I log contengono solo eventi dell\'app e tipi di arresto anomalo, mai testi dei ricordi, percorsi delle foto, backup o posizioni esatte.';

  @override
  String get closedBetaBadge => 'Beta chiusa';

  @override
  String get sendFeedback => 'Invia feedback';

  @override
  String get backupArchiveBody =>
      'Salva tutto – ricordi, foto, note, fili e disposizione – in un unico file. Tienilo sul computer o nel tuo cloud, e aggiungi una password per crittografarlo.';

  @override
  String get backupArchiveTitle => 'Backup';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Sblocca';

  @override
  String get exportArchive => 'Esporta archivio';

  @override
  String get importArchive => 'Importa archivio';

  @override
  String get importCapsule => 'Importa capsula';

  @override
  String get moveDevices => 'Cambia dispositivo';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeBody =>
      'Scegli l\'atmosfera della tua bacheca privata. La versione gratuita include Stanza calda. Premium sblocca tutte le atmosfere.';

  @override
  String get oneFreeBadge => '1 gratis';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'L\'abbonamento Premium è attivo.';

  @override
  String get premiumLockedBody =>
      'Annuale o mensile: ricordi illimitati, più bacheche, storie, temi e layout.';

  @override
  String get activeBadge => 'Attivo';

  @override
  String get openPremium => 'Apri Premium';

  @override
  String get appVersionTitle => 'Versione dell\'app';

  @override
  String get clearAllDataTitle => 'Cancella tutti i dati';

  @override
  String get clearAllDataBody =>
      'Elimina da questo dispositivo tutti i ricordi, i collegamenti, le note, i chiodi e le foto copiate.';

  @override
  String get clearData => 'Cancella dati';

  @override
  String exportFailed(Object error) {
    return 'Esportazione non riuscita: $error';
  }

  @override
  String importRejected(Object message) {
    return 'Importazione rifiutata: $message';
  }

  @override
  String importFailed(Object error) {
    return 'Importazione non riuscita: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'Eliminazione non riuscita: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'Capsula rifiutata: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'Importazione della capsula non riuscita: $error';
  }

  @override
  String get clearAllDataQuestion => 'Cancellare tutti i dati?';

  @override
  String get clearAllDataQuestionBody =>
      'Questo rimuove per sempre tutti i dati locali di LifeThreads su questo dispositivo. Se vuoi conservarli, esporta prima un backup.';

  @override
  String get clearAll => 'Cancella tutto';

  @override
  String get allLocalDataCleared =>
      'Tutti i dati locali sono stati cancellati.';

  @override
  String get feedbackGeneral => 'Feedback generale';

  @override
  String get feedbackBug => 'Bug';

  @override
  String get feedbackCrash => 'Arresto anomalo';

  @override
  String get feedbackDesign => 'Problema di design';

  @override
  String get feedbackMissingFeature => 'Funzione mancante';

  @override
  String get feedbackPerformance => 'Prestazioni';

  @override
  String get betaFeedbackIntro =>
      'Scrivi cosa è successo o cosa non ti è sembrato giusto. Verrà allegata una diagnostica sicura, senza contenuti privati dei ricordi.';

  @override
  String get feedbackType => 'Tipo';

  @override
  String get feedbackLabel => 'Feedback';

  @override
  String get feedbackHint =>
      'Esempio: ho toccato Aggiungi > Foto veloce e lo schermo si è bloccato.';

  @override
  String get betaFeedbackNotIncluded =>
      'Non inclusi: titoli dei ricordi, storie, note, percorsi delle foto, percorsi dei backup, posizioni esatte.';

  @override
  String get feedbackEmpty => 'Scrivi prima un breve messaggio.';

  @override
  String get feedbackCopied =>
      'Nessuna app di posta si è aperta. Feedback copiato negli appunti per info@gkcoding.dev.';

  @override
  String themeSelected(Object theme) {
    return '$theme selezionato.';
  }

  @override
  String get onboardingHeadline => 'Crea la tua bacheca viva.';

  @override
  String get onboardingBody =>
      'Una stanza privata dei ricordi dove foto, luoghi, persone e piccole note si legano con fili di emozioni.';

  @override
  String get onboardingPrivacy =>
      'I tuoi ricordi sono privati per impostazione: nessun account e nessun profilo pubblico. Condivisione cloud crittografata e backup avvengono solo se lo scegli tu.';

  @override
  String get onboardingPrivacyShort =>
      'Nessun account e nessun profilo pubblico. I tuoi ricordi restano su questo dispositivo, a meno che tu non scelga altrimenti.';

  @override
  String get onboardingNext => 'Avanti';

  @override
  String get onboardingNameTitle => 'Come ti chiamiamo?';

  @override
  String get onboardingNameHint => 'Il tuo nome';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'Piacere di conoscerti, $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'Scegli come iniziare';

  @override
  String get onboardingGetStartedBody =>
      'Guarda una bacheca di esempio, oppure parti da una vuota e appendi i tuoi ricordi.';

  @override
  String get settingsNameTitle => 'Il tuo nome';

  @override
  String get settingsNameBody => 'Compare come saluto sulla tua bacheca.';

  @override
  String get settingsNameHint => 'Il tuo nome';

  @override
  String get settingsNameSaved => 'Nome aggiornato.';

  @override
  String get storyPrivacyTitle => 'I tuoi ricordi restano privati';

  @override
  String get storyConnectTitle => 'Collega i momenti';

  @override
  String get storyConnectText =>
      'Collega ricordi, note e luoghi perché ogni capitolo abbia un contesto.';

  @override
  String get storyWallTitle => 'Crea la tua bacheca viva';

  @override
  String get storyWallText =>
      'Inizia con una foto, poi lascia crescere la bacheca finché non sembra viva.';

  @override
  String get previewDemoWall => 'Vedi bacheca di esempio';

  @override
  String get startFresh => 'Inizia da zero';

  @override
  String get optionalDemoPreview => 'Anteprima facoltativa';

  @override
  String get quickTutorial => 'Tutorial veloce';

  @override
  String get tutorialIntro =>
      'Prima le basi – salvare, collegare, ordinare – poi tutto il resto che sa fare la tua bacheca.';

  @override
  String get gotIt => 'Ho capito';

  @override
  String get howItWorks => 'Come funziona';

  @override
  String get tutorialAddTitle => 'Aggiungi un ricordo';

  @override
  String get tutorialAddText =>
      'Tocca +, scegli Ricordo o Foto veloce, poi salva titolo, data, persone e foto. Se esci prima di salvare, viene tenuto come bozza.';

  @override
  String get tutorialConnectTitle => 'Collega i ricordi';

  @override
  String get tutorialConnectText =>
      'Apri una scheda, tocca l\'icona di collegamento, scegli i ricordi correlati e aggiungi un breve motivo.';

  @override
  String get tutorialArrangeTitle => 'Ordina la bacheca';

  @override
  String get tutorialArrangeText =>
      'Trascina schede, note e chiodi al loro posto. Vista › Ordina li dispone per data, categoria o luogo – si applica con Fine.';

  @override
  String get tutorialShowBoardTitle => 'Mostra la bacheca';

  @override
  String get tutorialShowBoardText =>
      'Apri lifethreads.gkcoding.dev/display su un altro schermo, scegli Altro › Mostra bacheca e scansiona il codice per mostrare una bacheca temporanea in sola lettura.';

  @override
  String get tutorialBackupTitle => 'Privacy e backup';

  @override
  String get tutorialBackupText =>
      'Impostazioni › Privacy › Blocco app apre LifeThreads con Face ID. Prima di cambiare telefono, esporta un backup in Impostazioni › Backup e dati.';

  @override
  String get scanDisplayQr => 'Scansiona QR dello schermo';

  @override
  String get scannerHintTitle => 'Dov\'è il codice QR?';

  @override
  String get addMemoryBeforeDisplay =>
      'Aggiungi un ricordo prima di mostrare una bacheca.';

  @override
  String get notLifeThreadsDisplayQr =>
      'Questo non è un QR di LifeThreads per lo schermo.';

  @override
  String get displayWallQuestion => 'Mostrare questa bacheca?';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads invierà un\'istantanea temporanea in sola lettura con $memoryCount ricordi alla sessione del browser che hai scansionato. Si apre su lifethreads.gkcoding.dev/display e scade da sola.';
  }

  @override
  String get displayAction => 'Mostra';

  @override
  String get soon => 'a breve';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'La bacheca è visibile con $memoryCount ricordi fino alle $expires.';
  }

  @override
  String get preparingWallDisplay => 'Preparazione della bacheca...';

  @override
  String get open => 'Apri';

  @override
  String get edit => 'Modifica';

  @override
  String get save => 'Salva';

  @override
  String get done => 'Fine';

  @override
  String get back => 'Indietro';

  @override
  String get continueAction => 'Continua';

  @override
  String get close => 'Chiudi';

  @override
  String get add => 'Aggiungi';

  @override
  String get saveReason => 'Salva motivo';

  @override
  String get chooseBackup => 'Scegli backup';

  @override
  String get chooseArchive => 'Scegli archivio';

  @override
  String get chooseCapsule => 'Scegli capsula';

  @override
  String get exportAction => 'Esporta';

  @override
  String get addToWall => 'Aggiungi alla bacheca';

  @override
  String get cinemaSkip => 'Salta';

  @override
  String get cinemaNotNow => 'Non ora';

  @override
  String get cinemaSharedChapter => 'Un capitolo condiviso';

  @override
  String get cinemaConnectedThread => 'Filo collegato';

  @override
  String get cinemaInviteTitle => 'Aggiungere questo ricordo alla tua bacheca?';

  @override
  String get useSelected => 'Usa selezionate';

  @override
  String photoGridItem(String date) {
    return 'Foto del $date';
  }

  @override
  String get noPhotosFound => 'Nessuna foto trovata.';

  @override
  String get manage => 'Gestisci';

  @override
  String get manageAccess => 'Gestisci accesso';

  @override
  String get saveNow => 'Salva ora';

  @override
  String get hangOnWall => 'Appendi alla bacheca';

  @override
  String get placeHere => 'Metti qui';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get viewPremium => 'Vedi Premium';

  @override
  String get memoryNotFound => 'Ricordo non trovato';

  @override
  String get memoryTypeMoment => 'Momento';

  @override
  String get memoryTypeTrip => 'Viaggio';

  @override
  String get memoryTypePerson => 'Persona';

  @override
  String get memoryTypePlace => 'Luogo';

  @override
  String get memoryTypeNote => 'Nota';

  @override
  String get memoryTypeMomentDescription => 'Una piccola scena da conservare';

  @override
  String get memoryTypeTripDescription => 'Un viaggio o una gita';

  @override
  String get memoryTypePersonDescription => 'Qualcuno di importante';

  @override
  String get memoryTypePlaceDescription => 'Un luogo che ha un significato';

  @override
  String get memoryTypeNoteDescription =>
      'Un pensiero, una citazione o un promemoria';

  @override
  String get categoryPersonal => 'Personale';

  @override
  String get categoryFamily => 'Famiglia';

  @override
  String get categoryTravel => 'Viaggi';

  @override
  String get feelingWarm => 'Affettuoso';

  @override
  String get feelingNostalgic => 'Nostalgico';

  @override
  String get feelingProud => 'Orgoglioso';

  @override
  String get feelingCalm => 'Sereno';

  @override
  String get feelingImportant => 'Importante';

  @override
  String get feelingWarmDescription => 'Dolce, vicino, pieno d\'amore.';

  @override
  String get feelingNostalgicDescription =>
      'Un ricordo che ti riporta indietro.';

  @override
  String get feelingProudDescription =>
      'Un momento che ha dimostrato qualcosa.';

  @override
  String get feelingCalmDescription => 'Quieto, sicuro, in pace.';

  @override
  String get feelingImportantDescription =>
      'Un ricordo che ha cambiato la storia.';

  @override
  String get addPeopleHint =>
      'Aggiungi le persone di questo momento. I contatti restano sul dispositivo.';

  @override
  String get addPerson => 'Aggiungi persona';

  @override
  String get editPerson => 'Modifica persona';

  @override
  String get chooseFromContacts => 'Scegli dai contatti';

  @override
  String get personNameLabel => 'Nome';

  @override
  String get personNameHint => 'Scrivi per cercare persone salvate';

  @override
  String get relationshipLabel => 'Relazione';

  @override
  String get relationshipHint => 'Amica, madre, partner...';

  @override
  String get phoneOptionalLabel => 'Telefono (facoltativo)';

  @override
  String get emailOptionalLabel => 'Email (facoltativa)';

  @override
  String get nameRelationshipRequired => 'Nome e relazione sono obbligatori.';

  @override
  String get contactAccessDenied =>
      'L\'accesso ai contatti non è stato concesso.';

  @override
  String get couldNotOpenContacts => 'Impossibile aprire i contatti.';

  @override
  String get chooseContact => 'Scegli contatto';

  @override
  String get searchContacts => 'Cerca contatti';

  @override
  String get noContactsFound => 'Nessun contatto trovato.';

  @override
  String get unnamedContact => 'Contatto senza nome';

  @override
  String get contactRelationship => 'Contatto';

  @override
  String get couldNotLoadContacts => 'Impossibile caricare i contatti.';

  @override
  String get saveMomentTitle => 'Salva un momento';

  @override
  String get todayEyebrow => 'Oggi';

  @override
  String get addMemoryStepTitle => 'Cos\'è successo che non vuoi perdere?';

  @override
  String get addMemoryStepSubtitle =>
      'Scrivi una riga, aggiungi una foto se ce l\'hai e salva. I dettagli possono aspettare.';

  @override
  String get momentLabel => 'Momento';

  @override
  String get momentHint =>
      'Cena con Lara, primo lancio, passeggiata tranquilla...';

  @override
  String get storyWorthLabel => 'Perché vale la pena conservarlo?';

  @override
  String get storyWorthHint => 'Bastano poche parole.';

  @override
  String get feelingEyebrow => 'Emozione';

  @override
  String get feelingStepTitle => 'Che emozione deve darti quando torna?';

  @override
  String get feelingStepSubtitle =>
      'Così sarà più facile ritrovare il ricordo in futuro.';

  @override
  String get contextEyebrow => 'Contesto';

  @override
  String get whenWasItTitle => 'Quando è stato?';

  @override
  String get photoGpsStepSubtitle =>
      'La mappa usa il GPS salvato nelle foto scelte. Se una foto non ha GPS, non viene mostrato nessun luogo.';

  @override
  String get peopleThreadsEyebrow => 'Persone e fili';

  @override
  String get peopleThreadsTitle => 'A chi o a cosa è collegato?';

  @override
  String get peopleThreadsSubtitle =>
      'I dettagli facoltativi trasformano momenti singoli in un filo della vita.';

  @override
  String get connectExistingMemoryLabel => 'Collega a un ricordo esistente';

  @override
  String get noConnectionYet => 'Ancora nessun collegamento';

  @override
  String get connectionReasonLabel => 'Perché sono collegati?';

  @override
  String get connectionReasonHint =>
      'Esempio: stesso viaggio, stessa persona, prima / dopo...';

  @override
  String get writeMomentOrPhotoFirst =>
      'Scrivi prima un momento o aggiungi una foto.';

  @override
  String get todaysMoment => 'Il momento di oggi';

  @override
  String get savedFromTodaysPrompt => 'Salvato dalla domanda di oggi.';

  @override
  String get saveItBeforeItFades => 'Salvalo prima che svanisca';

  @override
  String get chooseDate => 'Scegli data';

  @override
  String get dateLabel => 'Data';

  @override
  String get untitledMemory => 'Ricordo senza titolo';

  @override
  String get organize => 'Organizza';

  @override
  String get memoryShape => 'Forma del ricordo';

  @override
  String get wallCategory => 'Categoria della bacheca';

  @override
  String get privatePhotos => 'Foto private';

  @override
  String get pick => 'Scegli';

  @override
  String get addMore => 'Aggiungi altre';

  @override
  String get takePhoto => 'Scatta foto';

  @override
  String get takePhotosNow => 'Scatta foto ora';

  @override
  String get takePhotosFabTooltip => 'Scatta foto per un nuovo ricordo';

  @override
  String get takeAnotherPhoto => 'Scatta un\'altra foto';

  @override
  String get continueWithPhotos => 'Continua con queste foto';

  @override
  String get addPhotosToMemory => 'Aggiungi al ricordo';

  @override
  String get takeAnotherOrContinueBody =>
      'Continua a scattare per questo ricordo, oppure vai avanti e aggiungi la storia.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foto scattate',
      one: '1 foto scattata',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads copia le foto scelte nella memoria privata dell\'app e conserva data e posizione, se disponibili.';

  @override
  String get limitedPhotoAccessActive =>
      'L\'accesso limitato alle foto è attivo. Puoi consentire altre foto.';

  @override
  String get selectPhotos => 'Seleziona foto';

  @override
  String get photoAccessOff => 'L\'accesso alle foto è disattivato';

  @override
  String get photoAccessOffBody =>
      'Attiva l\'accesso alle foto per scegliere i ricordi. Le tue foto restano su questo dispositivo.';

  @override
  String get freeMemoryLimitReached => 'Limite gratuito raggiunto';

  @override
  String get freeMemoryLimitBody =>
      'Le bacheche gratuite includono 30 ricordi. Passa a Premium per continuare a far crescere la tua bacheca.';

  @override
  String get photoAccessNeeded => 'Serve prima l\'accesso alle foto.';

  @override
  String get quickPhotoMemory => 'Foto veloce';

  @override
  String get quickPhotoDescription =>
      'Una foto da conservare. Aggiungi la storia quando vuoi.';

  @override
  String get hangQuickPhoto => 'Appendi foto veloce';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'GPS della foto rilevato: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'Nessun GPS nella foto. Questo ricordo non comparirà sulla mappa.';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • $photoCount foto';
  }

  @override
  String metadataDates(int count, int total) {
    return '$count/$total date';
  }

  @override
  String metadataLocations(int count, int total) {
    return '$count/$total posizioni';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total dimensioni';
  }

  @override
  String newSelected(int count) {
    return '$count nuove selezionate';
  }

  @override
  String selectedCount(int count) {
    return '$count selezionate';
  }

  @override
  String get editMemoryTitle => 'Modifica ricordo';

  @override
  String get storyPanel => 'Storia';

  @override
  String get memoryTitleLabel => 'Titolo del ricordo';

  @override
  String get addTitleValidation => 'Aggiungi un titolo';

  @override
  String get storyDescriptionLabel => 'Storia / descrizione';

  @override
  String get addStoryValidation => 'Aggiungi una breve storia';

  @override
  String get shapeFeelingTitle => 'Forma ed emozione';

  @override
  String get memoryTypeLabel => 'Tipo di ricordo';

  @override
  String get feelingLabel => 'Emozione';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get timePhotoGpsTitle => 'Data e GPS della foto';

  @override
  String get memoryDateLabel => 'Data del ricordo';

  @override
  String get peopleTitle => 'Persone';

  @override
  String get galleryTitle => 'Galleria';

  @override
  String get addPhotos => 'Aggiungi foto';

  @override
  String get saveMemory => 'Salva ricordo';

  @override
  String get memorySaveFailed => 'Impossibile salvare questo ricordo. Riprova.';

  @override
  String get passwordOnlySpaces => 'La password non può contenere solo spazi.';

  @override
  String get somethingWentWrong => 'Qualcosa è andato storto. Riprova.';

  @override
  String get mapUnavailable => 'La mappa non è disponibile al momento.';

  @override
  String get coverPhoto => 'Foto di copertina';

  @override
  String get galleryPhoto => 'Foto della galleria';

  @override
  String get setAsCover => 'Imposta come copertina';

  @override
  String get replacePhoto => 'Sostituisci foto';

  @override
  String get removePhoto => 'Rimuovi foto';

  @override
  String get choosePhoto => 'Scegli foto';

  @override
  String get threadReasonsTitle => 'Motivi dei fili';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'Crea altri ricordi prima di collegarli.';

  @override
  String get connectionHeaderBody =>
      'Collega i ricordi con un motivo. La corda deve spiegare perché due momenti stanno insieme.';

  @override
  String get connectedMemory => 'ricordo collegato';

  @override
  String get whyConnectedTitle => 'Perché sono collegati?';

  @override
  String get exportPremiumArchiveTitle => 'Esporta backup';

  @override
  String get importArchiveTitle => 'Importa archivio';

  @override
  String get archiveExportBody =>
      'Aggiungi una password per crittografare l\'archivio. Lascia vuoto per un normale zip locale.';

  @override
  String get archiveImportBody =>
      'Se l\'archivio è crittografato, inserisci la password. Lascia vuoto per backup vecchi o non protetti.';

  @override
  String get archivePasswordOptional => 'Password dell\'archivio (facoltativa)';

  @override
  String get archivePasswordLabel => 'Password dell\'archivio';

  @override
  String get archivePasswordWarning =>
      'Conserva la password in un posto sicuro. Se la perdi, non si può recuperare.';

  @override
  String get sendArchiveTitle => 'Invia archivio LifeThreads';

  @override
  String get sendArchiveSubject => 'Archivio dei ricordi LifeThreads';

  @override
  String get sendEncryptedArchiveText =>
      'Archivio LifeThreads crittografato. Usa la password che hai scelto per importarlo su un altro dispositivo.';

  @override
  String get sendArchiveText =>
      'Archivio LifeThreads. Importalo in LifeThreads per aprire la tua bacheca dei ricordi su un altro dispositivo.';

  @override
  String get archiveReadyToSend =>
      'Backup pronto. Conservalo in un posto sicuro, non su questo telefono.';

  @override
  String get archiveNotSaved =>
      'Backup non salvato. Esporta di nuovo quando vuoi.';

  @override
  String get archiveSharingUnavailable =>
      'La condivisione non è disponibile su questo dispositivo.';

  @override
  String archiveShareFailed(Object error) {
    return 'Archivio salvato, ma la condivisione non è riuscita: $error';
  }

  @override
  String get archiveImportedTitle => 'Archivio importato';

  @override
  String get memoriesLabel => 'Ricordi';

  @override
  String get photosLabel => 'Foto';

  @override
  String get wallNotesNailsLabel => 'Note / chiodi';

  @override
  String get connectionsLabel => 'Collegamenti';

  @override
  String get archiveImportSummary =>
      'La tua bacheca attuale è stata mantenuta. I ricordi importati sono stati aggiunti in sicurezza.';

  @override
  String get shareEncryptedCapsuleTitle => 'Condividi capsula crittografata';

  @override
  String get openSharedCapsuleTitle => 'Apri capsula condivisa';

  @override
  String get exportMemoryCapsuleTitle => 'Esporta capsula del ricordo';

  @override
  String get importCapsuleDialogTitle => 'Importa capsula';

  @override
  String get secureSharePasswordBody =>
      'Crea una password prima di caricare questa capsula. Invia la password separatamente a chi la riceve.';

  @override
  String get sharedCapsulePasswordBody =>
      'Inserisci la password che hai ricevuto per questo ricordo condiviso.';

  @override
  String get capsuleExportBody =>
      'Aggiungi una password se vuoi proteggere questo ricordo prima di inviarlo. Lascia vuoto per una capsula normale.';

  @override
  String get capsuleImportBody =>
      'Se la capsula ha una password, inseriscila. Altrimenti lascia vuoto.';

  @override
  String get capsulePasswordLabel => 'Password della capsula';

  @override
  String get sharedCapsulePasswordLabel => 'Password della capsula condivisa';

  @override
  String get capsulePasswordOptional => 'Password della capsula (facoltativa)';

  @override
  String get capsulePasswordWarning =>
      'LifeThreads non potrà recuperare questa password.';

  @override
  String get passwordRequiredCloudSharing =>
      'Per la condivisione cloud serve una password.';

  @override
  String get createSecureShare => 'Crea condivisione sicura';

  @override
  String get previewMemory => 'Anteprima ricordo';

  @override
  String get sendCapsuleTitle => 'Condividi ricordo LifeThreads';

  @override
  String get sendCapsuleSubject => 'Capsula del ricordo LifeThreads';

  @override
  String get sendEncryptedCapsuleText =>
      'Ciao, ho condiviso con te un ricordo protetto di LifeThreads. Usa la password che ti ho mandato per importarlo.';

  @override
  String get sendCapsuleText =>
      'Ciao, ho condiviso con te un ricordo di LifeThreads. Importa la capsula in LifeThreads per aggiungerlo alla tua bacheca.';

  @override
  String get capsuleReadyToSend => 'Capsula pronta da inviare.';

  @override
  String get capsuleSavedLater =>
      'Capsula salvata. Puoi condividerla più tardi.';

  @override
  String get capsuleSharingUnavailable =>
      'Capsula salvata, ma la condivisione non è disponibile.';

  @override
  String capsuleShareFailed(Object error) {
    return 'Capsula salvata, ma la condivisione non è riuscita: $error';
  }

  @override
  String get importThisMemory => 'Importare questo ricordo?';

  @override
  String get noStoryTextIncluded => 'Nessun testo della storia incluso.';

  @override
  String get placeLabel => 'Luogo';

  @override
  String get notesLabel => 'Note';

  @override
  String get capsulePasswordProtected =>
      'Questa capsula era protetta da password.';

  @override
  String get openingSharedMemory => 'Apertura del ricordo condiviso...';

  @override
  String get lifeThreadsMemoryTitle => 'Ricordo LifeThreads';

  @override
  String shareMemoryText(Object url) {
    return 'Ciao, ho condiviso un ricordo con te su LifeThreads.\n\n$url';
  }

  @override
  String get shareLinkReady => 'Link di condivisione pronto.';

  @override
  String get shareLinkCreated => 'Link di condivisione creato.';

  @override
  String get shareLinkUnavailable =>
      'Link creato, ma la condivisione non è disponibile.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label Il link scade da solo. Puoi eliminarlo ora.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'Condivisione cloud non riuscita: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'Link del ricordo condiviso eliminato.';

  @override
  String get creatingSecureMemoryLink => 'Creazione del link sicuro...';

  @override
  String get shareMemoryCapsule => 'Condividi capsula';

  @override
  String get editStory => 'Modifica storia';

  @override
  String get metaType => 'Tipo';

  @override
  String get metaFeeling => 'Emozione';

  @override
  String get metaCategory => 'Categoria';

  @override
  String get metaDate => 'Data';

  @override
  String get storyEyebrow => 'Storia';

  @override
  String get whyMemoryMatters => 'Perché questo ricordo conta';

  @override
  String get galleryEyebrow => 'Galleria';

  @override
  String editSectionTooltip(String section) {
    return 'Modifica $section';
  }

  @override
  String get openInMaps => 'Apri in Mappe';

  @override
  String get memoryChangesSaved => 'Modifiche salvate.';

  @override
  String get memoryDeletedToast => 'Ricordo eliminato.';

  @override
  String get noteDeletedToast => 'Nota eliminata.';

  @override
  String get nailDeletedToast => 'Chiodo rimosso.';

  @override
  String get undo => 'Annulla';

  @override
  String photoPlaceDetected(String place) {
    return 'Luogo dalla foto: $place';
  }

  @override
  String get settingsGroupYou => 'Tu';

  @override
  String get settingsGroupReminders => 'Promemoria';

  @override
  String get settingsGroupMore => 'Altro';

  @override
  String get backupDataTitle => 'Backup e dati';

  @override
  String get backupDataSubtitle => 'Backup, ripristino, nuovo telefono';

  @override
  String get aboutHelpTitle => 'Info e aiuto';

  @override
  String get aboutHelpSubtitle => 'Feedback, privacy, musica, versione';

  @override
  String get discardChangesTitle => 'Annullare le modifiche?';

  @override
  String get discardChangesBody => 'Quello che hai cambiato qui andrà perso.';

  @override
  String get discardChanges => 'Scarta';

  @override
  String get keepEditing => 'Continua a modificare';

  @override
  String get settingsGroupPrivacy => 'Privacy';

  @override
  String get appLockTitle => 'Blocco app';

  @override
  String get appLockSubtitle => 'Face ID o codice per aprire LifeThreads';

  @override
  String get appLockReason => 'Sblocca i tuoi ricordi';

  @override
  String get appLockLockedTitle => 'LifeThreads è bloccato';

  @override
  String get appLockUnlock => 'Sblocca';

  @override
  String get appLockUnavailable =>
      'Configura prima Face ID o un codice su questo telefono.';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Ti aspetta un ricordo di $years anni fa.',
      one: 'Ti aspetta un ricordo di 1 anno fa.',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Cerca';

  @override
  String get searchHint => 'Titolo, luogo, persona o anno';

  @override
  String get searchClear => 'Cancella ricerca';

  @override
  String get searchNoResults => 'Nessun ricordo corrisponde.';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricordi',
      one: '1 ricordo',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => 'Cerca ricordi';

  @override
  String get premiumFeatureWalls => 'Più bacheche';

  @override
  String get newWall => 'Nuova bacheca';

  @override
  String get wallNameLabel => 'Nome della bacheca';

  @override
  String get newWallHint => 'es. Viaggi 2025';

  @override
  String get createWall => 'Crea';

  @override
  String get renameWall => 'Rinomina';

  @override
  String get deleteWall => 'Elimina bacheca';

  @override
  String deleteWallQuestion(String name) {
    return 'Eliminare “$name”?';
  }

  @override
  String get deleteWallBody =>
      'I suoi ricordi passano a La mia bacheca; non si perde nulla.';

  @override
  String get personalWallSubtitle => 'La tua bacheca, su questo dispositivo';

  @override
  String get wallOptions => 'Opzioni bacheca';

  @override
  String get moveToWall => 'Sposta nella bacheca…';

  @override
  String movedToWall(String name) {
    return 'Spostato in $name.';
  }

  @override
  String get hideMemory => 'Nascondi';

  @override
  String get unhideMemory => 'Mostra di nuovo';

  @override
  String get memoryHiddenToast =>
      'Nascosto. Lo trovi in Vista › Ricordi nascosti.';

  @override
  String get showHiddenMemories => 'Ricordi nascosti';

  @override
  String get showHiddenReason => 'Mostra ricordi nascosti';

  @override
  String get yearThreadFirstTitle => 'Il tuo primo Filo dell\'anno';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricordi su 3',
      one: '1 ricordo su 3',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => 'Oppure crea una storia ora';

  @override
  String get moveMemoriesHere => 'Sposta qui dei ricordi';

  @override
  String get moveMemoriesTitle => 'Scegli i ricordi da spostare qui';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sposta $count ricordi',
      one: 'Sposta 1 ricordo',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'Mostra tutto';

  @override
  String get addAMemory => 'Aggiungi un ricordo';

  @override
  String get mapAddPhotoMemory => 'Aggiungi una foto con il suo luogo';

  @override
  String get searchSuggestions => 'Prova con uno dei tuoi';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Questa settimana, $years anni fa',
      one: 'Questa settimana, 1 anno fa',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => 'Chi c\'era?';

  @override
  String get premiumPlanYearly => 'Annuale';

  @override
  String get premiumPlanMonthly => 'Mensile';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/anno';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Risparmia il $percent%';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'Il pagamento viene addebitato sul tuo account $store. L\'abbonamento si rinnova automaticamente ogni anno, a meno che tu non lo annulli almeno 24 ore prima della fine del periodo in corso. Gestiscilo o annullalo nelle impostazioni del tuo account $store.';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foto salvate',
      one: '1 foto salvata',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => 'Persone';

  @override
  String get partOfMemory => 'Parte di questo ricordo';

  @override
  String get notesEyebrow => 'Note';

  @override
  String get attachedThoughts => 'Pensieri allegati';

  @override
  String get stickyNote => 'Post-it';

  @override
  String get placeEyebrow => 'Luogo';

  @override
  String get threadsEyebrow => 'Fili';

  @override
  String get connectedMemories => 'Ricordi collegati';

  @override
  String get noConnectedMemoriesYet =>
      'Ancora nessun ricordo collegato. Collega questo capitolo a un altro momento per iniziare un filo della vita visibile.';

  @override
  String get backToWall => 'Torna alla bacheca';

  @override
  String get addTextToWall => 'Aggiungi testo alla bacheca';

  @override
  String get addTextAction => 'Aggiungi testo';

  @override
  String get textNoteHint =>
      'Scrivi un piccolo ricordo, una citazione o una nota...';

  @override
  String get placeTextNote => 'Posiziona nota';

  @override
  String get placeRopeAnchor => 'Posiziona ancoraggio';

  @override
  String get nailSubtitle =>
      'Un chiodo può collegare a mano le corde tra i ricordi.';

  @override
  String get clearDemoWallQuestion => 'Cancellare la bacheca di esempio?';

  @override
  String get clearDemoWallBody =>
      'Rimuove i ricordi di esempio così puoi iniziare con una bacheca privata vuota.';

  @override
  String get importBackupQuestion => 'Importare il backup?';

  @override
  String get importBackupBody =>
      'Ripristina i ricordi da un archivio LifeThreads e mantiene la tua bacheca attuale.';

  @override
  String get deleteMemoryQuestion => 'Eliminare il ricordo?';

  @override
  String get deleteMemoryBody =>
      'Rimuove il ricordo e tutti i suoi collegamenti sulla bacheca.';

  @override
  String get editText => 'Modifica testo';

  @override
  String get editTextTitle => 'Modifica testo';

  @override
  String get connectRope => 'Collega corda';

  @override
  String get connectRopeSubtitle => 'Collega questo chiodo ai ricordi.';

  @override
  String get deleteNail => 'Elimina chiodo';

  @override
  String get connectNailTitle => 'Collega il chiodo ai ricordi';

  @override
  String get connectNailSubtitle =>
      'I ricordi scelti saranno appesi a questo ancoraggio.';

  @override
  String get timelineTitle => 'Cronologia';

  @override
  String get timelineSubtitle => 'I tuoi ricordi in ordine di tempo.';

  @override
  String get noMemoriesFilter => 'Nessun ricordo con questo filtro';

  @override
  String get noMemoriesFilterBody =>
      'Cambia filtro o aggiungi un ricordo per creare la cronologia.';

  @override
  String get memoryMapTitle => 'Mappa dei ricordi';

  @override
  String get memoryMapSubtitle => 'I tuoi ricordi raggruppati per luogo.';

  @override
  String get noMappedMemories => 'Ancora nessun ricordo sulla mappa';

  @override
  String get displayWallTooltip => 'Mostra bacheca';

  @override
  String get tutorialTooltip => 'Tutorial';

  @override
  String get settingsTooltip => 'Impostazioni';

  @override
  String get freeformLayout => 'Libero';

  @override
  String get categoryLayout => 'Categoria';

  @override
  String get locationLayout => 'Luogo';

  @override
  String get saveToday => 'Salva oggi';

  @override
  String get rememberThis => 'Ricorda questo';

  @override
  String get whatHappenedToday => 'Cos\'è successo oggi?';

  @override
  String get tapToOpenDrag => 'Tocca per aprire • trascina per spostare';

  @override
  String get demoWallPreview =>
      'Bacheca di esempio. Cancellala quando vuoi iniziare da zero.';

  @override
  String get clearDemo => 'Cancella esempio';

  @override
  String get chooseQuickPhoto => 'Scegli foto veloce';

  @override
  String get wallView => 'Bacheca';

  @override
  String get timelineView => 'Cronologia';

  @override
  String get mapView => 'Mappa';

  @override
  String get wallFilterAll => 'Tutti';

  @override
  String get wallViewButton => 'Vista';

  @override
  String get wallShowAs => 'Mostra come';

  @override
  String get wallArrange => 'Ordina';

  @override
  String get wallShowOnly => 'Mostra';

  @override
  String get layoutByDate => 'Per data';

  @override
  String get moreActionsTooltip => 'Altro';

  @override
  String get addToWallTitle => 'Aggiungi alla tua bacheca';

  @override
  String get expandableMemory => 'Ricordo';

  @override
  String get expandableMemorySubtitle => 'Storia guidata completa';

  @override
  String get expandableQuickPhoto => 'Foto veloce';

  @override
  String get expandableQuickPhotoSubtitle => 'Scegli una foto e appendila';

  @override
  String get expandableTextNote => 'Nota di testo';

  @override
  String get expandableTextNoteSubtitle => 'Un pensiero sulla bacheca';

  @override
  String get expandableNail => 'Chiodo / ancoraggio';

  @override
  String get expandableNailSubtitle => 'Punto manuale per le corde';

  @override
  String get startWithOneThing => 'Inizia con una cosa di oggi';

  @override
  String get emptyWallBody =>
      'Salva un momento prima che svanisca. Basta una frase o una foto.';

  @override
  String get usePhoto => 'Usa una foto';

  @override
  String get editMemoryTooltip => 'Modifica ricordo';

  @override
  String get connectMemoryTooltip => 'Collega ricordo';

  @override
  String get archiveTransferTitle => 'Apri su un altro dispositivo';

  @override
  String get archiveTransferHeroTitle =>
      'Sposta i tuoi ricordi tra dispositivi in sicurezza.';

  @override
  String get archiveTransferHeroBody =>
      'Un backup è uno zip con ricordi, foto, note, fili, posizioni sulla bacheca e metadati, protetto da password se vuoi. Non teniamo copie: decidi tu dove va.';

  @override
  String get archiveTransferStep1Title => 'Esporta un archivio';

  @override
  String get archiveTransferStep1Body =>
      'Apri Impostazioni, scegli Esporta archivio e aggiungi una password se vuoi proteggerlo.';

  @override
  String get archiveTransferStep2Title => 'Sposta lo zip';

  @override
  String get archiveTransferStep2Body =>
      'Trasferiscilo con AirDrop, USB, il tuo cloud o via email.';

  @override
  String get archiveTransferStep3Title => 'Importa in sicurezza';

  @override
  String get archiveTransferStep3Body =>
      'Installa LifeThreads sull\'altro dispositivo, scegli Importa archivio, inserisci la password se serve e ripristina senza cancellare i dati esistenti.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled =>
      'Sblocco Premium di sviluppo attivato.';

  @override
  String get lifetimeActive => 'Abbonamento attivo';

  @override
  String get oneTimeLifetimeUnlock => 'Annuale o mensile';

  @override
  String get premiumHeroActiveTitle =>
      'La tua bacheca dei ricordi è illimitata.';

  @override
  String get premiumHeroLockedTitle => 'Trasforma i tuoi ricordi in storie.';

  @override
  String get premiumHeroActiveBody =>
      'Il tuo abbonamento Premium è attivo. Storie con musica, Filo dell\'anno, bacheche di famiglia e ricordi illimitati sono tuoi.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'La versione gratuita include $limit ricordi e backup completi. Premium aggiunge storie e film con musica, Filo dell\'anno, bacheche di famiglia e ricordi illimitati.';
  }

  @override
  String get premiumMemories => 'Ricordi Premium';

  @override
  String get freeMemories => 'Ricordi gratuiti';

  @override
  String get unlimited => 'illimitati';

  @override
  String get benefitUnlimitedTitle => 'Ricordi illimitati';

  @override
  String get benefitUnlimitedBody =>
      'Nessun limite di 30 ricordi. La bacheca cresce insieme alla tua vita.';

  @override
  String get benefitThemesTitle => 'Temi Premium';

  @override
  String get benefitThemesBody =>
      'Sblocca atmosfere più ricche, temi stagionali e Auto in base all\'ora.';

  @override
  String get benefitLayoutsTitle => 'Layout avanzati';

  @override
  String get benefitLayoutsBody =>
      'Più modi per disporre fili, cronologie, ancoraggi e gruppi di ricordi.';

  @override
  String get lifetimeUnlock => 'Abbonamento Premium';

  @override
  String get premiumActiveOnDevice => 'Premium è attivo su questo dispositivo.';

  @override
  String onePurchaseBody(String store) {
    return 'Abbonati ogni anno o ogni mese per storie con musica, Filo dell\'anno, bacheche di famiglia e ricordi illimitati. Annulla quando vuoi nelle impostazioni di $store.';
  }

  @override
  String get premiumActiveButton => 'Premium attivo';

  @override
  String get processing => 'Elaborazione...';

  @override
  String get unlockPremium => 'Abbonati a Premium';

  @override
  String get restorePurchase => 'Ripristina abbonamento';

  @override
  String get enableDebugMockUnlock => 'Attiva sblocco di prova';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'Il pagamento viene addebitato sul tuo account $store. L\'abbonamento si rinnova automaticamente ogni mese, a meno che tu non lo annulli almeno 24 ore prima della fine del periodo in corso. Gestiscilo o annullalo nelle impostazioni del tuo account $store.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'L\'aggiornamento dello store non è riuscito. Riprova.';

  @override
  String get premiumMessageStoreUnavailable =>
      'Gli acquisti non sono disponibili su questo dispositivo.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium non è ancora disponibile nello store. Riprova più tardi.';

  @override
  String get premiumMessageLoadFailed =>
      'Impossibile caricare Premium dallo store. Riprova.';

  @override
  String get premiumMessageOpeningCheckout => 'Apertura del pagamento…';

  @override
  String get premiumMessageCheckoutFailed =>
      'Impossibile aprire il pagamento. Riprova.';

  @override
  String get premiumMessageChecking => 'Verifica dell\'abbonamento…';

  @override
  String get premiumMessageRestoreFailed => 'Ripristino non riuscito. Riprova.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'Nessun abbonamento Premium attivo trovato.';

  @override
  String get premiumMessagePending =>
      'Il tuo acquisto è in sospeso. Premium si sblocca appena viene approvato.';

  @override
  String get premiumMessagePurchaseFailed =>
      'L\'acquisto non è andato a buon fine. Riprova.';

  @override
  String get premiumMessageCanceled => 'Acquisto annullato.';

  @override
  String get premiumMessageRestored =>
      'Il tuo abbonamento Premium è stato ripristinato.';

  @override
  String get premiumMessageActive => 'Il tuo abbonamento Premium è attivo.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/mese';
  }

  @override
  String get loadingPlayStoreProduct => 'Caricamento dell\'abbonamento…';

  @override
  String get playStoreUnavailable => 'Lo store non è disponibile al momento';

  @override
  String get productNotConfigured => 'Premium non è disponibile al momento';

  @override
  String get purchasePending => 'Acquisto in sospeso';

  @override
  String get purchased => 'Acquistato';

  @override
  String get restored => 'Ripristinato';

  @override
  String get premiumTryAgain => 'Riprova';

  @override
  String get purchaseFailed => 'Acquisto non riuscito';

  @override
  String get preparingCheckout => 'Preparazione del pagamento...';

  @override
  String get premiumLocalFirstTitle => 'Premium resta in locale';

  @override
  String get premiumLocalFirstBody =>
      'I tuoi ricordi restano sul tuo dispositivo, e i backup sono gratis per tutti.';

  @override
  String get noMappedMemoriesBody =>
      'Aggiungi foto con dati GPS per vedere i ricordi qui.';

  @override
  String get peopleLabel => 'Persone';

  @override
  String get connect => 'Collega';

  @override
  String get themeWarmMemoryRoom => 'Stanza calda';

  @override
  String get themeWarmMemoryRoomDescription =>
      'Calore scuro e morbido, luce dorata e la profondità di una stanza privata.';

  @override
  String get themeMidnightArchive => 'Archivio di mezzanotte';

  @override
  String get themeMidnightArchiveDescription =>
      'Sala d\'archivio blu profondo con la quiete di un museo.';

  @override
  String get themeSoftPaperWall => 'Carta morbida';

  @override
  String get themeSoftPaperWallDescription =>
      'Carta color crema, ombre d\'inchiostro e la calma di uno scrapbook.';

  @override
  String get themeTravelCorkboard => 'Sughero da viaggio';

  @override
  String get themeTravelCorkboardDescription =>
      'Il calore del sughero con tocchi di mappa per viaggi e luoghi.';

  @override
  String get themeAutoTitle => 'Auto in base all\'ora';

  @override
  String get themeAutoDescription =>
      'Carta morbida di giorno, Stanza calda la sera, Archivio di mezzanotte di notte.';

  @override
  String get themeAutoSelected => 'La tua bacheca ora segue l\'ora del giorno.';

  @override
  String get themeSeasonalTitle => 'Stagionali';

  @override
  String get themeSeasonalBody =>
      'Temi Premium limitati, ognuno disponibile solo nella sua stagione.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Fino al $dateString';
  }

  @override
  String get themeUseButton => 'Usa questo tema';

  @override
  String get themeInUse => 'In uso';

  @override
  String get themeUnlockButton => 'Sblocca con Premium';

  @override
  String get themeAutumnHarvest => 'Raccolto d\'autunno';

  @override
  String get themeAutumnHarvestDescription =>
      'Luce ambrata, schede di carta kraft e il bagliore delle foglie che cadono.';

  @override
  String get themeWinterLights => 'Luci d\'inverno';

  @override
  String get themeWinterLightsDescription =>
      'Schede brinate e lucine calde in una fredda notte blu.';

  @override
  String get themeSpringBlossom => 'Fiori di primavera';

  @override
  String get themeSpringBlossomDescription =>
      'Schede di fiori pallidi con un tenue bagliore rosa.';

  @override
  String get themeSummerEvening => 'Sera d\'estate';

  @override
  String get themeSummerEveningDescription =>
      'Colori del tramonto e schede da foto istantanea.';

  @override
  String get themeYearRoundTitle => 'Sempre disponibili';

  @override
  String get themeComingTitle => 'In arrivo';

  @override
  String get themeComingBody =>
      'Guarda le prossime stagioni. Ogni tema si apre il primo giorno della sua stagione.';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Dal $dateString';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vedi tutti i temi, $count per questa stagione',
      one: 'Vedi tutti i temi, 1 per questa stagione',
      zero: 'Vedi tutti i temi',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => 'Al mare';

  @override
  String get themeSeasideDescription =>
      'Acqua turchese, carta color sabbia e calda luce d\'estate.';

  @override
  String get themeSnowyCabin => 'Baita innevata';

  @override
  String get themeSnowyCabinDescription =>
      'Legno davanti al camino, schede brinate e neve soffice fuori.';

  @override
  String get themeSpringMeadow => 'Prato di primavera';

  @override
  String get themeSpringMeadowDescription =>
      'Erba fresca, schede chiare e sole giallo.';

  @override
  String get themeMistyForest => 'Bosco nella nebbia';

  @override
  String get themeMistyForestDescription =>
      'Pini silenziosi, nebbia mattutina e foglie dorate.';

  @override
  String get demoFirstDanceTitle => 'Il nostro primo ballo';

  @override
  String get demoFirstDanceStory =>
      'La band ha suonato la nostra canzone e tutto il fienile è rimasto in silenzio. Ti ho pestato il piede due volte, hai riso per tutto il tempo, e per tre minuti non c\'era nessun altro.';

  @override
  String get demoFirstDancePlace => 'Salisburgo';

  @override
  String get demoNewbornTitle => 'Benvenuta a casa, Lina';

  @override
  String get demoNewbornStory =>
      'Tutta la sua manina stava intorno a un dito. La prima mattina tranquilla a casa.';

  @override
  String get demoNewbornPlace => 'Vienna';

  @override
  String get demoBeachSunsetTitle => 'Estate al mare';

  @override
  String get demoBeachSunsetStory =>
      'A piedi nudi fino al tramonto, Lina addormentata sulle tue spalle al ritorno.';

  @override
  String get demoBeachSunsetPlace => 'Spalato, Croazia';

  @override
  String get demoGrandmaKitchenTitle => 'La cucina della nonna';

  @override
  String get demoGrandmaKitchenStory =>
      'La sua torta di albicocche, finalmente scritta – e farina dappertutto.';

  @override
  String get demoGrandmaKitchenPlace => 'Graz';

  @override
  String get demoGraduationTitle => 'Il giorno della laurea';

  @override
  String get demoGraduationStory =>
      'Papà ha pianto prima ancora che i cappelli ricadessero.';

  @override
  String get demoGraduationPlace => 'Innsbruck';

  @override
  String get demoFirstHomeTitle => 'Le chiavi della nostra prima casa';

  @override
  String get demoFirstHomeStory =>
      'Ancora niente mobili, solo scatoloni, pizza sul pavimento e tanti progetti.';

  @override
  String get demoFirstHomePlace => 'Linz';

  @override
  String get demoAlpineSummitTitle => 'Sopra le nuvole';

  @override
  String get demoAlpineSummitStory =>
      'In piedi alle 4 per questo. Ne è valsa ogni passo.';

  @override
  String get demoAlpineSummitPlace => 'Grossglockner';

  @override
  String get demoFirstBikeTitle => 'Primo giro, senza mani';

  @override
  String get demoFirstBikeStory =>
      'Tre pedalate, un\'oscillazione, e via – orgogliosissimo.';

  @override
  String get demoFirstBikePlace => 'Prater, Vienna';

  @override
  String get demoGardenDinnerTitle => 'Gli 80 anni del nonno';

  @override
  String get demoGardenDinnerStory =>
      'Quattro generazioni a una lunga tavolata, e le storie più belle le raccontava ancora lui.';

  @override
  String get demoGardenDinnerPlace => 'Wachau';

  @override
  String get demoThreadFirstDanceToFirstHome => 'La nostra storia';

  @override
  String get demoThreadFirstHomeToNewborn => 'Poi è arrivata Lina';

  @override
  String get demoThreadNewbornToBeachSunset => 'La sua prima estate';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'Famiglia';

  @override
  String get demoThreadGraduationToFirstHome => 'Nuovo capitolo';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'Piccole avventure';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'Il nonno guardava';

  @override
  String get demoRelationGrandpa => 'Nonno';

  @override
  String get demoRelationGrandma => 'Nonna';

  @override
  String get demoRelationDaughter => 'Figlia';

  @override
  String get demoRelationWife => 'Moglie';

  @override
  String get demoRelationBestMan => 'Testimone';

  @override
  String get demoRelationMother => 'Madre';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Salvato in $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricordi non sono ancora in un backup.',
      one: '1 ricordo non è ancora in un backup.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Più tardi';

  @override
  String get backUp => 'Fai il backup';

  @override
  String get onThisDayTitle => 'Accadde oggi';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years anni fa, oggi',
      one: '1 anno fa, oggi',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years anni fa',
      one: '1 anno fa',
    );
    return 'Accadde oggi · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'Nei giorni in cui torna un ricordo di un anno passato, LifeThreads ti manda un promemoria discreto.';

  @override
  String get onThisDayReminderSwitch => 'Promemoria giornaliero';

  @override
  String onThisDayReminderAt(String time) {
    return 'Alle $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'Le notifiche di LifeThreads sono disattivate. Consentile nelle impostazioni del telefono.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years anni fa, oggi: $title',
      one: '1 anno fa, oggi: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'altri $count ricordi',
      one: '1 altro ricordo',
    );
    return '$title e $_temp0 di questo giorno';
  }

  @override
  String get onThisDayChannelDescription =>
      'Un ricordo di questo giorno in un anno passato.';

  @override
  String get benefitOnThisDayBody =>
      'Un promemoria quando torna un ricordo di un anno passato, aperto come un capitolo a sé.';

  @override
  String get premiumFeatureStoryImage => 'Immagini storia';

  @override
  String get premiumFeatureStoryVideo => 'Video storia';

  @override
  String get premiumFeatureThreadOfTheYear => 'Filo dell\'anno';

  @override
  String get premiumFeatureFamilyWall => 'Bacheca di famiglia';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature fa parte di Premium.';
  }

  @override
  String get yearThreadTitle => 'Filo dell\'anno';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricordi',
      one: '1 ricordo',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count luoghi',
      one: '1 luogo',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count persone',
      one: '1 persona',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mesi',
      one: '1 mese',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'Emozione principale: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'Un anno, intrecciato.';

  @override
  String get yearThreadMyYear => 'Il mio anno';

  @override
  String get yearThreadWallCardTitle => 'Il tuo anno in ricordi';

  @override
  String yearThreadWallCardBody(String year) {
    return 'Trasforma il $year in un breve film.';
  }

  @override
  String get yearThreadDismiss => 'Non ora';

  @override
  String get yearThreadSettingsBody =>
      'Trasforma ogni anno con almeno 3 ricordi in un breve film, in ordine e unito dal filo.';

  @override
  String get yearThreadOpen => 'Crea il film';

  @override
  String get yearThreadNoYears =>
      'Il Filo dell\'anno ha bisogno di un anno con almeno 3 ricordi. Continua a salvare momenti e torna qui.';

  @override
  String get yearThreadYear => 'Anno';

  @override
  String get yearThreadLength => 'Durata';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'Film · $seconds s';
  }

  @override
  String get yearThreadLengthStory => 'Storia · 20 s';

  @override
  String get yearThreadMusic => 'Musica';

  @override
  String get yearThreadNoMusic => 'Nessuna musica';

  @override
  String get yearThreadInFilm => 'Nel film';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count di $max';
  }

  @override
  String get yearThreadAddMemory => 'Aggiungi un ricordo';

  @override
  String get yearThreadSwap => 'Scambia';

  @override
  String get yearThreadRemove => 'Rimuovi';

  @override
  String get yearThreadUseSuggestions => 'Usa i suggerimenti';

  @override
  String yearThreadPickTitle(String year) {
    return 'Scegli un ricordo del $year';
  }

  @override
  String get yearThreadNoOthers =>
      'Tutti i ricordi di quest\'anno sono già nel film.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricordi',
      one: '1 ricordo',
    );
    return 'Scegli almeno $_temp0.';
  }

  @override
  String get yearThreadPreview => 'Anteprima';

  @override
  String get yearThreadExportVideo => 'Esporta video';

  @override
  String get yearThreadExportImage => 'Esporta immagine';

  @override
  String get yearThreadShare => 'Condividi';

  @override
  String get yearThreadSave => 'Salva in Foto';

  @override
  String get yearThreadMakingFilm => 'Creazione del film…';

  @override
  String get yearThreadMakingImage => 'Creazione dell\'immagine…';

  @override
  String get yearThreadFilmReady => 'Il tuo film è pronto';

  @override
  String get yearThreadImageReady => 'La tua immagine è pronta';

  @override
  String get yearThreadSaved => 'Salvato nelle tue foto.';

  @override
  String get yearThreadExportFailed => 'Non ha funzionato. Riprova.';

  @override
  String get yearThreadPlay => 'Riproduci';

  @override
  String get yearThreadPause => 'Pausa';

  @override
  String get createStory => 'Crea storia';

  @override
  String get storyPickTitle => 'Scegli i ricordi';

  @override
  String storyPickBody(int max) {
    return 'Scegli fino a $max ricordi per una storia.';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$count di $max scelti';
  }

  @override
  String storyPickLimit(int max) {
    return 'Una storia contiene fino a $max ricordi.';
  }

  @override
  String get storyPickContinue => 'Continua';

  @override
  String get storyNoMemories =>
      'Salva prima un ricordo, poi trasformalo in una storia.';

  @override
  String get storyEditorTitle => 'La tua storia';

  @override
  String get storyChangeMemories => 'Cambia ricordi';

  @override
  String get storyTemplateSingle => 'Un ricordo';

  @override
  String get storyTemplateThread => 'Bacheca con filo';

  @override
  String get storyTemplateCollage => 'Collage';

  @override
  String get storyTemplateQuote => 'Parole';

  @override
  String get storySwipeHint => 'Scorri per un altro stile';

  @override
  String get storyCaptionLabel => 'Didascalia';

  @override
  String get storyCaptionHint => 'Una riga della tua storia';

  @override
  String get storyVideoSwitch => 'Video';

  @override
  String get storyVideoBody =>
      'Un breve film per Storie e Reel, con movimento e musica.';

  @override
  String get storyMusicTitle => 'Musica';

  @override
  String get storyMusicNone => 'Nessuna musica';

  @override
  String get storyMusicNoneHint =>
      'Puoi anche aggiungere musica su Instagram quando pubblichi.';

  @override
  String get storyMoodWarm => 'Affettuosa';

  @override
  String get storyMoodJoyful => 'Allegra';

  @override
  String get storyMoodCalm => 'Serena';

  @override
  String get storyMoodNostalgic => 'Nostalgica';

  @override
  String get storyMoodEpic => 'Epica';

  @override
  String get storyMoodEmotional => 'Emozionante';

  @override
  String get storyMusicTrimHint =>
      'Trascina il riquadro dorato per scegliere la parte della canzone';

  @override
  String get storySearchHint => 'Cerca ricordi, luoghi, anni';

  @override
  String storySearchEmpty(String query) {
    return 'Nessun ricordo corrisponde a “$query”.';
  }

  @override
  String get storyMemoriesInStory => 'Nella tua storia';

  @override
  String get storyMemoriesReorderHint =>
      'Tieni premuto e trascina per cambiare l\'ordine';

  @override
  String get storyAddMemory => 'Aggiungi';

  @override
  String get storyAddMemoryTitle => 'Aggiungi un ricordo';

  @override
  String storyRemoveMemory(String title) {
    return 'Rimuovi $title dalla storia';
  }

  @override
  String get storyAllMemoriesAdded =>
      'Tutti i ricordi sono già in questa storia.';

  @override
  String get storyShare => 'Condividi';

  @override
  String get storySaveToPhotos => 'Salva in Foto';

  @override
  String get storySaved => 'Salvato nelle tue foto.';

  @override
  String get storySaveDenied =>
      'LifeThreads non può aggiungere alle tue foto. Consentilo nelle impostazioni del telefono.';

  @override
  String storyExportFailed(String error) {
    return 'Impossibile creare la storia: $error';
  }

  @override
  String get storyRenderingTitle => 'Creazione del film';

  @override
  String get storyRenderingBody =>
      'Tieni LifeThreads aperto, ci vuole qualche secondo.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent %';
  }

  @override
  String get storyPreviewFree =>
      'L\'anteprima è gratis. Condividere e salvare le storie fa parte di Premium.';

  @override
  String get benefitStoriesTitle => 'Crea storia';

  @override
  String get benefitStoriesBody =>
      'Trasforma i ricordi in immagini e brevi film con musica per Instagram, WhatsApp e altro.';

  @override
  String get musicCreditsTitle => 'Crediti musicali';

  @override
  String get musicCreditsBody =>
      'Brani inclusi per i video delle storie, con le loro licenze.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'Il tuo anno in un breve film: i momenti che contano, in ordine, con la musica.';

  @override
  String get benefitFamilyTitle => 'Bacheche di famiglia';

  @override
  String get benefitFamilyBody =>
      'Una bacheca condivisa per la tua famiglia, crittografata end-to-end. Ognuno aggiunge i suoi momenti.';

  @override
  String get myWall => 'La mia bacheca';

  @override
  String get myWallSubtitle => 'Privata, su questo dispositivo';

  @override
  String get switchWall => 'Cambia bacheca';

  @override
  String get familyWallsTitle => 'Bacheche di famiglia';

  @override
  String get familyWallsSettingsBody =>
      'Condividi una bacheca con famiglia o amici: tutti aggiungono ricordi, crittografati end-to-end. La mia bacheca resta privata su questo dispositivo.';

  @override
  String get familyWallsOpen => 'Apri bacheche di famiglia';

  @override
  String get familyWallsManage => 'Gestisci bacheche di famiglia';

  @override
  String get familyWallsHeadline => 'Una bacheca, tutta la famiglia';

  @override
  String get familyWallsIntro =>
      'Una bacheca di famiglia è condivisa con le persone che inviti. Ricordi e foto vengono crittografati sul telefono prima del caricamento; solo i membri possono aprirli. La mia bacheca non è condivisa e resta su questo dispositivo.';

  @override
  String get familyUnavailableTitle => 'Non ancora disponibile';

  @override
  String get familyUnavailable =>
      'Le bacheche di famiglia non sono ancora disponibili in questa versione di LifeThreads.';

  @override
  String get familySignInNeededTitle =>
      'Accedi per usare le bacheche di famiglia';

  @override
  String get familySignInNeededBody =>
      'Una bacheca condivisa ha bisogno di un account, così la famiglia sa chi ha aggiunto cosa. La mia bacheca funziona senza.';

  @override
  String get familySignIn => 'Accedi';

  @override
  String get familyLoadFailed => 'Impossibile caricare';

  @override
  String get familyRetry => 'Riprova';

  @override
  String get familyNoWallsYet =>
      'Ancora nessuna bacheca di famiglia. Creane una o unisciti con un link di invito.';

  @override
  String get familyStartTitle => 'Crea o unisciti';

  @override
  String get familyStartBody =>
      'Per creare una bacheca di famiglia serve Premium. Unirsi è gratis: il Premium del creatore copre la famiglia.';

  @override
  String get familyCreateAction => 'Crea bacheca di famiglia';

  @override
  String get familyCreateTitle => 'Nuova bacheca di famiglia';

  @override
  String get familyNameLabel => 'Nome della bacheca';

  @override
  String get familyNameHint => 'es. Famiglia Rossi';

  @override
  String get familyMyNameLabel => 'Il tuo nome su questa bacheca';

  @override
  String get familyMyNameHelper =>
      'I membri lo vedono sui tuoi ricordi. È crittografato come tutto sulla bacheca.';

  @override
  String get familyMyNameSaved => 'Nome salvato.';

  @override
  String get familySetMyName => 'Il mio nome';

  @override
  String get familyCheckingSubscription => 'Verifica del tuo Premium…';

  @override
  String get familyCreating => 'Creazione della bacheca…';

  @override
  String get familyJoinWithLink => 'Unisciti con un link';

  @override
  String get familyInviteLinkLabel => 'Link di invito';

  @override
  String get familyJoinTitle => 'Unirti a questa bacheca di famiglia?';

  @override
  String get familyJoinBody =>
      'I membri vedranno il tuo nome e i ricordi che aggiungi, e tu vedrai i loro. Puoi uscire quando vuoi.';

  @override
  String get familyJoinAction => 'Unisciti';

  @override
  String get familyJoining => 'Accesso alla bacheca…';

  @override
  String familyJoined(String family) {
    return 'Ti sei unito a $family.';
  }

  @override
  String get familyRoleOwner => 'Creatore';

  @override
  String get familyRoleMember => 'Membro';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membri',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'Impostazioni bacheca';

  @override
  String familyStorageUsed(String used, String total) {
    return '$used di $total usati';
  }

  @override
  String get familyRename => 'Rinomina';

  @override
  String get familyInviteTitle => 'Invita';

  @override
  String get familyInviteBody =>
      'Invia un link a qualcuno di cui ti fidi. Ogni link funziona una volta e scade dopo 7 giorni.';

  @override
  String get familyInviteAction => 'Crea link di invito';

  @override
  String get familyCreatingInvite => 'Creazione dell\'invito…';

  @override
  String get familyInviteReady => 'Link di invito pronto';

  @override
  String get familyInviteValidity =>
      'Funziona una volta e scade al massimo dopo 7 giorni.';

  @override
  String get familyInviteKeyWarning =>
      'Il link contiene la chiave della bacheca: chi lo apre può unirsi e leggerla. Invialo solo alla persona che inviti.';

  @override
  String get familyInviteShare => 'Condividi link';

  @override
  String get familyInviteCopy => 'Copia link';

  @override
  String get familyInviteCopied => 'Link copiato.';

  @override
  String get familyInviteShareFailed =>
      'La condivisione non è disponibile. Copia il link.';

  @override
  String familyInviteSubject(String family) {
    return 'Unisciti a $family su LifeThreads';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'Unisciti alla nostra bacheca di famiglia “$family” su LifeThreads: $link';
  }

  @override
  String get familyMembersTitle => 'Membri';

  @override
  String get familyMemberActions => 'Azioni sul membro';

  @override
  String get familyYou => 'Tu';

  @override
  String familyYouNamed(String name) {
    return '$name (tu)';
  }

  @override
  String get familyAMember => 'Un membro';

  @override
  String get familyFormerMember => 'Ex membro';

  @override
  String get familyBlocked => 'Bloccato';

  @override
  String get familyBlock => 'Blocca';

  @override
  String get familyUnblock => 'Sblocca';

  @override
  String familyBlockAuthor(String name) {
    return 'Blocca $name';
  }

  @override
  String familyBlockQuestion(String name) {
    return 'Bloccare $name?';
  }

  @override
  String get familyBlockBody =>
      'Non vedrai più i suoi ricordi su nessuna bacheca di famiglia. Non riceverà avvisi. Puoi sbloccarlo nell\'elenco dei membri.';

  @override
  String get familyReport => 'Segnala';

  @override
  String get familyRemoveMember => 'Rimuovi dalla bacheca';

  @override
  String familyRemoveQuestion(String name) {
    return 'Rimuovere $name?';
  }

  @override
  String get familyRemoveBody =>
      'Perderà l\'accesso a questa bacheca. Invitalo di nuovo per farlo tornare.';

  @override
  String get familyRemoveDeleteContent =>
      'Elimina anche i ricordi che ha aggiunto';

  @override
  String get familyDeleteTitle => 'Elimina bacheca di famiglia';

  @override
  String get familyDeleteBody =>
      'Come creatore non puoi uscire dalla bacheca; puoi eliminarla per tutti.';

  @override
  String get familyDeleteAction => 'Elimina bacheca';

  @override
  String familyDeleteQuestion(String family) {
    return 'Eliminare $family?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'Tutti i ricordi e le foto di questa bacheca vengono eliminati dai nostri server per tutti i membri. L\'operazione è irreversibile. I ricordi in La mia bacheca non vengono toccati.';

  @override
  String get familyDeleting => 'Eliminazione…';

  @override
  String get familyLeaveTitle => 'Esci dalla bacheca di famiglia';

  @override
  String get familyLeaveBody =>
      'Non vedrai più questa bacheca. Puoi tenere o eliminare i ricordi che hai aggiunto.';

  @override
  String get familyLeaveAction => 'Esci';

  @override
  String familyLeaveQuestion(String family) {
    return 'Uscire da $family?';
  }

  @override
  String get familyLeaveConfirmBody =>
      'Per tornare ti servirà un nuovo invito.';

  @override
  String get familyLeaveDeleteMine => 'Elimina anche i ricordi che ho aggiunto';

  @override
  String get familyLeaving => 'Uscita…';

  @override
  String get familySignInTitle => 'Accedi';

  @override
  String get familySignInHeadline => 'Un account per le bacheche di famiglia';

  @override
  String get familySignInWhy =>
      'Una bacheca di famiglia è condivisa, quindi serve un account: i membri vedono chi ha aggiunto ogni ricordo, e solo i membri possono aprirla.';

  @override
  String get familySignInMyWallStays =>
      'La mia bacheca non ha bisogno di un account. Resta privata su questo dispositivo e non viene mai caricata.';

  @override
  String get familySignInEncrypted =>
      'I ricordi e le foto di famiglia sono crittografati end-to-end. GK Coding li conserva ma non può leggerli.';

  @override
  String get familySignInWhatWeGet =>
      'Da Apple o Google usiamo solo un ID account, non i tuoi contatti o le tue foto.';

  @override
  String get familySignInApple => 'Accedi con Apple';

  @override
  String get familySignInGoogle => 'Accedi con Google';

  @override
  String get familySignInFinePrint =>
      'Accedendo accetti le Condizioni d\'uso e l\'Informativa sulla privacy. Puoi eliminare il tuo account nell\'app in qualsiasi momento.';

  @override
  String get familyAccountTitle => 'Account';

  @override
  String get familySignedOutTitle => 'Accesso non effettuato';

  @override
  String get familySignedOutBody =>
      'Accedi per vedere le tue bacheche di famiglia. La mia bacheca funziona senza account.';

  @override
  String get familySignedInTitle => 'Accesso effettuato';

  @override
  String get familySignedInBody =>
      'Il tuo account si usa solo per le bacheche di famiglia.';

  @override
  String familyAccountId(String id) {
    return 'ID account: $id';
  }

  @override
  String get familySignOut => 'Esci dall\'account';

  @override
  String get familySignOutQuestion => 'Uscire dall\'account?';

  @override
  String get familySignOutBody =>
      'Le bacheche di famiglia e le loro chiavi vengono rimosse da questo dispositivo finché non accedi di nuovo. Sul server non si elimina nulla. La mia bacheca non viene toccata.';

  @override
  String get familySigningOut => 'Uscita dall\'account…';

  @override
  String get familyDeleteAccountTitle => 'Elimina account';

  @override
  String get familyDeleteAccountBody =>
      'Elimina il tuo account e i dati delle tue bacheche di famiglia dai nostri server. La mia bacheca resta su questo dispositivo.';

  @override
  String get familyDeleteAccount => 'Elimina account';

  @override
  String get familyDeleteAccountQuestion => 'Eliminare il tuo account?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Le $count bacheche di famiglia che hai creato vengono eliminate per tutti i membri, con ogni ricordo e foto.',
      one:
          'La bacheca di famiglia che hai creato viene eliminata per tutti i membri, con ogni ricordo e foto.',
      zero: 'Non hai creato bacheche di famiglia.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'I ricordi e le foto che hai aggiunto alle bacheche di altre famiglie vengono eliminati, e esci da quelle bacheche.';

  @override
  String get familyDeleteAccountKeys =>
      'Le chiavi delle bacheche di famiglia e le foto in cache vengono rimosse da questo dispositivo. L\'operazione è irreversibile.';

  @override
  String get familyDeleteAccountMyWall =>
      'La mia bacheca non viene toccata: i suoi ricordi restano su questo dispositivo.';

  @override
  String get familyDeleteAccountSubscription =>
      'Questo non annulla un abbonamento Premium; gestiscilo nell\'App Store o in Google Play.';

  @override
  String get familyDeleteAccountUnderstood =>
      'Ho capito che il mio account verrà eliminato per sempre.';

  @override
  String get familyDeletingAccount => 'Eliminazione dell\'account…';

  @override
  String get familyAccountDeleted => 'Il tuo account è stato eliminato.';

  @override
  String get familyTermsTitle => 'Regole della bacheca di famiglia';

  @override
  String get familyTermsHeadline => 'Prima di condividere';

  @override
  String get familyTermsIntro =>
      'Le bacheche di famiglia sono per le persone che inviti. Per mantenerle sicure, tutti accettano queste regole:';

  @override
  String get familyTermsZeroTolerance =>
      'Tolleranza zero per i contenuti inappropriati: niente molestie, odio, contenuti sessuali, violenza, autolesionismo, contenuti illegali o informazioni private di altri senza il loro consenso.';

  @override
  String get familyTermsOwnContent =>
      'Condividi solo foto e storie che hai il diritto di condividere.';

  @override
  String get familyTermsReport =>
      'Segnala qualsiasi ricordo o membro dalla bacheca. GK Coding esamina le segnalazioni entro 24 ore.';

  @override
  String get familyTermsBlock =>
      'Blocca un membro per non vedere più i suoi ricordi.';

  @override
  String get familyTermsOwner =>
      'Il creatore di una bacheca può rimuovere membri e i loro ricordi.';

  @override
  String get familyTermsConsequences =>
      'I contenuti che violano queste regole vengono rimossi, e gli account che li hanno pubblicati possono essere sospesi o eliminati.';

  @override
  String get familyTermsReadFull => 'Leggi le condizioni complete';

  @override
  String get familyTermsAgree =>
      'Accetto le Condizioni d\'uso e queste regole.';

  @override
  String get familyTermsAccept => 'Accetta e continua';

  @override
  String familyTermsVersion(String version) {
    return 'Versione delle condizioni $version';
  }

  @override
  String get familyWallEmptyTitle => 'La bacheca ti aspetta';

  @override
  String get familyWallEmptyBody =>
      'Aggiungi il primo ricordo. Tutti su questa bacheca lo vedranno.';

  @override
  String get familyWallGoneBody =>
      'Questa bacheca di famiglia non è più disponibile per te. Forse è stata eliminata, o sei stato rimosso.';

  @override
  String get familyAddMemory => 'Aggiungi ricordo';

  @override
  String get familyRefresh => 'Aggiorna';

  @override
  String get familySyncing => 'Sincronizzazione…';

  @override
  String get familyOffline => 'Offline: ricordi salvati';

  @override
  String get familySyncFailed => 'Sincronizzazione non riuscita';

  @override
  String get familyMemoryTitle => 'Ricordo';

  @override
  String get familyMemoryGone => 'Questo ricordo non è più sulla bacheca.';

  @override
  String get familyMemoryActions => 'Azioni sul ricordo';

  @override
  String familyAddedBy(String name) {
    return 'Aggiunto da $name';
  }

  @override
  String get familyDeleteMemoryQuestion => 'Eliminare questo ricordo?';

  @override
  String get familyDeleteMemoryBody =>
      'Viene rimosso dalla bacheca per tutti, con le sue foto.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'Come creatore puoi rimuovere ricordi da questa bacheca. Questo ricordo di $name viene rimosso per tutti, con le sue foto.';
  }

  @override
  String get familyDeletingMemory => 'Eliminazione del ricordo…';

  @override
  String get familyNoPhotosYet => 'Ancora nessuna foto';

  @override
  String get familyPostNote =>
      'Tutti su questa bacheca vedranno questo ricordo. Le foto vengono ridimensionate e crittografate sul telefono prima del caricamento.';

  @override
  String get familyPost => 'Pubblica';

  @override
  String get familyPostMemory => 'Pubblica sulla bacheca';

  @override
  String get familyUploading => 'Crittografia e caricamento…';

  @override
  String get familyMemorySaved => 'Salvato sulla bacheca di famiglia.';

  @override
  String get familyConflictTitle => 'Modificato da qualcun altro';

  @override
  String get familyConflictBody =>
      'Questo ricordo è cambiato su un altro dispositivo mentre lo modificavi. Caricare l\'ultima versione e salvarci sopra le tue modifiche?';

  @override
  String get familyConflictRetry => 'Aggiorna e salva';

  @override
  String get familyQuotaTitle => 'La bacheca è piena';

  @override
  String get familyReportMemoryTitle => 'Segnala ricordo';

  @override
  String get familyReportPhotoTitle => 'Segnala foto';

  @override
  String get familyReportMemberTitle => 'Segnala membro';

  @override
  String get familyReportIntro =>
      'Dicci cosa non va. La segnalazione arriva a GK Coding, non alla persona segnalata.';

  @override
  String get familyReportSpam => 'Spam o truffa';

  @override
  String get familyReportHarassment => 'Molestie o bullismo';

  @override
  String get familyReportHate => 'Incitamento all\'odio';

  @override
  String get familyReportSexual => 'Contenuti sessuali o nudità';

  @override
  String get familyReportViolence => 'Violenza o minacce';

  @override
  String get familyReportSelfHarm => 'Autolesionismo o suicidio';

  @override
  String get familyReportIllegal => 'Contenuti illegali';

  @override
  String get familyReportPrivacy =>
      'Informazioni private condivise senza consenso';

  @override
  String get familyReportOther => 'Altro';

  @override
  String get familyReportDetailsLabel => 'Dettagli (facoltativo)';

  @override
  String get familyReportDetailsHint => 'Cosa dovremmo sapere?';

  @override
  String familyReportAlsoBlock(String name) {
    return 'Blocca anche $name';
  }

  @override
  String get familyReportSend => 'Invia segnalazione';

  @override
  String get familyReportReviewNote =>
      'GK Coding esamina ogni segnalazione entro 24 ore e rimuove contenuti e membri che violano le regole.';

  @override
  String get familyReportSentTitle => 'Grazie';

  @override
  String get familyReportSentBody =>
      'La tua segnalazione è stata inviata. GK Coding la esamina entro 24 ore e interviene sui contenuti che violano le regole.';

  @override
  String get familyErrorGeneric => 'Qualcosa è andato storto. Riprova.';

  @override
  String get familyErrorOffline =>
      'Sembri offline. Controlla la connessione e riprova.';

  @override
  String get familyErrorSubscriptionRequired =>
      'Serve un abbonamento Premium attivo del creatore della bacheca.';

  @override
  String get familyErrorInviteExpired =>
      'Questo invito è scaduto. Chiedi un nuovo link.';

  @override
  String get familyErrorInviteUsed =>
      'Questo invito è già stato usato. Ogni link funziona una volta; chiedine uno nuovo.';

  @override
  String get familyErrorInviteInvalid =>
      'Questo non è un link di invito LifeThreads valido.';

  @override
  String get familyErrorAlreadyMember =>
      'Sei già membro di questa bacheca di famiglia.';

  @override
  String get familyErrorFamilyFull =>
      'Questa bacheca di famiglia ha raggiunto il limite di membri.';

  @override
  String get familyErrorQuotaExceeded =>
      'Questa bacheca di famiglia non ha più spazio. Elimina qualche ricordo o foto per fare posto.';

  @override
  String get familyErrorVersionConflict =>
      'Qualcuno ha modificato questo ricordo prima di te. Aggiorna e riprova.';

  @override
  String get familyErrorTermsRequired =>
      'Accetta prima le regole della bacheca di famiglia.';

  @override
  String get familyErrorSignedOut =>
      'Sei uscito dall\'account. Accedi di nuovo.';

  @override
  String get familyErrorNotAllowed => 'Non puoi farlo su questa bacheca.';

  @override
  String get familyErrorNotFound => 'Bacheca di famiglia non trovata';

  @override
  String get familyErrorOwnerCannotLeave =>
      'Il creatore non può uscire dalla bacheca, ma può eliminarla.';

  @override
  String get familyPaste => 'Incolla';

  @override
  String get familyErrorInviteRevoked =>
      'Questo invito è stato ritirato. Chiedi un nuovo link.';

  @override
  String get familyErrorKeyMissing =>
      'Questo dispositivo non ha la chiave di questa bacheca di famiglia (per esempio dopo una reinstallazione o su un nuovo telefono). Chiedi a un membro un nuovo link di invito: aprendolo recuperi l\'accesso.';

  @override
  String get familyErrorSignInUnavailable =>
      'L\'accesso non è disponibile su questo dispositivo al momento.';

  @override
  String get familyErrorNoPurchase =>
      'Nessun acquisto Premium trovato per questo account App Store o Google Play. Prendi prima Premium, poi riprova.';

  @override
  String get familyErrorVerificationUnavailable =>
      'Al momento non è possibile verificare il tuo Premium. Riprova più tardi.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'Questo acquisto Premium è già collegato a un altro account di bacheca di famiglia. Accedi con quell\'account o scrivi a info@gkcoding.dev.';

  @override
  String get familyErrorNameTooLong =>
      'Il nome è troppo lungo. Usane uno più corto.';

  @override
  String get familyErrorContentNotAllowed =>
      'Il testo contiene parole non consentite sulle bacheche di famiglia. Modificalo e riprova.';

  @override
  String get familyErrorPhotoUnreadable =>
      'Una delle foto non può essere letta. Rimuovila e riprova.';

  @override
  String get familyErrorTooLarge =>
      'È troppo grande da caricare. Prova con meno foto o foto più piccole.';

  @override
  String get familyReportEvidenceNote =>
      'Per esaminarla, GK Coding riceve il titolo e la storia di questo ricordo con la tua segnalazione. Le foto non vengono mai inviate.';

  @override
  String get moveLeft => 'Sposta a sinistra';

  @override
  String get moveUp => 'Sposta su';

  @override
  String get moveDown => 'Sposta giù';

  @override
  String get moveRight => 'Sposta a destra';

  @override
  String get showPassword => 'Mostra password';

  @override
  String get hidePassword => 'Nascondi password';

  @override
  String get removePerson => 'Rimuovi persona';

  @override
  String get draftKept =>
      'Tenuto come bozza – lo ritroverai qui la prossima volta.';

  @override
  String get draftResumeTitle => 'Riprendere da dove avevi lasciato?';

  @override
  String draftResumeBody(String date) {
    return 'Hai iniziato un ricordo il $date e non l\'hai ancora salvato.';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foto',
      one: '1 foto',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => 'Continua la bozza';

  @override
  String get draftStartNew => 'Ricomincia';

  @override
  String get lookBackMenu => 'Rivivi un mese';

  @override
  String lookBackTitle(String month) {
    return 'Il tuo $month';
  }

  @override
  String get lookBackWallCardTitle => 'Il tuo mese in ricordi';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricordi',
      one: '1 ricordo',
    );
    return '$month: $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricordi',
      one: '1 ricordo',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count persone',
      one: '1 persona',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count luoghi',
      one: '1 luogo',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => 'Chi c\'era';

  @override
  String get lookBackPlacesHeading => 'Dove sei stato';

  @override
  String lookBackEmpty(String month) {
    return 'Ancora niente salvato di $month.';
  }

  @override
  String get lookBackEmptyHint =>
      'Qui compaiono i ricordi datati in questo mese.';

  @override
  String get lookBackPreviousMonth => 'Mese precedente';

  @override
  String get lookBackNextMonth => 'Mese successivo';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricordi',
      one: '1 ricordo',
    );
    return '$month: $_temp0 da rivivere.';
  }

  @override
  String get lookBackNotificationPrivate => 'Il tuo mese in ricordi è pronto.';

  @override
  String get homeWidgetLocked => 'Apri LifeThreads per vedere i tuoi ricordi.';

  @override
  String get homeWidgetSettingsTitle => 'Widget della schermata Home';

  @override
  String get homeWidgetSettingsSubtitle => 'Quali ricordi mostra';

  @override
  String get homeWidgetPreviewTitle => 'Oggi sul tuo widget';

  @override
  String get homeWidgetSourceTitle => 'Quali ricordi';

  @override
  String get homeWidgetAllWalls => 'Tutte le mie bacheche';

  @override
  String get homeWidgetOrderTitle => 'Mostrati per primi';

  @override
  String get homeWidgetOnThisDayFirst => 'Prima Accadde oggi';

  @override
  String get homeWidgetOnThisDayFirstBody =>
      'Prima un ricordo di questo giorno in un anno passato.';

  @override
  String get homeWidgetPhotosFirst => 'Prima i ricordi con foto';

  @override
  String get homeWidgetPhotosFirstBody =>
      'Gli altri solo se nessuno ha una foto.';

  @override
  String get homeWidgetHowToTitle => 'Aggiungilo alla schermata Home';

  @override
  String get homeWidgetHowToIos =>
      'Tieni premuta l\'icona di LifeThreads nella schermata Home e scegli una dimensione del widget. Oppure tieni premuto uno spazio vuoto, tocca Modifica › Aggiungi widget e scegli LifeThreads.';

  @override
  String get homeWidgetHowToAndroid =>
      'Tieni premuto uno spazio vuoto nella schermata Home, tocca Widget e trascina LifeThreads dove vuoi.';

  @override
  String get homeWidgetPrivacyNote =>
      'I ricordi nascosti non compaiono mai nel widget. Con il blocco app attivo, non mostra nessun ricordo.';

  @override
  String get yearThreadAlmostThere => 'Ci sei quasi';

  @override
  String get yearThreadMemoriesFrom => 'Ricordi del';

  @override
  String yearThreadAddMemoryTo(String year) {
    return 'Aggiungi un ricordo al $year';
  }

  @override
  String get onboardingHangTitle => 'Appendi i tuoi ricordi';

  @override
  String get onboardingHangText =>
      'Una foto, un luogo, le persone che c\'erano – la tua bacheca cresce con la tua vita.';

  @override
  String get onboardingConnectTitle => 'Collegali con dei fili';

  @override
  String get onboardingConnectText =>
      'Di\' perché due momenti stanno insieme. I fili mostrano come si compone la tua storia.';

  @override
  String get onboardingComeBackTitle => 'I ricordi tornano da te';

  @override
  String get onboardingComeBackText =>
      'Accadde oggi, il tuo mese rivissuto, il tuo anno come film – e un widget sulla schermata Home.';

  @override
  String get onboardingPrivateText =>
      'Nessun account. Tutto resta sul tuo telefono – con Face ID, se vuoi.';

  @override
  String get onboardingNameStaysHere =>
      'Solo per salutarti – resta su questo telefono.';

  @override
  String get tutorialLookBackTitle => 'Cerca e rivivi';

  @override
  String get tutorialLookBackText =>
      'Cerca per titolo, luogo, persona o anno. Altro › Rivivi un mese mostra i ricordi di un mese; Altro › Filo dell\'anno trasforma un anno in un film.';

  @override
  String get tutorialStoryTitle => 'Crea una storia';

  @override
  String get tutorialStoryText =>
      'Altro › Crea storia: scegli ricordi, un modello e la musica, poi condividila come immagine o video.';

  @override
  String get tutorialWallsTitle => 'Bacheche e ricordi nascosti';

  @override
  String get tutorialWallsText =>
      'Altro › Nuova bacheca tiene separati viaggi o capitoli (Premium). Tieni premuta una scheda › Nascondi la toglie dalla vista; Vista › Ricordi nascosti la mostra dopo Face ID.';

  @override
  String get tutorialFamilyTitle => 'Condividi con la famiglia';

  @override
  String get tutorialFamilyText =>
      'Altro › Bacheche di famiglia: una bacheca per tutta la famiglia, crittografata end-to-end. Invita gli altri con un link.';

  @override
  String get tutorialWidgetTitle => 'Un ricordo sulla schermata Home';

  @override
  String get tutorialWidgetText =>
      'Aggiungi il widget di LifeThreads: un ricordo diverso ogni giorno. Impostazioni › Widget della schermata Home sceglie quali.';

  @override
  String photoNumber(int number) {
    return 'Foto $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'Impossibile salvare il tuo nome su questa bacheca. Puoi impostarlo nelle impostazioni della bacheca.';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Contiene $count ricordi.',
      one: 'Contiene 1 ricordo.',
    );
    return '$_temp0 I ricordi già presenti nelle tue bacheche vengono mantenuti e non duplicati.';
  }

  @override
  String get importAction => 'Importa';

  @override
  String get familyRemovingMember =>
      'Rimozione e messa in sicurezza della bacheca…';

  @override
  String get tourSkip => 'Salta';

  @override
  String get tourNext => 'Avanti';

  @override
  String get tourDone => 'Fine';

  @override
  String get tourTapIt => 'Toccalo';

  @override
  String get tourEnd => 'Termina tour';

  @override
  String get tourShowMeHow => 'Fammi vedere';

  @override
  String get tourShowMeHowSubtitle => 'Un breve tour con ricordi di esempio';

  @override
  String get tourWelcomeTitle => 'Benvenuto nella tua bacheca';

  @override
  String get tourWelcomeBody =>
      'Scopriamo LifeThreads insieme con ricordi e foto di esempio. Segui l\'anello dorato. Alla fine decidi tu se tenerli.';

  @override
  String get tourCardTitle => 'Ogni scheda è un ricordo';

  @override
  String get tourCardBody =>
      'Foto, una storia, il luogo e l\'emozione. Trascina le schede per ordinarle, pizzica per lo zoom. Tocca questa per aprirla.';

  @override
  String get tourConnectTitle => 'Collega i ricordi';

  @override
  String get tourConnectBody =>
      'I fili legano i momenti: un viaggio a una persona, un luogo a un\'emozione. Tocca Collega.';

  @override
  String get tourConnectionsTitle => 'Scegli cosa sta insieme';

  @override
  String get tourConnectionsBody =>
      'Scegli altri ricordi e scrivi perché stanno insieme. Il filo poi si tende tra le schede sulla tua bacheca.';

  @override
  String get tourAddTitle => 'Salva un nuovo momento';

  @override
  String get tourAddBody => 'Tocca + per aggiungere qualcosa alla bacheca.';

  @override
  String get tourAddMemoryTitle => 'Un ricordo';

  @override
  String get tourAddMemoryBody =>
      'Scegli Ricordo. Puoi anche appendere una nota o un chiodo per raggruppare le schede.';

  @override
  String get tourAddTextTitle => 'Bastano poche parole';

  @override
  String get tourAddTextBody =>
      'Abbiamo aggiunto per te una foto di esempio e un titolo. Di solito scegli le tue foto o ne scatti una. Data e luogo vengono dalla foto.';

  @override
  String get tourSaveTitle => 'Appendilo alla bacheca';

  @override
  String get tourSaveBody =>
      'Tocca Salva ora. Emozioni, persone e fili possono arrivare dopo.';

  @override
  String get tourCameraTitle => 'Foto veloce';

  @override
  String get tourCameraBody =>
      'La fotocamera salva subito un momento. Le parole le aggiungi dopo.';

  @override
  String get tourViewTitle => 'Viste diverse';

  @override
  String get tourViewBody => 'Tocca Vista.';

  @override
  String get tourViewModesTitle => 'Bacheca, cronologia, mappa';

  @override
  String get tourViewModesBody =>
      'Guarda la tua vita come bacheca, cronologia o su una mappa. Qui filtri per categoria e mostri i ricordi nascosti (con Face ID).';

  @override
  String get tourViewDoneTitle => 'Torna alla bacheca';

  @override
  String get tourViewDoneBody => 'Tocca Fine.';

  @override
  String get tourSearchTitle => 'Trova qualsiasi ricordo';

  @override
  String get tourSearchBody =>
      'Scrivi qui un nome, un luogo, una persona o un anno. I risultati compaiono mentre scrivi.';

  @override
  String get tourMoreTitle => 'Tutto il resto';

  @override
  String get tourMoreBody =>
      'Storie, il tuo anno, rivivere un mese, altre bacheche e impostazioni sono in questo menu. Toccalo.';

  @override
  String get tourStoryTitle => 'Crea una storia';

  @override
  String get tourStoryBody => 'Tocca Crea storia.';

  @override
  String get tourYearTitle => 'Filo dell\'anno';

  @override
  String get tourYearBody =>
      'Il tuo anno in un breve film con musica: i ricordi in ordine, poi luoghi, persone ed emozioni dell\'anno (Premium).';

  @override
  String get tourLookBackTitle => 'Rivivi un mese';

  @override
  String get tourLookBackBody =>
      'Ogni mese in ricordi, con le sue persone e i suoi luoghi. Accadde oggi ti ricorda gli anni passati (Premium).';

  @override
  String get tourWallsTitle => 'Più bacheche';

  @override
  String get tourWallsBody =>
      'Una bacheca per ogni figlio, viaggio o progetto (Premium). Tocca il nome in alto per cambiare bacheca.';

  @override
  String get tourFamilyTitle => 'Bacheche di famiglia';

  @override
  String get tourFamilyBody =>
      'Una bacheca condivisa dove tutti aggiungono i loro momenti, crittografata end-to-end. Solo chi la crea ha bisogno di Premium; la famiglia entra gratis.';

  @override
  String get tourSettingsTitle => 'Impostazioni';

  @override
  String get tourSettingsBody =>
      'Fai il backup di tutto gratis, blocca l\'app con Face ID, configura il widget e Accadde oggi, e scegli la lingua.';

  @override
  String get tourFinishTitle => 'Ecco fatto!';

  @override
  String get tourFinishBody => 'Ora sai come muoverti. Rendi tua la bacheca.';

  @override
  String get tourDemoPhotoTitle => 'Una giornata al lago';

  @override
  String get tourRemoveDemoTitle => 'Iniziare la tua bacheca?';

  @override
  String get tourRemoveDemoBody =>
      'Il tour ha usato ricordi e foto di esempio. Rimuoverli ora e iniziare con le tue foto?';

  @override
  String get tourRemoveDemoRemove => 'Rimuovi e inizia';

  @override
  String get tourRemoveDemoKeep => 'Tienili per ora';

  @override
  String get tourRemovedToast =>
      'Ricordi di esempio rimossi. La tua bacheca è pronta.';

  @override
  String get storyTemplatePolaroid => 'Polaroid';

  @override
  String get storyTemplateAlbum => 'Album';

  @override
  String get storyTemplateFilmstrip => 'Pellicola';

  @override
  String get storyTemplateTimeline => 'Viaggio nel tempo';

  @override
  String get storyTemplatePostcard => 'Cartolina';

  @override
  String get storyTemplateCinema => 'Cinema';

  @override
  String get storyTemplateSingleHint =>
      'Ogni ricordo a schermo intero, uno dopo l\'altro';

  @override
  String get storyTemplateThreadHint => 'Schede sulla bacheca, unite dal filo';

  @override
  String get storyTemplateCollageHint => 'Tutte le foto insieme in una griglia';

  @override
  String get storyTemplateQuoteHint => 'Le tue parole si scrivono da sole';

  @override
  String get storyTemplatePolaroidHint => 'Foto istantanee cadono su una pila';

  @override
  String get storyTemplateAlbumHint => 'Le pagine girano, una foto per pagina';

  @override
  String get storyTemplateFilmstripHint => 'Una pellicola scorre e fa zoom';

  @override
  String get storyTemplateTimelineHint =>
      'Gli anni scorrono fino a ogni ricordo';

  @override
  String get storyTemplatePostcardHint =>
      'Ogni cartolina si gira sulla sua storia';

  @override
  String get storyTemplateCinemaHint => 'Cartelli, zoom lento e titoli di coda';

  @override
  String get storyAnimationTitle => 'Animazione';

  @override
  String get storyAnimationPageTitle => 'Scegli un\'animazione';

  @override
  String get storyAnimationExamples =>
      'Con foto di esempio. La tua storia usa i tuoi ricordi.';

  @override
  String get storyMusicPageTitle => 'Musica e durata';

  @override
  String get storyLengthTitle => 'Durata';

  @override
  String get storyLengthAuto => 'Auto';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds s';
  }

  @override
  String get storyMusicAll => 'Tutte';

  @override
  String get storyMusicPlay => 'Riproduci';

  @override
  String get storyMusicPause => 'Pausa';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return 'Brano $song ▸ Video $video';
  }

  @override
  String get storyMusicSyncHint =>
      'La linea bianca mostra quale secondo del brano suona con il video. I segni indicano dove inizia ogni ricordo.';

  @override
  String get storyMusicLengthHint =>
      'Auto si adatta al numero di ricordi. I film più lunghi scorrono più lentamente.';

  @override
  String get tourBack => 'Indietro';

  @override
  String get tourStoryPickTitle => 'Scegli i ricordi';

  @override
  String get tourStoryPickBody =>
      'Ne abbiamo scelti tre per te. Puoi sceglierne fino a sei. Tocca Continua.';

  @override
  String get tourStoryAnimationTitle => 'Scegli come si muove';

  @override
  String get tourStoryAnimationBody =>
      'Animazioni da Polaroid a Cinema. Tocca Animazione.';

  @override
  String get tourStoryStyleTitle => 'Prova Polaroid';

  @override
  String get tourStoryStyleBody =>
      'Ogni riquadro mostra un\'anteprima. Tocca Polaroid.';

  @override
  String get tourStoryMusicTitle => 'Aggiungi musica';

  @override
  String get tourStoryMusicBody =>
      'Scegli un brano e quanto dura il video. Tocca Musica.';

  @override
  String get tourStoryTrimTitle => 'Brano e video in sincronia';

  @override
  String get tourStoryTrimBody =>
      'Trascina il riquadro dorato per scegliere la parte del brano. La linea bianca avanza con il video, così vedi quale secondo suona e quando.';

  @override
  String get tourStoryMusicDoneTitle => 'Torna alla tua storia';

  @override
  String get tourStoryMusicDoneBody => 'Tocca Fine.';

  @override
  String get tourStoryShareTitle => 'Condividi o salva';

  @override
  String get tourStoryShareBody =>
      'Pronta per Instagram, WhatsApp e altro. Salvare e condividere fanno parte di Premium.';

  @override
  String get tourMoreAgainTitle => 'Altro nel menu';

  @override
  String get tourMoreAgainBody => 'Apri di nuovo il menu. Toccalo.';

  @override
  String get scannerStep1 =>
      'Su una TV, un computer o un tablet, apri il browser.';

  @override
  String scannerStep2(Object url) {
    return 'Vai su $url. Lì compare un codice QR.';
  }

  @override
  String get scannerStep3 =>
      'Tieni il telefono in modo che il codice sia dentro la cornice dorata. La tua bacheca comparirà lì per un po\', solo in visione.';

  @override
  String get scannerShareLink => 'Invia link';

  @override
  String get scannerCopyLink => 'Copia link';

  @override
  String get scannerLinkCopied => 'Link copiato';

  @override
  String get storyTemplateScrapbook => 'Scrapbook';

  @override
  String get storyTemplateMosaic => 'Mosaico';

  @override
  String get storyTemplateContactSheet => 'Provino';

  @override
  String get storyTemplateWallFlight => 'Volo sulla bacheca';

  @override
  String get storyTemplateCarousel => 'Carosello';

  @override
  String get storyTemplateJourney => 'Itinerario';

  @override
  String get storyTemplateScrapbookHint =>
      'Ogni foto attaccata con lo scotch su una pagina';

  @override
  String get storyTemplateMosaicHint => 'Una foto grande, le altre intorno';

  @override
  String get storyTemplateContactSheetHint =>
      'Ogni ricordo, un fotogramma della pellicola';

  @override
  String get storyTemplateWallFlightHint =>
      'Vola lungo il filo da scheda a scheda';

  @override
  String get storyTemplateCarouselHint =>
      'Le schede girano, una alla volta in primo piano';

  @override
  String get storyTemplateJourneyHint =>
      'Un percorso sulla mappa, un segnaposto per ogni luogo';

  @override
  String get storyModePicture => 'Immagine';

  @override
  String get storyModeVideo => 'Video';

  @override
  String get storyModePictureHint =>
      'Un\'immagine con tutti i tuoi ricordi, per post e storie.';

  @override
  String get storyModeVideoHint => 'Un breve film con movimento e musica.';

  @override
  String get storyLayoutTitle => 'Layout';

  @override
  String get storyLayoutPageTitle => 'Scegli un layout';

  @override
  String get storyChoosePhoto => 'Scegli la foto per la storia';

  @override
  String get wallTidyUp => 'Riordina la parete';

  @override
  String get wallTidyUpBody =>
      'Appendere tutte le schede in file ordinate, dal ricordo più vecchio al più recente? Note e chiodi restano dove sono.';

  @override
  String get wallTidyUpAction => 'Riordina';

  @override
  String get wallTidiedToast => 'La tua parete è in ordine.';

  @override
  String get storyFormatTitle => 'Formato';

  @override
  String get storyFormatStory => 'Storia 9:16';

  @override
  String get storyFormatPost => 'Post 4:5';

  @override
  String get storyFormatSquare => 'Quadrato 1:1';
}
