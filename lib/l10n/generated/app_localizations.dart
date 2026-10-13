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
  /// **'LifeThreads is local-first: no account and no public profile. Your memories stay on this device unless you export a backup, share an encrypted capsule, or display your wall on another screen.'**
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

  /// No description provided for @backupArchiveBody.
  ///
  /// In en, this message translates to:
  /// **'Save everything – memories, photos, notes, threads and layout – in one file. Keep it on your computer or in your own cloud, and add a password to encrypt it.'**
  String get backupArchiveBody;

  /// No description provided for @backupArchiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupArchiveTitle;

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
  /// **'Premium subscription is active.'**
  String get premiumActiveBody;

  /// No description provided for @premiumLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Monthly subscription: unlimited memories, premium themes and advanced layouts.'**
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

  /// No description provided for @onboardingPrivacyShort.
  ///
  /// In en, this message translates to:
  /// **'No account and no public profile. Your memories stay on this device unless you choose otherwise.'**
  String get onboardingPrivacyShort;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get onboardingNameHint;

  /// No description provided for @onboardingNiceToMeetYou.
  ///
  /// In en, this message translates to:
  /// **'Nice to meet you, {name}.'**
  String onboardingNiceToMeetYou(String name);

  /// No description provided for @onboardingGetStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how to begin'**
  String get onboardingGetStartedTitle;

  /// No description provided for @onboardingGetStartedBody.
  ///
  /// In en, this message translates to:
  /// **'Preview a sample wall, or start with a blank one and hang your own memories.'**
  String get onboardingGetStartedBody;

  /// No description provided for @wallWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}.'**
  String wallWelcome(String name);

  /// No description provided for @settingsNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get settingsNameTitle;

  /// No description provided for @settingsNameBody.
  ///
  /// In en, this message translates to:
  /// **'Shown as a greeting on your wall.'**
  String get settingsNameBody;

  /// No description provided for @settingsNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get settingsNameHint;

  /// No description provided for @settingsNameSaved.
  ///
  /// In en, this message translates to:
  /// **'Name updated.'**
  String get settingsNameSaved;

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
  /// **'Before you change phones, export a backup in Settings and keep the file somewhere safe.'**
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

  /// No description provided for @takePhotosNow.
  ///
  /// In en, this message translates to:
  /// **'Take photos now'**
  String get takePhotosNow;

  /// No description provided for @takePhotosFabTooltip.
  ///
  /// In en, this message translates to:
  /// **'Take photos for a new memory'**
  String get takePhotosFabTooltip;

  /// No description provided for @takeAnotherPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take another photo'**
  String get takeAnotherPhoto;

  /// No description provided for @continueWithPhotos.
  ///
  /// In en, this message translates to:
  /// **'Continue with these photos'**
  String get continueWithPhotos;

  /// No description provided for @addPhotosToMemory.
  ///
  /// In en, this message translates to:
  /// **'Add to memory'**
  String get addPhotosToMemory;

  /// No description provided for @takeAnotherOrContinueBody.
  ///
  /// In en, this message translates to:
  /// **'Keep shooting for this memory, or continue and add the story.'**
  String get takeAnotherOrContinueBody;

  /// No description provided for @photosCapturedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo captured} other{{count} photos captured}}'**
  String photosCapturedCount(int count);

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

  /// No description provided for @memorySaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save this memory. Please try again.'**
  String get memorySaveFailed;

  /// No description provided for @passwordOnlySpaces.
  ///
  /// In en, this message translates to:
  /// **'A password can\'t be only spaces.'**
  String get passwordOnlySpaces;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @mapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The map isn\'t available right now.'**
  String get mapUnavailable;

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
  /// **'Export backup'**
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
  /// **'Backup ready. Keep it somewhere safe, off this phone.'**
  String get archiveReadyToSend;

  /// No description provided for @archiveNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup not saved. Export again when you are ready.'**
  String get archiveNotSaved;

  /// No description provided for @archiveSharingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sharing is not available on this device.'**
  String get archiveSharingUnavailable;

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
  /// **'A backup is one zip with your memories, photos, notes, threads, wall positions and metadata, optionally locked with a password. We keep no copy: you decide where it goes.'**
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
  /// **'Move the zip'**
  String get archiveTransferStep2Title;

  /// No description provided for @archiveTransferStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Transfer it with AirDrop, USB, your own cloud drive or email.'**
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
  /// **'Development Premium unlock enabled.'**
  String get developmentUnlockEnabled;

  /// No description provided for @lifetimeActive.
  ///
  /// In en, this message translates to:
  /// **'Subscription active'**
  String get lifetimeActive;

  /// No description provided for @oneTimeLifetimeUnlock.
  ///
  /// In en, this message translates to:
  /// **'Monthly subscription'**
  String get oneTimeLifetimeUnlock;

  /// No description provided for @premiumHeroActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Your memory wall is unlimited.'**
  String get premiumHeroActiveTitle;

  /// No description provided for @premiumHeroLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn your memories into stories.'**
  String get premiumHeroLockedTitle;

  /// No description provided for @premiumHeroActiveBody.
  ///
  /// In en, this message translates to:
  /// **'Your Premium subscription is active. Stories with music, Thread of the Year, family walls and unlimited memories are yours.'**
  String get premiumHeroActiveBody;

  /// No description provided for @premiumHeroLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Free includes {limit} memories and full backups. Premium adds stories and films with music, Thread of the Year, family walls and unlimited memories.'**
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

  /// No description provided for @lifetimeUnlock.
  ///
  /// In en, this message translates to:
  /// **'Premium subscription'**
  String get lifetimeUnlock;

  /// No description provided for @premiumActiveOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Premium is active on this device.'**
  String get premiumActiveOnDevice;

  /// No description provided for @onePurchaseBody.
  ///
  /// In en, this message translates to:
  /// **'Subscribe monthly for stories with music, Thread of the Year, family walls and unlimited memories. Cancel anytime in your {store} settings.'**
  String onePurchaseBody(String store);

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
  /// **'Subscribe to Premium'**
  String get unlockPremium;

  /// No description provided for @restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore subscription'**
  String get restorePurchase;

  /// No description provided for @enableDebugMockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Enable debug mock unlock'**
  String get enableDebugMockUnlock;

  /// No description provided for @purchasesHandledByGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Payment is charged to your {store} account. The subscription renews automatically every month unless you cancel it at least 24 hours before the current period ends. Manage or cancel it in your {store} account settings.'**
  String purchasesHandledByGooglePlay(String store);

  /// No description provided for @premiumMessageBillingUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'The store update failed. Please try again.'**
  String get premiumMessageBillingUpdateFailed;

  /// No description provided for @premiumMessageStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Purchases are not available on this device.'**
  String get premiumMessageStoreUnavailable;

  /// No description provided for @premiumMessageProductUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Premium is not available in the store yet. Please try again later.'**
  String get premiumMessageProductUnavailable;

  /// No description provided for @premiumMessageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Premium could not be loaded from the store. Please try again.'**
  String get premiumMessageLoadFailed;

  /// No description provided for @premiumMessageOpeningCheckout.
  ///
  /// In en, this message translates to:
  /// **'Opening the checkout…'**
  String get premiumMessageOpeningCheckout;

  /// No description provided for @premiumMessageCheckoutFailed.
  ///
  /// In en, this message translates to:
  /// **'The checkout could not be opened. Please try again.'**
  String get premiumMessageCheckoutFailed;

  /// No description provided for @premiumMessageChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking your subscription…'**
  String get premiumMessageChecking;

  /// No description provided for @premiumMessageRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restoring failed. Please try again.'**
  String get premiumMessageRestoreFailed;

  /// No description provided for @premiumMessageNoSubscriptionFound.
  ///
  /// In en, this message translates to:
  /// **'No active Premium subscription was found.'**
  String get premiumMessageNoSubscriptionFound;

  /// No description provided for @premiumMessagePending.
  ///
  /// In en, this message translates to:
  /// **'Your purchase is pending. Premium unlocks once it is approved.'**
  String get premiumMessagePending;

  /// No description provided for @premiumMessagePurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'The purchase did not go through. Please try again.'**
  String get premiumMessagePurchaseFailed;

  /// No description provided for @premiumMessageCanceled.
  ///
  /// In en, this message translates to:
  /// **'Purchase canceled.'**
  String get premiumMessageCanceled;

  /// No description provided for @premiumMessageRestored.
  ///
  /// In en, this message translates to:
  /// **'Your Premium subscription is restored.'**
  String get premiumMessageRestored;

  /// No description provided for @premiumMessageActive.
  ///
  /// In en, this message translates to:
  /// **'Your Premium subscription is active.'**
  String get premiumMessageActive;

  /// No description provided for @lifetimeUnlockWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Premium • {price}/month'**
  String lifetimeUnlockWithPrice(Object price);

  /// No description provided for @loadingPlayStoreProduct.
  ///
  /// In en, this message translates to:
  /// **'Loading the subscription…'**
  String get loadingPlayStoreProduct;

  /// No description provided for @playStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The store is unavailable right now'**
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
  /// **'Your memories stay on your device, and backups are free for everyone.'**
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

  /// No description provided for @demoFirstDanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Our first dance'**
  String get demoFirstDanceTitle;

  /// No description provided for @demoFirstDanceStory.
  ///
  /// In en, this message translates to:
  /// **'The band played our song and the whole barn went quiet. I stepped on your foot twice, you laughed through all of it, and for three minutes nobody else was there.'**
  String get demoFirstDanceStory;

  /// No description provided for @demoFirstDancePlace.
  ///
  /// In en, this message translates to:
  /// **'Salzburg'**
  String get demoFirstDancePlace;

  /// No description provided for @demoNewbornTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome home, Lina'**
  String get demoNewbornTitle;

  /// No description provided for @demoNewbornStory.
  ///
  /// In en, this message translates to:
  /// **'Her whole hand fit around one finger. The first quiet morning at home.'**
  String get demoNewbornStory;

  /// No description provided for @demoNewbornPlace.
  ///
  /// In en, this message translates to:
  /// **'Vienna'**
  String get demoNewbornPlace;

  /// No description provided for @demoBeachSunsetTitle.
  ///
  /// In en, this message translates to:
  /// **'Summer by the sea'**
  String get demoBeachSunsetTitle;

  /// No description provided for @demoBeachSunsetStory.
  ///
  /// In en, this message translates to:
  /// **'Barefoot until the sun went down, Lina asleep on your shoulders on the way back.'**
  String get demoBeachSunsetStory;

  /// No description provided for @demoBeachSunsetPlace.
  ///
  /// In en, this message translates to:
  /// **'Split, Croatia'**
  String get demoBeachSunsetPlace;

  /// No description provided for @demoGrandmaKitchenTitle.
  ///
  /// In en, this message translates to:
  /// **'Grandma\'s kitchen'**
  String get demoGrandmaKitchenTitle;

  /// No description provided for @demoGrandmaKitchenStory.
  ///
  /// In en, this message translates to:
  /// **'Her apricot cake, finally written down – and flour everywhere.'**
  String get demoGrandmaKitchenStory;

  /// No description provided for @demoGrandmaKitchenPlace.
  ///
  /// In en, this message translates to:
  /// **'Graz'**
  String get demoGrandmaKitchenPlace;

  /// No description provided for @demoGraduationTitle.
  ///
  /// In en, this message translates to:
  /// **'Graduation day'**
  String get demoGraduationTitle;

  /// No description provided for @demoGraduationStory.
  ///
  /// In en, this message translates to:
  /// **'Dad cried before the caps even landed.'**
  String get demoGraduationStory;

  /// No description provided for @demoGraduationPlace.
  ///
  /// In en, this message translates to:
  /// **'Innsbruck'**
  String get demoGraduationPlace;

  /// No description provided for @demoFirstHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Keys to our first home'**
  String get demoFirstHomeTitle;

  /// No description provided for @demoFirstHomeStory.
  ///
  /// In en, this message translates to:
  /// **'No furniture yet, just boxes, pizza on the floor and a lot of plans.'**
  String get demoFirstHomeStory;

  /// No description provided for @demoFirstHomePlace.
  ///
  /// In en, this message translates to:
  /// **'Linz'**
  String get demoFirstHomePlace;

  /// No description provided for @demoAlpineSummitTitle.
  ///
  /// In en, this message translates to:
  /// **'Above the clouds'**
  String get demoAlpineSummitTitle;

  /// No description provided for @demoAlpineSummitStory.
  ///
  /// In en, this message translates to:
  /// **'Up at 4 a.m. for this. Worth every step.'**
  String get demoAlpineSummitStory;

  /// No description provided for @demoAlpineSummitPlace.
  ///
  /// In en, this message translates to:
  /// **'Grossglockner'**
  String get demoAlpineSummitPlace;

  /// No description provided for @demoFirstBikeTitle.
  ///
  /// In en, this message translates to:
  /// **'First ride, no hands'**
  String get demoFirstBikeTitle;

  /// No description provided for @demoFirstBikeStory.
  ///
  /// In en, this message translates to:
  /// **'Three steps, a wobble, then he was gone – and so proud.'**
  String get demoFirstBikeStory;

  /// No description provided for @demoFirstBikePlace.
  ///
  /// In en, this message translates to:
  /// **'Prater, Vienna'**
  String get demoFirstBikePlace;

  /// No description provided for @demoGardenDinnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Grandpa\'s 80th'**
  String get demoGardenDinnerTitle;

  /// No description provided for @demoGardenDinnerStory.
  ///
  /// In en, this message translates to:
  /// **'Four generations at one long table, and he still told the best stories.'**
  String get demoGardenDinnerStory;

  /// No description provided for @demoGardenDinnerPlace.
  ///
  /// In en, this message translates to:
  /// **'Wachau'**
  String get demoGardenDinnerPlace;

  /// No description provided for @demoThreadFirstDanceToFirstHome.
  ///
  /// In en, this message translates to:
  /// **'Our story'**
  String get demoThreadFirstDanceToFirstHome;

  /// No description provided for @demoThreadFirstHomeToNewborn.
  ///
  /// In en, this message translates to:
  /// **'Then came Lina'**
  String get demoThreadFirstHomeToNewborn;

  /// No description provided for @demoThreadNewbornToBeachSunset.
  ///
  /// In en, this message translates to:
  /// **'Her first summer'**
  String get demoThreadNewbornToBeachSunset;

  /// No description provided for @demoThreadGrandmaKitchenToGardenDinner.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get demoThreadGrandmaKitchenToGardenDinner;

  /// No description provided for @demoThreadGraduationToFirstHome.
  ///
  /// In en, this message translates to:
  /// **'New chapter'**
  String get demoThreadGraduationToFirstHome;

  /// No description provided for @demoThreadAlpineSummitToFirstBike.
  ///
  /// In en, this message translates to:
  /// **'Little adventures'**
  String get demoThreadAlpineSummitToFirstBike;

  /// No description provided for @demoThreadFirstBikeToGardenDinner.
  ///
  /// In en, this message translates to:
  /// **'Grandpa watched'**
  String get demoThreadFirstBikeToGardenDinner;

  /// No description provided for @demoRelationGrandpa.
  ///
  /// In en, this message translates to:
  /// **'Grandpa'**
  String get demoRelationGrandpa;

  /// No description provided for @demoRelationGrandma.
  ///
  /// In en, this message translates to:
  /// **'Grandma'**
  String get demoRelationGrandma;

  /// No description provided for @demoRelationDaughter.
  ///
  /// In en, this message translates to:
  /// **'Daughter'**
  String get demoRelationDaughter;

  /// No description provided for @demoRelationWife.
  ///
  /// In en, this message translates to:
  /// **'Wife'**
  String get demoRelationWife;

  /// No description provided for @demoRelationBestMan.
  ///
  /// In en, this message translates to:
  /// **'Best man'**
  String get demoRelationBestMan;

  /// No description provided for @demoRelationMother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get demoRelationMother;

  /// No description provided for @savedToPath.
  ///
  /// In en, this message translates to:
  /// **'{label} Saved to {path}'**
  String savedToPath(Object label, Object path);

  /// No description provided for @backupReminder.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 memory is not in a backup yet.} other{{count} memories are not in a backup yet.}}'**
  String backupReminder(int count);

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @backUp.
  ///
  /// In en, this message translates to:
  /// **'Back up'**
  String get backUp;

  /// No description provided for @onThisDayTitle.
  ///
  /// In en, this message translates to:
  /// **'On this day'**
  String get onThisDayTitle;

  /// No description provided for @onThisDayYearsAgoToday.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, =1{1 year ago today} other{{years} years ago today}}'**
  String onThisDayYearsAgoToday(int years);

  /// No description provided for @onThisDayHeader.
  ///
  /// In en, this message translates to:
  /// **'On this day · {years, plural, =1{1 year ago} other{{years} years ago}}'**
  String onThisDayHeader(int years);

  /// No description provided for @onThisDaySettingsBody.
  ///
  /// In en, this message translates to:
  /// **'On days when a memory from an earlier year comes back, LifeThreads sends one quiet reminder.'**
  String get onThisDaySettingsBody;

  /// No description provided for @onThisDayReminderSwitch.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get onThisDayReminderSwitch;

  /// No description provided for @onThisDayReminderAt.
  ///
  /// In en, this message translates to:
  /// **'At {time}'**
  String onThisDayReminderAt(String time);

  /// No description provided for @onThisDayNotificationsDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for LifeThreads. Allow them in your phone\'s settings.'**
  String get onThisDayNotificationsDenied;

  /// No description provided for @onThisDayNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, =1{1 year ago today: {title}} other{{years} years ago today: {title}}}'**
  String onThisDayNotificationBody(int years, String title);

  /// No description provided for @onThisDayNotificationBodyMany.
  ///
  /// In en, this message translates to:
  /// **'{title} and {count, plural, =1{1 more memory} other{{count} more memories}} from this day'**
  String onThisDayNotificationBodyMany(int count, String title);

  /// No description provided for @onThisDayChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'A memory from this day in an earlier year.'**
  String get onThisDayChannelDescription;

  /// No description provided for @benefitOnThisDayBody.
  ///
  /// In en, this message translates to:
  /// **'A reminder when a memory from an earlier year comes back, opened as its own chapter.'**
  String get benefitOnThisDayBody;

  /// No description provided for @premiumFeatureStoryImage.
  ///
  /// In en, this message translates to:
  /// **'Story images'**
  String get premiumFeatureStoryImage;

  /// No description provided for @premiumFeatureStoryVideo.
  ///
  /// In en, this message translates to:
  /// **'Story videos'**
  String get premiumFeatureStoryVideo;

  /// No description provided for @premiumFeatureThreadOfTheYear.
  ///
  /// In en, this message translates to:
  /// **'Thread of the Year'**
  String get premiumFeatureThreadOfTheYear;

  /// No description provided for @premiumFeatureFamilyWall.
  ///
  /// In en, this message translates to:
  /// **'Family wall'**
  String get premiumFeatureFamilyWall;

  /// No description provided for @premiumFeatureNotice.
  ///
  /// In en, this message translates to:
  /// **'{feature} is part of Premium.'**
  String premiumFeatureNotice(String feature);

  /// No description provided for @yearThreadTitle.
  ///
  /// In en, this message translates to:
  /// **'Thread of the Year'**
  String get yearThreadTitle;

  /// No description provided for @yearThreadMemories.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 memory} other{{count} memories}}'**
  String yearThreadMemories(int count);

  /// No description provided for @yearThreadPlaces.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 place} other{{count} places}}'**
  String yearThreadPlaces(int count);

  /// No description provided for @yearThreadPeople.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}}'**
  String yearThreadPeople(int count);

  /// No description provided for @yearThreadMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String yearThreadMonths(int count);

  /// No description provided for @yearThreadMostFelt.
  ///
  /// In en, this message translates to:
  /// **'Most felt: {feeling}'**
  String yearThreadMostFelt(String feeling);

  /// No description provided for @yearThreadClosingLine.
  ///
  /// In en, this message translates to:
  /// **'A year, threaded.'**
  String get yearThreadClosingLine;

  /// No description provided for @yearThreadMyYear.
  ///
  /// In en, this message translates to:
  /// **'My year'**
  String get yearThreadMyYear;

  /// No description provided for @yearThreadWallCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your year in memories'**
  String get yearThreadWallCardTitle;

  /// No description provided for @yearThreadWallCardBody.
  ///
  /// In en, this message translates to:
  /// **'Turn {year} into a short film.'**
  String yearThreadWallCardBody(String year);

  /// No description provided for @yearThreadDismiss.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get yearThreadDismiss;

  /// No description provided for @yearThreadSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Turn any year with at least 3 memories into a short film, told in order and joined by the thread.'**
  String get yearThreadSettingsBody;

  /// No description provided for @yearThreadOpen.
  ///
  /// In en, this message translates to:
  /// **'Make the film'**
  String get yearThreadOpen;

  /// No description provided for @yearThreadNoYears.
  ///
  /// In en, this message translates to:
  /// **'Thread of the Year needs a year with at least 3 memories. Keep saving moments and come back.'**
  String get yearThreadNoYears;

  /// No description provided for @yearThreadYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearThreadYear;

  /// No description provided for @yearThreadLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get yearThreadLength;

  /// No description provided for @yearThreadLengthFull.
  ///
  /// In en, this message translates to:
  /// **'Film · {seconds} s'**
  String yearThreadLengthFull(int seconds);

  /// No description provided for @yearThreadLengthStory.
  ///
  /// In en, this message translates to:
  /// **'Story · 20 s'**
  String get yearThreadLengthStory;

  /// No description provided for @yearThreadMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get yearThreadMusic;

  /// No description provided for @yearThreadNoMusic.
  ///
  /// In en, this message translates to:
  /// **'No music'**
  String get yearThreadNoMusic;

  /// No description provided for @yearThreadInFilm.
  ///
  /// In en, this message translates to:
  /// **'In the film'**
  String get yearThreadInFilm;

  /// No description provided for @yearThreadInFilmCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max}'**
  String yearThreadInFilmCount(int count, int max);

  /// No description provided for @yearThreadAddMemory.
  ///
  /// In en, this message translates to:
  /// **'Add a memory'**
  String get yearThreadAddMemory;

  /// No description provided for @yearThreadSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get yearThreadSwap;

  /// No description provided for @yearThreadRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get yearThreadRemove;

  /// No description provided for @yearThreadUseSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Use suggestions'**
  String get yearThreadUseSuggestions;

  /// No description provided for @yearThreadPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a memory from {year}'**
  String yearThreadPickTitle(String year);

  /// No description provided for @yearThreadNoOthers.
  ///
  /// In en, this message translates to:
  /// **'Every memory from this year is already in the film.'**
  String get yearThreadNoOthers;

  /// No description provided for @yearThreadNeedMore.
  ///
  /// In en, this message translates to:
  /// **'Choose at least {count, plural, =1{1 memory} other{{count} memories}}.'**
  String yearThreadNeedMore(int count);

  /// No description provided for @yearThreadPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get yearThreadPreview;

  /// No description provided for @yearThreadExportVideo.
  ///
  /// In en, this message translates to:
  /// **'Export video'**
  String get yearThreadExportVideo;

  /// No description provided for @yearThreadExportImage.
  ///
  /// In en, this message translates to:
  /// **'Export image'**
  String get yearThreadExportImage;

  /// No description provided for @yearThreadShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get yearThreadShare;

  /// No description provided for @yearThreadSave.
  ///
  /// In en, this message translates to:
  /// **'Save to Photos'**
  String get yearThreadSave;

  /// No description provided for @yearThreadMakingFilm.
  ///
  /// In en, this message translates to:
  /// **'Making your film…'**
  String get yearThreadMakingFilm;

  /// No description provided for @yearThreadMakingImage.
  ///
  /// In en, this message translates to:
  /// **'Making your image…'**
  String get yearThreadMakingImage;

  /// No description provided for @yearThreadFilmReady.
  ///
  /// In en, this message translates to:
  /// **'Your film is ready'**
  String get yearThreadFilmReady;

  /// No description provided for @yearThreadImageReady.
  ///
  /// In en, this message translates to:
  /// **'Your image is ready'**
  String get yearThreadImageReady;

  /// No description provided for @yearThreadSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to your photos.'**
  String get yearThreadSaved;

  /// No description provided for @yearThreadExportFailed.
  ///
  /// In en, this message translates to:
  /// **'That did not work. Please try again.'**
  String get yearThreadExportFailed;

  /// No description provided for @yearThreadPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get yearThreadPlay;

  /// No description provided for @yearThreadPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get yearThreadPause;

  /// No description provided for @createStory.
  ///
  /// In en, this message translates to:
  /// **'Create story'**
  String get createStory;

  /// No description provided for @storyPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose memories'**
  String get storyPickTitle;

  /// No description provided for @storyPickBody.
  ///
  /// In en, this message translates to:
  /// **'Pick up to {max} memories for one story.'**
  String storyPickBody(int max);

  /// No description provided for @storyPickCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} chosen'**
  String storyPickCount(int count, int max);

  /// No description provided for @storyPickLimit.
  ///
  /// In en, this message translates to:
  /// **'A story holds up to {max} memories.'**
  String storyPickLimit(int max);

  /// No description provided for @storyPickContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get storyPickContinue;

  /// No description provided for @storyNoMemories.
  ///
  /// In en, this message translates to:
  /// **'Save a memory first, then turn it into a story.'**
  String get storyNoMemories;

  /// No description provided for @storyEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Your story'**
  String get storyEditorTitle;

  /// No description provided for @storyChangeMemories.
  ///
  /// In en, this message translates to:
  /// **'Change memories'**
  String get storyChangeMemories;

  /// No description provided for @storyTemplateSingle.
  ///
  /// In en, this message translates to:
  /// **'Single memory'**
  String get storyTemplateSingle;

  /// No description provided for @storyTemplateThread.
  ///
  /// In en, this message translates to:
  /// **'Thread'**
  String get storyTemplateThread;

  /// No description provided for @storyTemplateCollage.
  ///
  /// In en, this message translates to:
  /// **'Collage'**
  String get storyTemplateCollage;

  /// No description provided for @storyTemplateQuote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get storyTemplateQuote;

  /// No description provided for @storySwipeHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe for another look'**
  String get storySwipeHint;

  /// No description provided for @storyCaptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Caption'**
  String get storyCaptionLabel;

  /// No description provided for @storyCaptionHint.
  ///
  /// In en, this message translates to:
  /// **'One line of your story'**
  String get storyCaptionHint;

  /// No description provided for @storyVideoSwitch.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get storyVideoSwitch;

  /// No description provided for @storyVideoBody.
  ///
  /// In en, this message translates to:
  /// **'A short film for Stories and Reels: photos drift, the thread draws itself, titles fade in.'**
  String get storyVideoBody;

  /// No description provided for @storyMusicTitle.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get storyMusicTitle;

  /// No description provided for @storyMusicNone.
  ///
  /// In en, this message translates to:
  /// **'No music'**
  String get storyMusicNone;

  /// No description provided for @storyMusicNoneHint.
  ///
  /// In en, this message translates to:
  /// **'You can add a song from Instagram\'s music library when you post the story.'**
  String get storyMusicNoneHint;

  /// No description provided for @storyMoodWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get storyMoodWarm;

  /// No description provided for @storyMoodJoyful.
  ///
  /// In en, this message translates to:
  /// **'Joyful'**
  String get storyMoodJoyful;

  /// No description provided for @storyMoodCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get storyMoodCalm;

  /// No description provided for @storyMoodNostalgic.
  ///
  /// In en, this message translates to:
  /// **'Nostalgic'**
  String get storyMoodNostalgic;

  /// No description provided for @storyMoodEpic.
  ///
  /// In en, this message translates to:
  /// **'Epic'**
  String get storyMoodEpic;

  /// No description provided for @storyMoodEmotional.
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get storyMoodEmotional;

  /// No description provided for @storyMusicTrimHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to choose which part plays'**
  String get storyMusicTrimHint;

  /// No description provided for @storySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search memories, places, years'**
  String get storySearchHint;

  /// No description provided for @storySearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No memory matches “{query}”.'**
  String storySearchEmpty(String query);

  /// No description provided for @storyMemoriesInStory.
  ///
  /// In en, this message translates to:
  /// **'In your story'**
  String get storyMemoriesInStory;

  /// No description provided for @storyMemoriesReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Hold and drag to change the order'**
  String get storyMemoriesReorderHint;

  /// No description provided for @storyAddMemory.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get storyAddMemory;

  /// No description provided for @storyAddMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a memory'**
  String get storyAddMemoryTitle;

  /// No description provided for @storyRemoveMemory.
  ///
  /// In en, this message translates to:
  /// **'Remove {title} from the story'**
  String storyRemoveMemory(String title);

  /// No description provided for @storyAllMemoriesAdded.
  ///
  /// In en, this message translates to:
  /// **'Every memory is already in this story.'**
  String get storyAllMemoriesAdded;

  /// No description provided for @storyShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get storyShare;

  /// No description provided for @storySaveToPhotos.
  ///
  /// In en, this message translates to:
  /// **'Save to Photos'**
  String get storySaveToPhotos;

  /// No description provided for @storySaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to your photos.'**
  String get storySaved;

  /// No description provided for @storySaveDenied.
  ///
  /// In en, this message translates to:
  /// **'LifeThreads may not add to your photos. Allow it in your phone\'s settings.'**
  String get storySaveDenied;

  /// No description provided for @storyExportFailed.
  ///
  /// In en, this message translates to:
  /// **'The story could not be created: {error}'**
  String storyExportFailed(String error);

  /// No description provided for @storyRenderingTitle.
  ///
  /// In en, this message translates to:
  /// **'Making your film'**
  String get storyRenderingTitle;

  /// No description provided for @storyRenderingBody.
  ///
  /// In en, this message translates to:
  /// **'Keep LifeThreads open, this takes a few seconds.'**
  String get storyRenderingBody;

  /// No description provided for @storyRenderingPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent} %'**
  String storyRenderingPercent(int percent);

  /// No description provided for @storyPreviewFree.
  ///
  /// In en, this message translates to:
  /// **'The preview is free. Sharing and saving stories are part of Premium.'**
  String get storyPreviewFree;

  /// No description provided for @benefitStoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Story'**
  String get benefitStoriesTitle;

  /// No description provided for @benefitStoriesBody.
  ///
  /// In en, this message translates to:
  /// **'Turn memories into story images and short films with music for Instagram, WhatsApp and more.'**
  String get benefitStoriesBody;

  /// No description provided for @musicCreditsTitle.
  ///
  /// In en, this message translates to:
  /// **'Music credits'**
  String get musicCreditsTitle;

  /// No description provided for @musicCreditsBody.
  ///
  /// In en, this message translates to:
  /// **'Songs bundled for story videos, with their licences.'**
  String get musicCreditsBody;

  /// No description provided for @musicCreditLine.
  ///
  /// In en, this message translates to:
  /// **'{title} · {artist} · {license}'**
  String musicCreditLine(String title, String artist, String license);

  /// No description provided for @benefitYearThreadBody.
  ///
  /// In en, this message translates to:
  /// **'Your year as a short film: the moments that mattered, threaded in order, with music.'**
  String get benefitYearThreadBody;

  /// No description provided for @benefitFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family walls'**
  String get benefitFamilyTitle;

  /// No description provided for @benefitFamilyBody.
  ///
  /// In en, this message translates to:
  /// **'A shared wall for your family, end-to-end encrypted. Everyone adds their moments.'**
  String get benefitFamilyBody;

  /// No description provided for @myWall.
  ///
  /// In en, this message translates to:
  /// **'My wall'**
  String get myWall;

  /// No description provided for @myWallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Private, on this device'**
  String get myWallSubtitle;

  /// No description provided for @switchWall.
  ///
  /// In en, this message translates to:
  /// **'Switch wall'**
  String get switchWall;

  /// No description provided for @familyWallsTitle.
  ///
  /// In en, this message translates to:
  /// **'Family walls'**
  String get familyWallsTitle;

  /// No description provided for @familyWallsSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Share one wall with family or friends: everyone adds memories, end-to-end encrypted. My wall stays private on this device.'**
  String get familyWallsSettingsBody;

  /// No description provided for @familyWallsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open family walls'**
  String get familyWallsOpen;

  /// No description provided for @familyWallsManage.
  ///
  /// In en, this message translates to:
  /// **'Manage family walls'**
  String get familyWallsManage;

  /// No description provided for @familyWallsHeadline.
  ///
  /// In en, this message translates to:
  /// **'One wall, the whole family'**
  String get familyWallsHeadline;

  /// No description provided for @familyWallsIntro.
  ///
  /// In en, this message translates to:
  /// **'A family wall is shared with the people you invite. Memories and photos are encrypted on your phone before they are uploaded; only members can open them. My wall is not shared and stays on this device.'**
  String get familyWallsIntro;

  /// No description provided for @familyUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Not available yet'**
  String get familyUnavailableTitle;

  /// No description provided for @familyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Family walls are not available in this version of LifeThreads yet.'**
  String get familyUnavailable;

  /// No description provided for @familySignInNeededTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to use family walls'**
  String get familySignInNeededTitle;

  /// No description provided for @familySignInNeededBody.
  ///
  /// In en, this message translates to:
  /// **'A shared wall needs an account so the family knows who added what. My wall works without one.'**
  String get familySignInNeededBody;

  /// No description provided for @familySignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get familySignIn;

  /// No description provided for @familyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load'**
  String get familyLoadFailed;

  /// No description provided for @familyRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get familyRetry;

  /// No description provided for @familyNoWallsYet.
  ///
  /// In en, this message translates to:
  /// **'No family walls yet. Start one or join with an invite link.'**
  String get familyNoWallsYet;

  /// No description provided for @familyStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start or join'**
  String get familyStartTitle;

  /// No description provided for @familyStartBody.
  ///
  /// In en, this message translates to:
  /// **'Starting a family wall needs Premium. Joining one is free: the owner\'s Premium covers the family.'**
  String get familyStartBody;

  /// No description provided for @familyCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create family wall'**
  String get familyCreateAction;

  /// No description provided for @familyCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New family wall'**
  String get familyCreateTitle;

  /// No description provided for @familyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of the wall'**
  String get familyNameLabel;

  /// No description provided for @familyNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. The Millers'**
  String get familyNameHint;

  /// No description provided for @familyMyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name on this wall'**
  String get familyMyNameLabel;

  /// No description provided for @familyMyNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Members see it on your memories. It is encrypted like everything on the wall.'**
  String get familyMyNameHelper;

  /// No description provided for @familyMyNameSaved.
  ///
  /// In en, this message translates to:
  /// **'Name saved.'**
  String get familyMyNameSaved;

  /// No description provided for @familySetMyName.
  ///
  /// In en, this message translates to:
  /// **'My name'**
  String get familySetMyName;

  /// No description provided for @familyCheckingSubscription.
  ///
  /// In en, this message translates to:
  /// **'Checking your Premium…'**
  String get familyCheckingSubscription;

  /// No description provided for @familyCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating the wall…'**
  String get familyCreating;

  /// No description provided for @familyJoinWithLink.
  ///
  /// In en, this message translates to:
  /// **'Join with link'**
  String get familyJoinWithLink;

  /// No description provided for @familyInviteLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite link'**
  String get familyInviteLinkLabel;

  /// No description provided for @familyJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join this family wall?'**
  String get familyJoinTitle;

  /// No description provided for @familyJoinBody.
  ///
  /// In en, this message translates to:
  /// **'Members will see your name and the memories you add, and you will see theirs. You can leave at any time.'**
  String get familyJoinBody;

  /// No description provided for @familyJoinAction.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get familyJoinAction;

  /// No description provided for @familyJoining.
  ///
  /// In en, this message translates to:
  /// **'Joining…'**
  String get familyJoining;

  /// No description provided for @familyJoined.
  ///
  /// In en, this message translates to:
  /// **'You joined {family}.'**
  String familyJoined(String family);

  /// No description provided for @familyRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get familyRoleOwner;

  /// No description provided for @familyRoleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get familyRoleMember;

  /// No description provided for @familyMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String familyMemberCount(int count);

  /// No description provided for @familySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Wall settings'**
  String get familySettingsTitle;

  /// No description provided for @familyStorageUsed.
  ///
  /// In en, this message translates to:
  /// **'{used} of {total} used'**
  String familyStorageUsed(String used, String total);

  /// No description provided for @familyRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get familyRename;

  /// No description provided for @familyInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get familyInviteTitle;

  /// No description provided for @familyInviteBody.
  ///
  /// In en, this message translates to:
  /// **'Send a link to someone you trust. Each link works once and expires after 7 days.'**
  String get familyInviteBody;

  /// No description provided for @familyInviteAction.
  ///
  /// In en, this message translates to:
  /// **'Create invite link'**
  String get familyInviteAction;

  /// No description provided for @familyCreatingInvite.
  ///
  /// In en, this message translates to:
  /// **'Creating the invite…'**
  String get familyCreatingInvite;

  /// No description provided for @familyInviteReady.
  ///
  /// In en, this message translates to:
  /// **'Invite link ready'**
  String get familyInviteReady;

  /// No description provided for @familyInviteValidity.
  ///
  /// In en, this message translates to:
  /// **'Works once and expires after 7 days at the latest.'**
  String get familyInviteValidity;

  /// No description provided for @familyInviteKeyWarning.
  ///
  /// In en, this message translates to:
  /// **'The link carries the wall\'s key: whoever opens it can join and read the wall. Send it only to the person you invite.'**
  String get familyInviteKeyWarning;

  /// No description provided for @familyInviteShare.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get familyInviteShare;

  /// No description provided for @familyInviteCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get familyInviteCopy;

  /// No description provided for @familyInviteCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied.'**
  String get familyInviteCopied;

  /// No description provided for @familyInviteShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Sharing is not available. Copy the link instead.'**
  String get familyInviteShareFailed;

  /// No description provided for @familyInviteSubject.
  ///
  /// In en, this message translates to:
  /// **'Join {family} on LifeThreads'**
  String familyInviteSubject(String family);

  /// No description provided for @familyInviteText.
  ///
  /// In en, this message translates to:
  /// **'Join our family wall \"{family}\" on LifeThreads: {link}'**
  String familyInviteText(String family, String link);

  /// No description provided for @familyMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get familyMembersTitle;

  /// No description provided for @familyMemberActions.
  ///
  /// In en, this message translates to:
  /// **'Member actions'**
  String get familyMemberActions;

  /// No description provided for @familyYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get familyYou;

  /// No description provided for @familyYouNamed.
  ///
  /// In en, this message translates to:
  /// **'{name} (you)'**
  String familyYouNamed(String name);

  /// No description provided for @familyAMember.
  ///
  /// In en, this message translates to:
  /// **'A member'**
  String get familyAMember;

  /// No description provided for @familyFormerMember.
  ///
  /// In en, this message translates to:
  /// **'Former member'**
  String get familyFormerMember;

  /// No description provided for @familyBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get familyBlocked;

  /// No description provided for @familyBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get familyBlock;

  /// No description provided for @familyUnblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get familyUnblock;

  /// No description provided for @familyBlockAuthor.
  ///
  /// In en, this message translates to:
  /// **'Block {name}'**
  String familyBlockAuthor(String name);

  /// No description provided for @familyBlockQuestion.
  ///
  /// In en, this message translates to:
  /// **'Block {name}?'**
  String familyBlockQuestion(String name);

  /// No description provided for @familyBlockBody.
  ///
  /// In en, this message translates to:
  /// **'You will no longer see their memories on any family wall. They are not told. You can unblock them in the members list.'**
  String get familyBlockBody;

  /// No description provided for @familyReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get familyReport;

  /// No description provided for @familyRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Remove from wall'**
  String get familyRemoveMember;

  /// No description provided for @familyRemoveQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String familyRemoveQuestion(String name);

  /// No description provided for @familyRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'They lose access to this wall. Invite them again to bring them back.'**
  String get familyRemoveBody;

  /// No description provided for @familyRemoveDeleteContent.
  ///
  /// In en, this message translates to:
  /// **'Also delete the memories they added'**
  String get familyRemoveDeleteContent;

  /// No description provided for @familyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete family wall'**
  String get familyDeleteTitle;

  /// No description provided for @familyDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'As the owner you cannot leave the wall; you can delete it for everyone.'**
  String get familyDeleteBody;

  /// No description provided for @familyDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete wall'**
  String get familyDeleteAction;

  /// No description provided for @familyDeleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete {family}?'**
  String familyDeleteQuestion(String family);

  /// No description provided for @familyDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'All memories and photos on this wall are deleted from our servers for every member. This cannot be undone. Memories on My wall are not affected.'**
  String get familyDeleteConfirmBody;

  /// No description provided for @familyDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get familyDeleting;

  /// No description provided for @familyLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave family wall'**
  String get familyLeaveTitle;

  /// No description provided for @familyLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'You stop seeing this wall. You can keep or delete the memories you added.'**
  String get familyLeaveBody;

  /// No description provided for @familyLeaveAction.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get familyLeaveAction;

  /// No description provided for @familyLeaveQuestion.
  ///
  /// In en, this message translates to:
  /// **'Leave {family}?'**
  String familyLeaveQuestion(String family);

  /// No description provided for @familyLeaveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'To come back you need a new invite.'**
  String get familyLeaveConfirmBody;

  /// No description provided for @familyLeaveDeleteMine.
  ///
  /// In en, this message translates to:
  /// **'Also delete the memories I added'**
  String get familyLeaveDeleteMine;

  /// No description provided for @familyLeaving.
  ///
  /// In en, this message translates to:
  /// **'Leaving…'**
  String get familyLeaving;

  /// No description provided for @familySignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get familySignInTitle;

  /// No description provided for @familySignInHeadline.
  ///
  /// In en, this message translates to:
  /// **'An account for family walls'**
  String get familySignInHeadline;

  /// No description provided for @familySignInWhy.
  ///
  /// In en, this message translates to:
  /// **'A family wall is shared, so it needs an account: members see who added each memory, and only members can open the wall.'**
  String get familySignInWhy;

  /// No description provided for @familySignInMyWallStays.
  ///
  /// In en, this message translates to:
  /// **'My wall needs no account. It stays private on this device and is never uploaded.'**
  String get familySignInMyWallStays;

  /// No description provided for @familySignInEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Family memories and photos are end-to-end encrypted. GK Coding stores them but cannot read them.'**
  String get familySignInEncrypted;

  /// No description provided for @familySignInWhatWeGet.
  ///
  /// In en, this message translates to:
  /// **'From Apple or Google we only use an account ID, not your contacts or photos.'**
  String get familySignInWhatWeGet;

  /// No description provided for @familySignInApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get familySignInApple;

  /// No description provided for @familySignInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get familySignInGoogle;

  /// No description provided for @familySignInFinePrint.
  ///
  /// In en, this message translates to:
  /// **'By signing in you agree to the Terms of Use and the Privacy Policy. You can delete your account in the app at any time.'**
  String get familySignInFinePrint;

  /// No description provided for @familyAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get familyAccountTitle;

  /// No description provided for @familySignedOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get familySignedOutTitle;

  /// No description provided for @familySignedOutBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your family walls. My wall works without an account.'**
  String get familySignedOutBody;

  /// No description provided for @familySignedInTitle.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get familySignedInTitle;

  /// No description provided for @familySignedInBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is used only for family walls.'**
  String get familySignedInBody;

  /// No description provided for @familyAccountId.
  ///
  /// In en, this message translates to:
  /// **'Account ID: {id}'**
  String familyAccountId(String id);

  /// No description provided for @familySignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get familySignOut;

  /// No description provided for @familySignOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get familySignOutQuestion;

  /// No description provided for @familySignOutBody.
  ///
  /// In en, this message translates to:
  /// **'Family walls and their keys are removed from this device until you sign in again. Nothing is deleted on the server. My wall is not affected.'**
  String get familySignOutBody;

  /// No description provided for @familySigningOut.
  ///
  /// In en, this message translates to:
  /// **'Signing out…'**
  String get familySigningOut;

  /// No description provided for @familyDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get familyDeleteAccountTitle;

  /// No description provided for @familyDeleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Deletes your account and your family wall data from our servers. My wall stays on this device.'**
  String get familyDeleteAccountBody;

  /// No description provided for @familyDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get familyDeleteAccount;

  /// No description provided for @familyDeleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get familyDeleteAccountQuestion;

  /// No description provided for @familyDeleteAccountOwned.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{You own no family wall.} =1{The family wall you own is deleted for all its members, with every memory and photo on it.} other{The {count} family walls you own are deleted for all their members, with every memory and photo on them.}}'**
  String familyDeleteAccountOwned(int count);

  /// No description provided for @familyDeleteAccountPosts.
  ///
  /// In en, this message translates to:
  /// **'The memories and photos you added to other families\' walls are deleted, and you leave those walls.'**
  String get familyDeleteAccountPosts;

  /// No description provided for @familyDeleteAccountKeys.
  ///
  /// In en, this message translates to:
  /// **'Family wall keys and cached photos are removed from this device. This cannot be undone.'**
  String get familyDeleteAccountKeys;

  /// No description provided for @familyDeleteAccountMyWall.
  ///
  /// In en, this message translates to:
  /// **'My wall is not affected: its memories stay on this device.'**
  String get familyDeleteAccountMyWall;

  /// No description provided for @familyDeleteAccountSubscription.
  ///
  /// In en, this message translates to:
  /// **'A Premium subscription is not cancelled by this; manage it in the App Store or Google Play.'**
  String get familyDeleteAccountSubscription;

  /// No description provided for @familyDeleteAccountUnderstood.
  ///
  /// In en, this message translates to:
  /// **'I understand that this deletes my account for good.'**
  String get familyDeleteAccountUnderstood;

  /// No description provided for @familyDeletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account…'**
  String get familyDeletingAccount;

  /// No description provided for @familyAccountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account was deleted.'**
  String get familyAccountDeleted;

  /// No description provided for @familyTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Family wall rules'**
  String get familyTermsTitle;

  /// No description provided for @familyTermsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Before you share'**
  String get familyTermsHeadline;

  /// No description provided for @familyTermsIntro.
  ///
  /// In en, this message translates to:
  /// **'Family walls are for the people you invite. To keep them safe, everyone accepts these rules:'**
  String get familyTermsIntro;

  /// No description provided for @familyTermsZeroTolerance.
  ///
  /// In en, this message translates to:
  /// **'Zero tolerance for objectionable content: no harassment, hate, sexual content, violence, self-harm, illegal content, or other people\'s private information without their consent.'**
  String get familyTermsZeroTolerance;

  /// No description provided for @familyTermsOwnContent.
  ///
  /// In en, this message translates to:
  /// **'Share only photos and stories you are allowed to share.'**
  String get familyTermsOwnContent;

  /// No description provided for @familyTermsReport.
  ///
  /// In en, this message translates to:
  /// **'Report any memory or member from the wall. GK Coding reviews reports within 24 hours.'**
  String get familyTermsReport;

  /// No description provided for @familyTermsBlock.
  ///
  /// In en, this message translates to:
  /// **'Block a member to stop seeing their memories.'**
  String get familyTermsBlock;

  /// No description provided for @familyTermsOwner.
  ///
  /// In en, this message translates to:
  /// **'The owner of a wall can remove members and their memories.'**
  String get familyTermsOwner;

  /// No description provided for @familyTermsConsequences.
  ///
  /// In en, this message translates to:
  /// **'Content that breaks these rules is removed, and the accounts that posted it can be suspended or deleted.'**
  String get familyTermsConsequences;

  /// No description provided for @familyTermsReadFull.
  ///
  /// In en, this message translates to:
  /// **'Read the full terms'**
  String get familyTermsReadFull;

  /// No description provided for @familyTermsAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Use and these rules.'**
  String get familyTermsAgree;

  /// No description provided for @familyTermsAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept and continue'**
  String get familyTermsAccept;

  /// No description provided for @familyTermsVersion.
  ///
  /// In en, this message translates to:
  /// **'Terms version {version}'**
  String familyTermsVersion(String version);

  /// No description provided for @familyWallEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'The wall is waiting'**
  String get familyWallEmptyTitle;

  /// No description provided for @familyWallEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add the first memory. Everyone on this wall will see it.'**
  String get familyWallEmptyBody;

  /// No description provided for @familyWallGoneBody.
  ///
  /// In en, this message translates to:
  /// **'This family wall is no longer available to you. It may have been deleted, or you were removed.'**
  String get familyWallGoneBody;

  /// No description provided for @familyAddMemory.
  ///
  /// In en, this message translates to:
  /// **'Add memory'**
  String get familyAddMemory;

  /// No description provided for @familyRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get familyRefresh;

  /// No description provided for @familySyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get familySyncing;

  /// No description provided for @familyOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline: showing saved memories'**
  String get familyOffline;

  /// No description provided for @familySyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get familySyncFailed;

  /// No description provided for @familyMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get familyMemoryTitle;

  /// No description provided for @familyMemoryGone.
  ///
  /// In en, this message translates to:
  /// **'This memory is no longer on the wall.'**
  String get familyMemoryGone;

  /// No description provided for @familyMemoryActions.
  ///
  /// In en, this message translates to:
  /// **'Memory actions'**
  String get familyMemoryActions;

  /// No description provided for @familyAddedBy.
  ///
  /// In en, this message translates to:
  /// **'Added by {name}'**
  String familyAddedBy(String name);

  /// No description provided for @familyDeleteMemoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this memory?'**
  String get familyDeleteMemoryQuestion;

  /// No description provided for @familyDeleteMemoryBody.
  ///
  /// In en, this message translates to:
  /// **'It is removed from the wall for everyone, with its photos.'**
  String get familyDeleteMemoryBody;

  /// No description provided for @familyDeleteMemoryAsOwnerBody.
  ///
  /// In en, this message translates to:
  /// **'As the owner you can remove memories from this wall. This memory by {name} is removed for everyone, with its photos.'**
  String familyDeleteMemoryAsOwnerBody(String name);

  /// No description provided for @familyDeletingMemory.
  ///
  /// In en, this message translates to:
  /// **'Deleting the memory…'**
  String get familyDeletingMemory;

  /// No description provided for @familyNoPhotosYet.
  ///
  /// In en, this message translates to:
  /// **'No photos yet'**
  String get familyNoPhotosYet;

  /// No description provided for @familyPostNote.
  ///
  /// In en, this message translates to:
  /// **'Everyone on this wall will see this memory. Photos are resized and encrypted on your phone before upload.'**
  String get familyPostNote;

  /// No description provided for @familyPostMemory.
  ///
  /// In en, this message translates to:
  /// **'Post to the wall'**
  String get familyPostMemory;

  /// No description provided for @familyUploading.
  ///
  /// In en, this message translates to:
  /// **'Encrypting and uploading…'**
  String get familyUploading;

  /// No description provided for @familyMemorySaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to the family wall.'**
  String get familyMemorySaved;

  /// No description provided for @familyConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Changed by someone else'**
  String get familyConflictTitle;

  /// No description provided for @familyConflictBody.
  ///
  /// In en, this message translates to:
  /// **'This memory changed on another device while you were editing. Load the latest version and save your changes over it?'**
  String get familyConflictBody;

  /// No description provided for @familyConflictRetry.
  ///
  /// In en, this message translates to:
  /// **'Refresh and save'**
  String get familyConflictRetry;

  /// No description provided for @familyQuotaTitle.
  ///
  /// In en, this message translates to:
  /// **'The wall is full'**
  String get familyQuotaTitle;

  /// No description provided for @familyReportMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Report memory'**
  String get familyReportMemoryTitle;

  /// No description provided for @familyReportPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Report photo'**
  String get familyReportPhotoTitle;

  /// No description provided for @familyReportMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Report member'**
  String get familyReportMemberTitle;

  /// No description provided for @familyReportIntro.
  ///
  /// In en, this message translates to:
  /// **'Tell us what is wrong. Your report goes to GK Coding, not to the person you report.'**
  String get familyReportIntro;

  /// No description provided for @familyReportSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam or scam'**
  String get familyReportSpam;

  /// No description provided for @familyReportHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment or bullying'**
  String get familyReportHarassment;

  /// No description provided for @familyReportHate.
  ///
  /// In en, this message translates to:
  /// **'Hate speech'**
  String get familyReportHate;

  /// No description provided for @familyReportSexual.
  ///
  /// In en, this message translates to:
  /// **'Sexual content or nudity'**
  String get familyReportSexual;

  /// No description provided for @familyReportViolence.
  ///
  /// In en, this message translates to:
  /// **'Violence or threats'**
  String get familyReportViolence;

  /// No description provided for @familyReportSelfHarm.
  ///
  /// In en, this message translates to:
  /// **'Self-harm or suicide'**
  String get familyReportSelfHarm;

  /// No description provided for @familyReportIllegal.
  ///
  /// In en, this message translates to:
  /// **'Illegal content'**
  String get familyReportIllegal;

  /// No description provided for @familyReportPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Private information shared without consent'**
  String get familyReportPrivacy;

  /// No description provided for @familyReportOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get familyReportOther;

  /// No description provided for @familyReportDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Details (optional)'**
  String get familyReportDetailsLabel;

  /// No description provided for @familyReportDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'What should we know?'**
  String get familyReportDetailsHint;

  /// No description provided for @familyReportAlsoBlock.
  ///
  /// In en, this message translates to:
  /// **'Also block {name}'**
  String familyReportAlsoBlock(String name);

  /// No description provided for @familyReportSend.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get familyReportSend;

  /// No description provided for @familyReportReviewNote.
  ///
  /// In en, this message translates to:
  /// **'GK Coding reviews every report within 24 hours and removes content and members that break the rules.'**
  String get familyReportReviewNote;

  /// No description provided for @familyReportSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get familyReportSentTitle;

  /// No description provided for @familyReportSentBody.
  ///
  /// In en, this message translates to:
  /// **'Your report was sent. GK Coding reviews it within 24 hours and acts on content that breaks the rules.'**
  String get familyReportSentBody;

  /// No description provided for @familyErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get familyErrorGeneric;

  /// No description provided for @familyErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline. Check your connection and try again.'**
  String get familyErrorOffline;

  /// No description provided for @familyErrorSubscriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'This needs an active Premium subscription of the wall\'s owner.'**
  String get familyErrorSubscriptionRequired;

  /// No description provided for @familyErrorInviteExpired.
  ///
  /// In en, this message translates to:
  /// **'This invite has expired. Ask for a new link.'**
  String get familyErrorInviteExpired;

  /// No description provided for @familyErrorInviteUsed.
  ///
  /// In en, this message translates to:
  /// **'This invite was already used. Each link works once; ask for a new one.'**
  String get familyErrorInviteUsed;

  /// No description provided for @familyErrorInviteInvalid.
  ///
  /// In en, this message translates to:
  /// **'This is not a valid LifeThreads invite link.'**
  String get familyErrorInviteInvalid;

  /// No description provided for @familyErrorAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'You are already a member of this family wall.'**
  String get familyErrorAlreadyMember;

  /// No description provided for @familyErrorFamilyFull.
  ///
  /// In en, this message translates to:
  /// **'This family wall has reached its member limit.'**
  String get familyErrorFamilyFull;

  /// No description provided for @familyErrorQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'This family wall has no storage left. Delete some memories or photos to make room.'**
  String get familyErrorQuotaExceeded;

  /// No description provided for @familyErrorVersionConflict.
  ///
  /// In en, this message translates to:
  /// **'Someone changed this memory first. Refresh and try again.'**
  String get familyErrorVersionConflict;

  /// No description provided for @familyErrorTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the family wall rules first.'**
  String get familyErrorTermsRequired;

  /// No description provided for @familyErrorSignedOut.
  ///
  /// In en, this message translates to:
  /// **'You were signed out. Please sign in again.'**
  String get familyErrorSignedOut;

  /// No description provided for @familyErrorNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to do this on this wall.'**
  String get familyErrorNotAllowed;

  /// No description provided for @familyErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Family wall not found'**
  String get familyErrorNotFound;

  /// No description provided for @familyErrorOwnerCannotLeave.
  ///
  /// In en, this message translates to:
  /// **'The owner cannot leave the wall, but can delete it.'**
  String get familyErrorOwnerCannotLeave;

  /// No description provided for @familyPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get familyPaste;

  /// No description provided for @familyErrorInviteRevoked.
  ///
  /// In en, this message translates to:
  /// **'This invite was withdrawn. Ask for a new link.'**
  String get familyErrorInviteRevoked;

  /// No description provided for @familyErrorKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'This device does not have the key for this family wall (for example after a reinstall or on a new phone). Ask a member for a new invite link: opening it restores access.'**
  String get familyErrorKeyMissing;

  /// No description provided for @familyErrorSignInUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is not available on this device right now.'**
  String get familyErrorSignInUnavailable;

  /// No description provided for @familyErrorNoPurchase.
  ///
  /// In en, this message translates to:
  /// **'No Premium purchase was found for this App Store or Google Play account. Get Premium first, then try again.'**
  String get familyErrorNoPurchase;

  /// No description provided for @familyErrorNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'That name is too long. Please use a shorter one.'**
  String get familyErrorNameTooLong;

  /// No description provided for @familyErrorPhotoUnreadable.
  ///
  /// In en, this message translates to:
  /// **'One of the photos could not be read. Remove it and try again.'**
  String get familyErrorPhotoUnreadable;

  /// No description provided for @familyErrorTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This is too large to upload. Try fewer or smaller photos.'**
  String get familyErrorTooLarge;

  /// No description provided for @familyReportEvidenceNote.
  ///
  /// In en, this message translates to:
  /// **'To review it, GK Coding receives this memory\'s title and story with your report. Its photos are never sent.'**
  String get familyReportEvidenceNote;
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
