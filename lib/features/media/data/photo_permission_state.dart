import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import 'photo_library_service.dart';

final photoPermissionProvider = FutureProvider<PermissionState>((ref) {
  return ref.read(photoLibraryServiceProvider).currentPermission();
});
