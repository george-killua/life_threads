# Google Play Closed Testing Pipeline

## What This Pipeline Does

- Builds LifeThreads as a signed release Android App Bundle.
- Injects `MAPTILER_KEY` through `--dart-define`.
- Uploads the `.aab` to Google Play closed testing.
- Does not commit API keys, service-account JSON, or keystore files.

## Required Google Play Setup

1. Open Google Play Console.
2. Create the LifeThreads app with package `dev.gkcoding.lifethreads`.
3. Go to `Setup > API access`.
4. Link or create a Google Cloud project.
5. Create a service account.
6. Grant it app access with release permissions.
7. Download the service-account JSON file.

## Local Upload

```bash
cd /Users/georgekassih/development/Projects/life_threads
bundle install

export MAPTILER_KEY="your-rotated-maptiler-key"
export GOOGLE_PLAY_JSON_KEY_PATH="/absolute/path/to/google-play-service-account.json"
export PLAY_TRACK="alpha"
export PLAY_RELEASE_STATUS="draft"

scripts/play_closed_test_release.sh
```

Use `PLAY_RELEASE_STATUS=completed` only when you want the closed-test release submitted immediately.

## GitHub Actions Upload

Add these repository secrets:

```text
MAPTILER_KEY
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON_BASE64
ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_PASSWORD
ANDROID_KEY_ALIAS
```

Encode secrets:

```bash
base64 -i android/release/lifethreads-release-key.jks | pbcopy
base64 -i /path/to/google-play-service-account.json | pbcopy
```

Then run the `Play Closed Test` workflow manually.

## Safe Defaults

- Default track: `alpha`.
- Default release status: `draft`.
- Metadata, screenshots, and store listing content are not uploaded by Fastlane yet.
- Upload the app bundle first, then complete Play Console forms manually.
