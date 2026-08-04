# iOS App Store Checklist

Complete after Android closed-beta validation looks healthy.

## Identity

- Display name: LifeThreads
- Bundle ID: `dev.gkcoding.lifeThreads`
- Team: configured in Xcode project
- Version/build: sync from `pubspec.yaml`

## Privacy and compliance

- [x] `ios/Runner/PrivacyInfo.xcprivacy` present and reviewed
- [ ] App Store Connect encryption declaration for `cryptography` / capsule encryption (standard encryption / exempt questionnaire as applicable)
- [ ] Usage strings reviewed in `ios/Runner/Info.plist`:
  - Camera (QR + memory photos)
  - Photo library read/add
  - Contacts
- [x] Privacy policy URL: `https://gkcoding.dev/lifethreads/privacy`
- [x] Terms URL: `https://gkcoding.dev/lifethreads/terms`

## Associated domains / share links

- [x] Add Associated Domains entitlement for:
  - `applinks:gkcoding.dev`
  - `applinks:lifethreads.gkcoding.dev`
- [x] Host apple-app-site-association for both hosts (lifethreads subdomain JSON verified; gkcoding.dev file deployed)
- [ ] Cold-start and warm-start open of a share URL → capsule import flow

## Monetization

- [ ] StoreKit product parity with Play: lifetime premium unlock
- [ ] Sandbox purchase + restore verified on TestFlight

## Store listing

- [ ] App Store screenshots (phone + tablet as needed)
- [ ] Copy from `docs/app_store_screenshot_copy.md` / `docs/play_store_content.md`
- [ ] Age rating aligned with Play (13+)

## TestFlight → App Store

1. Upload build via Xcode or `flutter build ipa`
2. Internal TestFlight smoke: onboarding, camera, gallery, wall, share, backup, IAP
3. External TestFlight group (optional) mirroring Android closed beta scripts
4. Submit for App Review once exit criteria match Android stability bar
