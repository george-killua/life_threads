import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/wall/presentation/widgets/wall_drag_listener.dart';

void main() {
  late List<Offset> updates;
  late int ends;

  Future<void> pumpListener(WidgetTester tester) async {
    updates = [];
    ends = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: WallDragListener(
            onDragStart: () {},
            onDragUpdate: updates.add,
            onDragEnd: () => ends++,
            child: const SizedBox(width: 400, height: 400),
          ),
        ),
      ),
    );
  }

  testWidgets('second finger does not make the dragged node jump', (
    tester,
  ) async {
    await pumpListener(tester);
    final a = await tester.startGesture(const Offset(100, 100), pointer: 1);
    await a.moveBy(const Offset(30, 0)); // drag starts (> slop)
    final b = await tester.startGesture(const Offset(300, 300), pointer: 2);
    updates.clear();
    await a.moveBy(const Offset(5, 0)); // finger A moves 5px right
    final total = updates.fold(Offset.zero, (s, d) => s + d);
    expect(
      total.distance,
      lessThan(10),
      reason: 'finger A moved 5px but node moved by $total',
    );
    await b.up();
    await a.up();
  });

  testWidgets('lifting the second finger does not end the first drag', (
    tester,
  ) async {
    await pumpListener(tester);
    final a = await tester.startGesture(const Offset(100, 100), pointer: 1);
    await a.moveBy(const Offset(30, 0));
    final b = await tester.startGesture(const Offset(300, 300), pointer: 2);
    await b.up();
    expect(ends, 0, reason: 'drag ended while finger A still down');
    updates.clear();
    await a.moveBy(const Offset(20, 0));
    expect(updates, isNotEmpty, reason: 'finger A movement ignored');
    await a.up();
  });

  testWidgets('a drag interrupted by a second finger still reports onDragEnd', (
    tester,
  ) async {
    await pumpListener(tester);
    final a = await tester.startGesture(const Offset(100, 100), pointer: 1);
    await a.moveBy(const Offset(30, 0)); // drag started
    final b = await tester.startGesture(const Offset(300, 300), pointer: 2);
    await b.up();
    await a.up();
    expect(ends, 1, reason: 'started drag never ended (no commit/unlock)');
  });
}
