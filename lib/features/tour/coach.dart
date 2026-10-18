import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/localization/app_localizations_x.dart';

/// One hint in a tour: what to look at ([target], a [CoachTarget] id) and
/// what it does. With [tapToContinue] the tour moves on when the person taps
/// the target itself; otherwise they tap Next. A step without a target is a
/// message in the middle of the screen. [onEnter] runs when the step comes
/// up, e.g. to open the screen it talks about.
class CoachStep {
  const CoachStep({
    this.target,
    required this.title,
    required this.body,
    this.tapToContinue = false,
    this.onEnter,
  });

  final String? target;
  final String title;
  final String body;
  final bool tapToContinue;
  final VoidCallback? onEnter;
}

/// The running tour: which step is showing and where its targets are on
/// screen. (The same hint system as the Mezzo app.)
class Coach extends ChangeNotifier {
  Coach._();

  static final instance = Coach._();

  String? _tour;
  List<CoachStep> _steps = const [];
  int _index = 0;
  VoidCallback? _onDone;
  VoidCallback? _onEnd;
  final Map<String, GlobalKey> _targets = {};

  /// The tour's name, or null when none is running.
  String? get tour => _tour;
  bool get active => _tour != null;
  CoachStep? get step =>
      active && _index < _steps.length ? _steps[_index] : null;
  int get index => _index;
  int get length => _steps.length;

  /// [onDone] runs when the tour reaches its end; [onEnd] whenever it ends,
  /// also when skipped.
  void start(
    String tour,
    List<CoachStep> steps, {
    VoidCallback? onDone,
    VoidCallback? onEnd,
  }) {
    _tour = tour;
    _steps = steps;
    _index = 0;
    _onDone = onDone;
    _onEnd = onEnd;
    notifyListeners();
    step?.onEnter?.call();
  }

  void next() {
    if (!active) return;
    if (_index >= _steps.length - 1) return finish();
    _index++;
    notifyListeners();
    step?.onEnter?.call();
  }

  /// Ends the tour; [onDone] runs only when it ran to the end.
  void finish() {
    final done = _onDone;
    stop();
    done?.call();
  }

  void stop() {
    if (!active) return;
    final end = _onEnd;
    _tour = null;
    _steps = const [];
    _index = 0;
    _onDone = null;
    _onEnd = null;
    notifyListeners();
    end?.call();
  }

  /// Called by a [CoachTarget] when it's tapped.
  void tapped(String id) {
    final current = step;
    if (current != null && current.tapToContinue && current.target == id) {
      final at = _index;
      // After the tap's own action has run (a page opens, a sheet closes).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_index == at) next();
      });
    }
  }

  BuildContext? contextOf(String id) => _targets[id]?.currentContext;
}

/// Marks a widget a tour can point at.
class CoachTarget extends StatefulWidget {
  const CoachTarget({super.key, required this.id, required this.child});

  final String id;
  final Widget child;

  @override
  State<CoachTarget> createState() => _CoachTargetState();
}

class _CoachTargetState extends State<CoachTarget> {
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    Coach.instance._targets[widget.id] = _key;
  }

  @override
  void didUpdateWidget(CoachTarget old) {
    super.didUpdateWidget(old);
    if (old.id != widget.id) {
      if (Coach.instance._targets[old.id] == _key) {
        Coach.instance._targets.remove(old.id);
      }
      Coach.instance._targets[widget.id] = _key;
    }
  }

  @override
  void dispose() {
    if (Coach.instance._targets[widget.id] == _key) {
      Coach.instance._targets.remove(widget.id);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A screen that comes back to the front claims the id again.
    Coach.instance._targets[widget.id] = _key;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerUp: (_) => Coach.instance.tapped(widget.id),
      child: KeyedSubtree(key: _key, child: widget.child),
    );
  }
}

/// Draws the current hint above the whole app: the screen dimmed except for
/// the target, and a bubble saying what it does. Taps outside the target are
/// blocked.
class CoachLayer extends StatefulWidget {
  const CoachLayer({super.key, required this.child});

  final Widget child;

  @override
  State<CoachLayer> createState() => _CoachLayerState();
}

class _CoachLayerState extends State<CoachLayer> {
  final coach = Coach.instance;
  Rect? _hole;
  int _shownIndex = -1;
  bool _tracking = false;

  @override
  void initState() {
    super.initState();
    coach.addListener(_changed);
  }

  @override
  void dispose() {
    coach.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    if (!mounted) return;
    setState(() {});
    if (!_tracking) _track();
  }

  /// Follows the target while a step shows (it may scroll, animate in, or
  /// appear later when its page opens).
  void _track() {
    _tracking = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !coach.active) {
        _tracking = false;
        _shownIndex = -1;
        if (mounted && _hole != null) setState(() => _hole = null);
        return;
      }
      final hole = _targetRect();
      if (coach.index != _shownIndex && hole != null) {
        _shownIndex = coach.index;
        final target = coach.contextOf(coach.step!.target!);
        // Scroll the target into view.
        if (target != null &&
            target.mounted &&
            Scrollable.maybeOf(target) != null) {
          Scrollable.ensureVisible(
            target,
            alignment: 0.4,
            duration: const Duration(milliseconds: 250),
          );
        }
      }
      // Until it has scrolled in, a target off the screen gets no hint yet.
      final screen = Offset.zero & MediaQuery.sizeOf(context);
      final visible = hole != null && screen.overlaps(hole) ? hole : null;
      if (visible != _hole) setState(() => _hole = visible);
      _track();
    });
  }

  Rect? _targetRect() {
    final id = coach.step?.target;
    if (id == null) return null;
    final context = coach.contextOf(id);
    if (context == null || !context.mounted) return null;
    // Only targets on the screen in front: not under a sheet, dialog or a
    // newer page.
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) return null;
    final box = context.findRenderObject();
    final layer = this.context.findRenderObject();
    if (box is! RenderBox ||
        !box.hasSize ||
        !box.attached ||
        layer is! RenderBox) {
      return null;
    }
    final topLeft = box.localToGlobal(Offset.zero, ancestor: layer);
    return (topLeft & box.size).inflate(6);
  }

  @override
  Widget build(BuildContext context) {
    final step = coach.step;
    final waitingForTarget =
        step != null && step.target != null && _hole == null;
    return Stack(
      children: [
        widget.child,
        if (step != null && !waitingForTarget)
          Positioned.fill(
            child: _Hint(step: step, hole: _hole),
          ),
        // While the target's page isn't open yet, a way out stays on screen.
        if (waitingForTarget)
          PositionedDirectional(
            top: MediaQuery.paddingOf(context).top + 6,
            end: 12,
            child: Material(
              color: AppColors.gold,
              shape: const StadiumBorder(),
              child: InkWell(
                key: const ValueKey('tour-end'),
                customBorder: const StadiumBorder(),
                onTap: coach.stop,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text(
                    context.l10n.tourEnd,
                    style: TextStyle(
                      color: AppColors.wallInk,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.step, required this.hole});

  final CoachStep step;
  final Rect? hole;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final coach = Coach.instance;
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final hole = this.hole;
    final below = hole == null || hole.center.dy < size.height * 0.55;
    final ink = AppColors.wallInk;
    void block() {}

    final bubble = Material(
      color: AppColors.gold,
      borderRadius: BorderRadius.circular(22),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 10, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Text(
                step.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Text(
                step.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ink,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${coach.index + 1}/${coach.length}',
                  style: theme.textTheme.labelMedium?.copyWith(color: ink),
                ),
                const SizedBox(width: 8),
                // Long labels (German, Arabic) wrap instead of overflowing.
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TextButton(
                        key: const ValueKey('tour-skip'),
                        style: TextButton.styleFrom(foregroundColor: ink),
                        onPressed: coach.stop,
                        child: Text(l10n.tourSkip),
                      ),
                      if (step.tapToContinue)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 4,
                            end: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                below
                                    ? Icons.north_rounded
                                    : Icons.south_rounded,
                                size: 16,
                                color: ink,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.tourTapIt,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: ink,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        FilledButton(
                          key: const ValueKey('tour-next'),
                          style: FilledButton.styleFrom(
                            backgroundColor: ink,
                            foregroundColor: AppColors.gold,
                          ),
                          onPressed: coach.next,
                          child: Text(
                            coach.index == coach.length - 1
                                ? l10n.tourDone
                                : l10n.tourNext,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // The bubble never runs off a short screen.
    final bubbleBox = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 520, maxHeight: size.height * 0.5),
      child: SingleChildScrollView(child: bubble),
    );

    return Stack(
      children: [
        // The dim layer, with a rounded window over the target.
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _ScrimPainter(hole)),
          ),
        ),
        // Taps outside the window are blocked; inside it they reach the
        // target.
        if (hole == null)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: block,
            ),
          )
        else ...[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: hole.top.clamp(0, size.height),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: block,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: hole.bottom.clamp(0, size.height),
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: block,
            ),
          ),
          Positioned(
            left: 0,
            width: hole.left.clamp(0, size.width),
            top: hole.top,
            height: hole.height,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: block,
            ),
          ),
          Positioned(
            left: hole.right.clamp(0, size.width),
            right: 0,
            top: hole.top,
            height: hole.height,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: block,
            ),
          ),
        ],
        if (hole == null)
          Center(
            child: Padding(padding: const EdgeInsets.all(24), child: bubbleBox),
          )
        else if (below)
          Positioned(
            left: 16,
            right: 16,
            top: (hole.bottom + 12).clamp(
              padding.top,
              (size.height - 220).clamp(padding.top, size.height),
            ),
            child: Center(child: bubbleBox),
          )
        else
          Positioned(
            left: 16,
            right: 16,
            bottom: (size.height - hole.top + 12).clamp(
              padding.bottom,
              (size.height - 220).clamp(padding.bottom, size.height),
            ),
            child: Center(child: bubbleBox),
          ),
      ],
    );
  }
}

class _ScrimPainter extends CustomPainter {
  _ScrimPainter(this.hole);

  final Rect? hole;

  @override
  void paint(Canvas canvas, Size size) {
    final scrim = Path()..addRect(Offset.zero & size);
    final hole = this.hole;
    final path = hole == null
        ? scrim
        : Path.combine(
            PathOperation.difference,
            scrim,
            Path()..addRRect(
              RRect.fromRectAndRadius(hole, const Radius.circular(18)),
            ),
          );
    canvas.drawPath(
      path,
      Paint()..color = Colors.black.withValues(alpha: 0.66),
    );
    if (hole != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(hole, const Radius.circular(18)),
        Paint()
          ..color = AppColors.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(_ScrimPainter old) => old.hole != hole;
}
