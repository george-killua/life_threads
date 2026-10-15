import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../media/data/photo_library_service.dart';
import '../../../media/data/picked_memory_photo.dart';
import '../../../media/presentation/widgets/photo_grid_sheet.dart';
import '../../../memories/data/place_names.dart';
import '../../../memories/domain/memory_category.dart';
import '../../../memories/domain/memory_feeling.dart';
import '../../../memories/presentation/memory_l10n.dart';
import '../../domain/family_models.dart';
import '../family_flows.dart';
import '../family_providers.dart';
import '../widgets/family_photo.dart';
import '../widgets/family_ui.dart';
import '../../../../core/widgets/app_toast.dart';

/// Adds a memory to a family wall, or edits one of the author's own
/// ([memoryId] set). Photos are encrypted and uploaded by the service.
class FamilyMemoryEditorPage extends ConsumerStatefulWidget {
  const FamilyMemoryEditorPage({
    super.key,
    required this.familyId,
    this.memoryId,
  });

  final String familyId;
  final String? memoryId;

  @override
  ConsumerState<FamilyMemoryEditorPage> createState() =>
      _FamilyMemoryEditorPageState();
}

class _FamilyMemoryEditorPageState
    extends ConsumerState<FamilyMemoryEditorPage> {
  final _title = TextEditingController();
  final _story = TextEditingController();
  final _place = TextEditingController();
  final _keptPhotoIds = <String>[];
  final _newPhotos = <PickedMemoryPhoto>[];
  var _category = MemoryCategory.family;
  var _feeling = MemoryFeeling.warm;
  DateTime? _occurredAt;
  double? _latitude;
  double? _longitude;
  var _isPicking = false;
  var _isSaving = false;
  FamilyMemory? _original;

  bool get _isEditing => widget.memoryId != null;

  @override
  void dispose() {
    _title.dispose();
    _story.dispose();
    _place.dispose();
    super.dispose();
  }

  void _loadOriginal(FamilyMemory memory) {
    _original = memory;
    _title.text = memory.title;
    _story.text = memory.description;
    _place.text = memory.locationLabel;
    _category = memory.category;
    _feeling = memory.feeling;
    _occurredAt = memory.occurredAt;
    _latitude = memory.latitude;
    _longitude = memory.longitude;
    final cover = memory.coverPhotoId;
    _keptPhotoIds
      ..clear()
      ..addAll([
        if (cover != null && memory.photoIds.contains(cover)) cover,
        for (final id in memory.photoIds)
          if (id != cover) id,
      ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Kept up to date for the storage shown when the wall is full.
    ref.watch(familyProvider(widget.familyId));
    if (_isEditing && _original == null) {
      final memory = ref
          .watch(familyMemoriesProvider(widget.familyId))
          .asData
          ?.value
          .where((m) => m.id == widget.memoryId)
          .firstOrNull;
      if (memory == null) {
        return FamilyPageScaffold(
          title: l10n.editMemoryTitle,
          children: const [Center(child: CircularProgressIndicator())],
        );
      }
      _loadOriginal(memory);
    }

    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = _occurredAt ?? DateTime.now();

    return PopScope(
      canPop: !_isSaving,
      child: FamilyPageScaffold(
        title: _isEditing ? l10n.editMemoryTitle : l10n.familyAddMemory,
        children: [
          _PhotoStrip(
            familyId: widget.familyId,
            keptPhotoIds: _keptPhotoIds,
            newPhotos: _newPhotos,
            onRemoveKept: (id) => setState(() => _keptPhotoIds.remove(id)),
            onRemoveNew: (photo) => setState(() => _newPhotos.remove(photo)),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FamilyAction(
                label: l10n.addPhotos,
                icon: Icons.photo_library_rounded,
                secondary: true,
                onTap: _isPicking || _isSaving ? null : _pickPhotos,
              ),
              FamilyAction(
                label: l10n.takePhoto,
                icon: Icons.photo_camera_rounded,
                secondary: true,
                onTap: _isPicking || _isSaving ? null : _capturePhoto,
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            key: const ValueKey('family-memory-title'),
            controller: _title,
            maxLength: 120,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.memoryTitleLabel),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const ValueKey('family-memory-story'),
            controller: _story,
            minLines: 3,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.storyDescriptionLabel,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _isSaving ? null : _pickDate,
            icon: const Icon(Icons.event_rounded),
            label: Text(
              '${l10n.dateLabel}: ${DateFormat.yMMMd(locale).format(date)}',
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _place,
            maxLength: 120,
            decoration: InputDecoration(
              labelText: l10n.placeLabel,
              prefixIcon: const Icon(Icons.place_rounded),
            ),
          ),
          const SizedBox(height: 8),
          _ChipGroup<MemoryFeeling>(
            label: l10n.feelingLabel,
            values: MemoryFeeling.values,
            selected: _feeling,
            labelOf: (feeling) => feeling.localizedLabel(l10n),
            onSelected: (feeling) => setState(() => _feeling = feeling),
          ),
          const SizedBox(height: 14),
          _ChipGroup<MemoryCategory>(
            label: l10n.categoryLabel,
            values: MemoryCategory.values,
            selected: _category,
            labelOf: (category) => category.localizedLabel(l10n),
            onSelected: (category) => setState(() => _category = category),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.familyPostNote,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12.5,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              key: const ValueKey('family-memory-save'),
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Icon(Icons.cloud_upload_rounded),
              label: Text(
                _isSaving ? l10n.familyUploading : l10n.familyPostMemory,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhotos() async {
    setState(() => _isPicking = true);
    try {
      final service = ref.read(photoLibraryServiceProvider);
      var permission = await service.currentPermission();
      if (!permission.hasAccess) {
        permission = await service.requestPermission();
      }
      if (!mounted) return;
      if (!permission.hasAccess) {
        await showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (_) =>
              PhotoPermissionDeniedSheet(onOpenSettings: service.openSettings),
        );
        return;
      }
      final assets = await service.recentPhotos();
      if (!mounted) return;
      final selected = await showModalBottomSheet<List<AssetEntity>>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => PhotoGridSheet(
          assets: assets,
          initiallySelectedIds: {
            for (final photo in _newPhotos)
              if (photo.originalAssetId != null) photo.originalAssetId!,
          },
          isLimited: permission.isLimited,
          onManageLimitedAccess: service.manageLimitedSelection,
        ),
      );
      if (!mounted || selected == null || selected.isEmpty) return;
      final picked = await service.copyAssetsToAppStorage(selected);
      if (!mounted) return;
      setState(() => _addPhotos(picked));
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  Future<void> _capturePhoto() async {
    setState(() => _isPicking = true);
    try {
      final photo = await ref
          .read(photoLibraryServiceProvider)
          .capturePhotoToAppStorage();
      if (!mounted || photo == null) return;
      setState(() => _addPhotos([photo]));
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  /// Like adding a personal memory: the first photos set the date and
  /// place when they are still empty.
  void _addPhotos(List<PickedMemoryPhoto> photos) {
    if (photos.isEmpty) return;
    final hadPhotos = _keptPhotoIds.isNotEmpty || _newPhotos.isNotEmpty;
    _newPhotos.addAll(photos);
    if (hadPhotos) return;
    final dated = photos.where((p) => p.hasCapturedDate).firstOrNull;
    if (_occurredAt == null && dated != null) _occurredAt = dated.capturedAt;
    final located = photos.where((p) => p.hasLocation).firstOrNull;
    if (located != null && _latitude == null) {
      _latitude = located.latitude;
      _longitude = located.longitude;
      if (_place.text.trim().isEmpty) {
        _place.text = coordinateLabel(located.latitude!, located.longitude!);
        _nameThePlace(located.latitude!, located.longitude!);
      }
    }
  }

  /// Replaces the coordinates in the place field with the place's name,
  /// unless the field was changed in the meantime.
  Future<void> _nameThePlace(double latitude, double longitude) async {
    final coordinates = _place.text;
    final name = await ref
        .read(placeNameLookupProvider)
        .nameFor(latitude, longitude, Localizations.localeOf(context));
    if (!mounted || name == null || _place.text != coordinates) return;
    setState(() => _place.text = name);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = DateTime(1900);
    final last = now.add(const Duration(days: 1));
    var initial = _occurredAt ?? now;
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null && mounted) setState(() => _occurredAt = picked);
  }

  FamilyMemoryDraft _draft() {
    final l10n = context.l10n;
    final title = _title.text.trim();
    return FamilyMemoryDraft(
      title: title.isEmpty ? l10n.todaysMoment : title,
      description: _story.text.trim(),
      category: _category,
      feeling: _feeling,
      occurredAt: _occurredAt ?? DateTime.now(),
      locationLabel: _place.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
      newPhotoPaths: [for (final photo in _newPhotos) photo.localPath],
      keptPhotoIds: List.of(_keptPhotoIds),
      coverIndex: 0,
    );
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    if (_title.text.trim().isEmpty &&
        _story.text.trim().isEmpty &&
        _keptPhotoIds.isEmpty &&
        _newPhotos.isEmpty) {
      showFamilyMessage(context, l10n.writeMomentOrPhotoFirst);
      return;
    }
    final account = await ensureFamilyPosting(context);
    if (account == null || !mounted) return;
    final service = familyServiceFor(context);
    if (service == null) return;

    final draft = _draft();
    var retryAfterTerms = false;
    setState(() => _isSaving = true);
    try {
      final original = _original;
      if (original == null) {
        await service.addMemory(widget.familyId, draft);
        AppLogger.event('family_memory_added');
      } else {
        await service.updateMemory(original, draft);
        AppLogger.event('family_memory_updated');
      }
      if (!mounted) return;
      showFamilyMessage(
        context,
        l10n.familyMemorySaved,
        kind: ToastKind.success,
      );
      context.pop();
    } on FamilyException catch (error) {
      if (!mounted) return;
      if (error.code == 'version_conflict' && _original != null) {
        await _resolveConflict(draft);
      } else if (error.code == 'quota_exceeded') {
        await _showQuotaExceeded();
      } else if (error.code == 'terms_required' ||
          error.code == 'terms_not_accepted') {
        // New terms since the last acceptance: accept, then post again.
        final accepted = await ensureFamilyTerms(
          context,
          FamilyAccount(
            id: account.id,
            termsAccepted: false,
            requiredTermsVersion: account.requiredTermsVersion,
            hasActiveSubscription: account.hasActiveSubscription,
          ),
        );
        retryAfterTerms = accepted != null;
      } else {
        showFamilyError(context, error);
      }
    } catch (error) {
      if (mounted) showFamilyError(context, error);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
    if (retryAfterTerms && mounted) await _save();
  }

  /// Someone changed the memory first: fetch the new version and ask
  /// whether to save these changes over it.
  Future<void> _resolveConflict(FamilyMemoryDraft draft) async {
    final l10n = context.l10n;
    final retry = await confirmFamilyAction(
      context,
      title: l10n.familyConflictTitle,
      body: l10n.familyConflictBody,
      confirmLabel: l10n.familyConflictRetry,
    );
    if (!retry || !mounted) return;
    final service = familyServiceFor(context);
    if (service == null) return;
    setState(() => _isSaving = true);
    try {
      await service.sync(widget.familyId);
      final latest = (await service.watchMemories(widget.familyId).first)
          .where((m) => m.id == widget.memoryId)
          .firstOrNull;
      if (latest == null) throw const FamilyException('not_found');
      await service.updateMemory(latest, draft);
      AppLogger.event('family_memory_conflict_resolved');
      if (!mounted) return;
      showFamilyMessage(
        context,
        l10n.familyMemorySaved,
        kind: ToastKind.success,
      );
      context.pop();
    } catch (error) {
      if (mounted) showFamilyError(context, error);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _showQuotaExceeded() async {
    final l10n = context.l10n;
    final family = ref.read(familyProvider(widget.familyId)).asData?.value;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.storage_rounded, color: AppColors.gold),
        title: Text(l10n.familyQuotaTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.familyErrorQuotaExceeded),
            if (family != null) ...[
              const SizedBox(height: 14),
              FamilyUsageBar(
                usedBytes: family.usedBytes,
                quotaBytes: family.quotaBytes,
                label: l10n.familyStorageUsed(
                  formatFamilyBytes(context, family.usedBytes),
                  formatFamilyBytes(context, family.quotaBytes),
                ),
              ),
            ],
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({
    required this.familyId,
    required this.keptPhotoIds,
    required this.newPhotos,
    required this.onRemoveKept,
    required this.onRemoveNew,
  });

  final String familyId;
  final List<String> keptPhotoIds;
  final List<PickedMemoryPhoto> newPhotos;
  final ValueChanged<String> onRemoveKept;
  final ValueChanged<PickedMemoryPhoto> onRemoveNew;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (keptPhotoIds.isEmpty && newPhotos.isEmpty) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.panelWarm.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_rounded,
              color: AppColors.gold,
              size: 34,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.familyNoPhotosYet,
              style: TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final id in keptPhotoIds)
            _Thumb(
              tooltip: l10n.removePhoto,
              onRemove: () => onRemoveKept(id),
              child: FamilyPhoto(familyId: familyId, photoId: id),
            ),
          for (final photo in newPhotos)
            _Thumb(
              tooltip: l10n.removePhoto,
              onRemove: () => onRemoveNew(photo),
              child: Image.file(
                File(photo.localPath),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    ColoredBox(color: AppColors.wallDeep),
              ),
            ),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.child,
    required this.onRemove,
    required this.tooltip,
  });

  final Widget child;
  final VoidCallback onRemove;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: SizedBox(
        width: 120,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
            PositionedDirectional(
              top: 4,
              end: 4,
              child: IconButton.filledTonal(
                tooltip: tooltip,
                visualDensity: VisualDensity.compact,
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipGroup<T> extends StatelessWidget {
  const _ChipGroup({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final String label;
  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in values)
              ChoiceChip(
                selected: value == selected,
                label: Text(labelOf(value)),
                onSelected: (_) => onSelected(value),
              ),
          ],
        ),
      ],
    );
  }
}
