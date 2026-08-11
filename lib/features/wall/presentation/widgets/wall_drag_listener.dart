import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Drag handle for wall nodes (memories, nails, notes).
///
/// Uses a [Listener] with **global** pointer deltas so the node still tracks
/// the finger if [InteractiveViewer] briefly pans before pan-lock rebuilds.
/// Local deltas cancel out in that case and make cards feel immovable.
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
  Offset? _lastGlobalPosition;
  var _pendingGlobalDelta = Offset.zero;

  static final double _dragSlop = kTouchSlop;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        _pointerDown = true;
        _dragging = false;
        _pendingGlobalDelta = Offset.zero;
        _lastGlobalPosition = event.position;
        widget.onPointerDown?.call();
      },
      onPointerMove: (event) {
        if (!_pointerDown) return;
        final last = _lastGlobalPosition;
        if (last == null) return;

        final globalDelta = event.position - last;
        _lastGlobalPosition = event.position;
        if (globalDelta == Offset.zero) return;

        if (!_dragging) {
          _pendingGlobalDelta += globalDelta;
          if (_pendingGlobalDelta.distance < _dragSlop) return;
          _dragging = true;
          widget.onDraggingChanged?.call(true);
          widget.onDragStart();
          widget.onDragUpdate(_pendingGlobalDelta);
          _pendingGlobalDelta = Offset.zero;
          return;
        }

        widget.onDragUpdate(globalDelta);
      },
      onPointerUp: (_) => _finishDrag(),
      onPointerCancel: (_) => _finishDrag(),
      child: widget.child,
    );
  }

  void _finishDrag() {
    if (!_pointerDown) return;
    _pointerDown = false;
    _lastGlobalPosition = null;
    _pendingGlobalDelta = Offset.zero;

    if (_dragging) {
      _dragging = false;
      widget.onDraggingChanged?.call(false);
      widget.onDragEnd();
      return;
    }

    widget.onPointerUp?.call();
  }
}
