// A wall with hundreds of memories builds only the cards near the screen,
// so it stays smooth and light in memory.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/wall/presentation/pages/memory_wall_page.dart';
import 'package:life_threads/features/wall/presentation/widgets/memory_card.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'regression/wall_drag_test.dart' show ev;

class _BigWall extends MemoryRepository {
  @override
  Future<MemoryState> build() async => MemoryState(
    events: [
      for (var i = 0; i < 250; i++)
        ev(
          'm$i',
          Offset((i % 25) * 260.0, (i ~/ 25) * 320.0),
          DateTime(2020 + i % 6, i % 12 + 1, 1 + i % 27),
        ),
    ],
    connections: const [],
    photos: const [],
    people: const [],
    wallItems: const [],
  );
}

void main() {
  testWidgets('250 memories: only the cards near the screen are built', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [memoryRepositoryProvider.overrideWith(_BigWall.new)],
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

    final built = find.byType(MemoryCard).evaluate().length;
    expect(built, greaterThan(0));
    expect(built, lessThan(80), reason: '$built of 250 cards built');
  });
}
