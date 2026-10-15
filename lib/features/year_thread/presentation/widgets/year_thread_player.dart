import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/rendering/story_canvas.dart';
import '../../../stories/domain/story_film.dart';

/// Plays a [StoryFilm] on screen by drawing its frames with a ticker: the
/// same frames the export renders, so the preview is what gets shared.
class YearThreadPlayer extends StatefulWidget {
  const YearThreadPlayer({super.key, required this.film, this.autoplay = true});

  final StoryFilm film;
  final bool autoplay;

  @override
  State<YearThreadPlayer> createState() => _YearThreadPlayerState();
}

class _YearThreadPlayerState extends State<YearThreadPlayer>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_onTick);
  var _position = Duration.zero;
  var _playStart = Duration.zero;

  StoryFilm get _film => widget.film;

  @override
  void initState() {
    super.initState();
    if (widget.autoplay) _ticker.start();
  }

  @override
  void didUpdateWidget(covariant YearThreadPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.film != widget.film) {
      _seek(Duration.zero);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    var position = _playStart + elapsed;
    if (position >= _film.duration) {
      position = _film.duration;
      _ticker.stop();
    }
    setState(() => _position = position);
  }

  void _toggle() {
    if (_ticker.isActive) {
      _ticker.stop();
      setState(() {});
      return;
    }
    _playStart = _position >= _film.duration ? Duration.zero : _position;
    _ticker.start();
    setState(() => _position = _playStart);
  }

  void _seek(Duration position) {
    final wasPlaying = _ticker.isActive;
    _ticker.stop();
    _position = position;
    _playStart = position;
    if (wasPlaying) _ticker.start();
    setState(() {});
  }

  /// The frame the export would render at [_position].
  Duration get _frameTime {
    final frame = (_position.inMicroseconds * _film.fps / 1000000).floor();
    return Duration(microseconds: (frame * 1000000 / _film.fps).round());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = _film.duration;
    final playing = _ticker.isActive;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: AspectRatio(
            aspectRatio: 9 / 16,
            // One image for VoiceOver: the moving frame changes every tick,
            // which flooded the accessibility tree (and stalled UI tests).
            child: Semantics(
              image: true,
              label: l10n.yearThreadPreview,
              excludeSemantics: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: GestureDetector(
                  onTap: _toggle,
                  child: FittedBox(
                    child: SizedBox.fromSize(
                      size: StoryCanvas.storyLogicalSize,
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          size: StoryCanvas.storyLogicalSize,
                          textScaler: TextScaler.noScaling,
                        ),
                        child: Builder(
                          builder: (context) =>
                              _film.buildFrame(context, _frameTime),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            IconButton.filled(
              tooltip: playing ? l10n.yearThreadPause : l10n.yearThreadPlay,
              onPressed: _toggle,
              icon: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
            ),
            Expanded(
              child: Slider(
                value: total == Duration.zero
                    ? 0
                    : _position.inMicroseconds / total.inMicroseconds,
                // Whole seconds, so the value read out changes once a second.
                semanticFormatterCallback: (value) => _seconds(
                  Duration(
                    microseconds: (total.inMicroseconds * value).round(),
                  ),
                ),
                onChanged: (value) => _seek(
                  Duration(
                    microseconds: (total.inMicroseconds * value).round(),
                  ),
                ),
              ),
            ),
            Text(
              '${_seconds(_position)} / ${_seconds(total)}',
              style: TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w800,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ],
    );
  }

  static String _seconds(Duration duration) {
    final seconds = duration.inSeconds;
    return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  }
}
