import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../media/data/photo_library_service.dart';
import '../../../media/data/picked_memory_photo.dart';
import '../../data/memory_repository.dart';
import '../../domain/memory_category.dart';
import '../../domain/memory_feeling.dart';
import '../../domain/memory_type.dart';

class AddMemoryPage extends ConsumerStatefulWidget {
  const AddMemoryPage({super.key});

  @override
  ConsumerState<AddMemoryPage> createState() => _AddMemoryPageState();
}

class _AddMemoryPageState extends ConsumerState<AddMemoryPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _connectionReasonController = TextEditingController();
  final List<PickedMemoryPhoto> _photos = [];
  int _step = 0;
  String? _connectedEventId;
  MemoryCategory _category = MemoryCategory.personal;
  MemoryType _memoryType = MemoryType.moment;
  MemoryFeeling _feeling = MemoryFeeling.warm;
  DateTime? _occurredAt;
  double? _latitude;
  double? _longitude;
  bool _isPicking = false;
  bool _isSaving = false;

  static const _stepCount = 6;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _connectionReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memoryState = ref.watch(memoryRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _backToWall(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Create a thread'),
      ),
      body: memoryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(message: error.toString()),
        data: (state) => Column(
          children: [
            _FlowHeader(step: _step, stepCount: _stepCount),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: ListView(
                  key: ValueKey(_step),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  children: [_buildStep(context, state)],
                ),
              ),
            ),
            _BottomControls(
              step: _step,
              stepCount: _stepCount,
              isSaving: _isSaving,
              onBack: _step == 0 ? null : () => setState(() => _step--),
              onNext: _nextOrSave,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, MemoryState state) {
    return switch (_step) {
      0 => _StepCard(
        eyebrow: 'Step 1',
        title: 'What kind of memory is this?',
        subtitle: 'Choose the shape of the moment before writing details.',
        child: Column(
          children: [
            for (final type in MemoryType.values)
              _ChoiceTile(
                selected: _memoryType == type,
                icon: _iconForType(type),
                title: type.label,
                subtitle: type.description,
                color: AppColors.gold,
                onTap: () => setState(() => _memoryType = type),
              ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Wall category',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in MemoryCategory.values)
                  ChoiceChip(
                    selected: _category == category,
                    label: Text(category.label),
                    onSelected: (_) => setState(() => _category = category),
                  ),
              ],
            ),
          ],
        ),
      ),
      1 => _StepCard(
        eyebrow: 'Step 2',
        title: 'Choose the photos that carry it.',
        subtitle:
            'Photos stay private on this device. Pick one or more, or continue without a photo.',
        child: _PhotoPickerPanel(
          photos: _photos,
          isPicking: _isPicking,
          onPick: _openPhotoPicker,
          onRemove: (photo) => setState(() => _photos.remove(photo)),
        ),
      ),
      2 => _StepCard(
        eyebrow: 'Step 3',
        title: 'Tell the story like a chapter.',
        subtitle:
            'Short is fine. The important part is why this moment matters.',
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Memory title',
                hintText: 'Example: First launch night',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descriptionController,
              minLines: 5,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Why this memory matters',
                hintText:
                    'Write what happened, who was there, and what you felt.',
              ),
            ),
          ],
        ),
      ),
      3 => _StepCard(
        eyebrow: 'Step 4',
        title: 'What feeling should this carry?',
        subtitle: 'This helps the wall feel alive, not just organized.',
        child: Column(
          children: [
            for (final feeling in MemoryFeeling.values)
              _ChoiceTile(
                selected: _feeling == feeling,
                icon: feeling.icon,
                title: feeling.label,
                subtitle: _feelingDescription(feeling),
                color: feeling.color,
                onTap: () => setState(() => _feeling = feeling),
              ),
          ],
        ),
      ),
      4 => _StepCard(
        eyebrow: 'Step 5',
        title: 'Place it in time and space.',
        subtitle: 'A date and place make the memory easier to find later.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DateButton(date: _occurredAt, onTap: _pickDate),
            const SizedBox(height: 14),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Linz, Austria',
              ),
            ),
            if (_latitude != null && _longitude != null) ...[
              const SizedBox(height: 10),
              Text(
                'Photo location detected: ${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}',
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
          ],
        ),
      ),
      5 => _StepCard(
        eyebrow: 'Step 6',
        title: 'Connect it to your life wall.',
        subtitle: 'Optional, but this is where LifeThreads becomes emotional.',
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _connectedEventId,
              decoration: const InputDecoration(
                labelText: 'Connect to an existing memory',
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('No connection yet'),
                ),
                ...state.events.map(
                  (event) => DropdownMenuItem<String>(
                    value: event.id,
                    child: Text(event.title),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _connectedEventId = value),
            ),
            if (_connectedEventId != null) ...[
              const SizedBox(height: 14),
              TextField(
                controller: _connectionReasonController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Why are they connected?',
                  hintText:
                      'Example: same trip, same person, before / after...',
                ),
              ),
            ],
            const SizedBox(height: 18),
            _PreviewSummary(
              title: _titleController.text.trim(),
              type: _memoryType,
              feeling: _feeling,
              photoCount: _photos.length,
            ),
          ],
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Future<void> _openPhotoPicker() async {
    setState(() => _isPicking = true);
    final service = ref.read(photoLibraryServiceProvider);
    var permission = await service.currentPermission();
    if (!permission.hasAccess) {
      permission = await service.requestPermission();
    }

    if (!mounted) return;

    if (!permission.hasAccess) {
      setState(() => _isPicking = false);
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) =>
            _PermissionDeniedSheet(onOpenSettings: service.openSettings),
      );
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
            if (picked != null) {
              _photos.add(picked);
              _occurredAt ??= picked.capturedAt;
              _latitude ??= picked.latitude;
              _longitude ??= picked.longitude;
              if (_locationController.text.trim().isEmpty &&
                  picked.latitude != null &&
                  picked.longitude != null) {
                _locationController.text =
                    '${picked.latitude!.toStringAsFixed(5)}, ${picked.longitude!.toStringAsFixed(5)}';
              }
              if (_titleController.text.trim().isEmpty &&
                  picked.title != null) {
                _titleController.text = picked.title!.split('.').first;
              }
            }
          });
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _occurredAt ?? now,
      firstDate: DateTime(1900),
      lastDate: now.add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _occurredAt = picked);
  }

  Future<void> _nextOrSave() async {
    if (!_validateStep()) return;
    if (_step < _stepCount - 1) {
      setState(() => _step++);
      return;
    }
    await _saveMemory(context);
  }

  bool _validateStep() {
    final message = switch (_step) {
      2 when _titleController.text.trim().isEmpty => 'Add a title first.',
      2 when _descriptionController.text.trim().isEmpty =>
        'Write a short story first.',
      4 when _locationController.text.trim().isEmpty => 'Add a location first.',
      _ => null,
    };

    if (message == null) return true;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    return false;
  }

  Future<void> _saveMemory(BuildContext context) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    await ref
        .read(memoryRepositoryProvider.notifier)
        .addMemory(
          NewMemoryDraft(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            category: _category,
            memoryType: _memoryType,
            feeling: _feeling,
            occurredAt: _occurredAt ?? DateTime.now(),
            locationLabel: _locationController.text.trim(),
            latitude: _latitude,
            longitude: _longitude,
            coverPhotoPath: _photos.isEmpty ? null : _photos.first.localPath,
            connectedEventId: _connectedEventId,
            connectionReason: _connectionReasonController.text.trim(),
            photos: [
              for (final photo in _photos)
                MemoryPhotoDraft(
                  localPath: photo.localPath,
                  originalAssetId: photo.originalAssetId,
                  capturedAt: photo.capturedAt,
                  latitude: photo.latitude,
                  longitude: photo.longitude,
                  width: photo.width,
                  height: photo.height,
                ),
            ],
          ),
        );

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (context.mounted) _backToWall(context);
  }

  IconData _iconForType(MemoryType type) {
    return switch (type) {
      MemoryType.moment => Icons.auto_stories_rounded,
      MemoryType.trip => Icons.travel_explore_rounded,
      MemoryType.person => Icons.people_alt_rounded,
      MemoryType.place => Icons.place_rounded,
      MemoryType.note => Icons.edit_note_rounded,
    };
  }

  String _feelingDescription(MemoryFeeling feeling) {
    return switch (feeling) {
      MemoryFeeling.warm => 'Soft, close, full of love.',
      MemoryFeeling.nostalgic => 'A memory that pulls you back.',
      MemoryFeeling.proud => 'A moment that proved something.',
      MemoryFeeling.calm => 'Quiet, safe, peaceful.',
      MemoryFeeling.important => 'A memory that changed the story.',
    };
  }
}

class _FlowHeader extends StatelessWidget {
  const _FlowHeader({required this.step, required this.stepCount});

  final int step;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    final progress = (step + 1) / stepCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.panelWarm.withValues(alpha: 0.9),
              AppColors.panel.withValues(alpha: 0.82),
            ],
          ),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cable_rounded, color: AppColors.amber),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hang a memory with meaning',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '${step + 1}/$stepCount',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress,
                backgroundColor: AppColors.wallInk,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.panelWarm.withValues(alpha: 0.92),
            AppColors.panel.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, height: 1.45),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.16)
                : AppColors.wallInk.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? color.withValues(alpha: 0.74) : AppColors.line,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: selected ? 0.28 : 0.12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: color)
              else
                const Icon(Icons.circle_outlined, color: AppColors.line),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final value = date == null
        ? 'Choose date'
        : '${date!.day.toString().padLeft(2, '0')}.${date!.month.toString().padLeft(2, '0')}.${date!.year}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Date'),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_rounded, color: AppColors.gold),
            const SizedBox(width: 10),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _PreviewSummary extends StatelessWidget {
  const _PreviewSummary({
    required this.title,
    required this.type,
    required this.feeling,
    required this.photoCount,
  });

  final String title;
  final MemoryType type;
  final MemoryFeeling feeling;
  final int photoCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.wallInk.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Icon(feeling.icon, color: feeling.color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${title.isEmpty ? 'Untitled memory' : title} • ${type.label} • ${feeling.label} • $photoCount photo${photoCount == 1 ? '' : 's'}',
              style: const TextStyle(fontWeight: FontWeight.w800, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.step,
    required this.stepCount,
    required this.isSaving,
    required this.onBack,
    required this.onNext,
  });

  final int step;
  final int stepCount;
  final bool isSaving;
  final VoidCallback? onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isLast = step == stepCount - 1;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
        decoration: BoxDecoration(
          color: AppColors.wallInk.withValues(alpha: 0.88),
          border: Border(
            top: BorderSide(color: AppColors.line.withValues(alpha: 0.7)),
          ),
        ),
        child: Row(
          children: [
            if (onBack != null)
              TextButton.icon(
                onPressed: isSaving ? null : onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Back'),
              )
            else
              const SizedBox(width: 92),
            const Spacer(),
            FilledButton.icon(
              onPressed: isSaving ? null : onNext,
              icon: isSaving
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      isLast
                          ? Icons.push_pin_rounded
                          : Icons.arrow_forward_rounded,
                    ),
              label: Text(isLast ? 'Hang on wall' : 'Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoPickerPanel extends StatelessWidget {
  const _PhotoPickerPanel({
    required this.photos,
    required this.isPicking,
    required this.onPick,
    required this.onRemove,
  });

  final List<PickedMemoryPhoto> photos;
  final bool isPicking;
  final VoidCallback onPick;
  final ValueChanged<PickedMemoryPhoto> onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.wallInk.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_library_rounded, color: AppColors.gold),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Private photos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              TextButton.icon(
                onPressed: isPicking ? null : onPick,
                icon: isPicking
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_rounded),
                label: const Text('Pick'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (photos.isEmpty)
            const Text(
              'LifeThreads copies selected photos into private app storage and keeps date/location metadata when available.',
              style: TextStyle(color: AppColors.muted, height: 1.45),
            )
          else
            SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          File(photo.localPath),
                          width: 108,
                          height: 108,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: IconButton.filledTonal(
                          onPressed: () => onRemove(photo),
                          icon: const Icon(Icons.close_rounded, size: 18),
                        ),
                      ),
                    ],
                  );
                },
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
      child: assets.isEmpty
          ? const Center(child: Text('No photos found.'))
          : GridView.builder(
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
                    child: _AssetThumbnail(asset: asset),
                  ),
                );
              },
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

class _PermissionDeniedSheet extends StatelessWidget {
  const _PermissionDeniedSheet({required this.onOpenSettings});

  final Future<void> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_rounded, color: AppColors.gold, size: 42),
          const SizedBox(height: 14),
          const Text(
            'Photo access is off',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enable photo access to pick memories. Your photos stay on this device.',
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
              child: const Text('Open Settings'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

void _backToWall(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(RouteNames.wall);
  }
}
