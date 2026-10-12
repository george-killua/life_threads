# Family wall: app setup

What the owner has to create and configure so the family wall works in release builds, and
how the app's data layer (`lib/features/family/data/`) uses it. The server side is documented in
the website repo (`deploy/vps/OPERATIONS_RUNBOOK.md`, `backend/.env.example`).

## Build-time values (`--dart-define`)

None of these is a secret; they are public identifiers.

| Define | Default | What |
| --- | --- | --- |
| `LIFETHREADS_FAMILY_API_URL` | `https://lifethreads.gkcoding.dev/api/lifethreads/family` | Family API base URL (point it at a local server for testing). |
| `LIFETHREADS_GOOGLE_SERVER_CLIENT_ID` | empty | Google OAuth client id of type **Web application**. Required on Android: Credential Manager issues the ID token for this audience. |
| `LIFETHREADS_GOOGLE_IOS_CLIENT_ID` | empty | Google OAuth client id of type **iOS**. Alternatively put it in `Info.plist` as `GIDClientID`. |

Example:

```sh
flutter build appbundle \
  --dart-define=LIFETHREADS_GOOGLE_SERVER_CLIENT_ID=1234-web.apps.googleusercontent.com \
  --dart-define=LIFETHREADS_GOOGLE_IOS_CLIENT_ID=1234-ios.apps.googleusercontent.com
```

## Google sign-in (Android and iOS)

In Google Cloud Console (APIs & Services, same project for all three):

1. **OAuth consent screen**: app name LifeThreads, support email, privacy policy
   `https://lifethreads.gkcoding.dev/privacy`. Scopes: only `openid` (the app requests no
   others; no verification needed).
2. **Credentials, OAuth client id, Web application**: name "LifeThreads server". No redirect
   URIs. This id is `LIFETHREADS_GOOGLE_SERVER_CLIENT_ID`.
3. **OAuth client id, Android**: package `dev.gkcoding.lifethreads`, with the SHA-1 of
   - the debug keystore (`keytool -list -v -keystore ~/.android/debug.keystore`, password `android`),
   - the upload key,
   - the **Play App Signing** key (Play Console, Test and release, App integrity).
   One Android client per SHA-1. The app never sends this id; Google matches the signed APK.
4. **OAuth client id, iOS**: bundle id `dev.gkcoding.lifeThreads`. This id is
   `LIFETHREADS_GOOGLE_IOS_CLIENT_ID`.
5. iOS needs the **reversed iOS client id** as a URL scheme. Add to `ios/Runner/Info.plist`:

   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>com.googleusercontent.apps.1234-ios</string>
       </array>
     </dict>
   </array>
   ```

   (It is not in the repo yet because the id does not exist yet; Google sign-in on iOS fails
   without it.)
6. Server: `LIFETHREADS_GOOGLE_SIGNIN_CLIENT_IDS=<web id>,<ios id>` (add the Android ids too
   if in doubt; the server only compares the token audience against this list).

The app sends no nonce to Google: `google_sign_in` 7 fixes the nonce once per app run, so it
would not protect against replay. The server still checks signature, issuer, audience and
expiry.

## Sign in with Apple (iOS)

1. Apple Developer, Certificates, Identifiers & Profiles, Identifiers, `dev.gkcoding.lifeThreads`:
   enable **Sign in with Apple** (as a primary App ID). Regenerate the provisioning profiles.
2. `ios/Runner/Runner.entitlements` (Release/Profile) now contains
   `com.apple.developer.applesignin = [Default]`. `RunnerDebug.entitlements` stays empty so
   personal teams can still install debug builds; to test Apple sign-in in a debug build, add the
   same key there with the paid team.
3. Server: `LIFETHREADS_APPLE_SIGNIN_AUDIENCES=dev.gkcoding.lifeThreads` (the default).

No Services ID is needed: the app offers Apple sign-in on iOS only. Android has no native Sign in
with Apple; the web flow would need a callback endpoint on the server that does not exist, so
Android users sign in with Google. (App Store guideline 4.8 only requires Apple sign-in on iOS.)

The app sends `SHA-256(nonce)` to Apple and the raw nonce to the server, which checks that the
token carries its hash.

## Invite links

`https://lifethreads.gkcoding.dev/family/join#t=<invite token>&f=<family id>&k=<family key>`

- iOS: `applinks:lifethreads.gkcoding.dev` is already in `Runner.entitlements`, and the
  server's `apple-app-site-association` lists `/family/join`. Nothing to do.
- Android: an `autoVerify` intent filter for `https://lifethreads.gkcoding.dev/family/join` is in
  `AndroidManifest.xml`. The site's `assetlinks.json` must list the SHA-256 of the upload and
  Play App Signing keys (it already covers the domain for `/share`).
- The screens route the link: `FamilyService.isInviteLink(uri)` and `acceptInvite(uri)`.
- Only `t` goes to the server. The key `k` is in the URL fragment, which browsers do not send;
  the join page on the website must not read or forward it.

## Subscription linking

`FamilyService.linkSubscription()` reads the Premium purchase from the store on the device and
posts it to `/account/subscription`:

- Android: the Play Billing purchase token of `lifethreads_premium_monthly`.
- iOS: the StoreKit 2 **original transaction id** of the latest Premium transaction.

The server needs the Play service account and the App Store Server API key (runbook,
"LifeThreads family wall"); without them it answers `subscription_verification_not_configured`.

## What the app stores

| What | Where | Removed by |
| --- | --- | --- |
| Session token (`lts_…`) | Keychain / Keystore (`flutter_secure_storage`) | sign out, 401, delete account |
| Family keys (one key ring per family) | Keychain / Keystore | leaving / losing a family, delete account |
| Decrypted memory records, cursors, members, families list | `Application Support/family_wall/*.json` | sign out, delete account, leaving a family |
| Decrypted photos (JPEG) | `Application Support/family_wall/families/<id>/photos/` | same, and photo tombstones |

- iOS Keychain items use `first_unlock_this_device` (background sync works; never migrated to
  another device). Android excludes the secure-storage preferences from device-to-device
  transfer (`data_extraction_rules.xml`, `backup_rules.xml`); their Keystore key cannot move.
- **A new phone has no family keys.** It gets them by opening a fresh invite link from any
  member; an existing member's `acceptInvite` stores the key even though the server answers
  `already_member`. The UI should explain this (error code `family_key_missing`).

## Encryption

AES-256-GCM (`cryptography` package), one random 256-bit key per family. Every item and
string uses the same envelope:

```
byte 0      format version (1)
byte 1      key id length L
bytes 2..   key id (ASCII; also sent as X-Key-Id on uploads)
12 bytes    random nonce
n bytes     ciphertext
16 bytes    GCM tag
```

- Associated data `lifethreads-family/v1/<familyId>/<kind>/<id>` binds each ciphertext to its
  family, kind (`memory`, `photo`, `profile`) and id, so the server cannot swap blobs. The family
  name is encrypted before the family id exists, so it uses `lifethreads-family/v1//family-name/`.
- Key id = first 9 bytes of `SHA-256("lifethreads-family-key-id:" + key)`, base64url (12
  characters). Derived, so every member computes the same id; it lets a future key rotation keep
  old keys for reading.
- Memory records are JSON (title, description, category, feeling, occurredAt, location, photo
  ids, cover, wall position); id, author, version and timestamps come from the server item.
- Photos are resized to at most 2048 px, re-encoded as JPEG quality 85 (EXIF and GPS dropped),
  then encrypted, off the UI isolate.
- Names (`encryptedName`) and member profiles (`encryptedProfile`, JSON `{displayName}`) are
  base64url envelopes.

## Sync

- `watchMemories` streams from the local cache and starts a sync when first listened to.
- `sync` pages through `GET /families/:id/changes?since=<cursor>&limit=200` while `hasMore`,
  downloads and decrypts new or newer memories (4 at a time), applies tombstones, and saves the
  cursor after every page.
- `409 cursor_reset`: start again from 0. A sync from 0 drops cached memories the server no
  longer lists (deleted, or by a blocked author).
- A changed `membersVersion` refreshes the member list. `404 family_not_found` (removed from the
  family, or it was deleted) removes the family, its cache and its key from the device.
- Syncs run on app resume (for walls on screen) and after every write.
- Offline: reads work from the cache; writes fail with `network_error`. There is no offline
  write queue. A stale edit fails with `version_conflict`: sync and retry.

## Testing against the real server

```sh
cd /path/to/gk_coding_website/backend && npm ci
LIFETHREADS_FAMILY_SERVER_DIR=/path/to/gk_coding_website/backend \
  flutter test test/family/integration
```

It starts the family API with local test issuer keys and a fake Play verifier, and runs: create
family, invite, join with a second account, add a memory with a photo, sync on the other
account, check the server's files hold only ciphertext, delete both accounts.

## Store paperwork to update

- App Privacy (iOS) / Data safety (Android): account id (Apple/Google subject, linked to the
  user), user content (photos, text) stored encrypted on GK Coding servers, deletable in app.
- `ITSAppUsesNonExemptEncryption` is `false` in `Info.plist`. The family wall encrypts user
  content with standard AES-GCM; this is normally covered by the mass-market exemption, but
  confirm the export compliance answer in App Store Connect.
