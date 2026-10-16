import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/on_this_day/domain/on_this_day.dart';
import 'package:life_threads/features/year_thread/domain/year_thread.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

import 'support/year_thread_fixtures.dart';

void main() {
  final demo = MemorySeedData.events;

  test('untouched demo memories are recognised in every language', () {
    final german = MemorySeedData.localizedEvents(
      lookupAppLocalizations(const Locale('de')),
    );
    expect(demo.every(MemorySeedData.isUntouchedDemo), isTrue);
    expect(german.every(MemorySeedData.isUntouchedDemo), isTrue);
    expect(
      MemorySeedData.isUntouchedDemo(yearMemory('mine', DateTime(2026))),
      isFalse,
    );
  });

  test('a demo memory the user changed counts as theirs', () {
    final redated = demo.first.copyWith(occurredAt: DateTime(2026, 2, 3));
    final renamed = demo[1].copyWith(title: 'Our dance');
    expect(MemorySeedData.isUntouchedDemo(redated), isFalse);
    expect(MemorySeedData.isUntouchedDemo(renamed), isFalse);
  });

  test('Thread of the Year: edited demo memories count, untouched not', () {
    final state = yearState([
      yearMemory('mine', DateTime(2026, 5, 1)),
      demo[0].copyWith(occurredAt: DateTime(2026, 6, 1)),
      demo[1].copyWith(occurredAt: DateTime(2026, 7, 1)),
      // Still as the demo made it: its own year, not counted.
      demo[2],
    ]);
    expect(YearThread.availableYears(state), [2026]);
    expect(YearThread.year(state, 2026).memories, hasLength(3));
    expect(
      YearThread.almostYears(
        state,
      ).where((y) => y.year == demo[2].occurredAt.year),
      isEmpty,
    );
  });

  test('On this day: an edited demo memory comes back, an untouched not', () {
    final edited = demo[0].copyWith(occurredAt: DateTime(2024, 10, 16));
    final untouched = demo.firstWhere((e) => e.occurredAt.month == 10);
    final day = DateTime(
      2026,
      untouched.occurredAt.month,
      untouched.occurredAt.day,
    );
    expect(
      OnThisDay.matchesOn(day, [untouched]).map((m) => m.memory.id),
      isEmpty,
    );
    expect(
      OnThisDay.matchesOn(DateTime(2026, 10, 16), [
        edited,
      ]).map((m) => m.memory.id),
      [edited.id],
    );
  });
}
