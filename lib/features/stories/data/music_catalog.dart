import '../domain/music_track.dart';

/// Songs bundled for story videos. Every entry needs a row in
/// assets/music/LICENSES.md (a test checks this) and is listed in Settings
/// under the music credits.
///
/// Real tracks are added once their licences are approved; candidates are
/// in docs/music_candidates.md. Until then the catalog holds one generated
/// placeholder so the music path (asset copy, trim, fade, mux) runs end to
/// end.
const bundledMusicTracks = <MusicTrack>[
  MusicTrack(
    id: 'placeholder-pad',
    title: 'Placeholder pad',
    artist: 'LifeThreads (generated)',
    mood: MusicMood.calm,
    assetPath: 'assets/music/placeholder_pad.m4a',
    length: Duration(seconds: 30),
    license: 'CC0 1.0',
    sourceUrl: 'tool/music/make_placeholder_pad.py',
  ),
];
