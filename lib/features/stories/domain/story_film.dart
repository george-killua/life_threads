import 'package:flutter/widgets.dart';

/// A short vertical film rendered frame by frame into a video: story
/// videos and Thread of the Year.
///
/// Frames are rendered offscreen with [StoryCanvas] (animations are frozen
/// there), so [buildFrame] must draw the whole frame from [time] alone.
abstract class StoryFilm {
  const StoryFilm();

  Duration get duration;

  int get fps => 30;

  /// The frame [time] after the start, at the story size (360×640 logical,
  /// rendered at 1080×1920). Must be deterministic: the same [time] always
  /// gives the same picture.
  Widget buildFrame(BuildContext context, Duration time);

  /// Images the frames show, decoded once before the first frame.
  List<ImageProvider> get images => const [];

  int get frameCount => (duration.inMicroseconds * fps / 1000000).round();
}
