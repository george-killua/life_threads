# LifeThreads Closed Beta Checklist

## Build Identity

- App name: LifeThreads
- Package: `dev.gkcoding.lifethreads`
- Version: `0.1.0+1`
- Premium product ID: `lifethreads_premium_lifetime`

## Build Command

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

Upload this file to Google Play closed testing:

```text
build/app/outputs/bundle/release/app-release.aab
```

## Before Upload

- Confirm release keystore is configured in `android/key.properties`.
- Confirm the App Bundle is release-signed, not debug-signed.
- Confirm Play Console package name is `dev.gkcoding.lifethreads`.
- Create the one-time managed product `lifethreads_premium_lifetime`.
- Publish privacy policy at `https://gkcoding.dev/lifethreads/privacy`.
- Complete Data Safety and content rating forms.
- Add closed beta testers by email or Google Group.

## Tester Instructions

Ask each tester to complete these flows:

1. First launch and onboarding.
2. Create a memory with one photo.
3. Create a memory with multiple photos.
4. Add a story, feeling, category, date, and location.
5. Move memory cards on the wall.
6. Add a text note.
7. Add a nail/anchor.
8. Connect two memories and add a connection reason.
9. Open memory detail and preview photos fullscreen.
10. Edit an existing memory.
11. Switch between Wall, Timeline, and Map modes.
12. Export a backup.
13. Import a backup.
14. Open Settings > Beta feedback and send feedback.
15. Try Premium screen purchase and restore flows with a Play test account.

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

- No critical crashes are reported by at least 10 testers.
- Memory create/edit/delete flows are stable.
- Backup export/import works on at least 3 devices.
- Wall interactions are understandable without explanation.
- Premium purchase and restore are verified in Play testing.
- Privacy policy and Data Safety answers match actual app behavior.
