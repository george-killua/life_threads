// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get send => 'Envoyer';

  @override
  String get preparing => 'Préparation...';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get languageTitle => 'Langue';

  @override
  String get languageBody =>
      'Choisis la langue de l\'app. Système suit la langue de ton téléphone si LifeThreads la prend en charge.';

  @override
  String get systemLanguage => 'Système';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return 'Langue changée : $language.';
  }

  @override
  String get privacyTitle => 'Confidentialité';

  @override
  String get privacyBody =>
      'LifeThreads fonctionne en local : pas de compte, pas de profil public. Tes souvenirs restent sur cet appareil, sauf si tu exportes une sauvegarde, partages une capsule chiffrée ou affiches ton mur sur un autre écran.';

  @override
  String get viewPrivacyPolicy => 'Voir la politique de confidentialité';

  @override
  String get termsTitle => 'Conditions d\'utilisation';

  @override
  String get viewTerms => 'Voir les conditions';

  @override
  String get betaFeedbackTitle => 'Avis sur la bêta';

  @override
  String get betaFeedbackBody =>
      'Envoie ton avis sur la bêta avec des diagnostics sûrs. Les journaux contiennent seulement des événements de l\'app et des types de plantage, jamais le texte des souvenirs, les chemins des photos, les sauvegardes ou les lieux exacts.';

  @override
  String get closedBetaBadge => 'Bêta fermée';

  @override
  String get sendFeedback => 'Envoyer un avis';

  @override
  String get backupArchiveBody =>
      'Sauvegarde tout – souvenirs, photos, notes, fils et disposition – dans un seul fichier. Garde-le sur ton ordinateur ou dans ton propre cloud, et ajoute un mot de passe pour le chiffrer.';

  @override
  String get backupArchiveTitle => 'Sauvegarde';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Débloquer';

  @override
  String get exportArchive => 'Exporter l\'archive';

  @override
  String get importArchive => 'Importer une archive';

  @override
  String get importCapsule => 'Importer une capsule';

  @override
  String get moveDevices => 'Changer d\'appareil';

  @override
  String get themeTitle => 'Thème';

  @override
  String get themeBody =>
      'Choisis l\'ambiance de ton mur privé. La version gratuite inclut Salon chaleureux. Premium débloque toutes les ambiances.';

  @override
  String get oneFreeBadge => '1 gratuit';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'L\'abonnement Premium est actif.';

  @override
  String get premiumLockedBody =>
      'À l\'année ou au mois : souvenirs illimités, plusieurs murs, stories, thèmes et dispositions.';

  @override
  String get activeBadge => 'Actif';

  @override
  String get openPremium => 'Ouvrir Premium';

  @override
  String get appVersionTitle => 'Version de l\'app';

  @override
  String get clearAllDataTitle => 'Effacer toutes les données';

  @override
  String get clearAllDataBody =>
      'Supprime de cet appareil tous les souvenirs, liens, notes, clous et photos copiées.';

  @override
  String get clearData => 'Effacer les données';

  @override
  String exportFailed(Object error) {
    return 'Échec de l\'export : $error';
  }

  @override
  String importRejected(Object message) {
    return 'Import refusé : $message';
  }

  @override
  String importFailed(Object error) {
    return 'Échec de l\'import : $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'Échec de la suppression : $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'Capsule refusée : $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'Échec de l\'import de la capsule : $error';
  }

  @override
  String get clearAllDataQuestion => 'Effacer toutes les données ?';

  @override
  String get clearAllDataQuestionBody =>
      'Toutes les données locales de LifeThreads sur cet appareil seront supprimées définitivement. Exporte d\'abord une sauvegarde si tu veux les garder.';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get allLocalDataCleared =>
      'Toutes les données locales ont été effacées.';

  @override
  String get feedbackGeneral => 'Avis général';

  @override
  String get feedbackBug => 'Bug';

  @override
  String get feedbackCrash => 'Plantage';

  @override
  String get feedbackDesign => 'Problème de design';

  @override
  String get feedbackMissingFeature => 'Fonction manquante';

  @override
  String get feedbackPerformance => 'Performances';

  @override
  String get betaFeedbackIntro =>
      'Décris ce qui s\'est passé ou ce qui t\'a semblé bizarre. Des diagnostics sûrs seront joints, sans contenu privé de tes souvenirs.';

  @override
  String get feedbackType => 'Type';

  @override
  String get feedbackLabel => 'Avis';

  @override
  String get feedbackHint =>
      'Exemple : j\'ai touché Ajouter > Photo rapide et l\'écran s\'est figé.';

  @override
  String get betaFeedbackNotIncluded =>
      'Non inclus : titres des souvenirs, histoires, notes, chemins des photos, chemins des sauvegardes, lieux exacts.';

  @override
  String get feedbackEmpty => 'Écris d\'abord un court message.';

  @override
  String get feedbackCopied =>
      'Aucune app de mail ne s\'est ouverte. Avis copié dans le presse-papiers pour info@gkcoding.dev.';

  @override
  String themeSelected(Object theme) {
    return '$theme sélectionné.';
  }

  @override
  String get onboardingHeadline => 'Crée ton mur vivant.';

  @override
  String get onboardingBody =>
      'Une pièce privée pour tes souvenirs, où photos, lieux, personnes et petites notes sont reliés par des fils d\'émotion.';

  @override
  String get onboardingPrivacy =>
      'Tes souvenirs restent privés par défaut : pas de compte, pas de profil public. Le partage chiffré dans le cloud et la sauvegarde n\'ont lieu que si tu le choisis.';

  @override
  String get onboardingPrivacyShort =>
      'Pas de compte, pas de profil public. Tes souvenirs restent sur cet appareil, sauf si tu en décides autrement.';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingNameTitle => 'Comment doit-on t\'appeler ?';

  @override
  String get onboardingNameHint => 'Ton prénom';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'Enchanté, $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'Choisis comment commencer';

  @override
  String get onboardingGetStartedBody =>
      'Découvre un mur d\'exemple, ou commence avec un mur vide et accroche tes propres souvenirs.';

  @override
  String get settingsNameTitle => 'Ton prénom';

  @override
  String get settingsNameBody => 'Affiché comme salutation sur ton mur.';

  @override
  String get settingsNameHint => 'Ton prénom';

  @override
  String get settingsNameSaved => 'Prénom mis à jour.';

  @override
  String get storyPrivacyTitle => 'Tes souvenirs restent privés';

  @override
  String get storyConnectTitle => 'Relie les moments';

  @override
  String get storyConnectText =>
      'Relie souvenirs, notes et lieux pour que chaque chapitre ait son contexte.';

  @override
  String get storyWallTitle => 'Crée ton mur vivant';

  @override
  String get storyWallText =>
      'Commence avec une photo, puis laisse le mur grandir jusqu\'à ce qu\'il prenne vie.';

  @override
  String get previewDemoWall => 'Voir le mur d\'exemple';

  @override
  String get startFresh => 'Partir de zéro';

  @override
  String get optionalDemoPreview => 'Aperçu facultatif';

  @override
  String get quickTutorial => 'Tutoriel rapide';

  @override
  String get tutorialIntro =>
      'D\'abord l\'essentiel – enregistrer, relier, organiser – puis tout ce que ton mur sait faire.';

  @override
  String get gotIt => 'Compris';

  @override
  String get howItWorks => 'Comment ça marche';

  @override
  String get tutorialAddTitle => 'Ajoute un souvenir';

  @override
  String get tutorialAddText =>
      'Touche +, choisis Souvenir ou Photo rapide, puis enregistre le titre, la date, les personnes et la photo. Si tu pars avant d\'enregistrer, il est gardé comme brouillon.';

  @override
  String get tutorialConnectTitle => 'Relie des souvenirs';

  @override
  String get tutorialConnectText =>
      'Ouvre une carte, touche l\'icône de lien, choisis des souvenirs liés et ajoute une courte raison.';

  @override
  String get tutorialArrangeTitle => 'Organise le mur';

  @override
  String get tutorialArrangeText =>
      'Fais glisser cartes, notes et clous à leur place. Affichage › Organiser les trie par date, catégorie ou lieu – appliqué avec OK.';

  @override
  String get tutorialShowBoardTitle => 'Affiche le tableau';

  @override
  String get tutorialShowBoardText =>
      'Ouvre lifethreads.gkcoding.dev/display sur un autre écran, choisis Plus › Afficher le mur et scanne le code pour afficher un tableau temporaire en lecture seule.';

  @override
  String get tutorialBackupTitle => 'Confidentialité et sauvegarde';

  @override
  String get tutorialBackupText =>
      'Réglages › Confidentialité › Verrouillage ouvre LifeThreads avec Face ID. Avant de changer de téléphone, exporte une sauvegarde dans Réglages › Sauvegarde et données.';

  @override
  String get scanDisplayQr => 'Scanner le QR d\'affichage';

  @override
  String get scannerHintTitle => 'Où est le code QR ?';

  @override
  String get addMemoryBeforeDisplay =>
      'Ajoute un souvenir avant d\'afficher un mur.';

  @override
  String get notLifeThreadsDisplayQr =>
      'Ce n\'est pas un QR d\'affichage LifeThreads.';

  @override
  String get displayWallQuestion => 'Afficher ce mur ?';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads va envoyer un aperçu temporaire en lecture seule avec $memoryCount souvenirs à la session de navigateur scannée. Il s\'ouvre sur lifethreads.gkcoding.dev/display et expire tout seul.';
  }

  @override
  String get displayAction => 'Afficher';

  @override
  String get soon => 'bientôt';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'Le mur est affiché avec $memoryCount souvenirs jusqu\'à $expires.';
  }

  @override
  String get preparingWallDisplay => 'Préparation de l\'affichage...';

  @override
  String get open => 'Ouvrir';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get done => 'OK';

  @override
  String get back => 'Retour';

  @override
  String get continueAction => 'Continuer';

  @override
  String get close => 'Fermer';

  @override
  String get add => 'Ajouter';

  @override
  String get saveReason => 'Enregistrer la raison';

  @override
  String get chooseBackup => 'Choisir une sauvegarde';

  @override
  String get chooseArchive => 'Choisir une archive';

  @override
  String get chooseCapsule => 'Choisir une capsule';

  @override
  String get exportAction => 'Exporter';

  @override
  String get addToWall => 'Ajouter au mur';

  @override
  String get cinemaSkip => 'Passer';

  @override
  String get cinemaNotNow => 'Pas maintenant';

  @override
  String get cinemaSharedChapter => 'Un chapitre partagé';

  @override
  String get cinemaConnectedThread => 'Fil relié';

  @override
  String get cinemaInviteTitle => 'Ajouter ce souvenir à ton mur ?';

  @override
  String get useSelected => 'Utiliser la sélection';

  @override
  String photoGridItem(String date) {
    return 'Photo du $date';
  }

  @override
  String get noPhotosFound => 'Aucune photo trouvée.';

  @override
  String get manage => 'Gérer';

  @override
  String get manageAccess => 'Gérer l\'accès';

  @override
  String get saveNow => 'Enregistrer';

  @override
  String get hangOnWall => 'Accrocher au mur';

  @override
  String get placeHere => 'Placer ici';

  @override
  String get openSettings => 'Ouvrir les Réglages';

  @override
  String get viewPremium => 'Voir Premium';

  @override
  String get memoryNotFound => 'Souvenir introuvable';

  @override
  String get memoryTypeMoment => 'Moment';

  @override
  String get memoryTypeTrip => 'Voyage';

  @override
  String get memoryTypePerson => 'Personne';

  @override
  String get memoryTypePlace => 'Lieu';

  @override
  String get memoryTypeNote => 'Note';

  @override
  String get memoryTypeMomentDescription => 'Une petite scène à garder';

  @override
  String get memoryTypeTripDescription => 'Un voyage ou une journée ailleurs';

  @override
  String get memoryTypePersonDescription => 'Quelqu\'un d\'important';

  @override
  String get memoryTypePlaceDescription => 'Un lieu qui a du sens';

  @override
  String get memoryTypeNoteDescription =>
      'Une pensée, une citation ou un rappel';

  @override
  String get categoryPersonal => 'Perso';

  @override
  String get categoryFamily => 'Famille';

  @override
  String get categoryTravel => 'Voyages';

  @override
  String get feelingWarm => 'Tendre';

  @override
  String get feelingNostalgic => 'Nostalgique';

  @override
  String get feelingProud => 'Fier';

  @override
  String get feelingCalm => 'Calme';

  @override
  String get feelingImportant => 'Important';

  @override
  String get feelingWarmDescription => 'Doux, proche, plein d\'amour.';

  @override
  String get feelingNostalgicDescription =>
      'Un souvenir qui te ramène en arrière.';

  @override
  String get feelingProudDescription => 'Un moment qui a prouvé quelque chose.';

  @override
  String get feelingCalmDescription => 'Paisible, sûr, serein.';

  @override
  String get feelingImportantDescription =>
      'Un souvenir qui a changé l\'histoire.';

  @override
  String get addPeopleHint =>
      'Ajoute les personnes de ce moment. Les contacts restent sur ton appareil.';

  @override
  String get addPerson => 'Ajouter une personne';

  @override
  String get editPerson => 'Modifier la personne';

  @override
  String get chooseFromContacts => 'Choisir dans les contacts';

  @override
  String get personNameLabel => 'Nom';

  @override
  String get personNameHint => 'Tape pour chercher une personne enregistrée';

  @override
  String get relationshipLabel => 'Lien';

  @override
  String get relationshipHint => 'Ami, mère, partenaire...';

  @override
  String get phoneOptionalLabel => 'Téléphone (facultatif)';

  @override
  String get emailOptionalLabel => 'E-mail (facultatif)';

  @override
  String get nameRelationshipRequired => 'Le nom et le lien sont obligatoires.';

  @override
  String get contactAccessDenied =>
      'L\'accès aux contacts n\'a pas été autorisé.';

  @override
  String get couldNotOpenContacts => 'Impossible d\'ouvrir les contacts.';

  @override
  String get chooseContact => 'Choisir un contact';

  @override
  String get searchContacts => 'Rechercher des contacts';

  @override
  String get noContactsFound => 'Aucun contact trouvé.';

  @override
  String get unnamedContact => 'Contact sans nom';

  @override
  String get contactRelationship => 'Contact';

  @override
  String get couldNotLoadContacts => 'Impossible de charger les contacts.';

  @override
  String get saveMomentTitle => 'Garde un moment';

  @override
  String get todayEyebrow => 'Aujourd\'hui';

  @override
  String get addMemoryStepTitle =>
      'Que s\'est-il passé que tu ne veux pas perdre ?';

  @override
  String get addMemoryStepSubtitle =>
      'Écris une ligne, ajoute une photo si tu en as une, et enregistre. Les détails peuvent attendre.';

  @override
  String get momentLabel => 'Moment';

  @override
  String get momentHint =>
      'Dîner avec Lara, premier lancement, balade tranquille...';

  @override
  String get storyWorthLabel => 'Pourquoi ça vaut la peine de le garder ?';

  @override
  String get storyWorthHint => 'Quelques mots suffisent.';

  @override
  String get feelingEyebrow => 'Émotion';

  @override
  String get feelingStepTitle => 'Quelle émotion quand il reviendra ?';

  @override
  String get feelingStepSubtitle =>
      'Le souvenir sera plus facile à retrouver plus tard.';

  @override
  String get contextEyebrow => 'Contexte';

  @override
  String get whenWasItTitle => 'C\'était quand ?';

  @override
  String get photoGpsStepSubtitle =>
      'La carte utilise le GPS enregistré dans les photos choisies. Si une photo n\'a pas de GPS, aucun lieu n\'est affiché.';

  @override
  String get peopleThreadsEyebrow => 'Personnes et fils';

  @override
  String get peopleThreadsTitle => 'À qui ou à quoi est-ce relié ?';

  @override
  String get peopleThreadsSubtitle =>
      'Les détails facultatifs font de simples moments un fil de vie.';

  @override
  String get connectExistingMemoryLabel => 'Relier à un souvenir existant';

  @override
  String get noConnectionYet => 'Pas encore de lien';

  @override
  String get connectionReasonLabel => 'Pourquoi sont-ils liés ?';

  @override
  String get connectionReasonHint =>
      'Exemple : même voyage, même personne, avant / après...';

  @override
  String get writeMomentOrPhotoFirst =>
      'Écris un moment ou ajoute d\'abord une photo.';

  @override
  String get todaysMoment => 'Le moment du jour';

  @override
  String get savedFromTodaysPrompt => 'Enregistré depuis la question du jour.';

  @override
  String get saveItBeforeItFades => 'Garde-le avant qu\'il ne s\'efface';

  @override
  String get chooseDate => 'Choisir la date';

  @override
  String get dateLabel => 'Date';

  @override
  String get untitledMemory => 'Souvenir sans titre';

  @override
  String get organize => 'Organiser';

  @override
  String get memoryShape => 'Forme du souvenir';

  @override
  String get wallCategory => 'Catégorie du mur';

  @override
  String get privatePhotos => 'Photos privées';

  @override
  String get pick => 'Choisir';

  @override
  String get addMore => 'Ajouter';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get takePhotosNow => 'Prendre des photos';

  @override
  String get takePhotosFabTooltip =>
      'Prendre des photos pour un nouveau souvenir';

  @override
  String get takeAnotherPhoto => 'Prendre une autre photo';

  @override
  String get continueWithPhotos => 'Continuer avec ces photos';

  @override
  String get addPhotosToMemory => 'Ajouter au souvenir';

  @override
  String get takeAnotherOrContinueBody =>
      'Continue à photographier pour ce souvenir, ou passe à la suite pour ajouter l\'histoire.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos prises',
      one: '1 photo prise',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads copie les photos choisies dans le stockage privé de l\'app et garde la date et le lieu quand ils sont disponibles.';

  @override
  String get limitedPhotoAccessActive =>
      'L\'accès limité aux photos est actif. Tu peux autoriser d\'autres photos.';

  @override
  String get selectPhotos => 'Sélectionner des photos';

  @override
  String get photoAccessOff => 'L\'accès aux photos est désactivé';

  @override
  String get photoAccessOffBody =>
      'Active l\'accès aux photos pour choisir des souvenirs. Tes photos restent sur cet appareil.';

  @override
  String get freeMemoryLimitReached => 'Limite gratuite atteinte';

  @override
  String get freeMemoryLimitBody =>
      'Les murs gratuits incluent 30 souvenirs. Passe à Premium pour continuer ton mur vivant.';

  @override
  String get photoAccessNeeded =>
      'L\'accès aux photos est nécessaire d\'abord.';

  @override
  String get quickPhotoMemory => 'Photo rapide';

  @override
  String get quickPhotoDescription =>
      'Une photo à garder. Ajoute l\'histoire quand tu veux.';

  @override
  String get hangQuickPhoto => 'Accrocher la photo';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'GPS de la photo détecté : $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'Aucun GPS dans la photo. Ce souvenir n\'apparaîtra pas sur la carte.';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • $photoCount photo(s)';
  }

  @override
  String metadataDates(int count, int total) {
    return '$count/$total dates';
  }

  @override
  String metadataLocations(int count, int total) {
    return '$count/$total lieux';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total tailles';
  }

  @override
  String newSelected(int count) {
    return '$count nouvelles sélectionnées';
  }

  @override
  String selectedCount(int count) {
    return '$count sélectionnées';
  }

  @override
  String get editMemoryTitle => 'Modifier le souvenir';

  @override
  String get storyPanel => 'Histoire';

  @override
  String get memoryTitleLabel => 'Titre du souvenir';

  @override
  String get addTitleValidation => 'Ajoute un titre';

  @override
  String get storyDescriptionLabel => 'Histoire / description';

  @override
  String get addStoryValidation => 'Ajoute une courte histoire';

  @override
  String get shapeFeelingTitle => 'Forme et émotion';

  @override
  String get memoryTypeLabel => 'Type de souvenir';

  @override
  String get feelingLabel => 'Émotion';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get timePhotoGpsTitle => 'Date et GPS de la photo';

  @override
  String get memoryDateLabel => 'Date du souvenir';

  @override
  String get peopleTitle => 'Personnes';

  @override
  String get galleryTitle => 'Galerie';

  @override
  String get addPhotos => 'Ajouter des photos';

  @override
  String get saveMemory => 'Enregistrer le souvenir';

  @override
  String get memorySaveFailed =>
      'Impossible d\'enregistrer ce souvenir. Réessaie.';

  @override
  String get passwordOnlySpaces =>
      'Un mot de passe ne peut pas contenir que des espaces.';

  @override
  String get somethingWentWrong => 'Un problème est survenu. Réessaie.';

  @override
  String get mapUnavailable => 'La carte n\'est pas disponible pour le moment.';

  @override
  String get coverPhoto => 'Photo de couverture';

  @override
  String get galleryPhoto => 'Photo de la galerie';

  @override
  String get setAsCover => 'Mettre en couverture';

  @override
  String get replacePhoto => 'Remplacer la photo';

  @override
  String get removePhoto => 'Retirer la photo';

  @override
  String get choosePhoto => 'Choisir une photo';

  @override
  String get threadReasonsTitle => 'Raisons des fils';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'Crée d\'autres souvenirs avant de les relier.';

  @override
  String get connectionHeaderBody =>
      'Relie des souvenirs avec une raison. La corde doit dire pourquoi deux moments vont ensemble.';

  @override
  String get connectedMemory => 'souvenir relié';

  @override
  String get whyConnectedTitle => 'Pourquoi sont-ils liés ?';

  @override
  String get exportPremiumArchiveTitle => 'Exporter la sauvegarde';

  @override
  String get importArchiveTitle => 'Importer une archive';

  @override
  String get archiveExportBody =>
      'Ajoute un mot de passe pour chiffrer l\'archive. Laisse vide pour un zip local normal.';

  @override
  String get archiveImportBody =>
      'Si cette archive est chiffrée, saisis son mot de passe. Laisse vide pour les sauvegardes anciennes ou non protégées.';

  @override
  String get archivePasswordOptional =>
      'Mot de passe de l\'archive (facultatif)';

  @override
  String get archivePasswordLabel => 'Mot de passe de l\'archive';

  @override
  String get archivePasswordWarning =>
      'Garde le mot de passe en lieu sûr. Il ne peut pas être récupéré si tu le perds.';

  @override
  String get sendArchiveTitle => 'Envoyer l\'archive LifeThreads';

  @override
  String get sendArchiveSubject => 'Archive de souvenirs LifeThreads';

  @override
  String get sendEncryptedArchiveText =>
      'Archive LifeThreads chiffrée. Utilise le mot de passe choisi pour l\'importer sur un autre appareil.';

  @override
  String get sendArchiveText =>
      'Archive LifeThreads. Importe-la dans LifeThreads pour ouvrir ton mur de souvenirs sur un autre appareil.';

  @override
  String get archiveReadyToSend =>
      'Sauvegarde prête. Garde-la en lieu sûr, ailleurs que sur ce téléphone.';

  @override
  String get archiveNotSaved =>
      'Sauvegarde non enregistrée. Exporte à nouveau quand tu es prêt.';

  @override
  String get archiveSharingUnavailable =>
      'Le partage n\'est pas disponible sur cet appareil.';

  @override
  String archiveShareFailed(Object error) {
    return 'Archive enregistrée, mais le partage a échoué : $error';
  }

  @override
  String get archiveImportedTitle => 'Archive importée';

  @override
  String get memoriesLabel => 'Souvenirs';

  @override
  String get photosLabel => 'Photos';

  @override
  String get wallNotesNailsLabel => 'Notes / clous';

  @override
  String get connectionsLabel => 'Liens';

  @override
  String get archiveImportSummary =>
      'Ton mur actuel est conservé. Les souvenirs importés ont été ajoutés en toute sécurité.';

  @override
  String get shareEncryptedCapsuleTitle => 'Partager une capsule chiffrée';

  @override
  String get openSharedCapsuleTitle => 'Ouvrir une capsule partagée';

  @override
  String get exportMemoryCapsuleTitle => 'Exporter une capsule souvenir';

  @override
  String get importCapsuleDialogTitle => 'Importer une capsule';

  @override
  String get secureSharePasswordBody =>
      'Crée un mot de passe avant d\'envoyer cette capsule. Envoie le mot de passe séparément à la personne qui la reçoit.';

  @override
  String get sharedCapsulePasswordBody =>
      'Saisis le mot de passe reçu pour ce souvenir partagé.';

  @override
  String get capsuleExportBody =>
      'Ajoute un mot de passe si ce souvenir doit être protégé avant l\'envoi. Laisse vide pour une capsule normale.';

  @override
  String get capsuleImportBody =>
      'Si cette capsule a un mot de passe, saisis-le. Sinon, laisse vide.';

  @override
  String get capsulePasswordLabel => 'Mot de passe de la capsule';

  @override
  String get sharedCapsulePasswordLabel =>
      'Mot de passe de la capsule partagée';

  @override
  String get capsulePasswordOptional =>
      'Mot de passe de la capsule (facultatif)';

  @override
  String get capsulePasswordWarning =>
      'LifeThreads ne pourra pas récupérer ce mot de passe.';

  @override
  String get passwordRequiredCloudSharing =>
      'Un mot de passe est requis pour le partage cloud.';

  @override
  String get createSecureShare => 'Créer un partage sécurisé';

  @override
  String get previewMemory => 'Aperçu du souvenir';

  @override
  String get sendCapsuleTitle => 'Partager un souvenir LifeThreads';

  @override
  String get sendCapsuleSubject => 'Capsule souvenir LifeThreads';

  @override
  String get sendEncryptedCapsuleText =>
      'Coucou, je t\'ai partagé un souvenir LifeThreads protégé. Utilise le mot de passe que je t\'ai envoyé pour l\'importer.';

  @override
  String get sendCapsuleText =>
      'Coucou, je t\'ai partagé un souvenir LifeThreads. Importe la capsule dans LifeThreads pour l\'ajouter à ton mur.';

  @override
  String get capsuleReadyToSend => 'Capsule prête à envoyer.';

  @override
  String get capsuleSavedLater =>
      'Capsule enregistrée. Tu peux la partager plus tard.';

  @override
  String get capsuleSharingUnavailable =>
      'Capsule enregistrée, mais le partage n\'est pas disponible.';

  @override
  String capsuleShareFailed(Object error) {
    return 'Capsule enregistrée, mais le partage a échoué : $error';
  }

  @override
  String get importThisMemory => 'Importer ce souvenir ?';

  @override
  String get noStoryTextIncluded => 'Aucun texte d\'histoire inclus.';

  @override
  String get placeLabel => 'Lieu';

  @override
  String get notesLabel => 'Notes';

  @override
  String get capsulePasswordProtected =>
      'Cette capsule était protégée par un mot de passe.';

  @override
  String get openingSharedMemory => 'Ouverture du souvenir partagé...';

  @override
  String get lifeThreadsMemoryTitle => 'Souvenir LifeThreads';

  @override
  String shareMemoryText(Object url) {
    return 'Coucou, je t\'ai partagé un souvenir dans LifeThreads.\n\n$url';
  }

  @override
  String get shareLinkReady => 'Lien de partage prêt.';

  @override
  String get shareLinkCreated => 'Lien de partage créé.';

  @override
  String get shareLinkUnavailable =>
      'Lien créé, mais le partage n\'est pas disponible.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label Le lien expire tout seul. Tu peux le supprimer maintenant.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'Échec du partage cloud : $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'Lien du souvenir partagé supprimé.';

  @override
  String get creatingSecureMemoryLink => 'Création du lien sécurisé...';

  @override
  String get shareMemoryCapsule => 'Partager une capsule';

  @override
  String get editStory => 'Modifier l\'histoire';

  @override
  String get metaType => 'Type';

  @override
  String get metaFeeling => 'Émotion';

  @override
  String get metaCategory => 'Catégorie';

  @override
  String get metaDate => 'Date';

  @override
  String get storyEyebrow => 'Histoire';

  @override
  String get whyMemoryMatters => 'Pourquoi ce souvenir compte';

  @override
  String get galleryEyebrow => 'Galerie';

  @override
  String editSectionTooltip(String section) {
    return 'Modifier $section';
  }

  @override
  String get openInMaps => 'Ouvrir dans Plans';

  @override
  String get memoryChangesSaved => 'Modifications enregistrées.';

  @override
  String get memoryDeletedToast => 'Souvenir supprimé.';

  @override
  String get noteDeletedToast => 'Note supprimée.';

  @override
  String get nailDeletedToast => 'Clou retiré.';

  @override
  String get undo => 'Annuler';

  @override
  String photoPlaceDetected(String place) {
    return 'Lieu de la photo : $place';
  }

  @override
  String get settingsGroupYou => 'Toi';

  @override
  String get settingsGroupReminders => 'Rappels';

  @override
  String get settingsGroupMore => 'Plus';

  @override
  String get backupDataTitle => 'Sauvegarde et données';

  @override
  String get backupDataSubtitle =>
      'Sauvegarder, restaurer, changer de téléphone';

  @override
  String get aboutHelpTitle => 'À propos et aide';

  @override
  String get aboutHelpSubtitle => 'Avis, confidentialité, musique, version';

  @override
  String get discardChangesTitle => 'Abandonner les modifications ?';

  @override
  String get discardChangesBody => 'Ce que tu as modifié ici sera perdu.';

  @override
  String get discardChanges => 'Abandonner';

  @override
  String get keepEditing => 'Continuer';

  @override
  String get settingsGroupPrivacy => 'Confidentialité';

  @override
  String get appLockTitle => 'Verrouillage';

  @override
  String get appLockSubtitle => 'Face ID ou code pour ouvrir LifeThreads';

  @override
  String get appLockReason => 'Déverrouille tes souvenirs';

  @override
  String get appLockLockedTitle => 'LifeThreads est verrouillé';

  @override
  String get appLockUnlock => 'Déverrouiller';

  @override
  String get appLockUnavailable =>
      'Configure d\'abord Face ID ou un code sur ce téléphone.';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Un souvenir d\'il y a $years ans t\'attend.',
      one: 'Un souvenir d\'il y a 1 an t\'attend.',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Recherche';

  @override
  String get searchHint => 'Titre, lieu, personne ou année';

  @override
  String get searchClear => 'Effacer la recherche';

  @override
  String get searchNoResults => 'Aucun souvenir ne correspond.';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count souvenirs',
      one: '1 souvenir',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => 'Rechercher des souvenirs';

  @override
  String get premiumFeatureWalls => 'Plus de murs';

  @override
  String get newWall => 'Nouveau mur';

  @override
  String get wallNameLabel => 'Nom du mur';

  @override
  String get newWallHint => 'ex. Voyages 2025';

  @override
  String get createWall => 'Créer';

  @override
  String get renameWall => 'Renommer';

  @override
  String get deleteWall => 'Supprimer le mur';

  @override
  String deleteWallQuestion(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get deleteWallBody =>
      'Ses souvenirs vont dans Mon mur ; rien n\'est perdu.';

  @override
  String get personalWallSubtitle => 'Ton mur, sur cet appareil';

  @override
  String get wallOptions => 'Options du mur';

  @override
  String get moveToWall => 'Déplacer vers un mur…';

  @override
  String movedToWall(String name) {
    return 'Déplacé vers $name.';
  }

  @override
  String get hideMemory => 'Masquer';

  @override
  String get unhideMemory => 'Afficher à nouveau';

  @override
  String get memoryHiddenToast =>
      'Masqué. Retrouve-le dans Affichage › Souvenirs masqués.';

  @override
  String get showHiddenMemories => 'Souvenirs masqués';

  @override
  String get showHiddenReason => 'Afficher les souvenirs masqués';

  @override
  String get yearThreadFirstTitle => 'Ton premier Fil de l\'année';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count souvenirs sur 3',
      one: '1 souvenir sur 3',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => 'Ou crée une story maintenant';

  @override
  String get moveMemoriesHere => 'Déplacer des souvenirs ici';

  @override
  String get moveMemoriesTitle => 'Choisis les souvenirs à déplacer ici';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Déplacer $count souvenirs',
      one: 'Déplacer 1 souvenir',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'Tout afficher';

  @override
  String get addAMemory => 'Ajouter un souvenir';

  @override
  String get mapAddPhotoMemory => 'Ajoute une photo avec son lieu';

  @override
  String get searchSuggestions => 'Essaie avec l\'un des tiens';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Cette semaine, il y a $years ans',
      one: 'Cette semaine, il y a 1 an',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => 'Qui était là ?';

  @override
  String get premiumPlanYearly => 'Annuel';

  @override
  String get premiumPlanMonthly => 'Mensuel';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/an';
  }

  @override
  String premiumSavePercent(int percent) {
    return '−$percent %';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'Le paiement est débité de ton compte $store. L\'abonnement se renouvelle automatiquement chaque année, sauf si tu l\'annules au moins 24 heures avant la fin de la période en cours. Gère-le ou annule-le dans les réglages de ton compte $store.';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos enregistrées',
      one: '1 photo enregistrée',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => 'Personnes';

  @override
  String get partOfMemory => 'Dans ce souvenir';

  @override
  String get notesEyebrow => 'Notes';

  @override
  String get attachedThoughts => 'Pensées jointes';

  @override
  String get stickyNote => 'Post-it';

  @override
  String get placeEyebrow => 'Lieu';

  @override
  String get threadsEyebrow => 'Fils';

  @override
  String get connectedMemories => 'Souvenirs reliés';

  @override
  String get noConnectedMemoriesYet =>
      'Pas encore de souvenirs reliés. Relie ce chapitre à un autre moment pour commencer un fil de vie visible.';

  @override
  String get backToWall => 'Retour au mur';

  @override
  String get addTextToWall => 'Ajouter du texte au mur';

  @override
  String get addTextAction => 'Ajouter du texte';

  @override
  String get textNoteHint =>
      'Écris un petit souvenir, une citation ou une note...';

  @override
  String get placeTextNote => 'Placer la note';

  @override
  String get placeRopeAnchor => 'Placer l\'ancre';

  @override
  String get nailSubtitle =>
      'Un clou permet de relier des cordes à la main entre les souvenirs.';

  @override
  String get clearDemoWallQuestion => 'Effacer le mur d\'exemple ?';

  @override
  String get clearDemoWallBody =>
      'Les souvenirs d\'exemple seront retirés pour que tu commences avec un mur privé vide.';

  @override
  String get importBackupQuestion => 'Importer la sauvegarde ?';

  @override
  String get importBackupBody =>
      'Restaure les souvenirs d\'une archive LifeThreads et garde ton mur actuel.';

  @override
  String get deleteMemoryQuestion => 'Supprimer le souvenir ?';

  @override
  String get deleteMemoryBody =>
      'Le souvenir et tous ses liens sur le mur seront supprimés.';

  @override
  String get editText => 'Modifier le texte';

  @override
  String get editTextTitle => 'Modifier le texte';

  @override
  String get connectRope => 'Relier une corde';

  @override
  String get connectRopeSubtitle => 'Attache ce clou à des souvenirs.';

  @override
  String get deleteNail => 'Supprimer le clou';

  @override
  String get connectNailTitle => 'Relier le clou aux souvenirs';

  @override
  String get connectNailSubtitle =>
      'Les souvenirs choisis seront suspendus à cette ancre.';

  @override
  String get timelineTitle => 'Chronologie';

  @override
  String get timelineSubtitle => 'Tes souvenirs par ordre chronologique.';

  @override
  String get noMemoriesFilter => 'Aucun souvenir avec ce filtre';

  @override
  String get noMemoriesFilterBody =>
      'Change de filtre ou ajoute un souvenir pour créer la chronologie.';

  @override
  String get memoryMapTitle => 'Carte des souvenirs';

  @override
  String get memoryMapSubtitle => 'Tes souvenirs regroupés par lieu.';

  @override
  String get noMappedMemories => 'Pas encore de souvenirs sur la carte';

  @override
  String get displayWallTooltip => 'Afficher le mur';

  @override
  String get tutorialTooltip => 'Tutoriel';

  @override
  String get settingsTooltip => 'Réglages';

  @override
  String get freeformLayout => 'Libre';

  @override
  String get categoryLayout => 'Catégorie';

  @override
  String get locationLayout => 'Lieu';

  @override
  String get saveToday => 'Garder aujourd\'hui';

  @override
  String get rememberThis => 'Garde ça en mémoire';

  @override
  String get whatHappenedToday => 'Que s\'est-il passé aujourd\'hui ?';

  @override
  String get tapToOpenDrag => 'Touche pour ouvrir • glisse pour déplacer';

  @override
  String get demoWallPreview =>
      'Mur d\'exemple. Efface-le quand tu veux repartir de zéro.';

  @override
  String get clearDemo => 'Effacer l\'exemple';

  @override
  String get chooseQuickPhoto => 'Choisir une photo rapide';

  @override
  String get wallView => 'Mur';

  @override
  String get timelineView => 'Chronologie';

  @override
  String get mapView => 'Carte';

  @override
  String get wallFilterAll => 'Tout';

  @override
  String get wallViewButton => 'Affichage';

  @override
  String get wallShowAs => 'Afficher en';

  @override
  String get wallArrange => 'Organiser';

  @override
  String get wallShowOnly => 'Afficher';

  @override
  String get layoutByDate => 'Par date';

  @override
  String get moreActionsTooltip => 'Plus';

  @override
  String get addToWallTitle => 'Ajouter à ton mur';

  @override
  String get expandableMemory => 'Souvenir';

  @override
  String get expandableMemorySubtitle => 'Histoire guidée complète';

  @override
  String get expandableQuickPhoto => 'Photo rapide';

  @override
  String get expandableQuickPhotoSubtitle => 'Choisis une photo et accroche-la';

  @override
  String get expandableTextNote => 'Note';

  @override
  String get expandableTextNoteSubtitle => 'Une petite pensée au mur';

  @override
  String get expandableNail => 'Clou / ancre';

  @override
  String get expandableNailSubtitle => 'Point d\'attache manuel';

  @override
  String get startWithOneThing => 'Commence par une chose d\'aujourd\'hui';

  @override
  String get emptyWallBody =>
      'Garde un moment avant qu\'il ne s\'efface. Une phrase ou une photo suffit.';

  @override
  String get usePhoto => 'Utiliser une photo';

  @override
  String get editMemoryTooltip => 'Modifier le souvenir';

  @override
  String get connectMemoryTooltip => 'Relier le souvenir';

  @override
  String get archiveTransferTitle => 'Ouvrir sur un autre appareil';

  @override
  String get archiveTransferHeroTitle =>
      'Transfère tes souvenirs d\'un appareil à l\'autre en toute sécurité.';

  @override
  String get archiveTransferHeroBody =>
      'Une sauvegarde est un zip avec tes souvenirs, photos, notes, fils, positions sur le mur et métadonnées, protégé par mot de passe si tu veux. Nous ne gardons aucune copie : c\'est toi qui décides où il va.';

  @override
  String get archiveTransferStep1Title => 'Exporte une archive';

  @override
  String get archiveTransferStep1Body =>
      'Ouvre Réglages, choisis Exporter l\'archive et ajoute un mot de passe si tu veux la protéger.';

  @override
  String get archiveTransferStep2Title => 'Déplace le zip';

  @override
  String get archiveTransferStep2Body =>
      'Transfère-le par AirDrop, USB, ton propre cloud ou par e-mail.';

  @override
  String get archiveTransferStep3Title => 'Importe en sécurité';

  @override
  String get archiveTransferStep3Body =>
      'Installe LifeThreads sur l\'autre appareil, choisis Importer une archive, saisis le mot de passe si besoin et restaure sans effacer les données existantes.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled =>
      'Déblocage Premium de développement activé.';

  @override
  String get lifetimeActive => 'Abonnement actif';

  @override
  String get oneTimeLifetimeUnlock => 'À l\'année ou au mois';

  @override
  String get premiumHeroActiveTitle => 'Ton mur de souvenirs est illimité.';

  @override
  String get premiumHeroLockedTitle => 'Fais de tes souvenirs des stories.';

  @override
  String get premiumHeroActiveBody =>
      'Ton abonnement Premium est actif. Stories en musique, Fil de l\'année, murs de famille et souvenirs illimités sont à toi.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'La version gratuite inclut $limit souvenirs et des sauvegardes complètes. Premium ajoute stories et films en musique, Fil de l\'année, murs de famille et souvenirs illimités.';
  }

  @override
  String get premiumMemories => 'Souvenirs Premium';

  @override
  String get freeMemories => 'Souvenirs gratuits';

  @override
  String get unlimited => 'illimités';

  @override
  String get benefitUnlimitedTitle => 'Souvenirs illimités';

  @override
  String get benefitUnlimitedBody =>
      'Fini la limite de 30 souvenirs. Ton mur grandit avec ta vie.';

  @override
  String get benefitThemesTitle => 'Thèmes Premium';

  @override
  String get benefitThemesBody =>
      'Débloque des ambiances plus riches, des thèmes de saison et le mode Auto selon l\'heure.';

  @override
  String get benefitLayoutsTitle => 'Dispositions avancées';

  @override
  String get benefitLayoutsBody =>
      'Plus de façons d\'organiser fils, chronologies, ancres et groupes de souvenirs.';

  @override
  String get lifetimeUnlock => 'Abonnement Premium';

  @override
  String get premiumActiveOnDevice => 'Premium est actif sur cet appareil.';

  @override
  String onePurchaseBody(String store) {
    return 'Abonne-toi à l\'année ou au mois pour les stories en musique, le Fil de l\'année, les murs de famille et des souvenirs illimités. Résiliable à tout moment dans les réglages $store.';
  }

  @override
  String get premiumActiveButton => 'Premium actif';

  @override
  String get processing => 'Traitement...';

  @override
  String get unlockPremium => 'S\'abonner à Premium';

  @override
  String get restorePurchase => 'Restaurer l\'abonnement';

  @override
  String get enableDebugMockUnlock => 'Activer le déblocage de test';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'Le paiement est débité de ton compte $store. L\'abonnement se renouvelle automatiquement chaque mois, sauf si tu l\'annules au moins 24 heures avant la fin de la période en cours. Gère-le ou annule-le dans les réglages de ton compte $store.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'La mise à jour du store a échoué. Réessaie.';

  @override
  String get premiumMessageStoreUnavailable =>
      'Les achats ne sont pas disponibles sur cet appareil.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium n\'est pas encore disponible dans le store. Réessaie plus tard.';

  @override
  String get premiumMessageLoadFailed =>
      'Impossible de charger Premium depuis le store. Réessaie.';

  @override
  String get premiumMessageOpeningCheckout => 'Ouverture du paiement…';

  @override
  String get premiumMessageCheckoutFailed =>
      'Impossible d\'ouvrir le paiement. Réessaie.';

  @override
  String get premiumMessageChecking => 'Vérification de ton abonnement…';

  @override
  String get premiumMessageRestoreFailed =>
      'La restauration a échoué. Réessaie.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'Aucun abonnement Premium actif trouvé.';

  @override
  String get premiumMessagePending =>
      'Ton achat est en attente. Premium sera débloqué dès qu\'il sera approuvé.';

  @override
  String get premiumMessagePurchaseFailed =>
      'L\'achat n\'a pas abouti. Réessaie.';

  @override
  String get premiumMessageCanceled => 'Achat annulé.';

  @override
  String get premiumMessageRestored => 'Ton abonnement Premium est restauré.';

  @override
  String get premiumMessageActive => 'Ton abonnement Premium est actif.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/mois';
  }

  @override
  String get loadingPlayStoreProduct => 'Chargement de l\'abonnement…';

  @override
  String get playStoreUnavailable => 'Le store est indisponible pour le moment';

  @override
  String get productNotConfigured =>
      'Premium n\'est pas disponible pour le moment';

  @override
  String get purchasePending => 'Achat en attente';

  @override
  String get purchased => 'Acheté';

  @override
  String get restored => 'Restauré';

  @override
  String get premiumTryAgain => 'Réessayer';

  @override
  String get purchaseFailed => 'Échec de l\'achat';

  @override
  String get preparingCheckout => 'Préparation du paiement...';

  @override
  String get premiumLocalFirstTitle => 'Premium reste local';

  @override
  String get premiumLocalFirstBody =>
      'Tes souvenirs restent sur ton appareil, et les sauvegardes sont gratuites pour tous.';

  @override
  String get noMappedMemoriesBody =>
      'Ajoute des photos avec des données GPS pour voir des souvenirs ici.';

  @override
  String get peopleLabel => 'Personnes';

  @override
  String get connect => 'Relier';

  @override
  String get themeWarmMemoryRoom => 'Salon chaleureux';

  @override
  String get themeWarmMemoryRoomDescription =>
      'Douceur sombre, lumière dorée et profondeur d\'une pièce intime.';

  @override
  String get themeMidnightArchive => 'Archives de minuit';

  @override
  String get themeMidnightArchiveDescription =>
      'Salle d\'archives bleu profond, au calme d\'un musée.';

  @override
  String get themeSoftPaperWall => 'Papier doux';

  @override
  String get themeSoftPaperWallDescription =>
      'Papier crème, ombres d\'encre et douceur d\'un scrapbook.';

  @override
  String get themeTravelCorkboard => 'Liège de voyage';

  @override
  String get themeTravelCorkboardDescription =>
      'La chaleur du liège avec des touches de carte pour les voyages et les lieux.';

  @override
  String get themeAutoTitle => 'Auto selon l\'heure';

  @override
  String get themeAutoDescription =>
      'Papier doux le jour, Salon chaleureux le soir, Archives de minuit la nuit.';

  @override
  String get themeAutoSelected =>
      'Ton mur suit maintenant l\'heure de la journée.';

  @override
  String get themeSeasonalTitle => 'De saison';

  @override
  String get themeSeasonalBody =>
      'Thèmes Premium limités, chacun disponible seulement pendant sa saison.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Jusqu\'au $dateString';
  }

  @override
  String get themeUseButton => 'Utiliser ce thème';

  @override
  String get themeInUse => 'Utilisé';

  @override
  String get themeUnlockButton => 'Débloquer avec Premium';

  @override
  String get themeAutumnHarvest => 'Récolte d\'automne';

  @override
  String get themeAutumnHarvestDescription =>
      'Lumière ambrée, cartes en papier kraft et éclat des feuilles qui tombent.';

  @override
  String get themeWinterLights => 'Lumières d\'hiver';

  @override
  String get themeWinterLightsDescription =>
      'Cartes givrées et guirlandes chaleureuses par une froide nuit bleue.';

  @override
  String get themeSpringBlossom => 'Fleurs de printemps';

  @override
  String get themeSpringBlossomDescription =>
      'Cartes aux fleurs pâles avec une douce lueur rose.';

  @override
  String get themeSummerEvening => 'Soir d\'été';

  @override
  String get themeSummerEveningDescription =>
      'Couleurs de coucher de soleil et cartes photo instantanée.';

  @override
  String get themeYearRoundTitle => 'Toujours disponibles';

  @override
  String get themeComingTitle => 'Bientôt';

  @override
  String get themeComingBody =>
      'Découvre les prochaines saisons. Chaque thème s\'ouvre le premier jour de sa saison.';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'À partir du $dateString';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Voir tous les thèmes, dont $count de saison',
      one: 'Voir tous les thèmes, dont 1 de saison',
      zero: 'Voir tous les thèmes',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => 'Bord de mer';

  @override
  String get themeSeasideDescription =>
      'Eau turquoise, papier sable et chaude lumière d\'été.';

  @override
  String get themeSnowyCabin => 'Chalet enneigé';

  @override
  String get themeSnowyCabinDescription =>
      'Bois au coin du feu, cartes givrées et neige douce dehors.';

  @override
  String get themeSpringMeadow => 'Prairie de printemps';

  @override
  String get themeSpringMeadowDescription =>
      'Herbe fraîche, cartes claires et soleil jaune.';

  @override
  String get themeMistyForest => 'Forêt brumeuse';

  @override
  String get themeMistyForestDescription =>
      'Pins paisibles, brume du matin et feuilles dorées.';

  @override
  String get demoFirstDanceTitle => 'Notre première danse';

  @override
  String get demoFirstDanceStory =>
      'Le groupe a joué notre chanson et toute la grange s\'est tue. Je t\'ai marché deux fois sur le pied, tu as ri tout du long, et pendant trois minutes il n\'y avait personne d\'autre.';

  @override
  String get demoFirstDancePlace => 'Salzbourg';

  @override
  String get demoNewbornTitle => 'Bienvenue à la maison, Lina';

  @override
  String get demoNewbornStory =>
      'Sa main entière tenait autour d\'un seul doigt. Le premier matin calme à la maison.';

  @override
  String get demoNewbornPlace => 'Vienne';

  @override
  String get demoBeachSunsetTitle => 'L\'été au bord de la mer';

  @override
  String get demoBeachSunsetStory =>
      'Pieds nus jusqu\'au coucher du soleil, Lina endormie sur tes épaules au retour.';

  @override
  String get demoBeachSunsetPlace => 'Split, Croatie';

  @override
  String get demoGrandmaKitchenTitle => 'La cuisine de mamie';

  @override
  String get demoGrandmaKitchenStory =>
      'Son gâteau aux abricots, enfin écrit – et de la farine partout.';

  @override
  String get demoGrandmaKitchenPlace => 'Graz';

  @override
  String get demoGraduationTitle => 'Jour du diplôme';

  @override
  String get demoGraduationStory =>
      'Papa a pleuré avant même que les toques ne retombent.';

  @override
  String get demoGraduationPlace => 'Innsbruck';

  @override
  String get demoFirstHomeTitle => 'Les clés de notre premier chez-nous';

  @override
  String get demoFirstHomeStory =>
      'Pas encore de meubles, juste des cartons, une pizza par terre et plein de projets.';

  @override
  String get demoFirstHomePlace => 'Linz';

  @override
  String get demoAlpineSummitTitle => 'Au-dessus des nuages';

  @override
  String get demoAlpineSummitStory =>
      'Debout à 4 h du matin pour ça. Chaque pas en valait la peine.';

  @override
  String get demoAlpineSummitPlace => 'Grossglockner';

  @override
  String get demoFirstBikeTitle => 'Premier tour, sans les mains';

  @override
  String get demoFirstBikeStory =>
      'Trois coups de pédale, un petit vacillement, et il était parti – si fier.';

  @override
  String get demoFirstBikePlace => 'Prater, Vienne';

  @override
  String get demoGardenDinnerTitle => 'Les 80 ans de papi';

  @override
  String get demoGardenDinnerStory =>
      'Quatre générations à une longue table, et c\'est toujours lui qui racontait les meilleures histoires.';

  @override
  String get demoGardenDinnerPlace => 'Wachau';

  @override
  String get demoThreadFirstDanceToFirstHome => 'Notre histoire';

  @override
  String get demoThreadFirstHomeToNewborn => 'Puis Lina est arrivée';

  @override
  String get demoThreadNewbornToBeachSunset => 'Son premier été';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'Famille';

  @override
  String get demoThreadGraduationToFirstHome => 'Nouveau chapitre';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'Petites aventures';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'Papi regardait';

  @override
  String get demoRelationGrandpa => 'Papi';

  @override
  String get demoRelationGrandma => 'Mamie';

  @override
  String get demoRelationDaughter => 'Fille';

  @override
  String get demoRelationWife => 'Épouse';

  @override
  String get demoRelationBestMan => 'Témoin';

  @override
  String get demoRelationMother => 'Mère';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Enregistré dans $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count souvenirs ne sont pas encore sauvegardés.',
      one: '1 souvenir n\'est pas encore sauvegardé.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Plus tard';

  @override
  String get backUp => 'Sauvegarder';

  @override
  String get onThisDayTitle => 'Ce jour-là';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Il y a $years ans aujourd\'hui',
      one: 'Il y a 1 an aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'il y a $years ans',
      one: 'il y a 1 an',
    );
    return 'Ce jour-là · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'Les jours où un souvenir d\'une année passée revient, LifeThreads t\'envoie un rappel discret.';

  @override
  String get onThisDayReminderSwitch => 'Rappel quotidien';

  @override
  String onThisDayReminderAt(String time) {
    return 'À $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'Les notifications de LifeThreads sont désactivées. Autorise-les dans les réglages du téléphone.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Il y a $years ans aujourd\'hui : $title',
      one: 'Il y a 1 an aujourd\'hui : $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count autres souvenirs',
      one: '1 autre souvenir',
    );
    return '$title et $_temp0 de ce jour';
  }

  @override
  String get onThisDayChannelDescription =>
      'Un souvenir de ce jour, une année passée.';

  @override
  String get benefitOnThisDayBody =>
      'Un rappel quand un souvenir d\'une année passée revient, ouvert comme son propre chapitre.';

  @override
  String get premiumFeatureStoryImage => 'Images de story';

  @override
  String get premiumFeatureStoryVideo => 'Vidéos de story';

  @override
  String get premiumFeatureThreadOfTheYear => 'Fil de l\'année';

  @override
  String get premiumFeatureFamilyWall => 'Mur de famille';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature fait partie de Premium.';
  }

  @override
  String get yearThreadTitle => 'Fil de l\'année';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count souvenirs',
      one: '1 souvenir',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lieux',
      one: '1 lieu',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes',
      one: '1 personne',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mois',
      one: '1 mois',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'Émotion phare : $feeling';
  }

  @override
  String get yearThreadClosingLine => 'Une année, tissée.';

  @override
  String get yearThreadMyYear => 'Mon année';

  @override
  String get yearThreadWallCardTitle => 'Ton année en souvenirs';

  @override
  String yearThreadWallCardBody(String year) {
    return 'Fais de $year un court film.';
  }

  @override
  String get yearThreadDismiss => 'Pas maintenant';

  @override
  String get yearThreadSettingsBody =>
      'Fais de chaque année avec au moins 3 souvenirs un court film, dans l\'ordre et relié par le fil.';

  @override
  String get yearThreadOpen => 'Créer le film';

  @override
  String get yearThreadNoYears =>
      'Le Fil de l\'année a besoin d\'une année avec au moins 3 souvenirs. Continue à garder des moments et reviens.';

  @override
  String get yearThreadYear => 'Année';

  @override
  String get yearThreadLength => 'Durée';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'Film · $seconds s';
  }

  @override
  String get yearThreadLengthStory => 'Story · 20 s';

  @override
  String get yearThreadMusic => 'Musique';

  @override
  String get yearThreadNoMusic => 'Sans musique';

  @override
  String get yearThreadInFilm => 'Dans le film';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count sur $max';
  }

  @override
  String get yearThreadAddMemory => 'Ajouter un souvenir';

  @override
  String get yearThreadSwap => 'Échanger';

  @override
  String get yearThreadRemove => 'Retirer';

  @override
  String get yearThreadUseSuggestions => 'Utiliser les suggestions';

  @override
  String yearThreadPickTitle(String year) {
    return 'Choisis un souvenir de $year';
  }

  @override
  String get yearThreadNoOthers =>
      'Tous les souvenirs de cette année sont déjà dans le film.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count souvenirs',
      one: '1 souvenir',
    );
    return 'Choisis au moins $_temp0.';
  }

  @override
  String get yearThreadPreview => 'Aperçu';

  @override
  String get yearThreadExportVideo => 'Exporter la vidéo';

  @override
  String get yearThreadExportImage => 'Exporter l\'image';

  @override
  String get yearThreadShare => 'Partager';

  @override
  String get yearThreadSave => 'Enregistrer dans Photos';

  @override
  String get yearThreadMakingFilm => 'Création de ton film…';

  @override
  String get yearThreadMakingImage => 'Création de ton image…';

  @override
  String get yearThreadFilmReady => 'Ton film est prêt';

  @override
  String get yearThreadImageReady => 'Ton image est prête';

  @override
  String get yearThreadSaved => 'Enregistré dans tes photos.';

  @override
  String get yearThreadExportFailed => 'Ça n\'a pas marché. Réessaie.';

  @override
  String get yearThreadPlay => 'Lire';

  @override
  String get yearThreadPause => 'Pause';

  @override
  String get createStory => 'Créer une story';

  @override
  String get storyPickTitle => 'Choisis des souvenirs';

  @override
  String storyPickBody(int max) {
    return 'Choisis jusqu\'à $max souvenirs pour une story.';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$count sur $max choisis';
  }

  @override
  String storyPickLimit(int max) {
    return 'Une story contient jusqu\'à $max souvenirs.';
  }

  @override
  String get storyPickContinue => 'Continuer';

  @override
  String get storyNoMemories =>
      'Garde d\'abord un souvenir, puis fais-en une story.';

  @override
  String get storyEditorTitle => 'Ta story';

  @override
  String get storyChangeMemories => 'Changer les souvenirs';

  @override
  String get storyTemplateSingle => 'Un souvenir';

  @override
  String get storyTemplateThread => 'Mur et fil';

  @override
  String get storyTemplateCollage => 'Collage';

  @override
  String get storyTemplateQuote => 'Mots';

  @override
  String get storySwipeHint => 'Balaie pour un autre style';

  @override
  String get storyCaptionLabel => 'Légende';

  @override
  String get storyCaptionHint => 'Une ligne de ton histoire';

  @override
  String get storyVideoSwitch => 'Vidéo';

  @override
  String get storyVideoBody =>
      'Un court film pour les Stories et Reels, avec mouvement et musique.';

  @override
  String get storyMusicTitle => 'Musique';

  @override
  String get storyMusicNone => 'Sans musique';

  @override
  String get storyMusicNoneHint =>
      'Tu peux aussi ajouter de la musique dans Instagram en publiant.';

  @override
  String get storyMoodWarm => 'Tendre';

  @override
  String get storyMoodJoyful => 'Joyeux';

  @override
  String get storyMoodCalm => 'Calme';

  @override
  String get storyMoodNostalgic => 'Nostalgique';

  @override
  String get storyMoodEpic => 'Épique';

  @override
  String get storyMoodEmotional => 'Émouvant';

  @override
  String get storyMusicTrimHint =>
      'Fais glisser le cadre doré pour choisir le passage de la chanson';

  @override
  String get storySearchHint => 'Souvenirs, lieux, années';

  @override
  String storySearchEmpty(String query) {
    return 'Aucun souvenir ne correspond à « $query ».';
  }

  @override
  String get storyMemoriesInStory => 'Dans ta story';

  @override
  String get storyMemoriesReorderHint =>
      'Maintiens et glisse pour changer l\'ordre';

  @override
  String get storyAddMemory => 'Ajouter';

  @override
  String get storyAddMemoryTitle => 'Ajouter un souvenir';

  @override
  String storyRemoveMemory(String title) {
    return 'Retirer $title de la story';
  }

  @override
  String get storyAllMemoriesAdded =>
      'Tous les souvenirs sont déjà dans cette story.';

  @override
  String get storyShare => 'Partager';

  @override
  String get storySaveToPhotos => 'Enregistrer dans Photos';

  @override
  String get storySaved => 'Enregistré dans tes photos.';

  @override
  String get storySaveDenied =>
      'LifeThreads n\'a pas le droit d\'ajouter à tes photos. Autorise-le dans les réglages du téléphone.';

  @override
  String storyExportFailed(String error) {
    return 'La story n\'a pas pu être créée : $error';
  }

  @override
  String get storyRenderingTitle => 'Création de ton film';

  @override
  String get storyRenderingBody =>
      'Garde LifeThreads ouvert, ça prend quelques secondes.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent %';
  }

  @override
  String get storyPreviewFree =>
      'L\'aperçu est gratuit. Partager et enregistrer des stories fait partie de Premium.';

  @override
  String get benefitStoriesTitle => 'Créer une story';

  @override
  String get benefitStoriesBody =>
      'Fais de tes souvenirs des images de story et de courts films en musique pour Instagram, WhatsApp et plus.';

  @override
  String get musicCreditsTitle => 'Crédits musicaux';

  @override
  String get musicCreditsBody =>
      'Chansons incluses pour les vidéos de story, avec leurs licences.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'Ton année en court film : les moments qui comptent, dans l\'ordre, en musique.';

  @override
  String get benefitFamilyTitle => 'Murs de famille';

  @override
  String get benefitFamilyBody =>
      'Un mur partagé pour ta famille, chiffré de bout en bout. Chacun ajoute ses moments.';

  @override
  String get myWall => 'Mon mur';

  @override
  String get myWallSubtitle => 'Privé, sur cet appareil';

  @override
  String get switchWall => 'Changer de mur';

  @override
  String get familyWallsTitle => 'Murs de famille';

  @override
  String get familyWallsSettingsBody =>
      'Partage un mur avec ta famille ou tes amis : chacun ajoute des souvenirs, chiffrés de bout en bout. Mon mur reste privé sur cet appareil.';

  @override
  String get familyWallsOpen => 'Ouvrir les murs de famille';

  @override
  String get familyWallsManage => 'Gérer les murs de famille';

  @override
  String get familyWallsHeadline => 'Un mur, toute la famille';

  @override
  String get familyWallsIntro =>
      'Un mur de famille est partagé avec les personnes que tu invites. Les souvenirs et les photos sont chiffrés sur ton téléphone avant l\'envoi ; seuls les membres peuvent les ouvrir. Mon mur n\'est pas partagé et reste sur cet appareil.';

  @override
  String get familyUnavailableTitle => 'Pas encore disponible';

  @override
  String get familyUnavailable =>
      'Les murs de famille ne sont pas encore disponibles dans cette version de LifeThreads.';

  @override
  String get familySignInNeededTitle => 'Connecte-toi pour les murs de famille';

  @override
  String get familySignInNeededBody =>
      'Un mur partagé a besoin d\'un compte pour que la famille sache qui a ajouté quoi. Mon mur fonctionne sans.';

  @override
  String get familySignIn => 'Se connecter';

  @override
  String get familyLoadFailed => 'Chargement impossible';

  @override
  String get familyRetry => 'Réessayer';

  @override
  String get familyNoWallsYet =>
      'Pas encore de mur de famille. Crées-en un ou rejoins-en un avec un lien d\'invitation.';

  @override
  String get familyStartTitle => 'Créer ou rejoindre';

  @override
  String get familyStartBody =>
      'Créer un mur de famille demande Premium. Le rejoindre est gratuit : le Premium du créateur couvre la famille.';

  @override
  String get familyCreateAction => 'Créer un mur de famille';

  @override
  String get familyCreateTitle => 'Nouveau mur de famille';

  @override
  String get familyNameLabel => 'Nom du mur';

  @override
  String get familyNameHint => 'ex. Les Martin';

  @override
  String get familyMyNameLabel => 'Ton nom sur ce mur';

  @override
  String get familyMyNameHelper =>
      'Les membres le voient sur tes souvenirs. Il est chiffré comme tout le reste du mur.';

  @override
  String get familyMyNameSaved => 'Nom enregistré.';

  @override
  String get familySetMyName => 'Mon nom';

  @override
  String get familyCheckingSubscription => 'Vérification de ton Premium…';

  @override
  String get familyCreating => 'Création du mur…';

  @override
  String get familyJoinWithLink => 'Rejoindre avec un lien';

  @override
  String get familyInviteLinkLabel => 'Lien d\'invitation';

  @override
  String get familyJoinTitle => 'Rejoindre ce mur de famille ?';

  @override
  String get familyJoinBody =>
      'Les membres verront ton nom et les souvenirs que tu ajoutes, et tu verras les leurs. Tu peux partir à tout moment.';

  @override
  String get familyJoinAction => 'Rejoindre';

  @override
  String get familyJoining => 'Connexion au mur…';

  @override
  String familyJoined(String family) {
    return 'Tu as rejoint $family.';
  }

  @override
  String get familyRoleOwner => 'Créateur';

  @override
  String get familyRoleMember => 'Membre';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'Réglages du mur';

  @override
  String familyStorageUsed(String used, String total) {
    return '$used sur $total utilisés';
  }

  @override
  String get familyRename => 'Renommer';

  @override
  String get familyInviteTitle => 'Inviter';

  @override
  String get familyInviteBody =>
      'Envoie un lien à quelqu\'un de confiance. Chaque lien fonctionne une fois et expire après 7 jours.';

  @override
  String get familyInviteAction => 'Créer un lien d\'invitation';

  @override
  String get familyCreatingInvite => 'Création de l\'invitation…';

  @override
  String get familyInviteReady => 'Lien d\'invitation prêt';

  @override
  String get familyInviteValidity =>
      'Fonctionne une fois et expire au plus tard après 7 jours.';

  @override
  String get familyInviteKeyWarning =>
      'Le lien contient la clé du mur : qui l\'ouvre peut rejoindre et lire le mur. Envoie-le uniquement à la personne invitée.';

  @override
  String get familyInviteShare => 'Partager le lien';

  @override
  String get familyInviteCopy => 'Copier le lien';

  @override
  String get familyInviteCopied => 'Lien copié.';

  @override
  String get familyInviteShareFailed =>
      'Le partage n\'est pas disponible. Copie plutôt le lien.';

  @override
  String familyInviteSubject(String family) {
    return 'Rejoins $family sur LifeThreads';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'Rejoins notre mur de famille « $family » sur LifeThreads : $link';
  }

  @override
  String get familyMembersTitle => 'Membres';

  @override
  String get familyMemberActions => 'Actions du membre';

  @override
  String get familyYou => 'Toi';

  @override
  String familyYouNamed(String name) {
    return '$name (toi)';
  }

  @override
  String get familyAMember => 'Un membre';

  @override
  String get familyFormerMember => 'Ancien membre';

  @override
  String get familyBlocked => 'Bloqué';

  @override
  String get familyBlock => 'Bloquer';

  @override
  String get familyUnblock => 'Débloquer';

  @override
  String familyBlockAuthor(String name) {
    return 'Bloquer $name';
  }

  @override
  String familyBlockQuestion(String name) {
    return 'Bloquer $name ?';
  }

  @override
  String get familyBlockBody =>
      'Tu ne verras plus ses souvenirs sur aucun mur de famille. Cette personne n\'est pas prévenue. Tu peux la débloquer dans la liste des membres.';

  @override
  String get familyReport => 'Signaler';

  @override
  String get familyRemoveMember => 'Retirer du mur';

  @override
  String familyRemoveQuestion(String name) {
    return 'Retirer $name ?';
  }

  @override
  String get familyRemoveBody =>
      'Cette personne perd l\'accès à ce mur. Invite-la à nouveau pour la faire revenir.';

  @override
  String get familyRemoveDeleteContent =>
      'Supprimer aussi les souvenirs qu\'elle a ajoutés';

  @override
  String get familyDeleteTitle => 'Supprimer le mur de famille';

  @override
  String get familyDeleteBody =>
      'En tant que créateur, tu ne peux pas quitter le mur ; tu peux le supprimer pour tout le monde.';

  @override
  String get familyDeleteAction => 'Supprimer le mur';

  @override
  String familyDeleteQuestion(String family) {
    return 'Supprimer $family ?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'Tous les souvenirs et photos de ce mur sont supprimés de nos serveurs pour tous les membres. C\'est irréversible. Les souvenirs de Mon mur ne sont pas touchés.';

  @override
  String get familyDeleting => 'Suppression…';

  @override
  String get familyLeaveTitle => 'Quitter le mur de famille';

  @override
  String get familyLeaveBody =>
      'Tu ne verras plus ce mur. Tu peux garder ou supprimer les souvenirs que tu as ajoutés.';

  @override
  String get familyLeaveAction => 'Quitter';

  @override
  String familyLeaveQuestion(String family) {
    return 'Quitter $family ?';
  }

  @override
  String get familyLeaveConfirmBody =>
      'Pour revenir, il te faudra une nouvelle invitation.';

  @override
  String get familyLeaveDeleteMine =>
      'Supprimer aussi les souvenirs que j\'ai ajoutés';

  @override
  String get familyLeaving => 'Départ…';

  @override
  String get familySignInTitle => 'Connexion';

  @override
  String get familySignInHeadline => 'Un compte pour les murs de famille';

  @override
  String get familySignInWhy =>
      'Un mur de famille est partagé, il faut donc un compte : les membres voient qui a ajouté chaque souvenir, et seuls les membres peuvent ouvrir le mur.';

  @override
  String get familySignInMyWallStays =>
      'Mon mur n\'a pas besoin de compte. Il reste privé sur cet appareil et n\'est jamais envoyé.';

  @override
  String get familySignInEncrypted =>
      'Les souvenirs et photos de famille sont chiffrés de bout en bout. GK Coding les stocke mais ne peut pas les lire.';

  @override
  String get familySignInWhatWeGet =>
      'D\'Apple ou Google, nous utilisons seulement un identifiant de compte, ni tes contacts ni tes photos.';

  @override
  String get familySignInApple => 'Se connecter avec Apple';

  @override
  String get familySignInGoogle => 'Se connecter avec Google';

  @override
  String get familySignInFinePrint =>
      'En te connectant, tu acceptes les Conditions d\'utilisation et la Politique de confidentialité. Tu peux supprimer ton compte dans l\'app à tout moment.';

  @override
  String get familyAccountTitle => 'Compte';

  @override
  String get familySignedOutTitle => 'Non connecté';

  @override
  String get familySignedOutBody =>
      'Connecte-toi pour voir tes murs de famille. Mon mur fonctionne sans compte.';

  @override
  String get familySignedInTitle => 'Connecté';

  @override
  String get familySignedInBody =>
      'Ton compte sert uniquement aux murs de famille.';

  @override
  String familyAccountId(String id) {
    return 'Identifiant : $id';
  }

  @override
  String get familySignOut => 'Se déconnecter';

  @override
  String get familySignOutQuestion => 'Se déconnecter ?';

  @override
  String get familySignOutBody =>
      'Les murs de famille et leurs clés sont retirés de cet appareil jusqu\'à ta prochaine connexion. Rien n\'est supprimé sur le serveur. Mon mur n\'est pas touché.';

  @override
  String get familySigningOut => 'Déconnexion…';

  @override
  String get familyDeleteAccountTitle => 'Supprimer le compte';

  @override
  String get familyDeleteAccountBody =>
      'Supprime ton compte et les données de tes murs de famille de nos serveurs. Mon mur reste sur cet appareil.';

  @override
  String get familyDeleteAccount => 'Supprimer le compte';

  @override
  String get familyDeleteAccountQuestion => 'Supprimer ton compte ?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Les $count murs de famille que tu as créés sont supprimés pour tous leurs membres, avec tous leurs souvenirs et photos.',
      one:
          'Le mur de famille que tu as créé est supprimé pour tous ses membres, avec tous ses souvenirs et photos.',
      zero: 'Tu n\'as créé aucun mur de famille.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'Les souvenirs et photos que tu as ajoutés aux murs d\'autres familles sont supprimés, et tu quittes ces murs.';

  @override
  String get familyDeleteAccountKeys =>
      'Les clés des murs de famille et les photos en cache sont retirées de cet appareil. C\'est irréversible.';

  @override
  String get familyDeleteAccountMyWall =>
      'Mon mur n\'est pas touché : ses souvenirs restent sur cet appareil.';

  @override
  String get familyDeleteAccountSubscription =>
      'Cela ne résilie pas un abonnement Premium ; gère-le dans l\'App Store ou Google Play.';

  @override
  String get familyDeleteAccountUnderstood =>
      'Je comprends que cela supprime mon compte définitivement.';

  @override
  String get familyDeletingAccount => 'Suppression de ton compte…';

  @override
  String get familyAccountDeleted => 'Ton compte a été supprimé.';

  @override
  String get familyTermsTitle => 'Règles du mur de famille';

  @override
  String get familyTermsHeadline => 'Avant de partager';

  @override
  String get familyTermsIntro =>
      'Les murs de famille sont pour les personnes que tu invites. Pour qu\'ils restent sûrs, chacun accepte ces règles :';

  @override
  String get familyTermsZeroTolerance =>
      'Tolérance zéro pour les contenus choquants : pas de harcèlement, de haine, de contenu sexuel, de violence, d\'automutilation, de contenu illégal ni d\'informations privées d\'autrui sans son accord.';

  @override
  String get familyTermsOwnContent =>
      'Partage seulement des photos et histoires que tu as le droit de partager.';

  @override
  String get familyTermsReport =>
      'Signale n\'importe quel souvenir ou membre depuis le mur. GK Coding examine les signalements sous 24 heures.';

  @override
  String get familyTermsBlock =>
      'Bloque un membre pour ne plus voir ses souvenirs.';

  @override
  String get familyTermsOwner =>
      'Le créateur d\'un mur peut retirer des membres et leurs souvenirs.';

  @override
  String get familyTermsConsequences =>
      'Les contenus qui enfreignent ces règles sont supprimés, et les comptes qui les ont publiés peuvent être suspendus ou supprimés.';

  @override
  String get familyTermsReadFull => 'Lire les conditions complètes';

  @override
  String get familyTermsAgree =>
      'J\'accepte les Conditions d\'utilisation et ces règles.';

  @override
  String get familyTermsAccept => 'Accepter et continuer';

  @override
  String familyTermsVersion(String version) {
    return 'Version des conditions $version';
  }

  @override
  String get familyWallEmptyTitle => 'Le mur t\'attend';

  @override
  String get familyWallEmptyBody =>
      'Ajoute le premier souvenir. Tout le monde sur ce mur le verra.';

  @override
  String get familyWallGoneBody =>
      'Ce mur de famille n\'est plus disponible pour toi. Il a peut-être été supprimé, ou tu as été retiré.';

  @override
  String get familyAddMemory => 'Ajouter un souvenir';

  @override
  String get familyRefresh => 'Actualiser';

  @override
  String get familySyncing => 'Synchronisation…';

  @override
  String get familyOffline => 'Hors ligne : souvenirs enregistrés affichés';

  @override
  String get familySyncFailed => 'Échec de la synchro';

  @override
  String get familyMemoryTitle => 'Souvenir';

  @override
  String get familyMemoryGone => 'Ce souvenir n\'est plus sur le mur.';

  @override
  String get familyMemoryActions => 'Actions du souvenir';

  @override
  String familyAddedBy(String name) {
    return 'Ajouté par $name';
  }

  @override
  String get familyDeleteMemoryQuestion => 'Supprimer ce souvenir ?';

  @override
  String get familyDeleteMemoryBody =>
      'Il est retiré du mur pour tout le monde, avec ses photos.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'En tant que créateur, tu peux retirer des souvenirs de ce mur. Ce souvenir de $name est retiré pour tout le monde, avec ses photos.';
  }

  @override
  String get familyDeletingMemory => 'Suppression du souvenir…';

  @override
  String get familyNoPhotosYet => 'Pas encore de photos';

  @override
  String get familyPostNote =>
      'Tout le monde sur ce mur verra ce souvenir. Les photos sont réduites et chiffrées sur ton téléphone avant l\'envoi.';

  @override
  String get familyPost => 'Publier';

  @override
  String get familyPostMemory => 'Publier sur le mur';

  @override
  String get familyUploading => 'Chiffrement et envoi…';

  @override
  String get familyMemorySaved => 'Enregistré sur le mur de famille.';

  @override
  String get familyConflictTitle => 'Modifié par quelqu\'un d\'autre';

  @override
  String get familyConflictBody =>
      'Ce souvenir a changé sur un autre appareil pendant que tu le modifiais. Charger la dernière version et enregistrer tes modifications par-dessus ?';

  @override
  String get familyConflictRetry => 'Actualiser et enregistrer';

  @override
  String get familyQuotaTitle => 'Le mur est plein';

  @override
  String get familyReportMemoryTitle => 'Signaler le souvenir';

  @override
  String get familyReportPhotoTitle => 'Signaler la photo';

  @override
  String get familyReportMemberTitle => 'Signaler le membre';

  @override
  String get familyReportIntro =>
      'Dis-nous ce qui ne va pas. Ton signalement va à GK Coding, pas à la personne signalée.';

  @override
  String get familyReportSpam => 'Spam ou arnaque';

  @override
  String get familyReportHarassment => 'Harcèlement ou intimidation';

  @override
  String get familyReportHate => 'Discours haineux';

  @override
  String get familyReportSexual => 'Contenu sexuel ou nudité';

  @override
  String get familyReportViolence => 'Violence ou menaces';

  @override
  String get familyReportSelfHarm => 'Automutilation ou suicide';

  @override
  String get familyReportIllegal => 'Contenu illégal';

  @override
  String get familyReportPrivacy => 'Infos privées partagées sans accord';

  @override
  String get familyReportOther => 'Autre chose';

  @override
  String get familyReportDetailsLabel => 'Détails (facultatif)';

  @override
  String get familyReportDetailsHint => 'Que devons-nous savoir ?';

  @override
  String familyReportAlsoBlock(String name) {
    return 'Bloquer aussi $name';
  }

  @override
  String get familyReportSend => 'Envoyer le signalement';

  @override
  String get familyReportReviewNote =>
      'GK Coding examine chaque signalement sous 24 heures et supprime les contenus et membres qui enfreignent les règles.';

  @override
  String get familyReportSentTitle => 'Merci';

  @override
  String get familyReportSentBody =>
      'Ton signalement a été envoyé. GK Coding l\'examine sous 24 heures et agit contre les contenus qui enfreignent les règles.';

  @override
  String get familyErrorGeneric => 'Un problème est survenu. Réessaie.';

  @override
  String get familyErrorOffline =>
      'Tu sembles hors ligne. Vérifie ta connexion et réessaie.';

  @override
  String get familyErrorSubscriptionRequired =>
      'Il faut un abonnement Premium actif du créateur du mur.';

  @override
  String get familyErrorInviteExpired =>
      'Cette invitation a expiré. Demande un nouveau lien.';

  @override
  String get familyErrorInviteUsed =>
      'Cette invitation a déjà été utilisée. Chaque lien ne fonctionne qu\'une fois ; demandes-en un nouveau.';

  @override
  String get familyErrorInviteInvalid =>
      'Ce n\'est pas un lien d\'invitation LifeThreads valide.';

  @override
  String get familyErrorAlreadyMember =>
      'Tu es déjà membre de ce mur de famille.';

  @override
  String get familyErrorFamilyFull =>
      'Ce mur de famille a atteint sa limite de membres.';

  @override
  String get familyErrorQuotaExceeded =>
      'Ce mur de famille n\'a plus d\'espace. Supprime des souvenirs ou des photos pour faire de la place.';

  @override
  String get familyErrorVersionConflict =>
      'Quelqu\'un a modifié ce souvenir avant toi. Actualise et réessaie.';

  @override
  String get familyErrorTermsRequired =>
      'Accepte d\'abord les règles du mur de famille.';

  @override
  String get familyErrorSignedOut => 'Tu as été déconnecté. Reconnecte-toi.';

  @override
  String get familyErrorNotAllowed =>
      'Tu n\'as pas le droit de faire ça sur ce mur.';

  @override
  String get familyErrorNotFound => 'Mur de famille introuvable';

  @override
  String get familyErrorOwnerCannotLeave =>
      'Le créateur ne peut pas quitter le mur, mais il peut le supprimer.';

  @override
  String get familyPaste => 'Coller';

  @override
  String get familyErrorInviteRevoked =>
      'Cette invitation a été retirée. Demande un nouveau lien.';

  @override
  String get familyErrorKeyMissing =>
      'Cet appareil n\'a pas la clé de ce mur de famille (par exemple après une réinstallation ou sur un nouveau téléphone). Demande un nouveau lien d\'invitation à un membre : l\'ouvrir rétablit l\'accès.';

  @override
  String get familyErrorSignInUnavailable =>
      'La connexion n\'est pas disponible sur cet appareil pour le moment.';

  @override
  String get familyErrorNoPurchase =>
      'Aucun achat Premium trouvé pour ce compte App Store ou Google Play. Prends d\'abord Premium, puis réessaie.';

  @override
  String get familyErrorVerificationUnavailable =>
      'Ton Premium n\'a pas pu être vérifié pour le moment. Réessaie plus tard.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'Cet achat Premium est déjà lié à un autre compte de mur de famille. Connecte-toi avec ce compte ou écris à info@gkcoding.dev.';

  @override
  String get familyErrorNameTooLong =>
      'Ce nom est trop long. Choisis-en un plus court.';

  @override
  String get familyErrorContentNotAllowed =>
      'Ce texte contient des mots interdits sur les murs de famille. Modifie-le et réessaie.';

  @override
  String get familyErrorPhotoUnreadable =>
      'Une des photos n\'a pas pu être lue. Retire-la et réessaie.';

  @override
  String get familyErrorTooLarge =>
      'C\'est trop lourd à envoyer. Essaie avec moins de photos ou des photos plus petites.';

  @override
  String get familyReportEvidenceNote =>
      'Pour l\'examiner, GK Coding reçoit le titre et l\'histoire de ce souvenir avec ton signalement. Ses photos ne sont jamais envoyées.';

  @override
  String get moveLeft => 'Déplacer à gauche';

  @override
  String get moveUp => 'Déplacer vers le haut';

  @override
  String get moveDown => 'Déplacer vers le bas';

  @override
  String get moveRight => 'Déplacer à droite';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get removePerson => 'Retirer la personne';

  @override
  String get draftKept => 'Gardé en brouillon – il sera là la prochaine fois.';

  @override
  String get draftResumeTitle => 'Reprendre là où tu t\'es arrêté ?';

  @override
  String draftResumeBody(String date) {
    return 'Tu as commencé un souvenir le $date sans l\'enregistrer.';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => 'Reprendre le brouillon';

  @override
  String get draftStartNew => 'Recommencer';

  @override
  String get lookBackMenu => 'Revoir un mois';

  @override
  String lookBackTitle(String month) {
    return 'Ton mois de $month';
  }

  @override
  String get lookBackWallCardTitle => 'Ton mois en souvenirs';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count souvenirs',
      one: '1 souvenir',
    );
    return '$month : $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count souvenirs',
      one: '1 souvenir',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personnes',
      one: '1 personne',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lieux',
      one: '1 lieu',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => 'Qui était là';

  @override
  String get lookBackPlacesHeading => 'Où tu étais';

  @override
  String lookBackEmpty(String month) {
    return 'Rien d\'enregistré pour $month.';
  }

  @override
  String get lookBackEmptyHint =>
      'Les souvenirs datés de ce mois apparaissent ici.';

  @override
  String get lookBackPreviousMonth => 'Mois précédent';

  @override
  String get lookBackNextMonth => 'Mois suivant';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count souvenirs',
      one: '1 souvenir',
    );
    return '$month : $_temp0 à revoir.';
  }

  @override
  String get lookBackNotificationPrivate => 'Ton mois en souvenirs est prêt.';

  @override
  String get homeWidgetLocked => 'Ouvre LifeThreads pour voir tes souvenirs.';

  @override
  String get homeWidgetSettingsTitle => 'Widget d\'accueil';

  @override
  String get homeWidgetSettingsSubtitle => 'Quels souvenirs il affiche';

  @override
  String get homeWidgetPreviewTitle => 'Aujourd\'hui sur ton widget';

  @override
  String get homeWidgetSourceTitle => 'Quels souvenirs';

  @override
  String get homeWidgetAllWalls => 'Tous mes murs';

  @override
  String get homeWidgetOrderTitle => 'Affichés en premier';

  @override
  String get homeWidgetOnThisDayFirst => 'Ce jour-là d\'abord';

  @override
  String get homeWidgetOnThisDayFirstBody =>
      'Un souvenir de ce jour, une année passée, passe en premier.';

  @override
  String get homeWidgetPhotosFirst => 'Souvenirs avec photos d\'abord';

  @override
  String get homeWidgetPhotosFirstBody =>
      'Les autres seulement si aucun n\'a de photo.';

  @override
  String get homeWidgetHowToTitle => 'Ajoute-le à ton écran d\'accueil';

  @override
  String get homeWidgetHowToIos =>
      'Maintiens l\'icône LifeThreads sur ton écran d\'accueil et choisis une taille de widget. Ou maintiens un espace vide, touche Modifier › Ajouter un widget et choisis LifeThreads.';

  @override
  String get homeWidgetHowToAndroid =>
      'Maintiens un espace vide de ton écran d\'accueil, touche Widgets et fais glisser LifeThreads où tu veux.';

  @override
  String get homeWidgetPrivacyNote =>
      'Les souvenirs masqués n\'apparaissent jamais sur le widget. Avec le verrouillage activé, il n\'affiche aucun souvenir.';

  @override
  String get yearThreadAlmostThere => 'Presque';

  @override
  String get yearThreadMemoriesFrom => 'Souvenirs de';

  @override
  String yearThreadAddMemoryTo(String year) {
    return 'Ajoute un souvenir à $year';
  }

  @override
  String get onboardingHangTitle => 'Accroche tes souvenirs';

  @override
  String get onboardingHangText =>
      'Une photo, un lieu, les personnes présentes – ton mur grandit avec ta vie.';

  @override
  String get onboardingConnectTitle => 'Relie-les par des fils';

  @override
  String get onboardingConnectText =>
      'Dis pourquoi deux moments vont ensemble. Les fils montrent comment ton histoire s\'assemble.';

  @override
  String get onboardingComeBackTitle => 'Tes souvenirs te reviennent';

  @override
  String get onboardingComeBackText =>
      'Ce jour-là, ton mois en rétrospective, ton année en film – et un widget sur ton écran d\'accueil.';

  @override
  String get onboardingPrivateText =>
      'Pas de compte. Tout reste sur ton téléphone – avec Face ID si tu veux.';

  @override
  String get onboardingNameStaysHere =>
      'Juste pour te saluer – il reste sur ce téléphone.';

  @override
  String get tutorialLookBackTitle => 'Chercher et revoir';

  @override
  String get tutorialLookBackText =>
      'Cherche par titre, lieu, personne ou année. Plus › Revoir un mois montre les souvenirs d\'un mois ; Plus › Fil de l\'année fait d\'une année un film.';

  @override
  String get tutorialStoryTitle => 'Crée une story';

  @override
  String get tutorialStoryText =>
      'Plus › Créer une story : choisis des souvenirs, un modèle et une musique, puis partage-la en image ou en vidéo.';

  @override
  String get tutorialWallsTitle => 'Murs et souvenirs masqués';

  @override
  String get tutorialWallsText =>
      'Plus › Nouveau mur sépare voyages ou chapitres (Premium). Maintiens une carte › Masquer pour la cacher ; Affichage › Souvenirs masqués la montre après Face ID.';

  @override
  String get tutorialFamilyTitle => 'Partage avec ta famille';

  @override
  String get tutorialFamilyText =>
      'Plus › Murs de famille : un mur pour toute la famille, chiffré de bout en bout. Invite d\'autres personnes avec un lien.';

  @override
  String get tutorialWidgetTitle => 'Un souvenir sur ton écran d\'accueil';

  @override
  String get tutorialWidgetText =>
      'Ajoute le widget LifeThreads : un souvenir différent chaque jour. Réglages › Widget d\'accueil choisit lesquels.';

  @override
  String photoNumber(int number) {
    return 'Photo $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'Ton nom sur ce mur n\'a pas pu être enregistré. Tu peux le définir dans les réglages du mur.';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Elle contient $count souvenirs.',
      one: 'Elle contient 1 souvenir.',
    );
    return '$_temp0 Les souvenirs déjà sur tes murs sont gardés et pas ajoutés deux fois.';
  }

  @override
  String get importAction => 'Importer';

  @override
  String get familyRemovingMember => 'Retrait et sécurisation du mur…';

  @override
  String get tourSkip => 'Passer';

  @override
  String get tourNext => 'Suivant';

  @override
  String get tourDone => 'OK';

  @override
  String get tourTapIt => 'Touche ici';

  @override
  String get tourEnd => 'Terminer la visite';

  @override
  String get tourShowMeHow => 'Montre-moi';

  @override
  String get tourShowMeHowSubtitle =>
      'Une courte visite avec des souvenirs d\'exemple';

  @override
  String get tourWelcomeTitle => 'Bienvenue sur ton mur';

  @override
  String get tourWelcomeBody =>
      'Découvrons LifeThreads ensemble avec des souvenirs et des photos d\'exemple. Suis l\'anneau doré. À la fin, tu décides si tu les gardes.';

  @override
  String get tourCardTitle => 'Chaque carte est un souvenir';

  @override
  String get tourCardBody =>
      'Des photos, une histoire, le lieu et l\'émotion. Fais glisser les cartes pour les organiser, pince pour zoomer. Touche celle-ci pour l\'ouvrir.';

  @override
  String get tourConnectTitle => 'Relie des souvenirs';

  @override
  String get tourConnectBody =>
      'Les fils relient les moments : un voyage à une personne, un lieu à une émotion. Touche Relier.';

  @override
  String get tourConnectionsTitle => 'Choisis ce qui va ensemble';

  @override
  String get tourConnectionsBody =>
      'Choisis d\'autres souvenirs et écris pourquoi ils vont ensemble. Le fil se tend alors entre les cartes de ton mur.';

  @override
  String get tourAddTitle => 'Garde un nouveau moment';

  @override
  String get tourAddBody => 'Touche + pour ajouter quelque chose à ton mur.';

  @override
  String get tourAddMemoryTitle => 'Un souvenir';

  @override
  String get tourAddMemoryBody =>
      'Choisis Souvenir. Tu peux aussi épingler une note ou un clou pour regrouper des cartes.';

  @override
  String get tourAddTextTitle => 'Quelques mots suffisent';

  @override
  String get tourAddTextBody =>
      'On a ajouté une photo d\'exemple et un titre pour toi. D\'habitude, tu choisis tes photos ou tu en prends une. La date et le lieu viennent de la photo.';

  @override
  String get tourSaveTitle => 'Accroche-le au mur';

  @override
  String get tourSaveBody =>
      'Touche Enregistrer. Émotions, personnes et fils peuvent venir plus tard.';

  @override
  String get tourCameraTitle => 'Photo rapide';

  @override
  String get tourCameraBody =>
      'L\'appareil photo garde un moment tout de suite. Tu ajoutes les mots plus tard.';

  @override
  String get tourViewTitle => 'Différentes vues';

  @override
  String get tourViewBody => 'Touche Affichage.';

  @override
  String get tourViewModesTitle => 'Mur, chronologie, carte';

  @override
  String get tourViewModesBody =>
      'Vois ta vie en mur, en chronologie ou sur une carte. Filtre par catégorie ici et affiche les souvenirs masqués (avec Face ID).';

  @override
  String get tourViewDoneTitle => 'Retour au mur';

  @override
  String get tourViewDoneBody => 'Touche OK.';

  @override
  String get tourSearchTitle => 'Retrouve n\'importe quel souvenir';

  @override
  String get tourSearchBody =>
      'Tape ici un nom, un lieu, une personne ou une année. Les résultats s\'affichent pendant la saisie.';

  @override
  String get tourMoreTitle => 'Tout le reste';

  @override
  String get tourMoreBody =>
      'Stories, ton année, rétrospective, autres murs et réglages sont dans ce menu. Touche-le.';

  @override
  String get tourStoryTitle => 'Crée une story';

  @override
  String get tourStoryBody => 'Touche Créer une story.';

  @override
  String get tourYearTitle => 'Fil de l\'année';

  @override
  String get tourYearBody =>
      'Ton année en court film avec musique : tes souvenirs dans l\'ordre, puis les lieux, personnes et émotions de l\'année (Premium).';

  @override
  String get tourLookBackTitle => 'Revoir un mois';

  @override
  String get tourLookBackBody =>
      'Chaque mois en souvenirs, avec ses personnes et ses lieux. Ce jour-là te rappelle les années passées (Premium).';

  @override
  String get tourWallsTitle => 'Plus de murs';

  @override
  String get tourWallsBody =>
      'Un mur par enfant, voyage ou projet (Premium). Touche le nom en haut pour changer de mur.';

  @override
  String get tourFamilyTitle => 'Murs de famille';

  @override
  String get tourFamilyBody =>
      'Un mur partagé où chacun ajoute ses moments, chiffré de bout en bout. Seul le créateur a besoin de Premium ; la famille rejoint gratuitement.';

  @override
  String get tourSettingsTitle => 'Réglages';

  @override
  String get tourSettingsBody =>
      'Sauvegarde tout gratuitement, verrouille l\'app avec Face ID, configure le widget et Ce jour-là, et choisis ta langue.';

  @override
  String get tourFinishTitle => 'C\'est tout !';

  @override
  String get tourFinishBody =>
      'Tu connais le chemin. À toi de faire de ce mur le tien.';

  @override
  String get tourDemoPhotoTitle => 'Une journée au lac';

  @override
  String get tourRemoveDemoTitle => 'Commencer ton propre mur ?';

  @override
  String get tourRemoveDemoBody =>
      'La visite utilisait des souvenirs et photos d\'exemple. Les retirer maintenant et commencer avec tes propres photos ?';

  @override
  String get tourRemoveDemoRemove => 'Retirer et commencer';

  @override
  String get tourRemoveDemoKeep => 'Les garder pour l\'instant';

  @override
  String get tourRemovedToast =>
      'Souvenirs d\'exemple retirés. Ton mur est prêt.';

  @override
  String get storyTemplatePolaroid => 'Polaroid';

  @override
  String get storyTemplateAlbum => 'Album';

  @override
  String get storyTemplateFilmstrip => 'Pellicule';

  @override
  String get storyTemplateTimeline => 'Voyage dans le temps';

  @override
  String get storyTemplatePostcard => 'Carte postale';

  @override
  String get storyTemplateCinema => 'Cinéma';

  @override
  String get storyTemplateSingleHint =>
      'Chaque souvenir en plein écran, l\'un après l\'autre';

  @override
  String get storyTemplateThreadHint => 'Des cartes au mur, reliées par le fil';

  @override
  String get storyTemplateCollageHint => 'Toutes les photos ensemble en grille';

  @override
  String get storyTemplateQuoteHint => 'Tes mots s\'écrivent tout seuls';

  @override
  String get storyTemplatePolaroidHint =>
      'Des photos instantanées tombent en pile';

  @override
  String get storyTemplateAlbumHint => 'Les pages tournent, une photo par page';

  @override
  String get storyTemplateFilmstripHint => 'Une pellicule défile et zoome';

  @override
  String get storyTemplateTimelineHint =>
      'Les années défilent jusqu\'à chaque souvenir';

  @override
  String get storyTemplatePostcardHint =>
      'Chaque carte se retourne sur son histoire';

  @override
  String get storyTemplateCinemaHint =>
      'Cartons-titres, zoom lent et générique';

  @override
  String get storyAnimationTitle => 'Animation';

  @override
  String get storyAnimationPageTitle => 'Choisis une animation';

  @override
  String get storyAnimationExamples =>
      'Avec des photos d\'exemple. Ta story utilise tes souvenirs.';

  @override
  String get storyMusicPageTitle => 'Musique et durée';

  @override
  String get storyLengthTitle => 'Durée';

  @override
  String get storyLengthAuto => 'Auto';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds s';
  }

  @override
  String get storyMusicAll => 'Toutes';

  @override
  String get storyMusicPlay => 'Lire';

  @override
  String get storyMusicPause => 'Pause';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return 'Chanson $song ▸ Vidéo $video';
  }

  @override
  String get storyMusicSyncHint =>
      'La ligne blanche montre quelle seconde de la chanson joue avec la vidéo. Les repères indiquent où commence chaque souvenir.';

  @override
  String get storyMusicLengthHint =>
      'Auto s\'adapte au nombre de souvenirs. Les films plus longs bougent plus lentement.';

  @override
  String get tourBack => 'Retour';

  @override
  String get tourStoryPickTitle => 'Choisis des souvenirs';

  @override
  String get tourStoryPickBody =>
      'On en a choisi trois pour toi. Tu peux en choisir jusqu\'à six. Touche Continuer.';

  @override
  String get tourStoryAnimationTitle => 'Choisis le mouvement';

  @override
  String get tourStoryAnimationBody =>
      'Des animations, de Polaroid à Cinéma. Touche Animation.';

  @override
  String get tourStoryStyleTitle => 'Essaie Polaroid';

  @override
  String get tourStoryStyleBody =>
      'Chaque vignette joue un aperçu. Touche Polaroid.';

  @override
  String get tourStoryMusicTitle => 'Ajoute de la musique';

  @override
  String get tourStoryMusicBody =>
      'Choisis une chanson et la durée de la vidéo. Touche Musique.';

  @override
  String get tourStoryTrimTitle => 'Chanson et vidéo synchronisées';

  @override
  String get tourStoryTrimBody =>
      'Fais glisser le cadre doré pour choisir le passage de la chanson. La ligne blanche avance avec la vidéo, tu vois donc quelle seconde joue à quel moment.';

  @override
  String get tourStoryMusicDoneTitle => 'Retour à ta story';

  @override
  String get tourStoryMusicDoneBody => 'Touche OK.';

  @override
  String get tourStoryShareTitle => 'Partager ou enregistrer';

  @override
  String get tourStoryShareBody =>
      'Prête pour Instagram, WhatsApp et plus. Enregistrer et partager font partie de Premium.';

  @override
  String get tourMoreAgainTitle => 'Encore plus dans le menu';

  @override
  String get tourMoreAgainBody => 'Ouvre le menu encore une fois. Touche-le.';

  @override
  String get scannerStep1 =>
      'Sur une télé, un ordinateur ou une tablette, ouvre le navigateur web.';

  @override
  String scannerStep2(Object url) {
    return 'Va sur $url. Un code QR s\'y affiche.';
  }

  @override
  String get scannerStep3 =>
      'Tiens ce téléphone pour que le code soit dans le cadre doré. Ton mur s\'y affiche ensuite un moment, en lecture seule.';

  @override
  String get scannerShareLink => 'Envoyer le lien';

  @override
  String get scannerCopyLink => 'Copier le lien';

  @override
  String get scannerLinkCopied => 'Lien copié';

  @override
  String get storyTemplateScrapbook => 'Scrapbook';

  @override
  String get storyTemplateMosaic => 'Mosaïque';

  @override
  String get storyTemplateContactSheet => 'Planche contact';

  @override
  String get storyTemplateWallFlight => 'Vol sur le mur';

  @override
  String get storyTemplateCarousel => 'Carrousel';

  @override
  String get storyTemplateJourney => 'Itinéraire';

  @override
  String get storyTemplateScrapbookHint => 'Chaque photo scotchée sur une page';

  @override
  String get storyTemplateMosaicHint => 'Une grande photo, les autres autour';

  @override
  String get storyTemplateContactSheetHint =>
      'Chaque souvenir, une image de pellicule';

  @override
  String get storyTemplateWallFlightHint =>
      'Vole le long du fil de carte en carte';

  @override
  String get storyTemplateCarouselHint =>
      'Les cartes tournent, une à la fois devant';

  @override
  String get storyTemplateJourneyHint =>
      'Un trajet sur la carte, une épingle à chaque lieu';

  @override
  String get storyModePicture => 'Image';

  @override
  String get storyModeVideo => 'Vidéo';

  @override
  String get storyModePictureHint =>
      'Une image avec tous tes souvenirs, pour posts et stories.';

  @override
  String get storyModeVideoHint => 'Un court film avec mouvement et musique.';

  @override
  String get storyLayoutTitle => 'Mise en page';

  @override
  String get storyLayoutPageTitle => 'Choisis une mise en page';

  @override
  String get storyChoosePhoto => 'Choisis la photo pour la story';

  @override
  String get wallTidyUp => 'Ranger le mur';

  @override
  String get wallTidyUpBody =>
      'Accrocher toutes les cartes bien alignées, du souvenir le plus ancien au plus récent ? Les notes et les clous restent où ils sont.';

  @override
  String get wallTidyUpAction => 'Ranger';

  @override
  String get wallTidiedToast => 'Ton mur est rangé.';

  @override
  String get storyFormatTitle => 'Format';

  @override
  String get storyFormatStory => 'Story 9:16';

  @override
  String get storyFormatPost => 'Publication 4:5';

  @override
  String get storyFormatSquare => 'Carré 1:1';
}
