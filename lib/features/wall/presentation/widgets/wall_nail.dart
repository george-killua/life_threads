import 'package:flutter/material.dart';

import '../../domain/wall_item.dart';
import 'metallic_ball_pin.dart';
import 'wall_drag_listener.dart';

class WallNailWidget extends StatefulWidget {
  const WallNailWidget({
    super.key,
    required this.item,
    required this.isDragging,
    required this.onLongPress,
    required this.onPointerDown,
    required this.onPointerUp,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final WallItem item;
  final bool isDragging;
  final VoidCallback onLongPress;
  final VoidCallback onPointerDown;
  final VoidCallback onPointerUp;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  State<WallNailWidget> createState() => _WallNailWidgetState();
}

class _WallNailWidgetState extends State<WallNailWidget> {
  var _suppressTap = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.item.wallPosition.dx,
      top: widget.item.wallPosition.dy,
      child: WallDragListener(
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
          child: AnimatedScale(
            scale: widget.isDragging ? 1.2 : 1,
            duration: const Duration(milliseconds: 130),
            curve: Curves.easeOutCubic,
            child: SizedBox(
              width: 48,
              height: 58,
              child: Center(
                child: MetallicBallPin(
                  size: 27,
                  showStem: true,
                  elevated: widget.isDragging,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
