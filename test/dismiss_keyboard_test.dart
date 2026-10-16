import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/core/widgets/dismiss_keyboard_on_tap.dart';

void main() {
  final focus = FocusNode();
  var pressed = 0;

  Future<void> pump(WidgetTester tester) async {
    pressed = 0;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => DismissKeyboardOnTap(child: child!),
        home: Scaffold(
          body: ListView(
            children: [
              TextField(key: const Key('field'), focusNode: focus),
              const SizedBox(height: 200),
              ElevatedButton(
                onPressed: () => pressed++,
                child: const Text('Card'),
              ),
              const SizedBox(height: 1200),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('field')));
    await tester.pump();
    expect(focus.hasFocus, isTrue);
  }

  testWidgets('a tap on empty space closes the keyboard', (tester) async {
    await pump(tester);
    await tester.tapAt(const Offset(200, 150));
    await tester.pump();
    expect(focus.hasFocus, isFalse);
  });

  testWidgets('a tap on a button closes it and still presses', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Card'));
    await tester.pump();
    expect(focus.hasFocus, isFalse);
    expect(pressed, 1);
  });

  testWidgets('scrolling and taps in the field keep it open', (tester) async {
    await pump(tester);
    await tester.drag(find.byType(ListView), const Offset(0, -20));
    await tester.pump();
    expect(focus.hasFocus, isTrue);
    await tester.tap(find.byKey(const Key('field')), warnIfMissed: false);
    await tester.pump();
    expect(focus.hasFocus, isTrue);
  });
}
