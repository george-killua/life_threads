# LifeThreads Privacy Policy

Effective date: October 15, 2026

LifeThreads is developed by GK Coding.

Contact: `info@gkcoding.dev`

Public policy URL: `https://gkcoding.dev/lifethreads/privacy`

## 1. Overview

LifeThreads is a local-first private memory wall app. It helps you create memories with photos, titles, stories, dates, feelings, categories, locations, notes, people, and visual connections between moments.

Your own wall ("My wall") needs no account. LifeThreads does not provide a public profile, does not include advertising, and does not include in-app chat.

Your LifeThreads data stays on your device. GK Coding does not keep a copy of the memories on My wall. Data leaves your device only when you choose to: an exported backup file goes wherever you send it, a shared memory capsule is uploaded encrypted to GK Coding servers for a limited time, a wall display sends a temporary snapshot to the browser screen you scanned, and memories you add to a family wall are stored end-to-end encrypted on GK Coding servers for as long as they are on that wall (see section 8c).

Family walls are optional. Using one requires an account through Sign in with Apple or Google Sign-In.

## 2. Information You Add to LifeThreads

You may choose to add the following information:

- photos
- memory titles
- memory stories or descriptions
- dates and times
- feelings and categories
- location names
- optional latitude and longitude
- text notes
- people names, relationships, phone numbers, or email addresses that you manually add
- wall positions, nails, anchors, and connection labels
- relationships between memories

This information is stored locally on your device unless you choose to export, share, or back it up yourself.

## 3. Photos, Camera, and Media Access

LifeThreads requests photo/media access so you can select photos for your memories.

LifeThreads may also request camera access when you choose to take a new memory photo or scan a wall-display QR code. Camera use is optional and only happens when you start those actions.

When you select or capture photos, LifeThreads may copy those files into the app's private local storage. This lets the app show your memories later even if the original photo is moved or no longer available through the photo picker.

LifeThreads does not upload selected or captured photos to GK Coding unless you choose to create a shared memory capsule, add them to a family wall, or use another export/share action.

## 3a. Contacts Access

LifeThreads may request contacts access only when you choose to import selected contact details into a private memory person entry. Contacts are not uploaded automatically. Imported contact fields you keep in a memory stay local unless that memory is included in a backup file or shared capsule you choose to create.

## 4. Photo Metadata

When available and permitted by your device, LifeThreads may read metadata from selected photos, including:

- capture date
- image width and height
- location metadata such as latitude and longitude

This metadata is used to pre-fill memory details, organize memories, and show memories on the map. Metadata is stored locally on your device with the memory. If you share a memory capsule, metadata included in that memory may be included inside the encrypted capsule.

## 5. Location Information

LifeThreads may store location information when you choose a photo that contains location metadata. If no location metadata exists in the selected photos, location details are hidden and no manual location is required.

LifeThreads does not request background location access. The app does not track your live location in the background.

If you open map features, LifeThreads loads map tiles from OpenFreeMap, using OpenMapTiles and OpenStreetMap data. Map tile requests may reveal technical information, such as your IP address and the requested map area, to the map tile provider. This is necessary to display the map.

To show a place name such as “Split, Croatia” instead of coordinates, LifeThreads asks your phone's built-in geocoding service for the name of a memory's photo location: Apple's on iPhone and iPad, Google's on Android. The coordinates are sent for this lookup, without your photos, stories or other memory content, and only the place name is stored with the memory. Offline, the coordinates are kept and the name is looked up later.

## 6. Local Storage

LifeThreads stores app data locally on your device, including:

- memory database records
- copied memory photos
- wall layout data
- notes and connection labels
- people you add to memories
- local settings
- premium entitlement state after purchase or restore

If you delete the app or clear app data, locally stored LifeThreads data may be removed from your device unless you created and kept a backup.

Your device's own transfer tools may copy LifeThreads data to a new device: on Android, a device-to-device transfer when you set up a new phone; on iPhone, your iCloud device backup or a direct transfer, if you use them. These copies are made by your device's operating system under your Apple or Google account settings. LifeThreads does not send its data to Google's cloud backup.

## 7. Backups, Export, Import, and Memory Capsules

LifeThreads lets you export a backup file containing your memories, metadata, notes, connections, people, wall layout, and copied photos. Backups are free and can be protected with a password, which encrypts the file.

The backup file is handed to your device's share sheet. You decide where it is saved, for example on your computer or in your own cloud storage. LifeThreads does not upload backup files to GK Coding and removes its temporary copy afterwards. LifeThreads may remind you to save a new backup when you have added memories since your last one.

LifeThreads also supports portable memory capsules. A capsule contains one memory and related content, such as photos, story text, metadata, people, notes, and connections.

Important: exported backup files and memory capsules may contain private photos, stories, locations, people data, and metadata. Keep backup files and capsule passwords private.

Importing a backup or capsule reads the file you choose and restores its content into LifeThreads local storage. The app shows a preview before importing a shared capsule.

## 8. Cloud Memory Sharing

If you choose “Share Memory Capsule”, LifeThreads creates an encrypted capsule and uploads it to GK Coding servers. GK Coding stores the encrypted capsule file, basic share metadata, an expiry date, and a revoke token used to delete the shared link.

Shared capsule links expire automatically, and the encrypted capsule file is then deleted from GK Coding servers. The app may also show a delete action after a link is created so you can revoke the shared capsule earlier.

GK Coding cannot read the contents of encrypted memory capsules without the password you chose. You should send the password separately from the share link.

People who receive a valid share link and password can download and import the shared memory into their own LifeThreads app. LifeThreads does not provide public feeds, public profiles, comments, likes, chat, or user discovery.

## 8a. Wall Display

If you scan a display QR code shown on `lifethreads.gkcoding.dev/display`, LifeThreads sends a read-only snapshot of your wall to that browser session. The snapshot contains the memories on the wall, including their photos, titles, stories, dates, places, and connections. It is not password-encrypted, because the browser needs to show it. The display session is temporary: the snapshot is deleted from GK Coding servers when the session expires, at most 60 minutes after it was created.

## 8b. Earlier Cloud Sync Backups

Earlier versions of LifeThreads offered Cloud Sync, which uploaded a password-protected encrypted backup archive to GK Coding servers. Cloud Sync has been retired and accepts no new backups. Archives uploaded before can still be restored or deleted from an older app version until GK Coding deletes all remaining archives. GK Coding cannot read these archives without the password you chose.

## 8c. Family Walls

Family walls are optional shared walls for people you invite, for example your family or friends. My wall is never part of a family wall.

**Account.** To use family walls you sign in with Sign in with Apple (on iPhone and iPad) or Google Sign-In. GK Coding receives an account identifier from Apple or Google to recognise your account. We do not receive your contacts, your photo library, or your Apple or Google password.

**End-to-end encryption.** Each family wall has its own key. The key is created on the device of the person who starts the wall, kept in your device's secure storage (Keychain on iPhone, Keystore on Android), and passed to new members only inside the invite link. The part of the link that carries the key is never sent to GK Coding servers. Before anything is uploaded, your device encrypts it with that key: the memories you add (title, story, date, place, feeling, category), their photos (resized before upload), the family wall's name, and the display name you choose for that wall. GK Coding stores only the encrypted data and cannot read it.

**What GK Coding servers can see.** To run family walls, GK Coding processes data that is not end-to-end encrypted:

- your account identifier and when the account was created
- which family walls you belong to, your role (owner or member), and which invite you joined with
- the number, size, and timestamps of encrypted memories and photos, and which account added each one
- invite links' expiry and whether they were used (not the key)
- accepted terms version, blocks you set, and reports you submit
- whether the family wall owner has an active Premium subscription (see section 9)
- technical data needed to deliver requests, such as your IP address

**Reports.** You can report a memory or a member. A report contains the reason you pick, your optional note, which memory or member it concerns, and, for a memory, its decrypted title and story so that GK Coding can review it. Photos are never sent with a report. Reports are sent to GK Coding and reviewed within 24 hours. GK Coding may remove reported content and suspend or delete accounts that break the Terms of Use.

**Blocking.** If you block a member, LifeThreads hides their memories from you. The blocked member is not told.

**Leaving, removal, and deletion.** You can leave a family wall and choose to delete the memories you added. The owner can remove members and their memories, and can delete the whole family wall, which deletes all of its memories and photos from GK Coding servers. Deleting your account (section 13) deletes the family walls you own and the memories you added to other walls.

**Photos on your device.** Family wall photos you open are decrypted and kept in the app's private cache on your device so the wall can be shown offline. Signing out or deleting your account removes family wall data and keys from the device.

## 9. Purchases and Premium Unlock

LifeThreads may offer an optional monthly Premium subscription through Google Play Billing or the Apple App Store.

Purchases are processed by Google Play or Apple. GK Coding does not receive or store your payment card details.

The app may store a local premium entitlement flag after a successful purchase or restore. Google Play and Apple may process purchase-related information according to their own terms and privacy policies.

Starting a family wall needs an active Premium subscription of its owner. When you start one, the app sends your store purchase token or receipt to GK Coding, and GK Coding checks it with Google Play or Apple and stores whether the subscription is active and when it ends. Members who join a family wall do not need Premium.

## 10. Internet Access

LifeThreads uses internet access for:

- loading map tiles when map features are opened
- looking up place names for photo locations with Apple's or Google's geocoding service
- communicating with Google Play Billing for optional purchases and purchase restoration
- uploading encrypted shared memory capsules when you choose cloud sharing
- downloading shared memory capsules when you open a LifeThreads share link
- sending a temporary wall snapshot when you choose to display your wall on another screen
- signing in, syncing encrypted family wall memories and photos, invites, reports, and subscription checks when you use family walls

LifeThreads does not use internet access for advertising or analytics.

## 11. Data Sharing

GK Coding does not sell your LifeThreads data.

GK Coding does not share your memories, photos, notes, stories, people data, or locations with advertisers.

The current version does not include advertising SDKs or analytics SDKs.

Third-party services may process limited technical data when their features are used:

- OpenFreeMap may receive map tile requests when map views are opened.
- Apple (on iPhone and iPad) or Google (on Android) receive a photo's coordinates when LifeThreads looks up its place name.
- Google Play or Apple may process purchase-related information when you buy or restore premium unlocks.
- Apple (Sign in with Apple) or Google (Google Sign-In) process your sign-in when you use family walls.
- GK Coding infrastructure processes encrypted memory capsule uploads and downloads, temporary wall display snapshots, and encrypted family wall data only when you choose those features.

Members of a family wall see the memories, photos, and display names that other members add to it. That is the purpose of a family wall.

## 12. Data Security

LifeThreads is designed to minimize data transmission by keeping memories local-first.

Cloud-shared memory capsules and family wall memories and photos are encrypted on your device before upload. Anyone who has a family wall's invite link can use it once to join that wall before it expires (at most 7 days), so send invite links only to the people you invite. Share links are not public listings and expire automatically, but anyone with a capsule link can access the encrypted capsule file until it expires or is deleted. Anyone who has a password-protected backup file and its password can restore it, so keep both private.

Because your memories are stored on your device, device security matters. Use a secure device passcode, keep your operating system updated, protect exported backup files, and share capsule passwords carefully.

LifeThreads cannot protect data that you manually export, share, store in another app or cloud service, or send to another person.

## 13. Data Deletion

You can delete individual memories inside the app.

You can remove local LifeThreads data by using the app's clear-data option where available, clearing app data in your device settings, or uninstalling the app.

You can delete a shared memory capsule link from the app immediately after creating it when the delete action is shown. Shared capsule links and wall display sessions also expire automatically.

You can delete your family wall account in the app at any time (Settings > Family walls > Account > Delete account). This deletes your account, the family walls you own with all of their memories and photos (for every member), and the memories and photos you added to other family walls, from GK Coding servers. It also removes family wall data and keys from your device. My wall stays on your device. Deleting the account does not cancel a Premium subscription; manage that in Google Play or the App Store. Reports about content that broke the rules may be kept as long as needed to handle them and to meet legal obligations.

For help with deletion requests, use: `https://gkcoding.dev/lifethreads/delete-data` or contact `info@gkcoding.dev`.

GK Coding cannot remotely delete data stored only on your device. GK Coding can only help with server-side data that was uploaded through cloud memory sharing, a wall display, family walls, or the earlier Cloud Sync and can be identified. If you can no longer open the app, you can request deletion of your family wall account through the page above.

## 14. Children's Privacy

LifeThreads is not directed to children. If a child or minor uses LifeThreads, a parent or guardian should supervise the use of personal photos, stories, people information, and location information.

## 15. Future Features

If LifeThreads later adds analytics, crash reporting, or other online services, this policy will be updated before those features are released.

## 16. Changes to This Policy

GK Coding may update this privacy policy when LifeThreads changes or when legal, platform, or operational requirements change.

The updated policy will include a new effective date.

## 17. Contact

For privacy questions, contact:

`info@gkcoding.dev`
