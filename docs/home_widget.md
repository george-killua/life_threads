# Home screen widget

A memory from the wall on the home screen, on iPhone and Android. Free.

## Settings

Settings › More › **Home screen widget** (`HomeWidgetSettingsPage`):

- a preview of today's widget;
- **Which memories** (only with walls of one's own): all walls, My wall, or
  one named wall – a deleted wall falls back to all;
- **On this day first** and **Memories with photos first** (both on by
  default);
- how to add the widget on iPhone or Android.

Stored in shared preferences (`home_widget_source`,
`home_widget_on_this_day_first`, `home_widget_photos_first`).

## Empty widget

Without memories the widget says "What happened today?" with **Add a
memory** and **Take photo** buttons (medium and large; a small widget opens
"add" as a whole). Links: `lifethreads://add` and
`lifethreads://add?camera=1` (opens the camera on the add screen).

## What it shows

For each of the next 7 days the app picks one memory:

1. a memory from that day in an earlier year ("3 years ago today"), else
2. a memory to remember ("Remember this") – memories with a photo first, a
   different one each day, else
3. "What happened today?" on an empty wall.

The app writes those 7 days and a small copy of each photo (at most 720 px)
whenever it starts, comes back to the foreground, or a memory changes. The
widget switches to the next day's memory at midnight by itself, so the app
doesn't have to be opened every day.

- **Hidden memories** never appear.
- **App lock on**: one entry "LifeThreads is locked – Open LifeThreads to see
  your memories."; the photo copies are deleted.
- **Tap**: opens the app at that memory (`lifethreads://memory/<id>`); on
  the empty widget, the app (`lifethreads://wall`).

Nothing leaves the phone: the data is in the app's own storage (Android) or
the app's App Group (iPhone). The App Store privacy labels and the Play Data
safety form don't change.

## Code

| Part | Where |
|---|---|
| Which memory on which day | `lib/features/home_widget/domain/home_widget_days.dart` |
| Writing days and photos, app lock | `lib/features/home_widget/data/home_widget_sync.dart` |
| Opening a tapped memory | `lib/features/home_widget/presentation/home_widget_link_listener.dart` |
| iPhone widget (SwiftUI, WidgetKit) | `ios/LifeThreadsWidget/` (target `LifeThreadsWidget`) |
| iPhone channel | `ios/Runner/AppDelegate.swift` (`LifeThreadsHomeWidgetHandler`) |
| Android widget | `android/app/src/main/kotlin/.../LifeThreadsWidgetProvider.kt`, `res/layout/lifethreads_widget.xml`, `res/xml/lifethreads_widget_info.xml` |
| Android channel | `MainActivity.kt` |

The app and the widget share the payload as JSON:
`{"addLabel":"…","photoLabel":"…","days":[{"date":"2026-10-16","kind":"memory","title":"…","subtitle":"…","memoryId":"…","image":"images/….jpg"}]}`
(`kind` is `memory`, `empty` or `locked`; `date` is null for the single
locked entry). iPhone: App Group
`group.dev.gkcoding.lifeThreads`, key `home_widget_payload`, photos in
`<group>/home_widget/`. Android: preferences `lifethreads_home_widget`,
photos in `files/home_widget/`.

## iPhone signing (first upload with the widget)

The widget is an app extension with its own bundle ID
`dev.gkcoding.lifeThreads.LifeThreadsWidget`, and both use the App Group
`group.dev.gkcoding.lifeThreads`. With automatic signing, Xcode registers
both in the developer account during `flutter build ipa` (Xcode must be
signed in to the account, Xcode › Settings › Accounts). If the build stops
with a provisioning error, open `ios/Runner.xcworkspace` once, select the
`LifeThreadsWidget` target › Signing & Capabilities and let Xcode fix it.
The extension takes its version from the app (`FLUTTER_BUILD_NAME` /
`FLUTTER_BUILD_NUMBER`), as the App Store requires.

## Tested

- `test/home_widget_test.dart`: choice of memories, hidden memories, app lock,
  photo copies, links.
- iPhone simulator: widget added from the app icon (medium), shows the photo
  and title; a tap opens the memory.
- Android: builds; not tried on a device or emulator yet (the emulator on this
  Mac doesn't respond).
