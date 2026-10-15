import 'package:flutter/material.dart';

/// One button of [EqualWidthButtons]: what it says, and the button itself.
typedef EqualWidthButton = ({String label, Widget button});

/// Buttons of equal width side by side across the available width; stacked,
/// each full width, when a label would not fit on one line (German, Arabic,
/// large text). Words are never split.
class EqualWidthButtons extends StatelessWidget {
  const EqualWidthButtons({
    super.key,
    required this.buttons,
    this.gap = 10,
    this.labelStyle,
    this.chrome = 70,
  });

  final List<EqualWidthButton> buttons;
  final double gap;

  /// The style the buttons' labels are drawn in, to measure them; by
  /// default the theme's button label (bold).
  final TextStyle? labelStyle;

  /// Width a button needs besides its label: icon, gaps and padding.
  final double chrome;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final style =
        labelStyle ??
        Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w900);
    final direction = Directionality.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final needed = buttons
            .map((b) {
              final painter = TextPainter(
                text: TextSpan(text: b.label, style: style),
                textDirection: direction,
                textScaler: scaler,
                maxLines: 1,
              )..layout();
              return painter.width + scaler.scale(chrome);
            })
            .fold(0.0, (a, b) => a > b ? a : b);
        final each =
            (constraints.maxWidth - gap * (buttons.length - 1)) /
            buttons.length;
        if (needed > each) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < buttons.length; i++) ...[
                if (i > 0) SizedBox(height: gap),
                buttons[i].button,
              ],
            ],
          );
        }
        return Row(
          children: [
            for (var i = 0; i < buttons.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              Expanded(child: buttons[i].button),
            ],
          ],
        );
      },
    );
  }
}
