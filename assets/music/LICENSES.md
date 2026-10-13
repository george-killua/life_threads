# Story music licences

Every song in `assets/music/` and in `lib/features/stories/data/music_catalog.dart` has a row
here. A track may only be bundled when its licence clearly allows shipping it inside a
commercial app and using it in videos that users make and share, with no credit required inside
the video: CC0 1.0 or public domain. A copy of each source page as it was on the download date is
in `assets/music/licenses/` (not bundled in the app).

All songs are released under CC0 1.0 by their authors: HoliznaCC0 (every release on the Free
Music Archive is CC0; the album pages state `creativecommons.org/publicdomain/zero/1.0/`) and
Komiku (CC0 uploads on Wikimedia Commons). Credits are shown in Settings → Music credits as a
courtesy.

## How the files were made

The first 120 s of each song (users pick which part plays), with a 2.5 s fade-out at the end,
loudness-normalised to -16 LUFS / -1.5 dBTP (two-pass `loudnorm`, linear), AAC 96 kbit/s stereo
44.1 kHz. `peaks` in the catalog is the RMS loudness of 50 equal slices of the encoded file,
scaled to 0–100.

```sh
ffmpeg -t 120 -i <source> -vn \
  -af "afade=t=out:st=117.5:d=2.5,loudnorm=I=-16:TP=-1.5:LRA=11:<measured values>:linear=true,aresample=44100" \
  -ac 2 -c:a aac -b:a 96k -movflags +faststart -map_metadata -1 <file>.m4a
```

| File | Title | Artist | Source URL | Licence | Downloaded | Saved licence copy |
|---|---|---|---|---|---|---|
| `holizna_we_used_to_dance.m4a` | We Used To Dance | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/waves-of-nostalgia-2/we-used-to-dance/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_we_used_to_dance.html`](licenses/holizna_we_used_to_dance.html) |
| `holizna_letting_go_of_the_past.m4a` | Letting Go Of The Past | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/lo-fi-and-chill/letting-go-of-the-past/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_letting_go_of_the_past.html`](licenses/holizna_letting_go_of_the_past.html) |
| `holizna_you_loved_me_once.m4a` | You Loved Me Once | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/lo-fi-and-chill/you-loved-me-once/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_you_loved_me_once.html`](licenses/holizna_you_loved_me_once.html) |
| `holizna_lullabies_for_the_end_of_the_world.m4a` | Lullabies For The End Of The World #1 | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/lullabies-for-the-end-of-the-world/lullabies-for-the-end-of-the-world-1/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_lullabies_for_the_end_of_the_world.html`](licenses/holizna_lullabies_for_the_end_of_the_world.html) |
| `komiku_sad_walk.m4a` | Sad walk with sad piano | Komiku | [source](https://commons.wikimedia.org/wiki/File:Komiku_-_32_-_Sad_walk_with_sad_piano.ogg) | CC0 1.0 | 2026-10-13 | [`licenses/komiku_sad_walk.html`](licenses/komiku_sad_walk.html) |
| `holizna_summer_felt_longer_then.m4a` | Summer Felt Longer Then | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/summer-air-lo-fi/summer-felt-longer-then/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_summer_felt_longer_then.html`](licenses/holizna_summer_felt_longer_then.html) |
| `holizna_august_never_lasts.m4a` | August Never Lasts | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/summer-air-lo-fi/august-never-lasts/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_august_never_lasts.html`](licenses/holizna_august_never_lasts.html) |
| `holizna_ocean_memory.m4a` | Ocean Memory | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/ocean-memory-lo-fi-chill/ocean-memory/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_ocean_memory.html`](licenses/holizna_ocean_memory.html) |
| `holizna_life_on_cassette.m4a` | Life On Cassette | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/be-happy-with-who-you-are/life-on-cassette/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_life_on_cassette.html`](licenses/holizna_life_on_cassette.html) |
| `holizna_yesterday.m4a` | Yesterday | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/lo-fi-and-chill/yesterday-1/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_yesterday.html`](licenses/holizna_yesterday.html) |
| `komiku_dreaming_of_you.m4a` | Dreaming of you | Komiku | [source](https://commons.wikimedia.org/wiki/File:Komiku_-_08_-_Dreaming_of_you.ogg) | CC0 1.0 | 2026-10-13 | [`licenses/komiku_dreaming_of_you.html`](licenses/komiku_dreaming_of_you.html) |
| `holizna_morning_coffee.m4a` | Morning Coffee | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/lo-fi-and-chill/morning-coffee/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_morning_coffee.html`](licenses/holizna_morning_coffee.html) |
| `holizna_seasons_change.m4a` | Seasons Change | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/lo-fi-and-chill/seasons-change/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_seasons_change.html`](licenses/holizna_seasons_change.html) |
| `holizna_feeling_human_again.m4a` | Feeling Human Again | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/spring-woke-me-up/feeling-human-again/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_feeling_human_again.html`](licenses/holizna_feeling_human_again.html) |
| `holizna_puppy_love.m4a` | Puppy Love | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/lo-fi-and-chill/puppy-love/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_puppy_love.html`](licenses/holizna_puppy_love.html) |
| `holizna_the_good_times.m4a` | The Good Times | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/be-happy-with-who-you-are/the-good-times/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_the_good_times.html`](licenses/holizna_the_good_times.html) |
| `holizna_spring_in_sight.m4a` | Spring In Sight | HoliznaCC0 | [source](https://freemusicarchive.org/music/holiznacc0/spring-woke-me-up/spring-in-sight/) | CC0 1.0 | 2026-10-13 | [`licenses/holizna_spring_in_sight.html`](licenses/holizna_spring_in_sight.html) |
