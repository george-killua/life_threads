// The wall's top bar: View sheet, ⋯ menu and the first-run hint, on a
// small phone in German and Arabic.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'regression/wall_drag_test.dart' show FakeRepo, card, step;

Future<void> pumpPhoneWall(WidgetTester tester, Locale locale) async {
  SharedPreferences.setMockInitialValues({});
  // iPhone SE width.
  tester.view.physicalSize = const Size(375, 667);
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

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

void main() {
  testWidgets('German: the View sheet names Timeline once and marks a '
      'custom arrangement', (tester) async {
    await pumpPhoneWall(tester, const Locale('de'));
    expect(find.text('LifeThreads'), findsOneWidget);
    expect(find.byKey(const ValueKey('wall-view-custom-dot')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('wall-view-button')));
    await settle(tester);
    expect(find.text('Zeitleiste'), findsOneWidget);
    expect(find.text('Nach Datum'), findsOneWidget);
    expect(find.text('Alle'), findsOneWidget);

    await tester.tap(find.text('Kategorie'));
    await settle(tester);
    // Close the sheet (as the system back gesture does).
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(find.text('Nach Datum'), findsNothing);
    expect(find.byKey(const ValueKey('wall-view-custom-dot')), findsOneWidget);
  });

  testWidgets('Arabic: the ⋯ menu holds story, display, help and settings', (
    tester,
  ) async {
    await pumpPhoneWall(tester, const Locale('ar'));
    await tester.tap(find.byKey(const ValueKey('wall-more-button')));
    await settle(tester);
    expect(find.byIcon(Icons.auto_stories_rounded), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    expect(find.byIcon(Icons.help_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
  });

  testWidgets('the tap-and-drag hint goes away after the first drag', (
    tester,
  ) async {
    await pumpPhoneWall(tester, const Locale('en'));
    final hint = find.text('Tap to open • drag to move');
    expect(hint, findsOneWidget);

    final g = await tester.startGesture(tester.getCenter(card('A')));
    await step(g, const Offset(30, 0), tester);
    await g.up();
    await settle(tester);
    expect(hint, findsNothing);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('wall_hint_seen'), isTrue);
  });
}
