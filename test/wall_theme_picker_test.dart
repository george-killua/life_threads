import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/features/wall/data/wall_theme_controller.dart';
import 'package:life_threads/features/wall/domain/wall_theme.dart';
import 'package:life_threads/features/wall/presentation/widgets/wall_theme_picker.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> pumpPicker(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'premium_store_unlock_enabled': true,
    });
    final container = ProviderContainer(
      overrides: [
        wallClockProvider.overrideWithValue(
          AsyncData(DateTime(2026, 10, 15, 12)),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.dark,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: SingleChildScrollView(child: WallThemePicker()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('shows this season\'s themes and previews the next ones', (
    tester,
  ) async {
    await pumpPicker(tester);

    expect(find.text('Auto by time of day'), findsOneWidget);
    expect(find.text('Autumn Harvest'), findsOneWidget);
    expect(find.text('Misty Forest'), findsOneWidget);
    expect(find.text('Until Nov 30'), findsNWidgets(2));
    expect(find.text('Coming later'), findsOneWidget);
    expect(find.text('Winter Lights'), findsOneWidget);
    expect(find.text('From Dec 1'), findsNWidgets(2));
  });

  testWidgets('a coming theme can be previewed but not used yet', (
    tester,
  ) async {
    final container = await pumpPicker(tester);

    await tester.ensureVisible(find.text('Snowy Cabin'));
    await tester.tap(find.text('Snowy Cabin'));
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('From Dec 1').last,
        matching: find.byWidgetPredicate((w) => w is FilledButton),
      ),
    );
    expect(button.onPressed, isNull);
    expect(
      container.read(effectiveWallThemeProvider).id,
      WallThemeId.warmMemoryRoom,
    );
  });

  testWidgets('previews a theme before using it', (tester) async {
    final container = await pumpPicker(tester);

    await tester.ensureVisible(find.text('Travel Corkboard'));
    await tester.tap(find.text('Travel Corkboard'));
    await tester.pumpAndSettle();
    expect(find.text('Use this theme'), findsOneWidget);
    expect(
      container.read(effectiveWallThemeProvider).id,
      WallThemeId.warmMemoryRoom,
    );

    await tester.tap(find.text('Use this theme'));
    await tester.pumpAndSettle();
    expect(
      container.read(effectiveWallThemeProvider).id,
      WallThemeId.travelCorkboard,
    );
  });
}
