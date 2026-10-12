import 'package:flutter/widgets.dart' show StringCharacters;

import '../../memories/domain/memory_event.dart';

/// The looks a story can take. Every template works with 1–6 memories.
enum StoryTemplate {
  /// One memory full-bleed: photo, title, place, date and feeling. A film
  /// shows each picked memory in turn.
  single,

  /// Pinned cards joined by the rope, like the wall.
  thread,

  /// A photo grid with one line of story.
  collage,

  /// The story text on the wall with a small pinned photo.
  quote,
}

/// The memories picked for a story, in the order they were picked.
class StorySelection {
  const StorySelection([this.ids = const []]);

  static const maxMemories = 6;

  final List<String> ids;

  bool get isEmpty => ids.isEmpty;
  bool get isFull => ids.length >= maxMemories;
  bool contains(String id) => ids.contains(id);

  /// Adds or removes [id]. Adding to a full selection returns this
  /// selection unchanged (check [isFull] to tell the user).
  StorySelection toggle(String id) {
    if (ids.contains(id)) {
      return StorySelection([
        for (final other in ids)
          if (other != id) other,
      ]);
    }
    if (isFull) return this;
    return StorySelection([...ids, id]);
  }

  /// The selected memories that still exist, in selection order.
  List<MemoryEvent> resolve(List<MemoryEvent> events) {
    final byId = {for (final event in events) event.id: event};
    return [for (final id in ids) ?byId[id]];
  }
}

/// The caption a new story starts with: the first memory's story, short
/// enough for one or two lines.
String defaultStoryCaption(List<MemoryEvent> memories) {
  if (memories.isEmpty) return '';
  return truncateStoryText(memories.first.description, 140);
}

/// Cuts [value] to [max] user-perceived characters (emoji stay whole).
String truncateStoryText(String value, int max) {
  final trimmed = value.trim().replaceAll(RegExp(r'\s+'), ' ');
  final characters = trimmed.characters;
  if (characters.length <= max) return trimmed;
  return '${characters.take(max - 1).toString().trimRight()}…';
}
