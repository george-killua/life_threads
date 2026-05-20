import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../media/data/photo_library_service.dart';
import '../../data/memory_repository.dart';
import '../../domain/memory_category.dart';
import '../../domain/memory_event.dart';

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
  MemoryCategory _category = MemoryCategory.personal;
  DateTime? _occurredAt;
  double? _latitude;
  double? _longitude;
  String? _coverPhotoPath;
  bool _initialized = false;
  bool _isPicking = false;

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
          _init(event);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _CoverPicker(
                path: _coverPhotoPath,
                isPicking: _isPicking,
                onPick: _pickCoverPhoto,
              ),
              const SizedBox(height: 22),
              Form(
                key: _formKey,
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
                    const SizedBox(height: 14),
                    DropdownButtonFormField<MemoryCategory>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: MemoryCategory.values
                          .map(
                            (category) => DropdownMenuItem<MemoryCategory>(
                              value: category,
                              child: Text(category.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(
                        () => _category = value ?? MemoryCategory.personal,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Add a location'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.event_rounded,
                        color: AppColors.gold,
                      ),
                      title: Text(_dateLabel(_occurredAt ?? event.occurredAt)),
                      subtitle: const Text('Memory date'),
                      trailing: const Icon(Icons.edit_calendar_rounded),
                      onTap: () => _pickDate(event.occurredAt),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _save(context),
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save memory'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _init(MemoryEvent event) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _locationController.text = event.locationLabel;
    _category = event.category;
    _occurredAt = event.occurredAt;
    _latitude = event.latitude;
    _longitude = event.longitude;
    _coverPhotoPath = event.coverPhotoPath;
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

  Future<void> _pickCoverPhoto() async {
    setState(() => _isPicking = true);
    final service = ref.read(photoLibraryServiceProvider);
    var permission = await service.currentPermission();
    if (!permission.hasAccess) permission = await service.requestPermission();

    if (!mounted) return;
    if (!permission.hasAccess) {
      setState(() => _isPicking = false);
      await service.openSettings();
      return;
    }

    final assets = await service.recentPhotos();
    if (!mounted) return;
    setState(() => _isPicking = false);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PhotoGridSheet(
        assets: assets,
        onSelect: (asset) async {
          Navigator.of(context).pop();
          setState(() => _isPicking = true);
          final picked = await service.copyAssetToAppStorage(asset);
          if (!mounted) return;
          setState(() {
            _isPicking = false;
            if (picked == null) return;
            _coverPhotoPath = picked.localPath;
            _occurredAt ??= picked.capturedAt;
            _latitude ??= picked.latitude;
            _longitude ??= picked.longitude;
            if (_locationController.text.trim().isEmpty &&
                picked.latitude != null &&
                picked.longitude != null) {
              _locationController.text =
                  '${picked.latitude!.toStringAsFixed(5)}, ${picked.longitude!.toStringAsFixed(5)}';
            }
          });
        },
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(memoryRepositoryProvider.notifier)
        .updateMemory(
          id: widget.memoryId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _category,
          occurredAt: _occurredAt ?? DateTime.now(),
          locationLabel: _locationController.text.trim(),
          latitude: _latitude,
          longitude: _longitude,
          coverPhotoPath: _coverPhotoPath,
        );
    if (context.mounted) _backToPrevious(context);
  }

  String _dateLabel(DateTime date) => '${date.day}.${date.month}.${date.year}';
}

class _CoverPicker extends StatelessWidget {
  const _CoverPicker({
    required this.path,
    required this.isPicking,
    required this.onPick,
  });

  final String? path;
  final bool isPicking;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (path != null && File(path!).existsSync())
            Image.file(File(path!), fit: BoxFit.cover),
          if (path == null || !File(path!).existsSync())
            const Center(
              child: Icon(
                Icons.photo_camera_back_rounded,
                color: AppColors.gold,
                size: 46,
              ),
            ),
          Positioned(
            right: 12,
            bottom: 12,
            child: FilledButton.icon(
              onPressed: isPicking ? null : onPick,
              icon: isPicking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.image_rounded),
              label: const Text('Change cover'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoGridSheet extends StatelessWidget {
  const _PhotoGridSheet({required this.assets, required this.onSelect});

  final List<AssetEntity> assets;
  final ValueChanged<AssetEntity> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.78,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: assets.length,
        itemBuilder: (context, index) {
          final asset = assets[index];
          return GestureDetector(
            onTap: () => onSelect(asset),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: FutureBuilder<Uint8List?>(
                future: asset.thumbnailDataWithSize(
                  const ThumbnailSize.square(320),
                ),
                builder: (context, snapshot) {
                  final bytes = snapshot.data;
                  if (bytes == null) {
                    return const ColoredBox(color: AppColors.wallDeep);
                  }
                  return Image.memory(bytes, fit: BoxFit.cover);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

void _backToPrevious(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  }
}
