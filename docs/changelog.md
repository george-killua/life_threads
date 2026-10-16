# LifeThreads – Changelog

What changed in each TestFlight / Play build. Newest first.

## 1.0.0 (22) – 16 October 2026

Uploaded to TestFlight and to Google Play closed testing (alpha).

**View sheet**
- Choices apply only with **Done**; closing the sheet another way leaves
  the wall as it was. Hidden memories still ask for Face ID right away.
- After Done the cards **move** from their old places to the new
  arrangement (threads follow), and a new category **fades** cards out and
  in. Not with Reduce Motion.

**Thread of the Year**
- **Memories from:** with walls of one's own, choose All my walls, My wall
  or one wall; starts with the wall on screen.
- Years that aren't ready yet (this year and earlier ones) show the
  memories that already count – tap one to fix a wrong date – and **Add a
  memory to 2024**, which starts the new memory on the same day back then
  (a photo's own date still wins).
- When a year is ready, the years that are nearly there are listed below
  the film under "Almost there".
- **Fixed:** after saving a memory, a draft autosave that was still
  writing could bring it back as a draft; the next "Add memory" then asked
  to continue it, and "Start new" could delete the saved memory's photo
  copies. Draft saves and clears now run in order, and "Start new" never
  deletes a photo a saved memory uses.
- **Demo memories you changed count as yours** (Thread of the Year, On this
  day): once their date, title or story differs from the demo wall. Untouched
  demo memories still stay out.

## 1.0.0 (21) – 16 October 2026

Uploaded to TestFlight and to Google Play closed testing (alpha).

**New**
- **Home screen widget** (iPhone and Android, free): a memory from your wall
  with its photo – one from this day in an earlier year when there is one,
  otherwise a different memory each day. Tapping it opens the memory. Small,
  medium and large on iPhone; resizable on Android. With the app lock on it
  shows "LifeThreads is locked" and no memory or photo. Hidden memories never
  appear. Details: [home_widget.md](home_widget.md).
- **Unfinished memories are kept as drafts**: "Add memory" saves while you
  type. Leaving shows "Kept as a draft"; the next time it asks "Continue where
  you left off?" with *Continue draft* / *Start new*. Survives closing the app.
- **Look back on a month**: More › Look back on a month shows "Your
  September" – its memories, the people in them and the places, with arrows
  to other months and "Create story". In the first week of a month a card on
  the wall offers the month before (Thread of the Year's card goes first in
  January). With On this day reminders on, a notification on the 1st:
  "September: 5 memories to look back on."

**Fixed**
- The demo wall stayed empty when chosen in onboarding (the widget had
  loaded the memories before onboarding finished).
- Look back on a month: an empty month is centered on the screen.
- **iOS swipe back works again** on every screen, and screens slide in and
  out. go_router 18 didn't recognise the app as a Material app on this
  Flutter version and showed pages without transition or back gesture;
  routes now build Material pages themselves (`material_route.dart`).
- **A tap outside a text field closes the keyboard** on every screen, also
  when the tap lands on a button or card; scrolling leaves it open.
- **Widget settings** (Settings › Home screen widget): which wall's
  memories, On this day first, memories with photos first, a preview and
  how to add the widget.
- **Empty widget** offers **Add a memory** and **Take photo** (straight to
  the camera).
- Opening a memory from the widget switches the wall screen to the wall
  that memory hangs on (the widget shows memories from every wall).
- The View sheet has a Done button (at the largest text size it fills the
  screen and could only be closed by dragging).

**Tests**: 370 automated tests pass; UI test flow `13_drafts_look_back`
(WAL-11, WAL-12) added.

## 1.0.0 (20) – 15 October 2026

**New**
- **Yearly Premium plan** (`lifethreads_premium_yearly`, €34.99): shown
  first on the Premium page with its saving ("Save 41%"); Monthly beside it.
  Without a yearly product in the store, monthly is offered alone.
- **Empty screens offer a next step**:
  - New wall: "Move memories here" (pick memories from other walls).
  - Timeline / map with nothing to show: "Add a memory", "Show all".
  - Search: suggestions from your own places, people and years before
    typing; "Clear search" when nothing matches.
  - Bottom chip: a memory from this week in an earlier year ("This week,
    3 years ago") when nothing happened on this date.
  - Thread of the Year: progress per year ("2025 · 2 of 3 memories"),
    "Add a memory", "Or make a story now".
  - Stories: "Add a memory". Memory without people: "Who was there? Add
    person". Without threads: "Connect".

**Better**
- Walls with hundreds of memories stay smooth: only cards near the screen
  are built, card photos are decoded at card size (about 20× less memory),
  the cards hang still with Reduce Motion.
- Onboarding in 4 steps (privacy is one of the "How it works" cards).

## 1.0.0 (19) – 15 October 2026

(Build 18 has the same code; uploaded twice by mistake.)

**New**
- **Several walls** (Premium): More › New wall; the wall switcher lists
  them with rename and delete (a deleted wall's memories go back to My
  wall); "Move to wall…" in a memory's menu.
- **Hidden memories**: hide from a memory's menu; View › Hidden memories
  shows them after Face ID or the passcode. Left out of search, On this day,
  Thread of the Year and stories.
- **App lock** (free): Settings › Privacy › App lock with Face ID / Touch ID
  / passcode; blurred in the app switcher; On this day notifications name no
  memory while it is on.
- **Search**: by title, place, person or year, ignoring case and accents.
- **Undo** after deleting a memory, note or nail (instead of "Are you
  sure?").
- **Edit pencils** on the memory screen open the edit screen at that
  section; **Open in Maps** on the Place card.
- **Connected memories** as polaroids on a rope, with the reason for each
  thread.
- **Place names** ("Split, Croatia") instead of coordinates; older memories
  get their names in the background.
- **Timeline grouped by year** with headings that stay on top.

**Better**
- Fixed top bars on every screen; **Save** in the top bar of edit screens,
  with "Discard changes?" when leaving.
- **Settings** as a short list; Backup & data and About & help have their
  own screens; Thread of the Year and Family walls are in the More menu.
- The add button is a round "+" opening an "Add to your wall" sheet; the
  View sheet's options fill the width.
- Thread of the Year card and export buttons laid out evenly.
- Large text sizes (up to 2×) without split words or cut-off labels.
- Light haptics when a card lands, a thread connects or a memory is hung.
- The demo wall speaks the app's language, also after a language change.
- The Premium page no longer says "Purchase failed" when the store can't
  load the offer; it offers "Try again".

**Fixed**
- A crash when naming a new wall.
- Wrong accessibility frames on the wall (VoiceOver focus boxes and UI test
  taps landed in the wrong place).
- Thread of the Year preview unreadable for VoiceOver while playing.

## 1.0.0 (17) – earlier

See git history before commit `641dc73`.
