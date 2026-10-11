// Wall page drag and pan behaviour, driven with real gestures.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/features/wall/presentation/widgets/memory_card.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

MemoryEvent ev(String id, Offset pos, DateTime at) => MemoryEvent(
  id: id,
  title: 'Card $id',
  description: '',
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: at,
  createdAt: at,
  coverColor: Colors.amber,
  wallPosition: pos,
  rotation: 0,
  locationLabel: '',
);

class FakeRepo extends MemoryRepository {
  Completer<void>? gate;
  final moves = <(String, Offset)>[];

  @override
  Future<MemoryState> build() async => MemoryState(
    events: [
      ev('A', const Offset(0, 0), DateTime(2024, 1, 1)),
      ev('B', const Offset(400, 0), DateTime(2024, 6, 1)),
    ],
    connections: const [],
    photos: const [],
    people: const [],
    wallItems: const [],
  );

  @override
  Future<void> moveMemory(String id, Offset position) async {
    moves.add((id, position));
    final g = gate;
    if (g != null) await g.future;
  }
}

late FakeRepo repo;

Finder card(String id) => find.descendant(
  of: find.byType(MemoryCard),
  matching: find.text('Card $id'),
);

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 30; i++) {
    await t.pump(const Duration(milliseconds: 20));
  }
}

Future<void> pumpWall(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = const Size(800, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  repo = FakeRepo();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [memoryRepositoryProvider.overrideWith(() => repo)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MemoryWallPage(),
      ),
    ),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> step(TestGesture g, Offset d, WidgetTester t, {int n = 4}) async {
  for (var i = 0; i < n; i++) {
    await g.moveBy(d / n.toDouble());
    await t.pump(const Duration(milliseconds: 16));
  }
}

void main() {
  testWidgets('second drag must survive the first drag finishing its save', (
    tester,
  ) async {
    await pumpWall(tester);
    repo.gate = Completer<void>();
    final a = tester.getCenter(card('A'));
    final b = tester.getCenter(card('B'));

    final g1 = await tester.startGesture(a);
    await step(g1, const Offset(60, 0), tester);
    await g1.up(); // _endDrag(A) now awaits moveMemory
    await tester.pump();

    final g2 = await tester.startGesture(b, pointer: 7);
    await step(g2, const Offset(0, 90), tester);
    repo.gate!.complete(); // A's save finishes mid-drag of B
    await tester.pump();
    await step(g2, const Offset(0, 90), tester);
    await g2.up();
    await tester.pump(const Duration(milliseconds: 50));

    expect(
      repo.moves.map((m) => m.$1).toList(),
      contains('B'),
      reason: 'drag of B must be persisted',
    );
  });

  testWidgets('empty-canvas pan must move content 1:1 with the finger', (
    tester,
  ) async {
    await pumpWall(tester);
    final viewer = tester.widget<InteractiveViewer>(
      find.byType(InteractiveViewer),
    );
    final ctl = viewer.transformationController!;
    final before = ctl.value.getTranslation().x;
    final g = await tester.startGesture(const Offset(40, 600));
    await step(g, const Offset(100, 0), tester);
    await g.up();
    await tester.pump();
    final moved = ctl.value.getTranslation().x - before;
    expect(moved, closeTo(100, 0.5));
  });

  testWidgets('a second finger on another card does not hijack the drag', (
    tester,
  ) async {
    await pumpWall(tester);
    final a = tester.getCenter(card('A'));
    final b = tester.getCenter(card('B'));
    final g1 = await tester.startGesture(a, pointer: 1);
    await step(g1, const Offset(60, 0), tester);
    final g2 = await tester.startGesture(b, pointer: 2);
    await step(g2, const Offset(0, 80), tester);
    await step(g1, const Offset(60, 0), tester);
    await g1.up();
    await tester.pump();
    await g2.up();
    await tester.pump(const Duration(milliseconds: 50));
    // One card at a time: A keeps its own move, B is left alone.
    expect(repo.moves.map((m) => m.$1).toList(), ['A']);
    expect(repo.moves.single.$2.dy, closeTo(0, 1));
  });

  testWidgets('dragging in Timeline layout does not rewrite the freeform '
      'position', (tester) async {
    await pumpWall(tester);
    await tester.tap(find.byKey(const ValueKey('collapsed-wall-controls')));
    await settle(tester);
    final timeline = find.text('Timeline');
    await tester.tap(timeline.last);
    await settle(tester);
    await tester.tap(find.byTooltip('Hide controls'));
    await settle(tester);
    final b = tester.getCenter(card('B'));
    final g = await tester.startGesture(b);
    await step(g, const Offset(30, 0), tester);
    await g.up();
    await tester.pump(const Duration(milliseconds: 50));
    expect(repo.moves.where((m) => m.$1 == 'B'), isEmpty);
  });

  testWidgets('dragged card must track the finger at the initial zoom', (
    tester,
  ) async {
    await pumpWall(tester);
    final ctl = tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer))
        .transformationController!;
    final xScale = ctl.value.entry(0, 0);
    final g = await tester.startGesture(tester.getCenter(card('A')));
    await step(g, const Offset(0, 90), tester);
    await g.up();
    await tester.pump(const Duration(milliseconds: 50));
    final moved = repo.moves.single.$2.dy;
    expect(moved * xScale, closeTo(90, 1));
  });
}
