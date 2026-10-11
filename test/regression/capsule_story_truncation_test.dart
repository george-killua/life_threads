import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/capsule/domain/memory_capsule_models.dart';
import 'package:life_threads/features/capsule/presentation/capsule_cinema_script.dart';

bool wellFormedUtf16(String s) {
  for (var i = 0; i < s.length; i++) {
    final c = s.codeUnitAt(i);
    if (c >= 0xD800 && c <= 0xDBFF) {
      if (i + 1 >= s.length) return false;
      final n = s.codeUnitAt(i + 1);
      if (n < 0xDC00 || n > 0xDFFF) return false;
      i++;
    } else if (c >= 0xDC00 && c <= 0xDFFF) {
      return false;
    }
  }
  return true;
}

void main() {
  test('story truncation must not split an emoji surrogate pair', () {
    // 118 ASCII chars then emoji: the cut at index 119 lands between the
    // high and low surrogate of the emoji.
    final description = '${'a' * 118}\u{1F496}${'b' * 20}';
    final draft = MemoryCapsuleImportDraft(
      preview: MemoryCapsulePreview(
        title: 'T',
        description: description,
        locationLabel: '',
        occurredAt: DateTime(2024, 6, 12),
        photoCount: 0,
        noteCount: 0,
        connectionCount: 0,
        relatedMemoryCount: 0,
        peopleCount: 0,
        isEncrypted: true,
      ),
      relatedMemoryTitles: const [],
      backup: BackupImportData(
        events: [
          {'id': 'm1', 'title': 'T', 'description': description},
        ],
        photos: const [],
        people: const [],
        connections: const [],
        wallItems: const [],
        photoPaths: const {},
      ),
    );
    final script = CapsuleCinemaScript.fromDraft(draft);
    expect(
      wellFormedUtf16(script.story),
      isTrue,
      reason:
          'story ends with code units ${script.story.codeUnits.skip(116).map((c) => c.toRadixString(16)).toList()}',
    );
  });
}
