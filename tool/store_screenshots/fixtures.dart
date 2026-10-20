import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/memories/domain/memory_connection.dart';
import 'package:life_threads/features/memories/domain/memory_person.dart';
import 'package:life_threads/features/wall/domain/wall_item.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

/// The store screenshots show the app's demo wall (MemorySeedData): the
/// same moments, threads, people and photos (assets/demo_moments/) that new
/// users can preview in the app.
const momentsPrefix = 'assets/demo_moments/';

/// The demo memories under their own ids (`store-…`): with the demo ids the
/// wall would show its "Demo wall preview – clear demo" banner.
String storeId(String demoId) => demoId.replaceFirst('demo-', 'store-');

MemoryState storeMemoryState(String lang) {
  final l10n = lookupAppLocalizations(Locale(lang));
  return MemoryState(
    events: [
      for (final event in MemorySeedData.localizedEvents(l10n))
        event.copyWith(id: storeId(event.id)),
    ],
    connections: [
      for (final c in MemorySeedData.localizedConnections(l10n))
        MemoryConnection(
          id: c.id,
          fromEventId: storeId(c.fromEventId),
          toEventId: storeId(c.toEventId),
          label: c.label,
        ),
    ],
    photos: const [],
    people: [
      for (final p in MemorySeedData.localizedPeople(l10n))
        MemoryPerson(
          id: p.id,
          eventId: storeId(p.eventId),
          name: p.name,
          relationship: p.relationship,
        ),
    ],
    wallItems: const <WallItem>[],
  );
}

/// Store captions: (tag, headline, subtitle) per language, in listing order.
/// The caption above each screenshot: (tag, headline, subtitle) per scene
/// and language, from captions.json.
final Map<String, Map<String, (String, String, String)>> storeCaptions = {
  for (final MapEntry(key: scene, value: languages)
      in (jsonDecode(
                File('tool/store_screenshots/captions.json').readAsStringSync(),
              )
              as Map<String, dynamic>)
          .entries)
    scene: {
      for (final MapEntry(key: lang, value: texts)
          in (languages as Map<String, dynamic>).entries)
        lang: (
          (texts as List)[0] as String,
          texts[1] as String,
          texts[2] as String,
        ),
    },
};
