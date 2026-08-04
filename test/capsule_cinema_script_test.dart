import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/capsule/domain/memory_capsule_models.dart';
import 'package:life_threads/features/capsule/presentation/capsule_cinema_script.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';

void main() {
  MemoryCapsuleImportDraft draft({
    String title = 'Sunset picnic',
    String description = 'We stayed until the lights came on.',
    String locationLabel = 'Lake shore',
    List<String> related = const ['First train', 'Morning coffee'],
    String feeling = 'warm',
  }) {
    return MemoryCapsuleImportDraft(
      preview: MemoryCapsulePreview(
        title: title,
        description: description,
        locationLabel: locationLabel,
        occurredAt: DateTime(2024, 6, 12),
        photoCount: 1,
        noteCount: 0,
        connectionCount: 0,
        relatedMemoryCount: related.length,
        peopleCount: 0,
        isEncrypted: true,
      ),
      relatedMemoryTitles: related,
      backup: BackupImportData(
        events: [
          {
            'id': 'm1',
            'title': title,
            'description': description,
            'locationLabel': locationLabel,
            'feeling': feeling,
            'coverColorValue': 0xFFE7C995,
            'coverPhotoPath': 'photos/cover.jpg',
            'occurredAt': DateTime(2024, 6, 12).millisecondsSinceEpoch,
          },
        ],
        photos: const [],
        people: const [],
        connections: const [],
        wallItems: const [],
        photoPaths: const {'photos/cover.jpg': '/tmp/cover.jpg'},
      ),
    );
  }

  test('builds full beat list and redistributes near 18s', () {
    final script = CapsuleCinemaScript.fromDraft(draft());

    expect(
      script.beats.map((beat) => beat.kind).toList(),
      [
        CapsuleCinemaBeatKind.seal,
        CapsuleCinemaBeatKind.cover,
        CapsuleCinemaBeatKind.story,
        CapsuleCinemaBeatKind.place,
        CapsuleCinemaBeatKind.thread,
        CapsuleCinemaBeatKind.invite,
      ],
    );
    expect(script.feeling, MemoryFeeling.warm);
    expect(script.coverPhotoPath, '/tmp/cover.jpg');
    expect(script.relatedMemoryTitles, ['First train', 'Morning coffee']);
    expect(
      script.totalDuration.inMilliseconds,
      closeTo(CapsuleCinemaScript.fullTarget.inMilliseconds, 50),
    );
  });

  test('collapses empty story place and thread beats', () {
    final script = CapsuleCinemaScript.fromDraft(
      draft(description: '', locationLabel: '', related: const []),
    );

    expect(
      script.beats.map((beat) => beat.kind).toList(),
      [
        CapsuleCinemaBeatKind.seal,
        CapsuleCinemaBeatKind.cover,
        CapsuleCinemaBeatKind.invite,
      ],
    );
    expect(
      script.totalDuration.inMilliseconds,
      closeTo(CapsuleCinemaScript.fullTarget.inMilliseconds, 50),
    );
  });

  test('reduce motion keeps cover and invite only', () {
    final script = CapsuleCinemaScript.fromDraft(
      draft(),
      reduceMotion: true,
    );

    expect(
      script.beats.map((beat) => beat.kind).toList(),
      [CapsuleCinemaBeatKind.cover, CapsuleCinemaBeatKind.invite],
    );
    expect(
      script.totalDuration.inMilliseconds,
      closeTo(CapsuleCinemaScript.reducedTarget.inMilliseconds, 50),
    );
  });

  test('truncates long stories', () {
    final long = List.filled(40, 'memory').join(' ');
    final script = CapsuleCinemaScript.fromDraft(draft(description: long));
    expect(script.story.length, lessThanOrEqualTo(120));
    expect(script.story.endsWith('…'), isTrue);
  });
}
