# Android Release Notes

## Identity

- App name: LifeThreads
- Application ID: `dev.gkcoding.lifethreads`
- Version source: `pubspec.yaml`
- Current version: `0.1.0+1`

## Release Build

The Android release build is configured in `android/app/build.gradle.kts`.

Release signing behavior:
- If `android/key.properties` exists, Gradle signs release builds with the configured keystore.
- If it does not exist, local release builds fall back to debug signing so CI/local verification can still run.
- Do not upload debug-signed artifacts to Google Play.

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

## Privacy-Safe Manifest

Main manifest permissions are intentionally limited:

- `INTERNET`: required for map tiles.
- `READ_MEDIA_IMAGES`: Android 13+ photo picking/import.
- `READ_MEDIA_VISUAL_USER_SELECTED`: Android 14 selected-photo access.
- `READ_EXTERNAL_STORAGE` with `maxSdkVersion=32`: legacy photo access.
- `ACCESS_MEDIA_LOCATION`: optional EXIF GPS metadata from selected photos.

Not requested:

- background location
- contacts
- microphone
- camera
- account access
- broad file write permissions

App backup is disabled with `android:allowBackup="false"` because LifeThreads contains private local memories and has its own manual encrypted-export direction planned.

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
flutter build apk --release
flutter build appbundle --release
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
3. Build the App Bundle with `flutter build appbundle --release`.
4. Verify Play Console package name is `dev.gkcoding.lifethreads`.
5. Create the one-time in-app product `lifethreads_premium_lifetime`.
6. Prepare privacy policy explaining local-first photo/media usage.

Store listing drafts:

```text
docs/play_store_content.md
docs/privacy_policy.md
```
