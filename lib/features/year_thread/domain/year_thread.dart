import 'dart:math' as math;

import '../../memories/data/memory_repository.dart';
import '../../memories/data/memory_seed_data.dart';
import '../../memories/domain/memory_event.dart';
import '../../memories/domain/memory_feeling.dart';

/// One memory as Thread of the Year sees it: the event plus what makes it a
/// good candidate for the film.
class YearThreadMemory {
  const YearThreadMemory({
    required this.event,
    this.photoPath,
    this.threadCount = 0,
    this.people = const [],
  });

  final MemoryEvent event;

  /// The cover photo, else the memory's first photo; null without photos.
  final String? photoPath;

  /// Threads (connections) to other memories, in any year.
  final int threadCount;

  /// Names of the people in the memory.
  final List<String> people;

  String get id => event.id;

  bool get hasPhoto => photoPath != null;

  /// The place shown in the film; '' when the memory has none.
  String get place {
    final label = event.locationLabel.trim();
    return label.isNotEmpty ? label : event.locationDisplayLabel;
  }

  /// Identifies the place across memories (same label, or roughly the same
  /// spot on the map for unnamed pins); null without a place.
  String? get placeKey {
    final label = event.locationLabel.trim().toLowerCase();
    if (label.isNotEmpty) return label;
    if (!event.hasGeoPoint) return null;
    return 'geo:${event.latitude!.toStringAsFixed(2)},'
        '${event.longitude!.toStringAsFixed(2)}';
  }

  /// How much the memory wants to be in the film. A photo matters most (the
  /// film is visual), then the feelings people mark as the big ones, then
  /// how woven-in the memory is.
  double get score {
    var score = 0.0;
    if (hasPhoto) score += 4;
    if (event.feeling == MemoryFeeling.important ||
        event.feeling == MemoryFeeling.proud) {
      score += 2;
    }
    score += math.min(threadCount, 4);
    score += math.min(people.length, 3) * 0.25;
    if (event.description.trim().isNotEmpty) score += 0.25;
    return score;
  }
}

/// What a year adds up to, for the title and closing cards.
class YearThreadStats {
  const YearThreadStats({
    required this.year,
    required this.memoryCount,
    required this.placeCount,
    required this.peopleCount,
    required this.months,
    this.mostFelt,
  });

  factory YearThreadStats.of(int year, List<YearThreadMemory> memories) {
    final places = <String>{};
    final people = <String>{};
    final months = <int>{};
    final feelings = <MemoryFeeling, int>{};
    for (final memory in memories) {
      final place = memory.placeKey;
      if (place != null) places.add(place);
      for (final name in memory.people) {
        final key = name.trim().toLowerCase();
        if (key.isNotEmpty) people.add(key);
      }
      months.add(memory.event.occurredAt.month);
      feelings.update(memory.event.feeling, (n) => n + 1, ifAbsent: () => 1);
    }
    MemoryFeeling? mostFelt;
    // Ties go to the feeling listed first, so the result never depends on
    // the order of the memories.
    for (final feeling in MemoryFeeling.values) {
      final count = feelings[feeling] ?? 0;
      if (count > 0 && (mostFelt == null || count > feelings[mostFelt]!)) {
        mostFelt = feeling;
      }
    }
    return YearThreadStats(
      year: year,
      memoryCount: memories.length,
      placeCount: places.length,
      peopleCount: people.length,
      months: (months.toList()..sort()),
      mostFelt: mostFelt,
    );
  }

  final int year;
  final int memoryCount;
  final int placeCount;
  final int peopleCount;

  /// Months (1–12) with at least one memory, in order.
  final List<int> months;

  /// The feeling marked most often; null for an empty year.
  final MemoryFeeling? mostFelt;
}

/// A year's memories (date order) and their stats.
class YearThreadYear {
  const YearThreadYear({
    required this.year,
    required this.memories,
    required this.stats,
  });

  final int year;
  final List<YearThreadMemory> memories;
  final YearThreadStats stats;

  /// A year needs a few memories to tell a story.
  bool get isAvailable => memories.length >= YearThread.minMemories;

  List<YearThreadMemory> get suggested => YearThread.select(memories);

  YearThreadMemory? find(String id) {
    for (final memory in memories) {
      if (memory.id == id) return memory;
    }
    return null;
  }
}

/// Picks the memories for a Thread of the Year. Pure and deterministic: the
/// same memories always give the same film.
abstract final class YearThread {
  static const minMemories = 3;
  static const maxMemories = 12;

  /// What a month that already has a memory in the film costs a candidate,
  /// in score points. Big enough that a strong memory from an empty month
  /// beats a second photo from a busy one; small enough that a year spent
  /// in one month still gets its best memories.
  static const monthPenalty = 3.0;

  /// Years with enough memories for a film, newest first. Demo memories do
  /// not count.
  static List<int> availableYears(MemoryState state) {
    final counts = <int, int>{};
    for (final event in state.visibleEvents) {
      if (MemorySeedData.isDemoEventId(event.id)) continue;
      counts.update(event.occurredAt.year, (n) => n + 1, ifAbsent: () => 1);
    }
    return [
      for (final entry in counts.entries)
        if (entry.value >= minMemories) entry.key,
    ]..sort((a, b) => b.compareTo(a));
  }

  /// Years that don't have enough memories yet, with how many they have,
  /// newest first (for the empty screen: "2025 · 2 of 3 memories").
  static List<({int year, int count})> almostYears(MemoryState state) {
    final counts = <int, int>{};
    for (final event in state.visibleEvents) {
      if (MemorySeedData.isDemoEventId(event.id)) continue;
      counts.update(event.occurredAt.year, (n) => n + 1, ifAbsent: () => 1);
    }
    return [
      for (final entry in counts.entries)
        if (entry.value < minMemories) (year: entry.key, count: entry.value),
    ]..sort((a, b) => b.year.compareTo(a.year));
  }

  /// The year Thread of the Year is about in December (this year) and
  /// January (the year that just ended); null the rest of the year.
  static int? seasonYear(DateTime now) => switch (now.month) {
    DateTime.december => now.year,
    DateTime.january => now.year - 1,
    _ => null,
  };

  static YearThreadYear year(MemoryState state, int year) {
    final eventIds = {for (final event in state.visibleEvents) event.id};
    final threads = <String, int>{};
    for (final connection in state.connections) {
      // Threads to notes and nails do not make a memory more central.
      if (!eventIds.contains(connection.fromEventId) ||
          !eventIds.contains(connection.toEventId)) {
        continue;
      }
      threads.update(connection.fromEventId, (n) => n + 1, ifAbsent: () => 1);
      threads.update(connection.toEventId, (n) => n + 1, ifAbsent: () => 1);
    }
    final memories = [
      for (final event in state.visibleEvents)
        if (event.occurredAt.year == year &&
            !MemorySeedData.isDemoEventId(event.id))
          YearThreadMemory(
            event: event,
            photoPath: _photoPath(state, event),
            threadCount: threads[event.id] ?? 0,
            people: [
              for (final person in state.people)
                if (person.eventId == event.id) person.name,
            ],
          ),
    ]..sort(byDate);
    return YearThreadYear(
      year: year,
      memories: memories,
      stats: YearThreadStats.of(year, memories),
    );
  }

  /// Up to [max] memories: the best-scoring ones, spread across months,
  /// returned in date order.
  static List<YearThreadMemory> select(
    List<YearThreadMemory> memories, {
    int max = maxMemories,
  }) {
    // Rank once so that equal scores always resolve the same way (earlier
    // memory first).
    final remaining = [...memories]
      ..sort((a, b) {
        final byScore = b.score.compareTo(a.score);
        return byScore != 0 ? byScore : byDate(a, b);
      });
    final picked = <YearThreadMemory>[];
    final perMonth = <int, int>{};
    while (picked.length < max && remaining.isNotEmpty) {
      var best = 0;
      var bestValue = double.negativeInfinity;
      for (var i = 0; i < remaining.length; i++) {
        final memory = remaining[i];
        final value =
            memory.score -
            monthPenalty * (perMonth[memory.event.occurredAt.month] ?? 0);
        if (value > bestValue) {
          best = i;
          bestValue = value;
        }
      }
      final memory = remaining.removeAt(best);
      picked.add(memory);
      perMonth.update(
        memory.event.occurredAt.month,
        (n) => n + 1,
        ifAbsent: () => 1,
      );
    }
    return picked..sort(byDate);
  }

  static int byDate(YearThreadMemory a, YearThreadMemory b) {
    final byTime = a.event.occurredAt.compareTo(b.event.occurredAt);
    return byTime != 0 ? byTime : a.id.compareTo(b.id);
  }

  static String? _photoPath(MemoryState state, MemoryEvent event) {
    final cover = event.coverPhotoPath?.trim();
    if (cover != null && cover.isNotEmpty) return cover;
    for (final photo in state.photos) {
      if (photo.eventId == event.id && photo.localPath.trim().isNotEmpty) {
        return photo.localPath;
      }
    }
    return null;
  }
}
