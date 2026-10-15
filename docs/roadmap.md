# LifeThreads – Launch Roadmap

The path from beta to a public launch, in order. Each step says who does it
(**George**, **Claude**, or **both**) and its status. Update this file when a
step is done.

Status: ✅ done · 🔄 in progress · ⏳ waiting on someone · ⬜ not started

_Last updated: 15 October 2026_

## Phase 1 – Finish the beta properly

| # | Step | Who | Status |
|---|---|---|---|
| 1 | Push all work; upload build **1.0.0 (20)** to TestFlight | Claude | ✅ |
| 2 | Create the yearly plan `lifethreads_premium_yearly` (€34.99) in App Store Connect and Play Console, and let the server accept it – see [store_setup_yearly.md](store_setup_yearly.md) | both | 🔄 Both stores done (App Store: submit with the next app version). Left: server accepts the product (George, section 3) |
| 3 | Publish privacy policy, terms and Premium page on gkcoding.dev (ready in the website repo; one `rsync` – see [store_setup_yearly.md](store_setup_yearly.md#4-website)) | George | ⏳ |
| 4 | Join the App Store Small Business Program; check Google's 15 % service fee | George | ⏳ |
| 5 | Test on a real iPhone: Face ID lock, hidden memories, a sandbox purchase | George | ⏳ |

## Phase 2 – Learn from real people (2–3 weeks)

| # | Step | Who | Status |
|---|---|---|---|
| 6 | Recruit 20–50 beta testers (friends, family, and strangers from journaling communities) | George | ⬜ |
| 7 | Hand out the test protocol (EN/DE/AR) and ask: what did you understand in the first minute, what annoyed you, would you pay €35 a year? | George | ⬜ |
| 8 | Measure 7-day retention: if fewer than 3 in 10 testers come back, fix that before adding features | both | ⬜ |

## Phase 3 – Sync between devices (parallel to phase 2)

Design: [sync_plan.md](sync_plan.md).

| # | Step | Who | Status |
|---|---|---|---|
| 9 | Put the family-wall server code into a git repo Claude can read | George | ⏳ |
| 10 | Create IONOS S3 Object Storage with a budget alert (€20/month) | George | ⬜ |
| 11 | Server endpoints + app side of the encrypted sync | Claude | ⬜ |
| 12 | Update privacy policy, App Store privacy labels, Play Data safety | both | ⬜ |

## Phase 4 – Launch-ready (1–2 weeks)

| # | Step | Who | Status |
|---|---|---|---|
| 13 | App Store / Play page: first screenshot shows the wall with threads; a 15–20 s preview video | both | ⬜ |
| 14 | Store text: "your life as a wall of connected memories" – not "a journal" | both | ⬜ |
| 15 | Business basics in Austria: trade licence (Gewerbe) and income reporting – ask a tax advisor or the WKO | George | ⬜ |

## Phase 5 – Launch and grow

| # | Step | Who | Status |
|---|---|---|---|
| 16 | Release on both stores at the same time | both | ⬜ |
| 17 | Short videos (Reels/TikTok): a wall of threads, a Thread of the Year film | George | ⬜ |
| 18 | In-app review prompt after the 10th memory | Claude | ⬜ |
| 19 | Monthly: new users, 7-day retention, Premium conversion – improve the weakest | both | ⬜ |

## Related documents

- [changelog.md](changelog.md) – what changed in each build
- [business_numbers.md](business_numbers.md) – costs, revenue and profit estimates
- [sync_plan.md](sync_plan.md) – cross-platform encrypted sync design
- [pricing_strategy.md](pricing_strategy.md) – plans and product IDs
- [store_setup_yearly.md](store_setup_yearly.md) – yearly plan in both stores, server and website
- [e2e_testing.md](e2e_testing.md) – automated UI tests
- [privacy_policy.md](privacy_policy.md) – the published privacy policy
