import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/app.dart';
import 'package:life_threads/features/onboarding/onboarding_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The demo wall preview keeps swaying, so time is stepped instead of
/// waiting for everything to stand still.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('shows onboarding before first wall visit', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ProviderScope(child: LifeThreadsApp()));
    await tester.pump();
    await tester.pump();

    expect(find.text('LifeThreads'), findsWidgets);
    expect(find.text('Build your living wall.'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('collects name and completes onboarding', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ProviderScope(child: LifeThreadsApp()));
    await tester.pump();
    await tester.pump();

    // Welcome -> How it works
    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(find.text('How it works'), findsOneWidget);
    expect(find.text('Memories come back to you'), findsOneWidget);
    expect(find.text('Your memories stay private'), findsOneWidget);

    // How it works -> Name
    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(find.text('What should we call you?'), findsOneWidget);

    // Next disabled until name entered
    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(find.text('What should we call you?'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'George');
    await tester.pump();
    expect(find.text('Nice to meet you, George.'), findsOneWidget);

    // Privacy is one of the "How it works" cards, not a page of its own.
    expect(
      find.text('Only for greeting you – it stays on this phone.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(find.text('Choose how to begin'), findsOneWidget);
    expect(find.text('Start fresh'), findsOneWidget);

    await tester.tap(find.text('Start fresh'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final preferences = const OnboardingPreferences();
    expect(await preferences.isCompleted(), isTrue);
    expect(await preferences.getDisplayName(), 'George');
    expect(await preferences.shouldUseDemoWall(), isFalse);
  });
}
