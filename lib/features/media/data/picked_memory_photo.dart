class PickedMemoryPhoto {
  const PickedMemoryPhoto({
    required this.localPath,
    required this.originalAssetId,
    required this.capturedAt,
    required this.width,
    required this.height,
    this.latitude,
    this.longitude,
    this.title,
  });

  final String localPath;
  final String originalAssetId;
  final DateTime capturedAt;
  final int width;
  final int height;
  final double? latitude;
  final double? longitude;
  final String? title;
}
