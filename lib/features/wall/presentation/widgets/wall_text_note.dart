import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../domain/wall_item.dart';
import 'wall_drag_listener.dart';

class WallTextNoteWidget extends StatefulWidget {
  const WallTextNoteWidget({
    super.key,
    required this.item,
    required this.windValue,
    required this.isDragging,
    required this.onLongPress,
    required this.onEdit,
    required this.onPointerDown,
    required this.onPointerUp,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final WallItem item;
  final double windValue;
  final bool isDragging;
  final VoidCallback onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onPointerDown;
  final VoidCallback onPointerUp;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  State<WallTextNoteWidget> createState() => _WallTextNoteWidgetState();
}

class _WallTextNoteWidgetState extends State<WallTextNoteWidget> {
  var _suppressTap = false;

  @override
  Widget build(BuildContext context) {
    final phase =
        widget.windValue * math.pi * 2 + widget.item.wallPosition.dx / 80;
    final sway = widget.isDragging ? 0.0 : math.sin(phase) * 0.028;
    final bob = widget.isDragging ? -5.0 : math.cos(phase * 0.6) * 1.8;

    return Positioned(
      left: widget.item.wallPosition.dx,
      top: widget.item.wallPosition.dy,
      child: AnimatedScale(
        scale: widget.isDragging ? 1.045 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Transform.translate(
          offset: Offset(0, bob),
          child: Transform.rotate(
            angle: sway,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 198,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  WallDragListener(
                    onDragStart: widget.onDragStart,
                    onDragUpdate: widget.onDragUpdate,
                    onDragEnd: widget.onDragEnd,
                    onPointerDown: () {
                      _suppressTap = false;
                      widget.onPointerDown();
                    },
                    onPointerUp: widget.onPointerUp,
                    onDraggingChanged: (dragging) {
                      if (dragging) _suppressTap = true;
                    },
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onLongPress: () {
                        if (_suppressTap) return;
                        widget.onLongPress();
                      },
                      onTap: () {
                        if (_suppressTap) return;
                        widget.onLongPress();
                      },
                      child: Container(
                        width: 198,
                        padding: const EdgeInsets.fromLTRB(17, 20, 17, 17),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.item.color.withValues(alpha: 0.98),
                              widget.item.color,
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
                                alpha: widget.isDragging ? 0.52 : 0.38,
                              ),
                              blurRadius: widget.isDragging ? 38 : 27,
                              offset: Offset(0, widget.isDragging ? 22 : 15),
                            ),
                            BoxShadow(
                              color: widget.item.color.withValues(alpha: 0.18),
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
                                widget.item.content,
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
                                    color: AppColors.card.withValues(
                                      alpha: 0.76,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.34,
                                      ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -9,
                    bottom: -9,
                    child: _NoteActionButton(
                      icon: Icons.edit_rounded,
                      onTap: widget.onEdit,
                      tooltip: context.l10n.editText,
                    ),
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
