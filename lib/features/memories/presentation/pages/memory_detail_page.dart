import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../features/backup/domain/backup_models.dart';
import '../../../../features/capsule/data/memory_capsule_cloud_share_service.dart';
import '../../../../features/capsule/data/memory_capsule_service.dart';
import '../../../../features/capsule/presentation/widgets/memory_capsule_dialogs.dart';
import '../../../../features/map/presentation/widgets/memory_map_preview.dart';
import '../../../../features/on_this_day/data/on_this_day_providers.dart';
import '../../../../features/premium/presentation/premium_gate.dart';
import '../../data/memory_repository.dart';
import '../../domain/memory_event.dart';
import '../../domain/memory_photo.dart';
import '../../domain/memory_person.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../memory_l10n.dart';
import 'edit_memory_page.dart';
import '../../../wall/domain/wall_item.dart';
import '../../../../core/widgets/app_toast.dart';

class MemoryDetailPage extends ConsumerWidget {
  const MemoryDetailPage({super.key, required this.memoryId});

  final String memoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoryState = ref.watch(memoryRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.wallInk,
      body: memoryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (state) {
          final event = state.findEvent(memoryId);
          if (event == null) return const _NotFoundState();

          final connectedEvents = state.connectedEvents(memoryId);
          final photos = state.photosForEvent(memoryId);
          final people = state.peopleForEvent(memoryId);
          final attachedNotes = state.attachedTextNotes(memoryId);
          final heroPhotos = _heroPreviewPhotos(event, photos);
          // On its anniversary a memory opens as an On this day chapter
          // (Premium; free users see the usual page).
          final onThisDayYears = ref.watch(premiumActiveProvider)
              ? ref
                    .watch(onThisDayMatchesProvider)
                    .where((match) => match.memory.id == memoryId)
                    .firstOrNull
                    ?.yearsAgo
              : null;
          final galleryPhotos = _galleryPreviewPhotos(photos);

          return _ScrolledPast(
            offset: 320,
            builder: (context, pastPhoto) => Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _CinematicHero(
                        event: event,
                        previewPhotos: heroPhotos,
                        onThisDayYears: onThisDayYears,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ChapterActions(
                              onEdit: () =>
                                  context.push('/memories/$memoryId/edit'),
                              onConnect: () => context.push(
                                '/memories/$memoryId/connections',
                              ),
                              onCreateStory: () => context.push(
                                RouteNames.createStory,
                                extra: memoryId,
                              ),
                              onShareCapsule: () => _shareCloudCapsule(
                                context,
                                ref,
                                state,
                                memoryId,
                              ),
                            ),
                            const SizedBox(height: 18),
                            _MetadataGrid(
                              event: event,
                              onEdit: (section) => context.push(
                                EditMemoryPage.location(memoryId, section),
                              ),
                            ),
                            const SizedBox(height: 22),
                            _StorySection(
                              event: event,
                              onEdit: () => context.push(
                                EditMemoryPage.location(
                                  memoryId,
                                  EditMemorySection.story,
                                ),
                              ),
                            ),
                            if (people.isNotEmpty) ...[
                              const SizedBox(height: 22),
                              _PeopleSection(
                                people: people,
                                onEdit: () => context.push(
                                  EditMemoryPage.location(
                                    memoryId,
                                    EditMemorySection.people,
                                  ),
                                ),
                              ),
                            ] else ...[
                              // An invitation instead of nothing.
                              const SizedBox(height: 14),
                              _HintRow(
                                key: const ValueKey('memory-add-person-hint'),
                                icon: Icons.person_add_alt_1_rounded,
                                text: context.l10n.peopleHint,
                                action: context.l10n.addPerson,
                                onTap: () => context.push(
                                  EditMemoryPage.location(
                                    memoryId,
                                    EditMemorySection.people,
                                  ),
                                ),
                              ),
                            ],
                            if (attachedNotes.isNotEmpty) ...[
                              const SizedBox(height: 22),
                              _ConnectedNotesSection(notes: attachedNotes),
                            ],
                            if (photos.isNotEmpty) ...[
                              const SizedBox(height: 22),
                              _GallerySection(
                                photos: photos,
                                previewPhotos: galleryPhotos,
                                onEdit: () => context.push(
                                  EditMemoryPage.location(
                                    memoryId,
                                    EditMemorySection.gallery,
                                  ),
                                ),
                              ),
                            ],
                            if (event.hasGeoPoint) ...[
                              const SizedBox(height: 22),
                              _MapSection(event: event),
                            ],
                            const SizedBox(height: 22),
                            _ConnectedThreadPath(
                              memoryId: memoryId,
                              events: connectedEvents,
                              state: state,
                              onEdit: () => context.push(
                                '/memories/$memoryId/connections',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Fixed above the content, so they stay while it scrolls.
                _DetailTopButtons(
                  solid: pastPhoto,
                  onBack: () => _backToWall(context),
                  onEdit: () => context.push('/memories/$memoryId/edit'),
                  onConnect: () =>
                      context.push('/memories/$memoryId/connections'),
                  onShareCapsule: () =>
                      _shareCloudCapsule(context, ref, state, memoryId),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareCloudCapsule(
    BuildContext context,
    WidgetRef ref,
    MemoryState state,
    String memoryId,
  ) async {
    final password = await showMemoryCapsulePasswordDialog(
      context,
      purpose: MemoryCapsulePasswordPurpose.export,
      requirePassword: true,
    );
    if (!context.mounted || password == null) return;

    var progressVisible = false;
    try {
      _showCloudShareProgress(context);
      progressVisible = true;
      final result = await ref
          .read(memoryCapsuleServiceProvider)
          .exportCapsule(state: state, memoryId: memoryId, password: password);
      final cloudShare = await ref
          .read(memoryCapsuleCloudShareServiceProvider)
          .uploadCapsule(capsule: result);

      if (context.mounted && progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        progressVisible = false;
      }
      if (!context.mounted) return;
      final shareResult = await SharePlus.instance.share(
        ShareParams(
          title: context.l10n.lifeThreadsMemoryTitle,
          subject: context.l10n.lifeThreadsMemoryTitle,
          text: context.l10n.shareMemoryText(cloudShare.shareUrl),
        ),
      );
      if (!context.mounted) return;
      final label = switch (shareResult.status) {
        ShareResultStatus.success => context.l10n.shareLinkReady,
        ShareResultStatus.dismissed => context.l10n.shareLinkCreated,
        ShareResultStatus.unavailable => context.l10n.shareLinkUnavailable,
      };
      // The toast outlives this page (it stays up on the wall), so Delete
      // must not depend on the page's context or ref.
      final messenger = ScaffoldMessenger.of(context);
      final l10n = context.l10n;
      final shareService = ref.read(memoryCapsuleCloudShareServiceProvider);
      messenger.showToast(
        l10n.shareLinkExpiresDelete(label),
        action: ToastAction(
          label: l10n.delete,
          onPressed: () {
            unawaited(
              _deleteSharedCapsule(messenger, l10n, shareService, cloudShare),
            );
          },
        ),
      );
    } on BackupValidationException catch (error) {
      if (context.mounted && progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        progressVisible = false;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showToast(
        context.l10n.capsuleRejected(error.message),
        kind: ToastKind.error,
      );
    } on MemoryCapsuleCloudShareException catch (error) {
      if (context.mounted && progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        progressVisible = false;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showToast(
        context.l10n.cloudShareFailed(error.message),
        kind: ToastKind.error,
      );
    } catch (error) {
      if (context.mounted && progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        progressVisible = false;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showToast(
        context.l10n.cloudShareFailed('$error'),
        kind: ToastKind.error,
      );
    }
  }

  void _showCloudShareProgress(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // Back must not dismiss it: the caller pops it when work finishes.
      builder: (context) =>
          const PopScope(canPop: false, child: _CloudShareProgressDialog()),
    );
  }

  Future<void> _deleteSharedCapsule(
    ScaffoldMessengerState messenger,
    AppLocalizations l10n,
    MemoryCapsuleCloudShareService shareService,
    MemoryCapsuleCloudShareResult cloudShare,
  ) async {
    try {
      await shareService.revokeShare(cloudShare);
      if (!messenger.mounted) return;
      messenger.showToast(
        l10n.sharedMemoryLinkDeleted,
        kind: ToastKind.success,
      );
    } on MemoryCapsuleCloudShareException catch (error) {
      if (!messenger.mounted) return;
      messenger.showToast(
        l10n.deleteFailed(error.message),
        kind: ToastKind.error,
      );
    }
  }
}

class _CloudShareProgressDialog extends StatelessWidget {
  const _CloudShareProgressDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(context.l10n.creatingSecureMemoryLink)),
        ],
      ),
    );
  }
}

class _CinematicHero extends StatelessWidget {
  const _CinematicHero({
    required this.event,
    required this.previewPhotos,
    this.onThisDayYears,
  });

  final MemoryEvent event;
  final List<_PreviewPhoto> previewPhotos;
  final int? onThisDayYears;

  @override
  Widget build(BuildContext context) {
    final path = event.coverPhotoPath;
    final assetExists = path != null && path.startsWith('assets/');
    final fileExists = path != null && File(path).existsSync();
    final heroTag = 'memory-cover-${event.id}';
    final height = MediaQuery.sizeOf(context).height * 0.58;

    return SizedBox(
      height: height.clamp(390.0, 520.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (assetExists || fileExists)
            GestureDetector(
              onTap: () => _openPhotoPreview(
                context,
                photos: previewPhotos,
                initialIndex: 0,
              ),
              child: Hero(
                tag: heroTag,
                child: assetExists
                    ? Image.asset(
                        path,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        errorBuilder: (_, _, _) =>
                            _HeroPlaceholder(event: event),
                      )
                    : Image.file(
                        File(path),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        errorBuilder: (_, _, _) =>
                            _HeroPlaceholder(event: event),
                      ),
              ),
            )
          else
            _HeroPlaceholder(event: event),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.28),
                  Colors.transparent,
                  AppColors.wallInk.withValues(alpha: 0.96),
                ],
                stops: const [0, 0.42, 1],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomLeft,
                radius: 0.95,
                colors: [
                  event.feeling.color.withValues(alpha: 0.32),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Kept below the fixed buttons: at large text sizes the block
          // shrinks to fit instead of sliding under them.
          Positioned(
            left: 20,
            right: 20,
            top: MediaQuery.paddingOf(context).top + 68,
            bottom: 24,
            child: LayoutBuilder(
              builder: (context, constraints) => Align(
                alignment: AlignmentDirectional.bottomStart,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.bottomStart,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: _heroText(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroText(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onThisDayYears != null) ...[
          _OnThisDayHeader(yearsAgo: onThisDayYears!),
          const SizedBox(height: 10),
        ],
        _FeelingBadge(event: event),
        const SizedBox(height: 14),
        Text(
          event.title,
          // Already display size; more would push the rest away.
          textScaler: MediaQuery.textScalerOf(
            context,
          ).clamp(maxScaleFactor: 1.3),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 43,
            height: 0.98,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.4,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              event.hasGeoPoint
                  ? Icons.place_rounded
                  : Icons.calendar_month_rounded,
              color: AppColors.amber,
              size: 20,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                _heroSubtitle(context, event),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder({required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            event.coverColor.withValues(alpha: 0.72),
            event.feeling.color.withValues(alpha: 0.42),
            AppColors.wallPlum,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          event.feeling.icon,
          size: 96,
          color: Colors.white.withValues(alpha: 0.62),
        ),
      ),
    );
  }
}

class _OnThisDayHeader extends StatelessWidget {
  const _OnThisDayHeader({required this.yearsAgo});

  final int yearsAgo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.56)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_repeat_rounded, color: AppColors.amber, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              context.l10n.onThisDayHeader(yearsAgo),
              style: TextStyle(
                color: AppColors.amber,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeelingBadge extends StatelessWidget {
  const _FeelingBadge({required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.wallInk.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: event.feeling.color.withValues(alpha: 0.48)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(event.feeling.icon, color: event.feeling.color, size: 18),
          const SizedBox(width: 8),
          Text(
            '${event.feeling.localizedLabel(context.l10n)} '
            '${event.memoryType.localizedLabel(context.l10n)}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The tooltip also names the button for VoiceOver and TalkBack.
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.wallInk.withValues(alpha: 0.54),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: Icon(icon, color: AppColors.text),
          ),
        ),
      ),
    );
  }
}

class _ChapterActions extends StatelessWidget {
  const _ChapterActions({
    required this.onEdit,
    required this.onConnect,
    required this.onCreateStory,
    required this.onShareCapsule,
  });

  final VoidCallback onEdit;
  final VoidCallback onConnect;
  final VoidCallback onCreateStory;
  final VoidCallback onShareCapsule;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onShareCapsule,
            icon: const Icon(Icons.inventory_2_rounded),
            label: Text(context.l10n.shareMemoryCapsule),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded),
                label: Text(context.l10n.editStory),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.amber,
                  side: BorderSide(color: AppColors.line),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onConnect,
                icon: const Icon(Icons.hub_rounded),
                label: Text(context.l10n.connect),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.amber,
                  side: BorderSide(color: AppColors.line),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onCreateStory,
            icon: const Icon(Icons.auto_stories_rounded),
            label: Text(context.l10n.createStory),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.amber,
              side: BorderSide(color: AppColors.line),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetadataGrid extends StatelessWidget {
  const _MetadataGrid({required this.event, required this.onEdit});

  final MemoryEvent event;

  /// Each tile opens the part of the edit screen where it is changed.
  final ValueChanged<EditMemorySection> onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        _MetaCard(
          icon: Icons.auto_stories_rounded,
          label: l10n.metaType,
          value: event.memoryType.localizedLabel(l10n),
          color: AppColors.gold,
          onTap: () => onEdit(EditMemorySection.details),
        ),
        _MetaCard(
          icon: event.feeling.icon,
          label: l10n.metaFeeling,
          value: event.feeling.localizedLabel(l10n),
          color: event.feeling.color,
          onTap: () => onEdit(EditMemorySection.details),
        ),
        _MetaCard(
          icon: Icons.category_rounded,
          label: l10n.metaCategory,
          value: event.category.localizedLabel(l10n),
          color: AppColors.sage,
          onTap: () => onEdit(EditMemorySection.details),
        ),
        _MetaCard(
          icon: Icons.calendar_month_rounded,
          label: l10n.metaDate,
          value: _formatDate(context, event.occurredAt),
          color: AppColors.blue,
          onTap: () => onEdit(EditMemorySection.time),
        ),
      ],
    );
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(23),
    );
    return Semantics(
      button: true,
      hint: context.l10n.editSectionTooltip(label),
      child: Material(
        type: MaterialType.transparency,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: _metaContent(),
        ),
      ),
    );
  }

  Widget _metaContent() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.panelWarm.withValues(alpha: 0.92),
            AppColors.panel.withValues(alpha: 0.86),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 9),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection({required this.event, required this.onEdit});

  final MemoryEvent event;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      onEdit: onEdit,
      eyebrow: context.l10n.storyEyebrow,
      title: context.l10n.whyMemoryMatters,
      child: Text(
        event.description,
        style: TextStyle(
          fontSize: 18,
          height: 1.62,
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    required this.photos,
    required this.previewPhotos,
    required this.onEdit,
  });

  final List<MemoryPhoto> photos;
  final List<_PreviewPhoto> previewPhotos;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      onEdit: onEdit,
      eyebrow: context.l10n.galleryEyebrow,
      title: context.l10n.savedPhotosTitle(photos.length),
      // One photo fills the card; several scroll side by side.
      child: photos.length == 1
          ? _SinglePhoto(photo: photos.single, previewPhotos: previewPhotos)
          : SizedBox(
              height: 176,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 13),
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  final heroTag = 'memory-photo-${photo.id}';
                  final fileExists = File(photo.localPath).existsSync();
                  return GestureDetector(
                    onTap: () => _openPhotoPreview(
                      context,
                      photos: previewPhotos,
                      initialIndex: index,
                    ),
                    child: Container(
                      width: 138,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.32),
                            blurRadius: 22,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: fileExists
                          ? Hero(
                              tag: heroTag,
                              child: Image.file(
                                File(photo.localPath),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.medium,
                                errorBuilder: (_, _, _) => ColoredBox(
                                  color: AppColors.wallDeep,
                                  child: Center(
                                    child: Icon(
                                      Icons.photo_camera_back_rounded,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : ColoredBox(
                              color: AppColors.wallDeep,
                              child: Center(
                                child: Icon(Icons.broken_image_rounded),
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _PeopleSection extends StatelessWidget {
  const _PeopleSection({required this.people, required this.onEdit});

  final List<MemoryPerson> people;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      onEdit: onEdit,
      eyebrow: context.l10n.peopleEyebrow,
      title: context.l10n.partOfMemory,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final person in people)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: AppColors.panelWarm.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.22),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_rounded, color: AppColors.gold, size: 19),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        _personContactLabel(person),
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _personContactLabel(MemoryPerson person) {
    final contact = person.phone ?? person.email;
    return contact == null
        ? person.relationship
        : '${person.relationship} • $contact';
  }
}

class _ConnectedNotesSection extends StatelessWidget {
  const _ConnectedNotesSection({required this.notes});

  final List<WallItem> notes;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      eyebrow: context.l10n.notesEyebrow,
      title: context.l10n.attachedThoughts,
      child: Column(
        children: [
          for (final note in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AttachedNoteCard(note: note),
            ),
        ],
      ),
    );
  }
}

class _AttachedNoteCard extends StatelessWidget {
  const _AttachedNoteCard({required this.note});

  final WallItem note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.card.withValues(alpha: 0.96),
            AppColors.gold.withValues(alpha: 0.72),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              color: AppColors.paperInk,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.stickyNote,
                  style: TextStyle(
                    color: AppColors.paperInk,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  note.content,
                  style: TextStyle(
                    color: AppColors.paperInk,
                    fontSize: 16,
                    height: 1.38,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  const _MapSection({required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      eyebrow: context.l10n.placeEyebrow,
      title: event.locationDisplayLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MemoryMapPreview(event: event),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _openInMaps(event),
            icon: const Icon(Icons.map_rounded),
            label: Text(context.l10n.openInMaps),
          ),
        ],
      ),
    );
  }
}

/// Opens the phone's maps app at the memory's place.
Future<void> _openInMaps(MemoryEvent event) async {
  final lat = event.latitude!;
  final lng = event.longitude!;
  final name = event.locationDisplayLabel;
  final uri = defaultTargetPlatform == TargetPlatform.iOS
      ? Uri.https('maps.apple.com', '/', {'ll': '$lat,$lng', 'q': name})
      : Uri.parse('geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(name)})');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// A memory's only photo, across the whole card in its own proportions.
class _SinglePhoto extends StatelessWidget {
  const _SinglePhoto({required this.photo, required this.previewPhotos});

  final MemoryPhoto photo;
  final List<_PreviewPhoto> previewPhotos;

  @override
  Widget build(BuildContext context) {
    final ratio = photo.width > 0 && photo.height > 0
        ? (photo.width / photo.height).clamp(0.75, 1.6)
        : 4 / 3;
    final exists = File(photo.localPath).existsSync();
    return GestureDetector(
      onTap: () =>
          _openPhotoPreview(context, photos: previewPhotos, initialIndex: 0),
      child: AspectRatio(
        aspectRatio: ratio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: exists
              ? Hero(
                  tag: 'memory-photo-${photo.id}',
                  child: Image.file(
                    File(photo.localPath),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (_, _, _) => ColoredBox(
                      color: AppColors.wallDeep,
                      child: const Center(
                        child: Icon(Icons.photo_camera_back_rounded),
                      ),
                    ),
                  ),
                )
              : ColoredBox(
                  color: AppColors.wallDeep,
                  child: const Center(child: Icon(Icons.broken_image_rounded)),
                ),
        ),
      ),
    );
  }
}

class _ConnectedThreadPath extends StatelessWidget {
  const _ConnectedThreadPath({
    required this.memoryId,
    required this.events,
    required this.state,
    required this.onEdit,
  });

  final String memoryId;
  final List<MemoryEvent> events;
  final MemoryState state;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      onEdit: onEdit,
      eyebrow: context.l10n.threadsEyebrow,
      title: context.l10n.connectedMemories,
      child: events.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.noConnectedMemoriesYet,
                  style: TextStyle(color: AppColors.muted, height: 1.45),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.hub_rounded),
                  label: Text(context.l10n.connect),
                ),
              ],
            )
          // The connected memories hang on a rope, like on the wall.
          : SizedBox(
              height: 292,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: events.length,
                itemBuilder: (context, index) => _ThreadPolaroid(
                  event: events[index],
                  reason: state
                      .connectionBetween(memoryId, events[index].id)
                      ?.reason,
                  tilt: index.isEven ? -0.03 : 0.025,
                ),
              ),
            ),
    );
  }
}

/// One connected memory: a small photo on paper, pinned to the rope, with
/// the reason for the thread underneath.
class _ThreadPolaroid extends StatelessWidget {
  const _ThreadPolaroid({
    required this.event,
    required this.reason,
    required this.tilt,
  });

  final MemoryEvent event;
  final String? reason;
  final double tilt;

  static const _width = 156.0;

  @override
  Widget build(BuildContext context) {
    final why = reason?.trim();
    final date = _formatDate(context, event.occurredAt);
    return SizedBox(
      width: _width + 16,
      child: Semantics(
        button: true,
        label: [
          event.title,
          date,
          if (why != null && why.isNotEmpty) why,
        ].join(', '),
        excludeSemantics: true,
        child: GestureDetector(
          onTap: () => context.push('/memories/${event.id}'),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // The rope runs through every item, so the pieces join up.
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 24,
                child: CustomPaint(painter: _RopePainter()),
              ),
              Positioned(
                left: 8,
                right: 8,
                top: 12,
                child: Column(
                  children: [
                    Transform.rotate(
                      angle: tilt,
                      alignment: Alignment.topCenter,
                      child: _paper(context, date),
                    ),
                    if (why != null && why.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        '“$why”',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // The pin, on the rope.
              Positioned(
                top: 8,
                left: _width / 2 + 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paper(BuildContext context, String date) {
    final path = event.coverPhotoPath;
    final isAsset = path?.startsWith('assets/') ?? false;
    final exists = path != null && (isAsset || File(path).existsSync());
    final fallback = ColoredBox(
      color: event.coverColor,
      child: Center(child: Icon(event.feeling.icon, color: AppColors.text)),
    );
    return Container(
      width: _width,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: !exists
                  ? fallback
                  : isAsset
                  ? Image.asset(path, fit: BoxFit.cover)
                  : Image.file(
                      File(path),
                      fit: BoxFit.cover,
                      cacheWidth: 400,
                      errorBuilder: (_, _, _) => fallback,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.paperInk,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            date,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.paperMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// A piece of rope across the item, sagging a little in the middle.
class _RopePainter extends CustomPainter {
  const _RopePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.rope.withValues(alpha: 0.85)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, 8)
      ..quadraticBezierTo(size.width / 2, 20, size.width, 8);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RopePainter oldDelegate) => false;
}

class _ChapterPanel extends StatelessWidget {
  const _ChapterPanel({
    required this.eyebrow,
    required this.title,
    required this.child,
    this.onEdit,
  });

  final String eyebrow;
  final String title;
  final Widget child;

  /// Shows a pencil in the card's top corner that edits this part.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.panelWarm.withValues(alpha: 0.9),
              AppColors.panel.withValues(alpha: 0.86),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    eyebrow.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    tooltip: context.l10n.editSectionTooltip(eyebrow),
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.gold.withValues(alpha: 0.12),
                      foregroundColor: AppColors.gold,
                    ),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.45,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _NotFoundState extends StatelessWidget {
  const _NotFoundState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () => _backToWall(context),
        child: Text(context.l10n.backToWall),
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

void _openPhotoPreview(
  BuildContext context, {
  required List<_PreviewPhoto> photos,
  required int initialIndex,
}) {
  if (photos.isEmpty) return;
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black.withValues(alpha: 0.94),
      pageBuilder: (_, _, _) =>
          _PhotoPreviewPage(photos: photos, initialIndex: initialIndex),
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

class _PhotoPreviewPage extends StatefulWidget {
  const _PhotoPreviewPage({required this.photos, required this.initialIndex});

  final List<_PreviewPhoto> photos;
  final int initialIndex;

  @override
  State<_PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<_PhotoPreviewPage> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.photos.length - 1);
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.photos[_index];

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.96),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.photos.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) {
                  final photo = widget.photos[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 4,
                      child: Center(child: _PreviewPhotoImage(photo: photo)),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      current.title ?? context.l10n.photoNumber(_index + 1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.photos.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_index + 1} / ${widget.photos.length}',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < widget.photos.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: i == _index ? 22 : 7,
                            height: 7,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: i == _index
                                  ? AppColors.gold
                                  : AppColors.muted.withValues(alpha: 0.42),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PreviewPhoto {
  const _PreviewPhoto({required this.path, required this.heroTag, this.title});

  final String path;
  final String heroTag;

  /// The memory's title for its cover; null for photos, which are named
  /// by their place in the viewer ("Photo 2").
  final String? title;
}

class _PreviewPhotoImage extends StatelessWidget {
  const _PreviewPhotoImage({required this.photo});

  final _PreviewPhoto photo;

  @override
  Widget build(BuildContext context) {
    final isAsset = photo.path.startsWith('assets/');
    final exists = isAsset || File(photo.path).existsSync();
    if (!exists) {
      return Icon(Icons.broken_image_rounded, color: AppColors.muted, size: 72);
    }

    return Hero(
      tag: photo.heroTag,
      child: isAsset
          ? Image.asset(
              photo.path,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.broken_image_rounded,
                color: AppColors.muted,
                size: 72,
              ),
            )
          : Image.file(
              File(photo.path),
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.broken_image_rounded,
                color: AppColors.muted,
                size: 72,
              ),
            ),
    );
  }
}

List<_PreviewPhoto> _heroPreviewPhotos(
  MemoryEvent event,
  List<MemoryPhoto> photos,
) {
  final coverPath = event.coverPhotoPath;
  final previewPhotos = <_PreviewPhoto>[];
  if (coverPath != null &&
      (coverPath.startsWith('assets/') || File(coverPath).existsSync())) {
    previewPhotos.add(
      _PreviewPhoto(
        path: coverPath,
        heroTag: 'memory-cover-${event.id}',
        title: event.title,
      ),
    );
  }
  previewPhotos.addAll(
    photos
        .where((photo) => photo.localPath != coverPath)
        .map(
          (photo) => _PreviewPhoto(
            path: photo.localPath,
            heroTag: 'memory-photo-${photo.id}',
          ),
        ),
  );
  return previewPhotos;
}

List<_PreviewPhoto> _galleryPreviewPhotos(List<MemoryPhoto> photos) {
  return [
    for (var index = 0; index < photos.length; index++)
      _PreviewPhoto(
        path: photos[index].localPath,
        heroTag: 'memory-photo-${photos[index].id}',
      ),
  ];
}

String _heroSubtitle(BuildContext context, MemoryEvent event) {
  final date = _formatDate(context, event.occurredAt);
  if (!event.hasGeoPoint) return date;
  return '${event.locationDisplayLabel} • $date';
}

String _formatDate(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMd(locale).format(date);
}

/// Back, capsule, edit and connect: fixed over the memory while it scrolls.
/// Tells [builder] whether the scroll view below it has scrolled more than
/// [offset], e.g. past the memory's photo.
class _ScrolledPast extends StatefulWidget {
  const _ScrolledPast({required this.offset, required this.builder});

  final double offset;
  final Widget Function(BuildContext context, bool past) builder;

  @override
  State<_ScrolledPast> createState() => _ScrolledPastState();
}

class _ScrolledPastState extends State<_ScrolledPast> {
  var _past = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth != 0) return false;
        final past = notification.metrics.pixels > widget.offset;
        if (past != _past) setState(() => _past = past);
        return false;
      },
      child: widget.builder(context, _past),
    );
  }
}

class _DetailTopButtons extends StatelessWidget {
  const _DetailTopButtons({
    required this.solid,
    required this.onBack,
    required this.onEdit,
    required this.onConnect,
    required this.onShareCapsule,
  });

  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onConnect;
  final VoidCallback onShareCapsule;

  /// Past the photo the bar gets a background, so text scrolling beneath
  /// it (and under the status bar) stays out of the way.
  final bool solid;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: solid ? AppColors.wallInk : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: solid ? AppColors.line : Colors.transparent,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GlassIconButton(
                icon: Icons.arrow_back_rounded,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onTap: onBack,
              ),
              const Spacer(),
              _GlassIconButton(
                icon: Icons.inventory_2_rounded,
                tooltip: context.l10n.shareMemoryCapsule,
                onTap: onShareCapsule,
              ),
              const SizedBox(width: 8),
              _GlassIconButton(
                icon: Icons.edit_rounded,
                tooltip: context.l10n.editMemoryTooltip,
                onTap: onEdit,
              ),
              const SizedBox(width: 8),
              _GlassIconButton(
                icon: Icons.hub_rounded,
                tooltip: context.l10n.connectMemoryTooltip,
                onTap: onConnect,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A quiet one-line invitation (e.g. "Who was there? Add person") where a
/// section would otherwise be missing.
class _HintRow extends StatelessWidget {
  const _HintRow({
    super.key,
    required this.icon,
    required this.text,
    required this.action,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: AppColors.line),
    );
    return Material(
      color: AppColors.panelWarm.withValues(alpha: 0.6),
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.gold),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                action,
                style: TextStyle(
                  color: AppColors.amber,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
