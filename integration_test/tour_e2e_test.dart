// The guided "Show me how" tour on a simulator, done like a user: from the
// onboarding's last page, tapping every ringed button and Next on the
// information steps, then the question whether to remove the demo memories.
// Run with: flutter test integration_test/tour_e2e_test.dart -d <simulator>
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:life_threads/app/app.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/tour/app_tour.dart';
import 'package:life_threads/features/tour/coach.dart';

import 'support/harness.dart';

Finder _target(String id) =>
    find.byWidgetPredicate((w) => w is CoachTarget && w.id == id);

MemoryState _memories(WidgetTester tester) => ProviderScope.containerOf(
  tester.element(find.byType(LifeThreadsApp)),
).read(memoryRepositoryProvider).requireValue;

/// Waits until step [index] shows its bubble (its target is on screen).
Future<void> _waitForStep(WidgetTester tester, int index) async {
  final coach = Coach.instance;
  final end = DateTime.now().add(const Duration(seconds: 20));
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (coach.index == index &&
        find.byKey(const ValueKey('tour-skip')).evaluate().isNotEmpty) {
      await settle(tester, 500);
      return;
    }
  }
  fail(
    'Tour step ${index + 1} (${coach.step?.title}) did not show.\n'
    'On screen: ${visibleTexts(tester).take(40).join(' | ')}',
  );
}

/// Does step [index] like a user: taps its target or Next.
Future<void> _doStep(WidgetTester tester, int index) async {
  await _waitForStep(tester, index);
  final step = Coach.instance.step!;
  if (step.tapToContinue) {
    await tester.tap(_target(step.target!).hitTestable().first);
  } else {
    await tester.tap(find.byKey(const ValueKey('tour-next')));
  }
  await settle(tester, 1200);
}

Future<void> _startTourFromOnboarding(WidgetTester tester) async {
  await resetAppData();
  await launchApp(tester);
  await waitFor(tester, find.text('Build your living wall.'));
  await tapText(tester, 'Next');
  await tapText(tester, 'Next');
  await enterInto(tester, find.byType(TextField), 'Lina');
  await tapText(tester, 'Next');
  await tapOn(
    tester,
    find.byKey(const ValueKey('onboarding-show-me-how')),
    settleMillis: 2500,
  );
  expect(appTourRunning, isTrue);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDown(Coach.instance.stop);

  testWidgets('the whole tour, then remove the demo memories', (tester) async {
    await _startTourFromOnboarding(tester);
    final length = Coach.instance.length;
    final titles = <String>[];
    for (var i = 0; i < length; i++) {
      titles.add(Coach.instance.step!.title);
      await _doStep(tester, i);
    }
    expect(appTourRunning, isFalse);
    expect(titles.first, 'Welcome to your wall');
    expect(titles.last, "That's it!");

    // The memory saved on the tour has the demo picture: it is remembered.
    final tourIds = await TourMemories.all();
    expect(tourIds, hasLength(1));
    expect(
      _memories(tester).events.where((e) => MemorySeedData.isDemoEventId(e.id)),
      hasLength(MemorySeedData.eventIds.length),
    );

    await waitFor(tester, find.text('Start your own wall?'));
    await tapOn(tester, find.byKey(const ValueKey('tour-remove-demo')));
    await waitFor(
      tester,
      find.text('Demo memories removed. Your wall is ready.'),
    );
    expect(_memories(tester).events, isEmpty);
    expect(await TourMemories.all(), isEmpty);
  });

  testWidgets('skipping also asks; keeping leaves the demo memories', (
    tester,
  ) async {
    // Onboarding runs once per app start; this time from ⋯ › Tutorial.
    await launchApp(tester);
    await tapOn(tester, find.byTooltip('More'));
    await tapText(tester, 'Tutorial');
    await tapOn(
      tester,
      find.byKey(const ValueKey('tutorial-show-me-how')),
      settleMillis: 2500,
    );
    expect(appTourRunning, isTrue);
    for (var i = 0; i < 3; i++) {
      await _doStep(tester, i);
    }
    await _waitForStep(tester, 3);
    await tester.tap(find.byKey(const ValueKey('tour-skip')));
    await settle(tester, 1200);
    expect(appTourRunning, isFalse);

    await waitFor(tester, find.text('Start your own wall?'));
    await tapOn(tester, find.byKey(const ValueKey('tour-keep-demo')));
    await settle(tester);
    expect(
      _memories(tester).events.where((e) => MemorySeedData.isDemoEventId(e.id)),
      hasLength(MemorySeedData.eventIds.length),
    );
  });
}
