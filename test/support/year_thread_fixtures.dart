import 'package:flutter/material.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_connection.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_person.dart';
import 'package:life_threads/features/memories/domain/memory_photo.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/year_thread/domain/year_thread.dart';

MemoryEvent yearMemory(
  String id,
  DateTime occurredAt, {
  MemoryFeeling feeling = MemoryFeeling.warm,
  String place = '',
  double? latitude,
  double? longitude,
  String? photo,
  String? title,
  String description = '',
}) => MemoryEvent(
  id: id,
  title: title ?? 'Memory $id',
  description: description,
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: feeling,
  occurredAt: occurredAt,
  createdAt: occurredAt,
  coverColor: Colors.teal,
  wallPosition: Offset.zero,
  rotation: 0,
  locationLabel: place,
  latitude: latitude,
  longitude: longitude,
  coverPhotoPath: photo,
);

MemoryState yearState(
  List<MemoryEvent> events, {
  List<MemoryConnection> connections = const [],
  List<MemoryPhoto> photos = const [],
  List<MemoryPerson> people = const [],
}) => MemoryState(
  events: events,
  connections: connections,
  photos: photos,
  people: people,
  wallItems: const [],
);

MemoryConnection thread(String from, String to) => MemoryConnection(
  id: '$from-$to',
  fromEventId: from,
  toEventId: to,
  label: '',
);

MemoryPerson person(String eventId, String name) => MemoryPerson(
  id: '$eventId-$name',
  eventId: eventId,
  name: name,
  relationship: '',
);

MemoryPhoto photoOf(String eventId, String path) => MemoryPhoto(
  id: path,
  eventId: eventId,
  localPath: path,
  capturedAt: DateTime(2025),
  width: 100,
  height: 100,
);

YearThreadMemory candidate(MemoryEvent event, {int threads = 0}) =>
    YearThreadMemory(
      event: event,
      photoPath: event.coverPhotoPath,
      threadCount: threads,
    );

/// A year like a real user's: photos, places, people and threads, with the
/// store's demo photos (absolute paths) when [photoDir] is given.
MemoryState sampleYear({String? photoDir, int year = 2025}) {
  String? photo(String name) => photoDir == null ? null : '$photoDir/$name';
  final events = [
    yearMemory(
      'dance',
      DateTime(year, 1, 18),
      title: 'Our first dance',
      feeling: MemoryFeeling.important,
      place: 'Vienna',
      photo: photo('01_first_dance.jpg'),
    ),
    yearMemory(
      'newborn',
      DateTime(year, 3, 2),
      title: 'Lena came home',
      feeling: MemoryFeeling.proud,
      place: 'Linz',
      photo: photo('02_newborn.jpg'),
    ),
    yearMemory(
      'sunset',
      DateTime(year, 5, 24),
      title: 'Sunset at the beach',
      feeling: MemoryFeeling.calm,
      place: 'Grado',
      photo: photo('03_beach_sunset.jpg'),
    ),
    yearMemory(
      'kitchen',
      DateTime(year, 6, 9),
      title: "Grandma's kitchen",
      feeling: MemoryFeeling.nostalgic,
      place: 'Linz',
      photo: photo('04_grandma_kitchen.jpg'),
    ),
    yearMemory(
      'graduation',
      DateTime(year, 7, 4),
      title: 'Graduation day',
      feeling: MemoryFeeling.proud,
      place: 'Graz',
      photo: photo('05_graduation.jpg'),
    ),
    yearMemory(
      'home',
      DateTime(year, 9, 13),
      title: 'Keys to our first home',
      feeling: MemoryFeeling.important,
      place: 'Vienna',
      photo: photo('06_first_home.jpg'),
    ),
    yearMemory(
      'summit',
      DateTime(year, 10, 5),
      title: 'Up on the summit',
      feeling: MemoryFeeling.proud,
      place: 'Dachstein',
      photo: photo('07_alpine_summit.jpg'),
    ),
    yearMemory('note', DateTime(year, 11, 20), title: 'A quiet Sunday'),
  ];
  return yearState(
    events,
    connections: [thread('dance', 'home'), thread('newborn', 'kitchen')],
    people: [
      person('dance', 'Anna'),
      person('newborn', 'Lena'),
      person('newborn', 'Anna'),
      person('kitchen', 'Grandma'),
    ],
  );
}
