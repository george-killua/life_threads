import 'package:flutter/widgets.dart';

/// Pans the wall via [TransformationController] on empty canvas hits only.
/// Nodes sit above this in the stack, so their drags never compete with pan.
class WallPanSurface extends StatefulWidget {
  const WallPanSurface({
    super.key,
    required this.controller,
    required this.enabled,
  });

  final TransformationController controller;
  final bool enabled;

  @override
  State<WallPanSurface> createState() => _WallPanSurfaceState();
}

class _WallPanSurfaceState extends State<WallPanSurface> {
  Offset? _lastGlobal;
  int? _pointer;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (!widget.enabled || _pointer != null) return;
        _pointer = event.pointer;
        _lastGlobal = event.position;
      },
      onPointerMove: (event) {
        if (!widget.enabled || event.pointer != _pointer) return;
        final last = _lastGlobal;
        if (last == null) return;
        final delta = event.position - last;
        _lastGlobal = event.position;
        if (delta == Offset.zero) return;
        // Pre-multiply so the translation is in screen pixels and the wall
        // moves 1:1 with the finger at any zoom.
        final next = Matrix4.translationValues(delta.dx, delta.dy, 0)
          ..multiply(widget.controller.value);
        widget.controller.value = _keepBoardOnScreen(next);
      },
      onPointerUp: (event) => _release(event.pointer),
      onPointerCancel: (event) => _release(event.pointer),
      child: const SizedBox.expand(),
    );
  }

  /// This surface spans the whole board and only catches drags where the
  /// board is: once a swipe moved the board off screen there'd be nothing
  /// left to drag back. So the board always covers the screen.
  Matrix4 _keepBoardOnScreen(Matrix4 matrix) {
    final board = context.size;
    if (board == null) return matrix;
    final view = View.of(context);
    final screen =
        MediaQuery.maybeSizeOf(context) ??
        view.physicalSize / view.devicePixelRatio;
    final scale = matrix.entry(0, 0);
    double clamp(double value, double screenExtent, double boardExtent) {
      final lowest = screenExtent - boardExtent * scale;
      return lowest >= 0 ? value : value.clamp(lowest, 0.0);
    }

    final translation = matrix.getTranslation();
    return matrix.clone()..setTranslationRaw(
      clamp(translation.x, screen.width, board.width),
      clamp(translation.y, screen.height, board.height),
      translation.z,
    );
  }

  void _release(int pointer) {
    if (pointer != _pointer) return;
    _pointer = null;
    _lastGlobal = null;
  }
}
