import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/wall/data/wall_theme_controller.dart';
import 'package:life_threads/features/wall/domain/wall_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('WallThemePreset', () {
    test('only Warm Memory Room is free', () {
      final freeThemes = WallThemePreset.all.where((theme) => !theme.isPremium);

      expect(freeThemes.map((theme) => theme.id), [WallThemeId.warmMemoryRoom]);
    });

    test('includes required premium wall themes', () {
      expect(
        WallThemePreset.all.map((theme) => theme.id),
        containsAll([
          WallThemeId.warmMemoryRoom,
          WallThemeId.midnightArchive,
          WallThemeId.softPaperWall,
          WallThemeId.travelCorkboard,
        ]),
      );
    });
  });

  group('effectiveWallThemeProvider', () {
    Future<WallThemePreset> effectiveTheme({required bool premium}) async {
      SharedPreferences.setMockInitialValues({
        'selected_wall_theme': WallThemeId.midnightArchive.name,
        'premium_store_unlock_enabled': premium,
      });
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(effectiveWallThemeProvider, (_, _) {});
      await container.read(wallThemeProvider.future);
      await container.read(premiumEntitlementProvider.future);
      return container.read(effectiveWallThemeProvider);
    }

    test('applies a Premium theme with Premium', () async {
      expect(
        (await effectiveTheme(premium: true)).id,
        WallThemeId.midnightArchive,
      );
    });

    test('falls back to Warm Memory Room without Premium', () async {
      expect(
        (await effectiveTheme(premium: false)).id,
        WallThemeId.warmMemoryRoom,
      );
    });
  });

  test('each wall theme gives the app its own accent', () {
    for (final wall in WallThemePreset.all) {
      final theme = AppTheme.forWall(wall);
      expect(theme.colorScheme.primary, wall.accent);
      expect(theme.scaffoldBackgroundColor, wall.background);
    }
  });
}
