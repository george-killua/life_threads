# Premium Features Plan

Five new Premium features, built in six sessions. Planned 2026-10-12.

| # | Feature | Sessions | Needs a server |
|---|---|---|---|
| 1 | On this day | 1 | No |
| 2 | Create Story – image | 2 | No |
| 3 | Create Story – video with music | 3 | No |
| 4 | Thread of the Year | 4 | No |
| 5 | Family wall (shared wall) | 5–6 | Yes |

Features 1–4 run entirely on the device, like the rest of the app. Feature 5 changes what the app
is (accounts, photos stored on the server, moderation); see its risks before session 5.

## Decisions

Decided:

- Stories are shared through the **system share sheet** (Instagram, Facebook, Snapchat, WhatsApp,
  …). No Meta App ID and no direct Instagram/Facebook Stories intents.
- All five features are **Premium**.

Defaults this plan assumes (change them before the session that needs them):

- **Music: CC0 tracks bundled in the app** (session 3). Every track needs a license that clearly
  allows shipping it inside a commercial app; Pixabay's "standalone" restriction rules it out.
- **Free users see a preview, Premium unlocks export**: free users can build a story or a Thread of
  the Year and watch the preview; saving/sharing opens the Premium page. On this day notifications
  stay Premium.
- **Family wall after launch**: sessions 5–6 can run before launch, but the store reviews for
  accounts and shared content take longer, so shipping 1–4 first is safer.

## Shared groundwork (session 1, reused by every feature)

- `PremiumFeature` enum + one gate (`requirePremium(context, feature)`) that opens the Premium page
  with the feature's name, instead of the `isPremium` checks spread across pages today.
- `StoryCanvas`: renders any widget offscreen to a PNG at 1080×1920 (from the approach in
  `tool/store_screenshots`). Sessions 2–4 build on it.
- Premium page: the benefit grid lists the new features as they ship.
- Each feature adds its strings in EN, DE and AR and its own tests.

---

## Session 1 — On this day

**Goal:** on the date a memory happened in an earlier year, LifeThreads brings it back.

- Wall: the existing "Remember this" card (`_MemoryRitualCard`, `_memoryToRevisit`) shows the
  "On this day" memory first ("3 years ago today"), falling back to the current behaviour.
- Opens as a chapter: the memory detail page with an "On this day" header and the years passed.
- Local notification at a chosen time (default 9:00) on days that have a memory: one notification
  even when several memories match. `flutter_local_notifications` + `timezone`; schedule the next
  30 days on app start and after memories change. No server.
- Settings: on/off and the time. Asks for notification permission only when turned on.
- Premium: the wall card stays free (it exists today); notifications and the chapter header are
  Premium.
- Android: `POST_NOTIFICATIONS` (13+), exact alarms not needed (inexact daily is fine). iOS:
  notification permission string.
- Tests: date matching (Feb 29, time zones, same-day memories), scheduling list, gating.

**Done when:** a memory dated today minus N years shows on the wall and triggers a notification on a
real device; turning it off cancels everything.

## Session 2 — Create Story (image)

**Goal:** pick memories, get a beautiful 9:16 image, share it anywhere.

- Entry points: "Create story" on the wall controls, on a memory's detail page, and in the memory
  long-press menu.
- Picker: choose 1–6 memories (pre-selected when started from a memory).
- Templates (rendered with `StoryCanvas`, 1080×1920):
  1. **Single memory**: full-bleed photo, title, place, date, feeling.
  2. **Thread**: 2–6 memories as pinned cards joined by the rope, like the wall.
  3. **Collage**: photo grid with one line of story.
  4. **Quote**: the memory's story text on the wall background with a small photo.
  Light LifeThreads mark in a corner (Premium can hide it — optional).
- Editor: swipe between templates, edit the caption, choose the cover photo per memory.
- Share: `share_plus` with the PNG (system share sheet); also "Save to Photos" (needs the photo
  library add permission on iOS).
- Arabic: RTL layout and Arabic-capable fonts in the image.
- Premium: preview free, share/save Premium.
- Tests: golden-style render tests for each template at 1080×1920; picker limits.

**Done when:** a story image shared from a phone opens in Instagram's Story composer through the
share sheet and looks right in EN/DE/AR.

## Session 3 — Create Story (video) + music

**Goal:** the same stories as short videos with music.

- Video: 9:16, 1080×1920, 30 fps, 15–20 s (fits Instagram's 20 s story background limit; longer
  stories can be split later). Motion: photos drift/zoom, the rope draws from card to card, titles
  fade in — the Capsule Cinema style (`capsule_cinema_script.dart`).
- Engine: frames rendered in Flutter (`StoryCanvas` per frame) and encoded natively through a
  platform channel — Android Media3 Transformer / MediaCodec, iOS `AVAssetWriter` — then the audio
  track is muxed in. No FFmpeg (`ffmpeg_kit` is discontinued and the GPL builds conflict with a
  closed-source app).
- Progress UI with cancel; files go to the temporary directory and are removed after sharing, like
  backups.
- Music library: 8–12 curated tracks in moods (warm, joyful, calm, nostalgic, epic), each trimmed to
  ~30 s with a fade. Plus **"No music"**, so users can add Instagram's licensed music inside
  Instagram.
- Licensing record: `assets/music/LICENSES.md` with title, artist, source URL, license, download
  date and a saved copy of the license page for every track. In-app credits in Settings → About.
- Premium: preview free, export Premium.
- Tests: frame timeline maths, encoder channel contract (mocked), license file lists every bundled
  track.

**Before this session (you):** approve the track list (I propose candidates with their licenses).

**Done when:** a 20 s video with music exports on a mid-range Android phone and an iPhone in under
~30 s and plays in Instagram, WhatsApp and the Photos app.

## Session 4 — Thread of the Year

**Goal:** one tap turns a year of memories into a short film.

- Entry: a "Your year" card on the wall in December/January and a "Thread of the Year" button
  (any year with at least 3 memories).
- Selection (on device): up to 12 memories from the year, preferring ones with photos, "important"
  and "proud" feelings, many threads, and spread across months; the user can swap or remove
  memories before rendering.
- Film: title card ("2025 · 14 memories · 6 places"), one shot per memory in date order joined by
  the rope, month markers, a closing card with stats (places, people, most-felt feeling). Built on
  session 3's engine and music; 30–45 s, plus a 20 s cut for stories.
- Also exports a story image (session 2 template "Year").
- Premium: preview free, export Premium.
- Tests: selection rules (empty year, all-same-day, no photos), stats.

**Done when:** a year with 10+ memories renders a film that tells the year in order, in EN/DE/AR.

## Sessions 5–6 — Family wall

**Goal:** a family (or couple, or friends) shares one wall; everyone can add memories to it.

What this adds that the app does not have today, and must exist before release:

- **Accounts.** Sign in with Apple and Google (if Google sign-in is offered on iOS, Apple requires
  Sign in with Apple too). **In-app account deletion** (Apple 5.1.1(v); Google requires it in-app
  and on the web).
- **Photos on GK Coding servers, permanently.** This reverses "we keep no copy" for shared walls
  only. Plan: **end-to-end encryption** — each family wall has a key; it is shared through the
  invite link and never reaches the server, so GK Coding stores only ciphertext. Personal walls stay
  local.
- **Shared content rules (UGC).** Apple 1.2 and Google's UGC policy: users accept terms before
  posting; report a memory, remove or block a member; owner can remove members and memories;
  published contact; you act on reports quickly (App Review usually asks for 24 hours).
- **Server-side Premium check.** Today Premium is a local flag. A server feature must verify the
  subscription (Google Play Developer API / App Store Server API) or anyone could use the API.
- **Costs.** Storage grows with every shared photo. Quotas per family (e.g. 2 GB) and resized
  photos keep it predictable.
- **Policy and listings.** Privacy policy, terms, Data safety and App Privacy labels change
  substantially; delete-data page gains account deletion.

### Session 5 — server (repo `gk_coding_website/backend`)

- Auth: Sign in with Apple + Google (ID token verification), sessions, account deletion endpoint.
- Families: create, invite link (one-time token), join, leave, remove member, roles (owner/member).
- Encrypted storage: memory records and photos as encrypted blobs, versioned; quota per family.
- Moderation: report endpoint (emails you), block/remove, audit log.
- Subscription verification for the family owner.
- Tests with the existing `node --test` setup; runbook section for backups and storage.

### Session 6 — app

- Sign-in screen, account page with delete account.
- Create / join family wall (invite via share sheet, QR); switch between "My wall" and the family
  wall.
- Shared memories: add, edit own, threads between shared memories; offline cache and sync with
  conflict handling (last write wins per memory).
- Report memory, remove/block member, terms acceptance before first post.
- Encryption: family key in Keychain/Keystore, encrypt before upload.
- Policy, terms, delete-data page, Data safety and App Privacy updates.

**Before session 5 (you):** confirm it ships before or after launch, an email address for reports,
and that you accept storing encrypted photos on the VPS (or pick object storage).

**Done when:** two phones (Android + iPhone) share one wall, see each other's memories, can report
and remove, and deleting an account removes its data from the server.

---

## After the six sessions

- Store screenshots and listing copy for the new features (`tool/store_screenshots`).
- Closed testing on Play, then TestFlight; App Review notes for Stories (share sheet only) and,
  if shipped, the family wall (demo account, moderation explanation).
