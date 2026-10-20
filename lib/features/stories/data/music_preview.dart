import 'dart:async';
import 'dart:math' as math;

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

  /// Where in the song playback is, while it plays (about five times a
  /// second), so a film preview can run in step with it.
  Stream<Duration> get position;
}

class AudioplayersMusicPreview implements MusicPreview {
  AudioPlayer? _player;
  StreamSubscription<Duration>? _loop;
  final _position = StreamController<Duration>.broadcast();
  StreamSubscription<Duration>? _positionFeed;

  /// Bumped by every play and stop: a play still loading its song when a
  /// newer call came in gives up instead of starting to play after it.
  var _call = 0;
  var _stopped = true;

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
    // Positions often enough for the loop's fade to be smooth.
    player.positionUpdater = TimerPositionUpdater(
      getPosition: player.getCurrentPosition,
      interval: const Duration(milliseconds: 50),
    );
    _positionFeed = player.onPositionChanged.listen(_position.add);
    return _player = player;
  }

  @override
  Future<void> play(
    MusicTrack track, {
    Duration start = Duration.zero,
    Duration? length,
  }) async {
    final call = ++_call;
    _stopped = false;
    final player = await _ensurePlayer();
    await _loop?.cancel();
    _loop = null;
    await player.stop();
    if (call != _call) return;
    await player.setSource(AssetSource(track.assetPath));
    if (call != _call) return;
    if (start > Duration.zero) await player.seek(start);
    if (call != _call) return;
    // A looped part starts silent and fades in (see below).
    await player.setVolume(length == null ? 1 : 0);
    await player.resume();
    if (call != _call) {
      // Stopped while starting: it must not keep playing. (A newer play
      // takes over the player on its own.)
      if (_stopped) await player.stop();
      return;
    }
    if (length == null) return;
    final end = start + length;
    // The part fades out before its end and in after the jump back, as the
    // exported video fades out: the loop doesn't cut mid-note.
    var volume = -1.0;
    _loop = player.onPositionChanged.listen((position) {
      if (position >= end) {
        unawaited(player.seek(start));
        return;
      }
      final fadeIn = (position - start).inMilliseconds / _fadeIn;
      final fadeOut = (end - position).inMilliseconds / _fadeOut;
      final next = math.min(fadeIn, fadeOut).clamp(0.0, 1.0);
      if ((next - volume).abs() >= 0.05 || (next == 1 && volume != 1)) {
        volume = next;
        unawaited(player.setVolume(next));
      }
    });
  }

  static const _fadeIn = 250;
  static const _fadeOut = 450;

  @override
  Future<void> stop() async {
    _call++;
    _stopped = true;
    await _loop?.cancel();
    _loop = null;
    await _player?.stop();
  }

  @override
  Stream<Duration> get position => _position.stream;

  void dispose() {
    unawaited(_loop?.cancel());
    unawaited(_positionFeed?.cancel());
    unawaited(_position.close());
    unawaited(_player?.dispose());
  }
}
