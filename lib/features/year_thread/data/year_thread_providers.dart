import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../memories/data/memory_repository.dart';
import '../../stories/data/music_catalog.dart';
import '../../wall/data/current_wall.dart';
import '../../stories/domain/music_track.dart';
import '../domain/year_thread.dart';

/// The current time; overridden in tests.
final yearThreadClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// The songs offered for the film, besides "No music": the bundled story
/// music library.
final yearThreadMusicTracksProvider = Provider<List<MusicTrack>>(
  (ref) => bundledMusicTracks,
);

/// The year whose wall card was dismissed with "Not now".
final yearThreadCardDismissalProvider =
    AsyncNotifierProvider<YearThreadCardDismissal, int?>(
      YearThreadCardDismissal.new,
    );

class YearThreadCardDismissal extends AsyncNotifier<int?> {
  static const _key = 'year_thread_card_dismissed_year';

  @override
  Future<int?> build() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_key);
  }

  Future<void> dismiss(int year) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_key, year);
    state = AsyncData(year);
  }
}

/// The year the wall's "Your year in memories" card offers, or null when
/// the card is hidden: it shows in December and January for a year with
/// enough memories, until dismissed for that year.
final yearThreadWallCardYearProvider = Provider<int?>((ref) {
  final year = YearThread.seasonYear(ref.watch(yearThreadClockProvider)());
  if (year == null) return null;
  final state = ref.watch(memoryRepositoryProvider).asData?.value;
  if (state == null) return null;
  // The card sits on one wall and opens Thread of the Year for that wall,
  // so it counts that wall's memories.
  final current = ref.watch(currentWallProvider);
  final wallId = state.walls.any((wall) => wall.id == current) ? current : null;
  if (!YearThread.availableYears(state.onWall(wallId)).contains(year)) {
    return null;
  }
  final dismissal = ref.watch(yearThreadCardDismissalProvider);
  if (!dismissal.hasValue || dismissal.value == year) return null;
  return year;
});
