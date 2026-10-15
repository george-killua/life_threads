# Automated end-to-end tests

The beta test protocol (LT-TP-100) runs automatically on an iOS simulator, and
optionally an Android emulator at the same time:

```bash
tool/e2e/run_e2e.sh                 # iOS simulator: build, prepare, run everything
tool/e2e/run_e2e.sh --no-build      # reuse the last build
tool/e2e/run_e2e.sh --flow 03_wall  # one Maestro flow
tool/e2e/run_e2e.sh --android       # Android emulator (slow on this Mac)
tool/e2e/run_e2e.sh --both          # iOS and Android in parallel
```

Needs: Xcode with an iOS 18.5 simulator runtime, the Android SDK with the
`android-34` arm64 system image, [Maestro](https://maestro.mobile.dev), and
Python 3 with Pillow. The script creates its own simulator
("LifeThreads E2E iPhone") and emulator (`LifeThreads_E2E_API34`) and wipes
them each run, so your own simulators and data are never touched.

The report is written to `build/e2e/<timestamp>/report.md`, with a result per
protocol ID for iOS and Android, screenshots of every checked step, and logs.

## What runs where

| | How | Covers |
|---|---|---|
| `.maestro/flows/` | Maestro taps the real debug app like a person, including system dialogs, the photo picker, the contact picker, Save to Photos and the share sheet | INS, WAL, PRM-01, STO, YR, OTD, BAK-01/02, SET |
| `integration_test/` | Flutter integration test with a stand-in store and family server (a simulator has no store account and no Google/Apple sign-in) | PRM-02/03, FAM-01..05 |
| by a person | the protocol page | PRM-04 (Play Store promo code), BAK-03 (capsule on a second device), BAK-04 (QR camera), SET-04 |

Test data: `tool/e2e/make_photos.py` writes six photos with real EXIF dates and
GPS positions; one is dated exactly one year ago (On this day), three fall in
last year (Thread of the Year). Premium features are unlocked with the debug
build's test switch on the Premium page.

## Writing a flow

- Every screen element is found by its text or screen reader label. When a
  control has none, give it one (a tooltip or `Semantics` label) instead of
  tapping coordinates: it helps VoiceOver and TalkBack users too.
- `tool/e2e/screen.sh <device-id>` prints what Maestro sees on screen.
- Multi-line labels need `(?s)` in the pattern, e.g. `"(?s)Daily reminder.*"`.
- Shared steps live in `.maestro/subflows/` (fresh wall, add a memory, unlock
  Premium, scroll to an element, open or leave Settings).
