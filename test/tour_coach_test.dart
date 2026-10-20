import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/tour/app_tour.dart';
import 'package:life_threads/features/tour/coach.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

/// The guided tour's hint system, and every step's bubble in English,
/// German and Arabic on the smallest phone (the full tour runs on a
/// simulator: integration_test/tour_e2e_test.dart).
void main() {
  tearDown(Coach.instance.stop);

  Widget app({Locale locale = const Locale('en'), Widget? body}) => MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: (context, child) => CoachLayer(child: child!),
    home: Scaffold(
      body:
          body ??
          Center(
            child: CoachTarget(
              id: 'button',
              child: FilledButton(
                onPressed: () {},
                child: const Text('Button'),
              ),
            ),
          ),
    ),
  );

  testWidgets('the ring fits a target drawn smaller, like a card on the '
      'zoomed-out wall', (tester) async {
    await tester.pumpWidget(
      app(
        body: Center(
          child: Transform.scale(
            scale: 0.5,
            child: const CoachTarget(
              id: 'card',
              child: SizedBox(width: 200, height: 240),
            ),
          ),
        ),
      ),
    );
    Coach.instance.start('test', const [
      CoachStep(target: 'card', title: 'Card', body: 'Tap'),
    ]);
    await tester.pumpAndSettle();
    final hole = CoachLayer.debugHole!;
    // Drawn 100×120, plus the ring's 6 px on each side.
    expect(hole.width, closeTo(112, 0.5));
    expect(hole.height, closeTo(132, 0.5));
    expect(hole.center, tester.getCenter(find.byType(Scaffold)));
  });

  testWidgets('tapping the ringed button moves on; Next and Skip work', (
    tester,
  ) async {
    var ended = 0;
    var done = 0;
    await tester.pumpWidget(app());
    Coach.instance.start(
      'test',
      const [
        CoachStep(
          target: 'button',
          title: 'One',
          body: 'Tap',
          tapToContinue: true,
        ),
        CoachStep(title: 'Two', body: 'Read'),
        CoachStep(title: 'Three', body: 'Last'),
      ],
      onDone: () => done++,
      onEnd: () => ended++,
    );
    await tester.pumpAndSettle();
    expect(find.text('One'), findsOneWidget);
    // Outside the ring nothing reacts.
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(Coach.instance.index, 0);

    await tester.tap(find.text('Button'));
    await tester.pumpAndSettle();
    expect(Coach.instance.step?.title, 'Two');

    await tester.tap(find.byKey(const ValueKey('tour-next')));
    await tester.pumpAndSettle();
    expect(Coach.instance.step?.title, 'Three');
    expect(find.text('Done'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tour-next')));
    await tester.pumpAndSettle();
    expect(Coach.instance.active, isFalse);
    expect((done, ended), (1, 1));

    // Skip ends it too, without "done".
    Coach.instance.start(
      'test',
      const [CoachStep(title: 'Again', body: 'Skip me')],
      onDone: () => done++,
      onEnd: () => ended++,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tour-skip')));
    await tester.pumpAndSettle();
    expect((done, ended), (1, 2));
  });

  testWidgets('a step waits for its target and offers a way out', (
    tester,
  ) async {
    await tester.pumpWidget(app(body: const SizedBox.shrink()));
    Coach.instance.start('test', const [
      CoachStep(target: 'missing', title: 'Hidden', body: 'Not here yet'),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Hidden'), findsNothing);
    expect(find.byKey(const ValueKey('tour-end')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('tour-end')));
    await tester.pumpAndSettle();
    expect(Coach.instance.active, isFalse);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('every bubble fits a small phone in ${locale.languageCode}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(app(locale: locale));
      final l10n = lookupAppLocalizations(locale);
      // The real texts; targets and screens left out (they need the app).
      final steps = [
        for (final step in appTourSteps(l10n))
          CoachStep(
            title: step.title,
            body: step.body,
            tapToContinue: step.tapToContinue,
            target: step.tapToContinue ? 'button' : null,
          ),
      ];
      Coach.instance.start('test', steps);
      for (var i = 0; i < steps.length; i++) {
        await tester.pumpAndSettle();
        expect(find.text(steps[i].title), findsOneWidget);
        expect(tester.takeException(), isNull, reason: steps[i].title);
        Coach.instance.next();
      }
    });
  }
}
