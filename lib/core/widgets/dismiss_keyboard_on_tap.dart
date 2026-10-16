import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Closes the keyboard when the user taps anywhere outside the text field
/// they are typing in, as people expect on iOS (multi-line fields have no
/// Done key). Scrolling leaves it open.
///
/// Works through the text fields' own "tap outside" intents, so it also
/// counts taps on buttons and cards, and taps on the copy/paste menu stay
/// inside the field.
class DismissKeyboardOnTap extends StatefulWidget {
  const DismissKeyboardOnTap({super.key, required this.child});

  final Widget child;

  @override
  State<DismissKeyboardOnTap> createState() => _DismissKeyboardOnTapState();
}

class _DismissKeyboardOnTapState extends State<DismissKeyboardOnTap> {
  Offset? _downAt;

  late final _actions = <Type, Action<Intent>>{
    EditableTextTapOutsideIntent: CallbackAction<EditableTextTapOutsideIntent>(
      onInvoke: (intent) {
        _downAt = intent.pointerDownEvent.position;
        return null;
      },
    ),
    EditableTextTapUpOutsideIntent:
        CallbackAction<EditableTextTapUpOutsideIntent>(
          onInvoke: (intent) {
            final downAt = _downAt;
            _downAt = null;
            final moved = downAt == null
                ? double.infinity
                : (intent.pointerUpEvent.position - downAt).distance;
            if (moved <= kTouchSlop) intent.focusNode.unfocus();
            return null;
          },
        ),
  };

  @override
  Widget build(BuildContext context) =>
      Actions(actions: _actions, child: widget.child);
}
