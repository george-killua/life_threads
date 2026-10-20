import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../data/music_preview.dart';
import '../../domain/music_track.dart';
import 'music_trimmer.dart';

/// Plays a story film's song part and keeps the film in step with it: the
/// film's clock follows the song, so the music matches the picture as it
/// will in the exported video. Without a song (or paused) the film loops on
/// its own.
///
/// [filmTime] drives the preview ([StoryFilmPreview.time]); [songTime] is
/// the song's playhead (null while the song isn't playing).
class StoryPlayback extends ChangeNotifier with WidgetsBindingObserver {
  StoryPlayback({
    required MusicPreview preview,
    required TickerProvider vsync,
    this.alwaysTick = false,
  }) : _preview = preview {
    _positions = preview.position.listen((position) {
      _reported = position;
      _reportedAt = _now;
    });
    _ticker = vsync.createTicker(_tick);
    if (alwaysTick) _ticker.start();
    WidgetsBinding.instance.addObserver(this);
  }

  /// Leaving the app (home screen, another app, the lock screen) stops the
  /// song; the sound button or another song plays it again.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      if (_playing) unawaited(pause());
    }
  }

  /// Keep the film's clock running without a song too (a screen that always
  /// shows the film at [filmTime]); otherwise it runs only with a song.

  final bool alwaysTick;
  final MusicPreview _preview;
  late final Ticker _ticker;

  /// Which playback last started the shared preview player: a screen that
  /// closes stops the song only while it is still its own (the editor may
  /// already play it again under the closing music screen).
  static final _owners = Expando<StoryPlayback>();
  StreamSubscription<Duration>? _positions;

  final filmTime = ValueNotifier(Duration.zero);
  final songTime = ValueNotifier<Duration?>(null);

  MusicTrack? _track;
  var _start = Duration.zero;
  var _length = const Duration(seconds: 15);
  var _playing = false;

  /// The last position the player reported, and when (ticker time): frames
  /// in between move on from it, as the player reports only a few times a
  /// second.
  Duration? _reported;
  var _reportedAt = Duration.zero;
  var _now = Duration.zero;

  /// Without music the film runs on its own from here.
  var _loopFrom = Duration.zero;

  MusicTrack? get track => _track;
  bool get playing => _playing;

  /// Where the song part starts, kept inside the song.
  Duration get start {
    final track = _track;
    if (track == null) return Duration.zero;
    return MusicTrimmer.clampStart(track, _length, _start);
  }

  /// Sets what plays; returns whether anything changed. Without a song it
  /// stops; otherwise call [play] to hear the change.
  bool configure({
    required MusicTrack? track,
    required Duration start,
    required Duration length,
  }) {
    final changed =
        track?.id != _track?.id || start != _start || length != _length;
    if (!changed) return false;
    _track = track;
    _start = start;
    _length = length;
    if (track == null && _playing) unawaited(pause());
    if (track != null && !_ticker.isActive) {
      _ticker.start();
    } else if (track == null && !alwaysTick && _ticker.isActive) {
      _ticker.stop();
    }
    notifyListeners();
    return true;
  }

  /// Plays the song part from its start; the film starts over with it.
  Future<void> play() async {
    final track = _track;
    if (track == null) return;
    _playing = true;
    _reported = start;
    _reportedAt = _now;
    _owners[_preview] = this;
    notifyListeners();
    await _preview.play(track, start: start, length: _length);
  }

  /// Stops the song; the film keeps looping, silently, from where it is.
  Future<void> pause() async {
    final wasPlaying = _playing;
    _playing = false;
    _loopFrom = _now - filmTime.value;
    if (wasPlaying) notifyListeners();
    await _preview.stop();
  }

  void _tick(Duration elapsed) {
    _now = elapsed;
    final reported = _reported;
    if (_track != null && _playing && reported != null) {
      final from = start;
      var song = reported + (elapsed - _reportedAt);
      if (song > from + _length) song = from + _length;
      if (song < from) song = from;
      songTime.value = song;
      filmTime.value = song - from;
    } else {
      songTime.value = null;
      final us = _length.inMicroseconds;
      if (us > 0) {
        filmTime.value = Duration(
          microseconds: (elapsed - _loopFrom).inMicroseconds % us,
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    unawaited(_positions?.cancel());
    if (_playing && identical(_owners[_preview], this)) {
      unawaited(_preview.stop());
    }
    filmTime.dispose();
    songTime.dispose();
    super.dispose();
  }
}
