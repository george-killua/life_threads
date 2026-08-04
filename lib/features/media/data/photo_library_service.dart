import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/app_storage_paths.dart';
import 'picked_memory_photo.dart';

final photoLibraryServiceProvider = Provider<PhotoLibraryService>((ref) {
  return const PhotoLibraryService();
});

class PhotoLibraryService {
  const PhotoLibraryService();

  static final ImagePicker _imagePicker = ImagePicker();

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

    final photosDirectory = await AppStoragePaths.memoryPhotosDirectory(
      create: true,
    );

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

  Future<PickedMemoryPhoto?> capturePhotoToAppStorage() async {
    try {
      final capture = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 4096,
        maxHeight: 4096,
        imageQuality: 96,
      );
      if (capture == null) return null;

      final source = File(capture.path);
      final photosDirectory = await AppStoragePaths.memoryPhotosDirectory(
        create: true,
      );
      final extension = p.extension(capture.path).isEmpty
          ? '.jpg'
          : p.extension(capture.path);
      final fileName = '${const Uuid().v4()}$extension';
      final targetPath = p.join(photosDirectory.path, fileName);
      final copied = await source.copy(targetPath);
      final metadata = await _extractCapturedFileMetadata(copied);

      return PickedMemoryPhoto(
        localPath: copied.path,
        capturedAt: metadata.capturedAt,
        width: metadata.width,
        height: metadata.height,
        hasCapturedDate: metadata.hasCapturedDate,
        hasDimensions: metadata.hasDimensions,
        latitude: metadata.latitude,
        longitude: metadata.longitude,
        title: p.basenameWithoutExtension(capture.name),
      );
    } catch (_) {
      return null;
    }
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

  Future<_PhotoMetadata> _extractCapturedFileMetadata(File file) async {
    final exif = await _exifMetadata(file);
    final dimensions = await _dimensionsFromFile(file);
    final fallbackDate = await _capturedAtFromFile(file);

    return _PhotoMetadata(
      capturedAt: exif.capturedAt ?? fallbackDate.date,
      hasCapturedDate: true,
      width: dimensions.width,
      height: dimensions.height,
      hasDimensions: dimensions.isFromMetadata,
      latitude: exif.latitude,
      longitude: exif.longitude,
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
      final modified = await _capturedAtFromFile(file);
      if (modified.isFromFile) {
        return (date: modified.date, isFromAsset: false);
      }
    } catch (_) {
      // Fall through to a stable app-side timestamp when file metadata fails.
    }

    return (date: DateTime.now(), isFromAsset: false);
  }

  Future<({DateTime date, bool isFromFile})> _capturedAtFromFile(
    File file,
  ) async {
    final modified = await file.lastModified();
    if (_isReasonablePhotoDate(modified)) {
      return (date: modified, isFromFile: true);
    }

    return (date: DateTime.now(), isFromFile: false);
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

  Future<({int width, int height, bool isFromMetadata})> _dimensionsFromFile(
    File file,
  ) async {
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

  Future<_ExifMetadata> _exifMetadata(File file) async {
    try {
      final bytes = await file.readAsBytes();
      if (bytes.length < 2 || bytes[0] != 0xff || bytes[1] != 0xd8) {
        return const _ExifMetadata();
      }

      final exif = img.decodeJpgExif(bytes);
      if (exif == null || exif.isEmpty) return const _ExifMetadata();

      final location = _locationFromExif(exif);
      return _ExifMetadata(
        capturedAt: _capturedAtFromExif(exif),
        latitude: location?.latitude,
        longitude: location?.longitude,
      );
    } catch (_) {
      return const _ExifMetadata();
    }
  }

  DateTime? _capturedAtFromExif(img.ExifData exif) {
    final raw =
        exif.exifIfd['DateTimeOriginal']?.toString() ??
        exif.exifIfd['DateTimeDigitized']?.toString() ??
        exif.imageIfd['DateTime']?.toString();
    if (raw == null) return null;

    final match = RegExp(
      r'^(\d{4}):(\d{2}):(\d{2})[ T](\d{2}):(\d{2}):(\d{2})',
    ).firstMatch(raw.trim().replaceAll('\u0000', ''));
    if (match == null) return null;

    final values = [for (var i = 1; i <= 6; i++) int.tryParse(match.group(i)!)];
    if (values.any((value) => value == null)) return null;
    final year = values[0]!;
    final month = values[1]!;
    final day = values[2]!;
    final hour = values[3]!;
    final minute = values[4]!;
    final second = values[5]!;
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > DateTime(year, month + 1, 0).day) return null;
    if (hour > 23 || minute > 59 || second > 59) return null;

    final date = DateTime(year, month, day, hour, minute, second);
    return _isReasonablePhotoDate(date) ? date : null;
  }

  LatLng? _locationFromExif(img.ExifData exif) {
    final gps = exif.gpsIfd;
    final latitude = _gpsCoordinate(
      gps['GPSLatitude'],
      gps['GPSLatitudeRef']?.toString(),
    );
    final longitude = _gpsCoordinate(
      gps['GPSLongitude'],
      gps['GPSLongitudeRef']?.toString(),
    );

    if (latitude == null || longitude == null) return null;
    if (!_isValidCoordinate(latitude, longitude)) return null;
    return LatLng(latitude: latitude, longitude: longitude);
  }

  double? _gpsCoordinate(img.IfdValue? value, String? direction) {
    if (value == null || value.length < 3) return null;

    final degrees = value.toDouble(0);
    final minutes = value.toDouble(1);
    final seconds = value.toDouble(2);
    if (degrees.isNaN || minutes.isNaN || seconds.isNaN) return null;
    if (degrees < 0 || minutes < 0 || seconds < 0) return null;

    var coordinate = degrees + (minutes / 60) + (seconds / 3600);
    final normalizedDirection = direction?.trim().toUpperCase();
    if (normalizedDirection == 'S' || normalizedDirection == 'W') {
      coordinate = -coordinate;
    }

    return coordinate;
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

class _ExifMetadata {
  const _ExifMetadata({this.capturedAt, this.latitude, this.longitude});

  final DateTime? capturedAt;
  final double? latitude;
  final double? longitude;
}
