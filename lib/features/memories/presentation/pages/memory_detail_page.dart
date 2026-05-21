import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../features/backup/domain/backup_models.dart';
import '../../../../features/capsule/data/memory_capsule_cloud_share_service.dart';
import '../../../../features/capsule/data/memory_capsule_service.dart';
import '../../../../features/capsule/presentation/widgets/memory_capsule_dialogs.dart';
import '../../../../features/map/presentation/widgets/memory_map_preview.dart';
import '../../data/memory_repository.dart';
import '../../domain/memory_event.dart';
import '../../domain/memory_photo.dart';
import '../../domain/memory_person.dart';
import '../../../wall/domain/wall_item.dart';

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
          final galleryPhotos = _galleryPreviewPhotos(photos);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _CinematicHero(
                  event: event,
                  previewPhotos: heroPhotos,
                  onBack: () => _backToWall(context),
                  onEdit: () => context.push('/memories/$memoryId/edit'),
                  onConnect: () =>
                      context.push('/memories/$memoryId/connections'),
                  onShareCapsule: () =>
                      _shareCloudCapsule(context, ref, state, memoryId),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ChapterActions(
                        onEdit: () => context.push('/memories/$memoryId/edit'),
                        onConnect: () =>
                            context.push('/memories/$memoryId/connections'),
                        onShareCapsule: () =>
                            _shareCloudCapsule(context, ref, state, memoryId),
                      ),
                      const SizedBox(height: 18),
                      _MetadataGrid(event: event),
                      const SizedBox(height: 22),
                      _StorySection(event: event),
                      if (people.isNotEmpty) ...[
                        const SizedBox(height: 22),
                        _PeopleSection(people: people),
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
                        ),
                      ],
                      const SizedBox(height: 22),
                      _MapSection(event: event),
                      const SizedBox(height: 22),
                      _ConnectedThreadPath(
                        memoryId: memoryId,
                        events: connectedEvents,
                        state: state,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
          title: 'LifeThreads memory',
          subject: 'LifeThreads memory',
          text:
              'Hey, I shared a memory with you in LifeThreads.\n\n${cloudShare.shareUrl}',
        ),
      );
      if (!context.mounted) return;
      final label = switch (shareResult.status) {
        ShareResultStatus.success => 'Share link ready.',
        ShareResultStatus.dismissed => 'Share link created.',
        ShareResultStatus.unavailable =>
          'Share link created, but sharing is unavailable.',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 9),
          content: Text(
            '$label Link expires automatically. You can delete it now.',
          ),
          action: SnackBarAction(
            label: 'Delete',
            onPressed: () {
              unawaited(_deleteSharedCapsule(context, ref, cloudShare));
            },
          ),
        ),
      );
    } on BackupValidationException catch (error) {
      if (context.mounted && progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        progressVisible = false;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capsule rejected: ${error.message}')),
      );
    } on MemoryCapsuleCloudShareException catch (error) {
      if (context.mounted && progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        progressVisible = false;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cloud share failed: ${error.message}')),
      );
    } catch (error) {
      if (context.mounted && progressVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        progressVisible = false;
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cloud share failed: $error')));
    }
  }

  void _showCloudShareProgress(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _CloudShareProgressDialog(),
    );
  }

  Future<void> _deleteSharedCapsule(
    BuildContext context,
    WidgetRef ref,
    MemoryCapsuleCloudShareResult cloudShare,
  ) async {
    try {
      await ref
          .read(memoryCapsuleCloudShareServiceProvider)
          .revokeShare(cloudShare);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shared memory link deleted.')),
      );
    } on MemoryCapsuleCloudShareException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: ${error.message}')),
      );
    }
  }
}

class _CloudShareProgressDialog extends StatelessWidget {
  const _CloudShareProgressDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(width: 16),
          Expanded(child: Text('Creating secure memory link...')),
        ],
      ),
    );
  }
}

class _CinematicHero extends StatelessWidget {
  const _CinematicHero({
    required this.event,
    required this.previewPhotos,
    required this.onBack,
    required this.onEdit,
    required this.onConnect,
    required this.onShareCapsule,
  });

  final MemoryEvent event;
  final List<_PreviewPhoto> previewPhotos;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onConnect;
  final VoidCallback onShareCapsule;

  @override
  Widget build(BuildContext context) {
    final path = event.coverPhotoPath;
    final fileExists = path != null && File(path).existsSync();
    final heroTag = 'memory-cover-${event.id}';
    final height = MediaQuery.sizeOf(context).height * 0.58;

    return SizedBox(
      height: height.clamp(390.0, 520.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (fileExists)
            GestureDetector(
              onTap: () => _openPhotoPreview(
                context,
                photos: previewPhotos,
                initialIndex: 0,
              ),
              child: Hero(
                tag: heroTag,
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GlassIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: onBack,
                  ),
                  const Spacer(),
                  _GlassIconButton(
                    icon: Icons.inventory_2_rounded,
                    onTap: onShareCapsule,
                  ),
                  const SizedBox(width: 8),
                  _GlassIconButton(icon: Icons.edit_rounded, onTap: onEdit),
                  const SizedBox(width: 8),
                  _GlassIconButton(icon: Icons.hub_rounded, onTap: onConnect),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FeelingBadge(event: event),
                const SizedBox(height: 14),
                Text(
                  event.title,
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
                    const Icon(
                      Icons.place_rounded,
                      color: AppColors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        '${event.locationLabel} • ${_formatDate(event.occurredAt)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
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
            '${event.feeling.label} ${event.memoryType.label}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
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
    );
  }
}

class _ChapterActions extends StatelessWidget {
  const _ChapterActions({
    required this.onEdit,
    required this.onConnect,
    required this.onShareCapsule,
  });

  final VoidCallback onEdit;
  final VoidCallback onConnect;
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
            label: const Text('Share Memory Capsule'),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Edit story'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.amber,
                  side: const BorderSide(color: AppColors.line),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onConnect,
                icon: const Icon(Icons.hub_rounded),
                label: const Text('Connect'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.amber,
                  side: const BorderSide(color: AppColors.line),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetadataGrid extends StatelessWidget {
  const _MetadataGrid({required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
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
          label: 'Type',
          value: event.memoryType.label,
          color: AppColors.gold,
        ),
        _MetaCard(
          icon: event.feeling.icon,
          label: 'Feeling',
          value: event.feeling.label,
          color: event.feeling.color,
        ),
        _MetaCard(
          icon: Icons.category_rounded,
          label: 'Category',
          value: event.category.label,
          color: AppColors.sage,
        ),
        _MetaCard(
          icon: Icons.calendar_month_rounded,
          label: 'Date',
          value: _formatDate(event.occurredAt),
          color: AppColors.blue,
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
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
            style: const TextStyle(
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
  const _StorySection({required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      eyebrow: 'Story',
      title: 'Why this memory matters',
      child: Text(
        event.description,
        style: const TextStyle(
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
  const _GallerySection({required this.photos, required this.previewPhotos});

  final List<MemoryPhoto> photos;
  final List<_PreviewPhoto> previewPhotos;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      eyebrow: 'Gallery',
      title: '${photos.length} saved photo${photos.length == 1 ? '' : 's'}',
      child: SizedBox(
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
                        ),
                      )
                    : const ColoredBox(
                        color: AppColors.wallDeep,
                        child: Center(child: Icon(Icons.broken_image_rounded)),
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
  const _PeopleSection({required this.people});

  final List<MemoryPerson> people;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      eyebrow: 'People',
      title: 'Part of this memory',
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
                  const Icon(
                    Icons.person_rounded,
                    color: AppColors.gold,
                    size: 19,
                  ),
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
                        style: const TextStyle(
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
      eyebrow: 'Notes',
      title: 'Attached thoughts',
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
            decoration: const BoxDecoration(
              color: AppColors.paperInk,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sticky note',
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
                  style: const TextStyle(
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
      eyebrow: 'Place',
      title: event.locationLabel,
      child: MemoryMapPreview(event: event),
    );
  }
}

class _ConnectedThreadPath extends StatelessWidget {
  const _ConnectedThreadPath({
    required this.memoryId,
    required this.events,
    required this.state,
  });

  final String memoryId;
  final List<MemoryEvent> events;
  final MemoryState state;

  @override
  Widget build(BuildContext context) {
    return _ChapterPanel(
      eyebrow: 'Threads',
      title: 'Connected memories',
      child: events.isEmpty
          ? const Text(
              'No connected memories yet. Connect this chapter to another moment to start a visible life thread.',
              style: TextStyle(color: AppColors.muted, height: 1.45),
            )
          : Column(
              children: [
                for (var index = 0; index < events.length; index++)
                  _ConnectedMemoryNode(
                    event: events[index],
                    reason: state
                        .connectionBetween(memoryId, events[index].id)
                        ?.label,
                    isLast: index == events.length - 1,
                  ),
              ],
            ),
    );
  }
}

class _ConnectedMemoryNode extends StatelessWidget {
  const _ConnectedMemoryNode({
    required this.event,
    required this.reason,
    required this.isLast,
  });

  final MemoryEvent event;
  final String? reason;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cleanReason = reason?.trim();

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.push('/memories/${event.id}'),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 34,
              child: Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: event.feeling.color,
                      boxShadow: [
                        BoxShadow(
                          color: event.feeling.color.withValues(alpha: 0.28),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        color: AppColors.rope.withValues(alpha: 0.58),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.wallInk.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: event.coverColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cleanReason?.isNotEmpty == true
                                  ? cleanReason!
                                  : event.locationLabel,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.muted,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterPanel extends StatelessWidget {
  const _ChapterPanel({
    required this.eyebrow,
    required this.title,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final Widget child;

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
            Text(
              eyebrow.toUpperCase(),
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.3,
              ),
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
        child: const Text('Back to wall'),
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
                      child: Center(
                        child: File(photo.path).existsSync()
                            ? Hero(
                                tag: photo.heroTag,
                                child: Image.file(
                                  File(photo.path),
                                  fit: BoxFit.contain,
                                ),
                              )
                            : const Icon(
                                Icons.broken_image_rounded,
                                color: AppColors.muted,
                                size: 72,
                              ),
                      ),
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
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      current.title,
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
                      style: const TextStyle(
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
  const _PreviewPhoto({
    required this.path,
    required this.heroTag,
    required this.title,
  });

  final String path;
  final String heroTag;
  final String title;
}

List<_PreviewPhoto> _heroPreviewPhotos(
  MemoryEvent event,
  List<MemoryPhoto> photos,
) {
  final coverPath = event.coverPhotoPath;
  final previewPhotos = <_PreviewPhoto>[];
  if (coverPath != null && File(coverPath).existsSync()) {
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
            title: _photoTitle(photos.indexOf(photo)),
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
        title: _photoTitle(index),
      ),
  ];
}

String _photoTitle(int index) => 'Photo ${index + 1}';

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
