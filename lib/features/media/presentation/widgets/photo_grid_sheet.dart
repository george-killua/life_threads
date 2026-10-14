import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';

/// Picks photos from the recent library photos; pops the newly selected
/// assets.
class PhotoGridSheet extends StatefulWidget {
  const PhotoGridSheet({
    super.key,
    required this.assets,
    required this.initiallySelectedIds,
    required this.isLimited,
    required this.onManageLimitedAccess,
  });

  final List<AssetEntity> assets;
  final Set<String> initiallySelectedIds;
  final bool isLimited;
  final Future<void> Function() onManageLimitedAccess;

  @override
  State<PhotoGridSheet> createState() => _PhotoGridSheetState();
}

class _PhotoGridSheetState extends State<PhotoGridSheet> {
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = {...widget.initiallySelectedIds};
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.78,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedIds.isEmpty
                        ? context.l10n.selectPhotos
                        : context.l10n.newSelected(_newSelectionCount()),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (widget.isLimited)
                  TextButton(
                    onPressed: () async {
                      await widget.onManageLimitedAccess();
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: Text(context.l10n.manageAccess),
                  ),
                FilledButton(
                  onPressed: _newSelectionCount() == 0
                      ? null
                      : () => Navigator.of(context).pop(_selectedAssets()),
                  child: Text(context.l10n.useSelected),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.assets.isEmpty
                ? Center(child: Text(context.l10n.noPhotosFound))
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: widget.assets.length,
                    itemBuilder: (context, index) {
                      final asset = widget.assets[index];
                      final selected = _selectedIds.contains(asset.id);
                      final alreadyAdded = widget.initiallySelectedIds.contains(
                        asset.id,
                      );
                      return GestureDetector(
                        onTap: alreadyAdded
                            ? null
                            : () => setState(() {
                                if (selected) {
                                  _selectedIds.remove(asset.id);
                                } else {
                                  _selectedIds.add(asset.id);
                                }
                              }),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _AssetThumbnail(asset: asset),
                              if (selected || alreadyAdded)
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.wallInk.withValues(
                                      alpha: alreadyAdded ? 0.62 : 0.36,
                                    ),
                                    border: Border.all(
                                      color: alreadyAdded
                                          ? AppColors.muted
                                          : AppColors.gold,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              Positioned(
                                right: 7,
                                top: 7,
                                child: _SelectionBadge(
                                  selected: selected,
                                  alreadyAdded: alreadyAdded,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  int _newSelectionCount() {
    return _selectedIds
        .where((id) => !widget.initiallySelectedIds.contains(id))
        .length;
  }

  List<AssetEntity> _selectedAssets() {
    return widget.assets
        .where(
          (asset) =>
              _selectedIds.contains(asset.id) &&
              !widget.initiallySelectedIds.contains(asset.id),
        )
        .toList();
  }
}

class _SelectionBadge extends StatelessWidget {
  const _SelectionBadge({required this.selected, required this.alreadyAdded});

  final bool selected;
  final bool alreadyAdded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected || alreadyAdded ? AppColors.gold : Colors.black45,
        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),
      child: Icon(
        alreadyAdded
            ? Icons.done_all_rounded
            : selected
            ? Icons.check_rounded
            : Icons.add_rounded,
        size: 17,
        color: selected || alreadyAdded ? AppColors.paperInk : AppColors.text,
      ),
    );
  }
}

class _AssetThumbnail extends StatelessWidget {
  const _AssetThumbnail({required this.asset});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(const ThumbnailSize.square(320)),
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) {
          return Container(
            color: AppColors.wallDeep,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return Image.memory(bytes, fit: BoxFit.cover);
      },
    );
  }
}

/// Explains that photo access is off, with a way to the system settings.
class PhotoPermissionDeniedSheet extends StatelessWidget {
  const PhotoPermissionDeniedSheet({super.key, required this.onOpenSettings});

  final Future<void> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_rounded, color: AppColors.gold, size: 42),
          const SizedBox(height: 14),
          Text(
            context.l10n.photoAccessOff,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.photoAccessOffBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, height: 1.45),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await onOpenSettings();
              },
              child: Text(context.l10n.openSettings),
            ),
          ),
        ],
      ),
    );
  }
}
