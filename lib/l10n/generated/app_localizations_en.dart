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
      'LifeThreads is local-first: no account and no public profile. Your memories stay on this device unless you choose encrypted cloud share, Cloud Sync, or a manual backup export.';

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
  String get premiumArchiveTitle => 'Premium Archive';

  @override
  String get premiumArchiveBody =>
      'Move your memories between devices safely. Export an archive with memories, photos, notes, ropes, wall layout, and metadata. Add password protection when you need it.';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Unlock';

  @override
  String get exportArchive => 'Export Archive';

  @override
  String get unlockExport => 'Unlock Export';

  @override
  String get importArchive => 'Import Archive';

  @override
  String get importCapsule => 'Import Capsule';

  @override
  String get moveDevices => 'Move Devices';

  @override
  String get cloudSyncTitle => 'Cloud Sync';

  @override
  String get cloudSyncBody =>
      'Back up a password-protected archive to your VPS. The server stores only the locked zip and your private sync key controls restore access.';

  @override
  String get vpsBadge => 'VPS';

  @override
  String get backUpNow => 'Back Up Now';

  @override
  String get unlockBackup => 'Unlock Backup';

  @override
  String get restoreLatest => 'Restore Latest';

  @override
  String get copyKey => 'Copy Key';

  @override
  String get useKey => 'Use Key';

  @override
  String get deleteCloud => 'Delete Cloud';

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
      'Monthly subscription: unlimited memories, encrypted archive export/import, moving to another device, premium themes, and advanced layouts.';

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
  String get cloudBackupNeedsPassword => 'Cloud backup needs a password.';

  @override
  String cloudBackupSaved(int memoryCount) {
    return 'Cloud backup saved: $memoryCount memories.';
  }

  @override
  String cloudBackupFailed(Object message) {
    return 'Cloud backup failed: $message';
  }

  @override
  String cloudRestoreRejected(Object message) {
    return 'Cloud restore rejected: $message';
  }

  @override
  String cloudRestoreFailed(Object message) {
    return 'Cloud restore failed: $message';
  }

  @override
  String get syncKeyCopied => 'Sync key copied.';

  @override
  String get useSyncKeyTitle => 'Use Sync Key';

  @override
  String get syncKeyLabel => 'Sync key';

  @override
  String get syncKeySaved => 'Sync key saved.';

  @override
  String get deleteCloudBackupTitle => 'Delete cloud backup?';

  @override
  String get deleteCloudBackupBody =>
      'This deletes the encrypted archive from your VPS. Local memories stay on this device.';

  @override
  String get cloudBackupDeleted => 'Cloud backup deleted.';

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
      'Use Cloud Sync or archive transfer before changing phone or testing a production build.';

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
  String get exportPremiumArchiveTitle => 'Export Premium Archive';

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
  String get archiveReadyToSend => 'Archive ready to send.';

  @override
  String get archiveSavedLater => 'Archive saved. You can share it later.';

  @override
  String get archiveSharingUnavailable =>
      'Archive saved, but sharing is unavailable.';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Saved to $path';
  }

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
      'Premium Archive creates a portable encrypted zip with your memories, photos, notes, ropes, wall positions, and metadata. Cloud Sync can also store that locked zip on your VPS for restore on another device.';

  @override
  String get archiveTransferStep1Title => 'Export an archive';

  @override
  String get archiveTransferStep1Body =>
      'Open Settings, choose Export Archive, and add a password if you want password protection.';

  @override
  String get archiveTransferStep2Title => 'Move or sync the zip';

  @override
  String get archiveTransferStep2Body =>
      'Transfer it with AirDrop, USB, Drive, email, or use Cloud Sync with a private sync key.';

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
  String get premiumHeroLockedTitle =>
      'Move your memories between devices safely.';

  @override
  String get premiumHeroActiveBody =>
      'Your Premium subscription is active. Encrypted archive export, premium themes, and advanced layouts are available.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'Free includes $limit memories. Premium adds encrypted archive export/import, safe device transfer, themes, and advanced layouts.';
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
  String get benefitArchivesTitle => 'Encrypted archives';

  @override
  String get benefitArchivesBody =>
      'Export and import a password-protected zip with photos, notes, ropes, layout, and metadata.';

  @override
  String get benefitTransferTitle => 'Move to another device';

  @override
  String get benefitTransferBody =>
      'Carry your private memory wall to a new phone without active cloud sync.';

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
  String get cloudSyncPlannedTitle => 'Cloud sync is planned later';

  @override
  String get cloudSyncPlannedBody =>
      'Premium Archive is the safe transfer feature now: export, move the zip, and import on another device.';

  @override
  String get deviceTransferHow => 'How device transfer works';

  @override
  String get lifetimeUnlock => 'Premium subscription';

  @override
  String get premiumActiveOnDevice => 'Premium is active on this device.';

  @override
  String get onePurchaseBody =>
      'Subscribe monthly for unlimited memories, backups, premium themes, and advanced layouts. Cancel anytime in Google Play or the App Store.';

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
  String get purchasesHandledByGooglePlay =>
      'Subscriptions are handled by Google Play or the App Store. Premium stays active while your subscription renews.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/month';
  }

  @override
  String get loadingPlayStoreProduct => 'Loading Play Store product...';

  @override
  String get playStoreUnavailable => 'Play Store unavailable';

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
      'Premium unlocks local-first value now. Cloud sync is planned later and is not active in this version.';

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
  String get demoViennaTitle => 'Vienna evening walk';

  @override
  String get demoViennaDescription =>
      'A quiet evening in Vienna, the kind of moment that stays warm because nothing needed to be perfect.';

  @override
  String get demoViennaLocation => 'Vienna, Austria';

  @override
  String get demoLinzTitle => 'Rain and coffee';

  @override
  String get demoLinzDescription =>
      'A slow Linz afternoon with coffee, rain on the windows, and one photo that feels like home.';

  @override
  String get demoLinzLocation => 'Linz, Austria';

  @override
  String get demoFamilyTitle => 'Family table';

  @override
  String get demoFamilyDescription =>
      'Food, noise, small jokes, and the feeling that this is what should be remembered.';

  @override
  String get demoHomeLocation => 'Home';

  @override
  String get demoLaunchTitle => 'First launch night';

  @override
  String get demoLaunchDescription =>
      'The night an idea finally became something real on a screen.';

  @override
  String get demoConnectionQuietDays => 'quiet days';

  @override
  String get demoConnectionHomeFocus => 'home focus';

  @override
  String get demoConnectionWhyItMatters => 'why it matters';
}
