# LifeThreads

A private, local-first animated memory wall where photos, places, feelings, and life events become connected visual chapters.

## Concept

LifeThreads turns memories into a living wall: photo cards hang like real prints, related events connect with soft ropes, and the whole wall moves subtly with a calm wind effect.

## Current MVP

- Flutter Android-first app, iOS-ready.
- Android package: `dev.gkcoding.lifethreads`.
- Local-first: no login, no public profile, no cloud sync.
- Optional cloud sharing uploads one encrypted memory capsule only when the user chooses it.
- Interactive wall with draggable hanging memory cards, text notes, nails, and rope anchors.
- Emotional step-by-step memory creation flow.
- Memory types, feelings, dates, locations, and connection reasons.
- Cinematic memory detail chapters with gallery preview, story, metadata, map, and connected thread path.
- Wall, timeline, and map view modes.
- Custom LifeThreads launcher icon for Android and iOS.

## Run

```bash
flutter pub get
flutter run
```

## Android Release

Release preparation is documented in [docs/android_release_notes.md](docs/android_release_notes.md).
Google Play listing content is prepared in [docs/play_store_content.md](docs/play_store_content.md), with the privacy policy in [docs/privacy_policy.md](docs/privacy_policy.md).
Closed beta preparation is documented in [docs/closed_beta_checklist.md](docs/closed_beta_checklist.md), with safe logging rules in [docs/crash_safe_logging.md](docs/crash_safe_logging.md).
Launch and monetization planning starts in [docs/launch_checklist.md](docs/launch_checklist.md), [docs/marketing_30_day_plan.md](docs/marketing_30_day_plan.md), and [docs/pricing_strategy.md](docs/pricing_strategy.md).

Current Android release setup:
- App name: `LifeThreads`
- Package: `dev.gkcoding.lifethreads`
- Privacy-safe manifest with no background location, contacts, microphone, or account permissions.
- Media permissions are limited to selected photo import and optional EXIF location metadata.
- Release signing reads `android/key.properties` when available. Use `android/key.properties.example` as the template.

Build checks:

```bash
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
```

## Architecture

```text
lib/
  app/                  App shell, router, theme
  core/                 Database, extensions, utilities
  features/
    wall/               Animated memory wall
    memories/           Memory models, repository, add/detail UI
    media/              Future photo picking and local file storage
    map/                Location/map preview
  shared/               Shared widgets and helpers
```

## Product Strategy

See [docs/product_success_plan.md](docs/product_success_plan.md) for the monetization and launch plan.

Current direction:
- Free: 30 memories, local-only.
- Premium: €4.99 lifetime unlock for unlimited memories, export, themes, and advanced layouts.
- Subscription only later for encrypted backup/sync.
- Google Play Billing product ID: `lifethreads_premium_lifetime`.
