import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../media/data/photo_library_service.dart';
import '../../../media/data/picked_memory_photo.dart';
import '../../data/memory_repository.dart';
import '../../domain/memory_category.dart';
import '../../domain/memory_event.dart';
import '../../domain/memory_feeling.dart';
import '../../domain/memory_photo.dart';
import '../../domain/memory_person.dart';
import '../../domain/memory_type.dart';
import '../widgets/memory_people_editor.dart';

class EditMemoryPage extends ConsumerStatefulWidget {
  const EditMemoryPage({super.key, required this.memoryId});

  final String memoryId;

  @override
  ConsumerState<EditMemoryPage> createState() => _EditMemoryPageState();
}

class _EditMemoryPageState extends ConsumerState<EditMemoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final List<_EditablePhoto> _photos = [];
  List<MemoryPersonDraft> _people = [];

  MemoryCategory _category = MemoryCategory.personal;
  MemoryType _memoryType = MemoryType.moment;
  MemoryFeeling _feeling = MemoryFeeling.warm;
  DateTime? _occurredAt;
  double? _latitude;
  double? _longitude;
  String? _coverPhotoPath;
  bool _initialized = false;
  bool _isPicking = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memoryState = ref.watch(memoryRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Memory')),
      body: memoryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (state) {
          final event = state.findEvent(widget.memoryId);
          if (event == null) {
            return const Center(child: Text('Memory not found'));
          }
          _init(
            event,
            state.photosForEvent(widget.memoryId),
            state.peopleForEvent(widget.memoryId),
          );

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              children: [
                _CoverPicker(
                  path: _coverPhotoPath,
                  isPicking: _isPicking,
                  onPick: () => _pickPhotos(setFirstAsCover: true),
                  onClear: _coverPhotoPath == null
                      ? null
                      : () => setState(() => _coverPhotoPath = null),
                ),
                const SizedBox(height: 22),
                _EditPanel(
                  title: 'Story',
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Memory title',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Add a title'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 4,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          labelText: 'Story / description',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Add a short story'
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _EditPanel(
                  title: 'Shape and feeling',
                  child: Column(
                    children: [
                      DropdownButtonFormField<MemoryType>(
                        initialValue: _memoryType,
                        decoration: const InputDecoration(
                          labelText: 'Memory type',
                        ),
                        items: MemoryType.values
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(
                          () => _memoryType = value ?? MemoryType.moment,
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<MemoryFeeling>(
                        initialValue: _feeling,
                        decoration: const InputDecoration(labelText: 'Feeling'),
                        items: MemoryFeeling.values
                            .map(
                              (feeling) => DropdownMenuItem(
                                value: feeling,
                                child: Row(
                                  children: [
                                    Icon(
                                      feeling.icon,
                                      color: feeling.color,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(feeling.label),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _feeling = value ?? _feeling),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<MemoryCategory>(
                        initialValue: _category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: MemoryCategory.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(
                          () => _category = value ?? MemoryCategory.personal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _EditPanel(
                  title: 'Time and place',
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.event_rounded,
                          color: AppColors.gold,
                        ),
                        title: Text(
                          _dateLabel(_occurredAt ?? event.occurredAt),
                        ),
                        subtitle: const Text('Memory date'),
                        trailing: const Icon(Icons.edit_calendar_rounded),
                        onTap: () => _pickDate(event.occurredAt),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          hintText: 'Linz, Austria',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Add a location'
                            : null,
                      ),
                      if (_latitude != null && _longitude != null) ...[
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Map point: ${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}',
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _EditPanel(
                  title: 'People',
                  child: MemoryPeopleEditor(
                    people: _people,
                    onChanged: (people) => setState(() => _people = people),
                  ),
                ),
                const SizedBox(height: 16),
                _EditPanel(
                  title: 'Gallery',
                  trailing: TextButton.icon(
                    onPressed: _isPicking ? null : _pickPhotos,
                    icon: _isPicking
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add_photo_alternate_rounded),
                    label: const Text('Add photos'),
                  ),
                  child: _GalleryEditor(
                    photos: _photos,
                    coverPhotoPath: _coverPhotoPath,
                    onSetCover: (photo) =>
                        setState(() => _coverPhotoPath = photo.localPath),
                    onReplace: _replacePhoto,
                    onRemove: _removePhoto,
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: _isSaving ? null : () => _save(context),
                  icon: _isSaving
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded),
                  label: const Text('Save memory'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _init(
    MemoryEvent event,
    List<MemoryPhoto> photos,
    List<MemoryPerson> people,
  ) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _locationController.text = event.locationLabel;
    _category = event.category;
    _memoryType = event.memoryType;
    _feeling = event.feeling;
    _occurredAt = event.occurredAt;
    _latitude = event.latitude;
    _longitude = event.longitude;
    _coverPhotoPath = event.coverPhotoPath;
    _photos
      ..clear()
      ..addAll(photos.map(_EditablePhoto.fromMemoryPhoto));
    _people = people.map(_personToDraft).toList();

    if (_coverPhotoPath != null &&
        !_photos.any((photo) => photo.localPath == _coverPhotoPath)) {
      _coverPhotoPath = _photos.isEmpty ? null : _photos.first.localPath;
    }
  }

  MemoryPersonDraft _personToDraft(MemoryPerson person) {
    return MemoryPersonDraft(
      name: person.name,
      relationship: person.relationship,
      phone: person.phone,
      email: person.email,
    );
  }

  Future<void> _pickDate(DateTime initialDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _occurredAt ?? initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _occurredAt = picked);
  }

  Future<void> _pickPhotos({bool setFirstAsCover = false}) async {
    final picked = await _selectAndCopyPhotos(
      existingAssetIds: {
        for (final photo in _photos)
          if (photo.originalAssetId != null) photo.originalAssetId!,
      },
      allowMultiple: true,
    );
    if (picked.isEmpty || !mounted) return;

    setState(() {
      final added = picked.map(_EditablePhoto.fromPickedPhoto).toList();
      _photos.addAll(added);
      if (setFirstAsCover || _coverPhotoPath == null) {
        _coverPhotoPath = added.first.localPath;
      }
      _applyMetadataDefaults(added);
    });
  }

  Future<void> _replacePhoto(_EditablePhoto target) async {
    final picked = await _selectAndCopyPhotos(
      existingAssetIds: {
        for (final photo in _photos)
          if (photo != target && photo.originalAssetId != null)
            photo.originalAssetId!,
      },
      allowMultiple: false,
    );
    if (picked.isEmpty || !mounted) return;

    final replacement = _EditablePhoto.fromPickedPhoto(picked.first);
    setState(() {
      final index = _photos.indexOf(target);
      if (index == -1) return;
      _photos[index] = replacement;
      if (_coverPhotoPath == target.localPath) {
        _coverPhotoPath = replacement.localPath;
      }
      _applyMetadataDefaults([replacement]);
    });
  }

  void _removePhoto(_EditablePhoto photo) {
    setState(() {
      _photos.remove(photo);
      if (_coverPhotoPath == photo.localPath) {
        _coverPhotoPath = _photos.isEmpty ? null : _photos.first.localPath;
      }
    });
  }

  Future<List<PickedMemoryPhoto>> _selectAndCopyPhotos({
    required Set<String> existingAssetIds,
    required bool allowMultiple,
  }) async {
    setState(() => _isPicking = true);
    final service = ref.read(photoLibraryServiceProvider);
    var permission = await service.currentPermission();
    if (!permission.hasAccess) permission = await service.requestPermission();

    if (!mounted) return [];
    if (!permission.hasAccess) {
      setState(() => _isPicking = false);
      await service.openSettings();
      return [];
    }

    final assets = await service.recentPhotos();
    if (!mounted) return [];
    setState(() => _isPicking = false);

    final selectedAssets = await showModalBottomSheet<List<AssetEntity>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PhotoGridSheet(
        assets: assets,
        initiallySelectedIds: existingAssetIds,
        allowMultiple: allowMultiple,
      ),
    );
    if (!mounted || selectedAssets == null || selectedAssets.isEmpty) {
      return [];
    }

    setState(() => _isPicking = true);
    final newAssets = selectedAssets.where(
      (asset) => !existingAssetIds.contains(asset.id),
    );
    final copied = await service.copyAssetsToAppStorage(newAssets);
    if (mounted) setState(() => _isPicking = false);
    return copied;
  }

  void _applyMetadataDefaults(List<_EditablePhoto> photos) {
    final locatedPhoto = _firstWhereOrNull(
      photos,
      (photo) => photo.hasLocation,
    );
    if (_latitude == null && _longitude == null && locatedPhoto != null) {
      _latitude = locatedPhoto.latitude;
      _longitude = locatedPhoto.longitude;
    }
    if (_locationController.text.trim().isEmpty && locatedPhoto != null) {
      _locationController.text =
          '${locatedPhoto.latitude!.toStringAsFixed(5)}, ${locatedPhoto.longitude!.toStringAsFixed(5)}';
    }
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final coverPhotoPath =
        _coverPhotoPath != null &&
            _photos.any((photo) => photo.localPath == _coverPhotoPath)
        ? _coverPhotoPath
        : (_photos.isEmpty ? null : _photos.first.localPath);

    await ref
        .read(memoryRepositoryProvider.notifier)
        .updateMemory(
          id: widget.memoryId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _category,
          memoryType: _memoryType,
          feeling: _feeling,
          occurredAt: _occurredAt ?? DateTime.now(),
          locationLabel: _locationController.text.trim(),
          latitude: _latitude,
          longitude: _longitude,
          coverPhotoPath: coverPhotoPath,
          photos: _photos.map((photo) => photo.toDraft()).toList(),
          people: _people,
        );

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (context.mounted) _backToPrevious(context);
  }

  String _dateLabel(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _EditablePhoto {
  const _EditablePhoto({
    required this.localPath,
    required this.capturedAt,
    required this.width,
    required this.height,
    this.originalAssetId,
    this.latitude,
    this.longitude,
  });

  factory _EditablePhoto.fromMemoryPhoto(MemoryPhoto photo) {
    return _EditablePhoto(
      localPath: photo.localPath,
      originalAssetId: photo.originalAssetId,
      capturedAt: photo.capturedAt,
      latitude: photo.latitude,
      longitude: photo.longitude,
      width: photo.width,
      height: photo.height,
    );
  }

  factory _EditablePhoto.fromPickedPhoto(PickedMemoryPhoto photo) {
    return _EditablePhoto(
      localPath: photo.localPath,
      originalAssetId: photo.originalAssetId,
      capturedAt: photo.capturedAt,
      latitude: photo.latitude,
      longitude: photo.longitude,
      width: photo.width,
      height: photo.height,
    );
  }

  final String localPath;
  final String? originalAssetId;
  final DateTime capturedAt;
  final double? latitude;
  final double? longitude;
  final int width;
  final int height;

  bool get hasLocation => latitude != null && longitude != null;

  MemoryPhotoDraft toDraft() {
    return MemoryPhotoDraft(
      localPath: localPath,
      originalAssetId: originalAssetId,
      capturedAt: capturedAt,
      latitude: latitude,
      longitude: longitude,
      width: width,
      height: height,
    );
  }
}

class _CoverPicker extends StatelessWidget {
  const _CoverPicker({
    required this.path,
    required this.isPicking,
    required this.onPick,
    required this.onClear,
  });

  final String? path;
  final bool isPicking;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final hasImage = path != null && File(path!).existsSync();

    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage) Image.file(File(path!), fit: BoxFit.cover),
          if (!hasImage)
            const Center(
              child: Icon(
                Icons.photo_camera_back_rounded,
                color: AppColors.gold,
                size: 48,
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.wallInk.withValues(alpha: 0.72),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 18,
            child: Text(
              hasImage ? 'Cover photo' : 'No cover photo',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Wrap(
              spacing: 8,
              children: [
                if (onClear != null)
                  IconButton.filledTonal(
                    onPressed: isPicking ? null : onClear,
                    icon: const Icon(Icons.close_rounded),
                  ),
                FilledButton.icon(
                  onPressed: isPicking ? null : onPick,
                  icon: isPicking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.image_rounded),
                  label: Text(hasImage ? 'Change' : 'Choose'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditPanel extends StatelessWidget {
  const _EditPanel({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.panelWarm.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _GalleryEditor extends StatelessWidget {
  const _GalleryEditor({
    required this.photos,
    required this.coverPhotoPath,
    required this.onSetCover,
    required this.onReplace,
    required this.onRemove,
  });

  final List<_EditablePhoto> photos;
  final String? coverPhotoPath;
  final ValueChanged<_EditablePhoto> onSetCover;
  final ValueChanged<_EditablePhoto> onReplace;
  final ValueChanged<_EditablePhoto> onRemove;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const Text(
        'No gallery photos yet. Add photos to make this memory feel alive.',
        style: TextStyle(color: AppColors.muted, height: 1.45),
      );
    }

    return Column(
      children: [
        for (final photo in photos)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GalleryPhotoTile(
              photo: photo,
              isCover: photo.localPath == coverPhotoPath,
              onSetCover: () => onSetCover(photo),
              onReplace: () => onReplace(photo),
              onRemove: () => onRemove(photo),
            ),
          ),
      ],
    );
  }
}

class _GalleryPhotoTile extends StatelessWidget {
  const _GalleryPhotoTile({
    required this.photo,
    required this.isCover,
    required this.onSetCover,
    required this.onReplace,
    required this.onRemove,
  });

  final _EditablePhoto photo;
  final bool isCover;
  final VoidCallback onSetCover;
  final VoidCallback onReplace;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final exists = File(photo.localPath).existsSync();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.wallInk.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCover
              ? AppColors.gold.withValues(alpha: 0.65)
              : AppColors.line,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              width: 78,
              height: 78,
              child: exists
                  ? Image.file(File(photo.localPath), fit: BoxFit.cover)
                  : const ColoredBox(
                      color: AppColors.wallDeep,
                      child: Icon(Icons.broken_image_rounded),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCover ? 'Cover photo' : 'Gallery photo',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  '${photo.width} x ${photo.height} • ${_shortDate(photo.capturedAt)}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                if (photo.hasLocation) ...[
                  const SizedBox(height: 3),
                  Text(
                    '${photo.latitude!.toStringAsFixed(4)}, ${photo.longitude!.toStringAsFixed(4)}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<_PhotoAction>(
            onSelected: (action) {
              switch (action) {
                case _PhotoAction.cover:
                  onSetCover();
                case _PhotoAction.replace:
                  onReplace();
                case _PhotoAction.remove:
                  onRemove();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _PhotoAction.cover,
                child: Text('Set as cover'),
              ),
              const PopupMenuItem(
                value: _PhotoAction.replace,
                child: Text('Replace photo'),
              ),
              const PopupMenuItem(
                value: _PhotoAction.remove,
                child: Text('Remove photo'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _shortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

enum _PhotoAction { cover, replace, remove }

class _PhotoGridSheet extends StatefulWidget {
  const _PhotoGridSheet({
    required this.assets,
    required this.initiallySelectedIds,
    required this.allowMultiple,
  });

  final List<AssetEntity> assets;
  final Set<String> initiallySelectedIds;
  final bool allowMultiple;

  @override
  State<_PhotoGridSheet> createState() => _PhotoGridSheetState();
}

class _PhotoGridSheetState extends State<_PhotoGridSheet> {
  final Set<String> _selectedIds = {};

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
                    widget.allowMultiple
                        ? '${_selectedIds.length} selected'
                        : 'Choose photo',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: _selectedIds.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(_selectedAssets()),
                  child: const Text('Use selected'),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.assets.isEmpty
                ? const Center(child: Text('No photos found.'))
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
                                if (!widget.allowMultiple) {
                                  _selectedIds
                                    ..clear()
                                    ..add(asset.id);
                                  return;
                                }
                                selected
                                    ? _selectedIds.remove(asset.id)
                                    : _selectedIds.add(asset.id);
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

  List<AssetEntity> _selectedAssets() {
    return widget.assets
        .where((asset) => _selectedIds.contains(asset.id))
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

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}

void _backToPrevious(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  }
}
