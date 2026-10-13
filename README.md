# LifeThreads

A private, local-first animated memory wall where photos, places, feelings, and life events become connected visual chapters.

## Concept

LifeThreads turns memories into a living wall: photo cards hang like real prints, related events connect with soft ropes, and the whole wall moves subtly with a calm wind effect.

## Current MVP

- Flutter Android-first app, iOS-ready.
- Android package: `dev.gkcoding.lifethreads`.
- Local-first: no login and no public profile.
- Optional encrypted cloud memory capsules and optional Cloud Sync only when the user chooses them.
- Interactive wall with draggable hanging memory cards, text notes, nails, and rope anchors.
- Emotional step-by-step memory creation flow with gallery pick and camera capture.
- Memory types, feelings, dates, locations, people, and connection reasons.
- Cinematic memory detail chapters with gallery preview, story, metadata, map, and connected thread path.
- Wall, timeline, and map view modes.
- Custom LifeThreads launcher icon for Android and iOS.

## Run

```bash
flutter pub get
flutter run
```

## Releases and store listings

- Store listings, ready to paste, in English, German and Arabic:
  [Google Play](docs/store_listing/google_play.md) and [App Store](docs/store_listing/app_store.md)
  (texts, graphics, subscription, Data safety / App Privacy, review notes, checklists).
- Play closed testing upload: [docs/google_play_closed_testing_pipeline.md](docs/google_play_closed_testing_pipeline.md).
- Family wall setup (sign-in, server, subscription check): [docs/family_wall_setup.md](docs/family_wall_setup.md).
- Privacy policy and terms: [docs/privacy_policy.md](docs/privacy_policy.md), [docs/terms_of_use.md](docs/terms_of_use.md).
- Pricing: [docs/pricing_strategy.md](docs/pricing_strategy.md). Safe logging: [docs/crash_safe_logging.md](docs/crash_safe_logging.md).

Version and build number come from `pubspec.yaml` (`1.0.0+15`). Release signing reads
`android/key.properties` (template: `android/key.properties.example`).

```bash
flutter analyze
flutter test
flutter build appbundle --release   # Google Play
flutter build ipa --release         # App Store / TestFlight
tool/store_screenshots/run.sh       # store screenshots from the real app screens
```

## Architecture

```text
lib/
  app/                  App shell, router, theme
  core/                 Database, extensions, utilities
  features/
    wall/               Animated memory wall
    memories/           Memory models, repository, add/detail UI
    media/              Photo picking, camera capture, local file storage
    map/                Location/map preview
    capsule/            Encrypted memory share capsules
  shared/               Shared widgets and helpers
```

## Product

- Free: 30 memories, wall, timeline and map, full backups in one file, encrypted capsule sharing.
- Premium (monthly subscription `lifethreads_premium_monthly`): unlimited memories, Create Story
  with music, Thread of the Year, On this day and family walls.
- The user's own wall stays on the device; only family walls, capsules and the wall display use
  the server.
