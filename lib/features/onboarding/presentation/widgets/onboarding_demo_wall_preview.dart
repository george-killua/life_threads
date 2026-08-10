import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/data/memory_seed_data.dart';

class OnboardingDemoWallPreview extends StatelessWidget {
  const OnboardingDemoWallPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final demoEvents = MemorySeedData.localizedEvents(context.l10n);

    return Container(
      height: 270,
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
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _PreviewGridPainter())),
            Positioned.fill(
              child: CustomPaint(painter: _PreviewThreadPainter(demoEvents)),
            ),
            for (final event in demoEvents)
              _PreviewMemoryCard(
                title: event.title,
                color: event.coverColor,
                imagePath: event.coverPhotoPath,
                position: Offset(
                  event.wallPosition.dx * 0.34 + 18,
                  event.wallPosition.dy * 0.18 + 18,
                ),
                rotation: event.rotation,
              ),
            Positioned(
              left: 18,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
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
  });

  final String title;
  final Color color;
  final String? imagePath;
  final Offset position;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Transform.rotate(
        angle: rotation,
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
                style: const TextStyle(
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
  const _PreviewThreadPainter(this.events);

  final List<dynamic> events;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.rope.withValues(alpha: 0.42)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final points = [
      for (final event in events)
        Offset(
          event.wallPosition.dx * 0.34 + 70,
          event.wallPosition.dy * 0.18 + 48,
        ),
    ];
    for (var index = 0; index < points.length - 1; index++) {
      final start = points[index];
      final end = points[index + 1];
      final control = Offset(
        (start.dx + end.dx) / 2,
        (start.dy + end.dy) / 2 + 38,
      );
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
