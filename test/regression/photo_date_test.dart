// An asset without a creation date (reported as 0) must not be dated 1970.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/media/data/photo_library_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePaths extends PathProviderPlatform with MockPlatformInterfaceMixin {
  FakePaths(this.dir);
  final String dir;
  @override
  Future<String?> getApplicationDocumentsPath() async => dir;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'asset without a creation date is not reported as captured on 1970-01-01',
    () async {
      final tmp = await Directory.systemTemp.createTemp('p4_media');
      final src = File('${tmp.path}/IMG_1.jpg')
        ..writeAsBytesSync([0xff, 0xd8, 0xff, 0xd9]);
      PathProviderPlatform.instance = FakePaths('${tmp.path}/docs');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('com.fluttercandies/photo_manager'),
            (call) async => call.method == 'getFullFile' ? src.path : null,
          );

      final asset = AssetEntity(id: '1', typeInt: 1, width: 100, height: 100);
      final photo = await const PhotoLibraryService().copyAssetToAppStorage(
        asset,
      );

      expect(photo, isNotNull);
      expect(
        photo!.capturedAt.year == 1970 && photo.hasCapturedDate,
        isFalse,
        reason:
            'capturedAt=${photo.capturedAt} hasCapturedDate=${photo.hasCapturedDate}',
      );
    },
  );
}
