import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../domain/music_track.dart';

/// Picks which part of [track] plays under a film of length [window]: the
/// song's waveform with a highlighted window the user drags, like choosing a
/// song part for an Instagram story. [onChanged] fires while dragging,
/// [onChangeEnd] when the finger lifts (play the new part then).
///
/// With [playhead] a white line follows the song while it plays, and
/// [marks] (times in the film) show where each memory comes up, so the
/// user sees which part of the song plays over which memory.
class MusicTrimmer extends StatefulWidget {
  const MusicTrimmer({
    super.key,
    required this.track,
    required this.window,
    required this.start,
    required this.onChanged,
    required this.onChangeEnd,
    this.playhead,
    this.marks = const [],
  });

  final MusicTrack track;
  final Duration window;
  final Duration start;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  /// Where in the song playback is; null while nothing plays.
  final ValueListenable<Duration?>? playhead;
  final List<Duration> marks;

  /// The latest start that still fits a [window]-long part into [track].
  static Duration maxStart(MusicTrack track, Duration window) {
    final max = track.length - window;
    return max.isNegative ? Duration.zero : max;
  }

  /// [start] moved into the range that fits [window].
  static Duration clampStart(
    MusicTrack track,
    Duration window,
    Duration start,
  ) {
    final max = maxStart(track, window);
    if (start.isNegative) return Duration.zero;
    return start > max ? max : start;
  }

  /// Where a new pick starts: the loudest [window]-long part of the song
  /// (usually its chorus or main melody), so the first preview sounds good.
  static Duration suggestedStart(MusicTrack track, Duration window) {
    final peaks = track.peaks;
    final lengthUs = track.length.inMicroseconds;
    if (peaks.isEmpty || lengthUs == 0) return Duration.zero;
    final span = (peaks.length * window.inMicroseconds / lengthUs).ceil().clamp(
      1,
      peaks.length,
    );
    var best = 0;
    var bestSum = -1;
    for (var i = 0; i + span <= peaks.length; i++) {
      var sum = 0;
      for (var j = i; j < i + span; j++) {
        sum += peaks[j];
      }
      if (sum > bestSum) {
        bestSum = sum;
        best = i;
      }
    }
    final start = Duration(microseconds: lengthUs * best ~/ peaks.length);
    // Whole seconds read better in the range label.
    return clampStart(track, window, Duration(seconds: start.inSeconds));
  }

  @override
  State<MusicTrimmer> createState() => _MusicTrimmerState();
}

class _MusicTrimmerState extends State<MusicTrimmer> {
  late Duration _start = widget.start;

  @override
  void didUpdateWidget(covariant MusicTrimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.start != widget.start) _start = widget.start;
  }

  Duration get _window =>
      widget.window > widget.track.length ? widget.track.length : widget.window;

  void _moveBy(double dx, double width) {
    final lengthUs = widget.track.length.inMicroseconds;
    if (width <= 0 || lengthUs == 0) return;
    final delta = Duration(microseconds: (dx / width * lengthUs).round());
    final next = MusicTrimmer.clampStart(widget.track, _window, _start + delta);
    if (next == _start) return;
    setState(() => _start = next);
    widget.onChanged(next);
  }

  void _step(int seconds) {
    final next = MusicTrimmer.clampStart(
      widget.track,
      _window,
      _start + Duration(seconds: seconds),
    );
    setState(() => _start = next);
    widget.onChanged(next);
    widget.onChangeEnd(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final end = _start + _window;
    final range = '${_clock(_start)} – ${_clock(end)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.content_cut_rounded, size: 16, color: AppColors.gold),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                l10n.storyMusicTrimHint,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              range,
              key: const ValueKey('music-trim-range'),
              style: TextStyle(
                color: AppColors.amber,
                fontWeight: FontWeight.w900,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Time runs left to right in every language, like a player.
        Directionality(
          textDirection: TextDirection.ltr,
          child: Semantics(
            slider: true,
            label: l10n.storyMusicTrimHint,
            value: range,
            increasedValue: l10n.storyMusicTrimHint,
            decreasedValue: l10n.storyMusicTrimHint,
            onIncrease: () => _step(1),
            onDecrease: () => _step(-1),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return GestureDetector(
                  key: const ValueKey('music-trimmer'),
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) =>
                      _moveBy(details.delta.dx, width),
                  onHorizontalDragEnd: (_) => widget.onChangeEnd(_start),
                  child: SizedBox(
                    height: 62,
                    child: CustomPaint(
                      painter: _WaveformPainter(
                        peaks: widget.track.peaks,
                        length: widget.track.length,
                        start: _start,
                        window: _window,
                        marks: widget.marks,
                      ),
                      foregroundPainter: widget.playhead == null
                          ? null
                          : _PlayheadPainter(
                              playhead: widget.playhead!,
                              length: widget.track.length,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

String _clock(Duration value) {
  final minutes = value.inMinutes;
  final seconds = value.inSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.peaks,
    required this.length,
    required this.start,
    required this.window,
    required this.marks,
  });

  final List<int> peaks;
  final Duration length;
  final Duration start;
  final Duration window;
  final List<Duration> marks;

  @override
  void paint(Canvas canvas, Size size) {
    final lengthUs = length.inMicroseconds;
    if (lengthUs == 0) return;
    final left = size.width * start.inMicroseconds / lengthUs;
    final right = size.width * (start + window).inMicroseconds / lengthUs;
    final selection = RRect.fromLTRBR(
      left,
      0,
      right,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(10)),
      Paint()..color = AppColors.panel.withValues(alpha: 0.8),
    );
    canvas.drawRRect(
      selection,
      Paint()..color = AppColors.gold.withValues(alpha: 0.18),
    );

    // Where each memory comes up: small ticks along the bottom edge.
    final tick = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final mark in marks) {
      final x = size.width * (start + mark).inMicroseconds / lengthUs;
      if (x < left || x > right) continue;
      canvas.drawLine(
        Offset(x, size.height - 9),
        Offset(x, size.height - 3),
        tick,
      );
    }

    final bars = peaks.isEmpty ? List.filled(50, 40) : peaks;
    final slot = size.width / bars.length;
    final barWidth = (slot * 0.55).clamp(1.5, 6.0);
    for (var i = 0; i < bars.length; i++) {
      final x = slot * (i + 0.5);
      final height = (size.height - 22) * (bars[i].clamp(4, 100) / 100);
      final inside = x >= left && x <= right;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, (size.height - 6) / 2),
            width: barWidth,
            height: height,
          ),
          const Radius.circular(3),
        ),
        Paint()
          ..color = inside
              ? AppColors.gold
              : AppColors.muted.withValues(alpha: 0.45),
      );
    }

    canvas.drawRRect(
      selection,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AppColors.gold,
    );
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.start != start ||
      old.window != window ||
      old.length != length ||
      old.peaks != peaks ||
      !listEquals(old.marks, marks);
}

/// The white line at the song's playback position; repaints on its own,
/// without the waveform.
class _PlayheadPainter extends CustomPainter {
  _PlayheadPainter({required this.playhead, required this.length})
    : super(repaint: playhead);

  final ValueListenable<Duration?> playhead;
  final Duration length;

  @override
  void paint(Canvas canvas, Size size) {
    final position = playhead.value;
    final lengthUs = length.inMicroseconds;
    if (position == null || lengthUs == 0) return;
    final x = (size.width * position.inMicroseconds / lengthUs).clamp(
      0.0,
      size.width,
    );
    canvas.drawLine(
      Offset(x, -3),
      Offset(x, size.height + 3),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(x, -3), 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_PlayheadPainter old) =>
      old.playhead != playhead || old.length != length;
}
