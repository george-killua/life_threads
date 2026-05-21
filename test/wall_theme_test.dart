import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/wall/domain/wall_theme.dart';

void main() {
  group('WallThemePreset', () {
    test('only Warm Memory Room is free', () {
      final freeThemes = WallThemePreset.all.where((theme) => !theme.isPremium);

      expect(freeThemes.map((theme) => theme.id), [WallThemeId.warmMemoryRoom]);
    });

    test('includes required premium wall themes', () {
      expect(
        WallThemePreset.all.map((theme) => theme.label),
        containsAll([
          'Warm Memory Room',
          'Midnight Archive',
          'Soft Paper Wall',
          'Travel Corkboard',
        ]),
      );
    });
  });
}
