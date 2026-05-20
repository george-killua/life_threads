import 'dart:io';

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
    final latLng = asset.latLng ?? await asset.latlngAsync();

    return PickedMemoryPhoto(
      localPath: copied.path,
      originalAssetId: asset.id,
      capturedAt: asset.createDateTime,
      width: asset.orientatedWidth,
      height: asset.orientatedHeight,
      latitude: latLng?.latitude,
      longitude: latLng?.longitude,
      title: asset.title,
    );
  }
}
