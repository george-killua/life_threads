import 'dart:math' as math;

import 'package:flutter/widgets.dart' show Size, StringCharacters;

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

  /// The memories' own words on the wall with a small pinned photo; a film
  /// types each memory's words in turn.
  quote,

  /// Instant photos dropped onto a pile one after another.
  polaroid,

  /// Album pages that turn, one taped-in photo per page.
  album,

  /// A film strip runs past; each frame zooms up to full screen.
  filmstrip,

  /// A timeline grows down the screen, the year counting up to each memory.
  timeline,

  /// Every memory a postcard that flips over to its story and postmark.
  postcard,

  /// Cinema bars, title cards, slow zooms and closing credits.
  cinema,

  /// A scrapbook page: every photo taped on, with handwritten titles.
  scrapbook,

  /// A magazine page: one large photo and the others around it.
  mosaic,

  /// A film contact sheet: every memory a frame, the first circled.
  contactSheet,

  /// The camera flies along the rope from card to card on the wall, then
  /// shows the whole wall.
  wallFlight,

  /// The cards turn on a 3D carousel, each memory to the front in turn.
  carousel,

  /// A route drawn across a paper map, a pin and photo at each place.
  journey;

  /// Offered for a story picture: the image shows every picked memory.
  bool get forPicture => switch (this) {
    thread || collage || polaroid || timeline => true,
    scrapbook || mosaic || contactSheet => true,
    _ => false,
  };

  /// Offered for a story video.
  bool get forVideo => switch (this) {
    scrapbook || mosaic || contactSheet => false,
    _ => true,
  };

  /// The looks offered in picture mode or in video mode, in picker order.
  static List<StoryTemplate> forMode({required bool video}) => [
    for (final template in values)
      if (video ? template.forVideo : template.forPicture) template,
  ];

  /// Whether this picture layout works in [format]: the tall ones
  /// (thread, timeline) need more height than a square has.
  bool fits(StoryFormat format) =>
      format != StoryFormat.square || (this != thread && this != timeline);

  /// What a new story starts with in each mode.
  static StoryTemplate defaultFor({required bool video}) =>
      video ? single : collage;

  /// How long the film runs when the user keeps "Auto": long enough to see
  /// every memory, short enough not to drag.
  double autoSeconds(int count) {
    final n = count.clamp(1, StorySelection.maxMemories);
    final value = switch (this) {
      single => 2 + n * 3.5,
      thread => 8 + n * 1.8,
      collage => 8 + n * 1.4,
      quote => 1 + n * 5.0,
      polaroid => 4 + n * 2.6,
      album => 1.5 + n * 4.0,
      filmstrip => 1 + n * 4.0,
      timeline => 2.5 + n * 3.5,
      postcard => 1 + n * 5.0,
      cinema => 3.5 + n * 4.0,
      scrapbook || mosaic || contactSheet => 8 + n * 1.4,
      wallFlight => 3 + n * 3.5,
      carousel => 1.5 + n * 3.2,
      journey => 2.5 + n * 3.5,
    };
    return value.clamp(storyMinSeconds, storyMaxSeconds).toDouble();
  }
}

/// When each memory comes up in a [template] film of [total] seconds with
/// [count] memories (seconds from the start, in the order the film shows
/// them).
List<double> storyMemoryStarts(
  StoryTemplate template,
  int count,
  double total,
) {
  if (count <= 0) return const [];
  switch (template) {
    case StoryTemplate.single:
      final segment = total / count;
      return [for (var i = 0; i < count; i++) i * segment];
    case StoryTemplate.thread:
      return [for (var i = 0; i < count; i++) threadCardStart(i, count, total)];
    case StoryTemplate.collage:
      final step = collageStep(total, count);
      return [for (var i = 0; i < count; i++) 0.6 + i * step];
    default:
      final turns = storyTurns(template, total);
      final span = storyTurnSpan(template, count, total);
      return [for (var i = 0; i < count; i++) turns.intro + i * span];
  }
}

/// Seconds before the first and after the last memory, for looks that show
/// the memories one after another. With [total], a short film keeps the
/// outro to 15 % of it, so the memories keep most of the time.
({double intro, double outro}) storyTurns(
  StoryTemplate template, [
  double? total,
]) {
  final turns = _turns(template);
  if (total == null) return turns;
  return (intro: turns.intro, outro: math.min(turns.outro, total * 0.15));
}

({double intro, double outro}) _turns(StoryTemplate template) {
  return switch (template) {
    StoryTemplate.quote => (intro: 0.0, outro: 0.6),
    StoryTemplate.polaroid => (intro: 0.5, outro: 1.8),
    StoryTemplate.album => (intro: 0.2, outro: 0.8),
    StoryTemplate.filmstrip => (intro: 0.3, outro: 0.8),
    StoryTemplate.timeline => (intro: 0.6, outro: 1.2),
    StoryTemplate.postcard => (intro: 0.2, outro: 0.8),
    StoryTemplate.cinema => (intro: 0.3, outro: 3.0),
    StoryTemplate.wallFlight => (intro: 1.2, outro: 2.0),
    StoryTemplate.carousel => (intro: 0.6, outro: 1.0),
    StoryTemplate.journey => (intro: 0.8, outro: 1.8),
    _ => (intro: 0.3, outro: 0.9),
  };
}

/// Seconds each memory gets in a look that shows them one after another.
double storyTurnSpan(StoryTemplate template, int count, double total) {
  final turns = storyTurns(template, total);
  return math.max(
    0.5,
    (total - turns.intro - turns.outro) / math.max(1, count),
  );
}

/// When card [index] of [count] lands on the wall in a Thread wall film.
double threadCardStart(int index, int count, double total) {
  if (count <= 1) return 1.0;
  // Longer films hang the cards further apart instead of sitting still.
  final room = math.min(4.0, math.max(2.4, total * 0.6 / count));
  final gap = math.min(room, (total - 7.0) / (count - 1));
  return 1.0 + index * gap;
}

/// Seconds between the photos landing in a Collage film.
double collageStep(double total, int count) =>
    ((total - 5) / math.max(1, count) * 0.5).clamp(0.5, 2.0);

/// The shape of a story picture: a story (9:16), a feed post (4:5) or a
/// square. Videos are always stories.
enum StoryFormat {
  story(Size(360, 640)),
  post(Size(360, 450)),
  square(Size(360, 360));

  const StoryFormat(this.size);

  /// Logical size (rendered at 3×: 1080 wide).
  final Size size;

  double get aspectRatio => size.width / size.height;
}

/// The shortest and longest story film the user can choose, in seconds.
/// Instagram Stories take up to 60 s; 30 s keeps a story easy to watch.
const storyMinSeconds = 8;
const storyMaxSeconds = 30;

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
