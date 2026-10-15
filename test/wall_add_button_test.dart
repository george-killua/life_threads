// The wall's bottom row: a round "+" beside the camera, so the memory card
// keeps a readable width, and the "Add to your wall" sheet it opens.
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
  testWidgets('German at 375 pt: a round + and the card stays readable', (
    tester,
  ) async {
    await pumpWall(tester, const Locale('de'), const Size(375, 667));
    final l10n = lookupAppLocalizations(const Locale('de'));

    expect(find.text(l10n.add), findsNothing);
    expect(find.byTooltip(l10n.add), findsOneWidget);
    expect(tester.getSize(find.byKey(addButton)), const Size.square(64));
    expect(cardWidth(tester, rtl: false), greaterThanOrEqualTo(180));
    expect(find.text(l10n.rememberThis), findsOneWidget);

    // The sheet: a title and four full-width rows of the same width.
    await tester.tap(find.byKey(addButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text(l10n.addToWallTitle), findsOneWidget);
    final rows =
        [
          l10n.expandableMemory,
          l10n.expandableQuickPhoto,
          l10n.expandableTextNote,
          l10n.expandableNail,
        ].map(
          (label) => tester.getRect(
            find.ancestor(of: find.text(label), matching: find.byType(InkWell)),
          ),
        );
    for (final row in rows) {
      expect(row.left, 20);
      expect(row.right, 355);
    }

    // Closed by tapping outside it.
    await tester.tapAt(const Offset(20, 20));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text(l10n.addToWallTitle), findsNothing);
  });

  testWidgets('Arabic at 375 pt: the + sits at the left edge', (tester) async {
    await pumpWall(tester, const Locale('ar'), const Size(375, 667));
    final l10n = lookupAppLocalizations(const Locale('ar'));

    expect(find.byTooltip(l10n.add), findsOneWidget);
    expect(tester.getRect(find.byKey(addButton)).left, 20);
    expect(cardWidth(tester, rtl: true), greaterThanOrEqualTo(180));
  });
}
