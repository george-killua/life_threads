import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

import 'picked_memory_photo.dart';

final photoLibraryServiceProvider = Provider<PhotoLibraryService>((ref) {
  return const PhotoLibraryService();
});

class PhotoLibraryService {
  const PhotoLibraryService();

  static const _permissionOption = PermissionRequestOption(
    androidPermission: AndroidPermission(
      type: RequestType.image,
      mediaLocation: true,
    ),
  );

  Future<PermissionState> currentPermission() {
    return PhotoManager.getPermissionState(requestOption: _permissionOption);
  }

  Future<PermissionState> requestPermission() {
    return PhotoManager.requestPermissionExtend(
      requestOption: _permissionOption,
    );
  }

  Future<void> openSettings() => PhotoManager.openSetting();

  Future<void> manageLimitedSelection() async {
    try {
      await PhotoManager.presentLimited(type: RequestType.image);
    } catch (_) {
      await openSettings();
    }
  }

  Future<List<AssetEntity>> recentPhotos({int limit = 80}) async {
    final albums = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    if (albums.isEmpty) return [];
    return albums.first.getAssetListPaged(page: 0, size: limit);
  }

  Future<PickedMemoryPhoto?> copyAssetToAppStorage(AssetEntity asset) async {
    final source = await asset.file;
    if (source == null) return null;

    final documents = await getApplicationDocumentsDirectory();
    final photosDirectory = Directory(p.join(documents.path, 'memory_photos'));
    if (!photosDirectory.existsSync()) {
      await photosDirectory.create(recursive: true);
    }

    final extension = p.extension(source.path).isEmpty
        ? '.jpg'
        : p.extension(source.path);
    final fileName = '${const Uuid().v4()}$extension';
    final targetPath = p.join(photosDirectory.path, fileName);
    final copied = await source.copy(targetPath);
    final metadata = await _extractMetadata(asset, source);

    return PickedMemoryPhoto(
      localPath: copied.path,
      originalAssetId: asset.id,
      capturedAt: metadata.capturedAt,
      width: metadata.width,
      height: metadata.height,
      hasCapturedDate: metadata.hasCapturedDate,
      hasDimensions: metadata.hasDimensions,
      latitude: metadata.latitude,
      longitude: metadata.longitude,
      title: asset.title,
    );
  }

  Future<List<PickedMemoryPhoto>> copyAssetsToAppStorage(
    Iterable<AssetEntity> assets,
  ) async {
    final copied = <PickedMemoryPhoto>[];
    for (final asset in assets) {
      final photo = await copyAssetToAppStorage(asset);
      if (photo != null) copied.add(photo);
    }
    return copied;
  }

  Future<_PhotoMetadata> _extractMetadata(AssetEntity asset, File file) async {
    final capturedAt = await _capturedAt(asset, file);
    final dimensions = await _dimensions(asset, file);
    final location = await _location(asset);

    return _PhotoMetadata(
      capturedAt: capturedAt.date,
      hasCapturedDate: capturedAt.isFromAsset,
      width: dimensions.width,
      height: dimensions.height,
      hasDimensions: dimensions.isFromMetadata,
      latitude: location?.latitude,
      longitude: location?.longitude,
    );
  }

  Future<({DateTime date, bool isFromAsset})> _capturedAt(
    AssetEntity asset,
    File file,
  ) async {
    final assetDate = asset.createDateTime;
    if (_isReasonablePhotoDate(assetDate)) {
      return (date: assetDate, isFromAsset: true);
    }

    try {
      final modified = await file.lastModified();
      if (_isReasonablePhotoDate(modified)) {
        return (date: modified, isFromAsset: false);
      }
    } catch (_) {
      // Fall through to a stable app-side timestamp when file metadata fails.
    }

    return (date: DateTime.now(), isFromAsset: false);
  }

  Future<({int width, int height, bool isFromMetadata})> _dimensions(
    AssetEntity asset,
    File file,
  ) async {
    final assetWidth = asset.orientatedWidth > 0
        ? asset.orientatedWidth
        : asset.width;
    final assetHeight = asset.orientatedHeight > 0
        ? asset.orientatedHeight
        : asset.height;

    if (assetWidth > 0 && assetHeight > 0) {
      return (width: assetWidth, height: assetHeight, isFromMetadata: true);
    }

    try {
      final decoded = await _decodeImageSize(file);
      if (decoded != null) {
        return (
          width: decoded.width,
          height: decoded.height,
          isFromMetadata: true,
        );
      }
    } catch (_) {
      // Keep memory creation working even for unusual or unsupported files.
    }

    return (width: 1, height: 1, isFromMetadata: false);
  }

  Future<({int width, int height})?> _decodeImageSize(File file) async {
    final bytes = await file.readAsBytes();
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final width = descriptor.width;
    final height = descriptor.height;
    descriptor.dispose();
    buffer.dispose();
    if (width <= 0 || height <= 0) return null;
    return (width: width, height: height);
  }

  Future<LatLng?> _location(AssetEntity asset) async {
    final location = asset.latLng ?? await asset.latlngAsync();
    if (location == null) return null;
    if (!_isValidCoordinate(location.latitude, location.longitude)) {
      return null;
    }
    return location;
  }

  bool _isReasonablePhotoDate(DateTime date) {
    final lowerBound = DateTime(1900);
    final upperBound = DateTime.now().add(const Duration(days: 1));
    return date.isAfter(lowerBound) && date.isBefore(upperBound);
  }

  bool _isValidCoordinate(double latitude, double longitude) {
    if (latitude < -90 || latitude > 90) return false;
    if (longitude < -180 || longitude > 180) return false;
    return latitude.abs() > 0.000001 || longitude.abs() > 0.000001;
  }
}

class _PhotoMetadata {
  const _PhotoMetadata({
    required this.capturedAt,
    required this.hasCapturedDate,
    required this.width,
    required this.height,
    required this.hasDimensions,
    this.latitude,
    this.longitude,
  });

  final DateTime capturedAt;
  final bool hasCapturedDate;
  final int width;
  final int height;
  final bool hasDimensions;
  final double? latitude;
  final double? longitude;
}
