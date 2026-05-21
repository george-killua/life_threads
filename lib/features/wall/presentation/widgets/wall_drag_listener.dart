import 'package:flutter/material.dart';

class WallDragListener extends StatefulWidget {
  const WallDragListener({
    super.key,
    required this.child,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    this.onPointerDown,
    this.onPointerUp,
  });

  final Widget child;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback? onPointerDown;
  final VoidCallback? onPointerUp;

  @override
  State<WallDragListener> createState() => _WallDragListenerState();
}

class _WallDragListenerState extends State<WallDragListener> {
  static const _dragSlop = 4.0;

  var _pointerDown = false;
  var _dragging = false;
  var _pendingDelta = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        _pointerDown = true;
        _dragging = false;
        _pendingDelta = Offset.zero;
        widget.onPointerDown?.call();
      },
      onPointerMove: (event) {
        if (!_pointerDown) return;

        _pendingDelta += event.delta;
        if (!_dragging) {
          if (_pendingDelta.distance < _dragSlop) return;
          _dragging = true;
          widget.onDragStart();
          widget.onDragUpdate(_pendingDelta);
          _pendingDelta = Offset.zero;
          return;
        }

        widget.onDragUpdate(event.delta);
      },
      onPointerUp: (_) => _finishDrag(),
      onPointerCancel: (_) => _finishDrag(),
      child: widget.child,
    );
  }

  void _finishDrag() {
    _pointerDown = false;
    _pendingDelta = Offset.zero;
    widget.onPointerUp?.call();
    if (!_dragging) return;

    _dragging = false;
    widget.onDragEnd();
  }
}
