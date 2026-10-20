import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../memories/domain/memory_event.dart';
import '../../domain/story_template.dart';
import 'story_visuals.dart';

// Picture layouts (every memory in one image) and the video animations
// added with them. Like the other looks, each draws a whole frame from
// [StoryMotion] alone.

const _ink = BrandColors.paperInk;

/// Handwriting without bundling a font.
const _hand = TextStyle(
  color: _ink,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

/// The caption, or the memories' dates when there is none.
String _headline(BuildContext context, List<MemoryEvent> memories, String c) =>
    c.isNotEmpty ? c : storyDateRange(context, memories);

// ---------------------------------------------------------------------------
// Picture: a scrapbook page.

class ScrapbookStory extends StatelessWidget {
  const ScrapbookStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  /// Where each photo sits (and its tilt), by number of memories.
  static const _layouts = <int, List<(Rect, double)>>{
    1: [(Rect.fromLTWH(40, 130, 280, 330), -0.03)],
    2: [
      (Rect.fromLTWH(26, 112, 210, 236), -0.06),
      (Rect.fromLTWH(124, 348, 210, 236), 0.05),
    ],
    3: [
      (Rect.fromLTWH(22, 104, 180, 196), -0.05),
      (Rect.fromLTWH(160, 236, 180, 196), 0.06),
      (Rect.fromLTWH(30, 392, 180, 196), -0.03),
    ],
    4: [
      (Rect.fromLTWH(18, 108, 160, 178), -0.05),
      (Rect.fromLTWH(184, 132, 160, 178), 0.05),
      (Rect.fromLTWH(22, 330, 160, 178), 0.04),
      (Rect.fromLTWH(180, 356, 160, 178), -0.04),
    ],
    5: [
      (Rect.fromLTWH(16, 102, 154, 166), -0.05),
      (Rect.fromLTWH(190, 118, 154, 166), 0.05),
      (Rect.fromLTWH(100, 260, 160, 170), -0.02),
      (Rect.fromLTWH(16, 420, 154, 166), 0.04),
      (Rect.fromLTWH(190, 434, 154, 166), -0.05),
    ],
    6: [
      (Rect.fromLTWH(16, 100, 154, 160), -0.05),
      (Rect.fromLTWH(190, 114, 154, 160), 0.05),
      (Rect.fromLTWH(20, 268, 154, 160), 0.04),
      (Rect.fromLTWH(186, 284, 154, 160), -0.04),
      (Rect.fromLTWH(16, 436, 154, 160), -0.03),
      (Rect.fromLTWH(190, 450, 154, 160), 0.05),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final story = _layouts[memories.length.clamp(1, 6)]!;
    // On a shorter picture the photos move closer and get a little flatter.
    final height = StoryPageSize.of(context).height;
    final layout = height >= storySize.height
        ? story
        : [
            for (final (rect, angle) in story)
              () {
                final f = (height - 24 - 84) / (600 - 96);
                final width = rect.width * math.min(1, f * 1.25);
                return (
                  Rect.fromLTWH(
                    rect.center.dx - width / 2,
                    84 + (rect.top - 96) * f,
                    width,
                    rect.height * f,
                  ),
                  angle,
                );
              }(),
          ];
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF6EDDA), Color(0xFFEADCBF)],
            ),
          ),
        ),
        const CustomPaint(painter: _PaperLinesPainter()),
        PositionedDirectional(
          top: 28,
          start: 24,
          end: 24,
          child: StoryReveal(
            value: motion.appear(0.2, 0.8),
            child: Text(
              _headline(context, memories, caption),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _hand.copyWith(fontSize: 23),
            ),
          ),
        ),
        for (var i = 0; i < memories.length && i < layout.length; i++)
          Positioned.fromRect(
            rect: layout[i].$1,
            child: StoryReveal(
              value: motion.appear(0.5 + i * 0.45, 0.6),
              rise: -18,
              child: Transform.rotate(
                angle: layout[i].$2,
                child: _TapedPhoto(memory: memories[i]),
              ),
            ),
          ),
        PositionedDirectional(
          bottom: 14,
          end: 16,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
      ],
    );
  }
}

class _TapedPhoto extends StatelessWidget {
  const _TapedPhoto({required this.memory});

  final MemoryEvent memory;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: StoryPhoto(memory: memory),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                memory.title,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: _hand.copyWith(fontSize: 13.5),
              ),
            ],
          ),
        ),
        Positioned(
          top: -9,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.rotate(
              angle: -0.08,
              child: Container(
                width: 70,
                height: 20,
                color: const Color(0xFFE2D3AE).withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaperLinesPainter extends CustomPainter {
  const _PaperLinesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFFB9A57E).withValues(alpha: 0.18)
      ..strokeWidth = 1;
    for (double y = 90; y < size.height; y += 26) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(_PaperLinesPainter old) => false;
}

// ---------------------------------------------------------------------------
// Picture: a magazine page.

class MosaicStory extends StatelessWidget {
  const MosaicStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _gap = 6.0;
  static const _side = 12.0;

  @override
  Widget build(BuildContext context) {
    final hero = memories.first;
    final rest = memories.skip(1).toList();
    const width = 360 - 2 * _side;
    final pageHeight = StoryPageSize.of(context).height;
    const gridTop = 64.0;
    // The title needs less room under the photos on a shorter picture.
    final tilesBottom = pageHeight - (pageHeight >= 600 ? 120 : 92);
    final heroHeight = rest.isEmpty
        ? tilesBottom - gridTop
        : (tilesBottom - gridTop) * 0.6;
    final tilesTop = gridTop + heroHeight + _gap;
    final rows = (rest.length / 3).ceil();
    final tiles = <Widget>[];
    for (var r = 0; r < rows; r++) {
      final row = rest.skip(r * 3).take(3).toList();
      final rowHeight =
          (tilesBottom - tilesTop - _gap * (rows - 1)) / math.max(rows, 1);
      final tileWidth = (width - _gap * (row.length - 1)) / row.length;
      for (var c = 0; c < row.length; c++) {
        final index = 1 + r * 3 + c;
        tiles.add(
          Positioned(
            left: _side + c * (tileWidth + _gap),
            top: tilesTop + r * (rowHeight + _gap),
            width: tileWidth,
            height: rowHeight,
            child: _MosaicTile(
              memory: row[c],
              value: motion.appear(0.6 + index * 0.35, 0.7),
              zoom: 1.02 + 0.06 * motion.progress,
            ),
          ),
        );
      }
    }
    final title = caption.isNotEmpty ? caption : hero.title;
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF14100E)),
        Positioned(
          left: _side,
          right: _side,
          top: 18,
          height: 40,
          child: Row(
            children: [
              StoryMark(opacity: motion.appear(0.1)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  storyDateRange(context, memories).toUpperCase(),
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: BrandColors.amber,
                    fontSize: 10.5,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: _side,
          top: gridTop,
          width: width,
          height: heroHeight,
          child: _MosaicTile(
            memory: hero,
            value: motion.appear(0.2, 0.8),
            zoom: 1.03 + 0.08 * motion.progress,
          ),
        ),
        ...tiles,
        PositionedDirectional(
          start: 18,
          end: 18,
          bottom: 20,
          child: StoryReveal(
            value: motion.appear(1.2 + memories.length * 0.35, 0.9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 34, height: 3, color: BrandColors.gold),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: BrandColors.text,
                    fontSize: 24,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MosaicTile extends StatelessWidget {
  const _MosaicTile({
    required this.memory,
    required this.value,
    required this.zoom,
  });

  final MemoryEvent memory;
  final double value;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: value.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: 1.06 - 0.06 * value,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: StoryPhoto(memory: memory, zoom: zoom),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Picture: a film contact sheet.

class ContactSheetStory extends StatelessWidget {
  const ContactSheetStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  @override
  Widget build(BuildContext context) {
    final count = memories.length;
    final columns = count == 1 ? 1 : 2;
    final rows = (count / columns).ceil();
    const rowGapEarly = 26.0;
    // As large as the picture's height allows.
    final area = StoryPageSize.of(context).height - 92 - 80;
    final frameWidth = math.min(
      columns == 1 ? 280.0 : 140.0,
      (area - rowGapEarly * (rows - 1)) / rows / 0.72,
    );
    final frameHeight = frameWidth * 0.72;
    const stripPad = 18.0;
    final stripWidth = frameWidth + 2 * stripPad;
    const rowGap = 26.0;
    final blockWidth = columns * stripWidth + (columns - 1) * 16;
    final blockHeight = rows * (frameHeight + rowGap) - rowGap;
    final left = (360 - blockWidth) / 2;
    final top = 92 + (area - blockHeight) / 2;
    final frames = <Widget>[];
    for (var i = 0; i < count; i++) {
      final c = i % columns;
      final r = i ~/ columns;
      final x = left + c * (stripWidth + 16);
      final y = top + r * (frameHeight + rowGap);
      frames.add(
        Positioned(
          left: x,
          top: y - 8,
          width: stripWidth,
          height: frameHeight + 16,
          child: Opacity(
            opacity: motion.appear(0.3 + i * 0.3, 0.5),
            child: _Frame(
              memory: memories[i],
              number: i + 1,
              circled: i == 0,
              circle: motion.appear(0.6 + count * 0.3, 0.9),
            ),
          ),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF101010)),
        PositionedDirectional(
          top: 26,
          start: 22,
          end: 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StoryMark(opacity: motion.appear(0.1)),
              const SizedBox(height: 14),
              Text(
                storyDateRange(context, memories).toUpperCase(),
                style: const TextStyle(
                  color: BrandColors.amber,
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        ...frames,
        PositionedDirectional(
          start: 24,
          end: 24,
          bottom: 30,
          child: StoryReveal(
            value: motion.appear(1.0 + count * 0.3, 0.8),
            child: Text(
              caption.isNotEmpty ? caption : memories.first.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _hand.copyWith(
                color: const Color(0xFFE85A44),
                fontSize: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.memory,
    required this.number,
    required this.circled,
    required this.circle,
  });

  final MemoryEvent memory;
  final int number;
  final bool circled;
  final double circle;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StripPainter(),
      foregroundPainter: circled ? _GreasePencilPainter(circle) : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            StoryPhoto(memory: memory),
            PositionedDirectional(
              start: 4,
              bottom: 2,
              child: Text(
                '${number}A',
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Color(0xFFFFB347),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StripPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF2A2522),
    );
    final hole = Paint()..color = const Color(0xFF101010);
    for (double y = 6; y < size.height - 6; y += 13) {
      for (final x in [5.0, size.width - 12]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, 7, 7),
            const Radius.circular(1.5),
          ),
          hole,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_StripPainter old) => false;
}

class _GreasePencilPainter extends CustomPainter {
  const _GreasePencilPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final oval = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width + 10,
      height: size.height + 16,
    );
    final path = Path()..addOval(oval);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress.clamp(0.0, 1.0)),
      Paint()
        ..color = const Color(0xFFE85A44)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3.5,
    );
  }

  @override
  bool shouldRepaint(_GreasePencilPainter old) => old.progress != progress;
}

// ---------------------------------------------------------------------------
// Video: the camera flies along the rope from card to card.

class WallFlightStory extends StatelessWidget {
  const WallFlightStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _cardWidth = 150.0;
  static const _rowStep = 175.0;
  static const _zoom = 1.75;

  Offset _cardAt(int i) => Offset(i.isEven ? 0 : 170, i * _rowStep);

  @override
  Widget build(BuildContext context) {
    final count = memories.length;
    final contentWidth = count == 1 ? _cardWidth : 170 + _cardWidth;
    final contentHeight = (count - 1) * _rowStep + 170;
    final overview = (
      center: Offset(contentWidth / 2, contentHeight / 2),
      scale: math.min(
        1.6,
        math.min(320 / contentWidth, 480 / (contentHeight + 40)),
      ),
    );
    ({Offset center, double scale}) card(int i) =>
        (center: _cardAt(i) + const Offset(_cardWidth / 2, 82), scale: _zoom);
    ({Offset center, double scale}) lerp(
      ({Offset center, double scale}) a,
      ({Offset center, double scale}) b,
      double t,
    ) => (
      center: Offset.lerp(a.center, b.center, t)!,
      scale: ui.lerpDouble(a.scale, b.scale, t)!,
    );

    final turns = storyTurns(StoryTemplate.wallFlight, motion.total);
    final beat = motion.beatFor(StoryTemplate.wallFlight, count);
    final now = motion.seconds;
    final ({Offset center, double scale}) camera;
    var focus = -1;
    var arrived = 0.0;
    if (now == null || now < turns.intro) {
      final t = now == null ? 0.0 : (now / turns.intro).clamp(0.0, 1.0);
      camera = lerp(overview, overview, t);
    } else if (now > motion.total - turns.outro) {
      final t = Curves.easeInOutCubic.transform(
        ((now - (motion.total - turns.outro)) / (turns.outro * 0.7)).clamp(
          0.0,
          1.0,
        ),
      );
      camera = lerp(card(count - 1), overview, t);
    } else {
      focus = beat.index;
      final from = focus == 0 ? overview : card(focus - 1);
      final move = beat.phase(0, 0.4);
      camera = lerp(from, card(focus), move);
      arrived = beat.phase(0.4, 0.55) * (1 - beat.phase(0.92, 1));
    }

    final pins = [
      for (var i = 0; i < count; i++)
        _cardAt(i) + const Offset(_cardWidth / 2, 4),
    ];
    final transform = Matrix4.identity()
      ..translateByDouble(180, 300, 0, 1)
      ..scaleByDouble(camera.scale, camera.scale, 1, 1)
      ..translateByDouble(-camera.center.dx, -camera.center.dy, 0, 1);
    final memory = focus >= 0 ? memories[focus] : null;

    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        ClipRect(
          child: Transform(
            transform: transform,
            child: SizedBox(
              width: contentWidth,
              height: contentHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: StoryRopePainter(points: pins)),
                  ),
                  for (var i = 0; i < count; i++)
                    Positioned(
                      left: _cardAt(i).dx,
                      top: _cardAt(i).dy,
                      child: Transform.rotate(
                        angle: i.isEven ? -0.04 : 0.035,
                        alignment: Alignment.topCenter,
                        child: StoryPaperCard(
                          memory: memories[i],
                          width: _cardWidth,
                          titleLines: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
        if (memory != null && arrived > 0)
          PositionedDirectional(
            start: 22,
            end: 22,
            bottom: 40,
            child: Opacity(
              opacity: arrived,
              child: _Caption(
                title: focus == 0 && caption.isNotEmpty
                    ? caption
                    : memory.title,
                detail: storyMemoryDetail(context, memory),
              ),
            ),
          ),
        if (now == null || now > motion.total - turns.outro * 0.5)
          PositionedDirectional(
            start: 22,
            end: 22,
            bottom: 40,
            child: StoryReveal(
              value: now == null
                  ? 1
                  : motion.appear(motion.total - turns.outro * 0.5, 0.6),
              child: _Caption(
                title: _headline(context, memories, caption),
                detail: storyDateRange(context, memories),
              ),
            ),
          ),
      ],
    );
  }
}

/// A title and a line of detail on a soft dark band.
class _Caption extends StatelessWidget {
  const _Caption({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: BrandColors.wallInk.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.gold.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: BrandColors.text,
              fontSize: 20,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: BrandColors.amber,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Video: a 3D carousel.

class CarouselStory extends StatelessWidget {
  const CarouselStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _radius = 105.0;
  static const _cardWidth = 200.0;

  @override
  Widget build(BuildContext context) {
    final count = memories.length;
    final step = 2 * math.pi / math.max(count, 1);
    final beat = motion.beatFor(StoryTemplate.carousel, count);
    // The carousel turns to each memory at the start of its turn.
    final turn = beat.still
        ? 0.0
        : (beat.index - 1 + beat.phase(0, 0.3)).clamp(0.0, count - 1.0);
    final spin = -turn * step;
    final front = beat.index;
    final cards = <({double depth, Widget widget})>[];
    for (var i = 0; i < count; i++) {
      final angle = i * step + spin;
      final x = math.sin(angle) * _radius;
      final depth = math.cos(angle);
      final scale = count == 1 ? 1.0 : 0.55 + 0.45 * (depth + 1) / 2;
      cards.add((
        depth: depth,
        widget: Positioned(
          left: 180 - _cardWidth / 2 + x,
          top: 196,
          child: Opacity(
            opacity: count == 1 ? 1 : (0.35 + 0.65 * (depth + 1) / 2),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateY(
                  count == 1
                      ? 0.12 * math.sin(motion.progress * 6)
                      : angle * 0.6,
                )
                ..scaleByDouble(scale, scale, 1, 1),
              child: StoryPaperCard(
                memory: memories[i],
                width: _cardWidth,
                titleLines: 1,
                zoom: 1.02 + 0.05 * motion.progress,
              ),
            ),
          ),
        ),
      ));
    }
    cards.sort((a, b) => a.depth.compareTo(b.depth));
    final memory = memories[front];
    final reveal = beat.still ? 1.0 : beat.phase(0.28, 0.42);

    return Stack(
      fit: StackFit.expand,
      children: [
        const StoryWallBackdrop(),
        // The floor light the carousel turns on.
        Positioned(
          left: 40,
          right: 40,
          top: 450,
          height: 60,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  BrandColors.gold.withValues(alpha: 0.28),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
        PositionedDirectional(
          top: 64,
          start: 24,
          end: 24,
          child: StoryReveal(
            value: motion.appear(0.2, 0.8),
            child: Text(
              _headline(context, memories, caption),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: BrandColors.text,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        for (final card in cards) card.widget,
        PositionedDirectional(
          start: 22,
          end: 22,
          bottom: 60,
          child: Opacity(
            opacity: reveal,
            child: _Caption(
              title: memory.title,
              detail: storyMemoryDetail(context, memory),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 30,
          child: Center(
            child: StoryPageDots(count: count, index: front),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Video: a route across a paper map.

class JourneyStory extends StatelessWidget {
  const JourneyStory({
    super.key,
    required this.memories,
    required this.caption,
    required this.motion,
  });

  final List<MemoryEvent> memories;
  final String caption;
  final StoryMotion motion;

  static const _area = Rect.fromLTWH(48, 150, 264, 330);

  /// Where each memory sits on the map: by its place when the memories
  /// are in different places, otherwise in a gentle zigzag.
  List<Offset> _points(List<MemoryEvent> ordered) {
    final geo = [for (final memory in ordered) memory.hasGeoPoint];
    if (geo.every((has) => has) && ordered.length > 1) {
      final lats = [for (final m in ordered) m.latitude!];
      final lngs = [for (final m in ordered) m.longitude!];
      final minLat = lats.reduce(math.min);
      final maxLat = lats.reduce(math.max);
      final minLng = lngs.reduce(math.min);
      final maxLng = lngs.reduce(math.max);
      final spanLat = maxLat - minLat;
      final spanLng = maxLng - minLng;
      if (spanLat > 0.01 || spanLng > 0.01) {
        final span = math.max(spanLat, spanLng);
        return [
          for (var i = 0; i < ordered.length; i++)
            Offset(
              _area.left +
                  _area.width *
                      (0.5 + (lngs[i] - (minLng + maxLng) / 2) / span),
              _area.top +
                  _area.height *
                      (0.5 - (lats[i] - (minLat + maxLat) / 2) / span),
            ),
        ];
      }
    }
    final count = ordered.length;
    return [
      for (var i = 0; i < count; i++)
        Offset(
          _area.left + (i.isEven ? 0.2 : 0.8) * _area.width,
          count == 1
              ? _area.center.dy
              : _area.top + _area.height * i / (count - 1),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ordered = [...memories]
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    final count = ordered.length;
    final points = _points(ordered);
    final beat = motion.beatFor(StoryTemplate.journey, count);
    final arrive = beat.still ? 1.0 : beat.phase(0, 0.3);
    // How far along the route the line is drawn: to the current place.
    final reached = beat.still ? count - 1.0 : beat.index - 1 + arrive;
    final index = beat.index;
    final memory = ordered[index];
    final bubble = beat.still ? 1.0 : beat.phase(0.3, 0.45);

    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFEFE4CB), Color(0xFFE2D2B0)],
            ),
          ),
        ),
        CustomPaint(
          painter: _MapPainter(
            points: points,
            reached: reached,
            pinsShown: beat.still ? count : index + (arrive >= 1 ? 1 : 0),
          ),
        ),
        PositionedDirectional(
          top: 22,
          start: 18,
          child: StoryMark(opacity: motion.appear(0.2)),
        ),
        PositionedDirectional(
          top: 64,
          start: 24,
          end: 24,
          child: StoryReveal(
            value: motion.appear(0.2, 0.8),
            child: Text(
              _headline(context, ordered, caption),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _hand.copyWith(fontSize: 22),
            ),
          ),
        ),
        if (!beat.still && bubble > 0)
          Positioned(
            left: (points[index].dx - 55).clamp(10.0, 240.0),
            top: (points[index].dy - 140).clamp(110.0, 420.0),
            child: Opacity(
              opacity: bubble,
              child: Transform.scale(
                scale: 0.8 + 0.2 * bubble,
                child: Container(
                  width: 110,
                  height: 110,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: StoryPhoto(memory: memory),
                  ),
                ),
              ),
            ),
          ),
        PositionedDirectional(
          start: 22,
          end: 22,
          bottom: 36,
          child: Opacity(
            opacity: beat.still ? 1 : bubble,
            child: _Caption(
              title: beat.still
                  ? storyDateRange(context, ordered)
                  : memory.title,
              detail: beat.still
                  ? {
                      for (final m in ordered)
                        if (m.hasGeoPoint) m.locationDisplayLabel,
                    }.join(' · ')
                  : storyMemoryDetail(context, memory),
            ),
          ),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter({
    required this.points,
    required this.reached,
    required this.pinsShown,
  });

  final List<Offset> points;
  final double reached;
  final int pinsShown;

  @override
  void paint(Canvas canvas, Size size) {
    // Contour lines and a faint grid, like an old map.
    final contour = Paint()
      ..color = const Color(0xFFB59B6A).withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var k = 0; k < 9; k++) {
      final path = Path();
      for (double x = -10; x <= size.width + 10; x += 8) {
        final y =
            120 +
            k * 62 +
            math.sin(x / 47 + k * 1.3) * 16 +
            math.cos(x / 83) * 8;
        if (x == -10) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, contour);
    }
    final grid = Paint()
      ..color = const Color(0xFF9C8458).withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // The route, dashed, drawn up to [reached].
    if (points.length > 1 && reached > 0) {
      final route = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        final a = points[i - 1];
        final b = points[i];
        final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2 - 30);
        route.quadraticBezierTo(mid.dx, mid.dy, b.dx, b.dy);
      }
      final metric = route.computeMetrics().first;
      final segments = points.length - 1;
      final drawn = metric.length * (reached / segments).clamp(0.0, 1.0);
      final dash = Paint()
        ..color = const Color(0xFFB3412F)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (double d = 0; d < drawn; d += 14) {
        canvas.drawPath(metric.extractPath(d, math.min(d + 8, drawn)), dash);
      }
    }

    // Pins at the places reached.
    for (var i = 0; i < points.length && i < pinsShown; i++) {
      final p = points[i];
      canvas.drawCircle(
        p + const Offset(0, 2),
        9,
        Paint()..color = Colors.black.withValues(alpha: 0.2),
      );
      canvas.drawCircle(p, 9, Paint()..color = const Color(0xFFB3412F));
      canvas.drawCircle(p, 3.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.reached != reached ||
      old.pinsShown != pinsShown ||
      old.points != points;
}
