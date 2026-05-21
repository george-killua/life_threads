# LifeThreads Play Console Release Candidate Checklist

## App Access
- Select: all functionality is available without access restrictions.
- No login or reviewer credentials are required.

## User Content Sharing
- Native user-to-user sharing: Yes, because users can share an encrypted memory capsule link outside the app.
- Shared user-generated content primary source: No.
- Public sharing of nudity: No.
- Public sharing of graphic violence: No.
- Block users / report content / chat moderation: No, because the app has no public feed, no profiles, no comments, and no in-app chat.
- Interactions limited to invited friends only: Yes. Shared capsules are private links sent by the user to selected recipients.
- Safety note: shared capsule links expire automatically and can be revoked/deleted after creation.

## Target Audience
- Recommended: 13-15, 16-17, 18 and over.
- Do not target children under 13 for the first release.

## Data Safety
- App collects required user data types: Yes.
- Data encrypted in transit: Yes, for HTTPS map tile, Google Play Billing, and encrypted capsule share requests.
- Account creation: My app does not allow users to create an account.
- Users can request deletion: Yes.
- Delete data URL: https://gkcoding.dev/lifethreads/delete-data
- Privacy policy URL: https://gkcoding.dev/lifethreads/privacy

## Data Types To Disclose
- Photos and videos: user-selected photos, app functionality. Shared with GK Coding only if the user creates an encrypted shared memory capsule.
- Location: optional photo metadata/manual memory location, app functionality. May be included in an encrypted shared capsule if the user shares that memory.
- App activity/purchases: Google Play Billing purchase state for premium unlock when enabled.

## Cloud Share Disclosure
- No account required.
- No public profile or public listing.
- No in-app chat.
- Shared memory capsules are encrypted before upload.
- Recipient needs the share link and password.
- Links expire automatically.
- User can delete/revoke a freshly created link from the app.

## Release Blockers
- Use a real release keystore, not debug signing, before uploading to production/closed testing.
- Build release with MAPTILER_KEY through --dart-define.
- Rotate the MapTiler key before public release because a previous key was shared in chat.
