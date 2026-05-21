import '../../backup/domain/backup_models.dart';

class MemoryCapsuleExportResult {
  const MemoryCapsuleExportResult({
    required this.path,
    required this.title,
    required this.photoCount,
    required this.noteCount,
    required this.connectionCount,
    required this.isEncrypted,
  });

  final String path;
  final String title;
  final int photoCount;
  final int noteCount;
  final int connectionCount;
  final bool isEncrypted;
}

class MemoryCapsulePreview {
  const MemoryCapsulePreview({
    required this.title,
    required this.description,
    required this.locationLabel,
    required this.occurredAt,
    required this.photoCount,
    required this.noteCount,
    required this.connectionCount,
    required this.relatedMemoryCount,
    required this.peopleCount,
    required this.isEncrypted,
  });

  final String title;
  final String description;
  final String locationLabel;
  final DateTime occurredAt;
  final int photoCount;
  final int noteCount;
  final int connectionCount;
  final int relatedMemoryCount;
  final int peopleCount;
  final bool isEncrypted;
}

class MemoryCapsuleImportDraft {
  const MemoryCapsuleImportDraft({required this.preview, required this.backup});

  final MemoryCapsulePreview preview;
  final BackupImportData backup;
}
