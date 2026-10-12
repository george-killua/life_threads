import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/music_track.dart';

/// Plays a bundled song while the user picks music for a story or a Thread
/// of the Year film. Overridden in tests.
final musicPreviewProvider = Provider<MusicPreview>((ref) {
  final preview = AudioplayersMusicPreview();
  ref.onDispose(preview.dispose);
  return preview;
});

abstract interface class MusicPreview {
  /// Plays [track] from the start, replacing what is playing.
  Future<void> play(MusicTrack track);

  Future<void> stop();
}

class AudioplayersMusicPreview implements MusicPreview {
  AudioPlayer? _player;

  /// Created on first use, so screens that never play music never touch the
  /// platform player.
  Future<AudioPlayer> _ensurePlayer() async {
    final existing = _player;
    if (existing != null) return existing;
    final player = AudioPlayer()
      // Catalog paths already start with "assets/".
      ..audioCache = AudioCache(prefix: '');
    // Plays even with the ring/silent switch on silent, like the exported
    // video does in Photos.
    await player.setAudioContext(
      AudioContextConfig(respectSilence: false).build(),
    );
    await player.setReleaseMode(ReleaseMode.stop);
    return _player = player;
  }

  @override
  Future<void> play(MusicTrack track) async {
    final player = await _ensurePlayer();
    await player.stop();
    await player.play(AssetSource(track.assetPath));
  }

  @override
  Future<void> stop() async => _player?.stop();

  void dispose() => unawaited(_player?.dispose());
}
