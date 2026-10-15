// The wall's bottom row on a small phone: the Add button shows only its icon
// so the memory card beside it keeps a readable width.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'regression/wall_drag_test.dart' show FakeRepo;

const addButton = ValueKey('wall-add-button');

Future<void> pumpWall(WidgetTester tester, Locale locale, Size size) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [memoryRepositoryProvider.overrideWith(FakeRepo.new)],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MemoryWallPage(),
      ),
    ),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// The space the memory card gets: from the row's start edge to the camera
/// button, less the 12 pt gap.
double cardWidth(WidgetTester tester, {required bool rtl}) {
  final screen = tester.view.physicalSize.width;
  final camera = tester.getRect(
    find.ancestor(
      of: find.byIcon(Icons.photo_camera_rounded),
      matching: find.byType(FloatingActionButton),
    ),
  );
  return rtl ? screen - 20 - 12 - camera.right : camera.left - 12 - 20;
}

void main() {
  testWidgets(
    'German at 375 pt: Add is icon-only and the card stays readable',
    (tester) async {
      await pumpWall(tester, const Locale('de'), const Size(375, 667));
      final l10n = lookupAppLocalizations(const Locale('de'));

      expect(find.text(l10n.add), findsNothing);
      expect(find.byTooltip(l10n.add), findsOneWidget);
      expect(tester.getSize(find.byKey(addButton)).width, 56);
      expect(cardWidth(tester, rtl: false), greaterThanOrEqualTo(180));
      expect(find.text(l10n.rememberThis), findsOneWidget);

      // The open menu floats above the row instead of squeezing the card.
      await tester.tap(find.byKey(addButton));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(l10n.expandableMemory), findsOneWidget);
      expect(find.byTooltip(l10n.close), findsOneWidget);
      expect(cardWidth(tester, rtl: false), greaterThanOrEqualTo(180));
      final menu = tester.getRect(
        find.ancestor(
          of: find.text(l10n.expandableNail),
          matching: find.byType(InkWell),
        ),
      );
      final add = tester.getRect(find.byKey(addButton));
      expect(menu.right, add.right);
      expect(menu.bottom, lessThan(add.top));
      expect(menu.left, greaterThanOrEqualTo(20));
      expect(menu.height, lessThan(100));

      await tester.tap(find.byKey(addButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(l10n.expandableMemory), findsNothing);
    },
  );

  testWidgets('Arabic at 375 pt: icon-only Add sits at the left edge', (
    tester,
  ) async {
    await pumpWall(tester, const Locale('ar'), const Size(375, 667));
    final l10n = lookupAppLocalizations(const Locale('ar'));

    expect(find.text(l10n.add), findsNothing);
    expect(find.byTooltip(l10n.add), findsOneWidget);
    expect(tester.getRect(find.byKey(addButton)).left, 20);
    expect(cardWidth(tester, rtl: true), greaterThanOrEqualTo(180));

    await tester.tap(find.byKey(addButton));
    await tester.pump(const Duration(milliseconds: 300));
    final menu = tester.getRect(
      find.ancestor(
        of: find.text(l10n.expandableNail),
        matching: find.byType(InkWell),
      ),
    );
    expect(menu.left, 20);
    expect(menu.right, lessThanOrEqualTo(355));
    expect(cardWidth(tester, rtl: true), greaterThanOrEqualTo(180));
  });

  testWidgets('wider screens keep the labelled Add button', (tester) async {
    await pumpWall(tester, const Locale('en'), const Size(800, 1000));
    expect(
      find.descendant(of: find.byKey(addButton), matching: find.text('Add')),
      findsOneWidget,
    );
  });
}
