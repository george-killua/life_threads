import 'package:flutter/widgets.dart';

import '../../memories/domain/memory_event.dart';
import '../domain/story_film.dart';
import '../domain/story_template.dart';
import 'templates/story_templates.dart';
import 'templates/story_visuals.dart';

/// A story template as a short film in the Capsule Cinema style: photos
/// drift and zoom, the rope draws from card to card, titles fade in.
class StoryTemplateFilm extends StoryFilm {
  const StoryTemplateFilm({
    required this.template,
    required this.memories,
    this.caption = '',
    this.length,
  });

  final StoryTemplate template;
  final List<MemoryEvent> memories;
  final String caption;

  /// The length the user chose; null for the template's own
  /// ([StoryTemplate.autoSeconds]).
  final Duration? length;

  /// Seconds, between [storyMinSeconds] and [storyMaxSeconds].
  double get seconds {
    final chosen = length;
    if (chosen == null) return template.autoSeconds(memories.length);
    return (chosen.inMilliseconds / 1000).clamp(
      storyMinSeconds.toDouble(),
      storyMaxSeconds.toDouble(),
    );
  }

  /// When each memory comes up, from the start of the film.
  List<Duration> get memoryStarts => [
    for (final start in storyMemoryStarts(template, memories.length, seconds))
      Duration(milliseconds: (start * 1000).round()),
  ];

  @override
  Duration get duration => Duration(milliseconds: (seconds * 1000).round());

  @override
  Widget buildFrame(BuildContext context, Duration time) {
    return StoryPage(
      template: template,
      memories: memories,
      caption: caption,
      motion: StoryMotion.at(
        time.inMicroseconds / Duration.microsecondsPerSecond,
        seconds,
      ),
    );
  }

  @override
  List<ImageProvider> get images => [
    for (final memory in memories) ?storyPhotoFor(memory),
  ];
}
