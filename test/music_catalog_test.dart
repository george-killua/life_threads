import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/stories/data/music_catalog.dart';
import 'package:path/path.dart' as p;

void main() {
  final licenses = File('assets/music/LICENSES.md').readAsStringSync();
  final rows = licenses
      .split('\n')
      .where((line) => line.startsWith('| `'))
      .toList();

  test('every bundled track is an AAC file in assets/music', () {
    final ids = <String>{};
    for (final track in bundledMusicTracks) {
      expect(ids.add(track.id), isTrue, reason: 'duplicate id ${track.id}');
      expect(track.assetPath, startsWith('assets/music/'));
      expect(p.extension(track.assetPath), '.m4a');
      expect(File(track.assetPath).existsSync(), isTrue, reason: track.id);
      expect(track.license, isNotEmpty);
      expect(track.sourceUrl, isNotEmpty);
    }
  });

  test('LICENSES.md has a row for every bundled track', () {
    for (final track in bundledMusicTracks) {
      final file = p.basename(track.assetPath);
      final row = rows.where((row) => row.startsWith('| `$file`'));
      expect(row, hasLength(1), reason: '$file is missing in LICENSES.md');
      expect(row.single, contains(track.title));
      expect(row.single, contains(track.license));
    }
  });

  test('every audio file in assets/music is in the catalog', () {
    final bundled = bundledMusicTracks.map((t) => t.assetPath).toSet();
    final files = Directory('assets/music')
        .listSync()
        .whereType<File>()
        .map((file) => 'assets/music/${p.basename(file.path)}')
        .where((path) => !path.endsWith('.md'));
    for (final path in files) {
      expect(bundled, contains(path), reason: '$path has no catalog entry');
    }
  });
}
