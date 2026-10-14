import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/theme/app_colors.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/wall/data/wall_theme_controller.dart';
import 'package:life_threads/features/wall/domain/wall_card_style.dart';
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

  group('seasons', () {
    test('seasonal themes are only available in their season', () {
      expect(
        WallThemePreset.seasonalAt(DateTime(2026, 10, 15)).map((t) => t.id),
        [WallThemeId.autumnHarvest, WallThemeId.mistyForest],
      );
      expect(
        WallThemePreset.seasonalAt(DateTime(2027, 1, 5)).map((t) => t.id),
        [WallThemeId.winterLights, WallThemeId.snowyCabin],
      );
    });

    test('every season has two themes', () {
      for (final season in WallThemeSeason.values) {
        expect(
          WallThemePreset.seasonal.where((t) => t.season == season),
          hasLength(2),
        );
      }
    });

    test('upcoming themes come soonest season first', () {
      final october = DateTime(2026, 10, 15);
      final upcoming = WallThemePreset.upcomingAt(october);

      expect(upcoming.map((t) => t.season).toSet().toList(), [
        WallThemeSeason.winter,
        WallThemeSeason.spring,
        WallThemeSeason.summer,
      ]);
      expect(WallThemeSeason.winter.startAfter(october), DateTime(2026, 12));
      expect(WallThemeSeason.spring.startAfter(october), DateTime(2027, 3));
    });

    test('a season ends on its last day, across the new year', () {
      expect(
        WallThemeSeason.autumn.endAfter(DateTime(2026, 10, 15)),
        DateTime(2026, 11, 30),
      );
      expect(
        WallThemeSeason.winter.endAfter(DateTime(2026, 12, 3)),
        DateTime(2027, 2, 28),
      );
      expect(
        WallThemeSeason.winter.endAfter(DateTime(2027, 1, 3)),
        DateTime(2027, 2, 28),
      );
    });
  });

  test('Auto picks a theme by time of day', () {
    WallThemeId at(int hour) =>
        WallThemePreset.autoAt(DateTime(2026, 10, 15, hour)).id;

    expect(at(9), WallThemeId.softPaperWall);
    expect(at(19), WallThemeId.warmMemoryRoom);
    expect(at(23), WallThemeId.midnightArchive);
    expect(at(3), WallThemeId.midnightArchive);
  });

  group('effectiveWallThemeProvider', () {
    Future<WallThemePreset> effectiveTheme({
      required bool premium,
      WallThemeId selected = WallThemeId.midnightArchive,
      bool auto = false,
      DateTime? now,
    }) async {
      SharedPreferences.setMockInitialValues({
        'selected_wall_theme': selected.name,
        'premium_store_unlock_enabled': premium,
        'wall_theme_auto': auto,
      });
      final container = ProviderContainer(
        overrides: [
          wallClockProvider.overrideWithValue(
            AsyncData(now ?? DateTime(2026, 10, 15, 12)),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.listen(effectiveWallThemeProvider, (_, _) {});
      await container.read(wallThemeProvider.future);
      await container.read(wallThemeAutoProvider.future);
      await container.read(premiumEntitlementProvider.future);
      return container.read(effectiveWallThemeProvider);
    }

    test('shows a seasonal theme in season only', () async {
      final inSeason = await effectiveTheme(
        premium: true,
        selected: WallThemeId.autumnHarvest,
      );
      final afterSeason = await effectiveTheme(
        premium: true,
        selected: WallThemeId.autumnHarvest,
        now: DateTime(2026, 12, 2),
      );

      expect(inSeason.id, WallThemeId.autumnHarvest);
      expect(afterSeason.id, WallThemeId.warmMemoryRoom);
    });

    test('Auto follows the clock with Premium only', () async {
      final night = DateTime(2026, 10, 15, 23);

      expect(
        (await effectiveTheme(premium: true, auto: true, now: night)).id,
        WallThemeId.midnightArchive,
      );
      expect(
        (await effectiveTheme(premium: false, auto: true, now: night)).id,
        WallThemeId.warmMemoryRoom,
      );
    });

    test('choosing a theme turns Auto off', () async {
      SharedPreferences.setMockInitialValues({'wall_theme_auto': true});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(wallThemeAutoProvider.future);

      await container
          .read(wallThemeProvider.notifier)
          .selectTheme(WallThemePreset.travelCorkboard);

      expect(container.read(wallThemeAutoProvider).value, isFalse);
    });

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

  test('each wall theme gives the app its accent and card style', () {
    for (final wall in WallThemePreset.everyTheme) {
      final theme = AppTheme.forWall(wall);
      expect(theme.colorScheme.primary, wall.accent);
      expect(theme.scaffoldBackgroundColor, wall.background);
      expect(theme.extension<WallCardStyle>(), wall.cardStyle);
    }
  });

  test('AppColors follow the palette in use', () {
    addTearDown(() => AppColors.use(ThemePalette.warm));

    expect(AppColors.gold, BrandColors.gold);
    AppColors.use(ThemePalette.of(WallThemePreset.midnightArchive));
    expect(AppColors.gold, WallThemePreset.midnightArchive.accent);
    expect(AppColors.wallInk, WallThemePreset.midnightArchive.background);
    expect(ThemePalette.of(WallThemePreset.warmMemoryRoom), ThemePalette.warm);
  });

  test('text and paper colours follow the theme too', () {
    addTearDown(() => AppColors.use(ThemePalette.warm));

    expect(AppColors.muted, BrandColors.muted);
    expect(AppColors.card, BrandColors.card);
    AppColors.use(ThemePalette.of(WallThemePreset.travelCorkboard));
    expect(AppColors.muted, isNot(BrandColors.muted));
    expect(AppColors.card, WallThemePreset.travelCorkboard.cardStyle.paper[1]);
    expect(AppColors.paperInk, WallThemePreset.travelCorkboard.cardStyle.ink);
  });
}
