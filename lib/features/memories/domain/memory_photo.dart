class MemoryPhoto {
  const MemoryPhoto({
    required this.id,
    required this.eventId,
    required this.localPath,
    required this.capturedAt,
    required this.width,
    required this.height,
    this.originalAssetId,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String eventId;
  final String localPath;
  final String? originalAssetId;
  final DateTime capturedAt;
  final double? latitude;
  final double? longitude;
  final int width;
  final int height;
}
