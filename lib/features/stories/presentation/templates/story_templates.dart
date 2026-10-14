import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../memories/domain/memory_event.dart';
import '../../../wall/presentation/widgets/metallic_ball_pin.dart';
import '../../domain/story_template.dart';
import 'story_visuals.dart';

/// One story page (360×640 logical, 1080×1920 rendered) for [template].
///
/// With [StoryMotion.still] it is the story image; story films build it
/// once per frame with the frame's time.
class StoryPage extends StatelessWidget {
  const StoryPage({
    super.key,
    required this.template,
    required this.memories,
    this.caption = '',
    this.motion = const StoryMotion.still(),
  });

  final StoryTemplate template;
  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  @override
  Widget build(BuildContext context) {
    final page = switch (template) {
      StoryTemplate.single => _SingleStory(
        memories: memories,
        caption: caption.trim(),
        motion: motion,
      ),
      StoryTemplate.thread => _ThreadStory(
        memories: memories,
        caption: caption.trim(),
        motion: motion,
      ),
      StoryTemplate.collage => _CollageStory(
        memories: memories,
        caption: caption.trim(),
        motion: motion,
      ),
      StoryTemplate.quote => _QuoteStory(
        memories: memories,
        caption: caption.trim(),
        motion: motion,
      ),
    };
    return SizedBox.fromSize(
      size: storySize,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (memories.isEmpty) const StoryWallBackdrop() else page,
            if (motion.ending > 0)
              ColoredBox(
                color: BrandColors.wallInk.withValues(
                  alpha: motion.ending * 0.9,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Fades a piece in while it rises [rise] pixels into place.
class _Reveal extends StatelessWidget {
  const _Reveal({required this.value, required this.child, this.rise = 14});

  final double value;
  final double rise;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (value >= 1) return child;
    return Opacity(
      opacity: value.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, (1 - value) * rise),
        child: child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Single memory: full-bleed photo, title, place, date and feeling. A film
//    of several memories shows them one after another.

class _SingleStory extends StatelessWidget {
  const _SingleStory({
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _crossFade = 0.8;

  @override
  Widget build(BuildContext context) {
    final seconds = motion.seconds;
    if (seconds == null || memories.length == 1) {
      return _SingleScene(
        memory: memories.first,
        caption: caption,
        motion: motion,
      );
    }
    final segment = motion.total / memories.length;
    final index = math.min(memories.length - 1, seconds ~/ segment);
    final start = index * segment;
    StoryMotion local(int i) =>
        StoryMotion.at(seconds - i * segment, segment + _crossFade);
    final current = _SingleScene(
      memory: memories[index],
      caption: index == 0 ? caption : '',
      motion: local(index),
    );
    final fade = index == 0 ? 1.0 : motion.linear(start, _crossFade);
    if (fade >= 1) return current;
    return Stack(
      fit: StackFit.expand,
      children: [
        _SingleScene(
          memory: memories[index - 1],
          caption: index - 1 == 0 ? caption : '',
          motion: local(index - 1),
        ),
        Opacity(opacity: fade, child: current),
      ],
    );
  }
}

class _SingleScene extends StatelessWidget {
  const _SingleScene({
    required this.memory,
    required this.caption,
    required this.motion,
  });

  final MemoryEvent memory;
  final String caption;
  final StoryMotion motion;

  @override
  Widget build(BuildContext context) {
    final progress = motion.progress;
    final photoHeight = storySize.height * 0.8;
    final details = storyMemoryDetail(context, memory);
    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: photoHeight,
          child: StoryPhoto(
            memory: memory,
            zoom: 1.04 + 0.12 * progress,
            drift: Offset(0.025 - 0.05 * progress, 0.012 * progress),
          ),
        ),
        // The photo melts into the wall below it.
        Positioned(
          top: photoHeight * 0.4,
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  BrandColors.wallInk.withValues(alpha: 0),
                  BrandColors.wallInk.withValues(alpha: 0.6),
                  BrandColors.wallInk.withValues(alpha: 0.92),
                  BrandColors.wallInk.withValues(alpha: 0.9),
                ],
                stops: const [0, 0.35, 0.75, 1],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 90,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.3)),
        ),
        PositionedDirectional(
          start: 24,
          end: 24,
          bottom: 44,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Reveal(
                value: motion.appear(1.2),
                child: StoryFeelingChip(memory: memory),
              ),
              const SizedBox(height: 12),
              _Reveal(
                value: motion.appear(1.8, 1.1),
                rise: 22,
                child: Text(
                  memory.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: BrandColors.text,
                    fontSize: 30,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 12)],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _Reveal(
                value: motion.appear(2.6),
                child: Row(
                  children: [
                    Icon(
                      memory.hasGeoPoint
                          ? Icons.place_rounded
                          : Icons.event_rounded,
                      size: 15,
                      color: BrandColors.amber,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        details,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: BrandColors.amber,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (caption.isNotEmpty) ...[
                const SizedBox(height: 16),
                _Reveal(
                  value: motion.appear(3.6, 1.4),
                  child: Container(
                    padding: const EdgeInsetsDirectional.only(start: 12),
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        start: BorderSide(
                          color: memory.feeling.color.withValues(alpha: 0.8),
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Text(
                      caption,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: BrandColors.text.withValues(alpha: 0.88),
                        fontSize: 15,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Thread: pinned cards joined by the rope, oldest first, like the wall.

class _ThreadStory extends StatelessWidget {
  const _ThreadStory({
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _top = 132.0;
  static const _bottom = 616.0;

  /// When card [index] of [count] lands on the wall.
  static double cardStart(int index, int count, double total) {
    if (count <= 1) return 1.0;
    final gap = math.min(2.4, (total - 7.0) / (count - 1));
    return 1.0 + index * gap;
  }

  @override
  Widget build(BuildContext context) {
    final ordered = [...memories]
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    final count = ordered.length;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final width = const [230.0, 165.0, 160.0, 150.0, 132.0, 128.0][count - 1];
    final compact = count > 3;
    final photoHeight = width * (compact ? 0.58 : 0.66);
    // Estimated card height, enough to spread the cards.
    final cardHeight = photoHeight + (compact ? 58 : 72);
    const rotations = [-0.045, 0.04, -0.03, 0.05, -0.035, 0.03];
    const margin = 16.0;
    // Cards hang from a pin near their inner top corner, so the rope runs
    // down the middle of the story from card to card.
    const pinInset = 22.0;

    final placements = <({Offset topLeft, Offset pin, double rotation})>[];
    for (var i = 0; i < count; i++) {
      final double x;
      final double y;
      final double pinX;
      if (count == 1) {
        x = (storySize.width - width) / 2;
        y = (_top + _bottom - cardHeight) / 2;
        pinX = x + width / 2;
      } else {
        final left = i.isEven;
        final jitter = (i % 3) * 3.0;
        x = left ? margin + jitter : storySize.width - margin - width - jitter;
        y = _top + i * (_bottom - _top - cardHeight) / (count - 1);
        pinX = left ? x + width - pinInset : x + pinInset;
      }
      placements.add((
        topLeft: Offset(rtl ? storySize.width - x - width : x, y),
        pin: Offset(rtl ? storySize.width - pinX : pinX, y + 4),
        rotation: rotations[i],
      ));
    }
    final pins = [for (final placement in placements) placement.pin];

    final total = motion.total;
    final ropeStart = cardStart(0, count, total) + 0.4;
    final ropeEnd = cardStart(count - 1, count, total) + 0.4;
    final ropeProgress = motion.isStill
        ? 1.0
        : motion.linear(ropeStart, math.max(0.1, ropeEnd - ropeStart));
    final heading = caption.isNotEmpty ? caption : null;

    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.3)),
        ),
        PositionedDirectional(
          top: 56,
          start: 24,
          end: 24,
          child: _Reveal(
            value: motion.appear(0.6, 1.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (heading != null)
                  Text(
                    heading,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: BrandColors.text,
                      fontSize: 19,
                      height: 1.2,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  storyDateRange(context, ordered),
                  style: const TextStyle(
                    color: BrandColors.amber,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Behind the cards, as on the wall; the pins sit on top.
        IgnorePointer(
          child: CustomPaint(
            painter: StoryRopePainter(points: pins, progress: ropeProgress),
          ),
        ),
        for (var i = 0; i < count; i++)
          Positioned(
            left: placements[i].topLeft.dx,
            top: placements[i].topLeft.dy,
            child: _Reveal(
              value: motion.appear(cardStart(i, count, total), 0.8),
              rise: -30,
              child: Transform.rotate(
                angle: placements[i].rotation,
                // Swings around its pin.
                alignment: Alignment(
                  (pins[i].dx - placements[i].topLeft.dx) / width * 2 - 1,
                  -1,
                ),
                child: StoryPaperCard(
                  memory: ordered[i],
                  width: width,
                  photoHeight: photoHeight,
                  titleLines: compact ? 1 : 2,
                  showPin: false,
                  zoom: 1.02 + 0.08 * motion.progress,
                ),
              ),
            ),
          ),
        for (var i = 0; i < count; i++)
          Positioned(
            left: pins[i].dx - 12,
            top: pins[i].dy - 8,
            child: Opacity(
              opacity: motion.appear(cardStart(i, count, total), 0.5),
              child: const MetallicBallPin(size: 16, showStem: false),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Collage: the photos in a grid with one line of story on a paper strip.

class _CollageStory extends StatelessWidget {
  const _CollageStory({
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _rows = {
    1: [1],
    2: [1, 1],
    3: [1, 2],
    4: [2, 2],
    5: [2, 3],
    6: [2, 2, 2],
  };

  @override
  Widget build(BuildContext context) {
    final rows = _rows[memories.length]!;
    final line = caption.isNotEmpty ? caption : memories.first.title;
    const rotations = [-0.02, 0.018, -0.012, 0.022, -0.018, 0.014];
    final tiles = <Widget>[];
    var index = 0;
    final rowWidgets = <Widget>[];
    for (final columns in rows) {
      final cells = <Widget>[];
      for (var c = 0; c < columns; c++) {
        final i = index++;
        final appear = motion.appear(0.6 + i * 0.6, 0.9);
        cells.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Opacity(
                opacity: appear,
                child: Transform.scale(
                  scale: 1.1 - 0.1 * appear,
                  child: Transform.rotate(
                    angle: rotations[i],
                    child: _CollageTile(
                      memory: memories[i],
                      zoom: 1.03 + 0.1 * motion.progress,
                      drift: Offset(
                        (i.isEven ? 0.02 : -0.02) * (motion.progress - 0.5),
                        0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      rowWidgets.add(Expanded(child: Row(children: cells)));
    }
    tiles.addAll(rowWidgets);
    final lastTile = 0.6 + (memories.length - 1) * 0.6;

    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.3)),
        ),
        Positioned(
          top: 60,
          left: 17,
          right: 17,
          bottom: 158,
          child: Column(children: tiles),
        ),
        PositionedDirectional(
          start: 26,
          end: 26,
          bottom: 42,
          child: _Reveal(
            value: motion.appear(lastTile + 0.9, 1.2),
            child: Transform.rotate(
              angle: -0.012,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF7E7), BrandColors.card],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      line,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: BrandColors.paperInk,
                        fontSize: 16.5,
                        height: 1.3,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      storyDateRange(context, memories),
                      style: TextStyle(
                        color: BrandColors.paperInk.withValues(alpha: 0.58),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CollageTile extends StatelessWidget {
  const _CollageTile({
    required this.memory,
    required this.zoom,
    required this.drift,
  });

  final MemoryEvent memory;
  final double zoom;
  final Offset drift;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: BrandColors.card,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.42),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: StoryPhoto(memory: memory, zoom: zoom, drift: drift),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Quote: the story text on the wall with a small pinned photo.

class _QuoteStory extends StatelessWidget {
  const _QuoteStory({
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  @override
  Widget build(BuildContext context) {
    final memory = memories.first;
    final description = truncateStoryText(memory.description, 220);
    final quote = caption.isNotEmpty
        ? caption
        : (description.isNotEmpty ? description : memory.title);
    final length = quote.length;
    final fontSize = length < 50
        ? 30.0
        : length < 110
        ? 24.0
        : length < 170
        ? 20.0
        : 17.5;

    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.3)),
        ),
        PositionedDirectional(
          top: 92,
          start: 26,
          end: 26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Reveal(
                value: motion.appear(0.5, 1),
                child: Text(
                  '“',
                  style: TextStyle(
                    color: memory.feeling.color.withValues(alpha: 0.9),
                    fontSize: 86,
                    height: 0.9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _Reveal(
                value: motion.appear(1.1, 1.8),
                rise: 20,
                child: Text(
                  quote,
                  maxLines: 9,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: BrandColors.text,
                    fontSize: fontSize,
                    height: 1.32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _Reveal(
                value: motion.appear(2.2, 1),
                child: Container(
                  width: 46,
                  height: 3,
                  decoration: BoxDecoration(
                    color: BrandColors.gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
        PositionedDirectional(
          end: 30,
          bottom: 46,
          child: _Reveal(
            value: motion.appear(3.0, 0.9),
            rise: -26,
            child: Transform.rotate(
              angle: 0.05,
              alignment: Alignment.topCenter,
              child: StoryPaperCard(
                memory: memory,
                width: 158,
                zoom: 1.02 + 0.1 * motion.progress,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
