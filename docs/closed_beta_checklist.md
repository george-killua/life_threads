# LifeThreads Closed Beta Checklist

## Build Identity

- App name: LifeThreads
- Package: `dev.gkcoding.lifethreads`
- Version: `0.1.4+6` (from `pubspec.yaml`)
- Premium product ID: `lifethreads_premium_monthly`

## Build Command

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release --dart-define=MAPTILER_KEY="$MAPTILER_KEY"
```

Upload this file to Google Play closed testing:

```text
build/app/outputs/bundle/release/app-release.aab
```

## Before Upload

- Confirm release keystore is configured in `android/key.properties`.
- Confirm the App Bundle is release-signed, not debug-signed.
- Confirm Play Console package name is `dev.gkcoding.lifethreads`.
- Create the monthly subscription product `lifethreads_premium_monthly`.
- Publish privacy policy at `https://gkcoding.dev/lifethreads/privacy`.
- Publish terms at `https://gkcoding.dev/lifethreads/terms`.
- Complete Data Safety and content rating forms.
- Rotate MapTiler key and inject via CI/local dart-define.
- Verify App Links for share hosts.
- Add closed beta testers by email or Google Group (target 10+).

## Scripted Tester Flows

Ask each tester to complete these flows and note pass/fail:

1. First launch and onboarding (privacy copy mentions optional encrypted cloud).
2. Create a memory from gallery photos.
3. Create a memory by taking a camera photo.
4. Create a memory with multiple photos and story/feeling/category/date.
5. Quick-add from the wall (camera vs gallery sheet).
6. Move memory cards on the wall; add a text note and nail/anchor.
7. Connect two memories and add a connection reason.
8. Open memory detail and preview photos fullscreen.
9. Edit an existing memory (cover, gallery, people).
10. Switch between Wall, Timeline, and Map modes (maps require MapTiler key build).
11. Share a memory capsule link; open it on a second device/install.
12. Export a backup and import a backup.
13. Premium purchase + restore with a Play license tester account.
14. Open Settings → Privacy policy / Terms links.
15. Open Settings → Beta feedback and send feedback.

## Crash and Feedback Log

Track themes only (no private content):

- Crash / freeze
- Data loss
- Permission failures (camera, photos, contacts)
- Share link open failures
- Premium restore failures
- Map blank / MapTiler
- Confusion about wall interactions

Prioritize data-loss and crash fixes before public launch.

## Feedback Questions

Ask testers to answer:

- Did the app feel emotional or just functional?
- Was it clear how to add a memory?
- Was dragging smooth enough?
- Did ropes and connections make sense?
- Did any screen feel confusing?
- Did the app ever freeze, crash, or lose data?
- Would you trust this app with personal memories?
- What feature would make you keep using it?

## Known Beta Privacy Rules

- Do not ask testers to send private photos by email.
- Do not ask testers to send exported backups unless they knowingly choose to.
- Use the in-app beta feedback flow for bug reports.
- Feedback diagnostics do not include memory content, photo paths, backups, or exact locations.

## Exit Criteria

Closed beta is ready for production consideration when:

- At least 10 testers completed the checklist.
- At least 5 testers created 5+ memories.
- At least 3 testers tested backup export/import.
- At least 3 testers tested Premium purchase/restore with Play test accounts.
- No open data-loss bugs.
- No critical crashes remain open.
- Feedback confirms the app feels emotional, not just functional.
