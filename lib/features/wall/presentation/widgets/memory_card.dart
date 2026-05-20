import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../memories/domain/memory_event.dart';

class MemoryCard extends StatelessWidget {
  const MemoryCard({
    super.key,
    required this.event,
    required this.windValue,
    required this.isDragging,
    required this.onTap,
    required this.onLongPress,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final MemoryEvent event;
  final double windValue;
  final bool isDragging;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final phase = windValue * math.pi * 2 + event.wallPosition.dx / 86;
    final sway = isDragging ? 0.0 : math.sin(phase) * 0.038;
    final bob = isDragging ? -7.0 : math.sin(phase * 0.7) * 2.4;
    final scale = isDragging ? 1.055 : 1.0;

    return Positioned(
      left: event.wallPosition.dx,
      top: event.wallPosition.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        dragStartBehavior: DragStartBehavior.down,
        onTap: onTap,
        onLongPress: onLongPress,
        onPanStart: (_) => onDragStart(),
        onPanUpdate: (details) => onDragUpdate(details.delta),
        onPanEnd: (_) => onDragEnd(),
        onPanCancel: onDragEnd,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: Transform.translate(
            offset: Offset(0, bob),
            child: Transform.rotate(
              angle: event.rotation + sway,
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  _HangingThread(isDragging: isDragging),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _PhotoPaper(event: event, isDragging: isDragging),
                      _Tape(isDragging: isDragging),
                      _Pin(isDragging: isDragging),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HangingThread extends StatelessWidget {
  const _HangingThread({required this.isDragging});

  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.4,
      height: 34,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.rope.withValues(alpha: 0.45),
            isDragging ? AppColors.amber : AppColors.rope,
            AppColors.rope.withValues(alpha: 0.58),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.34),
            blurRadius: 7,
            offset: const Offset(1, 3),
          ),
        ],
      ),
    );
  }
}

class _PhotoPaper extends StatelessWidget {
  const _PhotoPaper({required this.event, required this.isDragging});

  final MemoryEvent event;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF7E7), AppColors.card, Color(0xFFEBD6AF)],
        ),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: Colors.white.withValues(alpha: 0.54)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDragging ? 0.58 : 0.42),
            blurRadius: isDragging ? 46 : 34,
            spreadRadius: isDragging ? 2 : 0,
            offset: Offset(0, isDragging ? 28 : 20),
          ),
          BoxShadow(
            color: event.coverColor.withValues(alpha: isDragging ? 0.3 : 0.18),
            blurRadius: isDragging ? 34 : 26,
            offset: const Offset(0, 9),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: CustomPaint(
        foregroundPainter: _PaperTexturePainter(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: _CardImage(event: event),
              ),
            ),
            const SizedBox(height: 11),
            Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.paperInk,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: -0.25,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${event.category.label} • ${event.locationLabel}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.paperInk.withValues(alpha: 0.58),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tape extends StatelessWidget {
  const _Tape({required this.isDragging});

  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -13,
      left: 62,
      child: Transform.rotate(
        angle: -0.075,
        child: Container(
          width: 56,
          height: 25,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.card.withValues(alpha: isDragging ? 0.86 : 0.68),
                AppColors.cardDark.withValues(alpha: isDragging ? 0.82 : 0.62),
              ],
            ),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withValues(alpha: 0.34)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.isDragging});

  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -44,
      left: 80,
      child: Container(
        width: 17,
        height: 17,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              isDragging ? AppColors.amber : const Color(0xFFFFD77D),
              const Color(0xFF9C6727),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.58),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.28),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.34),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
    final path = event.coverPhotoPath;
    if (path != null && File(path).existsSync()) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: event.coverColor,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            event.coverColor.withValues(alpha: 0.94),
            event.coverColor.withValues(alpha: 0.72),
            AppColors.wallPlum.withValues(alpha: 0.32),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _PhotoPlaceholderPainter()),
          ),
          Center(
            child: Icon(
              Icons.photo_camera_back_rounded,
              size: 38,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFF7A5A27).withValues(alpha: 0.03)
      ..strokeWidth = 1;
    final edge = Paint()
      ..color = Colors.black.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double y = 8; y < size.height; y += 10.5) {
      canvas.drawLine(Offset(2, y), Offset(size.width - 2, y + 1.6), line);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(14)),
      edge,
    );

    final fold = Path()
      ..moveTo(size.width - 32, size.height)
      ..lineTo(size.width, size.height - 32)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      fold,
      Paint()..color = Colors.black.withValues(alpha: 0.045),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PhotoPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 18) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
