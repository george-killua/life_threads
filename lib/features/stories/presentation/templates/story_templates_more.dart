import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../app/theme/app_colors.dart';
import '../../../memories/domain/memory_event.dart';
import '../../domain/story_template.dart';
import 'story_visuals.dart';

// The story looks added in 1.0.1. Like the first four, each one draws a
// whole frame from [StoryMotion] alone, so films render frame by frame.

/// The memory's words for a card: its story, or its title without one.
String _wordsOf(MemoryEvent memory, int max) {
  final description = truncateStoryText(memory.description, max);
  return description.isNotEmpty ? description : memory.title;
}

/// A slightly hand-written feel without bundling a font.
const _handwriting = TextStyle(
  color: BrandColors.paperInk,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w600,
  height: 1.3,
);

// ---------------------------------------------------------------------------
// 5. Polaroid: instant photos dropped onto a pile one after another.

class PolaroidStory extends StatelessWidget {
  const PolaroidStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static final _intro = storyTurns(StoryTemplate.polaroid).intro;

  /// Where each photo lands, from the middle of the pile.
  static const _spots = [
    Offset(-18, -40),
    Offset(22, -10),
    Offset(-26, 20),
    Offset(20, 46),
    Offset(-12, 70),
    Offset(16, 92),
  ];
  static const _angles = [-0.09, 0.07, -0.05, 0.1, -0.08, 0.04];

  @override
  Widget build(BuildContext context) {
    final count = memories.length;
    final beat = motion.beatFor(StoryTemplate.polaroid, count);
    final width = count <= 2 ? 236.0 : 214.0;
    final center = Offset(storySize.width / 2, count <= 2 ? 290 : 262);
    final last = _intro + (count - 1) * beat.span;
    final line = caption.isNotEmpty
        ? caption
        : storyDateRange(context, memories);
    final shortPage = StoryPageSize.of(context).height < storySize.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
        // As a picture the photos are fanned out so every one shows; the
        // film drops them onto a pile.
        if (motion.isStill)
          for (var i = 0; i < count; i++)
            _fanned(i, count, StoryPageSize.of(context).height)
        else
          for (var i = 0; i < count; i++)
            _drop(
              i,
              motion.appear(_intro + i * beat.span, 0.75),
              width,
              center,
            ),
        PositionedDirectional(
          start: 30,
          end: 30,
          bottom: shortPage ? 18 : 52,
          child: StoryReveal(
            value: motion.appear(last + 0.9, 1),
            child: Text(
              line,
              maxLines: shortPage ? 1 : 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: _handwriting.copyWith(
                color: BrandColors.text,
                fontSize: 20,
                shadows: const [Shadow(color: Colors.black54, blurRadius: 10)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Photo [i] of [count] laid out side by side for the picture: two
  /// columns, a little overlap and tilt, like photos spread on a table.
  Widget _fanned(int i, int count, double pageHeight) {
    final tall = pageHeight >= storySize.height;
    // Short pictures (a post, a square) put 5–6 photos in three columns.
    final columns = count == 1 ? 1 : (!tall && count >= 5 ? 3 : 2);
    final rows = (count / columns).ceil();
    const top = 96.0;
    // Room for the caption under the photos.
    final bottom = pageHeight - (tall ? 100 : 64);
    // As large as fits: the rows share the height (on a story a little
    // overlap, like photos on a table; on shorter pictures none, so every
    // title shows).
    final fit = (bottom - top) / rows * (tall ? 1.08 : 0.96) / 1.2;
    final width = math.min(switch (columns) {
      1 => 250.0,
      2 => count <= 4 ? 158.0 : 118.0,
      _ => 104.0,
    }, fit);
    final height = width * 1.2;
    final column = i % columns;
    final row = i ~/ columns;
    final columnX = switch (columns) {
      1 => 180.0,
      2 => column == 0 ? 98.0 : 262.0,
      _ => 62.0 + column * 118,
    };
    final step = rows == 1 ? 0.0 : (bottom - top - height) / (rows - 1);
    final y = count == 1
        ? (top + bottom - height) / 2
        : top + row * step + (column.isOdd ? 14 : 0);
    return Positioned(
      left: columnX - width / 2,
      top: y,
      child: Transform.rotate(
        angle: _angles[i] * 0.8,
        child: _Polaroid(memory: memories[i], width: width, zoom: 1.05),
      ),
    );
  }

  Widget _drop(int i, double value, double width, Offset center) {
    if (value <= 0) return const SizedBox.shrink();
    final spot = _spots[i];
    final height = width * 1.2;
    return Positioned(
      left: center.dx + spot.dx - width / 2,
      top: center.dy + spot.dy - height / 2 - (1 - value) * 70,
      child: Opacity(
        opacity: value.clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: _angles[i] * (1 + 2.5 * (1 - value)),
          child: Transform.scale(
            scale: 1.45 - 0.45 * value,
            child: _Polaroid(
              memory: memories[i],
              width: width,
              zoom: 1.02 + 0.08 * motion.progress,
            ),
          ),
        ),
      ),
    );
  }
}

class _Polaroid extends StatelessWidget {
  const _Polaroid({
    required this.memory,
    required this.width,
    required this.zoom,
  });

  final MemoryEvent memory;
  final double width;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    final inner = width - 22;
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(11, 11, 11, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8F1),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: inner,
            height: inner,
            child: StoryPhoto(memory: memory, zoom: zoom),
          ),
          SizedBox(
            height: width * 0.24,
            child: Center(
              child: Text(
                memory.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _handwriting.copyWith(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Album: pages that turn, one taped-in photo per page.

class AlbumStory extends StatelessWidget {
  const AlbumStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _page = Rect.fromLTWH(22, 74, 316, 500);

  @override
  Widget build(BuildContext context) {
    final count = memories.length;
    final beat = motion.beatFor(StoryTemplate.album, count);
    final index = beat.index;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final turning = !beat.still && index < count - 1
        ? beat.phase(0.84, 1)
        : 0.0;
    final angle = math.pi * turning;
    Widget page(int i, StoryMotion pageMotion) => _AlbumPage(
      memory: memories[i],
      words: i == 0 && caption.isNotEmpty
          ? caption
          : _wordsOf(memories[i], 120),
      motion: pageMotion,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3A2216), Color(0xFF241510), Color(0xFF3B2418)],
            ),
          ),
        ),
        PositionedDirectional(
          top: 26,
          start: 22,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
        // The next page waits under the one that turns.
        if (turning > 0)
          Positioned.fromRect(
            rect: _page,
            child: Stack(
              fit: StackFit.expand,
              children: [
                page(index + 1, const StoryMotion.still()),
                ColoredBox(
                  color: Colors.black.withValues(alpha: 0.35 * (1 - turning)),
                ),
              ],
            ),
          ),
        if (angle < math.pi / 2)
          Positioned.fromRect(
            rect: _page,
            child: Transform(
              alignment: rtl ? Alignment.centerRight : Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateY(rtl ? angle : -angle),
              child: page(index, beat.motion),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: Center(
            child: StoryPageDots(count: count, index: index),
          ),
        ),
      ],
    );
  }
}

class _AlbumPage extends StatelessWidget {
  const _AlbumPage({
    required this.memory,
    required this.words,
    required this.motion,
  });

  final MemoryEvent memory;
  final String words;
  final StoryMotion motion;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF8EA), Color(0xFFF3E6CC)],
        ),
        borderRadius: const BorderRadiusDirectional.horizontal(
          end: Radius.circular(10),
        ).resolve(Directionality.of(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 34, 26, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StoryReveal(
              value: motion.appear(0.3, 0.8),
              child: Center(
                child: Transform.rotate(
                  angle: -0.03,
                  child: SizedBox(
                    width: 250,
                    height: 230,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            color: Colors.white,
                            child: StoryPhoto(
                              memory: memory,
                              zoom: 1.02 + 0.06 * motion.progress,
                            ),
                          ),
                        ),
                        const Positioned(
                          top: -10,
                          left: -14,
                          child: _Tape(angle: -0.7),
                        ),
                        const Positioned(
                          top: -10,
                          right: -14,
                          child: _Tape(angle: 0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            StoryReveal(
              value: motion.appear(1.0, 0.8),
              child: Text(
                memory.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _handwriting.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 4),
            StoryReveal(
              value: motion.appear(1.3, 0.8),
              child: Text(
                storyMemoryDetail(context, memory),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: BrandColors.paperInk.withValues(alpha: 0.6),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StoryReveal(
                value: motion.appear(1.7, 1),
                child: Text(
                  words,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: _handwriting.copyWith(fontSize: 15.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tape extends StatelessWidget {
  const _Tape({required this.angle});

  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 64,
        height: 20,
        color: const Color(0xFFE9DDBF).withValues(alpha: 0.82),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Film strip: the strip runs past; each frame zooms up to full screen.

class FilmstripStory extends StatelessWidget {
  const FilmstripStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _frameWidth = 150.0;
  static const _frameHeight = 108.0;
  static const _gap = 14.0;
  static const _stripTop = 262.0;
  static const _stripHeight = 152.0;

  @override
  Widget build(BuildContext context) {
    final count = memories.length;
    final beat = motion.beatFor(StoryTemplate.filmstrip, count);
    final index = beat.index;
    // Where the strip is: frame [index] slides to the middle, then waits.
    final position = beat.still ? 0.0 : index - 1 + beat.phase(0, 0.18);
    final zoom = beat.still
        ? 1.0
        : beat.phase(0.2, 0.36) * (1 - beat.phase(0.84, 0.98));
    final step = _frameWidth + _gap;
    final firstLeft = (storySize.width - _frameWidth) / 2 - position * step;
    final frameTop = _stripTop + (_stripHeight - _frameHeight) / 2;
    final frame = Rect.fromLTWH(
      (storySize.width - _frameWidth) / 2,
      frameTop,
      _frameWidth,
      _frameHeight,
    );
    final full = Offset.zero & storySize;
    final open = Rect.lerp(frame, full, zoom)!;
    final memory = memories[index];
    final line = index == 0 && caption.isNotEmpty ? caption : memory.title;

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF0E0C0B)),
        const StoryWallBackdrop(),
        Positioned(
          left: 0,
          right: 0,
          top: _stripTop,
          height: _stripHeight,
          child: CustomPaint(
            painter: _SprocketPainter(offset: position * step),
          ),
        ),
        // Film runs left to right in every language.
        for (var i = 0; i < count; i++)
          Positioned(
            left: firstLeft + i * step,
            top: frameTop,
            width: _frameWidth,
            height: _frameHeight,
            child: Opacity(
              opacity: i == index ? 1 : 0.75,
              child: StoryPhoto(memory: memories[i]),
            ),
          ),
        if (zoom > 0)
          Positioned.fromRect(
            rect: open,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4 * (1 - zoom)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  StoryPhoto(
                    memory: memory,
                    zoom: 1.02 + 0.1 * beat.t,
                    drift: Offset(0.02 - 0.04 * beat.t, 0),
                  ),
                  if (zoom > 0.75)
                    Opacity(
                      opacity: ((zoom - 0.75) / 0.25).clamp(0.0, 1.0),
                      child: _FullFrameTitle(
                        memory: memory,
                        line: line,
                        motion: beat.motion,
                      ),
                    ),
                ],
              ),
            ),
          ),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
      ],
    );
  }
}

class _FullFrameTitle extends StatelessWidget {
  const _FullFrameTitle({
    required this.memory,
    required this.line,
    required this.motion,
  });

  final MemoryEvent memory;
  final String line;
  final StoryMotion motion;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            BrandColors.wallInk.withValues(alpha: 0.88),
          ],
          stops: const [0, 0.5, 1],
        ),
      ),
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StoryFeelingChip(memory: memory),
              const SizedBox(height: 10),
              Text(
                line,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: BrandColors.text,
                  fontSize: 27,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 12)],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                storyMemoryDetail(context, memory),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: BrandColors.amber,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SprocketPainter extends CustomPainter {
  const _SprocketPainter({required this.offset});

  /// How far the film has run, in pixels.
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xF2141210),
    );
    final hole = Paint()
      ..color = const Color(0xFFE8DCC4).withValues(alpha: 0.8);
    const pitch = 22.0;
    final shift = -(offset % pitch);
    for (var x = shift - pitch; x < size.width + pitch; x += pitch) {
      for (final y in [9.0, size.height - 17]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, 11, 8),
            const Radius.circular(2),
          ),
          hole,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SprocketPainter old) => old.offset != offset;
}

// ---------------------------------------------------------------------------
// 8. Time travel: a timeline grows; the year counts up to each memory.

class TimelineStory extends StatelessWidget {
  const TimelineStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _top = 196.0;
  static const _bottom = 586.0;

  @override
  Widget build(BuildContext context) {
    final ordered = [...memories]
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    final count = ordered.length;
    // As a picture: every memory along the line at once.
    if (motion.isStill) {
      return _TimelinePicture(memories: ordered, caption: caption);
    }
    final beat = motion.beatFor(StoryTemplate.timeline, count);
    final index = beat.index;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    double dotY(int i) => count == 1
        ? (_top + _bottom) / 2
        : _top + i * (_bottom - _top) / (count - 1);
    final arrive = beat.still ? 1.0 : beat.phase(0, 0.28);
    final lineEnd = index == 0
        ? _top - 30 + (dotY(0) - _top + 30) * arrive
        : dotY(index - 1) + (dotY(index) - dotY(index - 1)) * arrive;
    final year = ordered[index].occurredAt.year;
    final fromYear = index == 0
        ? year - 10
        : ordered[index - 1].occurredAt.year;
    final shownYear = (fromYear + (year - fromYear) * arrive).round();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final yearLabel = DateFormat.y(locale).format(DateTime(shownYear));
    final card = beat.motion;
    final leave = beat.still || index == count - 1 ? 0.0 : beat.phase(0.9, 1);
    const lineX = 34.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
        PositionedDirectional(
          top: 62,
          start: 26,
          end: 26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                yearLabel,
                style: const TextStyle(
                  color: BrandColors.amber,
                  fontSize: 64,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              if (caption.isNotEmpty)
                StoryReveal(
                  value: motion.appear(0.4, 1),
                  child: Text(
                    caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: BrandColors.text.withValues(alpha: 0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _TimelinePainter(
              x: rtl ? storySize.width - lineX : lineX,
              top: _top - 30,
              end: lineEnd,
              dots: [for (var i = 0; i < count; i++) dotY(i)],
              reached: beat.still ? count : index + (arrive >= 1 ? 1 : 0),
              current: index,
            ),
          ),
        ),
        PositionedDirectional(
          top: (dotY(index) - 120).clamp(_top - 20, 318.0),
          start: 66,
          end: 22,
          child: Opacity(
            opacity: (card.appear(0.7, 0.7) * (1 - leave)).clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(
                (rtl ? -1 : 1) * 40 * (1 - card.appear(0.7, 0.7)),
                -30 * leave,
              ),
              child: StoryPaperCard(
                memory: ordered[index],
                width: 272,
                photoHeight: 168,
                zoom: 1.02 + 0.08 * beat.t,
              ),
            ),
          ),
        ),
        PositionedDirectional(
          start: 66,
          bottom: 30,
          child: StoryReveal(
            value: motion.appear(motion.total - 1.4, 0.8),
            child: Text(
              storyDateRange(context, ordered),
              style: const TextStyle(
                color: BrandColors.amber,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelinePicture extends StatelessWidget {
  const _TimelinePicture({required this.memories, required this.caption});

  final List<MemoryEvent> memories;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final count = memories.length;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final pageHeight = StoryPageSize.of(context).height;
    // A post has less height: the rows get closer and smaller.
    final top = pageHeight < 600 ? 138.0 : 168.0;
    final bottom = pageHeight - 40;
    final step = count == 1 ? 0.0 : (bottom - top - 60) / (count - 1);
    final rowHeight = count == 1 ? 96.0 : (step - 6).clamp(34.0, 96.0);
    double rowY(int i) =>
        count == 1 ? (top + bottom - rowHeight) / 2 : top + i * step;
    const lineX = 34.0;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        const PositionedDirectional(top: 22, start: 18, child: StoryMark()),
        PositionedDirectional(
          top: 62,
          start: 26,
          end: 26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storyDateRange(context, memories),
                style: const TextStyle(
                  color: BrandColors.amber,
                  fontSize: 28,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (caption.isNotEmpty)
                Text(
                  caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: BrandColors.text.withValues(alpha: 0.85),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _TimelinePainter(
              x: rtl ? storySize.width - lineX : lineX,
              top: top - 10,
              end: rowY(count - 1) + rowHeight / 2,
              dots: [for (var i = 0; i < count; i++) rowY(i) + rowHeight / 2],
              reached: count,
              current: -1,
            ),
          ),
        ),
        for (var i = 0; i < count; i++)
          PositionedDirectional(
            top: rowY(i),
            start: 58,
            end: 18,
            height: rowHeight,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: rowHeight * 1.3,
                    height: rowHeight,
                    child: StoryPhoto(memory: memories[i]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.y(locale).format(memories[i].occurredAt),
                        style: const TextStyle(
                          color: BrandColors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        memories[i].title,
                        maxLines: rowHeight < 56 ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: BrandColors.text,
                          fontSize: 15,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TimelinePainter extends CustomPainter {
  const _TimelinePainter({
    required this.x,
    required this.top,
    required this.end,
    required this.dots,
    required this.reached,
    required this.current,
  });

  final double x;
  final double top;
  final double end;
  final List<double> dots;
  final int reached;
  final int current;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(x, top),
      Offset(x, dots.last + 20),
      Paint()
        ..color = BrandColors.text.withValues(alpha: 0.14)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(x, top),
      Offset(x, end),
      Paint()
        ..color = BrandColors.gold
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    for (var i = 0; i < dots.length; i++) {
      final on = i < reached;
      final center = Offset(x, dots[i]);
      if (on && i == current) {
        canvas.drawCircle(
          center,
          14,
          Paint()..color = BrandColors.gold.withValues(alpha: 0.25),
        );
      }
      canvas.drawCircle(
        center,
        on ? 7 : 5,
        Paint()
          ..color = on
              ? BrandColors.amber
              : BrandColors.text.withValues(alpha: 0.3),
      );
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.end != end ||
      old.reached != reached ||
      old.current != current ||
      old.x != x;
}

// ---------------------------------------------------------------------------
// 9. Postcard: each memory a postcard that flips to its story and postmark.

class PostcardStory extends StatelessWidget {
  const PostcardStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _size = Size(330, 226);

  @override
  Widget build(BuildContext context) {
    final count = memories.length;
    final beat = motion.beatFor(StoryTemplate.postcard, count);
    final index = beat.index;
    final memory = memories[index];
    final slideIn = beat.still ? 1.0 : beat.phase(0, 0.12);
    final slideOut = beat.still || index == count - 1
        ? 0.0
        : beat.phase(0.9, 1);
    final flip = beat.still ? 0.0 : beat.phase(0.4, 0.56);
    final angle = math.pi * flip;
    final back = angle > math.pi / 2;
    final words = index == 0 && caption.isNotEmpty
        ? caption
        : _wordsOf(memory, 150);

    final face = back
        ? Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: _PostcardBack(memory: memory, words: words),
          )
        : _PostcardFront(memory: memory, zoom: 1.02 + 0.08 * beat.t);

    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
        PositionedDirectional(
          top: 92,
          start: 26,
          end: 26,
          child: Opacity(
            opacity: (slideIn * (1 - slideOut)).clamp(0.0, 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: BrandColors.text,
                    fontSize: 25,
                    height: 1.12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  storyDate(context, memory.occurredAt),
                  style: const TextStyle(
                    color: BrandColors.amber,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left:
              (storySize.width - _size.width) / 2 +
              (1 - slideIn) * 420 -
              slideOut * 420,
          top: 250,
          width: _size.width,
          height: _size.height,
          child: Transform.rotate(
            angle: -0.035 + 0.02 * slideOut,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0013)
                ..rotateY(angle),
              child: face,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 44,
          child: Center(
            child: StoryPageDots(count: count, index: index),
          ),
        ),
      ],
    );
  }
}

class _PostcardFront extends StatelessWidget {
  const _PostcardFront({required this.memory, required this.zoom});

  final MemoryEvent memory;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    final place = memory.hasGeoPoint ? memory.locationDisplayLabel : '';
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _postcardDecoration,
      child: Stack(
        fit: StackFit.expand,
        children: [
          StoryPhoto(memory: memory, zoom: zoom),
          if (place.isNotEmpty)
            PositionedDirectional(
              start: 14,
              end: 14,
              bottom: 10,
              child: Text(
                place,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 14)],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PostcardBack extends StatelessWidget {
  const _PostcardBack({required this.memory, required this.words});

  final MemoryEvent memory;
  final String words;

  @override
  Widget build(BuildContext context) {
    final place = memory.hasGeoPoint ? memory.locationDisplayLabel : '';
    final line = Container(
      height: 1,
      color: BrandColors.paperInk.withValues(alpha: 0.25),
    );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _postcardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Text(
              words,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: _handwriting.copyWith(fontSize: 13.5),
            ),
          ),
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: BrandColors.paperInk.withValues(alpha: 0.25),
          ),
          SizedBox(
            width: 118,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 76,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 58,
                          height: 70,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: BrandColors.paperInk.withValues(
                                alpha: 0.25,
                              ),
                            ),
                          ),
                          child: StoryPhoto(memory: memory),
                        ),
                      ),
                      Positioned(
                        right: 34,
                        top: 18,
                        child: _Postmark(
                          date: storyDate(context, memory.occurredAt),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (place.isNotEmpty)
                  Text(
                    place,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: _handwriting.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                const SizedBox(height: 6),
                line,
                const SizedBox(height: 14),
                line,
                const SizedBox(height: 14),
                line,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final _postcardDecoration = BoxDecoration(
  color: const Color(0xFFFFF9EE),
  borderRadius: BorderRadius.circular(6),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.45),
      blurRadius: 22,
      offset: const Offset(0, 12),
    ),
  ],
);

class _Postmark extends StatelessWidget {
  const _Postmark({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF8A3B2E);
    return Transform.rotate(
      angle: -0.25,
      child: Container(
        width: 62,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ink.withValues(alpha: 0.75), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            date,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ink.withValues(alpha: 0.85),
              fontSize: 8.5,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. Cinema: cinema bars, title cards, slow zooms and closing credits.

class CinemaStory extends StatelessWidget {
  const CinemaStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _bar = 92.0;

  @override
  Widget build(BuildContext context) {
    final count = memories.length;
    final beat = motion.beatFor(StoryTemplate.cinema, count);
    final index = beat.index;
    final memory = memories[index];
    final now = motion.seconds;
    final outro = storyTurns(StoryTemplate.cinema, motion.total).outro;
    final creditsAt = motion.total - outro;
    final credits = now == null
        ? 0.0
        : ((now - creditsAt) / outro).clamp(0.0, 1.0);
    // Each turn opens on a title card, then the photo fades up.
    final titleCard = beat.still
        ? 0.0
        : beat.phase(0, 0.06) * (1 - beat.phase(0.18, 0.26));
    final photo = beat.still
        ? 1.0
        : beat.phase(0.2, 0.32) *
              (index == count - 1 ? 1 - credits : 1 - beat.phase(0.95, 1));
    final subtitle = index == 0 && caption.isNotEmpty
        ? caption
        : _wordsOf(memory, 90);
    final drift = index.isEven ? 1.0 : -1.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Colors.black),
        if (photo > 0)
          Opacity(
            opacity: photo.clamp(0.0, 1.0),
            child: StoryPhoto(
              memory: memory,
              zoom: 1.06 + 0.16 * beat.t,
              drift: Offset(drift * (0.03 - 0.06 * beat.t), 0),
            ),
          ),
        if (titleCard > 0)
          Center(
            child: Opacity(
              opacity: titleCard.clamp(0.0, 1.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      memory.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        height: 1.2,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      storyDate(context, memory.occurredAt),
                      style: const TextStyle(
                        color: BrandColors.amber,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (credits > 0) _Credits(memories: memories, progress: credits),
        // The cinema bars.
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: _bar,
          child: ColoredBox(color: Colors.black),
        ),
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: _bar,
          child: ColoredBox(color: Colors.black),
        ),
        PositionedDirectional(
          top: 34,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 18,
          height: _bar - 30,
          child: Opacity(
            opacity: beat.still
                ? 1
                : (beat.phase(0.34, 0.44) *
                          (1 - beat.phase(0.9, 0.97)) *
                          (1 - credits))
                      .clamp(0.0, 1.0),
            child: Center(
              child: Text(
                subtitle,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.3,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The closing credits: every memory with its place, rolling up.
class _Credits extends StatelessWidget {
  const _Credits({required this.memories, required this.progress});

  final List<MemoryEvent> memories;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 30,
      right: 30,
      top: storySize.height * 0.78 - progress * 330,
      child: Opacity(
        opacity: (progress * 4).clamp(0.0, 1.0),
        child: Column(
          children: [
            Text(
              storyDateRange(context, memories),
              style: const TextStyle(
                color: BrandColors.amber,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            for (final memory in memories) ...[
              Text(
                memory.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (memory.hasGeoPoint)
                Text(
                  memory.locationDisplayLabel,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 11.5,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            const Text(
              'LifeThreads',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: BrandColors.gold,
                fontSize: 13,
                letterSpacing: 3,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
