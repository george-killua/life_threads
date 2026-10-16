// Thread of the Year: which memories make the film, and the year's stats.
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/year_thread/domain/year_thread.dart';

import 'support/year_thread_fixtures.dart';

List<String> ids(List<YearThreadMemory> memories) =>
    memories.map((memory) => memory.id).toList();

void main() {
  group('available years', () {
    test('need at least 3 memories; newest first', () {
      final state = yearState([
        for (var i = 0; i < 3; i++) yearMemory('a$i', DateTime(2023, i + 1)),
        for (var i = 0; i < 2; i++) yearMemory('b$i', DateTime(2024, i + 1)),
        for (var i = 0; i < 5; i++) yearMemory('c$i', DateTime(2025, i + 1)),
      ]);

      expect(YearThread.availableYears(state), [2025, 2023]);
    });

    test('untouched demo memories do not count, changed ones do', () {
      // The demo's own 2025 memory, as the demo wall made it.
      final demo = MemorySeedData.events.firstWhere(
        (event) => event.occurredAt.year == 2025,
      );
      final state = yearState([
        demo,
        yearMemory('a', DateTime(2025, 2, 1)),
        yearMemory('b', DateTime(2025, 3, 1)),
      ]);

      expect(YearThread.availableYears(state), isEmpty);
      expect(YearThread.year(state, 2025).memories.map((m) => m.id), [
        'a',
        'b',
      ]);

      // Re-dated by the user: theirs now.
      final mine = yearState([
        demo.copyWith(occurredAt: DateTime(2025, 1, 1)),
        yearMemory('a', DateTime(2025, 2, 1)),
        yearMemory('b', DateTime(2025, 3, 1)),
      ]);
      expect(YearThread.availableYears(mine), [2025]);
    });

    test('an empty wall has no years', () {
      expect(YearThread.availableYears(yearState(const [])), isEmpty);
      final year = YearThread.year(yearState(const []), 2025);
      expect(year.isAvailable, isFalse);
      expect(year.suggested, isEmpty);
      expect(year.stats.memoryCount, 0);
      expect(year.stats.mostFelt, isNull);
      expect(year.stats.months, isEmpty);
    });

    test('fewer than 3 memories leave the feature unavailable', () {
      final year = YearThread.year(
        yearState([
          yearMemory('a', DateTime(2025, 2, 1)),
          yearMemory('b', DateTime(2025, 3, 1)),
        ]),
        2025,
      );

      expect(year.isAvailable, isFalse);
      expect(ids(year.suggested), ['a', 'b']);
    });
  });

  group('season', () {
    test('December is about this year, January about the last one', () {
      expect(YearThread.seasonYear(DateTime(2025, 12, 1)), 2025);
      expect(YearThread.seasonYear(DateTime(2025, 12, 31, 23)), 2025);
      expect(YearThread.seasonYear(DateTime(2026, 1, 1)), 2025);
      expect(YearThread.seasonYear(DateTime(2026, 1, 31)), 2025);
      expect(YearThread.seasonYear(DateTime(2026, 2, 1)), isNull);
      expect(YearThread.seasonYear(DateTime(2026, 11, 30)), isNull);
    });
  });

  group('selection', () {
    test('keeps at most 12, in date order', () {
      final memories = [
        for (var i = 0; i < 20; i++)
          candidate(yearMemory('m$i', DateTime(2025, 12 - i % 12, 28 - i))),
      ];

      final picked = YearThread.select(memories);

      expect(picked, hasLength(YearThread.maxMemories));
      final dates = picked.map((m) => m.event.occurredAt).toList();
      expect(dates, [...dates]..sort());
    });

    test('prefers photos, then important and proud memories', () {
      final day = DateTime(2025, 5, 1);
      final memories = [
        candidate(yearMemory('plain', day)),
        candidate(yearMemory('proud', day, feeling: MemoryFeeling.proud)),
        candidate(
          yearMemory('important', day, feeling: MemoryFeeling.important),
        ),
        candidate(yearMemory('photo', day, photo: '/p.jpg')),
      ];

      expect(ids(YearThread.select(memories, max: 1)), ['photo']);
      expect(ids(YearThread.select(memories, max: 3)), [
        'important',
        'photo',
        'proud',
      ]);
    });

    test('memories with many threads win among equals', () {
      final state = yearState(
        [
          yearMemory('hub', DateTime(2025, 4, 1)),
          yearMemory('lonely', DateTime(2025, 4, 2)),
          yearMemory('x', DateTime(2024, 1, 1)),
          yearMemory('y', DateTime(2023, 1, 1)),
        ],
        connections: [thread('hub', 'x'), thread('y', 'hub')],
      );
      final year = YearThread.year(state, 2025);

      expect(year.find('hub')!.threadCount, 2);
      expect(ids(YearThread.select(year.memories, max: 1)), ['hub']);
    });

    test('threads to notes and nails do not count', () {
      final state = yearState(
        [yearMemory('a', DateTime(2025, 4, 1))],
        connections: [thread('a', 'note-1')],
      );

      expect(YearThread.year(state, 2025).find('a')!.threadCount, 0);
    });

    test('spreads the film across months', () {
      // Four strong memories in March, simpler ones in other months.
      final memories = [
        for (var i = 0; i < 4; i++)
          candidate(
            yearMemory(
              'march$i',
              DateTime(2025, 3, i + 1),
              photo: '/m$i.jpg',
              feeling: MemoryFeeling.proud,
            ),
          ),
        candidate(yearMemory('june', DateTime(2025, 6, 1), photo: '/j.jpg')),
        candidate(
          yearMemory('october', DateTime(2025, 10, 1), photo: '/o.jpg'),
        ),
      ];

      expect(ids(YearThread.select(memories, max: 3)), [
        'march0',
        'june',
        'october',
      ]);
    });

    test('a year on one day still picks its best memories', () {
      final day = DateTime(2025, 8, 15, 12);
      final memories = [
        candidate(yearMemory('a', day)),
        candidate(yearMemory('b', day, photo: '/b.jpg')),
        candidate(yearMemory('c', day, feeling: MemoryFeeling.important)),
        candidate(yearMemory('d', day)),
      ];

      expect(ids(YearThread.select(memories, max: 2)), ['b', 'c']);
    });

    test('works without any photos', () {
      final memories = [
        for (var i = 0; i < 5; i++)
          candidate(yearMemory('m$i', DateTime(2025, i + 1))),
      ];

      expect(ids(YearThread.select(memories, max: 3)), ['m0', 'm1', 'm2']);
    });

    test('is deterministic whatever the input order', () {
      final memories = YearThread.year(sampleYear(), 2025).memories;
      final first = ids(YearThread.select(memories, max: 5));

      expect(ids(YearThread.select(memories.reversed.toList(), max: 5)), first);
      expect(ids(YearThread.select([...memories]..shuffle(), max: 5)), first);
    });

    test('uses the first photo when there is no cover', () {
      final state = sampleYear();
      final withPhotos = yearState(
        [yearMemory('a', DateTime(2025, 1, 1))],
        photos: [photoOf('a', '/first.jpg'), photoOf('a', '/second.jpg')],
      );

      expect(YearThread.year(state, 2025).find('note')!.hasPhoto, isFalse);
      expect(
        YearThread.year(withPhotos, 2025).find('a')!.photoPath,
        '/first.jpg',
      );
    });
  });

  group('stats', () {
    test('count memories, places, people and months of the year', () {
      final stats = YearThread.year(sampleYear(), 2025).stats;

      expect(stats.year, 2025);
      expect(stats.memoryCount, 8);
      // Vienna, Linz, Grado, Graz, Dachstein; the Sunday has no place.
      expect(stats.placeCount, 5);
      // Anna (twice), Lena and Grandma.
      expect(stats.peopleCount, 3);
      expect(stats.months, [1, 3, 5, 6, 7, 9, 10, 11]);
      expect(stats.mostFelt, MemoryFeeling.proud);
    });

    test('places are matched by name, or by spot for unnamed pins', () {
      final memories = [
        candidate(yearMemory('a', DateTime(2025, 1), place: 'Vienna')),
        candidate(yearMemory('b', DateTime(2025, 2), place: ' vienna ')),
        candidate(
          yearMemory(
            'c',
            DateTime(2025, 3),
            latitude: 48.2082,
            longitude: 16.3738,
          ),
        ),
        candidate(
          yearMemory(
            'd',
            DateTime(2025, 4),
            latitude: 48.2091,
            longitude: 16.3719,
          ),
        ),
        candidate(yearMemory('e', DateTime(2025, 5))),
      ];

      expect(YearThreadStats.of(2025, memories).placeCount, 2);
    });

    test('a tie in feelings goes to the first feeling', () {
      final memories = [
        candidate(
          yearMemory('a', DateTime(2025, 1), feeling: MemoryFeeling.calm),
        ),
        candidate(
          yearMemory('b', DateTime(2025, 2), feeling: MemoryFeeling.warm),
        ),
      ];

      expect(YearThreadStats.of(2025, memories).mostFelt, MemoryFeeling.warm);
      expect(
        YearThreadStats.of(2025, memories.reversed.toList()).mostFelt,
        MemoryFeeling.warm,
      );
    });
  });
}
