import 'package:flutter/material.dart';

import '../../domain/wall_card_style.dart';
import '../../domain/wall_theme.dart';
import 'wall_background.dart';

/// A small live picture of a wall theme: its background, two memory cards in
/// the theme's card style, and the rope between them.
class WallThemePreview extends StatelessWidget {
  const WallThemePreview({super.key, required this.theme, this.radius = 16});

  final WallThemePreset theme;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: WallBackground(
        theme: theme,
        // A fixed design size scaled to fit, so the preview looks the same
        // as a thumbnail and as a large sheet.
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 320,
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  left: 34,
                  top: 34,
                  child: _MiniCard(
                    style: theme.cardStyle,
                    photo: theme.accent,
                    angle: -0.07,
                  ),
                ),
                Positioned(
                  right: 38,
                  top: 58,
                  child: _MiniCard(
                    style: theme.cardStyle,
                    photo: theme.secondaryGlow,
                    angle: 0.06,
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PreviewRopePainter(theme.ropeGlow),
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

class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.style,
    required this.photo,
    required this.angle,
  });

  final WallCardStyle style;
  final Color photo;
  final double angle;

  @override
  Widget build(BuildContext context) {
    // Memory cards are 190 wide; this one is about half that.
    const scale = 0.5;
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 96,
        padding: style.padding * scale,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: style.paper,
          ),
          borderRadius: BorderRadius.circular(style.radius * scale),
          border: Border.all(color: style.edge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(style.photoRadius * scale),
              child: Container(
                height: 62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [photo.withValues(alpha: 0.75), photo],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            _Line(color: style.ink, width: 58),
            const SizedBox(height: 4),
            _Line(color: style.ink.withValues(alpha: 0.45), width: 38),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _PreviewRopePainter extends CustomPainter {
  const _PreviewRopePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(size.width * 0.27, size.height * 0.17);
    final end = Offset(size.width * 0.72, size.height * 0.29);
    final sag = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2 + size.height * 0.16,
    );
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(sag.dx, sag.dy, end.dx, end.dy);

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    for (final pin in [start, end]) {
      canvas.drawCircle(pin, 5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _PreviewRopePainter oldDelegate) =>
      oldDelegate.color != color;
}
