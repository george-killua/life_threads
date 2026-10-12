# Story music licences

Every song in `assets/music/` and in `lib/features/stories/data/music_catalog.dart` has a row
here. A track may only be bundled when its licence clearly allows shipping it inside a
commercial app and using it in videos that users make and share, with no credit required inside
the video: CC0 1.0 or public domain (composition **and** recording). A copy of each source page as
it was on the download date is in `assets/music/licenses/` (not bundled in the app).

All recordings come from Wikimedia Commons. The public-domain ones were released by Musopen
(Musopen Symphony, the "Set Chopin Free" Kickstarter recordings and musopen.org uploads), which
dedicate them to the public domain worldwide; the CC0 ones are dedications by the uploader
(Komiku, Orchestra Gli Armonici). Credits are shown in Settings → Music credits as a courtesy.
Not used: older commercial recordings that are public domain only in the US (e.g. Barbirolli's
"Nimrod"), and Pixabay / CC BY music (see `docs/music_candidates.md`).

## How the files were made

Each file is a 60 s excerpt starting where the music begins (the start in the table), with a
0.3 s fade-in and a 3 s fade-out, loudness-normalised to -16 LUFS / -1.5 dBTP (two-pass
`loudnorm`, linear), AAC 128 kbit/s stereo 44.1 kHz:

```sh
ffmpeg -ss <start> -t 60 -i <source> \
  -af "afade=t=in:d=0.3,afade=t=out:st=57:d=3,loudnorm=I=-16:TP=-1.5:LRA=11:<measured values>:linear=true,aresample=44100" \
  -ac 2 -c:a aac -b:a 128k -movflags +faststart -map_metadata -1 <file>.m4a
```

| File | Title | Artist | Source URL | Licence | Downloaded | Saved licence copy |
|---|---|---|---|---|---|---|
| `satie_gymnopedie_1.m4a` | Gymnopédie No. 1 | Erik Satie · Robin Alciatore | [Commons](https://commons.wikimedia.org/wiki/File:Erik_Satie_-_gymnopedies_-_la_1_ere._lent_et_douloureux.ogg) | Public domain | 2026-10-13 | [`licenses/satie_gymnopedie_1.html`](licenses/satie_gymnopedie_1.html) |
| `chopin_nocturne_b49.m4a` | Nocturne in C-sharp minor | Frédéric Chopin · Frank Levy | [Commons](https://commons.wikimedia.org/wiki/File:Chopin_-_Nocturne_No._20_in_C-sharp_minor,_B._49_(Frank_Levy).flac) | Public domain | 2026-10-13 | [`licenses/chopin_nocturne_b49.html`](licenses/chopin_nocturne_b49.html) |
| `chopin_tristesse.m4a` | Étude Op. 10 No. 3 "Tristesse" | Frédéric Chopin · Edward Neeman | [Commons](https://commons.wikimedia.org/wiki/File:Chopin_-_12_%C3%89tudes,_Op._10_-_No._3_in_E_major_%27Tristesse%27_(Edward_Neeman).flac) | Public domain | 2026-10-13 | [`licenses/chopin_tristesse.html`](licenses/chopin_tristesse.html) |
| `grieg_death_of_aase.m4a` | The Death of Åse | Edvard Grieg · Musopen Symphony | [Commons](https://commons.wikimedia.org/wiki/File:Grieg_-_Peer_Gynt_Suite_No._1,_Op._46_-_II._The_Death_of_Aase_(Musopen_Symphony).flac) | Public domain | 2026-10-13 | [`licenses/grieg_death_of_aase.html`](licenses/grieg_death_of_aase.html) |
| `komiku_sad_walk.m4a` | Sad walk with sad piano | Komiku | [Commons](https://commons.wikimedia.org/wiki/File:Komiku_-_32_-_Sad_walk_with_sad_piano.ogg) | CC0 1.0 | 2026-10-13 | [`licenses/komiku_sad_walk.html`](licenses/komiku_sad_walk.html) |
| `komiku_dreaming_of_you.m4a` | Dreaming of you | Komiku | [Commons](https://commons.wikimedia.org/wiki/File:Komiku_-_08_-_Dreaming_of_you.ogg) | CC0 1.0 | 2026-10-13 | [`licenses/komiku_dreaming_of_you.html`](licenses/komiku_dreaming_of_you.html) |
| `schumann_traumerei.m4a` | Träumerei | Robert Schumann · Musopen | [Commons](https://commons.wikimedia.org/wiki/File:Robert_Schumann_-_scenes_from_childhood,_op._15_-_vii._dreaming.ogg) | Public domain | 2026-10-13 | [`licenses/schumann_traumerei.html`](licenses/schumann_traumerei.html) |
| `chopin_nocturne_op9_2.m4a` | Nocturne in E-flat major, Op. 9 No. 2 | Frédéric Chopin · Frank Levy | [Commons](https://commons.wikimedia.org/wiki/File:Chopin_-_Nocturne_No._2_in_E-flat_major,_Op._9_No._2_(Frank_Levy).flac) | Public domain | 2026-10-13 | [`licenses/chopin_nocturne_op9_2.html`](licenses/chopin_nocturne_op9_2.html) |
| `grieg_morning_mood.m4a` | Morning Mood | Edvard Grieg · Musopen Symphony | [Commons](https://commons.wikimedia.org/wiki/File:Grieg_-_Peer_Gynt_Suite_No._1,_Op._46_-_I._Morning_Mood_(Musopen_Symphony).flac) | Public domain | 2026-10-13 | [`licenses/grieg_morning_mood.html`](licenses/grieg_morning_mood.html) |
| `bach_jesu_joy.m4a` | Jesu, Joy of Man's Desiring | J. S. Bach · Orchestra Gli Armonici | [Commons](https://commons.wikimedia.org/wiki/File:Bach,_BWV_147,_10._Jesus_bleibet_meine_Freude.ogg) | CC0 1.0 | 2026-10-13 | [`licenses/bach_jesu_joy.html`](licenses/bach_jesu_joy.html) |
| `chopin_minute_waltz.m4a` | Minute Waltz | Frédéric Chopin · Olga Gurevich | [Commons](https://commons.wikimedia.org/wiki/File:Chopin_-_Waltz_No._6_in_D-flat_major,_Op._64,_No._1_%27Minute%27_(Olga_Gurevich).flac) | Public domain | 2026-10-13 | [`licenses/chopin_minute_waltz.html`](licenses/chopin_minute_waltz.html) |
| `mozart_figaro.m4a` | The Marriage of Figaro: Overture | W. A. Mozart · Musopen Symphony | [Commons](https://commons.wikimedia.org/wiki/File:Mozart_-_Le_nozze_di_Figaro,_K492_-_Overture_(Musopen_Symphony).flac) | Public domain | 2026-10-13 | [`licenses/mozart_figaro.html`](licenses/mozart_figaro.html) |
| `mendelssohn_hebrides.m4a` | The Hebrides (Fingal's Cave) | Felix Mendelssohn · Musopen Symphony | [Commons](https://commons.wikimedia.org/wiki/File:Mendelssohn_-_Hebrides_Overture,_Op._26_(Musopen_Symphony).flac) | Public domain | 2026-10-13 | [`licenses/mendelssohn_hebrides.html`](licenses/mendelssohn_hebrides.html) |

Excerpt starts (seconds into the source): `satie_gymnopedie_1.m4a` 2.2, `chopin_nocturne_b49.m4a` 0.2, `chopin_tristesse.m4a` 3.2, `grieg_death_of_aase.m4a` 1.9, `komiku_sad_walk.m4a` 0.0, `komiku_dreaming_of_you.m4a` 0.4, `schumann_traumerei.m4a` 0.0, `chopin_nocturne_op9_2.m4a` 0.2, `grieg_morning_mood.m4a` 0.0, `bach_jesu_joy.m4a` 2.2, `chopin_minute_waltz.m4a` 0.9, `mozart_figaro.m4a` 0.0, `mendelssohn_hebrides.m4a` 10.9.
