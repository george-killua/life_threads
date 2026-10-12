import '../domain/music_track.dart';

/// Songs bundled for story videos and Thread of the Year films. Every entry
/// needs a row in assets/music/LICENSES.md (a test checks this) and is listed
/// in Settings under the music credits.
///
/// Each file is a 60 s excerpt of a public-domain or CC0 recording from
/// Wikimedia Commons, loudness-normalised to -16 LUFS (see
/// assets/music/LICENSES.md). Emotional tracks come first.
const bundledMusicTracks = <MusicTrack>[
  MusicTrack(
    id: 'satie-gymnopedie-1',
    title: 'Gymnopédie No. 1',
    artist: 'Erik Satie · Robin Alciatore',
    mood: MusicMood.emotional,
    assetPath: 'assets/music/satie_gymnopedie_1.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Erik_Satie_-_gymnopedies_-_la_1_ere._lent_et_douloureux.ogg',
  ),
  MusicTrack(
    id: 'chopin-nocturne-b49',
    title: 'Nocturne in C-sharp minor',
    artist: 'Frédéric Chopin · Frank Levy',
    mood: MusicMood.emotional,
    assetPath: 'assets/music/chopin_nocturne_b49.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Chopin_-_Nocturne_No._20_in_C-sharp_minor,_B._49_(Frank_Levy).flac',
  ),
  MusicTrack(
    id: 'chopin-tristesse',
    title: 'Étude Op. 10 No. 3 "Tristesse"',
    artist: 'Frédéric Chopin · Edward Neeman',
    mood: MusicMood.emotional,
    assetPath: 'assets/music/chopin_tristesse.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Chopin_-_12_%C3%89tudes,_Op._10_-_No._3_in_E_major_%27Tristesse%27_(Edward_Neeman).flac',
  ),
  MusicTrack(
    id: 'grieg-death-of-aase',
    title: 'The Death of Åse',
    artist: 'Edvard Grieg · Musopen Symphony',
    mood: MusicMood.emotional,
    assetPath: 'assets/music/grieg_death_of_aase.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Grieg_-_Peer_Gynt_Suite_No._1,_Op._46_-_II._The_Death_of_Aase_(Musopen_Symphony).flac',
  ),
  MusicTrack(
    id: 'komiku-sad-walk',
    title: 'Sad walk with sad piano',
    artist: 'Komiku',
    mood: MusicMood.emotional,
    assetPath: 'assets/music/komiku_sad_walk.m4a',
    length: Duration(seconds: 60),
    license: 'CC0 1.0',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Komiku_-_32_-_Sad_walk_with_sad_piano.ogg',
  ),
  MusicTrack(
    id: 'komiku-dreaming-of-you',
    title: 'Dreaming of you',
    artist: 'Komiku',
    mood: MusicMood.nostalgic,
    assetPath: 'assets/music/komiku_dreaming_of_you.m4a',
    length: Duration(seconds: 60),
    license: 'CC0 1.0',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Komiku_-_08_-_Dreaming_of_you.ogg',
  ),
  MusicTrack(
    id: 'schumann-traumerei',
    title: 'Träumerei',
    artist: 'Robert Schumann · Musopen',
    mood: MusicMood.calm,
    assetPath: 'assets/music/schumann_traumerei.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Robert_Schumann_-_scenes_from_childhood,_op._15_-_vii._dreaming.ogg',
  ),
  MusicTrack(
    id: 'chopin-nocturne-op9-2',
    title: 'Nocturne in E-flat major, Op. 9 No. 2',
    artist: 'Frédéric Chopin · Frank Levy',
    mood: MusicMood.warm,
    assetPath: 'assets/music/chopin_nocturne_op9_2.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Chopin_-_Nocturne_No._2_in_E-flat_major,_Op._9_No._2_(Frank_Levy).flac',
  ),
  MusicTrack(
    id: 'grieg-morning-mood',
    title: 'Morning Mood',
    artist: 'Edvard Grieg · Musopen Symphony',
    mood: MusicMood.warm,
    assetPath: 'assets/music/grieg_morning_mood.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Grieg_-_Peer_Gynt_Suite_No._1,_Op._46_-_I._Morning_Mood_(Musopen_Symphony).flac',
  ),
  MusicTrack(
    id: 'bach-jesu-joy',
    title: "Jesu, Joy of Man's Desiring",
    artist: 'J. S. Bach · Orchestra Gli Armonici',
    mood: MusicMood.warm,
    assetPath: 'assets/music/bach_jesu_joy.m4a',
    length: Duration(seconds: 60),
    license: 'CC0 1.0',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Bach,_BWV_147,_10._Jesus_bleibet_meine_Freude.ogg',
  ),
  MusicTrack(
    id: 'chopin-minute-waltz',
    title: 'Minute Waltz',
    artist: 'Frédéric Chopin · Olga Gurevich',
    mood: MusicMood.joyful,
    assetPath: 'assets/music/chopin_minute_waltz.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Chopin_-_Waltz_No._6_in_D-flat_major,_Op._64,_No._1_%27Minute%27_(Olga_Gurevich).flac',
  ),
  MusicTrack(
    id: 'mozart-figaro',
    title: 'The Marriage of Figaro: Overture',
    artist: 'W. A. Mozart · Musopen Symphony',
    mood: MusicMood.joyful,
    assetPath: 'assets/music/mozart_figaro.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Mozart_-_Le_nozze_di_Figaro,_K492_-_Overture_(Musopen_Symphony).flac',
  ),
  MusicTrack(
    id: 'mendelssohn-hebrides',
    title: "The Hebrides (Fingal's Cave)",
    artist: 'Felix Mendelssohn · Musopen Symphony',
    mood: MusicMood.epic,
    assetPath: 'assets/music/mendelssohn_hebrides.m4a',
    length: Duration(seconds: 60),
    license: 'Public domain',
    sourceUrl:
        'https://commons.wikimedia.org/wiki/File:Mendelssohn_-_Hebrides_Overture,_Op._26_(Musopen_Symphony).flac',
  ),
];
