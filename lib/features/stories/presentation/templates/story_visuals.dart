import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/domain/memory_event.dart';
import '../../../memories/presentation/memory_l10n.dart';
import '../../../wall/domain/wall_theme.dart';
import '../../../wall/presentation/widgets/metallic_ball_pin.dart';

/// Story pages are laid out at 360×640 logical pixels (1080×1920 at 3×).
const storySize = Size(360, 640);

/// The photo of [memory] at a size that is sharp in a 1080×1920 story but
/// never decodes a full camera image (a 12 MP photo would take ~48 MB).
ImageProvider? storyPhotoFor(MemoryEvent memory) {
  final path = memory.coverPhotoPath;
  if (path == null || path.isEmpty) return null;
  final ImageProvider source = path.startsWith('assets/')
      ? AssetImage(path)
      : FileImage(File(path));
  return ResizeImage(
    source,
    width: 1440,
    height: 1440,
    policy: ResizeImagePolicy.fit,
  );
}

/// Where a story is in its film. Templates draw their finished, still
/// state (the story image) with [StoryMotion.still].
class StoryMotion {
  const StoryMotion.still() : seconds = null, total = 1;

  const StoryMotion.at(double this.seconds, this.total);

  /// Seconds since the film started; null for a still image.
  final double? seconds;

  /// Length of the film in seconds.
  final double total;

  bool get isStill => seconds == null;

  /// 0 → 1 (eased) over a beat starting at [start] lasting [length]
  /// seconds; always 1 for a still image.
  double appear(double start, [double length = 0.9]) {
    final now = seconds;
    if (now == null) return 1;
    if (length <= 0) return now >= start ? 1 : 0;
    final value = ((now - start) / length).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(value);
  }

  /// Linear 0 → 1 over a beat, for movements that should not ease.
  double linear(double start, double length) {
    final now = seconds;
    if (now == null) return 1;
    return ((now - start) / length).clamp(0.0, 1.0);
  }

  /// 0 → 1 across the whole film (0.35 for a still: a slight zoom).
  double get progress {
    final now = seconds;
    if (now == null) return 0.35;
    return (now / total).clamp(0.0, 1.0);
  }

  /// 0 → 1 over the last 0.6 s, to fade the film out with the music.
  double get ending {
    final now = seconds;
    if (now == null) return 0;
    return ((now - (total - 0.6)) / 0.6).clamp(0.0, 1.0);
  }
}

/// The dark memory-room wall behind story pages (the free "Warm memory
/// room" theme, so every story looks like LifeThreads).
class StoryWallBackdrop extends StatelessWidget {
  const StoryWallBackdrop({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _StoryWallPainter(WallThemePreset.warmMemoryRoom),
      child: child == null ? const SizedBox.expand() : child!,
    );
  }
}

class _StoryWallPainter extends CustomPainter {
  const _StoryWallPainter(this.theme);

  final WallThemePreset theme;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.background, theme.depth, theme.surface],
          stops: const [0, 0.52, 1],
        ).createShader(rect),
    );
    _glow(
      canvas,
      Offset(size.width * 0.18, size.height * 0.1),
      size.shortestSide * 1.1,
      theme.secondaryGlow.withValues(alpha: 0.16),
    );
    _glow(
      canvas,
      Offset(size.width * 0.9, size.height * 0.8),
      size.shortestSide,
      theme.accent.withValues(alpha: 0.13),
    );

    final fiber = Paint()
      ..color = theme.accent.withValues(alpha: 0.025)
      ..strokeWidth = 1;
    for (double y = 10; y < size.height; y += 13) {
      final drift = math.sin(y * 0.021) * 11;
      canvas.drawLine(
        Offset(drift - 20, y),
        Offset(size.width + drift + 20, y + 1.8),
        fiber,
      );
    }
    final speck = Paint()..color = Colors.white.withValues(alpha: 0.02);
    for (var i = 0; i < 120; i++) {
      final x = (i * 47) % size.width;
      final y = (i * 83) % size.height;
      canvas.drawCircle(Offset(x, y), 0.5 + ((i * 13) % 5) * 0.08, speck);
    }
    final line = Paint()
      ..color = theme.line.withValues(alpha: 0.16)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 90) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += 90) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
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
  bool shouldRepaint(covariant _StoryWallPainter oldDelegate) =>
      oldDelegate.theme.id != theme.id;
}

/// The small LifeThreads mark in a corner of every story.
class StoryMark extends StatelessWidget {
  const StoryMark({super.key, this.opacity = 1});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 10, 5),
        decoration: BoxDecoration(
          color: BrandColors.wallInk.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: BrandColors.gold.withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: BrandColors.amber,
              size: 12,
            ),
            SizedBox(width: 5),
            Text(
              'LifeThreads',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: BrandColors.text,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A memory's photo filling its box, with a slow zoom ([zoom] 1 = none)
/// and drift for films. Without a photo it shows the memory's colour.
class StoryPhoto extends StatelessWidget {
  const StoryPhoto({
    super.key,
    required this.memory,
    this.zoom = 1,
    this.drift = Offset.zero,
  });

  final MemoryEvent memory;
  final double zoom;

  /// Shift as a fraction of the box size.
  final Offset drift;

  @override
  Widget build(BuildContext context) {
    final provider = storyPhotoFor(memory);
    final placeholder = StoryPhotoPlaceholder(color: memory.coverColor);
    if (provider == null) return placeholder;
    return ClipRect(
      child: FractionalTranslation(
        translation: drift,
        child: Transform.scale(
          scale: zoom,
          child: Image(
            image: provider,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, _, _) => placeholder,
          ),
        ),
      ),
    );
  }
}

class StoryPhotoPlaceholder extends StatelessWidget {
  const StoryPhotoPlaceholder({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.92),
            color,
            BrandColors.cardDark.withValues(alpha: 0.55),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          color: Color(0x66FFFFFF),
          size: 28,
        ),
      ),
    );
  }
}

/// A cream paper card pinned to the wall, as on the memory wall: photo,
/// title and a line of details.
class StoryPaperCard extends StatelessWidget {
  const StoryPaperCard({
    super.key,
    required this.memory,
    required this.width,
    this.photoHeight,
    this.zoom = 1,
    this.titleLines = 2,
    this.showPin = true,
    this.detail,
  });

  final MemoryEvent memory;
  final double width;
  final double? photoHeight;
  final double zoom;
  final int titleLines;
  final bool showPin;

  /// The line under the title; the date and place by default.
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final scale = width / 190;
    final padding = 9.0 * scale.clamp(0.75, 1.3);
    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(padding),
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
              borderRadius: BorderRadius.circular(16 * scale.clamp(0.7, 1.3)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.54)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.38),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: memory.coverColor.withValues(alpha: 0.16),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    11 * scale.clamp(0.7, 1.3),
                  ),
                  child: SizedBox(
                    height: photoHeight ?? (width - 2 * padding) * 0.72,
                    width: double.infinity,
                    child: StoryPhoto(memory: memory, zoom: zoom),
                  ),
                ),
                SizedBox(height: 8 * scale.clamp(0.8, 1.2)),
                Text(
                  memory.title,
                  maxLines: titleLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: BrandColors.paperInk,
                    fontWeight: FontWeight.w900,
                    fontSize: (16 * scale).clamp(11.5, 20),
                    height: 1.15,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 3 * scale.clamp(0.8, 1.2)),
                Text(
                  detail ?? storyMemoryDetail(context, memory),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: BrandColors.paperInk.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w700,
                    fontSize: (11.5 * scale).clamp(9, 14),
                  ),
                ),
              ],
            ),
          ),
          if (showPin)
            PositionedDirectional(
              top: -9,
              start: 0,
              end: 0,
              child: const Center(
                child: MetallicBallPin(size: 15, showStem: false),
              ),
            ),
        ],
      ),
    );
  }
}

/// "12 Mar 2024 · Vienna", in the story's language.
String storyMemoryDetail(BuildContext context, MemoryEvent memory) {
  return [
    storyDate(context, memory.occurredAt),
    if (memory.hasGeoPoint) memory.locationDisplayLabel,
  ].join(' · ');
}

String storyDate(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMd(locale).format(date);
}

/// "Mar 2023 – Jun 2025", or one date when all memories share it.
String storyDateRange(BuildContext context, List<MemoryEvent> memories) {
  if (memories.isEmpty) return '';
  final dates = memories.map((memory) => memory.occurredAt).toList()..sort();
  final first = dates.first;
  final last = dates.last;
  if (first.year == last.year &&
      first.month == last.month &&
      first.day == last.day) {
    return storyDate(context, first);
  }
  final locale = Localizations.localeOf(context).toLanguageTag();
  final format = DateFormat.yMMM(locale);
  final start = format.format(first);
  final end = format.format(last);
  return start == end ? start : '$start – $end';
}

/// The memory's feeling as a small glowing chip.
class StoryFeelingChip extends StatelessWidget {
  const StoryFeelingChip({super.key, required this.memory});

  final MemoryEvent memory;

  @override
  Widget build(BuildContext context) {
    final feeling = memory.feeling;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: feeling.color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: feeling.color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(feeling.icon, size: 13, color: feeling.color),
          const SizedBox(width: 5),
          Text(
            feeling.localizedLabel(context.l10n),
            style: const TextStyle(
              color: BrandColors.text,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// The braided wall rope through [points] (pin positions), drawn up to
/// [progress] (0..1) of its length so films can draw it card to card.
class StoryRopePainter extends CustomPainter {
  const StoryRopePainter({required this.points, this.progress = 1});

  final List<Offset> points;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2 || progress <= 0) return;
    final full = _path();
    final path = Path();
    final metrics = full.computeMetrics().toList();
    final total = metrics.fold<double>(0, (sum, metric) => sum + metric.length);
    var remaining = total * progress.clamp(0.0, 1.0);
    for (final metric in metrics) {
      if (remaining <= 0) break;
      final length = math.min(metric.length, remaining);
      path.addPath(metric.extractPath(0, length), Offset.zero);
      remaining -= length;
    }

    Paint stroke(Color color, double width, {double blur = 0}) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = width
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      if (blur > 0) {
        paint.maskFilter = ui.MaskFilter.blur(BlurStyle.normal, blur);
      }
      return paint;
    }

    canvas.drawPath(
      path.shift(const Offset(0, 6)),
      stroke(Colors.black.withValues(alpha: 0.32), 9),
    );
    canvas.drawPath(
      path,
      stroke(BrandColors.amber.withValues(alpha: 0.3), 18, blur: 14),
    );
    canvas.drawPath(path, stroke(const Color(0xE64A3425), 6.4));
    canvas.drawPath(
      path.shift(const Offset(-1.4, -1)),
      stroke(const Color(0xFFF1D79A).withValues(alpha: 0.7), 2.8),
    );
    canvas.drawPath(
      path.shift(const Offset(1.4, 1)),
      stroke(const Color(0xFF7F93B8).withValues(alpha: 0.5), 2.4),
    );

    // Braid: short cross threads along the drawn part.
    final gold = stroke(const Color(0xFFFFE2A5).withValues(alpha: 0.45), 1.1);
    final blue = stroke(const Color(0xFFAAB9D5).withValues(alpha: 0.38), 1);
    for (final metric in path.computeMetrics()) {
      for (double offset = 6; offset < metric.length - 6; offset += 14) {
        final tangent = metric.getTangentForOffset(offset);
        if (tangent == null) continue;
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
        final phase = math.sin(offset * 0.16);
        canvas.drawLine(
          tangent.position + normal * (phase * 4),
          tangent.position - normal * (phase * 4),
          phase > 0 ? gold : blue,
        );
      }
    }
  }

  /// One sagging curve from pin to pin.
  Path _path() {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final start = points[i - 1];
      final end = points[i];
      final vector = end - start;
      final sag = (vector.dx.abs() * 0.16 + vector.dy.abs() * 0.05).clamp(
        14.0,
        60.0,
      );
      final control1 = start + vector * 0.3 + Offset(0, sag);
      final control2 = start + vector * 0.7 + Offset(0, sag);
      path.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        end.dx,
        end.dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant StoryRopePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.points != points;
}
