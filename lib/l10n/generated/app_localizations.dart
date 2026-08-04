import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get preparing;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language. System follows your phone language when LifeThreads supports it.'**
  String get languageBody;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @germanLanguage.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get germanLanguage;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicLanguage;

  /// No description provided for @languageSelected.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}.'**
  String languageSelected(Object language);

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads is local-first: no account and no public profile. Your memories stay on this device unless you choose encrypted cloud share, Cloud Sync, or a manual backup export.'**
  String get privacyBody;

  /// No description provided for @viewPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'View privacy policy'**
  String get viewPrivacyPolicy;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsTitle;

  /// No description provided for @viewTerms.
  ///
  /// In en, this message translates to:
  /// **'View terms'**
  String get viewTerms;

  /// No description provided for @betaFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Beta feedback'**
  String get betaFeedbackTitle;

  /// No description provided for @betaFeedbackBody.
  ///
  /// In en, this message translates to:
  /// **'Send beta feedback with safe diagnostics. Logs include app events and crash types only, never memory text, photo paths, backups, or exact locations.'**
  String get betaFeedbackBody;

  /// No description provided for @closedBetaBadge.
  ///
  /// In en, this message translates to:
  /// **'Closed beta'**
  String get closedBetaBadge;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @premiumArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Archive'**
  String get premiumArchiveTitle;

  /// No description provided for @premiumArchiveBody.
  ///
  /// In en, this message translates to:
  /// **'Move your memories between devices safely. Export an archive with memories, photos, notes, ropes, wall layout, and metadata. Add password protection when you need it.'**
  String get premiumArchiveBody;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumBadge;

  /// No description provided for @unlockBadge.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockBadge;

  /// No description provided for @exportArchive.
  ///
  /// In en, this message translates to:
  /// **'Export Archive'**
  String get exportArchive;

  /// No description provided for @unlockExport.
  ///
  /// In en, this message translates to:
  /// **'Unlock Export'**
  String get unlockExport;

  /// No description provided for @importArchive.
  ///
  /// In en, this message translates to:
  /// **'Import Archive'**
  String get importArchive;

  /// No description provided for @importCapsule.
  ///
  /// In en, this message translates to:
  /// **'Import Capsule'**
  String get importCapsule;

  /// No description provided for @moveDevices.
  ///
  /// In en, this message translates to:
  /// **'Move Devices'**
  String get moveDevices;

  /// No description provided for @cloudSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSyncTitle;

  /// No description provided for @cloudSyncBody.
  ///
  /// In en, this message translates to:
  /// **'Back up a password-protected archive to your VPS. The server stores only the locked zip and your private sync key controls restore access.'**
  String get cloudSyncBody;

  /// No description provided for @vpsBadge.
  ///
  /// In en, this message translates to:
  /// **'VPS'**
  String get vpsBadge;

  /// No description provided for @backUpNow.
  ///
  /// In en, this message translates to:
  /// **'Back Up Now'**
  String get backUpNow;

  /// No description provided for @unlockBackup.
  ///
  /// In en, this message translates to:
  /// **'Unlock Backup'**
  String get unlockBackup;

  /// No description provided for @restoreLatest.
  ///
  /// In en, this message translates to:
  /// **'Restore Latest'**
  String get restoreLatest;

  /// No description provided for @copyKey.
  ///
  /// In en, this message translates to:
  /// **'Copy Key'**
  String get copyKey;

  /// No description provided for @useKey.
  ///
  /// In en, this message translates to:
  /// **'Use Key'**
  String get useKey;

  /// No description provided for @deleteCloud.
  ///
  /// In en, this message translates to:
  /// **'Delete Cloud'**
  String get deleteCloud;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeBody.
  ///
  /// In en, this message translates to:
  /// **'Choose how your private wall should feel. Free users get Warm Memory Room. Premium unlocks every wall mood.'**
  String get themeBody;

  /// No description provided for @oneFreeBadge.
  ///
  /// In en, this message translates to:
  /// **'1 free'**
  String get oneFreeBadge;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumTitle;

  /// No description provided for @premiumActiveBody.
  ///
  /// In en, this message translates to:
  /// **'Premium lifetime unlock is active.'**
  String get premiumActiveBody;

  /// No description provided for @premiumLockedBody.
  ///
  /// In en, this message translates to:
  /// **'One-time unlock: unlimited memories, encrypted archive export/import, moving to another device, premium themes, and advanced layouts.'**
  String get premiumLockedBody;

  /// No description provided for @activeBadge.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeBadge;

  /// No description provided for @openPremium.
  ///
  /// In en, this message translates to:
  /// **'Open Premium'**
  String get openPremium;

  /// No description provided for @appVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersionTitle;

  /// No description provided for @clearAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearAllDataTitle;

  /// No description provided for @clearAllDataBody.
  ///
  /// In en, this message translates to:
  /// **'Delete all memories, connections, wall notes, nails, and copied photos from this device.'**
  String get clearAllDataBody;

  /// No description provided for @clearData.
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(Object error);

  /// No description provided for @importRejected.
  ///
  /// In en, this message translates to:
  /// **'Import rejected: {message}'**
  String importRejected(Object message);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importFailed(Object error);

  /// No description provided for @cloudBackupNeedsPassword.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup needs a password.'**
  String get cloudBackupNeedsPassword;

  /// No description provided for @cloudBackupSaved.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup saved: {memoryCount} memories.'**
  String cloudBackupSaved(int memoryCount);

  /// No description provided for @cloudBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup failed: {message}'**
  String cloudBackupFailed(Object message);

  /// No description provided for @cloudRestoreRejected.
  ///
  /// In en, this message translates to:
  /// **'Cloud restore rejected: {message}'**
  String cloudRestoreRejected(Object message);

  /// No description provided for @cloudRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Cloud restore failed: {message}'**
  String cloudRestoreFailed(Object message);

  /// No description provided for @syncKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'Sync key copied.'**
  String get syncKeyCopied;

  /// No description provided for @useSyncKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Use Sync Key'**
  String get useSyncKeyTitle;

  /// No description provided for @syncKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Sync key'**
  String get syncKeyLabel;

  /// No description provided for @syncKeySaved.
  ///
  /// In en, this message translates to:
  /// **'Sync key saved.'**
  String get syncKeySaved;

  /// No description provided for @deleteCloudBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete cloud backup?'**
  String get deleteCloudBackupTitle;

  /// No description provided for @deleteCloudBackupBody.
  ///
  /// In en, this message translates to:
  /// **'This deletes the encrypted archive from your VPS. Local memories stay on this device.'**
  String get deleteCloudBackupBody;

  /// No description provided for @cloudBackupDeleted.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup deleted.'**
  String get cloudBackupDeleted;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {message}'**
  String deleteFailed(Object message);

  /// No description provided for @capsuleRejected.
  ///
  /// In en, this message translates to:
  /// **'Capsule rejected: {message}'**
  String capsuleRejected(Object message);

  /// No description provided for @capsuleImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Capsule import failed: {error}'**
  String capsuleImportFailed(Object error);

  /// No description provided for @clearAllDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'Clear all data?'**
  String get clearAllDataQuestion;

  /// No description provided for @clearAllDataQuestionBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes all local LifeThreads data on this device. Export a backup first if you want to keep it.'**
  String get clearAllDataQuestionBody;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @allLocalDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All local data cleared.'**
  String get allLocalDataCleared;

  /// No description provided for @feedbackGeneral.
  ///
  /// In en, this message translates to:
  /// **'General feedback'**
  String get feedbackGeneral;

  /// No description provided for @feedbackBug.
  ///
  /// In en, this message translates to:
  /// **'Bug'**
  String get feedbackBug;

  /// No description provided for @feedbackCrash.
  ///
  /// In en, this message translates to:
  /// **'Crash'**
  String get feedbackCrash;

  /// No description provided for @feedbackDesign.
  ///
  /// In en, this message translates to:
  /// **'Design issue'**
  String get feedbackDesign;

  /// No description provided for @feedbackMissingFeature.
  ///
  /// In en, this message translates to:
  /// **'Missing feature'**
  String get feedbackMissingFeature;

  /// No description provided for @feedbackPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get feedbackPerformance;

  /// No description provided for @betaFeedbackIntro.
  ///
  /// In en, this message translates to:
  /// **'Write what happened or what felt wrong. Safe diagnostics will be attached without private memory content.'**
  String get betaFeedbackIntro;

  /// No description provided for @feedbackType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get feedbackType;

  /// No description provided for @feedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackLabel;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Example: I tapped Add > Quick photo and the screen froze.'**
  String get feedbackHint;

  /// No description provided for @betaFeedbackNotIncluded.
  ///
  /// In en, this message translates to:
  /// **'Not included: memory titles, stories, notes, photo paths, backup paths, exact locations.'**
  String get betaFeedbackNotIncluded;

  /// No description provided for @feedbackEmpty.
  ///
  /// In en, this message translates to:
  /// **'Write a short feedback message first.'**
  String get feedbackEmpty;

  /// No description provided for @feedbackCopied.
  ///
  /// In en, this message translates to:
  /// **'No email app opened. Feedback copied to clipboard for info@gkcoding.dev.'**
  String get feedbackCopied;

  /// No description provided for @themeSelected.
  ///
  /// In en, this message translates to:
  /// **'{theme} selected.'**
  String themeSelected(Object theme);

  /// No description provided for @onboardingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Build your living wall.'**
  String get onboardingHeadline;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'A private memory room where photos, places, people, and little notes can hang together with emotional threads.'**
  String get onboardingBody;

  /// No description provided for @onboardingPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your memories stay private by default: no account and no public profile. Optional encrypted cloud share and backup only happen when you choose them.'**
  String get onboardingPrivacy;

  /// No description provided for @storyPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your memories stay private'**
  String get storyPrivacyTitle;

  /// No description provided for @storyConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect moments'**
  String get storyConnectTitle;

  /// No description provided for @storyConnectText.
  ///
  /// In en, this message translates to:
  /// **'Link memories, notes, and places so every chapter has context.'**
  String get storyConnectText;

  /// No description provided for @storyWallTitle.
  ///
  /// In en, this message translates to:
  /// **'Build your living wall'**
  String get storyWallTitle;

  /// No description provided for @storyWallText.
  ///
  /// In en, this message translates to:
  /// **'Start with one photo, then let the wall grow into something that feels alive.'**
  String get storyWallText;

  /// No description provided for @previewDemoWall.
  ///
  /// In en, this message translates to:
  /// **'Preview demo wall'**
  String get previewDemoWall;

  /// No description provided for @startFresh.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get startFresh;

  /// No description provided for @optionalDemoPreview.
  ///
  /// In en, this message translates to:
  /// **'Optional demo preview'**
  String get optionalDemoPreview;

  /// No description provided for @quickTutorial.
  ///
  /// In en, this message translates to:
  /// **'Quick tutorial'**
  String get quickTutorial;

  /// No description provided for @tutorialIntro.
  ///
  /// In en, this message translates to:
  /// **'The basic flow: save memories, connect the related ones, then arrange the wall.'**
  String get tutorialIntro;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @tutorialAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a memory'**
  String get tutorialAddTitle;

  /// No description provided for @tutorialAddText.
  ///
  /// In en, this message translates to:
  /// **'Tap Add, choose Memory or Quick photo, then save the title, date, people, and photo.'**
  String get tutorialAddText;

  /// No description provided for @tutorialConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect memories'**
  String get tutorialConnectTitle;

  /// No description provided for @tutorialConnectText.
  ///
  /// In en, this message translates to:
  /// **'Open a card, tap the connect icon, select related memories, and add a short reason.'**
  String get tutorialConnectText;

  /// No description provided for @tutorialArrangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Arrange the wall'**
  String get tutorialArrangeTitle;

  /// No description provided for @tutorialArrangeText.
  ///
  /// In en, this message translates to:
  /// **'Drag cards, notes, and nails into place. Real connections draw ropes behind the items.'**
  String get tutorialArrangeText;

  /// No description provided for @tutorialShowBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Show the board'**
  String get tutorialShowBoardTitle;

  /// No description provided for @tutorialShowBoardText.
  ///
  /// In en, this message translates to:
  /// **'Open lifethreads.gkcoding.dev/display on another screen, tap the QR button in Wall Controls, and scan the code to show a temporary read-only board.'**
  String get tutorialShowBoardText;

  /// No description provided for @tutorialBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep a backup'**
  String get tutorialBackupTitle;

  /// No description provided for @tutorialBackupText.
  ///
  /// In en, this message translates to:
  /// **'Use Cloud Sync or archive transfer before changing phone or testing a production build.'**
  String get tutorialBackupText;

  /// No description provided for @scanDisplayQr.
  ///
  /// In en, this message translates to:
  /// **'Scan display QR'**
  String get scanDisplayQr;

  /// No description provided for @scannerHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Open lifethreads.gkcoding.dev/display on another screen.'**
  String get scannerHintTitle;

  /// No description provided for @scannerHintBody.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code from that page. LifeThreads sends a temporary read-only board snapshot to that browser session.'**
  String get scannerHintBody;

  /// No description provided for @addMemoryBeforeDisplay.
  ///
  /// In en, this message translates to:
  /// **'Add a memory before displaying a wall.'**
  String get addMemoryBeforeDisplay;

  /// No description provided for @notLifeThreadsDisplayQr.
  ///
  /// In en, this message translates to:
  /// **'This is not a LifeThreads display QR.'**
  String get notLifeThreadsDisplayQr;

  /// No description provided for @displayWallQuestion.
  ///
  /// In en, this message translates to:
  /// **'Display this wall?'**
  String get displayWallQuestion;

  /// No description provided for @displayWallBody.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads will send a temporary read-only board snapshot with {memoryCount} memories to the browser session you scanned. It opens on lifethreads.gkcoding.dev/display and expires automatically.'**
  String displayWallBody(int memoryCount);

  /// No description provided for @displayAction.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get displayAction;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'soon'**
  String get soon;

  /// No description provided for @wallDisplayLive.
  ///
  /// In en, this message translates to:
  /// **'Wall display is live with {memoryCount} memories until {expires}.'**
  String wallDisplayLive(int memoryCount, Object expires);

  /// No description provided for @preparingWallDisplay.
  ///
  /// In en, this message translates to:
  /// **'Preparing wall display...'**
  String get preparingWallDisplay;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @saveReason.
  ///
  /// In en, this message translates to:
  /// **'Save Reason'**
  String get saveReason;

  /// No description provided for @chooseBackup.
  ///
  /// In en, this message translates to:
  /// **'Choose Backup'**
  String get chooseBackup;

  /// No description provided for @chooseArchive.
  ///
  /// In en, this message translates to:
  /// **'Choose Archive'**
  String get chooseArchive;

  /// No description provided for @chooseCapsule.
  ///
  /// In en, this message translates to:
  /// **'Choose Capsule'**
  String get chooseCapsule;

  /// No description provided for @exportAction.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportAction;

  /// No description provided for @addToWall.
  ///
  /// In en, this message translates to:
  /// **'Add to Wall'**
  String get addToWall;

  /// No description provided for @cinemaSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get cinemaSkip;

  /// No description provided for @cinemaNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get cinemaNotNow;

  /// No description provided for @cinemaSharedChapter.
  ///
  /// In en, this message translates to:
  /// **'A shared memory chapter'**
  String get cinemaSharedChapter;

  /// No description provided for @cinemaConnectedThread.
  ///
  /// In en, this message translates to:
  /// **'Connected thread'**
  String get cinemaConnectedThread;

  /// No description provided for @cinemaInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add this memory to your wall?'**
  String get cinemaInviteTitle;

  /// No description provided for @useSelected.
  ///
  /// In en, this message translates to:
  /// **'Use selected'**
  String get useSelected;

  /// No description provided for @noPhotosFound.
  ///
  /// In en, this message translates to:
  /// **'No photos found.'**
  String get noPhotosFound;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @manageAccess.
  ///
  /// In en, this message translates to:
  /// **'Manage access'**
  String get manageAccess;

  /// No description provided for @saveNow.
  ///
  /// In en, this message translates to:
  /// **'Save now'**
  String get saveNow;

  /// No description provided for @hangOnWall.
  ///
  /// In en, this message translates to:
  /// **'Hang on wall'**
  String get hangOnWall;

  /// No description provided for @placeHere.
  ///
  /// In en, this message translates to:
  /// **'Place here'**
  String get placeHere;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @viewPremium.
  ///
  /// In en, this message translates to:
  /// **'View Premium'**
  String get viewPremium;

  /// No description provided for @memoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Memory not found'**
  String get memoryNotFound;

  /// No description provided for @memoryTypeMoment.
  ///
  /// In en, this message translates to:
  /// **'Moment'**
  String get memoryTypeMoment;

  /// No description provided for @memoryTypeTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get memoryTypeTrip;

  /// No description provided for @memoryTypePerson.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get memoryTypePerson;

  /// No description provided for @memoryTypePlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get memoryTypePlace;

  /// No description provided for @memoryTypeNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get memoryTypeNote;

  /// No description provided for @memoryTypeMomentDescription.
  ///
  /// In en, this message translates to:
  /// **'A small scene worth keeping'**
  String get memoryTypeMomentDescription;

  /// No description provided for @memoryTypeTripDescription.
  ///
  /// In en, this message translates to:
  /// **'A journey or day away'**
  String get memoryTypeTripDescription;

  /// No description provided for @memoryTypePersonDescription.
  ///
  /// In en, this message translates to:
  /// **'Someone important'**
  String get memoryTypePersonDescription;

  /// No description provided for @memoryTypePlaceDescription.
  ///
  /// In en, this message translates to:
  /// **'A location that carries meaning'**
  String get memoryTypePlaceDescription;

  /// No description provided for @memoryTypeNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'A thought, quote, or reminder'**
  String get memoryTypeNoteDescription;

  /// No description provided for @categoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get categoryPersonal;

  /// No description provided for @categoryFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get categoryFamily;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @feelingWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get feelingWarm;

  /// No description provided for @feelingNostalgic.
  ///
  /// In en, this message translates to:
  /// **'Nostalgic'**
  String get feelingNostalgic;

  /// No description provided for @feelingProud.
  ///
  /// In en, this message translates to:
  /// **'Proud'**
  String get feelingProud;

  /// No description provided for @feelingCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get feelingCalm;

  /// No description provided for @feelingImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get feelingImportant;

  /// No description provided for @feelingWarmDescription.
  ///
  /// In en, this message translates to:
  /// **'Soft, close, full of love.'**
  String get feelingWarmDescription;

  /// No description provided for @feelingNostalgicDescription.
  ///
  /// In en, this message translates to:
  /// **'A memory that pulls you back.'**
  String get feelingNostalgicDescription;

  /// No description provided for @feelingProudDescription.
  ///
  /// In en, this message translates to:
  /// **'A moment that proved something.'**
  String get feelingProudDescription;

  /// No description provided for @feelingCalmDescription.
  ///
  /// In en, this message translates to:
  /// **'Quiet, safe, peaceful.'**
  String get feelingCalmDescription;

  /// No description provided for @feelingImportantDescription.
  ///
  /// In en, this message translates to:
  /// **'A memory that changed the story.'**
  String get feelingImportantDescription;

  /// No description provided for @addPeopleHint.
  ///
  /// In en, this message translates to:
  /// **'Add people who belong to this moment. Contacts stay local.'**
  String get addPeopleHint;

  /// No description provided for @addPerson.
  ///
  /// In en, this message translates to:
  /// **'Add person'**
  String get addPerson;

  /// No description provided for @editPerson.
  ///
  /// In en, this message translates to:
  /// **'Edit person'**
  String get editPerson;

  /// No description provided for @chooseFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Choose from contacts'**
  String get chooseFromContacts;

  /// No description provided for @personNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get personNameLabel;

  /// No description provided for @personNameHint.
  ///
  /// In en, this message translates to:
  /// **'Type to search saved people'**
  String get personNameHint;

  /// No description provided for @relationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationshipLabel;

  /// No description provided for @relationshipHint.
  ///
  /// In en, this message translates to:
  /// **'Friend, mother, partner...'**
  String get relationshipHint;

  /// No description provided for @phoneOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptionalLabel;

  /// No description provided for @emailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptionalLabel;

  /// No description provided for @nameRelationshipRequired.
  ///
  /// In en, this message translates to:
  /// **'Name and relationship are required.'**
  String get nameRelationshipRequired;

  /// No description provided for @contactAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Contact access was not granted.'**
  String get contactAccessDenied;

  /// No description provided for @couldNotOpenContacts.
  ///
  /// In en, this message translates to:
  /// **'Could not open contacts.'**
  String get couldNotOpenContacts;

  /// No description provided for @chooseContact.
  ///
  /// In en, this message translates to:
  /// **'Choose contact'**
  String get chooseContact;

  /// No description provided for @searchContacts.
  ///
  /// In en, this message translates to:
  /// **'Search contacts'**
  String get searchContacts;

  /// No description provided for @noContactsFound.
  ///
  /// In en, this message translates to:
  /// **'No contacts found.'**
  String get noContactsFound;

  /// No description provided for @unnamedContact.
  ///
  /// In en, this message translates to:
  /// **'Unnamed contact'**
  String get unnamedContact;

  /// No description provided for @contactRelationship.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactRelationship;

  /// No description provided for @couldNotLoadContacts.
  ///
  /// In en, this message translates to:
  /// **'Could not load contacts.'**
  String get couldNotLoadContacts;

  /// No description provided for @saveMomentTitle.
  ///
  /// In en, this message translates to:
  /// **'Save a moment'**
  String get saveMomentTitle;

  /// No description provided for @todayEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayEyebrow;

  /// No description provided for @addMemoryStepTitle.
  ///
  /// In en, this message translates to:
  /// **'What happened that you do not want to lose?'**
  String get addMemoryStepTitle;

  /// No description provided for @addMemoryStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write one line, add a photo if you have one, and save. Details can wait.'**
  String get addMemoryStepSubtitle;

  /// No description provided for @momentLabel.
  ///
  /// In en, this message translates to:
  /// **'Moment'**
  String get momentLabel;

  /// No description provided for @momentHint.
  ///
  /// In en, this message translates to:
  /// **'Dinner with Lara, first launch, quiet walk...'**
  String get momentHint;

  /// No description provided for @storyWorthLabel.
  ///
  /// In en, this message translates to:
  /// **'What made it worth keeping?'**
  String get storyWorthLabel;

  /// No description provided for @storyWorthHint.
  ///
  /// In en, this message translates to:
  /// **'A few words are enough.'**
  String get storyWorthHint;

  /// No description provided for @feelingEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Feeling'**
  String get feelingEyebrow;

  /// No description provided for @feelingStepTitle.
  ///
  /// In en, this message translates to:
  /// **'How should this feel when it returns?'**
  String get feelingStepTitle;

  /// No description provided for @feelingStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This makes the memory easier to rediscover later.'**
  String get feelingStepSubtitle;

  /// No description provided for @contextEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get contextEyebrow;

  /// No description provided for @whenWasItTitle.
  ///
  /// In en, this message translates to:
  /// **'When was it?'**
  String get whenWasItTitle;

  /// No description provided for @photoGpsStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The map uses GPS saved inside selected photos. If a photo has no GPS, no place is shown.'**
  String get photoGpsStepSubtitle;

  /// No description provided for @peopleThreadsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'People & threads'**
  String get peopleThreadsEyebrow;

  /// No description provided for @peopleThreadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Who or what does this connect to?'**
  String get peopleThreadsTitle;

  /// No description provided for @peopleThreadsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional details turn single moments into a life thread.'**
  String get peopleThreadsSubtitle;

  /// No description provided for @connectExistingMemoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Connect to an existing memory'**
  String get connectExistingMemoryLabel;

  /// No description provided for @noConnectionYet.
  ///
  /// In en, this message translates to:
  /// **'No connection yet'**
  String get noConnectionYet;

  /// No description provided for @connectionReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Why are they connected?'**
  String get connectionReasonLabel;

  /// No description provided for @connectionReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Example: same trip, same person, before / after...'**
  String get connectionReasonHint;

  /// No description provided for @writeMomentOrPhotoFirst.
  ///
  /// In en, this message translates to:
  /// **'Write a moment or add a photo first.'**
  String get writeMomentOrPhotoFirst;

  /// No description provided for @todaysMoment.
  ///
  /// In en, this message translates to:
  /// **'Today\'s moment'**
  String get todaysMoment;

  /// No description provided for @savedFromTodaysPrompt.
  ///
  /// In en, this message translates to:
  /// **'Saved from today\'s prompt.'**
  String get savedFromTodaysPrompt;

  /// No description provided for @saveItBeforeItFades.
  ///
  /// In en, this message translates to:
  /// **'Save it before it fades'**
  String get saveItBeforeItFades;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get chooseDate;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @untitledMemory.
  ///
  /// In en, this message translates to:
  /// **'Untitled memory'**
  String get untitledMemory;

  /// No description provided for @organize.
  ///
  /// In en, this message translates to:
  /// **'Organize'**
  String get organize;

  /// No description provided for @memoryShape.
  ///
  /// In en, this message translates to:
  /// **'Memory shape'**
  String get memoryShape;

  /// No description provided for @wallCategory.
  ///
  /// In en, this message translates to:
  /// **'Wall category'**
  String get wallCategory;

  /// No description provided for @privatePhotos.
  ///
  /// In en, this message translates to:
  /// **'Private photos'**
  String get privatePhotos;

  /// No description provided for @pick.
  ///
  /// In en, this message translates to:
  /// **'Pick'**
  String get pick;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get addMore;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @photoStorageHint.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads copies selected photos into private app storage and keeps date/location metadata when available.'**
  String get photoStorageHint;

  /// No description provided for @limitedPhotoAccessActive.
  ///
  /// In en, this message translates to:
  /// **'Limited photo access is active. You can add more allowed photos.'**
  String get limitedPhotoAccessActive;

  /// No description provided for @selectPhotos.
  ///
  /// In en, this message translates to:
  /// **'Select photos'**
  String get selectPhotos;

  /// No description provided for @photoAccessOff.
  ///
  /// In en, this message translates to:
  /// **'Photo access is off'**
  String get photoAccessOff;

  /// No description provided for @photoAccessOffBody.
  ///
  /// In en, this message translates to:
  /// **'Enable photo access to pick memories. Your photos stay on this device.'**
  String get photoAccessOffBody;

  /// No description provided for @freeMemoryLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Free memory limit reached'**
  String get freeMemoryLimitReached;

  /// No description provided for @freeMemoryLimitBody.
  ///
  /// In en, this message translates to:
  /// **'Free walls include 30 memories. Upgrade to keep building your living wall.'**
  String get freeMemoryLimitBody;

  /// No description provided for @photoAccessNeeded.
  ///
  /// In en, this message translates to:
  /// **'Photo access is needed first.'**
  String get photoAccessNeeded;

  /// No description provided for @quickPhotoMemory.
  ///
  /// In en, this message translates to:
  /// **'Quick photo memory'**
  String get quickPhotoMemory;

  /// No description provided for @quickPhotoDescription.
  ///
  /// In en, this message translates to:
  /// **'A photo worth keeping. Add the story whenever you want.'**
  String get quickPhotoDescription;

  /// No description provided for @hangQuickPhoto.
  ///
  /// In en, this message translates to:
  /// **'Hang quick photo'**
  String get hangQuickPhoto;

  /// No description provided for @photoGpsDetected.
  ///
  /// In en, this message translates to:
  /// **'Photo GPS detected: {latitude}, {longitude}'**
  String photoGpsDetected(Object latitude, Object longitude);

  /// No description provided for @photoGpsMissing.
  ///
  /// In en, this message translates to:
  /// **'No photo GPS detected. This memory will not appear on the map.'**
  String get photoGpsMissing;

  /// No description provided for @memoryPreviewSummary.
  ///
  /// In en, this message translates to:
  /// **'{title} • {type} • {feeling} • {photoCount} photo(s)'**
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  );

  /// No description provided for @metadataDates.
  ///
  /// In en, this message translates to:
  /// **'{count}/{total} dates'**
  String metadataDates(int count, int total);

  /// No description provided for @metadataLocations.
  ///
  /// In en, this message translates to:
  /// **'{count}/{total} locations'**
  String metadataLocations(int count, int total);

  /// No description provided for @metadataSizes.
  ///
  /// In en, this message translates to:
  /// **'{count}/{total} sizes'**
  String metadataSizes(int count, int total);

  /// No description provided for @newSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} new selected'**
  String newSelected(int count);

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @editMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Memory'**
  String get editMemoryTitle;

  /// No description provided for @storyPanel.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get storyPanel;

  /// No description provided for @memoryTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Memory title'**
  String get memoryTitleLabel;

  /// No description provided for @addTitleValidation.
  ///
  /// In en, this message translates to:
  /// **'Add a title'**
  String get addTitleValidation;

  /// No description provided for @storyDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Story / description'**
  String get storyDescriptionLabel;

  /// No description provided for @addStoryValidation.
  ///
  /// In en, this message translates to:
  /// **'Add a short story'**
  String get addStoryValidation;

  /// No description provided for @shapeFeelingTitle.
  ///
  /// In en, this message translates to:
  /// **'Shape and feeling'**
  String get shapeFeelingTitle;

  /// No description provided for @memoryTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Memory type'**
  String get memoryTypeLabel;

  /// No description provided for @feelingLabel.
  ///
  /// In en, this message translates to:
  /// **'Feeling'**
  String get feelingLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @timePhotoGpsTitle.
  ///
  /// In en, this message translates to:
  /// **'Time and photo GPS'**
  String get timePhotoGpsTitle;

  /// No description provided for @memoryDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Memory date'**
  String get memoryDateLabel;

  /// No description provided for @peopleTitle.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleTitle;

  /// No description provided for @galleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryTitle;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// No description provided for @saveMemory.
  ///
  /// In en, this message translates to:
  /// **'Save memory'**
  String get saveMemory;

  /// No description provided for @coverPhoto.
  ///
  /// In en, this message translates to:
  /// **'Cover photo'**
  String get coverPhoto;

  /// No description provided for @galleryPhoto.
  ///
  /// In en, this message translates to:
  /// **'Gallery photo'**
  String get galleryPhoto;

  /// No description provided for @setAsCover.
  ///
  /// In en, this message translates to:
  /// **'Set as cover'**
  String get setAsCover;

  /// No description provided for @replacePhoto.
  ///
  /// In en, this message translates to:
  /// **'Replace photo'**
  String get replacePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get choosePhoto;

  /// No description provided for @threadReasonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Thread Reasons'**
  String get threadReasonsTitle;

  /// No description provided for @createMoreMemoriesBeforeLinking.
  ///
  /// In en, this message translates to:
  /// **'Create more memories before linking.'**
  String get createMoreMemoriesBeforeLinking;

  /// No description provided for @connectionHeaderBody.
  ///
  /// In en, this message translates to:
  /// **'Connect memories with a reason. The rope should explain why two moments belong together.'**
  String get connectionHeaderBody;

  /// No description provided for @connectedMemory.
  ///
  /// In en, this message translates to:
  /// **'connected memory'**
  String get connectedMemory;

  /// No description provided for @whyConnectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are they connected?'**
  String get whyConnectedTitle;

  /// No description provided for @exportPremiumArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Premium Archive'**
  String get exportPremiumArchiveTitle;

  /// No description provided for @importArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Archive'**
  String get importArchiveTitle;

  /// No description provided for @archiveExportBody.
  ///
  /// In en, this message translates to:
  /// **'Add a password to encrypt the archive. Leave empty for a normal local zip.'**
  String get archiveExportBody;

  /// No description provided for @archiveImportBody.
  ///
  /// In en, this message translates to:
  /// **'If this archive is encrypted, enter its password. Leave empty for older or unprotected backups.'**
  String get archiveImportBody;

  /// No description provided for @archivePasswordOptional.
  ///
  /// In en, this message translates to:
  /// **'Archive password (optional)'**
  String get archivePasswordOptional;

  /// No description provided for @archivePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Archive password'**
  String get archivePasswordLabel;

  /// No description provided for @archivePasswordWarning.
  ///
  /// In en, this message translates to:
  /// **'Keep the password somewhere safe. It cannot be recovered if you lose it.'**
  String get archivePasswordWarning;

  /// No description provided for @sendArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Send LifeThreads archive'**
  String get sendArchiveTitle;

  /// No description provided for @sendArchiveSubject.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads memory archive'**
  String get sendArchiveSubject;

  /// No description provided for @sendEncryptedArchiveText.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads encrypted archive. Use the password you chose to import it on another device.'**
  String get sendEncryptedArchiveText;

  /// No description provided for @sendArchiveText.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads archive. Import it in LifeThreads to open your memory wall on another device.'**
  String get sendArchiveText;

  /// No description provided for @archiveReadyToSend.
  ///
  /// In en, this message translates to:
  /// **'Archive ready to send.'**
  String get archiveReadyToSend;

  /// No description provided for @archiveSavedLater.
  ///
  /// In en, this message translates to:
  /// **'Archive saved. You can share it later.'**
  String get archiveSavedLater;

  /// No description provided for @archiveSharingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Archive saved, but sharing is unavailable.'**
  String get archiveSharingUnavailable;

  /// No description provided for @savedToPath.
  ///
  /// In en, this message translates to:
  /// **'{label} Saved to {path}'**
  String savedToPath(Object label, Object path);

  /// No description provided for @archiveShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Archive saved, but sharing failed: {error}'**
  String archiveShareFailed(Object error);

  /// No description provided for @archiveImportedTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive imported'**
  String get archiveImportedTitle;

  /// No description provided for @memoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get memoriesLabel;

  /// No description provided for @photosLabel.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosLabel;

  /// No description provided for @wallNotesNailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Wall notes / nails'**
  String get wallNotesNailsLabel;

  /// No description provided for @connectionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get connectionsLabel;

  /// No description provided for @archiveImportSummary.
  ///
  /// In en, this message translates to:
  /// **'Your current wall was kept. Imported memories were added safely.'**
  String get archiveImportSummary;

  /// No description provided for @shareEncryptedCapsuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Encrypted Capsule'**
  String get shareEncryptedCapsuleTitle;

  /// No description provided for @openSharedCapsuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Shared Capsule'**
  String get openSharedCapsuleTitle;

  /// No description provided for @exportMemoryCapsuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Memory Capsule'**
  String get exportMemoryCapsuleTitle;

  /// No description provided for @importCapsuleDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Capsule'**
  String get importCapsuleDialogTitle;

  /// No description provided for @secureSharePasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Create a password before uploading this capsule. Send the password separately to the person receiving it.'**
  String get secureSharePasswordBody;

  /// No description provided for @sharedCapsulePasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the password you received for this shared memory.'**
  String get sharedCapsulePasswordBody;

  /// No description provided for @capsuleExportBody.
  ///
  /// In en, this message translates to:
  /// **'Add a password if this memory should be protected before you send it. Leave empty for a normal capsule.'**
  String get capsuleExportBody;

  /// No description provided for @capsuleImportBody.
  ///
  /// In en, this message translates to:
  /// **'If this capsule has a password, enter it. Otherwise leave empty.'**
  String get capsuleImportBody;

  /// No description provided for @capsulePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Capsule password'**
  String get capsulePasswordLabel;

  /// No description provided for @sharedCapsulePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared capsule password'**
  String get sharedCapsulePasswordLabel;

  /// No description provided for @capsulePasswordOptional.
  ///
  /// In en, this message translates to:
  /// **'Capsule password (optional)'**
  String get capsulePasswordOptional;

  /// No description provided for @capsulePasswordWarning.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads cannot recover this password later.'**
  String get capsulePasswordWarning;

  /// No description provided for @passwordRequiredCloudSharing.
  ///
  /// In en, this message translates to:
  /// **'Password is required for cloud sharing.'**
  String get passwordRequiredCloudSharing;

  /// No description provided for @createSecureShare.
  ///
  /// In en, this message translates to:
  /// **'Create Secure Share'**
  String get createSecureShare;

  /// No description provided for @previewMemory.
  ///
  /// In en, this message translates to:
  /// **'Preview Memory'**
  String get previewMemory;

  /// No description provided for @sendCapsuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Share LifeThreads memory'**
  String get sendCapsuleTitle;

  /// No description provided for @sendCapsuleSubject.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads memory capsule'**
  String get sendCapsuleSubject;

  /// No description provided for @sendEncryptedCapsuleText.
  ///
  /// In en, this message translates to:
  /// **'Hey, I shared a protected LifeThreads memory with you. Use the password I sent you to import it.'**
  String get sendEncryptedCapsuleText;

  /// No description provided for @sendCapsuleText.
  ///
  /// In en, this message translates to:
  /// **'Hey, I shared a LifeThreads memory with you. Import the capsule in LifeThreads to add it to your wall.'**
  String get sendCapsuleText;

  /// No description provided for @capsuleReadyToSend.
  ///
  /// In en, this message translates to:
  /// **'Capsule ready to send.'**
  String get capsuleReadyToSend;

  /// No description provided for @capsuleSavedLater.
  ///
  /// In en, this message translates to:
  /// **'Capsule saved. You can share it later.'**
  String get capsuleSavedLater;

  /// No description provided for @capsuleSharingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Capsule saved, but sharing is unavailable.'**
  String get capsuleSharingUnavailable;

  /// No description provided for @capsuleShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Capsule saved, but sharing failed: {error}'**
  String capsuleShareFailed(Object error);

  /// No description provided for @importThisMemory.
  ///
  /// In en, this message translates to:
  /// **'Import this memory?'**
  String get importThisMemory;

  /// No description provided for @noStoryTextIncluded.
  ///
  /// In en, this message translates to:
  /// **'No story text included.'**
  String get noStoryTextIncluded;

  /// No description provided for @placeLabel.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get placeLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @capsulePasswordProtected.
  ///
  /// In en, this message translates to:
  /// **'This capsule was password-protected.'**
  String get capsulePasswordProtected;

  /// No description provided for @openingSharedMemory.
  ///
  /// In en, this message translates to:
  /// **'Opening shared memory...'**
  String get openingSharedMemory;

  /// No description provided for @lifeThreadsMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads memory'**
  String get lifeThreadsMemoryTitle;

  /// No description provided for @shareMemoryText.
  ///
  /// In en, this message translates to:
  /// **'Hey, I shared a memory with you in LifeThreads.\n\n{url}'**
  String shareMemoryText(Object url);

  /// No description provided for @shareLinkReady.
  ///
  /// In en, this message translates to:
  /// **'Share link ready.'**
  String get shareLinkReady;

  /// No description provided for @shareLinkCreated.
  ///
  /// In en, this message translates to:
  /// **'Share link created.'**
  String get shareLinkCreated;

  /// No description provided for @shareLinkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Share link created, but sharing is unavailable.'**
  String get shareLinkUnavailable;

  /// No description provided for @shareLinkExpiresDelete.
  ///
  /// In en, this message translates to:
  /// **'{label} Link expires automatically. You can delete it now.'**
  String shareLinkExpiresDelete(Object label);

  /// No description provided for @cloudShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Cloud share failed: {message}'**
  String cloudShareFailed(Object message);

  /// No description provided for @sharedMemoryLinkDeleted.
  ///
  /// In en, this message translates to:
  /// **'Shared memory link deleted.'**
  String get sharedMemoryLinkDeleted;

  /// No description provided for @creatingSecureMemoryLink.
  ///
  /// In en, this message translates to:
  /// **'Creating secure memory link...'**
  String get creatingSecureMemoryLink;

  /// No description provided for @shareMemoryCapsule.
  ///
  /// In en, this message translates to:
  /// **'Share Memory Capsule'**
  String get shareMemoryCapsule;

  /// No description provided for @editStory.
  ///
  /// In en, this message translates to:
  /// **'Edit story'**
  String get editStory;

  /// No description provided for @metaType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get metaType;

  /// No description provided for @metaFeeling.
  ///
  /// In en, this message translates to:
  /// **'Feeling'**
  String get metaFeeling;

  /// No description provided for @metaCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get metaCategory;

  /// No description provided for @metaDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get metaDate;

  /// No description provided for @storyEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get storyEyebrow;

  /// No description provided for @whyMemoryMatters.
  ///
  /// In en, this message translates to:
  /// **'Why this memory matters'**
  String get whyMemoryMatters;

  /// No description provided for @galleryEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryEyebrow;

  /// No description provided for @savedPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} saved photo(s)'**
  String savedPhotosTitle(int count);

  /// No description provided for @peopleEyebrow.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleEyebrow;

  /// No description provided for @partOfMemory.
  ///
  /// In en, this message translates to:
  /// **'Part of this memory'**
  String get partOfMemory;

  /// No description provided for @notesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesEyebrow;

  /// No description provided for @attachedThoughts.
  ///
  /// In en, this message translates to:
  /// **'Attached thoughts'**
  String get attachedThoughts;

  /// No description provided for @stickyNote.
  ///
  /// In en, this message translates to:
  /// **'Sticky note'**
  String get stickyNote;

  /// No description provided for @placeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get placeEyebrow;

  /// No description provided for @threadsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Threads'**
  String get threadsEyebrow;

  /// No description provided for @connectedMemories.
  ///
  /// In en, this message translates to:
  /// **'Connected memories'**
  String get connectedMemories;

  /// No description provided for @noConnectedMemoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No connected memories yet. Connect this chapter to another moment to start a visible life thread.'**
  String get noConnectedMemoriesYet;

  /// No description provided for @backToWall.
  ///
  /// In en, this message translates to:
  /// **'Back to wall'**
  String get backToWall;

  /// No description provided for @addTextToWall.
  ///
  /// In en, this message translates to:
  /// **'Add text to wall'**
  String get addTextToWall;

  /// No description provided for @addTextAction.
  ///
  /// In en, this message translates to:
  /// **'Add Text'**
  String get addTextAction;

  /// No description provided for @textNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Write a small memory, quote, or note...'**
  String get textNoteHint;

  /// No description provided for @placeTextNote.
  ///
  /// In en, this message translates to:
  /// **'Place text note'**
  String get placeTextNote;

  /// No description provided for @placeRopeAnchor.
  ///
  /// In en, this message translates to:
  /// **'Place rope anchor'**
  String get placeRopeAnchor;

  /// No description provided for @nailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A nail can connect ropes manually between memories.'**
  String get nailSubtitle;

  /// No description provided for @clearDemoWallQuestion.
  ///
  /// In en, this message translates to:
  /// **'Clear demo wall?'**
  String get clearDemoWallQuestion;

  /// No description provided for @clearDemoWallBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the sample memories so you can start with an empty private wall.'**
  String get clearDemoWallBody;

  /// No description provided for @importBackupQuestion.
  ///
  /// In en, this message translates to:
  /// **'Import backup?'**
  String get importBackupQuestion;

  /// No description provided for @importBackupBody.
  ///
  /// In en, this message translates to:
  /// **'This restores memories from a LifeThreads archive and keeps your current wall.'**
  String get importBackupBody;

  /// No description provided for @deleteMemoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete memory?'**
  String get deleteMemoryQuestion;

  /// No description provided for @deleteMemoryBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the memory and all its wall links.'**
  String get deleteMemoryBody;

  /// No description provided for @editText.
  ///
  /// In en, this message translates to:
  /// **'Edit text'**
  String get editText;

  /// No description provided for @editTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Text'**
  String get editTextTitle;

  /// No description provided for @connectRope.
  ///
  /// In en, this message translates to:
  /// **'Connect rope'**
  String get connectRope;

  /// No description provided for @connectRopeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Attach this nail to memories.'**
  String get connectRopeSubtitle;

  /// No description provided for @deleteNail.
  ///
  /// In en, this message translates to:
  /// **'Delete nail'**
  String get deleteNail;

  /// No description provided for @connectNailTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect nail to memories'**
  String get connectNailTitle;

  /// No description provided for @connectNailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Selected memories will hang from this anchor.'**
  String get connectNailSubtitle;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineTitle;

  /// No description provided for @timelineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your memories ordered by time.'**
  String get timelineSubtitle;

  /// No description provided for @noMemoriesFilter.
  ///
  /// In en, this message translates to:
  /// **'No memories in this filter'**
  String get noMemoriesFilter;

  /// No description provided for @noMemoriesFilterBody.
  ///
  /// In en, this message translates to:
  /// **'Switch filter or add a memory to build the timeline.'**
  String get noMemoriesFilterBody;

  /// No description provided for @memoryMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory Map'**
  String get memoryMapTitle;

  /// No description provided for @memoryMapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your memories grouped by place.'**
  String get memoryMapSubtitle;

  /// No description provided for @noMappedMemories.
  ///
  /// In en, this message translates to:
  /// **'No mapped memories yet'**
  String get noMappedMemories;

  /// No description provided for @headerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your memories, hanging together.'**
  String get headerSubtitle;

  /// No description provided for @importBackupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get importBackupTooltip;

  /// No description provided for @exportBackupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackupTooltip;

  /// No description provided for @displayWallTooltip.
  ///
  /// In en, this message translates to:
  /// **'Display wall'**
  String get displayWallTooltip;

  /// No description provided for @tutorialTooltip.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorialTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @hideControlsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide controls'**
  String get hideControlsTooltip;

  /// No description provided for @freeformLayout.
  ///
  /// In en, this message translates to:
  /// **'Freeform'**
  String get freeformLayout;

  /// No description provided for @categoryLayout.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLayout;

  /// No description provided for @locationLayout.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLayout;

  /// No description provided for @wallControls.
  ///
  /// In en, this message translates to:
  /// **'Wall Controls'**
  String get wallControls;

  /// No description provided for @saveToday.
  ///
  /// In en, this message translates to:
  /// **'Save today'**
  String get saveToday;

  /// No description provided for @rememberThis.
  ///
  /// In en, this message translates to:
  /// **'Remember this'**
  String get rememberThis;

  /// No description provided for @whatHappenedToday.
  ///
  /// In en, this message translates to:
  /// **'What happened today?'**
  String get whatHappenedToday;

  /// No description provided for @tapToOpenDrag.
  ///
  /// In en, this message translates to:
  /// **'Tap to open • drag to move'**
  String get tapToOpenDrag;

  /// No description provided for @demoWallPreview.
  ///
  /// In en, this message translates to:
  /// **'Demo wall preview. Clear it when you are ready to start fresh.'**
  String get demoWallPreview;

  /// No description provided for @clearDemo.
  ///
  /// In en, this message translates to:
  /// **'Clear demo'**
  String get clearDemo;

  /// No description provided for @chooseQuickPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose quick photo'**
  String get chooseQuickPhoto;

  /// No description provided for @wallView.
  ///
  /// In en, this message translates to:
  /// **'Wall'**
  String get wallView;

  /// No description provided for @timelineView.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineView;

  /// No description provided for @mapView.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapView;

  /// No description provided for @wallFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get wallFilterAll;

  /// No description provided for @expandableMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get expandableMemory;

  /// No description provided for @expandableMemorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full guided story'**
  String get expandableMemorySubtitle;

  /// No description provided for @expandableQuickPhoto.
  ///
  /// In en, this message translates to:
  /// **'Quick photo memory'**
  String get expandableQuickPhoto;

  /// No description provided for @expandableQuickPhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick photo and hang it'**
  String get expandableQuickPhotoSubtitle;

  /// No description provided for @expandableTextNote.
  ///
  /// In en, this message translates to:
  /// **'Text note'**
  String get expandableTextNote;

  /// No description provided for @expandableTextNoteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Small thought on wall'**
  String get expandableTextNoteSubtitle;

  /// No description provided for @expandableNail.
  ///
  /// In en, this message translates to:
  /// **'Nail / rope anchor'**
  String get expandableNail;

  /// No description provided for @expandableNailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manual rope point'**
  String get expandableNailSubtitle;

  /// No description provided for @startWithOneThing.
  ///
  /// In en, this message translates to:
  /// **'Start with one thing from today'**
  String get startWithOneThing;

  /// No description provided for @emptyWallBody.
  ///
  /// In en, this message translates to:
  /// **'Save a moment before it fades. A sentence or a photo is enough.'**
  String get emptyWallBody;

  /// No description provided for @usePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use a photo'**
  String get usePhoto;

  /// No description provided for @editMemoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit memory'**
  String get editMemoryTooltip;

  /// No description provided for @connectMemoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Connect memory'**
  String get connectMemoryTooltip;

  /// No description provided for @archiveTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Open on another device'**
  String get archiveTransferTitle;

  /// No description provided for @archiveTransferHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Move your memories between devices safely.'**
  String get archiveTransferHeroTitle;

  /// No description provided for @archiveTransferHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Premium Archive creates a portable encrypted zip with your memories, photos, notes, ropes, wall positions, and metadata. Cloud Sync can also store that locked zip on your VPS for restore on another device.'**
  String get archiveTransferHeroBody;

  /// No description provided for @archiveTransferStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Export an archive'**
  String get archiveTransferStep1Title;

  /// No description provided for @archiveTransferStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Open Settings, choose Export Archive, and add a password if you want password protection.'**
  String get archiveTransferStep1Body;

  /// No description provided for @archiveTransferStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Move or sync the zip'**
  String get archiveTransferStep2Title;

  /// No description provided for @archiveTransferStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Transfer it with AirDrop, USB, Drive, email, or use Cloud Sync with a private sync key.'**
  String get archiveTransferStep2Body;

  /// No description provided for @archiveTransferStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Import safely'**
  String get archiveTransferStep3Title;

  /// No description provided for @archiveTransferStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Install LifeThreads on the other device, choose Import Archive, enter the password if needed, and restore without deleting existing data.'**
  String get archiveTransferStep3Body;

  /// No description provided for @premiumPageTitle.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads Premium'**
  String get premiumPageTitle;

  /// No description provided for @developmentUnlockEnabled.
  ///
  /// In en, this message translates to:
  /// **'Development lifetime unlock enabled.'**
  String get developmentUnlockEnabled;

  /// No description provided for @lifetimeActive.
  ///
  /// In en, this message translates to:
  /// **'Lifetime active'**
  String get lifetimeActive;

  /// No description provided for @oneTimeLifetimeUnlock.
  ///
  /// In en, this message translates to:
  /// **'One-time lifetime unlock'**
  String get oneTimeLifetimeUnlock;

  /// No description provided for @premiumHeroActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Your memory wall is unlimited.'**
  String get premiumHeroActiveTitle;

  /// No description provided for @premiumHeroLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Move your memories between devices safely.'**
  String get premiumHeroLockedTitle;

  /// No description provided for @premiumHeroActiveBody.
  ///
  /// In en, this message translates to:
  /// **'Premium lifetime unlock is active. Encrypted archive export, premium themes, and advanced layouts are available.'**
  String get premiumHeroActiveBody;

  /// No description provided for @premiumHeroLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Free includes {limit} memories. Premium adds encrypted archive export/import, safe device transfer, themes, and advanced layouts.'**
  String premiumHeroLockedBody(int limit);

  /// No description provided for @premiumMemories.
  ///
  /// In en, this message translates to:
  /// **'Premium memories'**
  String get premiumMemories;

  /// No description provided for @freeMemories.
  ///
  /// In en, this message translates to:
  /// **'Free memories'**
  String get freeMemories;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'unlimited'**
  String get unlimited;

  /// No description provided for @benefitUnlimitedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited memories'**
  String get benefitUnlimitedTitle;

  /// No description provided for @benefitUnlimitedBody.
  ///
  /// In en, this message translates to:
  /// **'No 30-memory ceiling. Keep building the wall as life grows.'**
  String get benefitUnlimitedBody;

  /// No description provided for @benefitArchivesTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted archives'**
  String get benefitArchivesTitle;

  /// No description provided for @benefitArchivesBody.
  ///
  /// In en, this message translates to:
  /// **'Export and import a password-protected zip with photos, notes, ropes, layout, and metadata.'**
  String get benefitArchivesBody;

  /// No description provided for @benefitTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to another device'**
  String get benefitTransferTitle;

  /// No description provided for @benefitTransferBody.
  ///
  /// In en, this message translates to:
  /// **'Carry your private memory wall to a new phone without active cloud sync.'**
  String get benefitTransferBody;

  /// No description provided for @benefitThemesTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium wall themes'**
  String get benefitThemesTitle;

  /// No description provided for @benefitThemesBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock richer wall moods for family, travel, archive, and gallery styles.'**
  String get benefitThemesBody;

  /// No description provided for @benefitLayoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced layouts'**
  String get benefitLayoutsTitle;

  /// No description provided for @benefitLayoutsBody.
  ///
  /// In en, this message translates to:
  /// **'More ways to arrange threads, timelines, anchors, and memory clusters.'**
  String get benefitLayoutsBody;

  /// No description provided for @cloudSyncPlannedTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is planned later'**
  String get cloudSyncPlannedTitle;

  /// No description provided for @cloudSyncPlannedBody.
  ///
  /// In en, this message translates to:
  /// **'Premium Archive is the safe transfer feature now: export, move the zip, and import on another device.'**
  String get cloudSyncPlannedBody;

  /// No description provided for @deviceTransferHow.
  ///
  /// In en, this message translates to:
  /// **'How device transfer works'**
  String get deviceTransferHow;

  /// No description provided for @lifetimeUnlock.
  ///
  /// In en, this message translates to:
  /// **'Lifetime unlock'**
  String get lifetimeUnlock;

  /// No description provided for @premiumActiveOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Premium is active on this device.'**
  String get premiumActiveOnDevice;

  /// No description provided for @onePurchaseBody.
  ///
  /// In en, this message translates to:
  /// **'One purchase. No monthly subscription for the first premium version. Keep, protect, and move your memory wall.'**
  String get onePurchaseBody;

  /// No description provided for @premiumActiveButton.
  ///
  /// In en, this message translates to:
  /// **'Premium Active'**
  String get premiumActiveButton;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @unlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get unlockPremium;

  /// No description provided for @restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get restorePurchase;

  /// No description provided for @enableDebugMockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Enable debug mock unlock'**
  String get enableDebugMockUnlock;

  /// No description provided for @purchasesHandledByGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Purchases are handled by Google Play. The unlock is stored locally after purchase or restore.'**
  String get purchasesHandledByGooglePlay;

  /// No description provided for @lifetimeUnlockWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Lifetime unlock • {price}'**
  String lifetimeUnlockWithPrice(Object price);

  /// No description provided for @loadingPlayStoreProduct.
  ///
  /// In en, this message translates to:
  /// **'Loading Play Store product...'**
  String get loadingPlayStoreProduct;

  /// No description provided for @playStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Play Store unavailable'**
  String get playStoreUnavailable;

  /// No description provided for @productNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Product not configured'**
  String get productNotConfigured;

  /// No description provided for @purchasePending.
  ///
  /// In en, this message translates to:
  /// **'Purchase pending'**
  String get purchasePending;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @restored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restored;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get purchaseFailed;

  /// No description provided for @preparingCheckout.
  ///
  /// In en, this message translates to:
  /// **'Preparing checkout...'**
  String get preparingCheckout;

  /// No description provided for @premiumLocalFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium is local-first'**
  String get premiumLocalFirstTitle;

  /// No description provided for @premiumLocalFirstBody.
  ///
  /// In en, this message translates to:
  /// **'Premium unlocks local-first value now. Cloud sync is planned later and is not active in this version.'**
  String get premiumLocalFirstBody;

  /// No description provided for @noMappedMemoriesBody.
  ///
  /// In en, this message translates to:
  /// **'Add photos that contain GPS metadata to see memories here.'**
  String get noMappedMemoriesBody;

  /// No description provided for @peopleLabel.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleLabel;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @themeWarmMemoryRoom.
  ///
  /// In en, this message translates to:
  /// **'Warm Memory Room'**
  String get themeWarmMemoryRoom;

  /// No description provided for @themeWarmMemoryRoomDescription.
  ///
  /// In en, this message translates to:
  /// **'Soft dark warmth, gold light, and private-room depth.'**
  String get themeWarmMemoryRoomDescription;

  /// No description provided for @themeMidnightArchive.
  ///
  /// In en, this message translates to:
  /// **'Midnight Archive'**
  String get themeMidnightArchive;

  /// No description provided for @themeMidnightArchiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Deep blue archive room with quiet museum-like focus.'**
  String get themeMidnightArchiveDescription;

  /// No description provided for @themeSoftPaperWall.
  ///
  /// In en, this message translates to:
  /// **'Soft Paper Wall'**
  String get themeSoftPaperWall;

  /// No description provided for @themeSoftPaperWallDescription.
  ///
  /// In en, this message translates to:
  /// **'Cream paper, ink shadows, and calm scrapbook feeling.'**
  String get themeSoftPaperWallDescription;

  /// No description provided for @themeTravelCorkboard.
  ///
  /// In en, this message translates to:
  /// **'Travel Corkboard'**
  String get themeTravelCorkboard;

  /// No description provided for @themeTravelCorkboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Corkboard warmth with map-grid hints for trips and places.'**
  String get themeTravelCorkboardDescription;

  /// No description provided for @demoViennaTitle.
  ///
  /// In en, this message translates to:
  /// **'Vienna evening walk'**
  String get demoViennaTitle;

  /// No description provided for @demoViennaDescription.
  ///
  /// In en, this message translates to:
  /// **'A quiet evening in Vienna, the kind of moment that stays warm because nothing needed to be perfect.'**
  String get demoViennaDescription;

  /// No description provided for @demoViennaLocation.
  ///
  /// In en, this message translates to:
  /// **'Vienna, Austria'**
  String get demoViennaLocation;

  /// No description provided for @demoLinzTitle.
  ///
  /// In en, this message translates to:
  /// **'Rain and coffee'**
  String get demoLinzTitle;

  /// No description provided for @demoLinzDescription.
  ///
  /// In en, this message translates to:
  /// **'A slow Linz afternoon with coffee, rain on the windows, and one photo that feels like home.'**
  String get demoLinzDescription;

  /// No description provided for @demoLinzLocation.
  ///
  /// In en, this message translates to:
  /// **'Linz, Austria'**
  String get demoLinzLocation;

  /// No description provided for @demoFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family table'**
  String get demoFamilyTitle;

  /// No description provided for @demoFamilyDescription.
  ///
  /// In en, this message translates to:
  /// **'Food, noise, small jokes, and the feeling that this is what should be remembered.'**
  String get demoFamilyDescription;

  /// No description provided for @demoHomeLocation.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get demoHomeLocation;

  /// No description provided for @demoLaunchTitle.
  ///
  /// In en, this message translates to:
  /// **'First launch night'**
  String get demoLaunchTitle;

  /// No description provided for @demoLaunchDescription.
  ///
  /// In en, this message translates to:
  /// **'The night an idea finally became something real on a screen.'**
  String get demoLaunchDescription;

  /// No description provided for @demoConnectionQuietDays.
  ///
  /// In en, this message translates to:
  /// **'quiet days'**
  String get demoConnectionQuietDays;

  /// No description provided for @demoConnectionHomeFocus.
  ///
  /// In en, this message translates to:
  /// **'home focus'**
  String get demoConnectionHomeFocus;

  /// No description provided for @demoConnectionWhyItMatters.
  ///
  /// In en, this message translates to:
  /// **'why it matters'**
  String get demoConnectionWhyItMatters;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
