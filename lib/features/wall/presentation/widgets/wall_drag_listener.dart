import 'package:flutter/gestures.dart';
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
    this.onDraggingChanged,
  });

  final Widget child;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback? onPointerDown;

  /// Called on pointer up/cancel only when a drag did **not** start.
  /// Drag end unlocks the wall via [onDragEnd] instead.
  final VoidCallback? onPointerUp;
  final ValueChanged<bool>? onDraggingChanged;

  @override
  State<WallDragListener> createState() => _WallDragListenerState();
}

class _WallDragListenerState extends State<WallDragListener> {
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
          if (_pendingDelta.distance < kTouchSlop) return;
          _dragging = true;
          widget.onDraggingChanged?.call(true);
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
    if (!_pointerDown) return;
    _pointerDown = false;
    _pendingDelta = Offset.zero;

    if (_dragging) {
      _dragging = false;
      widget.onDraggingChanged?.call(false);
      widget.onDragEnd();
      return;
    }

    widget.onPointerUp?.call();
  }
}
