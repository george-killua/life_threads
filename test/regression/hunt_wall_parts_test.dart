// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// wall pan, notes and layouts.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/wall/data/current_wall.dart';
import 'package:life_threads/features/wall/domain/wall_item.dart';
import 'package:life_threads/features/wall/domain/wall_layout.dart';
import 'package:life_threads/features/wall/presentation/widgets/wall_pan_surface.dart';
import 'package:life_threads/features/wall/presentation/widgets/wall_text_note.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'wall_drag_test.dart' show ev;

void main() {
  // P5-06 / W2-01: same structure as memory_wall_page.dart:322-360.
  testWidgets('W2-01 manual pan stays inside the InteractiveViewer bounds', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final controller = TransformationController();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: InteractiveViewer(
          transformationController: controller,
          constrained: false,
          clipBehavior: Clip.none,
          panEnabled: false,
          boundaryMargin: const EdgeInsets.all(4000),
          child: SizedBox(
            width: 80000,
            height: 80000,
            child: Stack(
              children: [
                Positioned.fill(
                  child: WallPanSurface(controller: controller, enabled: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // One long swipe to the right/down, in 100px steps.
    final g = await tester.startGesture(const Offset(200, 400));
    for (var i = 0; i < 60; i++) {
      await g.moveBy(const Offset(100, 100));
    }
    await g.up();
    final t = controller.value.getTranslation();
    expect(
      t.x,
      lessThanOrEqualTo(4000),
      reason: 'board origin pushed to x=${t.x} (boundaryMargin is 4000)',
    );
    expect(
      t.y,
      lessThanOrEqualTo(4000),
      reason: 'board origin pushed to y=${t.y} (boundaryMargin is 4000)',
    );
  });

  // W2-02: select() right after the first read loses to the async _load.
  test('W2-02 select() before the saved id loads is not overwritten', () async {
    SharedPreferences.setMockInitialValues({'current_wall_id': 'old'});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(currentWallProvider), isNull); // build() -> _load
    await container.read(currentWallProvider.notifier).select('new');
    await Future<void>.delayed(Duration.zero);
    expect(container.read(currentWallProvider), 'new');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('current_wall_id'), 'new');
  });

  // P6-04 / W2-03: outer strip of the edit button is outside the Stack.
  testWidgets('W2-03 tapping the outer part of the note edit button edits', (
    tester,
  ) async {
    var edits = 0;
    final item = WallItem(
      id: 'n',
      type: WallItemType.text,
      content: 'Hello',
      createdAt: DateTime(2024),
      wallPosition: const Offset(50, 50),
      color: Colors.amber,
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Stack(
          children: [
            WallTextNoteWidget(
              item: item,
              windValue: 0,
              isDragging: false,
              onLongPress: () {},
              onEdit: () => edits++,
              onPointerDown: () {},
              onPointerUp: () {},
              onDragStart: () {},
              onDragUpdate: (_) {},
              onDragEnd: () {},
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    final c = tester.getCenter(find.byIcon(Icons.edit_rounded));
    await tester.tapAt(c); // centre: works
    expect(edits, 1);
    await tester.tapAt(c + const Offset(10, 10)); // inside the 30px circle
    await tester.pump(const Duration(milliseconds: 500));
    expect(edits, 2, reason: 'tap 10px right/below centre of the 30px button');
  });

  // W2-04: computed layouts grow without bound; the board is 80000 tall.
  test('W2-04 timeline layout keeps 600 memories on the 80000px board', () {
    final events = [
      for (var i = 0; i < 600; i++)
        ev('m$i', Offset.zero, DateTime(2000).add(Duration(days: i))),
    ];
    final laid = WallLayoutEngine.apply(
      events: events,
      mode: WallLayoutMode.timeline,
    );
    final maxY = laid
        .map((e) => e.wallPosition.dy)
        .reduce((a, b) => a > b ? a : b);
    final off = laid.where((e) => e.wallPosition.dy + 260 > 80000).length;
    expect(off, 0, reason: '$off cards below the board (max y $maxY)');
  });
}
