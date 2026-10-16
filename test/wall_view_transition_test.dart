// The View sheet changes the wall only with Done; then cards move to a new
// arrangement and fade out and in for a new category.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/features/wall/presentation/widgets/memory_card.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'regression/wall_drag_test.dart' show ev;

class _Wall extends MemoryRepository {
  @override
  Future<MemoryState> build() async => MemoryState(
    events: [
      ev(
        'trip',
        const Offset(40, 160),
        DateTime(2024, 1, 1),
      ).copyWith(category: MemoryCategory.travel),
      ev('home', const Offset(240, 420), DateTime(2022, 1, 1)),
    ],
    connections: const [],
    photos: const [],
    people: const [],
    wallItems: const [],
  );
}

Future<void> pumpWall(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({'wall_interaction_hint_seen': true});
  tester.view.physicalSize = const Size(402, 874);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [memoryRepositoryProvider.overrideWith(_Wall.new)],
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MemoryWallPage(),
      ),
    ),
  );
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> openView(WidgetTester tester) async {
  await tester.tap(find.text('View'));
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Iterable<MemoryCard> cards(WidgetTester tester) =>
    tester.widgetList<MemoryCard>(find.byType(MemoryCard));

MemoryCard card(WidgetTester tester, String id) =>
    cards(tester).firstWhere((c) => c.event.id == id && c.interactive);

void main() {
  testWidgets('choices apply only with Done', (tester) async {
    await pumpWall(tester);
    await openView(tester);
    await tester.tap(find.text('Timeline').last);
    await tester.pump();
    // Still the wall behind the sheet.
    expect(find.byType(MemoryCard), findsNWidgets(2));

    // Closed without Done: nothing changes.
    Navigator.of(tester.element(find.text('Show as'))).pop();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byType(MemoryCard), findsNWidgets(2));

    await openView(tester);
    await tester.tap(find.text('Timeline').last);
    await tester.tap(find.byKey(const ValueKey('wall-view-done')));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byType(MemoryCard), findsNothing);
  });

  testWidgets('a new category fades the other cards out', (tester) async {
    await pumpWall(tester);
    await openView(tester);
    await tester.tap(find.text('Travel').last);
    await tester.tap(find.byKey(const ValueKey('wall-view-done')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Halfway: the personal card is fading out and can't be tapped.
    final leaving = cards(tester).where((c) => c.event.id == 'home').single;
    expect(leaving.interactive, isFalse);
    expect(leaving.opacity, inExclusiveRange(0, 1));
    expect(card(tester, 'trip').opacity, 1);

    await tester.pump(const Duration(milliseconds: 500));
    expect(cards(tester).map((c) => c.event.id), ['trip']);
  });

  testWidgets('a new arrangement moves the cards there', (tester) async {
    await pumpWall(tester);
    final start = card(tester, 'trip').event.wallPosition;
    await openView(tester);
    await tester.tap(find.text('By date'));
    await tester.tap(find.byKey(const ValueKey('wall-view-done')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final halfway = card(tester, 'trip').event.wallPosition;
    await tester.pump(const Duration(milliseconds: 500));
    final end = card(tester, 'trip').event.wallPosition;

    expect(end, isNot(start));
    // On its way: between the two, not jumped.
    expect(halfway, isNot(start));
    expect(halfway, isNot(end));
    expect(
      (halfway - start).distance + (end - halfway).distance,
      closeTo((end - start).distance, 1),
    );
  });
}
