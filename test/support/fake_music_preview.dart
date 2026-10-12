import 'package:life_threads/features/stories/data/music_preview.dart';
import 'package:life_threads/features/stories/domain/music_track.dart';

/// Records what the music pickers ask to play instead of playing it.
class FakeMusicPreview implements MusicPreview {
  final calls = <String>[];

  @override
  Future<void> play(MusicTrack track) async => calls.add('play:${track.id}');

  @override
  Future<void> stop() async => calls.add('stop');
}
