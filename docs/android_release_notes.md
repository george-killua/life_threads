# Android Release Notes

## Identity

- App name: LifeThreads
- Application ID: `dev.gkcoding.lifethreads`
- Version source: `pubspec.yaml`
- Current version: `0.1.4+6`

## Release Build

The Android release build is configured in `android/app/build.gradle.kts`.

Release signing behavior:
- If `android/key.properties` exists, Gradle signs release builds with the configured keystore.
- If it does not exist, local release builds fall back to debug signing so CI/local verification can still run.
- Do not upload debug-signed artifacts to Google Play.

Release shrinking:
- R8 minify and resource shrinking are enabled for release.
- Keep rules live in `android/app/proguard-rules.pro`.

Create `android/key.properties` from:

```text
android/key.properties.example
```

Expected fields:

```properties
storePassword=...
keyPassword=...
keyAlias=lifethreads
storeFile=../release/lifethreads-release-key.jks
```

## MapTiler

Production maps require a MapTiler key at build time:

```bash
flutter build appbundle --release --dart-define=MAPTILER_KEY="$MAPTILER_KEY"
```

Before public release:
1. Rotate the MapTiler key in the MapTiler dashboard (previous key was shared in chat).
2. Update GitHub Actions secret `MAPTILER_KEY` and local shell env.
3. Confirm closed-test and production AABs are built with the rotated key.

Without `MAPTILER_KEY`, release map views show the unavailable panel instead of tiles.

## App Links

Android App Links are declared for:

- `https://gkcoding.dev/lifethreads/share/...`
- `https://lifethreads.gkcoding.dev/share/...`

Verification checklist:

1. Host Digital Asset Links JSON for both hosts pointing at `dev.gkcoding.lifethreads`.
2. Install a release-signed build.
3. Open a fresh share URL from Messages/Chrome and confirm LifeThreads handles it.
4. Confirm Flutter deep linking meta is disabled so `app_links` owns handling (`flutter_deeplinking_enabled=false`).

## Manifest Permissions

Main manifest permissions:

- `INTERNET`: map tiles, Play Billing, optional cloud share/sync
- `CAMERA`: wall-display QR scan and optional memory photo capture
- `READ_CONTACTS`: optional person import from contacts
- `READ_MEDIA_IMAGES`: Android 13+ photo picking/import
- `READ_MEDIA_VISUAL_USER_SELECTED`: Android 14 selected-photo access
- `READ_EXTERNAL_STORAGE` with `maxSdkVersion=32`: legacy photo access
- `ACCESS_MEDIA_LOCATION`: optional EXIF GPS metadata from selected photos

Not requested:

- background location
- microphone
- account access
- broad file write permissions

App backup is disabled with `android:allowBackup="false"` because LifeThreads contains private local memories and has its own encrypted export/share direction.

## Launcher Icon

Launcher resources are configured for:

- legacy mipmap PNG densities
- round icon resources
- Android adaptive icon XML
- Android 12+ splash background

Source icon:

```text
assets/brand/lifethreads_icon.svg
```

## Release Commands

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --release --dart-define=MAPTILER_KEY="$MAPTILER_KEY"
flutter build appbundle --release --dart-define=MAPTILER_KEY="$MAPTILER_KEY"
```

Release outputs:

```text
build/app/outputs/flutter-apk/app-release.apk
build/app/outputs/bundle/release/app-release.aab
```

## Google Play Notes

Before uploading:

1. Create and store the release keystore securely.
2. Add `android/key.properties` locally only.
3. Build the App Bundle with MapTiler dart-define and release keystore.
4. Verify Play Console package name is `dev.gkcoding.lifethreads`.
5. Create the one-time in-app product `lifethreads_premium_monthly`.
6. Complete Data Safety using `docs/play_console_release_candidate_checklist.md`.
7. Link privacy policy and terms:
   - `https://gkcoding.dev/lifethreads/privacy`
   - `https://gkcoding.dev/lifethreads/terms`

Store listing drafts:

```text
docs/play_store_content.md
docs/privacy_policy.md
docs/terms_of_use.md
```
