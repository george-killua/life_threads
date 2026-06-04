import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AppStoragePaths {
  const AppStoragePaths._();

  static const memoryPhotosDirectoryName = 'memory_photos';

  static Future<String> documentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<Directory> memoryPhotosDirectory({bool create = false}) async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(
      p.join(documents.path, memoryPhotosDirectoryName),
    );
    if (create && !await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  static String? persistOptionalPhotoPath(String? path, String documentsPath) {
    if (path == null || path.isEmpty) return null;
    return persistPhotoPath(path, documentsPath);
  }

  static String persistPhotoPath(String path, String documentsPath) {
    if (path.isEmpty || path.startsWith('assets/') || !p.isAbsolute(path)) {
      return path;
    }

    final normalizedPath = p.normalize(path);
    final normalizedDocumentsPath = p.normalize(documentsPath);
    if (p.isWithin(normalizedDocumentsPath, normalizedPath)) {
      return p.relative(normalizedPath, from: normalizedDocumentsPath);
    }

    final memoryPhotoPath = _memoryPhotoRelativePath(normalizedPath);
    return memoryPhotoPath ?? path;
  }

  static String? resolveOptionalPhotoPath(
    String? storedPath,
    String documentsPath,
  ) {
    if (storedPath == null || storedPath.isEmpty) return null;
    return resolvePhotoPath(storedPath, documentsPath);
  }

  static String resolvePhotoPath(String storedPath, String documentsPath) {
    if (storedPath.isEmpty) return storedPath;
    if (storedPath.startsWith('assets/')) return storedPath;

    if (!p.isAbsolute(storedPath)) {
      return p.normalize(p.join(documentsPath, storedPath));
    }

    if (File(storedPath).existsSync()) return storedPath;

    final memoryPhotoPath = _memoryPhotoRelativePath(storedPath);
    if (memoryPhotoPath == null) return storedPath;
    return p.normalize(p.join(documentsPath, memoryPhotoPath));
  }

  static String? _memoryPhotoRelativePath(String path) {
    final segments = p.split(p.normalize(path));
    final index = segments.lastIndexOf(memoryPhotosDirectoryName);
    if (index == -1) return null;
    return p.joinAll(segments.sublist(index));
  }
}
