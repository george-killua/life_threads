import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/core/storage/app_storage_paths.dart';

void main() {
  group('AppStoragePaths', () {
    const documentsPath =
        '/var/mobile/Containers/Data/Application/NEW/Documents';

    test('stores current app photo paths relative to Documents', () {
      final stored = AppStoragePaths.persistPhotoPath(
        '$documentsPath/memory_photos/photo.jpg',
        documentsPath,
      );

      expect(stored, 'memory_photos/photo.jpg');
    });

    test('resolves stored relative photo paths under current Documents', () {
      final resolved = AppStoragePaths.resolvePhotoPath(
        'memory_photos/photo.jpg',
        documentsPath,
      );

      expect(resolved, '$documentsPath/memory_photos/photo.jpg');
    });

    test('keeps bundled asset photo paths unchanged', () {
      const assetPath = 'assets/demo_people/family_table.jpg';

      expect(
        AppStoragePaths.persistPhotoPath(assetPath, documentsPath),
        assetPath,
      );
      expect(
        AppStoragePaths.resolvePhotoPath(assetPath, documentsPath),
        assetPath,
      );
    });

    test('repairs stale iOS app container photo paths', () {
      final resolved = AppStoragePaths.resolvePhotoPath(
        '/var/mobile/Containers/Data/Application/OLD/Documents/'
        'memory_photos/photo.jpg',
        documentsPath,
      );

      expect(resolved, '$documentsPath/memory_photos/photo.jpg');
    });
  });
}
