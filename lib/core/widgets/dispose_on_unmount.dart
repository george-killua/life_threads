import 'package:flutter/widgets.dart';

/// Disposes [disposables] when this widget leaves the tree.
///
/// Wrap dialog content with it instead of disposing controllers right after
/// `showDialog` returns: the dialog route keeps building its fields during the
/// exit animation, after the awaited future has already completed.
class DisposeOnUnmount extends StatefulWidget {
  const DisposeOnUnmount({
    super.key,
    required this.disposables,
    required this.child,
  });

  final List<ChangeNotifier> disposables;
  final Widget child;

  @override
  State<DisposeOnUnmount> createState() => _DisposeOnUnmountState();
}

class _DisposeOnUnmountState extends State<DisposeOnUnmount> {
  @override
  void dispose() {
    for (final disposable in widget.disposables) {
      disposable.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
