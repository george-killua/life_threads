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

  /// Without [id]. The story keeps at least one memory, so removing the
  /// last one returns this selection unchanged.
  StorySelection remove(String id) {
    if (ids.length <= 1) return this;
    return StorySelection([
      for (final other in ids)
        if (other != id) other,
    ]);
  }

  /// The memory at [from] moved to [to] (indices into [ids], [to] counted
  /// after the removal, as `ReorderableListView` reports with the fix-up).
  StorySelection move(int from, int to) {
    if (from < 0 || from >= ids.length) return this;
    final next = [...ids];
    final id = next.removeAt(from);
    next.insert(to.clamp(0, next.length), id);
    return StorySelection(next);
  }

  /// The selected memories that still exist, in selection order.
  List<MemoryEvent> resolve(List<MemoryEvent> events) {
    final byId = {for (final event in events) event.id: event};
    return [for (final id in ids) ?byId[id]];
  }
}

/// Whether [event] matches what the user typed in the memory search: every
/// word must appear in the title, story, place or year (case-insensitive).
bool storyMemoryMatches(MemoryEvent event, String query) {
  final words = query.toLowerCase().split(RegExp(r'\s+'))
    ..removeWhere((word) => word.isEmpty);
  if (words.isEmpty) return true;
  final haystack = [
    event.title,
    event.description,
    event.locationLabel,
    '${event.occurredAt.year}',
  ].join(' ').toLowerCase();
  return words.every(haystack.contains);
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
