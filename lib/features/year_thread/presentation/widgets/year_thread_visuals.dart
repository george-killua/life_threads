import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../app/theme/app_colors.dart';
import '../../../memories/domain/memory_feeling.dart';
import '../../../wall/domain/wall_theme.dart';
import '../../../wall/presentation/widgets/metallic_ball_pin.dart';
import '../../domain/year_thread.dart';

// The wall's look (dark room, cream pinned cards, gold rope) for the film
// and the year image. Everything here is drawn from its arguments only: the
// story renderer freezes animations, so motion comes from the caller.

/// The photo of [memory] as an image provider; null without a photo.
ImageProvider? yearThreadPhoto(YearThreadMemory memory) {
  final path = memory.photoPath;
  if (path == null) return null;
  return path.startsWith('assets/') ? AssetImage(path) : FileImage(File(path));
}

String yearThreadDate(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMMd(locale).format(date);
}

/// The warm memory room behind the wall, without the theme lookup of
/// `WallBackground` (story frames are rendered outside the app's providers).
class YearThreadBackdrop extends StatelessWidget {
  const YearThreadBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _BackdropPainter(),
      child: SizedBox.expand(),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter();

  static const _theme = WallThemePreset.warmMemoryRoom;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_theme.background, _theme.depth, _theme.surface],
          stops: const [0, 0.52, 1],
        ).createShader(rect),
    );
    _glow(
      canvas,
      Offset(size.width * 0.18, size.height * 0.1),
      size.shortestSide * 1.1,
      _theme.secondaryGlow.withValues(alpha: 0.16),
    );
    _glow(
      canvas,
      Offset(size.width * 0.9, size.height * 0.8),
      size.shortestSide * 1.05,
      _theme.accent.withValues(alpha: 0.13),
    );

    final fiber = Paint()
      ..color = _theme.accent.withValues(alpha: 0.025)
      ..strokeWidth = 1;
    for (double y = 10; y < size.height; y += 13) {
      final drift = math.sin(y * 0.021) * 11;
      canvas.drawLine(
        Offset(drift - 20, y),
        Offset(size.width + drift + 20, y + 1.8),
        fiber,
      );
    }
    final grid = Paint()
      ..color = _theme.line.withValues(alpha: 0.16)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 118) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 118) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          radius: 0.9,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.42)],
          stops: const [0.6, 1],
        ).createShader(rect),
    );
  }

  void _glow(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) => false;
}

/// A rope between two points, drawn from [from] up to [progress] (0..1).
class YearThreadRope {
  const YearThreadRope({
    required this.from,
    required this.to,
    this.progress = 1,
    this.sag = 60,
  });

  final Offset from;
  final Offset to;
  final double progress;
  final double sag;
}

/// The wall's gold rope (shadow, glow, body and a thin highlight), with a
/// spark at the tip while a rope is still being drawn.
class YearThreadRopePainter extends CustomPainter {
  const YearThreadRopePainter({required this.ropes, this.scale = 1});

  final List<YearThreadRope> ropes;

  /// Widths shrink with the camera, but never below a visible line.
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    for (final rope in ropes) {
      if (rope.progress <= 0) continue;
      final full = Path()
        ..moveTo(rope.from.dx, rope.from.dy)
        ..quadraticBezierTo(
          (rope.from.dx + rope.to.dx) / 2,
          (rope.from.dy + rope.to.dy) / 2 + rope.sag,
          rope.to.dx,
          rope.to.dy,
        );
      final path = Path();
      Offset? tip;
      for (final metric in full.computeMetrics()) {
        final length = metric.length * rope.progress.clamp(0.0, 1.0);
        path.addPath(metric.extractPath(0, length), Offset.zero);
        tip = metric.getTangentForOffset(length)?.position;
      }
      _stroke(canvas, path);
      if (rope.progress < 1 && tip != null) {
        final radius = math.max(3.0, 9 * scale);
        canvas.drawCircle(
          tip,
          radius,
          Paint()
            ..shader = RadialGradient(
              colors: [
                BrandColors.amber.withValues(alpha: 0.9),
                BrandColors.amber.withValues(alpha: 0),
              ],
            ).createShader(Rect.fromCircle(center: tip, radius: radius)),
        );
      }
    }
  }

  void _stroke(Canvas canvas, Path path) {
    double width(double value) => math.max(value * scale, value * 0.3);
    canvas
      ..drawPath(
        path.shift(Offset(0, 6 * scale)),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.3)
          ..strokeWidth = width(9)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      )
      ..drawPath(
        path,
        Paint()
          ..color = BrandColors.gold.withValues(alpha: 0.2)
          ..strokeWidth = width(10)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = ui.MaskFilter.blur(BlurStyle.normal, width(4)),
      )
      ..drawPath(
        path,
        Paint()
          ..color = BrandColors.rope
          ..strokeWidth = width(4.4)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      )
      ..drawPath(
        path,
        Paint()
          ..color = BrandColors.amber.withValues(alpha: 0.55)
          ..strokeWidth = width(1.4)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
  }

  @override
  bool shouldRepaint(covariant YearThreadRopePainter oldDelegate) => true;
}

/// A cream photo card pinned at its top centre, like the wall's memory
/// cards. [photoScale] and [photoDrift] move the photo (slow zoom and
/// drift); [textOpacity] fades the caption in.
class YearThreadCard extends StatelessWidget {
  const YearThreadCard({
    super.key,
    required this.memory,
    this.photoScale = 1,
    this.photoDrift = Offset.zero,
    this.textOpacity = 1,
    this.compact = false,
  });

  final YearThreadMemory memory;
  final double photoScale;
  final Offset photoDrift;
  final double textOpacity;

  /// A small photo-only card (the year image's grid).
  final bool compact;

  static const size = Size(252, 330);
  static const compactSize = Size(92, 110);

  @override
  Widget build(BuildContext context) {
    final cardSize = compact ? compactSize : size;
    final padding = compact ? 6.0 : 12.0;
    return SizedBox.fromSize(
      size: cardSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF7E7),
                    BrandColors.card,
                    Color(0xFFEBD6AF),
                  ],
                ),
                borderRadius: BorderRadius.circular(compact ? 8 : 18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: compact ? 14 : 30,
                    offset: Offset(0, compact ? 8 : 18),
                  ),
                  BoxShadow(
                    color: memory.event.coverColor.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(compact ? 5 : 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: compact ? 80 : 206,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Transform.translate(
                              offset: photoDrift,
                              child: Transform.scale(
                                scale: photoScale,
                                child: _Photo(memory: memory),
                              ),
                            ),
                            if (!compact)
                              PositionedDirectional(
                                top: 8,
                                end: 8,
                                child: _FeelingBadge(
                                  feeling: memory.event.feeling,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (compact)
                      const Spacer()
                    else
                      // Long titles or large fonts are cut at the card's
                      // edge instead of overflowing it.
                      Expanded(
                        child: ClipRect(
                          child: OverflowBox(
                            alignment: AlignmentDirectional.topStart,
                            maxHeight: double.infinity,
                            child: Opacity(
                              opacity: textOpacity.clamp(0.0, 1.0),
                              child: _Caption(memory: memory),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: compact ? -9 : -13,
            left: 0,
            right: 0,
            child: Center(
              child: MetallicBallPin(size: compact ? 14 : 22, showStem: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption({required this.memory});

  final YearThreadMemory memory;

  @override
  Widget build(BuildContext context) {
    final meta = TextStyle(
      color: BrandColors.paperInk.withValues(alpha: 0.62),
      fontWeight: FontWeight.w700,
      fontSize: 12.5,
    );
    final place = memory.place;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 11),
        Text(
          memory.event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: BrandColors.paperInk,
            fontWeight: FontWeight.w900,
            fontSize: 19,
            height: 1.15,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Icon(
              Icons.event_rounded,
              size: 14,
              color: BrandColors.rope.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                yearThreadDate(context, memory.event.occurredAt),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: meta,
              ),
            ),
          ],
        ),
        if (place.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.place_rounded,
                size: 14,
                color: BrandColors.rope.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  place,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: meta,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.memory});

  final YearThreadMemory memory;

  @override
  Widget build(BuildContext context) {
    final photo = yearThreadPhoto(memory);
    if (photo == null) return YearThreadPhotoPlaceholder(memory: memory);
    return Image(
      image: photo,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => YearThreadPhotoPlaceholder(memory: memory),
    );
  }
}

/// The memory's colour and feeling where it has no photo.
class YearThreadPhotoPlaceholder extends StatelessWidget {
  const YearThreadPhotoPlaceholder({super.key, required this.memory});

  final YearThreadMemory memory;

  @override
  Widget build(BuildContext context) {
    final color = memory.event.coverColor;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.92),
            color,
            BrandColors.cardDark.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: Icon(
            memory.event.feeling.icon,
            size: constraints.biggest.shortestSide * 0.38,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

class _FeelingBadge extends StatelessWidget {
  const _FeelingBadge({required this.feeling});

  final MemoryFeeling feeling;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: BrandColors.card.withValues(alpha: 0.92),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(feeling.icon, size: 17, color: feeling.color),
    );
  }
}

/// A stat on the closing card and the year image: icon and text.
class YearThreadStatChip extends StatelessWidget {
  const YearThreadStatChip({
    super.key,
    required this.icon,
    required this.label,
    this.color = BrandColors.gold,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: BrandColors.wallInk.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.34)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: BrandColors.text,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// The app's name, small, on the title and closing cards.
class YearThreadMark extends StatelessWidget {
  const YearThreadMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: BrandColors.gold,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'LifeThreads',
          style: TextStyle(
            color: BrandColors.text.withValues(alpha: 0.72),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
