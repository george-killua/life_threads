enum MusicMood { warm, joyful, calm, nostalgic, epic }

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
}
