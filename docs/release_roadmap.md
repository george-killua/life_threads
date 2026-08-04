# LifeThreads Release Roadmap

Core promise: memories feel alive.

## Phases

0. Freeze camera WIP → `0.1.4+6` (done in tree)
1. Trust & legal alignment (onboarding/privacy/terms/README)
2. Android release engineering (R8, MapTiler, App Links, keystore)
3. Closed beta — see `docs/closed_beta_checklist.md`
4. Public Play launch — see `docs/public_launch_runbook.md`
5. iOS parity — see `docs/ios_app_store_checklist.md`
6. Post-launch creatives — Capsule Cinema (implemented), then Thread of the Year

## Capsule Cinema

Shared-link recipients see a skippable ~18s chapter after password decrypt and before Add to Wall.

Key files:

- `lib/features/capsule/presentation/capsule_cinema_script.dart`
- `lib/features/capsule/presentation/capsule_cinema_controller.dart`
- `lib/features/capsule/presentation/pages/capsule_cinema_page.dart`
- Deep link wiring in `memory_capsule_deep_link_listener.dart`

## Manual ops still required

- Rotate MapTiler key in dashboard + update CI secret
- Publish `docs/terms_of_use.html` and updated privacy HTML to gkcoding.dev
- Confirm Digital Asset Links / AASA for share hosts
- Run closed beta with 10+ testers
- Staged Play rollout and later TestFlight
