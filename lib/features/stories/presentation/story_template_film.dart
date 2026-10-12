import 'package:flutter/widgets.dart';

import '../../memories/domain/memory_event.dart';
import '../domain/story_film.dart';
import '../domain/story_template.dart';
import 'templates/story_templates.dart';
import 'templates/story_visuals.dart';

/// A story template as a 15–20 s film in the Capsule Cinema style: photos
/// drift and zoom, the rope draws from card to card, titles fade in.
class StoryTemplateFilm extends StoryFilm {
  const StoryTemplateFilm({
    required this.template,
    required this.memories,
    this.caption = '',
  });

  final StoryTemplate template;
  final List<MemoryEvent> memories;
  final String caption;

  /// Seconds, within Instagram's 20 s story limit.
  double get seconds {
    final count = memories.length;
    final value = switch (template) {
      // About 4 s per memory when the film shows them in turn.
      StoryTemplate.single => count * 4.0,
      StoryTemplate.thread => 9 + count * 1.6,
      StoryTemplate.collage => 13 + count * 0.6,
      StoryTemplate.quote => 15.0,
    };
    return value.clamp(15.0, 20.0);
  }

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
