# LifeThreads – Sync Plan (iPhone ⇄ Android)

Decided 15 October 2026: Premium syncs the private wall between devices,
across iOS and Android, through GK Coding's own server with **end-to-end
encryption**. Status: design – waiting for the server code (roadmap step 9).

## Why

- People expect their memories on a new phone or a second device without
  exporting a backup file. For a paid app it is the most likely complaint.
- iCloud only works between Apple devices; Google Drive needs every user to
  sign in to Google. The family-wall server already has accounts (Sign in
  with Apple / Google) on both platforms.

## What changes for the privacy promise

Since 12 October the app says "GK Coding keeps no copy of your memories"
(Cloud Sync was retired then). With sync it becomes: **"With sync on,
GK Coding keeps an encrypted copy it cannot read."** Sync is optional and
off by default. Privacy policy, App Store privacy labels and Play Data
safety must be updated before release.

## Architecture

```text
App ──(sign-in, "may I upload?")──▶ VPS: family-wall server (Node)
App ──(encrypted blobs, directly)──▶ IONOS S3 Object Storage
```

- **VPS** (existing): accounts, Premium check, hands out short-lived
  presigned upload/download URLs, keeps the index (which blobs exist, their
  versions). Little data, many small requests.
- **Object storage** (IONOS S3, EU): the encrypted blobs. Pay per GB,
  redundant. Written against the standard S3 API, so the provider can be
  changed (Hetzner, Backblaze, Cloudflare R2) without an app update.
- Big traffic (photos) never passes through the VPS.

## Encryption

- A random 256-bit **sync key** per user, made on the first device.
- Everything is encrypted on the device with AES-256-GCM (the same envelope
  as family walls and archives) before upload. The server only sees
  encrypted blobs, their sizes and timestamps.
- The key is kept in the Keychain / Keystore. A second device gets it by:
  - a **recovery code** shown once when sync is turned on (24 words or a
    printable code), or
  - scanning a QR code on the first device.
- Without the key nobody – including GK Coding – can read the data. Lost
  key and recovery code = the cloud copy cannot be restored (the devices
  still have their data).

## What is synced

| Data | How |
|---|---|
| Memories, people, threads, notes, nails, walls, hidden flag | Records: one encrypted JSON document per item with a version; last write wins per item, deletions as tombstones |
| Photos | One encrypted blob per photo, uploaded once (content hash), referenced by records |
| Settings (theme, name, language) | Not synced (per device) |
| Family walls | Unchanged (already on the server) |

## Server endpoints (draft)

| Method | Path | Purpose |
|---|---|---|
| POST | `/sync/enable` | Premium check; registers the user's sync space |
| GET | `/sync/changes?since=<cursor>` | Record changes since a cursor |
| POST | `/sync/records` | Upload changed records (encrypted), returns new cursor |
| POST | `/sync/photos/upload-url` | Presigned PUT URL for a photo blob |
| POST | `/sync/photos/download-url` | Presigned GET URL |
| DELETE | `/sync` | Delete the whole cloud copy (also on account deletion) |

Quota: e.g. 10 GB per Premium user; when Premium ends the copy is kept
read-only for 90 days, then deleted (said in the app and the policy).

## App side

- Settings › Sync: on/off, status ("Synced 2 minutes ago"), recovery code,
  "Delete cloud copy".
- Background upload after changes (debounced), on app start and resume.
- New device: sign in → "A synced wall was found – restore it?" → recovery
  code or QR.

## Costs

See [business_numbers.md](business_numbers.md): about 1 GB per Premium
user, a few cents per user per month on object storage.

## Open steps

1. George: git repo with the family-wall server code (roadmap step 9).
2. George: IONOS S3 Object Storage bucket + access key, budget alert €20.
3. Claude: server endpoints with tests; app side with tests; UI flow.
4. Both: privacy policy, App Store privacy labels, Play Data safety.
