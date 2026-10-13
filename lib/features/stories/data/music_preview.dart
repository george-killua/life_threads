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
  /// Plays [track] from [start], replacing what is playing. With [length],
  /// only that part plays, over and over (the part the film will use).
  Future<void> play(
    MusicTrack track, {
    Duration start = Duration.zero,
    Duration? length,
  });

  Future<void> stop();
}

class AudioplayersMusicPreview implements MusicPreview {
  AudioPlayer? _player;
  StreamSubscription<Duration>? _loop;

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
  Future<void> play(
    MusicTrack track, {
    Duration start = Duration.zero,
    Duration? length,
  }) async {
    final player = await _ensurePlayer();
    await _loop?.cancel();
    _loop = null;
    await player.stop();
    await player.setSource(AssetSource(track.assetPath));
    if (start > Duration.zero) await player.seek(start);
    await player.resume();
    if (length == null) return;
    final end = start + length;
    _loop = player.onPositionChanged.listen((position) {
      if (position >= end) unawaited(player.seek(start));
    });
  }

  @override
  Future<void> stop() async {
    await _loop?.cancel();
    _loop = null;
    await _player?.stop();
  }

  void dispose() {
    unawaited(_loop?.cancel());
    unawaited(_player?.dispose());
  }
}
