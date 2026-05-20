# LifeThreads

A private, local-first animated memory wall where photos, places, feelings, and life events become connected visual chapters.

## Concept

LifeThreads turns memories into a living wall: photo cards hang like real prints, related events connect with soft ropes, and the whole wall moves subtly with a calm wind effect.

## Current MVP

- Flutter Android-first app, iOS-ready.
- Local-first: no backend, no login, no cloud sync.
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
