// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get send => 'Send';

  @override
  String get preparing => 'Preparing...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageBody =>
      'Choose the app language. System follows your phone language when LifeThreads supports it.';

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
    return 'Language changed to $language.';
  }

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyBody =>
      'LifeThreads is local-first: no account and no public profile. Your memories stay on this device unless you export a backup, share an encrypted capsule, or display your wall on another screen.';

  @override
  String get viewPrivacyPolicy => 'View privacy policy';

  @override
  String get termsTitle => 'Terms of use';

  @override
  String get viewTerms => 'View terms';

  @override
  String get betaFeedbackTitle => 'Beta feedback';

  @override
  String get betaFeedbackBody =>
      'Send beta feedback with safe diagnostics. Logs include app events and crash types only, never memory text, photo paths, backups, or exact locations.';

  @override
  String get closedBetaBadge => 'Closed beta';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get backupArchiveBody =>
      'Save everything – memories, photos, notes, threads and layout – in one file. Keep it on your computer or in your own cloud, and add a password to encrypt it.';

  @override
  String get backupArchiveTitle => 'Backup';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Unlock';

  @override
  String get exportArchive => 'Export Archive';

  @override
  String get importArchive => 'Import Archive';

  @override
  String get importCapsule => 'Import Capsule';

  @override
  String get moveDevices => 'Move Devices';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeBody =>
      'Choose how your private wall should feel. Free users get Warm Memory Room. Premium unlocks every wall mood.';

  @override
  String get oneFreeBadge => '1 free';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'Premium subscription is active.';

  @override
  String get premiumLockedBody =>
      'Monthly subscription: unlimited memories, premium themes and advanced layouts.';

  @override
  String get activeBadge => 'Active';

  @override
  String get openPremium => 'Open Premium';

  @override
  String get appVersionTitle => 'App version';

  @override
  String get clearAllDataTitle => 'Clear all data';

  @override
  String get clearAllDataBody =>
      'Delete all memories, connections, wall notes, nails, and copied photos from this device.';

  @override
  String get clearData => 'Clear Data';

  @override
  String exportFailed(Object error) {
    return 'Export failed: $error';
  }

  @override
  String importRejected(Object message) {
    return 'Import rejected: $message';
  }

  @override
  String importFailed(Object error) {
    return 'Import failed: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'Delete failed: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'Capsule rejected: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'Capsule import failed: $error';
  }

  @override
  String get clearAllDataQuestion => 'Clear all data?';

  @override
  String get clearAllDataQuestionBody =>
      'This permanently removes all local LifeThreads data on this device. Export a backup first if you want to keep it.';

  @override
  String get clearAll => 'Clear All';

  @override
  String get allLocalDataCleared => 'All local data cleared.';

  @override
  String get feedbackGeneral => 'General feedback';

  @override
  String get feedbackBug => 'Bug';

  @override
  String get feedbackCrash => 'Crash';

  @override
  String get feedbackDesign => 'Design issue';

  @override
  String get feedbackMissingFeature => 'Missing feature';

  @override
  String get feedbackPerformance => 'Performance';

  @override
  String get betaFeedbackIntro =>
      'Write what happened or what felt wrong. Safe diagnostics will be attached without private memory content.';

  @override
  String get feedbackType => 'Type';

  @override
  String get feedbackLabel => 'Feedback';

  @override
  String get feedbackHint =>
      'Example: I tapped Add > Quick photo and the screen froze.';

  @override
  String get betaFeedbackNotIncluded =>
      'Not included: memory titles, stories, notes, photo paths, backup paths, exact locations.';

  @override
  String get feedbackEmpty => 'Write a short feedback message first.';

  @override
  String get feedbackCopied =>
      'No email app opened. Feedback copied to clipboard for info@gkcoding.dev.';

  @override
  String themeSelected(Object theme) {
    return '$theme selected.';
  }

  @override
  String get onboardingHeadline => 'Build your living wall.';

  @override
  String get onboardingBody =>
      'A private memory room where photos, places, people, and little notes can hang together with emotional threads.';

  @override
  String get onboardingPrivacy =>
      'Your memories stay private by default: no account and no public profile. Optional encrypted cloud share and backup only happen when you choose them.';

  @override
  String get onboardingPrivacyShort =>
      'No account and no public profile. Your memories stay on this device unless you choose otherwise.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingNameTitle => 'What should we call you?';

  @override
  String get onboardingNameHint => 'Your name';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'Nice to meet you, $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'Choose how to begin';

  @override
  String get onboardingGetStartedBody =>
      'Preview a sample wall, or start with a blank one and hang your own memories.';

  @override
  String wallWelcome(String name) {
    return 'Welcome, $name.';
  }

  @override
  String get settingsNameTitle => 'Your name';

  @override
  String get settingsNameBody => 'Shown as a greeting on your wall.';

  @override
  String get settingsNameHint => 'Your name';

  @override
  String get settingsNameSaved => 'Name updated.';

  @override
  String get storyPrivacyTitle => 'Your memories stay private';

  @override
  String get storyConnectTitle => 'Connect moments';

  @override
  String get storyConnectText =>
      'Link memories, notes, and places so every chapter has context.';

  @override
  String get storyWallTitle => 'Build your living wall';

  @override
  String get storyWallText =>
      'Start with one photo, then let the wall grow into something that feels alive.';

  @override
  String get previewDemoWall => 'Preview demo wall';

  @override
  String get startFresh => 'Start fresh';

  @override
  String get optionalDemoPreview => 'Optional demo preview';

  @override
  String get quickTutorial => 'Quick tutorial';

  @override
  String get tutorialIntro =>
      'The basic flow: save memories, connect the related ones, then arrange the wall.';

  @override
  String get gotIt => 'Got it';

  @override
  String get howItWorks => 'How it works';

  @override
  String get tutorialAddTitle => 'Add a memory';

  @override
  String get tutorialAddText =>
      'Tap Add, choose Memory or Quick photo, then save the title, date, people, and photo.';

  @override
  String get tutorialConnectTitle => 'Connect memories';

  @override
  String get tutorialConnectText =>
      'Open a card, tap the connect icon, select related memories, and add a short reason.';

  @override
  String get tutorialArrangeTitle => 'Arrange the wall';

  @override
  String get tutorialArrangeText =>
      'Drag cards, notes, and nails into place. Real connections draw ropes behind the items.';

  @override
  String get tutorialShowBoardTitle => 'Show the board';

  @override
  String get tutorialShowBoardText =>
      'Open lifethreads.gkcoding.dev/display on another screen, tap the QR button in Wall Controls, and scan the code to show a temporary read-only board.';

  @override
  String get tutorialBackupTitle => 'Keep a backup';

  @override
  String get tutorialBackupText =>
      'Before you change phones, export a backup in Settings and keep the file somewhere safe.';

  @override
  String get scanDisplayQr => 'Scan display QR';

  @override
  String get scannerHintTitle =>
      'Open lifethreads.gkcoding.dev/display on another screen.';

  @override
  String get scannerHintBody =>
      'Scan the QR code from that page. LifeThreads sends a temporary read-only board snapshot to that browser session.';

  @override
  String get addMemoryBeforeDisplay => 'Add a memory before displaying a wall.';

  @override
  String get notLifeThreadsDisplayQr => 'This is not a LifeThreads display QR.';

  @override
  String get displayWallQuestion => 'Display this wall?';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads will send a temporary read-only board snapshot with $memoryCount memories to the browser session you scanned. It opens on lifethreads.gkcoding.dev/display and expires automatically.';
  }

  @override
  String get displayAction => 'Display';

  @override
  String get soon => 'soon';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'Wall display is live with $memoryCount memories until $expires.';
  }

  @override
  String get preparingWallDisplay => 'Preparing wall display...';

  @override
  String get open => 'Open';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get back => 'Back';

  @override
  String get continueAction => 'Continue';

  @override
  String get close => 'Close';

  @override
  String get add => 'Add';

  @override
  String get saveReason => 'Save Reason';

  @override
  String get chooseBackup => 'Choose Backup';

  @override
  String get chooseArchive => 'Choose Archive';

  @override
  String get chooseCapsule => 'Choose Capsule';

  @override
  String get exportAction => 'Export';

  @override
  String get addToWall => 'Add to Wall';

  @override
  String get cinemaSkip => 'Skip';

  @override
  String get cinemaNotNow => 'Not now';

  @override
  String get cinemaSharedChapter => 'A shared memory chapter';

  @override
  String get cinemaConnectedThread => 'Connected thread';

  @override
  String get cinemaInviteTitle => 'Add this memory to your wall?';

  @override
  String get useSelected => 'Use selected';

  @override
  String get noPhotosFound => 'No photos found.';

  @override
  String get manage => 'Manage';

  @override
  String get manageAccess => 'Manage access';

  @override
  String get saveNow => 'Save now';

  @override
  String get hangOnWall => 'Hang on wall';

  @override
  String get placeHere => 'Place here';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get viewPremium => 'View Premium';

  @override
  String get memoryNotFound => 'Memory not found';

  @override
  String get memoryTypeMoment => 'Moment';

  @override
  String get memoryTypeTrip => 'Trip';

  @override
  String get memoryTypePerson => 'Person';

  @override
  String get memoryTypePlace => 'Place';

  @override
  String get memoryTypeNote => 'Note';

  @override
  String get memoryTypeMomentDescription => 'A small scene worth keeping';

  @override
  String get memoryTypeTripDescription => 'A journey or day away';

  @override
  String get memoryTypePersonDescription => 'Someone important';

  @override
  String get memoryTypePlaceDescription => 'A location that carries meaning';

  @override
  String get memoryTypeNoteDescription => 'A thought, quote, or reminder';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryFamily => 'Family';

  @override
  String get categoryTravel => 'Travel';

  @override
  String get feelingWarm => 'Warm';

  @override
  String get feelingNostalgic => 'Nostalgic';

  @override
  String get feelingProud => 'Proud';

  @override
  String get feelingCalm => 'Calm';

  @override
  String get feelingImportant => 'Important';

  @override
  String get feelingWarmDescription => 'Soft, close, full of love.';

  @override
  String get feelingNostalgicDescription => 'A memory that pulls you back.';

  @override
  String get feelingProudDescription => 'A moment that proved something.';

  @override
  String get feelingCalmDescription => 'Quiet, safe, peaceful.';

  @override
  String get feelingImportantDescription => 'A memory that changed the story.';

  @override
  String get addPeopleHint =>
      'Add people who belong to this moment. Contacts stay local.';

  @override
  String get addPerson => 'Add person';

  @override
  String get editPerson => 'Edit person';

  @override
  String get chooseFromContacts => 'Choose from contacts';

  @override
  String get personNameLabel => 'Name';

  @override
  String get personNameHint => 'Type to search saved people';

  @override
  String get relationshipLabel => 'Relationship';

  @override
  String get relationshipHint => 'Friend, mother, partner...';

  @override
  String get phoneOptionalLabel => 'Phone (optional)';

  @override
  String get emailOptionalLabel => 'Email (optional)';

  @override
  String get nameRelationshipRequired => 'Name and relationship are required.';

  @override
  String get contactAccessDenied => 'Contact access was not granted.';

  @override
  String get couldNotOpenContacts => 'Could not open contacts.';

  @override
  String get chooseContact => 'Choose contact';

  @override
  String get searchContacts => 'Search contacts';

  @override
  String get noContactsFound => 'No contacts found.';

  @override
  String get unnamedContact => 'Unnamed contact';

  @override
  String get contactRelationship => 'Contact';

  @override
  String get couldNotLoadContacts => 'Could not load contacts.';

  @override
  String get saveMomentTitle => 'Save a moment';

  @override
  String get todayEyebrow => 'Today';

  @override
  String get addMemoryStepTitle =>
      'What happened that you do not want to lose?';

  @override
  String get addMemoryStepSubtitle =>
      'Write one line, add a photo if you have one, and save. Details can wait.';

  @override
  String get momentLabel => 'Moment';

  @override
  String get momentHint => 'Dinner with Lara, first launch, quiet walk...';

  @override
  String get storyWorthLabel => 'What made it worth keeping?';

  @override
  String get storyWorthHint => 'A few words are enough.';

  @override
  String get feelingEyebrow => 'Feeling';

  @override
  String get feelingStepTitle => 'How should this feel when it returns?';

  @override
  String get feelingStepSubtitle =>
      'This makes the memory easier to rediscover later.';

  @override
  String get contextEyebrow => 'Context';

  @override
  String get whenWasItTitle => 'When was it?';

  @override
  String get photoGpsStepSubtitle =>
      'The map uses GPS saved inside selected photos. If a photo has no GPS, no place is shown.';

  @override
  String get peopleThreadsEyebrow => 'People & threads';

  @override
  String get peopleThreadsTitle => 'Who or what does this connect to?';

  @override
  String get peopleThreadsSubtitle =>
      'Optional details turn single moments into a life thread.';

  @override
  String get connectExistingMemoryLabel => 'Connect to an existing memory';

  @override
  String get noConnectionYet => 'No connection yet';

  @override
  String get connectionReasonLabel => 'Why are they connected?';

  @override
  String get connectionReasonHint =>
      'Example: same trip, same person, before / after...';

  @override
  String get writeMomentOrPhotoFirst => 'Write a moment or add a photo first.';

  @override
  String get todaysMoment => 'Today\'s moment';

  @override
  String get savedFromTodaysPrompt => 'Saved from today\'s prompt.';

  @override
  String get saveItBeforeItFades => 'Save it before it fades';

  @override
  String get chooseDate => 'Choose date';

  @override
  String get dateLabel => 'Date';

  @override
  String get untitledMemory => 'Untitled memory';

  @override
  String get organize => 'Organize';

  @override
  String get memoryShape => 'Memory shape';

  @override
  String get wallCategory => 'Wall category';

  @override
  String get privatePhotos => 'Private photos';

  @override
  String get pick => 'Pick';

  @override
  String get addMore => 'Add more';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get takePhotosNow => 'Take photos now';

  @override
  String get takePhotosFabTooltip => 'Take photos for a new memory';

  @override
  String get takeAnotherPhoto => 'Take another photo';

  @override
  String get continueWithPhotos => 'Continue with these photos';

  @override
  String get addPhotosToMemory => 'Add to memory';

  @override
  String get takeAnotherOrContinueBody =>
      'Keep shooting for this memory, or continue and add the story.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos captured',
      one: '1 photo captured',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads copies selected photos into private app storage and keeps date/location metadata when available.';

  @override
  String get limitedPhotoAccessActive =>
      'Limited photo access is active. You can add more allowed photos.';

  @override
  String get selectPhotos => 'Select photos';

  @override
  String get photoAccessOff => 'Photo access is off';

  @override
  String get photoAccessOffBody =>
      'Enable photo access to pick memories. Your photos stay on this device.';

  @override
  String get freeMemoryLimitReached => 'Free memory limit reached';

  @override
  String get freeMemoryLimitBody =>
      'Free walls include 30 memories. Upgrade to keep building your living wall.';

  @override
  String get photoAccessNeeded => 'Photo access is needed first.';

  @override
  String get quickPhotoMemory => 'Quick photo memory';

  @override
  String get quickPhotoDescription =>
      'A photo worth keeping. Add the story whenever you want.';

  @override
  String get hangQuickPhoto => 'Hang quick photo';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'Photo GPS detected: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'No photo GPS detected. This memory will not appear on the map.';

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
    return '$count/$total locations';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total sizes';
  }

  @override
  String newSelected(int count) {
    return '$count new selected';
  }

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get editMemoryTitle => 'Edit Memory';

  @override
  String get storyPanel => 'Story';

  @override
  String get memoryTitleLabel => 'Memory title';

  @override
  String get addTitleValidation => 'Add a title';

  @override
  String get storyDescriptionLabel => 'Story / description';

  @override
  String get addStoryValidation => 'Add a short story';

  @override
  String get shapeFeelingTitle => 'Shape and feeling';

  @override
  String get memoryTypeLabel => 'Memory type';

  @override
  String get feelingLabel => 'Feeling';

  @override
  String get categoryLabel => 'Category';

  @override
  String get timePhotoGpsTitle => 'Time and photo GPS';

  @override
  String get memoryDateLabel => 'Memory date';

  @override
  String get peopleTitle => 'People';

  @override
  String get galleryTitle => 'Gallery';

  @override
  String get addPhotos => 'Add photos';

  @override
  String get saveMemory => 'Save memory';

  @override
  String get memorySaveFailed =>
      'Could not save this memory. Please try again.';

  @override
  String get passwordOnlySpaces => 'A password can\'t be only spaces.';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get mapUnavailable => 'The map isn\'t available right now.';

  @override
  String get coverPhoto => 'Cover photo';

  @override
  String get galleryPhoto => 'Gallery photo';

  @override
  String get setAsCover => 'Set as cover';

  @override
  String get replacePhoto => 'Replace photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get choosePhoto => 'Choose photo';

  @override
  String get threadReasonsTitle => 'Thread Reasons';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'Create more memories before linking.';

  @override
  String get connectionHeaderBody =>
      'Connect memories with a reason. The rope should explain why two moments belong together.';

  @override
  String get connectedMemory => 'connected memory';

  @override
  String get whyConnectedTitle => 'Why are they connected?';

  @override
  String get exportPremiumArchiveTitle => 'Export backup';

  @override
  String get importArchiveTitle => 'Import Archive';

  @override
  String get archiveExportBody =>
      'Add a password to encrypt the archive. Leave empty for a normal local zip.';

  @override
  String get archiveImportBody =>
      'If this archive is encrypted, enter its password. Leave empty for older or unprotected backups.';

  @override
  String get archivePasswordOptional => 'Archive password (optional)';

  @override
  String get archivePasswordLabel => 'Archive password';

  @override
  String get archivePasswordWarning =>
      'Keep the password somewhere safe. It cannot be recovered if you lose it.';

  @override
  String get sendArchiveTitle => 'Send LifeThreads archive';

  @override
  String get sendArchiveSubject => 'LifeThreads memory archive';

  @override
  String get sendEncryptedArchiveText =>
      'LifeThreads encrypted archive. Use the password you chose to import it on another device.';

  @override
  String get sendArchiveText =>
      'LifeThreads archive. Import it in LifeThreads to open your memory wall on another device.';

  @override
  String get archiveReadyToSend =>
      'Backup ready. Keep it somewhere safe, off this phone.';

  @override
  String get archiveNotSaved =>
      'Backup not saved. Export again when you are ready.';

  @override
  String get archiveSharingUnavailable =>
      'Sharing is not available on this device.';

  @override
  String archiveShareFailed(Object error) {
    return 'Archive saved, but sharing failed: $error';
  }

  @override
  String get archiveImportedTitle => 'Archive imported';

  @override
  String get memoriesLabel => 'Memories';

  @override
  String get photosLabel => 'Photos';

  @override
  String get wallNotesNailsLabel => 'Wall notes / nails';

  @override
  String get connectionsLabel => 'Connections';

  @override
  String get archiveImportSummary =>
      'Your current wall was kept. Imported memories were added safely.';

  @override
  String get shareEncryptedCapsuleTitle => 'Share Encrypted Capsule';

  @override
  String get openSharedCapsuleTitle => 'Open Shared Capsule';

  @override
  String get exportMemoryCapsuleTitle => 'Export Memory Capsule';

  @override
  String get importCapsuleDialogTitle => 'Import Capsule';

  @override
  String get secureSharePasswordBody =>
      'Create a password before uploading this capsule. Send the password separately to the person receiving it.';

  @override
  String get sharedCapsulePasswordBody =>
      'Enter the password you received for this shared memory.';

  @override
  String get capsuleExportBody =>
      'Add a password if this memory should be protected before you send it. Leave empty for a normal capsule.';

  @override
  String get capsuleImportBody =>
      'If this capsule has a password, enter it. Otherwise leave empty.';

  @override
  String get capsulePasswordLabel => 'Capsule password';

  @override
  String get sharedCapsulePasswordLabel => 'Shared capsule password';

  @override
  String get capsulePasswordOptional => 'Capsule password (optional)';

  @override
  String get capsulePasswordWarning =>
      'LifeThreads cannot recover this password later.';

  @override
  String get passwordRequiredCloudSharing =>
      'Password is required for cloud sharing.';

  @override
  String get createSecureShare => 'Create Secure Share';

  @override
  String get previewMemory => 'Preview Memory';

  @override
  String get sendCapsuleTitle => 'Share LifeThreads memory';

  @override
  String get sendCapsuleSubject => 'LifeThreads memory capsule';

  @override
  String get sendEncryptedCapsuleText =>
      'Hey, I shared a protected LifeThreads memory with you. Use the password I sent you to import it.';

  @override
  String get sendCapsuleText =>
      'Hey, I shared a LifeThreads memory with you. Import the capsule in LifeThreads to add it to your wall.';

  @override
  String get capsuleReadyToSend => 'Capsule ready to send.';

  @override
  String get capsuleSavedLater => 'Capsule saved. You can share it later.';

  @override
  String get capsuleSharingUnavailable =>
      'Capsule saved, but sharing is unavailable.';

  @override
  String capsuleShareFailed(Object error) {
    return 'Capsule saved, but sharing failed: $error';
  }

  @override
  String get importThisMemory => 'Import this memory?';

  @override
  String get noStoryTextIncluded => 'No story text included.';

  @override
  String get placeLabel => 'Place';

  @override
  String get notesLabel => 'Notes';

  @override
  String get capsulePasswordProtected => 'This capsule was password-protected.';

  @override
  String get openingSharedMemory => 'Opening shared memory...';

  @override
  String get lifeThreadsMemoryTitle => 'LifeThreads memory';

  @override
  String shareMemoryText(Object url) {
    return 'Hey, I shared a memory with you in LifeThreads.\n\n$url';
  }

  @override
  String get shareLinkReady => 'Share link ready.';

  @override
  String get shareLinkCreated => 'Share link created.';

  @override
  String get shareLinkUnavailable =>
      'Share link created, but sharing is unavailable.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label Link expires automatically. You can delete it now.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'Cloud share failed: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'Shared memory link deleted.';

  @override
  String get creatingSecureMemoryLink => 'Creating secure memory link...';

  @override
  String get shareMemoryCapsule => 'Share Memory Capsule';

  @override
  String get editStory => 'Edit story';

  @override
  String get metaType => 'Type';

  @override
  String get metaFeeling => 'Feeling';

  @override
  String get metaCategory => 'Category';

  @override
  String get metaDate => 'Date';

  @override
  String get storyEyebrow => 'Story';

  @override
  String get whyMemoryMatters => 'Why this memory matters';

  @override
  String get galleryEyebrow => 'Gallery';

  @override
  String savedPhotosTitle(int count) {
    return '$count saved photo(s)';
  }

  @override
  String get peopleEyebrow => 'People';

  @override
  String get partOfMemory => 'Part of this memory';

  @override
  String get notesEyebrow => 'Notes';

  @override
  String get attachedThoughts => 'Attached thoughts';

  @override
  String get stickyNote => 'Sticky note';

  @override
  String get placeEyebrow => 'Place';

  @override
  String get threadsEyebrow => 'Threads';

  @override
  String get connectedMemories => 'Connected memories';

  @override
  String get noConnectedMemoriesYet =>
      'No connected memories yet. Connect this chapter to another moment to start a visible life thread.';

  @override
  String get backToWall => 'Back to wall';

  @override
  String get addTextToWall => 'Add text to wall';

  @override
  String get addTextAction => 'Add Text';

  @override
  String get textNoteHint => 'Write a small memory, quote, or note...';

  @override
  String get placeTextNote => 'Place text note';

  @override
  String get placeRopeAnchor => 'Place rope anchor';

  @override
  String get nailSubtitle =>
      'A nail can connect ropes manually between memories.';

  @override
  String get clearDemoWallQuestion => 'Clear demo wall?';

  @override
  String get clearDemoWallBody =>
      'This removes the sample memories so you can start with an empty private wall.';

  @override
  String get importBackupQuestion => 'Import backup?';

  @override
  String get importBackupBody =>
      'This restores memories from a LifeThreads archive and keeps your current wall.';

  @override
  String get deleteMemoryQuestion => 'Delete memory?';

  @override
  String get deleteMemoryBody =>
      'This removes the memory and all its wall links.';

  @override
  String get editText => 'Edit text';

  @override
  String get editTextTitle => 'Edit Text';

  @override
  String get connectRope => 'Connect rope';

  @override
  String get connectRopeSubtitle => 'Attach this nail to memories.';

  @override
  String get deleteNail => 'Delete nail';

  @override
  String get connectNailTitle => 'Connect nail to memories';

  @override
  String get connectNailSubtitle =>
      'Selected memories will hang from this anchor.';

  @override
  String get timelineTitle => 'Timeline';

  @override
  String get timelineSubtitle => 'Your memories ordered by time.';

  @override
  String get noMemoriesFilter => 'No memories in this filter';

  @override
  String get noMemoriesFilterBody =>
      'Switch filter or add a memory to build the timeline.';

  @override
  String get memoryMapTitle => 'Memory Map';

  @override
  String get memoryMapSubtitle => 'Your memories grouped by place.';

  @override
  String get noMappedMemories => 'No mapped memories yet';

  @override
  String get headerSubtitle => 'Your memories, hanging together.';

  @override
  String get importBackupTooltip => 'Import backup';

  @override
  String get exportBackupTooltip => 'Export backup';

  @override
  String get displayWallTooltip => 'Display wall';

  @override
  String get tutorialTooltip => 'Tutorial';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get hideControlsTooltip => 'Hide controls';

  @override
  String get freeformLayout => 'Freeform';

  @override
  String get categoryLayout => 'Category';

  @override
  String get locationLayout => 'Location';

  @override
  String get wallControls => 'Wall Controls';

  @override
  String get saveToday => 'Save today';

  @override
  String get rememberThis => 'Remember this';

  @override
  String get whatHappenedToday => 'What happened today?';

  @override
  String get tapToOpenDrag => 'Tap to open • drag to move';

  @override
  String get demoWallPreview =>
      'Demo wall preview. Clear it when you are ready to start fresh.';

  @override
  String get clearDemo => 'Clear demo';

  @override
  String get chooseQuickPhoto => 'Choose quick photo';

  @override
  String get wallView => 'Wall';

  @override
  String get timelineView => 'Timeline';

  @override
  String get mapView => 'Map';

  @override
  String get wallFilterAll => 'All';

  @override
  String get expandableMemory => 'Memory';

  @override
  String get expandableMemorySubtitle => 'Full guided story';

  @override
  String get expandableQuickPhoto => 'Quick photo memory';

  @override
  String get expandableQuickPhotoSubtitle => 'Pick photo and hang it';

  @override
  String get expandableTextNote => 'Text note';

  @override
  String get expandableTextNoteSubtitle => 'Small thought on wall';

  @override
  String get expandableNail => 'Nail / rope anchor';

  @override
  String get expandableNailSubtitle => 'Manual rope point';

  @override
  String get startWithOneThing => 'Start with one thing from today';

  @override
  String get emptyWallBody =>
      'Save a moment before it fades. A sentence or a photo is enough.';

  @override
  String get usePhoto => 'Use a photo';

  @override
  String get editMemoryTooltip => 'Edit memory';

  @override
  String get connectMemoryTooltip => 'Connect memory';

  @override
  String get archiveTransferTitle => 'Open on another device';

  @override
  String get archiveTransferHeroTitle =>
      'Move your memories between devices safely.';

  @override
  String get archiveTransferHeroBody =>
      'A backup is one zip with your memories, photos, notes, threads, wall positions and metadata, optionally locked with a password. We keep no copy: you decide where it goes.';

  @override
  String get archiveTransferStep1Title => 'Export an archive';

  @override
  String get archiveTransferStep1Body =>
      'Open Settings, choose Export Archive, and add a password if you want password protection.';

  @override
  String get archiveTransferStep2Title => 'Move the zip';

  @override
  String get archiveTransferStep2Body =>
      'Transfer it with AirDrop, USB, your own cloud drive or email.';

  @override
  String get archiveTransferStep3Title => 'Import safely';

  @override
  String get archiveTransferStep3Body =>
      'Install LifeThreads on the other device, choose Import Archive, enter the password if needed, and restore without deleting existing data.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled => 'Development Premium unlock enabled.';

  @override
  String get lifetimeActive => 'Subscription active';

  @override
  String get oneTimeLifetimeUnlock => 'Monthly subscription';

  @override
  String get premiumHeroActiveTitle => 'Your memory wall is unlimited.';

  @override
  String get premiumHeroLockedTitle => 'Turn your memories into stories.';

  @override
  String get premiumHeroActiveBody =>
      'Your Premium subscription is active. Stories with music, Thread of the Year, family walls and unlimited memories are yours.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'Free includes $limit memories and full backups. Premium adds stories and films with music, Thread of the Year, family walls and unlimited memories.';
  }

  @override
  String get premiumMemories => 'Premium memories';

  @override
  String get freeMemories => 'Free memories';

  @override
  String get unlimited => 'unlimited';

  @override
  String get benefitUnlimitedTitle => 'Unlimited memories';

  @override
  String get benefitUnlimitedBody =>
      'No 30-memory ceiling. Keep building the wall as life grows.';

  @override
  String get benefitThemesTitle => 'Premium wall themes';

  @override
  String get benefitThemesBody =>
      'Unlock richer wall moods for family, travel, archive, and gallery styles.';

  @override
  String get benefitLayoutsTitle => 'Advanced layouts';

  @override
  String get benefitLayoutsBody =>
      'More ways to arrange threads, timelines, anchors, and memory clusters.';

  @override
  String get lifetimeUnlock => 'Premium subscription';

  @override
  String get premiumActiveOnDevice => 'Premium is active on this device.';

  @override
  String onePurchaseBody(String store) {
    return 'Subscribe monthly for stories with music, Thread of the Year, family walls and unlimited memories. Cancel anytime in your $store settings.';
  }

  @override
  String get premiumActiveButton => 'Premium Active';

  @override
  String get processing => 'Processing...';

  @override
  String get unlockPremium => 'Subscribe to Premium';

  @override
  String get restorePurchase => 'Restore subscription';

  @override
  String get enableDebugMockUnlock => 'Enable debug mock unlock';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'Payment is charged to your $store account. The subscription renews automatically every month unless you cancel it at least 24 hours before the current period ends. Manage or cancel it in your $store account settings.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'The store update failed. Please try again.';

  @override
  String get premiumMessageStoreUnavailable =>
      'Purchases are not available on this device.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium is not available in the store yet. Please try again later.';

  @override
  String get premiumMessageLoadFailed =>
      'Premium could not be loaded from the store. Please try again.';

  @override
  String get premiumMessageOpeningCheckout => 'Opening the checkout…';

  @override
  String get premiumMessageCheckoutFailed =>
      'The checkout could not be opened. Please try again.';

  @override
  String get premiumMessageChecking => 'Checking your subscription…';

  @override
  String get premiumMessageRestoreFailed =>
      'Restoring failed. Please try again.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'No active Premium subscription was found.';

  @override
  String get premiumMessagePending =>
      'Your purchase is pending. Premium unlocks once it is approved.';

  @override
  String get premiumMessagePurchaseFailed =>
      'The purchase did not go through. Please try again.';

  @override
  String get premiumMessageCanceled => 'Purchase canceled.';

  @override
  String get premiumMessageRestored => 'Your Premium subscription is restored.';

  @override
  String get premiumMessageActive => 'Your Premium subscription is active.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/month';
  }

  @override
  String get loadingPlayStoreProduct => 'Loading the subscription…';

  @override
  String get playStoreUnavailable => 'The store is unavailable right now';

  @override
  String get productNotConfigured => 'Product not configured';

  @override
  String get purchasePending => 'Purchase pending';

  @override
  String get purchased => 'Purchased';

  @override
  String get restored => 'Restored';

  @override
  String get purchaseFailed => 'Purchase failed';

  @override
  String get preparingCheckout => 'Preparing checkout...';

  @override
  String get premiumLocalFirstTitle => 'Premium is local-first';

  @override
  String get premiumLocalFirstBody =>
      'Your memories stay on your device, and backups are free for everyone.';

  @override
  String get noMappedMemoriesBody =>
      'Add photos that contain GPS metadata to see memories here.';

  @override
  String get peopleLabel => 'People';

  @override
  String get connect => 'Connect';

  @override
  String get themeWarmMemoryRoom => 'Warm Memory Room';

  @override
  String get themeWarmMemoryRoomDescription =>
      'Soft dark warmth, gold light, and private-room depth.';

  @override
  String get themeMidnightArchive => 'Midnight Archive';

  @override
  String get themeMidnightArchiveDescription =>
      'Deep blue archive room with quiet museum-like focus.';

  @override
  String get themeSoftPaperWall => 'Soft Paper Wall';

  @override
  String get themeSoftPaperWallDescription =>
      'Cream paper, ink shadows, and calm scrapbook feeling.';

  @override
  String get themeTravelCorkboard => 'Travel Corkboard';

  @override
  String get themeTravelCorkboardDescription =>
      'Corkboard warmth with map-grid hints for trips and places.';

  @override
  String get demoFirstDanceTitle => 'Our first dance';

  @override
  String get demoFirstDanceStory =>
      'The band played our song and the whole barn went quiet. I stepped on your foot twice, you laughed through all of it, and for three minutes nobody else was there.';

  @override
  String get demoFirstDancePlace => 'Salzburg';

  @override
  String get demoNewbornTitle => 'Welcome home, Lina';

  @override
  String get demoNewbornStory =>
      'Her whole hand fit around one finger. The first quiet morning at home.';

  @override
  String get demoNewbornPlace => 'Vienna';

  @override
  String get demoBeachSunsetTitle => 'Summer by the sea';

  @override
  String get demoBeachSunsetStory =>
      'Barefoot until the sun went down, Lina asleep on your shoulders on the way back.';

  @override
  String get demoBeachSunsetPlace => 'Split, Croatia';

  @override
  String get demoGrandmaKitchenTitle => 'Grandma\'s kitchen';

  @override
  String get demoGrandmaKitchenStory =>
      'Her apricot cake, finally written down – and flour everywhere.';

  @override
  String get demoGrandmaKitchenPlace => 'Graz';

  @override
  String get demoGraduationTitle => 'Graduation day';

  @override
  String get demoGraduationStory => 'Dad cried before the caps even landed.';

  @override
  String get demoGraduationPlace => 'Innsbruck';

  @override
  String get demoFirstHomeTitle => 'Keys to our first home';

  @override
  String get demoFirstHomeStory =>
      'No furniture yet, just boxes, pizza on the floor and a lot of plans.';

  @override
  String get demoFirstHomePlace => 'Linz';

  @override
  String get demoAlpineSummitTitle => 'Above the clouds';

  @override
  String get demoAlpineSummitStory =>
      'Up at 4 a.m. for this. Worth every step.';

  @override
  String get demoAlpineSummitPlace => 'Grossglockner';

  @override
  String get demoFirstBikeTitle => 'First ride, no hands';

  @override
  String get demoFirstBikeStory =>
      'Three steps, a wobble, then he was gone – and so proud.';

  @override
  String get demoFirstBikePlace => 'Prater, Vienna';

  @override
  String get demoGardenDinnerTitle => 'Grandpa\'s 80th';

  @override
  String get demoGardenDinnerStory =>
      'Four generations at one long table, and he still told the best stories.';

  @override
  String get demoGardenDinnerPlace => 'Wachau';

  @override
  String get demoThreadFirstDanceToFirstHome => 'Our story';

  @override
  String get demoThreadFirstHomeToNewborn => 'Then came Lina';

  @override
  String get demoThreadNewbornToBeachSunset => 'Her first summer';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'Family';

  @override
  String get demoThreadGraduationToFirstHome => 'New chapter';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'Little adventures';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'Grandpa watched';

  @override
  String get demoRelationGrandpa => 'Grandpa';

  @override
  String get demoRelationGrandma => 'Grandma';

  @override
  String get demoRelationDaughter => 'Daughter';

  @override
  String get demoRelationWife => 'Wife';

  @override
  String get demoRelationBestMan => 'Best man';

  @override
  String get demoRelationMother => 'Mother';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Saved to $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories are not in a backup yet.',
      one: '1 memory is not in a backup yet.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Later';

  @override
  String get backUp => 'Back up';

  @override
  String get onThisDayTitle => 'On this day';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years ago today',
      one: '1 year ago today',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years ago',
      one: '1 year ago',
    );
    return 'On this day · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'On days when a memory from an earlier year comes back, LifeThreads sends one quiet reminder.';

  @override
  String get onThisDayReminderSwitch => 'Daily reminder';

  @override
  String onThisDayReminderAt(String time) {
    return 'At $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'Notifications are off for LifeThreads. Allow them in your phone\'s settings.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years ago today: $title',
      one: '1 year ago today: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more memories',
      one: '1 more memory',
    );
    return '$title and $_temp0 from this day';
  }

  @override
  String get onThisDayChannelDescription =>
      'A memory from this day in an earlier year.';

  @override
  String get benefitOnThisDayBody =>
      'A reminder when a memory from an earlier year comes back, opened as its own chapter.';

  @override
  String get premiumFeatureStoryImage => 'Story images';

  @override
  String get premiumFeatureStoryVideo => 'Story videos';

  @override
  String get premiumFeatureThreadOfTheYear => 'Thread of the Year';

  @override
  String get premiumFeatureFamilyWall => 'Family wall';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature is part of Premium.';
  }

  @override
  String get yearThreadTitle => 'Thread of the Year';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories',
      one: '1 memory',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places',
      one: '1 place',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'Most felt: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'A year, threaded.';

  @override
  String get yearThreadMyYear => 'My year';

  @override
  String get yearThreadWallCardTitle => 'Your year in memories';

  @override
  String yearThreadWallCardBody(String year) {
    return 'Turn $year into a short film.';
  }

  @override
  String get yearThreadDismiss => 'Not now';

  @override
  String get yearThreadSettingsBody =>
      'Turn any year with at least 3 memories into a short film, told in order and joined by the thread.';

  @override
  String get yearThreadOpen => 'Make the film';

  @override
  String get yearThreadNoYears =>
      'Thread of the Year needs a year with at least 3 memories. Keep saving moments and come back.';

  @override
  String get yearThreadYear => 'Year';

  @override
  String get yearThreadLength => 'Length';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'Film · $seconds s';
  }

  @override
  String get yearThreadLengthStory => 'Story · 20 s';

  @override
  String get yearThreadMusic => 'Music';

  @override
  String get yearThreadNoMusic => 'No music';

  @override
  String get yearThreadInFilm => 'In the film';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count of $max';
  }

  @override
  String get yearThreadAddMemory => 'Add a memory';

  @override
  String get yearThreadSwap => 'Swap';

  @override
  String get yearThreadRemove => 'Remove';

  @override
  String get yearThreadUseSuggestions => 'Use suggestions';

  @override
  String yearThreadPickTitle(String year) {
    return 'Choose a memory from $year';
  }

  @override
  String get yearThreadNoOthers =>
      'Every memory from this year is already in the film.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories',
      one: '1 memory',
    );
    return 'Choose at least $_temp0.';
  }

  @override
  String get yearThreadPreview => 'Preview';

  @override
  String get yearThreadExportVideo => 'Export video';

  @override
  String get yearThreadExportImage => 'Export image';

  @override
  String get yearThreadShare => 'Share';

  @override
  String get yearThreadSave => 'Save to Photos';

  @override
  String get yearThreadMakingFilm => 'Making your film…';

  @override
  String get yearThreadMakingImage => 'Making your image…';

  @override
  String get yearThreadFilmReady => 'Your film is ready';

  @override
  String get yearThreadImageReady => 'Your image is ready';

  @override
  String get yearThreadSaved => 'Saved to your photos.';

  @override
  String get yearThreadExportFailed => 'That did not work. Please try again.';

  @override
  String get yearThreadPlay => 'Play';

  @override
  String get yearThreadPause => 'Pause';

  @override
  String get createStory => 'Create story';

  @override
  String get storyPickTitle => 'Choose memories';

  @override
  String storyPickBody(int max) {
    return 'Pick up to $max memories for one story.';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$count of $max chosen';
  }

  @override
  String storyPickLimit(int max) {
    return 'A story holds up to $max memories.';
  }

  @override
  String get storyPickContinue => 'Continue';

  @override
  String get storyNoMemories =>
      'Save a memory first, then turn it into a story.';

  @override
  String get storyEditorTitle => 'Your story';

  @override
  String get storyChangeMemories => 'Change memories';

  @override
  String get storyTemplateSingle => 'Single memory';

  @override
  String get storyTemplateThread => 'Thread';

  @override
  String get storyTemplateCollage => 'Collage';

  @override
  String get storyTemplateQuote => 'Quote';

  @override
  String get storySwipeHint => 'Swipe for another look';

  @override
  String get storyCaptionLabel => 'Caption';

  @override
  String get storyCaptionHint => 'One line of your story';

  @override
  String get storyVideoSwitch => 'Video';

  @override
  String get storyVideoBody =>
      'A short film for Stories and Reels: photos drift, the thread draws itself, titles fade in.';

  @override
  String get storyMusicTitle => 'Music';

  @override
  String get storyMusicNone => 'No music';

  @override
  String get storyMusicNoneHint =>
      'You can add a song from Instagram\'s music library when you post the story.';

  @override
  String get storyMoodWarm => 'Warm';

  @override
  String get storyMoodJoyful => 'Joyful';

  @override
  String get storyMoodCalm => 'Calm';

  @override
  String get storyMoodNostalgic => 'Nostalgic';

  @override
  String get storyMoodEpic => 'Epic';

  @override
  String get storyMoodEmotional => 'Emotional';

  @override
  String get storyMusicTrimHint => 'Drag to choose which part plays';

  @override
  String get storySearchHint => 'Search memories, places, years';

  @override
  String storySearchEmpty(String query) {
    return 'No memory matches “$query”.';
  }

  @override
  String get storyMemoriesInStory => 'In your story';

  @override
  String get storyMemoriesReorderHint => 'Hold and drag to change the order';

  @override
  String get storyAddMemory => 'Add';

  @override
  String get storyAddMemoryTitle => 'Add a memory';

  @override
  String storyRemoveMemory(String title) {
    return 'Remove $title from the story';
  }

  @override
  String get storyAllMemoriesAdded => 'Every memory is already in this story.';

  @override
  String get storyShare => 'Share';

  @override
  String get storySaveToPhotos => 'Save to Photos';

  @override
  String get storySaved => 'Saved to your photos.';

  @override
  String get storySaveDenied =>
      'LifeThreads may not add to your photos. Allow it in your phone\'s settings.';

  @override
  String storyExportFailed(String error) {
    return 'The story could not be created: $error';
  }

  @override
  String get storyRenderingTitle => 'Making your film';

  @override
  String get storyRenderingBody =>
      'Keep LifeThreads open, this takes a few seconds.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent %';
  }

  @override
  String get storyPreviewFree =>
      'The preview is free. Sharing and saving stories are part of Premium.';

  @override
  String get benefitStoriesTitle => 'Create Story';

  @override
  String get benefitStoriesBody =>
      'Turn memories into story images and short films with music for Instagram, WhatsApp and more.';

  @override
  String get musicCreditsTitle => 'Music credits';

  @override
  String get musicCreditsBody =>
      'Songs bundled for story videos, with their licences.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'Your year as a short film: the moments that mattered, threaded in order, with music.';

  @override
  String get benefitFamilyTitle => 'Family walls';

  @override
  String get benefitFamilyBody =>
      'A shared wall for your family, end-to-end encrypted. Everyone adds their moments.';

  @override
  String get myWall => 'My wall';

  @override
  String get myWallSubtitle => 'Private, on this device';

  @override
  String get switchWall => 'Switch wall';

  @override
  String get familyWallsTitle => 'Family walls';

  @override
  String get familyWallsSettingsBody =>
      'Share one wall with family or friends: everyone adds memories, end-to-end encrypted. My wall stays private on this device.';

  @override
  String get familyWallsOpen => 'Open family walls';

  @override
  String get familyWallsManage => 'Manage family walls';

  @override
  String get familyWallsHeadline => 'One wall, the whole family';

  @override
  String get familyWallsIntro =>
      'A family wall is shared with the people you invite. Memories and photos are encrypted on your phone before they are uploaded; only members can open them. My wall is not shared and stays on this device.';

  @override
  String get familyUnavailableTitle => 'Not available yet';

  @override
  String get familyUnavailable =>
      'Family walls are not available in this version of LifeThreads yet.';

  @override
  String get familySignInNeededTitle => 'Sign in to use family walls';

  @override
  String get familySignInNeededBody =>
      'A shared wall needs an account so the family knows who added what. My wall works without one.';

  @override
  String get familySignIn => 'Sign in';

  @override
  String get familyLoadFailed => 'Could not load';

  @override
  String get familyRetry => 'Try again';

  @override
  String get familyNoWallsYet =>
      'No family walls yet. Start one or join with an invite link.';

  @override
  String get familyStartTitle => 'Start or join';

  @override
  String get familyStartBody =>
      'Starting a family wall needs Premium. Joining one is free: the owner\'s Premium covers the family.';

  @override
  String get familyCreateAction => 'Create family wall';

  @override
  String get familyCreateTitle => 'New family wall';

  @override
  String get familyNameLabel => 'Name of the wall';

  @override
  String get familyNameHint => 'e.g. The Millers';

  @override
  String get familyMyNameLabel => 'Your name on this wall';

  @override
  String get familyMyNameHelper =>
      'Members see it on your memories. It is encrypted like everything on the wall.';

  @override
  String get familyMyNameSaved => 'Name saved.';

  @override
  String get familySetMyName => 'My name';

  @override
  String get familyCheckingSubscription => 'Checking your Premium…';

  @override
  String get familyCreating => 'Creating the wall…';

  @override
  String get familyJoinWithLink => 'Join with link';

  @override
  String get familyInviteLinkLabel => 'Invite link';

  @override
  String get familyJoinTitle => 'Join this family wall?';

  @override
  String get familyJoinBody =>
      'Members will see your name and the memories you add, and you will see theirs. You can leave at any time.';

  @override
  String get familyJoinAction => 'Join';

  @override
  String get familyJoining => 'Joining…';

  @override
  String familyJoined(String family) {
    return 'You joined $family.';
  }

  @override
  String get familyRoleOwner => 'Owner';

  @override
  String get familyRoleMember => 'Member';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'Wall settings';

  @override
  String familyStorageUsed(String used, String total) {
    return '$used of $total used';
  }

  @override
  String get familyRename => 'Rename';

  @override
  String get familyInviteTitle => 'Invite';

  @override
  String get familyInviteBody =>
      'Send a link to someone you trust. Each link works once and expires after 7 days.';

  @override
  String get familyInviteAction => 'Create invite link';

  @override
  String get familyCreatingInvite => 'Creating the invite…';

  @override
  String get familyInviteReady => 'Invite link ready';

  @override
  String get familyInviteValidity =>
      'Works once and expires after 7 days at the latest.';

  @override
  String get familyInviteKeyWarning =>
      'The link carries the wall\'s key: whoever opens it can join and read the wall. Send it only to the person you invite.';

  @override
  String get familyInviteShare => 'Share link';

  @override
  String get familyInviteCopy => 'Copy link';

  @override
  String get familyInviteCopied => 'Link copied.';

  @override
  String get familyInviteShareFailed =>
      'Sharing is not available. Copy the link instead.';

  @override
  String familyInviteSubject(String family) {
    return 'Join $family on LifeThreads';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'Join our family wall \"$family\" on LifeThreads: $link';
  }

  @override
  String get familyMembersTitle => 'Members';

  @override
  String get familyMemberActions => 'Member actions';

  @override
  String get familyYou => 'You';

  @override
  String familyYouNamed(String name) {
    return '$name (you)';
  }

  @override
  String get familyAMember => 'A member';

  @override
  String get familyFormerMember => 'Former member';

  @override
  String get familyBlocked => 'Blocked';

  @override
  String get familyBlock => 'Block';

  @override
  String get familyUnblock => 'Unblock';

  @override
  String familyBlockAuthor(String name) {
    return 'Block $name';
  }

  @override
  String familyBlockQuestion(String name) {
    return 'Block $name?';
  }

  @override
  String get familyBlockBody =>
      'You will no longer see their memories on any family wall. They are not told. You can unblock them in the members list.';

  @override
  String get familyReport => 'Report';

  @override
  String get familyRemoveMember => 'Remove from wall';

  @override
  String familyRemoveQuestion(String name) {
    return 'Remove $name?';
  }

  @override
  String get familyRemoveBody =>
      'They lose access to this wall. Invite them again to bring them back.';

  @override
  String get familyRemoveDeleteContent => 'Also delete the memories they added';

  @override
  String get familyDeleteTitle => 'Delete family wall';

  @override
  String get familyDeleteBody =>
      'As the owner you cannot leave the wall; you can delete it for everyone.';

  @override
  String get familyDeleteAction => 'Delete wall';

  @override
  String familyDeleteQuestion(String family) {
    return 'Delete $family?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'All memories and photos on this wall are deleted from our servers for every member. This cannot be undone. Memories on My wall are not affected.';

  @override
  String get familyDeleting => 'Deleting…';

  @override
  String get familyLeaveTitle => 'Leave family wall';

  @override
  String get familyLeaveBody =>
      'You stop seeing this wall. You can keep or delete the memories you added.';

  @override
  String get familyLeaveAction => 'Leave';

  @override
  String familyLeaveQuestion(String family) {
    return 'Leave $family?';
  }

  @override
  String get familyLeaveConfirmBody => 'To come back you need a new invite.';

  @override
  String get familyLeaveDeleteMine => 'Also delete the memories I added';

  @override
  String get familyLeaving => 'Leaving…';

  @override
  String get familySignInTitle => 'Sign in';

  @override
  String get familySignInHeadline => 'An account for family walls';

  @override
  String get familySignInWhy =>
      'A family wall is shared, so it needs an account: members see who added each memory, and only members can open the wall.';

  @override
  String get familySignInMyWallStays =>
      'My wall needs no account. It stays private on this device and is never uploaded.';

  @override
  String get familySignInEncrypted =>
      'Family memories and photos are end-to-end encrypted. GK Coding stores them but cannot read them.';

  @override
  String get familySignInWhatWeGet =>
      'From Apple or Google we only use an account ID, not your contacts or photos.';

  @override
  String get familySignInApple => 'Sign in with Apple';

  @override
  String get familySignInGoogle => 'Sign in with Google';

  @override
  String get familySignInFinePrint =>
      'By signing in you agree to the Terms of Use and the Privacy Policy. You can delete your account in the app at any time.';

  @override
  String get familyAccountTitle => 'Account';

  @override
  String get familySignedOutTitle => 'Not signed in';

  @override
  String get familySignedOutBody =>
      'Sign in to see your family walls. My wall works without an account.';

  @override
  String get familySignedInTitle => 'Signed in';

  @override
  String get familySignedInBody =>
      'Your account is used only for family walls.';

  @override
  String familyAccountId(String id) {
    return 'Account ID: $id';
  }

  @override
  String get familySignOut => 'Sign out';

  @override
  String get familySignOutQuestion => 'Sign out?';

  @override
  String get familySignOutBody =>
      'Family walls and their keys are removed from this device until you sign in again. Nothing is deleted on the server. My wall is not affected.';

  @override
  String get familySigningOut => 'Signing out…';

  @override
  String get familyDeleteAccountTitle => 'Delete account';

  @override
  String get familyDeleteAccountBody =>
      'Deletes your account and your family wall data from our servers. My wall stays on this device.';

  @override
  String get familyDeleteAccount => 'Delete account';

  @override
  String get familyDeleteAccountQuestion => 'Delete your account?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'The $count family walls you own are deleted for all their members, with every memory and photo on them.',
      one:
          'The family wall you own is deleted for all its members, with every memory and photo on it.',
      zero: 'You own no family wall.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'The memories and photos you added to other families\' walls are deleted, and you leave those walls.';

  @override
  String get familyDeleteAccountKeys =>
      'Family wall keys and cached photos are removed from this device. This cannot be undone.';

  @override
  String get familyDeleteAccountMyWall =>
      'My wall is not affected: its memories stay on this device.';

  @override
  String get familyDeleteAccountSubscription =>
      'A Premium subscription is not cancelled by this; manage it in the App Store or Google Play.';

  @override
  String get familyDeleteAccountUnderstood =>
      'I understand that this deletes my account for good.';

  @override
  String get familyDeletingAccount => 'Deleting your account…';

  @override
  String get familyAccountDeleted => 'Your account was deleted.';

  @override
  String get familyTermsTitle => 'Family wall rules';

  @override
  String get familyTermsHeadline => 'Before you share';

  @override
  String get familyTermsIntro =>
      'Family walls are for the people you invite. To keep them safe, everyone accepts these rules:';

  @override
  String get familyTermsZeroTolerance =>
      'Zero tolerance for objectionable content: no harassment, hate, sexual content, violence, self-harm, illegal content, or other people\'s private information without their consent.';

  @override
  String get familyTermsOwnContent =>
      'Share only photos and stories you are allowed to share.';

  @override
  String get familyTermsReport =>
      'Report any memory or member from the wall. GK Coding reviews reports within 24 hours.';

  @override
  String get familyTermsBlock =>
      'Block a member to stop seeing their memories.';

  @override
  String get familyTermsOwner =>
      'The owner of a wall can remove members and their memories.';

  @override
  String get familyTermsConsequences =>
      'Content that breaks these rules is removed, and the accounts that posted it can be suspended or deleted.';

  @override
  String get familyTermsReadFull => 'Read the full terms';

  @override
  String get familyTermsAgree => 'I agree to the Terms of Use and these rules.';

  @override
  String get familyTermsAccept => 'Accept and continue';

  @override
  String familyTermsVersion(String version) {
    return 'Terms version $version';
  }

  @override
  String get familyWallEmptyTitle => 'The wall is waiting';

  @override
  String get familyWallEmptyBody =>
      'Add the first memory. Everyone on this wall will see it.';

  @override
  String get familyWallGoneBody =>
      'This family wall is no longer available to you. It may have been deleted, or you were removed.';

  @override
  String get familyAddMemory => 'Add memory';

  @override
  String get familyRefresh => 'Refresh';

  @override
  String get familySyncing => 'Syncing…';

  @override
  String get familyOffline => 'Offline: showing saved memories';

  @override
  String get familySyncFailed => 'Sync failed';

  @override
  String get familyMemoryTitle => 'Memory';

  @override
  String get familyMemoryGone => 'This memory is no longer on the wall.';

  @override
  String get familyMemoryActions => 'Memory actions';

  @override
  String familyAddedBy(String name) {
    return 'Added by $name';
  }

  @override
  String get familyDeleteMemoryQuestion => 'Delete this memory?';

  @override
  String get familyDeleteMemoryBody =>
      'It is removed from the wall for everyone, with its photos.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'As the owner you can remove memories from this wall. This memory by $name is removed for everyone, with its photos.';
  }

  @override
  String get familyDeletingMemory => 'Deleting the memory…';

  @override
  String get familyNoPhotosYet => 'No photos yet';

  @override
  String get familyPostNote =>
      'Everyone on this wall will see this memory. Photos are resized and encrypted on your phone before upload.';

  @override
  String get familyPostMemory => 'Post to the wall';

  @override
  String get familyUploading => 'Encrypting and uploading…';

  @override
  String get familyMemorySaved => 'Saved to the family wall.';

  @override
  String get familyConflictTitle => 'Changed by someone else';

  @override
  String get familyConflictBody =>
      'This memory changed on another device while you were editing. Load the latest version and save your changes over it?';

  @override
  String get familyConflictRetry => 'Refresh and save';

  @override
  String get familyQuotaTitle => 'The wall is full';

  @override
  String get familyReportMemoryTitle => 'Report memory';

  @override
  String get familyReportPhotoTitle => 'Report photo';

  @override
  String get familyReportMemberTitle => 'Report member';

  @override
  String get familyReportIntro =>
      'Tell us what is wrong. Your report goes to GK Coding, not to the person you report.';

  @override
  String get familyReportSpam => 'Spam or scam';

  @override
  String get familyReportHarassment => 'Harassment or bullying';

  @override
  String get familyReportHate => 'Hate speech';

  @override
  String get familyReportSexual => 'Sexual content or nudity';

  @override
  String get familyReportViolence => 'Violence or threats';

  @override
  String get familyReportSelfHarm => 'Self-harm or suicide';

  @override
  String get familyReportIllegal => 'Illegal content';

  @override
  String get familyReportPrivacy =>
      'Private information shared without consent';

  @override
  String get familyReportOther => 'Something else';

  @override
  String get familyReportDetailsLabel => 'Details (optional)';

  @override
  String get familyReportDetailsHint => 'What should we know?';

  @override
  String familyReportAlsoBlock(String name) {
    return 'Also block $name';
  }

  @override
  String get familyReportSend => 'Send report';

  @override
  String get familyReportReviewNote =>
      'GK Coding reviews every report within 24 hours and removes content and members that break the rules.';

  @override
  String get familyReportSentTitle => 'Thank you';

  @override
  String get familyReportSentBody =>
      'Your report was sent. GK Coding reviews it within 24 hours and acts on content that breaks the rules.';

  @override
  String get familyErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get familyErrorOffline =>
      'You appear to be offline. Check your connection and try again.';

  @override
  String get familyErrorSubscriptionRequired =>
      'This needs an active Premium subscription of the wall\'s owner.';

  @override
  String get familyErrorInviteExpired =>
      'This invite has expired. Ask for a new link.';

  @override
  String get familyErrorInviteUsed =>
      'This invite was already used. Each link works once; ask for a new one.';

  @override
  String get familyErrorInviteInvalid =>
      'This is not a valid LifeThreads invite link.';

  @override
  String get familyErrorAlreadyMember =>
      'You are already a member of this family wall.';

  @override
  String get familyErrorFamilyFull =>
      'This family wall has reached its member limit.';

  @override
  String get familyErrorQuotaExceeded =>
      'This family wall has no storage left. Delete some memories or photos to make room.';

  @override
  String get familyErrorVersionConflict =>
      'Someone changed this memory first. Refresh and try again.';

  @override
  String get familyErrorTermsRequired =>
      'Please accept the family wall rules first.';

  @override
  String get familyErrorSignedOut =>
      'You were signed out. Please sign in again.';

  @override
  String get familyErrorNotAllowed =>
      'You are not allowed to do this on this wall.';

  @override
  String get familyErrorNotFound => 'Family wall not found';

  @override
  String get familyErrorOwnerCannotLeave =>
      'The owner cannot leave the wall, but can delete it.';

  @override
  String get familyPaste => 'Paste';

  @override
  String get familyErrorInviteRevoked =>
      'This invite was withdrawn. Ask for a new link.';

  @override
  String get familyErrorKeyMissing =>
      'This device does not have the key for this family wall (for example after a reinstall or on a new phone). Ask a member for a new invite link: opening it restores access.';

  @override
  String get familyErrorSignInUnavailable =>
      'Sign-in is not available on this device right now.';

  @override
  String get familyErrorNoPurchase =>
      'No Premium purchase was found for this App Store or Google Play account. Get Premium first, then try again.';

  @override
  String get familyErrorVerificationUnavailable =>
      'Your Premium could not be checked right now. Please try again later.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'This Premium purchase is already linked to another family wall account. Sign in with that account, or contact info@gkcoding.dev.';

  @override
  String get familyErrorNameTooLong =>
      'That name is too long. Please use a shorter one.';

  @override
  String get familyErrorPhotoUnreadable =>
      'One of the photos could not be read. Remove it and try again.';

  @override
  String get familyErrorTooLarge =>
      'This is too large to upload. Try fewer or smaller photos.';

  @override
  String get familyReportEvidenceNote =>
      'To review it, GK Coding receives this memory\'s title and story with your report. Its photos are never sent.';
}
