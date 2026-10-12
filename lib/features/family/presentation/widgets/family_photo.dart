import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../family_providers.dart';

/// A decrypted family photo, loaded through the family service.
class FamilyPhoto extends ConsumerWidget {
  const FamilyPhoto({
    super.key,
    required this.familyId,
    required this.photoId,
    this.fit = BoxFit.cover,
  });

  final String familyId;
  final String photoId;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(
      familyPhotoProvider((familyId: familyId, photoId: photoId)),
    );
    return file.when(
      loading: () => const ColoredBox(
        color: AppColors.wallDeep,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, _) => const _Missing(),
      data: (file) => Image.file(
        file,
        fit: fit,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => const _Missing(),
      ),
    );
  }
}

class _Missing extends StatelessWidget {
  const _Missing();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.wallDeep,
      child: Center(
        child: Icon(Icons.broken_image_rounded, color: AppColors.muted),
      ),
    );
  }
}
