import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../media/data/photo_library_service.dart';
import '../../../media/data/picked_memory_photo.dart';
import '../../../premium/data/premium_entitlement_controller.dart';
import '../../../premium/domain/premium_entitlement.dart';
import '../../data/memory_repository.dart';
import '../../domain/memory_category.dart';
import '../../domain/memory_feeling.dart';
import '../../domain/memory_type.dart';
import '../memory_l10n.dart';
import '../widgets/memory_people_editor.dart';

class AddMemoryPage extends ConsumerStatefulWidget {
  const AddMemoryPage({super.key});

  @override
  ConsumerState<AddMemoryPage> createState() => _AddMemoryPageState();
}

class _AddMemoryPageState extends ConsumerState<AddMemoryPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _connectionReasonController = TextEditingController();
  final List<PickedMemoryPhoto> _photos = [];
  List<MemoryPersonDraft> _people = [];
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
  PermissionState? _photoPermission;

  static const _stepCount = 4;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _connectionReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final memoryState = ref.watch(memoryRepositoryProvider);
    final entitlement = ref.watch(premiumEntitlementProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _backToWall(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(l10n.saveMomentTitle),
      ),
      body: memoryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(message: error.toString()),
        data: (state) {
          final canCreate =
              entitlement?.canCreateMemory(state.events.length) ??
              state.events.length < PremiumEntitlement.freeMemoryLimit;
          if (!canCreate) return const _MemoryLimitReached();

          return Column(
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
                onSaveNow: _canSaveNow() ? () => _saveMemory(context) : null,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStep(BuildContext context, MemoryState state) {
    final l10n = context.l10n;

    return switch (_step) {
      0 => _StepCard(
        eyebrow: l10n.todayEyebrow,
        title: l10n.addMemoryStepTitle,
        subtitle: l10n.addMemoryStepSubtitle,
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.momentLabel,
                hintText: l10n.momentHint,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: l10n.storyWorthLabel,
                hintText: l10n.storyWorthHint,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            _PhotoPickerPanel(
              photos: _photos,
              isPicking: _isPicking,
              permission: _photoPermission,
              onPick: _openPhotoPicker,
              onCapture: _capturePhoto,
              onManageLimitedAccess: _manageLimitedPhotoAccess,
              onRemove: (photo) => setState(() {
                _photos.remove(photo);
                _syncLocationFromPhotos();
              }),
            ),
          ],
        ),
      ),
      1 => _StepCard(
        eyebrow: l10n.feelingEyebrow,
        title: l10n.feelingStepTitle,
        subtitle: l10n.feelingStepSubtitle,
        child: Column(
          children: [
            for (final feeling in MemoryFeeling.values)
              _ChoiceTile(
                selected: _feeling == feeling,
                icon: feeling.icon,
                title: feeling.localizedLabel(l10n),
                subtitle: feeling.localizedDescription(l10n),
                color: feeling.color,
                onTap: () => setState(() => _feeling = feeling),
              ),
          ],
        ),
      ),
      2 => _StepCard(
        eyebrow: l10n.contextEyebrow,
        title: l10n.whenWasItTitle,
        subtitle: l10n.photoGpsStepSubtitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DateButton(date: _occurredAt, onTap: _pickDate),
            const SizedBox(height: 14),
            _PhotoGpsStatus(latitude: _latitude, longitude: _longitude),
          ],
        ),
      ),
      3 => _StepCard(
        eyebrow: l10n.peopleThreadsEyebrow,
        title: l10n.peopleThreadsTitle,
        subtitle: l10n.peopleThreadsSubtitle,
        child: Column(
          children: [
            MemoryPeopleEditor(
              people: _people,
              suggestedPeople: _personSuggestions(state),
              onChanged: (people) => setState(() => _people = people),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: _connectedEventId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.connectExistingMemoryLabel,
              ),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(l10n.noConnectionYet),
                ),
                ...state.events.map(
                  (event) => DropdownMenuItem<String>(
                    value: event.id,
                    child: Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                decoration: InputDecoration(
                  labelText: l10n.connectionReasonLabel,
                  hintText: l10n.connectionReasonHint,
                ),
              ),
            ],
            const SizedBox(height: 18),
            _MemoryDetailsPanel(
              memoryType: _memoryType,
              category: _category,
              onTypeChanged: (type) => setState(() => _memoryType = type),
              onCategoryChanged: (category) =>
                  setState(() => _category = category),
            ),
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
    setState(() => _photoPermission = permission);

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

    final selectedAssets = await showModalBottomSheet<List<AssetEntity>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PhotoGridSheet(
        assets: assets,
        initiallySelectedIds: {
          for (final photo in _photos)
            if (photo.originalAssetId != null) photo.originalAssetId!,
        },
        isLimited: permission.isLimited,
        onManageLimitedAccess: _manageLimitedPhotoAccess,
      ),
    );
    if (!mounted || selectedAssets == null || selectedAssets.isEmpty) return;

    setState(() => _isPicking = true);
    final existingIds = {
      for (final photo in _photos)
        if (photo.originalAssetId != null) photo.originalAssetId!,
    };
    final newAssets = selectedAssets.where(
      (asset) => !existingIds.contains(asset.id),
    );
    final pickedPhotos = await service.copyAssetsToAppStorage(newAssets);
    if (!mounted) return;

    setState(() {
      _isPicking = false;
      if (pickedPhotos.isEmpty) return;
      _photos.addAll(pickedPhotos);
      _applyPhotoDefaults(pickedPhotos);
    });
  }

  Future<void> _capturePhoto() async {
    setState(() => _isPicking = true);
    final photo = await ref
        .read(photoLibraryServiceProvider)
        .capturePhotoToAppStorage();
    if (!mounted) return;

    setState(() {
      _isPicking = false;
      if (photo == null) return;
      _photos.add(photo);
      _applyPhotoDefaults([photo]);
    });
  }

  List<MemoryPersonDraft> _personSuggestions(MemoryState state) {
    return [
      for (final person in state.people)
        MemoryPersonDraft(
          name: person.name,
          relationship: person.relationship,
          phone: person.phone,
          email: person.email,
        ),
    ];
  }

  Future<void> _manageLimitedPhotoAccess() async {
    final service = ref.read(photoLibraryServiceProvider);
    await service.manageLimitedSelection();
    final permission = await service.currentPermission();
    if (!mounted) return;
    setState(() => _photoPermission = permission);
  }

  void _applyPhotoDefaults(Iterable<PickedMemoryPhoto> pickedPhotos) {
    final photos = pickedPhotos.toList();
    if (photos.isEmpty) return;

    final datedPhoto = _firstWhereOrNull(
      photos,
      (photo) => photo.hasCapturedDate,
    );
    _occurredAt ??= (datedPhoto ?? photos.first).capturedAt;

    _syncLocationFromPhotos();

    final namedPhoto = _firstWhereOrNull(
      photos,
      (photo) => _cleanPhotoTitle(photo.title) != null,
    );
    final title = _cleanPhotoTitle(namedPhoto?.title);
    if (_titleController.text.trim().isEmpty && title != null) {
      _titleController.text = title;
    }
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

  void _syncLocationFromPhotos() {
    final locatedPhoto = _firstWhereOrNull(
      _photos,
      (photo) => photo.hasLocation,
    );
    _latitude = locatedPhoto?.latitude;
    _longitude = locatedPhoto?.longitude;
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
    final message = _step == 0 && !_canSaveNow()
        ? context.l10n.writeMomentOrPhotoFirst
        : null;

    if (message == null) return true;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    return false;
  }

  bool _canSaveNow() {
    return _titleController.text.trim().isNotEmpty ||
        _descriptionController.text.trim().isNotEmpty ||
        _photos.isNotEmpty;
  }

  Future<void> _saveMemory(BuildContext context) async {
    if (_isSaving) return;
    final state = ref.read(memoryRepositoryProvider).asData?.value;
    final entitlement = ref.read(premiumEntitlementProvider).asData?.value;
    final canCreate =
        state == null ||
        (entitlement?.canCreateMemory(state.events.length) ??
            state.events.length < PremiumEntitlement.freeMemoryLimit);
    if (!canCreate) {
      context.go(RouteNames.upgrade);
      return;
    }

    setState(() => _isSaving = true);

    final fallbackTitle =
        _cleanPhotoTitle(_photos.firstOrNull?.title) ??
        context.l10n.todaysMoment;
    final title = _titleController.text.trim().isEmpty
        ? fallbackTitle
        : _titleController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? context.l10n.savedFromTodaysPrompt
        : _descriptionController.text.trim();
    final locationLabel = _locationLabelFromGps(_latitude, _longitude);

    await ref
        .read(memoryRepositoryProvider.notifier)
        .addMemory(
          NewMemoryDraft(
            title: title,
            description: description,
            category: _category,
            memoryType: _memoryType,
            feeling: _feeling,
            occurredAt: _occurredAt ?? DateTime.now(),
            locationLabel: locationLabel,
            latitude: _latitude,
            longitude: _longitude,
            coverPhotoPath: _photos.isEmpty ? null : _photos.first.localPath,
            connectedEventId: _connectedEventId,
            connectionReason: _connectionReasonController.text.trim(),
            people: _people,
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
}

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}

String? _cleanPhotoTitle(String? title) {
  final value = title?.trim();
  if (value == null || value.isEmpty) return null;
  final withoutExtension = value.contains('.')
      ? value.substring(0, value.lastIndexOf('.'))
      : value;
  final cleaned = withoutExtension.replaceAll(RegExp(r'[_-]+'), ' ').trim();
  return cleaned.isEmpty ? null : cleaned;
}

String _locationLabelFromGps(double? latitude, double? longitude) {
  if (latitude == null || longitude == null) return '';
  return '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
}

class _PhotoGpsStatus extends StatelessWidget {
  const _PhotoGpsStatus({required this.latitude, required this.longitude});

  final double? latitude;
  final double? longitude;

  @override
  Widget build(BuildContext context) {
    final hasGps = latitude != null && longitude != null;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.panelWarm.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Icon(
            hasGps ? Icons.location_on_rounded : Icons.location_off_rounded,
            color: hasGps ? AppColors.gold : AppColors.muted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasGps
                  ? l10n.photoGpsDetected(
                      latitude!.toStringAsFixed(5),
                      longitude!.toStringAsFixed(5),
                    )
                  : l10n.photoGpsMissing,
              style: const TextStyle(color: AppColors.muted, height: 1.35),
            ),
          ),
        ],
      ),
    );
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
                    context.l10n.saveItBeforeItFades,
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
        ? context.l10n.chooseDate
        : '${date!.day.toString().padLeft(2, '0')}.${date!.month.toString().padLeft(2, '0')}.${date!.year}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: InputDecorator(
        decoration: InputDecoration(labelText: context.l10n.dateLabel),
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
    final l10n = context.l10n;
    final titleLabel = title.isEmpty ? l10n.untitledMemory : title;

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
              l10n.memoryPreviewSummary(
                titleLabel,
                type.localizedLabel(l10n),
                feeling.localizedLabel(l10n),
                photoCount,
              ),
              style: const TextStyle(fontWeight: FontWeight.w800, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoryDetailsPanel extends StatelessWidget {
  const _MemoryDetailsPanel({
    required this.memoryType,
    required this.category,
    required this.onTypeChanged,
    required this.onCategoryChanged,
  });

  final MemoryType memoryType;
  final MemoryCategory category;
  final ValueChanged<MemoryType> onTypeChanged;
  final ValueChanged<MemoryCategory> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      leading: const Icon(Icons.tune_rounded, color: AppColors.gold),
      title: Text(
        l10n.organize,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      subtitle: Text(
        '${memoryType.localizedLabel(l10n)} • ${category.localizedLabel(l10n)}',
      ),
      children: [
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.memoryShape,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final type in MemoryType.values)
              ChoiceChip(
                selected: memoryType == type,
                label: Text(type.localizedLabel(l10n)),
                onSelected: (_) => onTypeChanged(type),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.wallCategory,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in MemoryCategory.values)
              ChoiceChip(
                selected: category == item,
                label: Text(item.localizedLabel(l10n)),
                onSelected: (_) => onCategoryChanged(item),
              ),
          ],
        ),
      ],
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
    required this.onSaveNow,
  });

  final int step;
  final int stepCount;
  final bool isSaving;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final VoidCallback? onSaveNow;

  @override
  Widget build(BuildContext context) {
    final isLast = step == stepCount - 1;
    final l10n = context.l10n;

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
                label: Text(l10n.back),
              )
            else
              const SizedBox.shrink(),
            const Spacer(),
            if (step == 0) ...[
              TextButton(
                onPressed: isSaving ? null : onSaveNow,
                child: Text(l10n.saveNow),
              ),
              const SizedBox(width: 8),
            ],
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
              label: Text(isLast ? l10n.hangOnWall : l10n.continueAction),
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
    required this.permission,
    required this.onPick,
    required this.onCapture,
    required this.onManageLimitedAccess,
    required this.onRemove,
  });

  final List<PickedMemoryPhoto> photos;
  final bool isPicking;
  final PermissionState? permission;
  final VoidCallback onPick;
  final VoidCallback onCapture;
  final Future<void> Function() onManageLimitedAccess;
  final ValueChanged<PickedMemoryPhoto> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
              Expanded(
                child: Text(
                  l10n.privatePhotos,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton.icon(
                  onPressed: isPicking ? null : onCapture,
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: Text(l10n.takePhoto),
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
                  label: Text(photos.isEmpty ? l10n.pick : l10n.addMore),
                ),
              ],
            ),
          ),
          if (permission?.isLimited == true) ...[
            const SizedBox(height: 12),
            _LimitedAccessNotice(onManage: onManageLimitedAccess),
          ],
          const SizedBox(height: 14),
          if (photos.isEmpty)
            Text(
              l10n.photoStorageHint,
              style: const TextStyle(color: AppColors.muted, height: 1.45),
            )
          else ...[
            _PhotoMetadataSummary(photos: photos),
            const SizedBox(height: 12),
            SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  final isCover = index == 0;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          File(photo.localPath),
                          width: 108,
                          height: 108,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const ColoredBox(
                            color: AppColors.wallDeep,
                            child: SizedBox(
                              width: 108,
                              height: 108,
                              child: Icon(Icons.photo_camera_back_rounded),
                            ),
                          ),
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
                      if (isCover)
                        Positioned(
                          left: 6,
                          bottom: 6,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                l10n.coverPhoto,
                                style: const TextStyle(
                                  color: AppColors.wallDeep,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhotoMetadataSummary extends StatelessWidget {
  const _PhotoMetadataSummary({required this.photos});

  final List<PickedMemoryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    final dateCount = photos.where((photo) => photo.hasCapturedDate).length;
    final locationCount = photos.where((photo) => photo.hasLocation).length;
    final dimensionCount = photos.where((photo) => photo.hasDimensions).length;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _MetadataChip(
          icon: Icons.calendar_month_rounded,
          label: context.l10n.metadataDates(dateCount, photos.length),
          active: dateCount > 0,
        ),
        _MetadataChip(
          icon: Icons.place_rounded,
          label: context.l10n.metadataLocations(locationCount, photos.length),
          active: locationCount > 0,
        ),
        _MetadataChip(
          icon: Icons.aspect_ratio_rounded,
          label: context.l10n.metadataSizes(dimensionCount, photos.length),
          active: dimensionCount > 0,
        ),
      ],
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: active
            ? AppColors.gold.withValues(alpha: 0.13)
            : AppColors.wallInk.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? AppColors.gold.withValues(alpha: 0.28)
              : AppColors.line,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: active ? AppColors.gold : AppColors.muted,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: active ? AppColors.text : AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitedAccessNotice extends StatelessWidget {
  const _LimitedAccessNotice({required this.onManage});

  final Future<void> Function() onManage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          const Icon(Icons.photo_filter_rounded, color: AppColors.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.limitedPhotoAccessActive,
              style: const TextStyle(fontWeight: FontWeight.w700, height: 1.3),
            ),
          ),
          TextButton(onPressed: onManage, child: Text(context.l10n.manage)),
        ],
      ),
    );
  }
}

class _PhotoGridSheet extends StatefulWidget {
  const _PhotoGridSheet({
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
  State<_PhotoGridSheet> createState() => _PhotoGridSheetState();
}

class _PhotoGridSheetState extends State<_PhotoGridSheet> {
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
          Text(
            context.l10n.photoAccessOff,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.photoAccessOffBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.45),
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

class _MemoryLimitReached extends StatelessWidget {
  const _MemoryLimitReached();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.panelWarm.withValues(alpha: 0.94),
                AppColors.panel.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.workspace_premium_rounded,
                color: AppColors.amber,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.freeMemoryLimitReached,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.freeMemoryLimitBody,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted, height: 1.45),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => context.go(RouteNames.upgrade),
                icon: const Icon(Icons.lock_open_rounded),
                label: Text(context.l10n.viewPremium),
              ),
            ],
          ),
        ),
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
