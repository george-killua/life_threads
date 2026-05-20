import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/wall_item.dart';

class WallTextNoteWidget extends StatelessWidget {
  const WallTextNoteWidget({
    super.key,
    required this.item,
    required this.windValue,
    required this.isDragging,
    required this.isAttached,
    required this.onLongPress,
    required this.onEdit,
    required this.onAttach,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final WallItem item;
  final double windValue;
  final bool isDragging;
  final bool isAttached;
  final VoidCallback onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onAttach;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final phase = windValue * math.pi * 2 + item.wallPosition.dx / 80;
    final sway = isDragging ? 0.0 : math.sin(phase) * 0.028;
    final bob = isDragging ? -5.0 : math.cos(phase * 0.6) * 1.8;

    return Positioned(
      left: item.wallPosition.dx,
      top: item.wallPosition.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        dragStartBehavior: DragStartBehavior.down,
        onLongPress: onLongPress,
        onTap: onLongPress,
        onPanStart: (_) => onDragStart(),
        onPanUpdate: (details) => onDragUpdate(details.delta),
        onPanEnd: (_) => onDragEnd(),
        onPanCancel: onDragEnd,
        child: AnimatedScale(
          scale: isDragging ? 1.045 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: Transform.translate(
            offset: Offset(0, bob),
            child: Transform.rotate(
              angle: sway,
              alignment: Alignment.topCenter,
              child: Container(
                width: 198,
                padding: const EdgeInsets.fromLTRB(17, 20, 17, 17),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.color.withValues(alpha: 0.98),
                      item.color,
                      const Color(0xFFD7B875),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDragging ? 0.52 : 0.38,
                      ),
                      blurRadius: isDragging ? 38 : 27,
                      offset: Offset(0, isDragging ? 22 : 15),
                    ),
                    BoxShadow(
                      color: item.color.withValues(alpha: 0.18),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      foregroundPainter: _NoteLinesPainter(),
                      child: Text(
                        item.content,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.paperInk,
                          fontSize: 15,
                          height: 1.35,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -34,
                      left: 63,
                      child: Transform.rotate(
                        angle: 0.06,
                        child: Container(
                          width: 50,
                          height: 19,
                          decoration: BoxDecoration(
                            color: AppColors.card.withValues(alpha: 0.76),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.34),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -47,
                      left: 82,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    if (isAttached)
                      Positioned(
                        top: -8,
                        right: -8,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.wallInk.withValues(alpha: 0.82),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.72),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.28),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.link_rounded,
                            color: AppColors.amber,
                            size: 17,
                          ),
                        ),
                      ),
                    Positioned(
                      right: -9,
                      bottom: -9,
                      child: Row(
                        children: [
                          _NoteActionButton(
                            icon: Icons.edit_rounded,
                            onTap: onEdit,
                            tooltip: 'Edit text',
                          ),
                          const SizedBox(width: 7),
                          _NoteActionButton(
                            icon: isAttached
                                ? Icons.link_off_rounded
                                : Icons.link_rounded,
                            onTap: onAttach,
                            tooltip: isAttached
                                ? 'Change attachment'
                                : 'Attach to memory',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteActionButton extends StatelessWidget {
  const _NoteActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.wallInk.withValues(alpha: 0.82),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, size: 16, color: AppColors.amber),
        ),
      ),
    );
  }
}

class _NoteLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFF8A6A32).withValues(alpha: 0.1)
      ..strokeWidth = 1;
    final edge = Paint()
      ..color = Colors.black.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double y = 22; y < size.height + 12; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      edge,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
