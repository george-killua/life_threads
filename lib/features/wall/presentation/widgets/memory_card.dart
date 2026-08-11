import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/domain/memory_event.dart';
import '../../../memories/presentation/memory_l10n.dart';
import 'metallic_ball_pin.dart';
import 'wall_drag_listener.dart';

class MemoryCard extends StatefulWidget {
  const MemoryCard({
    super.key,
    required this.event,
    required this.windValue,
    required this.isDragging,
    required this.hasConnection,
    required this.onTap,
    required this.onLongPress,
    required this.onEdit,
    required this.onConnect,
    required this.onPointerDown,
    required this.onPointerUp,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final MemoryEvent event;
  final double windValue;
  final bool isDragging;
  final bool hasConnection;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onConnect;
  final VoidCallback onPointerDown;
  final VoidCallback onPointerUp;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  static const Size visualSize = Size(190, 236);
  static const Offset pinHeadOffset = Offset(89.5, 1.5);

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> {
  var _suppressTap = false;

  @override
  Widget build(BuildContext context) {
    final phase =
        widget.windValue * math.pi * 2 + widget.event.wallPosition.dx / 86;
    final sway = widget.isDragging ? 0.0 : math.sin(phase) * 0.038;
    final bob = widget.isDragging ? -7.0 : math.sin(phase * 0.7) * 2.4;
    final scale = widget.isDragging ? 1.055 : 1.0;

    return Positioned(
      left: widget.event.wallPosition.dx,
      top: widget.event.wallPosition.dy,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Transform.translate(
          offset: Offset(0, bob),
          child: Transform.rotate(
            angle: widget.event.rotation + sway,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                if (widget.hasConnection)
                  _HangingThread(isDragging: widget.isDragging)
                else
                  const SizedBox(height: 34),
                SizedBox(
                  width: 190,
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
                          onTap: () {
                            if (_suppressTap) return;
                            widget.onTap();
                          },
                          onLongPress: () {
                            if (_suppressTap) return;
                            widget.onLongPress();
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _PhotoPaper(
                                event: widget.event,
                                isDragging: widget.isDragging,
                              ),
                              _Tape(isDragging: widget.isDragging),
                              if (widget.hasConnection)
                                _Pin(isDragging: widget.isDragging),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Row(
                          children: [
                            _CardActionButton(
                              icon: Icons.edit_rounded,
                              onTap: widget.onEdit,
                              tooltip: context.l10n.editMemoryTooltip,
                            ),
                            const SizedBox(width: 7),
                            _CardActionButton(
                              icon: Icons.hub_rounded,
                              onTap: widget.onConnect,
                              tooltip: context.l10n.connectMemoryTooltip,
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _CardActionButton extends StatelessWidget {
  const _CardActionButton({
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
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.wallInk.withValues(alpha: 0.8),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.52)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, size: 17, color: AppColors.amber),
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
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.rope.withValues(alpha: isDragging ? 0.95 : 0.72),
            AppColors.rope.withValues(alpha: 0.35),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(1, 4),
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
      width: 190,
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
                height: 128,
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
                fontSize: 17,
                letterSpacing: -0.25,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              [
                event.category.localizedLabel(context.l10n),
                if (event.hasGeoPoint) event.locationDisplayLabel,
              ].join(' • '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.paperInk.withValues(alpha: 0.58),
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
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
      child: MetallicBallPin(
        size: 17,
        showStem: false,
        elevated: isDragging,
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
    if (_isAssetPath(path)) {
      return Image.asset(
        path!,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => _buildPlaceholder(),
      );
    }
    if (path != null && File(path).existsSync()) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => _buildPlaceholder(),
      );
    }

    return _buildPlaceholder();
  }

  bool _isAssetPath(String? path) => path != null && path.startsWith('assets/');

  Widget _buildPlaceholder() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: event.coverColor,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            event.coverColor.withValues(alpha: 0.92),
            event.coverColor,
            AppColors.cardDark.withValues(alpha: 0.55),
          ],
        ),
      ),
      child: CustomPaint(painter: _PhotoPlaceholderPainter()),
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8A6A32).withValues(alpha: 0.045)
      ..strokeWidth = 1;
    for (double y = 8; y < size.height; y += 7) {
      canvas.drawLine(Offset(6, y), Offset(size.width - 6, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PhotoPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(12, 12, size.width - 24, size.height - 24),
        const Radius.circular(10),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
