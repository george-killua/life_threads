// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// backup from the banner, hidden memories across walls, and the 2026-10-11
// drag/pan findings.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/domain/personal_wall.dart';
import 'package:life_threads/features/app_lock/app_lock.dart';
import 'package:life_threads/features/backup/data/backup_service.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/wall/data/current_wall.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/features/wall/presentation/widgets/memory_card.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'wall_drag_test.dart' show ev;

class FakeRepo extends MemoryRepository {
  FakeRepo(this.events, {this.walls = const []});
  final List<MemoryEvent> events;
  final List<PersonalWall> walls;
  Completer<void>? gate;
  final moves = <(String, Offset)>[];

  @override
  Future<MemoryState> build() async => MemoryState(
    events: events,
    connections: const [],
    photos: const [],
    people: const [],
    wallItems: const [],
    walls: walls,
  );

  @override
  Future<void> moveMemory(String id, Offset position) async {
    moves.add((id, position));
    final g = gate;
    if (g != null) await g.future;
  }
}

class FakeAuth implements AppLockAuth {
  var prompts = 0;
  @override
  Future<bool> isAvailable() async => true;
  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return true;
  }
}

class CapturingBackup extends BackupService {
  MemoryState? exported;
  @override
  Future<BackupExportResult> exportBackup(
    MemoryState state, {
    String? password,
  }) async {
    exported = state;
    throw StateError('stop here');
  }
}

late FakeRepo repo;
final auth = FakeAuth();
final backup = CapturingBackup();

Future<void> pumpWall(
  WidgetTester tester,
  FakeRepo r, {
  Map<String, Object> prefs = const {'wall_interaction_hint_seen': true},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  tester.view.physicalSize = const Size(800, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  repo = r;
  auth.prompts = 0;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        memoryRepositoryProvider.overrideWith(() => repo),
        appLockAuthProvider.overrideWithValue(auth),
        backupServiceProvider.overrideWithValue(backup),
      ],
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MemoryWallPage(),
      ),
    ),
  );
  await pumps(tester);
}

Future<void> pumps(WidgetTester t, [int n = 10]) async {
  for (var i = 0; i < n; i++) {
    await t.pump(const Duration(milliseconds: 50));
  }
}

FakeRepo twoCards() => FakeRepo([
  ev('A', const Offset(0, 0), DateTime(2024, 1, 1)),
  ev('B', const Offset(400, 0), DateTime(2024, 6, 1)),
]);

Set<String> shownIds(WidgetTester t) => {
  for (final c in t.widgetList<MemoryCard>(find.byType(MemoryCard)))
    if (c.interactive) c.event.id,
};

Finder card(String id) => find.descendant(
  of: find.byType(MemoryCard),
  matching: find.text('Card $id'),
);

Future<void> step(TestGesture g, Offset d, WidgetTester t, {int n = 4}) async {
  for (var i = 0; i < n; i++) {
    await g.moveBy(d / n.toDouble());
    await t.pump(const Duration(milliseconds: 16));
  }
}

void main() {
  testWidgets('W1-01 backup from the wall banner contains every memory', (
    tester,
  ) async {
    await pumpWall(
      tester,
      FakeRepo(
        [
          for (var i = 0; i < 5; i++)
            ev('m$i', Offset(i * 300.0, 0), DateTime(2024, 1, i + 1)),
          ev(
            'hid',
            const Offset(0, 400),
            DateTime(2024, 2, 1),
          ).copyWith(hidden: true),
          ev(
            'trip',
            const Offset(0, 0),
            DateTime(2024, 3, 1),
          ).copyWith(wallId: 'w2'),
        ],
        walls: [
          PersonalWall(id: 'w2', name: 'Trips', createdAt: DateTime(2024)),
        ],
      ),
    );
    await tester.tap(find.text('Back up'));
    await pumps(tester);
    await tester.tap(find.text('Export'));
    await pumps(tester);
    final ids = backup.exported!.events.map((e) => e.id).toSet();
    expect(ids, containsAll(<String>['hid', 'trip']));
  });

  testWidgets('W1-02 Face ID for hidden on one wall does not unlock another', (
    tester,
  ) async {
    await pumpWall(
      tester,
      FakeRepo(
        [
          ev('A', const Offset(0, 0), DateTime(2024, 1, 1)),
          ev(
            'H1',
            const Offset(300, 0),
            DateTime(2024, 1, 2),
          ).copyWith(hidden: true),
          ev(
            'B',
            const Offset(0, 0),
            DateTime(2024, 1, 3),
          ).copyWith(wallId: 'w2'),
          ev(
            'H2',
            const Offset(300, 0),
            DateTime(2024, 1, 4),
          ).copyWith(wallId: 'w2', hidden: true),
        ],
        walls: [
          PersonalWall(id: 'w2', name: 'Diary', createdAt: DateTime(2024)),
        ],
      ),
    );
    await tester.tap(find.text('View'));
    await pumps(tester);
    await tester.tap(find.byKey(const ValueKey('wall-show-hidden')));
    await pumps(tester);
    await tester.tap(find.byKey(const ValueKey('wall-view-done')));
    await pumps(tester, 20);
    expect(shownIds(tester), containsAll(<String>['A', 'H1']));
    expect(auth.prompts, 1);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MemoryWallPage)),
    );
    await container.read(currentWallProvider.notifier).select('w2');
    await pumps(tester, 20);
    expect(shownIds(tester), contains('B'));
    expect(
      shownIds(tester),
      isNot(contains('H2')),
      reason: 'hidden memory of another wall shown without Face ID',
    );
  });

  testWidgets('P5-01 second drag survives the first drag finishing its save', (
    tester,
  ) async {
    await pumpWall(tester, twoCards());
    repo.gate = Completer<void>();
    final a = tester.getCenter(card('A'));
    final b = tester.getCenter(card('B'));
    final g1 = await tester.startGesture(a);
    await step(g1, const Offset(60, 0), tester);
    await g1.up();
    await tester.pump();
    final g2 = await tester.startGesture(b, pointer: 7);
    await step(g2, const Offset(0, 90), tester);
    repo.gate!.complete();
    await tester.pump();
    await step(g2, const Offset(0, 90), tester);
    await g2.up();
    await tester.pump(const Duration(milliseconds: 50));
    expect(repo.moves.map((m) => m.$1).toList(), contains('B'));
  });

  testWidgets('P5-02 empty-canvas pan moves content 1:1', (tester) async {
    await pumpWall(tester, twoCards());
    final ctl = tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer))
        .transformationController!;
    final before = ctl.value.getTranslation().x;
    final g = await tester.startGesture(const Offset(40, 600));
    await step(g, const Offset(100, 0), tester);
    await g.up();
    await tester.pump();
    expect(ctl.value.getTranslation().x - before, closeTo(100, 0.5));
  });

  testWidgets('P5-03 a second finger on another card does not hijack', (
    tester,
  ) async {
    await pumpWall(tester, twoCards());
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
    expect(repo.moves.map((m) => m.$1).toList(), ['A']);
    expect(repo.moves.single.$2.dy, closeTo(0, 1));
  });

  testWidgets('P5-04 drag in By-date layout keeps the freeform position', (
    tester,
  ) async {
    await pumpWall(tester, twoCards());
    await tester.tap(find.text('View'));
    await pumps(tester);
    await tester.tap(find.text('By date'));
    await tester.tap(find.byKey(const ValueKey('wall-view-done')));
    await pumps(tester, 20);
    final g = await tester.startGesture(tester.getCenter(card('B')));
    await step(g, const Offset(30, 0), tester);
    await g.up();
    await tester.pump(const Duration(milliseconds: 50));
    expect(repo.moves.where((m) => m.$1 == 'B'), isEmpty);
    // The nudge is still shown in By date.
    final shown = tester
        .widgetList<MemoryCard>(find.byType(MemoryCard))
        .firstWhere((c) => c.event.id == 'B');
    expect(shown.event.wallPosition, isNotNull);
  });

  testWidgets('P5-05 dragged card tracks the finger at the initial zoom', (
    tester,
  ) async {
    await pumpWall(tester, twoCards());
    final ctl = tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer))
        .transformationController!;
    final xScale = ctl.value.entry(0, 0);
    final g = await tester.startGesture(tester.getCenter(card('A')));
    await step(g, const Offset(0, 90), tester);
    await g.up();
    await tester.pump(const Duration(milliseconds: 50));
    expect(repo.moves.single.$2.dy * xScale, closeTo(90, 1));
  });
}
