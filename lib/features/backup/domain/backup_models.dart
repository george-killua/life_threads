class BackupExportResult {
  const BackupExportResult({
    required this.path,
    required this.memoryCount,
    required this.photoCount,
    required this.wallItemCount,
    required this.isEncrypted,
  });

  final String path;
  final int memoryCount;
  final int photoCount;
  final int wallItemCount;
  final bool isEncrypted;
}

class BackupImportResult {
  const BackupImportResult({
    required this.memoryCount,
    required this.photoCount,
    required this.personCount,
    required this.wallItemCount,
    required this.connectionCount,
  });

  final int memoryCount;
  final int photoCount;
  final int personCount;
  final int wallItemCount;
  final int connectionCount;
}

class BackupImportData {
  const BackupImportData({
    required this.events,
    required this.photos,
    required this.people,
    required this.connections,
    required this.wallItems,
    required this.photoPaths,
  });

  final List<Map<String, Object?>> events;
  final List<Map<String, Object?>> photos;
  final List<Map<String, Object?>> people;
  final List<Map<String, Object?>> connections;
  final List<Map<String, Object?>> wallItems;
  final Map<String, String> photoPaths;
}

class BackupValidationException implements Exception {
  const BackupValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
