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
- Export and restore your local memory archive.
- Share one encrypted memory capsule by private link when you choose.
- Choose wall themes and layouts as the app grows.

Why LifeThreads is different:

Most photo apps show files. LifeThreads shows relationships.

A trip, a person, a place, a first launch, a birthday, a quiet evening, or a small personal win can all become part of a connected wall. The app is built around the feeling that memories are not isolated. They are linked by meaning.

Privacy-first:

LifeThreads is local-first. There is no account, no social feed, no public profile, no advertising system, and no cloud sync in the current version. Optional memory capsule sharing uploads only the one encrypted memory package you choose to share. Your memories are created for you, not for an algorithm.

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
- Export and import local backups
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
- saying full cloud sync or social sharing exists before it is implemented

## Data Safety Draft

Recommended Play Console answers for the current release:

- Data collected by developer: Yes, only when the user chooses cloud memory sharing or uses online services such as map tiles / Play Billing.
- Data shared by developer: No advertising or analytics sharing.
- Data encrypted in transit: Yes.
- Data deletion request: Yes. Use `https://gkcoding.dev/lifethreads/delete-data`.
- Photos and videos: User-selected photos are used for app functionality. They stay local unless the user exports or shares an encrypted memory capsule.
- Location: Optional photo metadata/manual memory location is used for app functionality. Location metadata may be included in an encrypted shared capsule if the user chooses to share that memory. Production map tile requests are sent to MapTiler when map features are opened and may reveal viewed map area to the map tile provider.
- App activity / analytics: Not collected in the current version.
- Account info: Not collected.
- Financial info: Not collected by the app. Google Play Billing purchases are processed by Google Play.

## User Content Sharing / Safety Answers

Use these answers for the Play Console user-content sharing questions:

- Does the app natively allow users to interact or exchange content with other users through voice, text, images, or audio? `Yes`
- Is shared, user-generated content the primary source of content in the app? `No`
- Does the app permit public sharing of nudity? `No`
- Does the app permit public sharing of real-world graphic violence outside newsworthy context? `No`
- Does the app include the ability to block users or user-generated content? `No`
- Does the app include the ability to report users or user-generated content? `No`
- Does the app include chat moderation? `No`
- Can interactions in the app be limited to invited friends only? `Yes`

Explanation:

```text
LifeThreads has no public feed, no profiles, no comments, no chat, and no user discovery. Users can optionally share one encrypted memory capsule through a private link. The recipient needs the link and the password. Links expire automatically and can be revoked/deleted after creation.
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
- Create a managed one-time product in Play Console: `lifethreads_premium_lifetime`.
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
