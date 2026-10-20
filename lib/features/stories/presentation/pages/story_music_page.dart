import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../tour/app_tour.dart';
import '../../../tour/coach.dart';
import '../../data/music_catalog.dart';
import '../../data/music_preview.dart';
import '../../domain/music_track.dart';
import '../../domain/story_film.dart';
import '../../domain/story_template.dart';
import '../story_template_film.dart';
import '../story_template_l10n.dart';
import '../widgets/music_trimmer.dart';
import '../widgets/story_film_preview.dart';
import '../widgets/story_playback.dart';

/// What the music page returns: the song (or none), where it starts, and
/// the film length (null for the animation's own).
typedef StoryMusicChoice = ({
  MusicTrack? track,
  Duration start,
  Duration? length,
});

/// Music and length for a story video, on its own screen: the film plays at
/// the top in step with the song, so the user sees which second of the
/// song plays with which moment; under it the length, the part of the song
/// (with a moving playhead) and the songs.
class StoryMusicPage extends ConsumerStatefulWidget {
  const StoryMusicPage({
    super.key,
    required this.filmFor,
    required this.track,
    required this.start,
    required this.length,
    this.canChangeLength = true,
    this.tracks = bundledMusicTracks,
  });

  /// The songs to choose from.
  final List<MusicTrack> tracks;

  /// The film at a chosen length (null: its own length).
  final StoryFilm Function(Duration? length) filmFor;

  /// Thread of the Year has the length its memories need: no slider.
  final bool canChangeLength;
  final MusicTrack? track;
  final Duration start;
  final Duration? length;

  @override
  ConsumerState<StoryMusicPage> createState() => _StoryMusicPageState();
}

class _StoryMusicPageState extends ConsumerState<StoryMusicPage>
    with SingleTickerProviderStateMixin {
  late MusicTrack? _track = widget.track;
  late Duration _start = widget.start;
  late Duration? _length = widget.length;
  MusicMood? _mood;
  late final StoryPlayback _playback;

  @override
  void initState() {
    super.initState();
    _playback = StoryPlayback(
      preview: ref.read(musicPreviewProvider),
      vsync: this,
      alwaysTick: true,
    )..addListener(_changed);
    // The tour shows the part of the song and its playhead: it needs one.
    if (_track == null && appTourRunning) {
      final first = widget.tracks.first;
      _track = first;
      _start = MusicTrimmer.suggestedStart(first, _film.duration);
    }
    _configure();
    if (_track != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _play());
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _playback
      ..removeListener(_changed)
      ..dispose();
    super.dispose();
  }

  StoryFilm get _film => widget.filmFor(_length);

  bool get _playing => _playback.playing;
  ValueNotifier<Duration> get _filmTime => _playback.filmTime;
  ValueNotifier<Duration?> get _songTime => _playback.songTime;

  Duration get _clampedStart {
    final track = _track;
    if (track == null) return Duration.zero;
    return MusicTrimmer.clampStart(track, _film.duration, _start);
  }

  void _configure() =>
      _playback.configure(track: _track, start: _start, length: _film.duration);

  /// Plays the chosen part of the song from its start; the film starts over
  /// with it.
  Future<void> _play() async {
    _configure();
    await _playback.play();
  }

  Future<void> _pause() => _playback.pause();

  void _choose(MusicTrack? track) {
    if (track == null) {
      setState(() => _track = null);
      unawaited(_pause());
      return;
    }
    if (track.id == _track?.id) {
      unawaited(_playing ? _pause() : _play());
      return;
    }
    setState(() {
      _track = track;
      _start = MusicTrimmer.suggestedStart(track, _film.duration);
    });
    unawaited(_play());
  }

  void _setLength(Duration? length) {
    setState(() => _length = length);
    _configure();
    if (_playing) unawaited(_play());
  }

  void _done() {
    Navigator.of(context).pop<StoryMusicChoice>((
      track: _track,
      start: _clampedStart,
      length: _length,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final film = _film;
    final track = _track;
    final seconds = (film.duration.inMilliseconds / 1000).round();
    final tracks = [
      for (final candidate in widget.tracks)
        if (_mood == null || candidate.mood == _mood) candidate,
    ];
    final moods = {for (final candidate in widget.tracks) candidate.mood};

    return Scaffold(
      backgroundColor: AppColors.wallInk,
      appBar: AppBar(
        title: Text(l10n.storyMusicPageTitle),
        actions: [
          CoachTarget(
            id: TourTargets.storyMusicDone,
            child: TextButton(
              key: const ValueKey('story-music-done'),
              onPressed: _done,
              child: Text(
                l10n.done,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        // The film, its length and the part of the song stay in view; the
        // songs scroll under them. On short phones the top gets at most 60 %
        // of the height (and scrolls itself), so songs always show.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final previewHeight = (height * 0.3).clamp(120.0, 200.0);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  // Short screens leave the songs a little more room.
                  constraints: BoxConstraints(
                    maxHeight: height * (height < 560 ? 0.52 : 0.6),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: previewHeight,
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: StoryFilmPreview(
                                    film: film,
                                    time: _filmTime,
                                    radius: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: widget.canChangeLength
                                    ? _LengthControl(
                                        seconds: seconds,
                                        auto: _length == null,
                                        onChanged: _setLength,
                                      )
                                    : Text(
                                        '${l10n.storyLengthTitle}: '
                                        '${l10n.storyLengthSeconds('$seconds')}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        if (track != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                            child: CoachTarget(
                              id: TourTargets.storyMusicTrimmer,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MusicTrimmer(
                                    key: ValueKey('music-trimmer-${track.id}'),
                                    track: track,
                                    window: film.duration,
                                    start: _clampedStart,
                                    playhead: _songTime,
                                    marks: film is StoryTemplateFilm
                                        ? film.memoryStarts
                                        : const [],
                                    onChanged: (start) =>
                                        setState(() => _start = start),
                                    onChangeEnd: (start) {
                                      _start = start;
                                      unawaited(_play());
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton.filledTonal(
                                        key: const ValueKey('story-music-play'),
                                        tooltip: _playing
                                            ? l10n.storyMusicPause
                                            : l10n.storyMusicPlay,
                                        onPressed: _playing ? _pause : _play,
                                        icon: Icon(
                                          _playing
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ValueListenableBuilder<Duration>(
                                          valueListenable: _filmTime,
                                          builder: (context, video, _) => Text(
                                            l10n.storyMusicPlayhead(
                                              _clock(
                                                _songTime.value ??
                                                    _clampedStart,
                                              ),
                                              _clock(video),
                                            ),
                                            key: const ValueKey(
                                              'story-music-playhead',
                                            ),
                                            style: TextStyle(
                                              color: AppColors.amber,
                                              fontWeight: FontWeight.w900,
                                              fontFeatures: const [
                                                FontFeature.tabularFigures(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    l10n.storyMusicSyncHint,
                                    style: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 12,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 56,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ChoiceChip(
                          label: Text(l10n.storyMusicAll),
                          selected: _mood == null,
                          onSelected: (_) => setState(() => _mood = null),
                        ),
                      ),
                      for (final mood in MusicMood.values)
                        if (moods.contains(mood))
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8),
                            child: ChoiceChip(
                              label: Text(musicMoodLabel(l10n, mood)),
                              selected: _mood == mood,
                              onSelected: (_) => setState(() => _mood = mood),
                            ),
                          ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    key: const ValueKey('story-music-songs'),
                    children: [
                      _SongTile(
                        key: const ValueKey('story-music-none'),
                        title: l10n.storyMusicNone,
                        subtitle: l10n.storyMusicNoneHint,
                        icon: Icons.music_off_rounded,
                        selected: track == null,
                        onTap: () => _choose(null),
                      ),
                      for (final candidate in tracks)
                        _SongTile(
                          key: ValueKey('story-music-${candidate.id}'),
                          title: candidate.title,
                          subtitle:
                              '${candidate.artist} · '
                              '${musicMoodLabel(l10n, candidate.mood)} · '
                              '${_clock(candidate.length)}',
                          icon: candidate.id == track?.id && _playing
                              ? Icons.graphic_eq_rounded
                              : Icons.play_circle_outline_rounded,
                          selected: candidate.id == track?.id,
                          onTap: () => _choose(candidate),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LengthControl extends StatelessWidget {
  const _LengthControl({
    required this.seconds,
    required this.auto,
    required this.onChanged,
  });

  final int seconds;
  final bool auto;
  final ValueChanged<Duration?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.storyLengthTitle,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              l10n.storyLengthSeconds('$seconds'),
              key: const ValueKey('story-length-value'),
              style: TextStyle(
                color: AppColors.amber,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        Slider(
          key: const ValueKey('story-length-slider'),
          value: seconds.toDouble().clamp(
            storyMinSeconds.toDouble(),
            storyMaxSeconds.toDouble(),
          ),
          min: storyMinSeconds.toDouble(),
          max: storyMaxSeconds.toDouble(),
          divisions: storyMaxSeconds - storyMinSeconds,
          label: l10n.storyLengthSeconds('$seconds'),
          onChanged: (value) => onChanged(Duration(seconds: value.round())),
        ),
        ChoiceChip(
          key: const ValueKey('story-length-auto'),
          label: Text(l10n.storyLengthAuto),
          selected: auto,
          onSelected: (_) => onChanged(null),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.storyMusicLengthHint,
          style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.35),
        ),
      ],
    );
  }
}

class _SongTile extends StatelessWidget {
  const _SongTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      selectedColor: AppColors.amber,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, size: 30),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColors.muted),
      ),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: AppColors.gold)
          : null,
    );
  }
}

String _clock(Duration value) {
  final minutes = value.inMinutes;
  final seconds = value.inSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
