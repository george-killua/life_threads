# Release ops status (automated + remaining)

Updated: 2026-08-04

## Completed automatically

- Privacy policy live at https://gkcoding.dev/lifethreads/privacy/ (Aug 10 copy: monthly Premium)
- Terms live at https://gkcoding.dev/lifethreads/terms/ (Aug 10 copy: monthly subscription)
- Android App Links `assetlinks.json` live on gkcoding.dev and lifethreads.gkcoding.dev
- Fingerprint matches release keystore SHA-256 `3E:16:2A:8F:...:AC:98`
- Apple AASA live on lifethreads.gkcoding.dev (JSON) and present on gkcoding.dev
- iOS Associated Domains entitlement added (`ios/Runner/Runner.entitlements`)
- Release AAB built locally: `build/app/outputs/bundle/release/app-release.aab`
- R8 Play Core dontwarn rules fixed so minify succeeds
- Play Closed Test workflow fixed (ruby-version + Java 17)
- Closed testing workflow re-triggered after fixes

## Requires your MapTiler login (cannot automate)

1. Rotate MapTiler API key — see `docs/maptiler_key_rotation.md`
2. `gh secret set MAPTILER_KEY` with the new key
3. Rebuild/upload AAB with the rotated key (local or CI)

Local AAB currently used placeholder define `PLACEHOLDER_ROTATE_ME` for maps only; signing is the real release keystore.

## Closed beta / public / iOS (human store consoles)

GitHub Actions secrets currently empty in CI (`MAPTILER_KEY`, `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON_BASE64`).
Add them under GitHub → Settings → Secrets and variables → Actions, then:

```bash
gh workflow run "Play Closed Test" -f play_track=alpha -f release_status=draft
```

Or locally after exporting secrets:

```bash
./scripts/upload_closed_test.sh
```

- Invite 10+ testers and run `docs/closed_beta_checklist.md`
- After exit criteria: staged production via `docs/public_launch_runbook.md`
- iOS: enable Associated Domains capability in Apple Developer portal for the App ID, then TestFlight (`docs/ios_app_store_checklist.md`)
