import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_person.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/search/memory_search.dart';

MemoryEvent _event(String id, String title, DateTime at, {String place = ''}) =>
    MemoryEvent(
      id: id,
      title: title,
      description: 'A day to remember',
      category: MemoryCategory.personal,
      memoryType: MemoryType.moment,
      feeling: MemoryFeeling.warm,
      occurredAt: at,
      createdAt: at,
      coverColor: Colors.amber,
      wallPosition: Offset.zero,
      rotation: 0,
      locationLabel: place,
    );

final _state = MemoryState(
  events: [
    _event(
      'a',
      'Above the clouds',
      DateTime(2025, 7, 20),
      place: 'Heiligenblut am Großglockner, Austria',
    ),
    _event(
      'b',
      'Summer in Split',
      DateTime(2025, 10, 15),
      place: 'Split, Croatia',
    ),
    _event('c', 'Café morning', DateTime(2023, 3, 1)),
  ],
  connections: const [],
  photos: const [],
  people: const [
    MemoryPerson(id: 'p', eventId: 'c', name: 'Kate Bell', relationship: ''),
  ],
  wallItems: const [],
);

List<String> _ids(String query) =>
    searchMemories(_state, query).map((e) => e.id).toList();

void main() {
  test('finds by title, place, person and year, newest first', () {
    expect(_ids('split'), ['b']);
    expect(_ids('austria'), ['a']);
    expect(_ids('kate'), ['c']);
    expect(_ids('2025'), ['b', 'a']);
  });

  test('ignores case and accents; every word must match', () {
    expect(_ids('GROSSGLOCKNER'), ['a']);
    expect(_ids('cafe'), ['c']);
    expect(_ids('summer 2025'), ['b']);
    expect(_ids('summer 2023'), isEmpty);
  });

  test('an empty search shows nothing', () {
    expect(_ids('   '), isEmpty);
  });
}
