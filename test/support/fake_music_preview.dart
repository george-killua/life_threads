import 'dart:async';

import 'package:life_threads/features/stories/data/music_preview.dart';
import 'package:life_threads/features/stories/domain/music_track.dart';

/// Records what the music pickers ask to play instead of playing it.
class FakeMusicPreview implements MusicPreview {
  final calls = <String>[];

  /// Where each play started and how long its loop was.
  final parts = <({Duration start, Duration? length})>[];

  @override
  Future<void> play(
    MusicTrack track, {
    Duration start = Duration.zero,
    Duration? length,
  }) async {
    calls.add('play:${track.id}');
    parts.add((start: start, length: length));
  }

  @override
  Future<void> stop() async => calls.add('stop');

  /// Push playback positions here to drive the synced previews.
  final positions = StreamController<Duration>.broadcast();

  @override
  Stream<Duration> get position => positions.stream;
}
