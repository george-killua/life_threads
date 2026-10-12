import 'dart:math' as math;

/// The two lengths of the film.
enum YearThreadCut {
  /// 30–45 s: every selected memory gets a calm shot.
  full,

  /// Exactly 20 s, Instagram's story limit: up to [storyMaxMemories]
  /// memories, quicker shots.
  story;

  static const storyMaxMemories = 8;

  /// The memories (in order) this cut shows: all of them for the full film,
  /// for the story an even spread that keeps the first and the last.
  List<T> pick<T>(List<T> memories) {
    if (this == full || memories.length <= storyMaxMemories) {
      return memories;
    }
    final last = memories.length - 1;
    return [
      for (var i = 0; i < storyMaxMemories; i++)
        memories[(i * last / (storyMaxMemories - 1)).round()],
    ];
  }
}

/// Which part of the film a moment belongs to.
enum YearThreadPart { title, shot, closing }

/// Where the film is at a moment: the part, the memory for a shot, and the
/// time since the part started.
class YearThreadMoment {
  const YearThreadMoment({
    required this.part,
    required this.elapsed,
    required this.length,
    this.index = 0,
  });

  final YearThreadPart part;

  /// The shot's memory (0-based); 0 for the title and closing cards.
  final int index;
  final Duration elapsed;
  final Duration length;

  /// 0..1 through the part.
  double get progress => length == Duration.zero
      ? 1
      : (elapsed.inMicroseconds / length.inMicroseconds).clamp(0.0, 1.0);
}

/// The film's schedule: a title card, one shot per memory in date order,
/// then a closing card. Times are whole milliseconds so the parts add up to
/// the duration exactly.
class YearThreadTimeline {
  YearThreadTimeline._(this.title, this.shots, this.closing);

  /// Full film: 4.5 s title, 2.8–6.7 s per memory, 5.5 s closing, so 3 to 12
  /// memories make 30–44 s. Story: 2.5 s title, 3 s closing and the rest of
  /// 20 s shared by the memories.
  factory YearThreadTimeline.build(int memoryCount, YearThreadCut cut) {
    assert(memoryCount > 0, 'A film needs at least one memory');
    final count = math.max(memoryCount, 1);
    switch (cut) {
      case YearThreadCut.full:
        final shot = (30000 / count).round().clamp(2800, 6700);
        return YearThreadTimeline._(
          const Duration(milliseconds: 4500),
          List.filled(count, Duration(milliseconds: shot)),
          const Duration(milliseconds: 5500),
        );
      case YearThreadCut.story:
        const title = 2500;
        const closing = 3000;
        const shots = storyLength - title - closing;
        final shot = shots ~/ count;
        return YearThreadTimeline._(
          const Duration(milliseconds: title),
          [
            for (var i = 0; i < count; i++)
              // The last shot takes the remainder: exactly 20 s in total.
              Duration(
                milliseconds: i == count - 1
                    ? shots - shot * (count - 1)
                    : shot,
              ),
          ],
          const Duration(milliseconds: closing),
        );
    }
  }

  static const storyLength = 20000;

  /// How long the camera takes to travel to the next memory while the rope
  /// draws to it, at the start of every shot after the first.
  static Duration transitionOf(Duration shot) =>
      Duration(milliseconds: math.min(900, shot.inMilliseconds * 35 ~/ 100));

  /// The title card's last moments cross-fade into the first shot.
  static const titleFadeOut = Duration(milliseconds: 700);

  final Duration title;
  final List<Duration> shots;
  final Duration closing;

  Duration get total => shots.fold(title, (sum, shot) => sum + shot) + closing;

  Duration shotStart(int index) {
    var start = title;
    for (var i = 0; i < index; i++) {
      start += shots[i];
    }
    return start;
  }

  Duration get closingStart => total - closing;

  YearThreadMoment at(Duration time) {
    if (time < title) {
      return YearThreadMoment(
        part: YearThreadPart.title,
        elapsed: time < Duration.zero ? Duration.zero : time,
        length: title,
      );
    }
    var start = title;
    for (var i = 0; i < shots.length; i++) {
      if (time < start + shots[i]) {
        return YearThreadMoment(
          part: YearThreadPart.shot,
          index: i,
          elapsed: time - start,
          length: shots[i],
        );
      }
      start += shots[i];
    }
    final elapsed = time - start;
    return YearThreadMoment(
      part: YearThreadPart.closing,
      elapsed: elapsed > closing ? closing : elapsed,
      length: closing,
    );
  }
}
