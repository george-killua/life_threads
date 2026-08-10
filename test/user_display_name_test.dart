import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/onboarding/onboarding_preferences.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:life_threads/features/settings/presentation/pages/settings_page.dart';
import 'package:life_threads/features/wall/data/wall_theme_controller.dart';
import 'package:life_threads/features/wall/domain/wall_theme.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _EmptyMemoryRepository extends MemoryRepository {
  @override
  Future<MemoryState> build() async {
    return const MemoryState(
      events: [],
      connections: [],
      photos: [],
      people: [],
      wallItems: [],
    );
  }
}

class _FreePremiumController extends PremiumEntitlementController {
  @override
  Future<PremiumEntitlement> build() async {
    return const PremiumEntitlement(
      isPremium: false,
      isMockUnlocked: false,
    );
  }
}

class _FixedThemeController extends WallThemeController {
  @override
  Future<WallThemePreset> build() async => WallThemePreset.warmMemoryRoom;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingPreferences display name', () {
    test('stores and clears display name', () async {
      SharedPreferences.setMockInitialValues({});
      const preferences = OnboardingPreferences();

      expect(await preferences.getDisplayName(), isEmpty);

      await preferences.setDisplayName('  Ada  ');
      expect(await preferences.getDisplayName(), 'Ada');

      await preferences.setDisplayName('   ');
      expect(await preferences.getDisplayName(), isEmpty);
    });

    test('markCompleted persists display name', () async {
      SharedPreferences.setMockInitialValues({});
      const preferences = OnboardingPreferences();

      await preferences.markCompleted(
        useDemoWall: false,
        displayName: 'Nora',
      );

      expect(await preferences.isCompleted(), isTrue);
      expect(await preferences.getDisplayName(), 'Nora');
      expect(await preferences.shouldUseDemoWall(), isFalse);
    });
  });

  group('userDisplayNameProvider', () {
    test('reads and updates display name', () async {
      SharedPreferences.setMockInitialValues({
        'user_display_name': 'George',
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(await container.read(userDisplayNameProvider.future), 'George');

      await container
          .read(userDisplayNameProvider.notifier)
          .setDisplayName('Alex');

      expect(container.read(userDisplayNameProvider).asData?.value, 'Alex');
      expect(await const OnboardingPreferences().getDisplayName(), 'Alex');
    });
  });

  testWidgets('settings rename updates saved display name', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
      'user_display_name': 'George',
      'demo_wall_enabled': false,
    });

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoryRepositoryProvider.overrideWith(_EmptyMemoryRepository.new),
          premiumEntitlementProvider.overrideWith(_FreePremiumController.new),
          wallThemeProvider.overrideWith(_FixedThemeController.new),
        ],
        child: MaterialApp.router(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Your name'), findsWidgets);
    expect(find.text('George'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Alex');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Name updated.'), findsOneWidget);
    expect(await const OnboardingPreferences().getDisplayName(), 'Alex');
  });
}
