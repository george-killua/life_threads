import '../../memories/data/memory_repository.dart';
import '../../memories/domain/memory_event.dart';

/// One month of one's life on the wall: its memories, the people in them
/// and the places, for "Your September".
class MonthLookBack {
  const MonthLookBack({
    required this.year,
    required this.month,
    required this.memories,
    required this.people,
    required this.places,
  });

  /// The memories of [month] in [year] (hidden ones left out), in the order
  /// they happened.
  factory MonthLookBack.of(int year, int month, MemoryState state) {
    final memories = [
      for (final event in state.visibleEvents)
        if (_inMonth(event, year, month)) event,
    ]..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    final ids = {for (final event in memories) event.id};

    // People by how many memories they are in, then by name.
    final counts = <String, int>{};
    final names = <String, String>{};
    for (final person in state.people) {
      if (!ids.contains(person.eventId)) continue;
      final name = person.name.trim();
      if (name.isEmpty) continue;
      final key = name.toLowerCase();
      names.putIfAbsent(key, () => name);
      counts[key] = (counts[key] ?? 0) + 1;
    }
    final people = counts.keys.toList()
      ..sort((a, b) {
        final byCount = counts[b]!.compareTo(counts[a]!);
        return byCount != 0 ? byCount : a.compareTo(b);
      });

    final places = <String>[];
    for (final event in memories) {
      final place = event.locationDisplayLabel.trim();
      if (place.isNotEmpty && !places.contains(place)) places.add(place);
    }

    return MonthLookBack(
      year: year,
      month: month,
      memories: memories,
      people: [for (final key in people) names[key]!],
      places: places,
    );
  }

  final int year;
  final int month;
  final List<MemoryEvent> memories;
  final List<String> people;
  final List<String> places;

  bool get isEmpty => memories.isEmpty;

  /// The month the wall card and the monthly reminder look back on: the
  /// one before [now], during the first [cardDays] days of a month.
  static ({int year, int month})? cardMonth(DateTime now) {
    if (now.day > cardDays) return null;
    return previousMonth(now.year, now.month);
  }

  /// How long into a month its look-back card stays on the wall.
  static const cardDays = 7;

  static ({int year, int month}) previousMonth(int year, int month) =>
      month == 1 ? (year: year - 1, month: 12) : (year: year, month: month - 1);

  static ({int year, int month}) nextMonth(int year, int month) =>
      month == 12 ? (year: year + 1, month: 1) : (year: year, month: month + 1);

  static bool _inMonth(MemoryEvent event, int year, int month) {
    final at = event.occurredAt.toLocal();
    return at.year == year && at.month == month;
  }
}
