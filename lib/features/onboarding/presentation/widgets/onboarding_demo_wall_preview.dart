import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/data/memory_seed_data.dart';

/// The demo wall in small, alive: the cards appear one after another and
/// sway like on the real wall, and the threads draw themselves between
/// them. Still with Reduce Motion.
class OnboardingDemoWallPreview extends StatefulWidget {
  const OnboardingDemoWallPreview({super.key});

  @override
  State<OnboardingDemoWallPreview> createState() =>
      _OnboardingDemoWallPreviewState();
}

class _OnboardingDemoWallPreviewState extends State<OnboardingDemoWallPreview>
    with TickerProviderStateMixin {
  late final _appear = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  late final _wind = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _appear.value = 1;
      _wind.stop();
    } else {
      if (_appear.value == 0) _appear.forward();
      if (!_wind.isAnimating) _wind.repeat();
    }
  }

  @override
  void dispose() {
    _appear.dispose();
    _wind.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demoEvents = MemorySeedData.localizedEvents(context.l10n);
    return AnimatedBuilder(
      animation: Listenable.merge([_appear, _wind]),
      builder: (context, _) => _frame(context, demoEvents),
    );
  }

  /// Six demo memories in two loose rows, so the threads between them show.
  static const _links = [(0, 1), (1, 2), (3, 4), (4, 5), (1, 4), (0, 3)];
  static const _cardWidth = 96.0;

  Widget _frame(BuildContext context, List<dynamic> demoEvents) {
    final shown = demoEvents.take(6).toList();
    final count = shown.length;
    // Cards in the first 60 %, one after another; threads after them.
    double cardIn(int index) {
      final start = 0.6 * index / count;
      return Curves.easeOutBack.transform(
        ((_appear.value - start) / 0.25).clamp(0.0, 1.0),
      );
    }

    final threads = Curves.easeInOut.transform(
      ((_appear.value - 0.45) / 0.55).clamp(0.0, 1.0),
    );

    return Container(
      height: 352,
      decoration: BoxDecoration(
        color: AppColors.wallDeep.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final xs = [
              width * 0.05,
              width / 2 - _cardWidth / 2,
              width * 0.95 - _cardWidth,
            ];
            // The middle card of each row hangs a little lower.
            final positions = [
              for (var i = 0; i < count; i++)
                Offset(
                  xs[i % 3],
                  (i < 3 ? 34.0 : 172.0) + (i % 3 == 1 ? 16 : 0),
                ),
            ];
            final pins = [
              for (final position in positions)
                position + const Offset(_cardWidth / 2, -8),
            ];
            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _PreviewGridPainter()),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PreviewThreadPainter(
                      pins: pins,
                      links: [
                        for (final link in _links)
                          if (link.$1 < count && link.$2 < count) link,
                      ],
                      progress: threads,
                    ),
                  ),
                ),
                for (final (index, event) in shown.indexed)
                  _PreviewMemoryCard(
                    title: event.title,
                    color: event.coverColor,
                    imagePath: event.coverPhotoPath,
                    position: positions[index],
                    width: _cardWidth,
                    rotation:
                        (index.isEven ? -0.04 : 0.035) +
                        math.sin(_wind.value * math.pi * 2 + index) * 0.025,
                    appear: cardIn(index),
                  ),
                Positioned(
                  left: 16,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.wallInk.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Text(
                      context.l10n.optionalDemoPreview,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
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

class _PreviewMemoryCard extends StatelessWidget {
  const _PreviewMemoryCard({
    required this.title,
    required this.color,
    required this.imagePath,
    required this.position,
    required this.rotation,
    this.width = 104,
    this.appear = 1,
  });

  final String title;
  final double width;
  final Color color;
  final String? imagePath;
  final Offset position;
  final double rotation;

  /// 0 → 1 while the card is hung: it drops in from above and fades in.
  final double appear;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy - (1 - appear) * 24,
      child: Opacity(
        opacity: appear.clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: rotation,
          alignment: Alignment.topCenter,
          child: Container(
            width: 104,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.34),
                  blurRadius: 20,
                  offset: const Offset(0, 11),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: imagePath == null
                      ? null
                      : Image.asset(
                          imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                ),
                const SizedBox(height: 7),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.paperInk,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.055)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 52) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 52) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PreviewThreadPainter extends CustomPainter {
  const _PreviewThreadPainter({
    required this.pins,
    required this.links,
    this.progress = 1,
  });

  /// Where each card hangs (top centre).
  final List<Offset> pins;

  /// Pairs of cards joined by a thread.
  final List<(int, int)> links;

  /// How much of each thread is drawn (0 → 1).
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rope = Paint()
      ..color = AppColors.rope.withValues(alpha: 0.7)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    if (progress > 0) {
      for (final (from, to) in links) {
        final start = pins[from];
        final end = pins[to];
        final control = Offset(
          (start.dx + end.dx) / 2,
          math.max(start.dy, end.dy) + 14,
        );
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
        for (final PathMetric metric in path.computeMetrics()) {
          canvas.drawPath(
            metric.extractPath(0, metric.length * progress),
            rope,
          );
        }
      }
    }
    final pin = Paint()..color = AppColors.gold;
    for (final point in pins) {
      canvas.drawCircle(point, 4, pin);
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewThreadPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pins != pins;
}
