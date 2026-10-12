import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Where exported story images and videos live: a folder in the temporary
/// directory, never in the app's backed-up documents. Like backup archives,
/// the files are deleted before the next export and on the next app start,
/// once the receiving app (or the photo library) has its copy.
class StoryFiles {
  const StoryFiles({Future<Directory> Function()? temporaryDirectory})
    : _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;

  final Future<Directory> Function() _temporaryDirectory;

  static const folderName = 'lifethreads_stories';

  Future<Directory> directory({bool create = true}) async {
    final temp = await _temporaryDirectory();
    final directory = Directory(p.join(temp.path, folderName));
    if (create && !await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  /// A new file name in [directory], e.g. `lifethreads_story_20261012T101500.mp4`.
  Future<File> newFile(String extension) async {
    final dir = await directory();
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '')
        .replaceAll('-', '')
        .replaceAll('.', '_');
    return File(p.join(dir.path, 'lifethreads_story_$stamp.$extension'));
  }

  /// Deletes every exported story file (and leftover music copies).
  Future<void> deleteExportedStories() async {
    final dir = await directory(create: false);
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}
