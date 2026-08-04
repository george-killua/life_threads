import '../../memories/domain/memory_feeling.dart';
import '../domain/memory_capsule_models.dart';

enum CapsuleCinemaBeatKind {
  seal,
  cover,
  story,
  place,
  thread,
  invite,
}

class CapsuleCinemaBeat {
  const CapsuleCinemaBeat({
    required this.kind,
    required this.duration,
  });

  final CapsuleCinemaBeatKind kind;
  final Duration duration;
}

class CapsuleCinemaScript {
  const CapsuleCinemaScript({
    required this.title,
    required this.story,
    required this.locationLabel,
    required this.feeling,
    required this.coverColorValue,
    required this.coverPhotoPath,
    required this.relatedMemoryTitles,
    required this.beats,
  });

  final String title;
  final String story;
  final String locationLabel;
  final MemoryFeeling feeling;
  final int coverColorValue;
  final String? coverPhotoPath;
  final List<String> relatedMemoryTitles;
  final List<CapsuleCinemaBeat> beats;

  static const storyMaxChars = 120;
  static const fullTarget = Duration(milliseconds: 18000);
  static const reducedTarget = Duration(milliseconds: 6000);

  factory CapsuleCinemaScript.fromDraft(
    MemoryCapsuleImportDraft draft, {
    bool reduceMotion = false,
  }) {
    final event = draft.backup.events.isEmpty
        ? const <String, Object?>{}
        : draft.backup.events.first;
    final title = _string(event['title']).isEmpty
        ? draft.preview.title
        : _string(event['title']);
    final story = _truncateStory(
      _string(event['description']).isEmpty
          ? draft.preview.description
          : _string(event['description']),
    );
    final locationLabel = _string(event['locationLabel']).isEmpty
        ? draft.preview.locationLabel
        : _string(event['locationLabel']);
    final feeling = MemoryFeeling.fromName(_string(event['feeling']));
    final coverColorValue = event['coverColorValue'] is int
        ? event['coverColorValue'] as int
        : 0xFFE7C995;
    final coverArchivePath = _string(event['coverPhotoPath']);
    final coverPhotoPath = coverArchivePath.isEmpty
        ? null
        : draft.backup.photoPaths[coverArchivePath];
    final relatedTitles = draft.relatedMemoryTitles
        .map((title) => title.trim())
        .where((title) => title.isNotEmpty)
        .toList(growable: false);

    if (reduceMotion) {
      return CapsuleCinemaScript(
        title: title,
        story: story,
        locationLabel: locationLabel,
        feeling: feeling,
        coverColorValue: coverColorValue,
        coverPhotoPath: coverPhotoPath,
        relatedMemoryTitles: relatedTitles,
        beats: _redistribute(const [
          CapsuleCinemaBeat(
            kind: CapsuleCinemaBeatKind.cover,
            duration: Duration(milliseconds: 4000),
          ),
          CapsuleCinemaBeat(
            kind: CapsuleCinemaBeatKind.invite,
            duration: Duration(milliseconds: 2000),
          ),
        ], reducedTarget),
      );
    }

    final rawBeats = <CapsuleCinemaBeat>[
      const CapsuleCinemaBeat(
        kind: CapsuleCinemaBeatKind.seal,
        duration: Duration(milliseconds: 2000),
      ),
      const CapsuleCinemaBeat(
        kind: CapsuleCinemaBeatKind.cover,
        duration: Duration(milliseconds: 5000),
      ),
      if (story.isNotEmpty)
        const CapsuleCinemaBeat(
          kind: CapsuleCinemaBeatKind.story,
          duration: Duration(milliseconds: 4000),
        ),
      if (locationLabel.isNotEmpty)
        const CapsuleCinemaBeat(
          kind: CapsuleCinemaBeatKind.place,
          duration: Duration(milliseconds: 3000),
        ),
      if (relatedTitles.isNotEmpty)
        const CapsuleCinemaBeat(
          kind: CapsuleCinemaBeatKind.thread,
          duration: Duration(milliseconds: 3000),
        ),
      const CapsuleCinemaBeat(
        kind: CapsuleCinemaBeatKind.invite,
        duration: Duration(milliseconds: 1000),
      ),
    ];

    return CapsuleCinemaScript(
      title: title,
      story: story,
      locationLabel: locationLabel,
      feeling: feeling,
      coverColorValue: coverColorValue,
      coverPhotoPath: coverPhotoPath,
      relatedMemoryTitles: relatedTitles,
      beats: _redistribute(rawBeats, fullTarget),
    );
  }

  Duration get totalDuration => beats.fold<Duration>(
    Duration.zero,
    (total, beat) => total + beat.duration,
  );

  static List<CapsuleCinemaBeat> _redistribute(
    List<CapsuleCinemaBeat> beats,
    Duration target,
  ) {
    if (beats.isEmpty) return const [];
    final currentMs = beats.fold<int>(
      0,
      (sum, beat) => sum + beat.duration.inMilliseconds,
    );
    if (currentMs <= 0) return beats;
    final scale = target.inMilliseconds / currentMs;
    return [
      for (final beat in beats)
        CapsuleCinemaBeat(
          kind: beat.kind,
          duration: Duration(
            milliseconds: (beat.duration.inMilliseconds * scale).round().clamp(
              400,
              target.inMilliseconds,
            ),
          ),
        ),
    ];
  }

  static String _truncateStory(String value) {
    final trimmed = value.trim();
    if (trimmed.length <= storyMaxChars) return trimmed;
    return '${trimmed.substring(0, storyMaxChars - 1).trimRight()}…';
  }

  static String _string(Object? value) {
    if (value is String) return value.trim();
    return '';
  }
}
