# LifeThreads Google Play Store Content

Status: draft, not published.

References:
- Google Play listing limits: https://support.google.com/googleplay/android-developer/answer/9859152
- Google Play preview asset rules: https://support.google.com/googleplay/android-developer/answer/1078870
- Google Play Data safety form: https://support.google.com/googleplay/android-developer/answer/10787469

## Store Listing

App name:

```text
LifeThreads
```

Short description, 73 of 80 characters:

```text
A private memory wall that connects photos, stories, places, and moments.
```

Full description:

```text
LifeThreads is a private memory wall for the moments you do not want to lose.

Instead of storing memories in a normal gallery, LifeThreads lets you build a living wall of photos, stories, places, feelings, notes, and connections. Add a memory, hang it on your wall, connect it to another moment with a thread, and revisit your life as a visual story.

LifeThreads is designed for people who want their memories to feel personal, emotional, and alive.

What you can do:

- Create memories with photos, title, story, date, feeling, category, and location.
- Build a private wall with hanging memory cards, notes, nails, and thread connections.
- Connect memories and explain why they belong together.
- View memories as a wall, timeline, or map.
- Open a cinematic memory chapter with photos, story, metadata, connected notes, and related moments.
- Keep your memories local-first on your device.
- Back up everything – photos included – into one file, free, and keep it wherever you like.
- Share one encrypted memory capsule by private link when you choose.
- Choose wall themes and layouts as the app grows.

Why LifeThreads is different:

Most photo apps show files. LifeThreads shows relationships.

A trip, a person, a place, a first launch, a birthday, a quiet evening, or a small personal win can all become part of a connected wall. The app is built around the feeling that memories are not isolated. They are linked by meaning.

Privacy-first:

LifeThreads is local-first. There is no account, no social feed, no public profile, and no advertising system. We keep no copy of your memories: your backup is one file you save wherever you like. Optional memory capsule sharing uploads only the one encrypted memory you choose to share, for a limited time. Your memories are created for you, not for an algorithm.

Use LifeThreads for:

- Family memories
- Travel stories
- Couple timelines
- Personal milestones
- Creative journals
- Life events
- Photo walls
- Private reflection

LifeThreads is still growing. The first release focuses on the core experience: making your memories feel alive.
```

## Feature List

- Private local-first memory wall
- Add memories with photos, story, date, feeling, category, and location
- Hanging photo cards with motion and depth
- Rope/thread connections between memories
- Connection reasons for linked memories
- Text notes and nail/anchor items on the wall
- Wall, timeline, and map view modes
- Cinematic memory detail page
- Fullscreen photo preview
- Edit memories after creation
- Manage memory connections
- Free backup and restore in one file (optionally password-encrypted)
- Backup reminder when new memories are not in a backup yet
- Optional encrypted memory capsule sharing
- Shared links expire and can be deleted/revoked
- Premium-ready structure for future unlocks

## Category Recommendation

Primary category:

```text
Lifestyle
```

Reason:

```text
LifeThreads is primarily a personal memory and life-journaling app. It uses photos, but the core value is emotional organization and reflection, not camera editing or photo storage.
```

Alternative only if Google Play positioning changes:

```text
Photography
```

## Tags / Keywords Direction

Use naturally in the listing, not as repeated keyword stuffing:

- memory wall
- private memories
- photo journal
- life timeline
- personal journal
- travel memories
- family memories
- photo story

Avoid:

- claims like "best", "#1", "award-winning", or "most secure"
- fake reviews or testimonials
- repeated keyword lists
- saying family walls (accounts, shared walls) exist in a listing before the release that ships them

## Data Safety Draft

Recommended Play Console answers once family walls ship (the release that contains the family wall screens and the `family-data` service). For a release without family walls, use the answers marked "without family walls".

- Data collected by developer: Yes. Without family walls: only when the user chooses cloud memory sharing or a wall display. With family walls: also the account identifier, family wall membership, end-to-end encrypted family wall content, reports, and the owner's subscription status. Backup files never go to GK Coding servers; Android cloud backup is turned off for the app (device-to-device transfer only).
- Data shared by developer: No. No advertising or analytics sharing. (Sign-in is processed by Google as a service provider; reports stay with GK Coding.)
- Data encrypted in transit: Yes.
- Account creation: Yes, optional, only for family walls (Google Sign-In on Android). My wall needs no account.
- Account deletion: Yes, in the app (Family walls > Account > Delete account) and on the web at `https://gkcoding.dev/lifethreads/delete-data`. Deleting the account deletes the owned family walls with all their memories and photos, the user's memories on other walls, and the account.
- Data deletion request: Yes. Use `https://gkcoding.dev/lifethreads/delete-data`.
- Personal info > User IDs: Collected (with family walls). The account identifier from Google Sign-In. Required for family walls, optional for the app. Purpose: app functionality, account management, fraud prevention/security (moderation). Not shared.
- Personal info > Name: Collected (with family walls), optional. The display name a member chooses for a family wall. It is end-to-end encrypted: Play's guidance lets end-to-end encrypted data that the developer cannot read be left out; if in doubt, declare it as collected for app functionality.
- Photos and videos: User-selected photos are used for app functionality. They stay local unless the user exports a backup (saved where the user chooses), shares an encrypted memory capsule, displays the wall on another screen, or adds them to a family wall. Declare Photos as collected (not shared), user-initiated, for app functionality: the wall display snapshot is stored unencrypted on GK Coding servers until the session expires (at most 60 minutes). Family wall photos are resized and end-to-end encrypted on the device; GK Coding stores only ciphertext and never receives the key, and photos are never included in reports.
- Messages / Other user-generated content: Collected (with family walls). Memory titles and stories on a family wall are end-to-end encrypted (GK Coding cannot read them), except when a user reports a memory: the report sends that memory's decrypted title and story, the chosen reason, and an optional note to GK Coding for review. Declare "Other user-generated content" as collected, user-initiated, for app functionality and fraud prevention/security (moderation).
- Location: Optional photo metadata location is used for app functionality. Place names may be included in a shared capsule, a wall display snapshot, or (end-to-end encrypted) a family wall memory if the user chooses those features. Map tile requests are sent to OpenFreeMap when map features are opened and may reveal the viewed map area to the tile provider.
- App activity / analytics: Not collected in the current version. Family wall servers do see metadata needed to run the feature (membership, roles, sizes and timestamps of encrypted items, which account added each item, blocks); it is used only for app functionality and moderation, not analytics.
- App info and performance: Not collected.
- Account info: Without family walls: not collected. With family walls: User IDs as above.
- Financial info > Purchase history: With family walls, the owner's store purchase token is sent to GK Coding to verify the Premium subscription with Google Play; GK Coding stores whether it is active and when it ends. Declare as collected for app functionality. Payments themselves are processed by Google Play.

## User Content Sharing / Safety Answers

Use these answers for the Play Console user-content sharing questions once family walls ship (without family walls, keep block/report at `No`):

- Does the app natively allow users to interact or exchange content with other users through voice, text, images, or audio? `Yes`
- Is shared, user-generated content the primary source of content in the app? `No`
- Does the app permit public sharing of nudity? `No`
- Does the app permit public sharing of real-world graphic violence outside newsworthy context? `No`
- Does the app include the ability to block users or user-generated content? `Yes` (block a family wall member; owners remove members and memories)
- Does the app include the ability to report users or user-generated content? `Yes` (report a memory or member; reviewed within 24 hours)
- Does the app include chat moderation? `No`
- Can interactions in the app be limited to invited friends only? `Yes`

Explanation:

```text
LifeThreads has no public feed, no profiles, no comments, no chat, and no user discovery. Users can optionally share one encrypted memory capsule through a private link; the recipient needs the link and the password, and links expire automatically and can be revoked. Family walls are private, end-to-end encrypted walls shared only with people invited by a one-time link that expires within 7 days. Before posting, users accept terms with zero tolerance for objectionable content. Any member can report a memory or a member and block a member; GK Coding reviews reports within 24 hours and removes content and accounts that break the rules. The owner of a family wall can remove members and their memories.
```

## Screenshot Plan

Use phone screenshots at 1080 x 1920 PNG where possible. Prepare at least 6 screenshots, with at least 4 high-quality screenshots to qualify for stronger Play recommendation surfaces.

1. Wall hero
   Caption: "Build a private wall of living memories"
   Screen: Main wall with memory cards, ropes, notes, and warm lighting.

2. Add memory flow
   Caption: "Capture the story behind every moment"
   Screen: Step-by-step add memory page with photo and story fields.

3. Connected memories
   Caption: "Connect moments and remember why they matter"
   Screen: Manage connections or wall view with connection labels.

4. Memory chapter
   Caption: "Open each memory as a cinematic chapter"
   Screen: Memory detail page with photo header, story, metadata, and gallery.

5. Timeline view
   Caption: "Revisit your memories by time"
   Screen: Timeline mode with grouped memories by date.

6. Map view
   Caption: "See where your memories happened"
   Screen: Map mode with memory locations.

7. Backup and privacy
   Caption: "Local-first, private, and exportable"
   Screen: Settings or backup page.

8. Themes / premium preview
   Caption: "Make the wall feel like yours"
   Screen: Theme selection page.

Feature graphic direction:

```text
Dark warm memory-room background, three hanging photo cards connected by gold thread, LifeThreads wordmark, no pricing text, no "best app" claims.
```

## Release Checklist

- Build signed Android App Bundle with real release keystore.
- Confirm package name: `dev.gkcoding.lifethreads`.
- Create a monthly subscription in Play Console: `lifethreads_premium_monthly`.
- Upload app icon: 512 x 512 PNG, max 1024 KB.
- Upload feature graphic: 1024 x 500 PNG or JPG.
- Upload at least 6 phone screenshots.
- Add app name, short description, and full description.
- Add privacy policy URL: `https://gkcoding.dev/lifethreads/privacy`.
- Complete Data safety form consistently with the privacy policy.
- Complete content rating questionnaire.
- Select app category: Lifestyle.
- Set target audience: likely 13+ unless final content rating requires otherwise.
- Verify no debug signing is used for production.
- Run internal testing before production release.
- Do not publish until privacy policy page is live and screenshots are final.
