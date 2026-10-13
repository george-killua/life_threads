enum MusicMood { warm, joyful, calm, nostalgic, epic, emotional }

/// A song bundled with the app for story videos. Every track needs a license
/// that allows shipping it inside a commercial app; its record lives in
/// assets/music/LICENSES.md.
class MusicTrack {
  const MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.mood,
    required this.assetPath,
    required this.length,
    required this.license,
    required this.sourceUrl,
    this.peaks = const [],
  });

  final String id;
  final String title;
  final String artist;
  final MusicMood mood;

  /// AAC (.m4a) asset, the format the video encoder copies without
  /// re-encoding.
  final String assetPath;
  final Duration length;
  final String license;
  final String sourceUrl;

  /// Loudness outline of the file (0–100, evenly spread over [length]),
  /// drawn as the waveform when choosing which part of the song plays.
  final List<int> peaks;
}
