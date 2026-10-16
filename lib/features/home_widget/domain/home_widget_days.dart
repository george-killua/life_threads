import '../../../l10n/generated/app_localizations.dart';
import '../../memories/domain/memory_event.dart';
import '../../on_this_day/domain/on_this_day.dart';

/// What the home screen widget shows on one day.
class HomeWidgetDay {
  const HomeWidgetDay({
    required this.date,
    required this.title,
    required this.subtitle,
    this.memory,
  });

  /// The day, at midnight; null for an entry shown on any day (locked).
  final DateTime? date;
  final String title;
  final String subtitle;

  /// The memory a tap opens and whose cover photo is shown; null opens the
  /// wall.
  final MemoryEvent? memory;

  /// [date] null: the one entry of a locked app.
  bool get isLocked => date == null;

  /// No memory yet: the widget offers to add one.
  bool get isEmpty => !isLocked && memory == null;
}

/// The widget's next [days] days from [today]: a memory from that day in an
/// earlier year (with [onThisDayFirst]), else one to remember (with
/// [photosFirst] memories with a photo first; a different one each day),
/// else an invitation to save today.
///
/// The widget switches at midnight by itself, so the app needs to run only
/// once in a while.
List<HomeWidgetDay> homeWidgetDays(
  DateTime today,
  List<MemoryEvent> events,
  AppLocalizations l10n, {
  int days = 7,
  bool onThisDayFirst = true,
  bool photosFirst = true,
}) {
  final start = DateTime(today.year, today.month, today.day);
  final withPhoto = [
    for (final event in events)
      if (event.coverPhotoPath?.isNotEmpty ?? false) event,
  ];
  final candidates =
      (!photosFirst || withPhoto.isEmpty ? [...events] : withPhoto)
        ..sort((a, b) => a.id.compareTo(b.id));

  return [
    for (var offset = 0; offset < days; offset++)
      _dayFor(
        DateTime(start.year, start.month, start.day + offset),
        onThisDayFirst ? events : const [],
        candidates,
        l10n,
      ),
  ];
}

HomeWidgetDay _dayFor(
  DateTime day,
  List<MemoryEvent> events,
  List<MemoryEvent> candidates,
  AppLocalizations l10n,
) {
  final match = OnThisDay.matchesOn(day, events).firstOrNull;
  if (match != null) {
    return HomeWidgetDay(
      date: day,
      title: match.memory.title,
      subtitle: l10n.onThisDayYearsAgoToday(match.yearsAgo),
      memory: match.memory,
    );
  }
  if (candidates.isEmpty) {
    return HomeWidgetDay(
      date: day,
      title: l10n.whatHappenedToday,
      subtitle: l10n.saveToday,
    );
  }
  // Days since 1970: one step through the memories per day.
  final dayNumber =
      DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
  final memory = candidates[dayNumber % candidates.length];
  return HomeWidgetDay(
    date: day,
    title: memory.title,
    subtitle: l10n.rememberThis,
    memory: memory,
  );
}
