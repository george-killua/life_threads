import 'dart:async';
import 'dart:math' as math;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../memories/data/memory_seed_data.dart';
import '../../../memories/domain/memory_event.dart';
import '../../../memories/domain/memory_photo.dart';
import '../../../premium/domain/premium_feature.dart';
import '../../../premium/presentation/premium_gate.dart';
import '../../../tour/app_tour.dart';
import '../../../tour/coach.dart';
import '../../data/music_preview.dart';
import '../../data/story_exporter.dart';
import '../../domain/music_track.dart';
import '../../domain/story_template.dart';
import '../story_template_film.dart';
import '../templates/story_templates.dart';
import '../templates/story_visuals.dart';
import '../story_template_l10n.dart';
import '../widgets/music_trimmer.dart';
import '../widgets/story_film_preview.dart';
import '../widgets/story_playback.dart';
import 'story_music_page.dart';
import 'story_style_page.dart';
import '../widgets/story_export_progress_dialog.dart';
import '../widgets/story_memory_strip.dart';
import '../widgets/story_search_field.dart';
import '../../../../core/widgets/app_toast.dart';

/// Create Story: pick 1–6 memories, choose a template, edit the caption,
/// optionally make it a film with music, then share or save. The preview
/// is free; sharing and saving need Premium.
class CreateStoryPage extends ConsumerStatefulWidget {
  const CreateStoryPage({super.key, this.initialMemoryId});

  /// Started from a memory: it is picked and the editor opens directly.
  final String? initialMemoryId;

  @override
  ConsumerState<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends ConsumerState<CreateStoryPage>
    with SingleTickerProviderStateMixin {
  late StorySelection _selection;
  late bool _editing;
  final _caption = TextEditingController();
  var _captionEdited = false;
  var _captionReady = false;

  /// Picture (one image with every memory) or video (a film with music).
  /// The tour makes a video: it shows the music too.
  var _video = appTourRunning;
  late var _template = StoryTemplate.defaultFor(video: _video);

  /// A picture's shape: story, feed post or square.
  var _format = StoryFormat.story;
  MusicTrack? _music;

  /// The film length the user chose; null for the animation's own.
  Duration? _length;

  /// The tour picked its example memories already.
  var _tourPicked = false;

  /// Where the chosen song starts in the film (see [MusicTrimmer]).
  var _musicStart = Duration.zero;
  late final MusicPreview _preview;

  /// The chosen song, playing in step with the preview (as in the video).
  late final StoryPlayback _playback;

  /// The user turned the sound off on the preview.
  var _soundOn = true;

  /// The photo chosen for a memory with several (memory id → photo path).
  final _photoChoice = <String, String>{};
  List<MemoryPhoto> Function(String id) _photosFor = (_) => const [];

  Future<void> _choosePhoto(MemoryEvent memory) async {
    final photos = _photosFor(memory.id);
    if (photos.length < 2) return;
    final chosen = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.wallInk,
      builder: (context) => _PhotoChoiceSheet(
        title: memory.title,
        photos: photos,
        selected: _photoChoice[memory.id] ?? memory.coverPhotoPath,
      ),
    );
    if (chosen == null || !mounted) return;
    setState(() => _photoChoice[memory.id] = chosen);
  }

  var _busy = false;
  final _shareButtonKey = GlobalKey();

  /// The last export, reused while nothing changed (Share then Save).
  ({String signature, File file})? _exported;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialMemoryId;
    _selection = initial == null
        ? const StorySelection()
        : StorySelection([initial]);
    _editing = initial != null;
    _preview = ref.read(musicPreviewProvider);
    _playback = StoryPlayback(preview: _preview, vsync: this);
  }

  /// The film length for [memories] as the story looks now.
  Duration _filmLength(List<MemoryEvent> memories) => _film(memories).duration;

  StoryTemplateFilm _film(List<MemoryEvent> memories, {String? caption}) =>
      StoryTemplateFilm(
        template: _template,
        memories: memories,
        caption: caption ?? _caption.text,
        length: _length,
      );

  /// Keeps the playing song in step with the story as it is now: another
  /// length or song part starts it over; no video or no song stops it.
  void _syncPlayback(List<MemoryEvent> memories) {
    if (!mounted) return;
    final music = _video ? _music : null;
    final changed = _playback.configure(
      track: music,
      start: _musicStart,
      length: _filmLength(memories),
    );
    if (changed && music != null && _playback.playing) {
      unawaited(_playback.play());
    }
  }

  /// Plays the song with the preview, unless the user turned the sound off.
  void _resumeMusic(List<MemoryEvent> memories) {
    if (!mounted || !_video || _music == null || !_soundOn) return;
    _syncPlayback(memories);
    unawaited(_playback.play());
  }

  /// Picture or video; a look the other mode doesn't offer changes to
  /// that mode's first one.
  void _setMode(bool video, List<MemoryEvent> memories) {
    if (video == _video) return;
    setState(() {
      _video = video;
      final offered = video ? _template.forVideo : _template.forPicture;
      if (!offered) _template = StoryTemplate.defaultFor(video: video);
    });
    if (video) {
      _resumeMusic(memories);
    } else {
      _syncPlayback(memories);
    }
  }

  void _changeMemories() {
    unawaited(_playback.pause());
    setState(() => _editing = false);
  }

  Future<void> _chooseAnimation(List<MemoryEvent> memories) async {
    unawaited(_playback.pause());
    final chosen = await Navigator.of(context).push<StoryTemplate>(
      MaterialPageRoute(
        builder: (_) => StoryStylePage(
          selected: _template,
          memories: memories,
          video: _video,
          format: _format,
        ),
      ),
    );
    if (!mounted) return;
    if (chosen != null) setState(() => _template = chosen);
    _resumeMusic(memories);
  }

  /// Music and length; choosing either makes the story a video.
  Future<void> _chooseMusic(List<MemoryEvent> memories) async {
    // The music screen plays the song itself.
    unawaited(_playback.pause());
    final chosen = await Navigator.of(context).push<StoryMusicChoice>(
      MaterialPageRoute(
        builder: (_) => StoryMusicPage(
          filmFor: (length) => StoryTemplateFilm(
            template: _template,
            memories: memories,
            caption: _caption.text,
            length: length,
          ),
          track: _music,
          start: _musicStart,
          length: _length,
        ),
      ),
    );
    if (!mounted) return;
    if (chosen != null) {
      setState(() {
        _music = chosen.track;
        _musicStart = chosen.start;
        _length = chosen.length;
        if (chosen.track != null || chosen.length != null) _video = true;
        if (chosen.track != null) _soundOn = true;
      });
    }
    // Back on the story: the song plays on with the preview.
    _resumeMusic(memories);
  }

  /// Applies a change to the memories in the story from the editor. The
  /// caption follows the first memory until the user edits it.
  void _changeSelection(StorySelection selection, List<MemoryEvent> events) {
    setState(() {
      _selection = selection;
      if (!_captionEdited) {
        _caption.text = defaultStoryCaption(selection.resolve(events));
      }
    });
  }

  Future<void> _addMemory(List<MemoryEvent> events) async {
    final added = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.wallInk,
      builder: (context) => _AddMemorySheet(
        events: [
          for (final event in events)
            if (!_selection.contains(event.id)) event,
        ],
      ),
    );
    if (added == null || !mounted) return;
    _changeSelection(_selection.toggle(added), events);
  }

  @override
  void dispose() {
    _playback.dispose();
    unawaited(_preview.stop());
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final memoryState = ref.watch(memoryRepositoryProvider);
    return Scaffold(
      backgroundColor: AppColors.wallInk,
      appBar: AppBar(
        title: Text(_editing ? l10n.storyEditorTitle : l10n.storyPickTitle),
        actions: [
          // On narrow phones (or with large text) only the icon fits next
          // to the title.
          if (_editing && MediaQuery.sizeOf(context).width >= 400)
            TextButton.icon(
              onPressed: _busy ? null : _changeMemories,
              icon: const Icon(Icons.photo_library_rounded),
              label: Text(l10n.storyChangeMemories),
            )
          else if (_editing)
            IconButton(
              tooltip: l10n.storyChangeMemories,
              onPressed: _busy ? null : _changeMemories,
              icon: const Icon(Icons.photo_library_rounded),
            ),
        ],
      ),
      body: memoryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (state) {
          // A story started from a hidden memory (shown after Face ID) may
          // use that memory; the picker still offers visible ones only.
          final initial = widget.initialMemoryId == null
              ? null
              : state.findEvent(widget.initialMemoryId!);
          final events = [
            ...state.visibleEvents,
            if (initial != null && initial.hidden) initial,
          ];
          // The tour starts the story with three example memories.
          if (appTourRunning && !_tourPicked && _selection.isEmpty) {
            _tourPicked = true;
            final examples = [
              for (final event in events)
                if (MemorySeedData.isDemoEventId(event.id)) event.id,
            ];
            _selection = StorySelection(examples.take(3).toList());
          }
          // The photo the user chose for a memory stands in for its cover.
          final memories = [
            for (final memory in _selection.resolve(events))
              if (_photoChoice[memory.id] case final path?)
                memory.copyWith(coverPhotoPath: path)
              else
                memory,
          ];
          _photosFor = state.photosForEvent;
          if (_editing && memories.isNotEmpty) {
            // Started from a memory: its story is the first caption. Set
            // before the caption field exists, so no listener fires.
            if (!_captionReady) {
              _captionReady = true;
              _caption.text = defaultStoryCaption(memories);
            }
            return _buildEditor(context, memories, events);
          }
          return _StoryMemoryPicker(
            events: events,
            selection: _selection,
            onChanged: (selection) => setState(() => _selection = selection),
            onContinue: () => setState(() {
              if (!_captionEdited) {
                _caption.text = defaultStoryCaption(_selection.resolve(events));
              }
              _captionReady = true;
              _editing = true;
            }),
          );
        },
      ),
    );
  }

  Widget _buildEditor(
    BuildContext context,
    List<MemoryEvent> memories,
    List<MemoryEvent> events,
  ) {
    final l10n = context.l10n;
    final isPremium = ref.watch(premiumActiveProvider);
    final filmLength = _filmLength(memories);
    // A new song part, length or set of memories restarts the song with the
    // film (after this frame: it notifies the sound button).
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _syncPlayback(memories),
    );
    final music = _music;
    final preview = AspectRatio(
      aspectRatio: _video ? 9 / 16 : _format.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          StoryFilmPreview(
            key: ValueKey('story-preview-${_template.name}'),
            film: _film(memories),
            animate: _video,
            format: _format,
            // With a song the film follows it, as in the video.
            time: _video && _music != null ? _playback.filmTime : null,
          ),
          if (_video && _music != null)
            PositionedDirectional(
              end: 8,
              bottom: 8,
              child: ListenableBuilder(
                listenable: _playback,
                builder: (context, _) => IconButton.filled(
                  key: const ValueKey('story-preview-sound'),
                  tooltip: _playback.playing
                      ? l10n.storyMusicPause
                      : l10n.storyMusicPlay,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.55),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_playback.playing) {
                      _soundOn = false;
                      unawaited(_playback.pause());
                    } else {
                      _soundOn = true;
                      _resumeMusic(memories);
                    }
                  },
                  icon: Icon(
                    _playback.playing
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    return SafeArea(
      top: false,
      child: Column(
        children: [
          // Preview, memories and settings scroll as one page: the preview
          // shrinks to a small pinned one, so small phones show the settings.
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxPreview = (constraints.maxHeight * 0.5).clamp(
                  150.0,
                  560.0,
                );
                return CustomScrollView(
                  key: const ValueKey('story-settings'),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _PreviewHeader(
                        min: math.min(maxPreview, 132),
                        max: maxPreview,
                        child: preview,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          StoryMemoryStrip(
                            memories: memories,
                            canAdd:
                                !_selection.isFull &&
                                memories.length < events.length,
                            onReorder: (from, to) => _changeSelection(
                              _selection.move(from, to),
                              events,
                            ),
                            onRemove: (id) =>
                                _changeSelection(_selection.remove(id), events),
                            onAdd: () => _addMemory(events),
                            photoCounts: {
                              for (final memory in memories)
                                memory.id: _photosFor(memory.id).length,
                            },
                            onChoosePhoto: _busy
                                ? null
                                : (id) => _choosePhoto(
                                    memories.firstWhere(
                                      (memory) => memory.id == id,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Divider(height: 1, color: AppColors.line),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                      sliver: SliverList.list(
                        children: [
                          _ModeChooser(
                            video: _video,
                            onChanged: _busy
                                ? null
                                : (video) => _setMode(video, memories),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _video
                                ? l10n.storyModeVideoHint
                                : l10n.storyModePictureHint,
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12.5,
                            ),
                          ),
                          if (!_video) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                for (final format in StoryFormat.values)
                                  ChoiceChip(
                                    key: ValueKey(
                                      'story-format-${format.name}',
                                    ),
                                    label: Text(_formatLabel(l10n, format)),
                                    selected: format == _format,
                                    onSelected: _busy
                                        ? null
                                        : (_) => setState(() {
                                            _format = format;
                                            if (!_template.fits(format)) {
                                              _template =
                                                  StoryTemplate.defaultFor(
                                                    video: false,
                                                  );
                                            }
                                          }),
                                  ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 14),
                          TextField(
                            key: const ValueKey('story-caption'),
                            controller: _caption,
                            maxLength: 160,
                            maxLines: 2,
                            minLines: 1,
                            decoration: InputDecoration(
                              labelText: l10n.storyCaptionLabel,
                              hintText: l10n.storyCaptionHint,
                              // The limit still holds; the counter only took room.
                              counterText: '',
                            ),
                            onChanged: (_) =>
                                setState(() => _captionEdited = true),
                          ),
                          CoachTarget(
                            id: TourTargets.storyAnimation,
                            child: _EditorRow(
                              key: const ValueKey('story-animation-row'),
                              icon: storyTemplateIcon(_template),
                              title: _video
                                  ? l10n.storyAnimationTitle
                                  : l10n.storyLayoutTitle,
                              value: storyTemplateLabel(l10n, _template),
                              onTap: _busy
                                  ? null
                                  : () => _chooseAnimation(memories),
                            ),
                          ),
                          if (_video)
                            CoachTarget(
                              id: TourTargets.storyMusic,
                              child: _EditorRow(
                                key: const ValueKey('story-music-row'),
                                icon: Icons.music_note_rounded,
                                title: l10n.storyMusicTitle,
                                value: music == null
                                    ? l10n.storyMusicNone
                                    : '${music.title} · '
                                          '${_range(MusicTrimmer.clampStart(music, filmLength, _musicStart), filmLength)}',
                                trailing: l10n.storyLengthSeconds(
                                  '${(filmLength.inMilliseconds / 1000).round()}',
                                ),
                                onTap: _busy
                                    ? null
                                    : () => _chooseMusic(memories),
                              ),
                            ),
                          if (!isPremium) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.workspace_premium_rounded,
                                  color: AppColors.gold,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.storyPreviewFree,
                                    style: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 12.5,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey('story-save'),
                    onPressed: _busy ? null : () => _save(memories),
                    icon: const Icon(Icons.download_rounded),
                    // One line in every language: a long label shrinks a
                    // little instead of breaking a word.
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(l10n.storySaveToPhotos, maxLines: 1),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.amber,
                      side: BorderSide(color: AppColors.line),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CoachTarget(
                    id: TourTargets.storyShare,
                    child: FilledButton.icon(
                      key: _shareButtonKey,
                      onPressed: _busy ? null : () => _share(memories),
                      icon: _busy
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.ios_share_rounded),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(l10n.storyShare, maxLines: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PremiumFeature get _feature =>
      _video ? PremiumFeature.storyVideo : PremiumFeature.storyImage;

  Future<void> _share(List<MemoryEvent> memories) async {
    // The paywall or the export comes next: the preview song stops either way.
    unawaited(_playback.pause());
    if (!await requirePremium(context, _feature)) return;
    if (!mounted) return;
    final file = await _export(memories);
    if (file == null || !mounted) return;
    // The share popover points at the button on iPad.
    final anchor = _shareButtonKey.currentContext ?? context;
    if (!anchor.mounted) return;
    try {
      await ref.read(storyExporterProvider).share(anchor, file);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _save(List<MemoryEvent> memories) async {
    unawaited(_playback.pause());
    if (!await requirePremium(context, _feature)) return;
    if (!mounted) return;
    final file = await _export(memories);
    if (file == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      await ref.read(storyExporterProvider).saveToGallery(file);
      messenger.showToast(l10n.storySaved, kind: ToastKind.success);
    } on StoryGalleryAccessDenied {
      messenger.showToast(l10n.storySaveDenied, kind: ToastKind.error);
    } catch (error) {
      _showError(error);
    }
  }

  /// Renders the story as it looks now, or reuses the last file when
  /// nothing changed. Null when cancelled or failed (the user was told).
  Future<File?> _export(List<MemoryEvent> memories) async {
    final caption = _caption.text.trim();
    final signature = [
      _template.name,
      _video,
      _music?.id,
      _musicStart,
      _length,
      _format,
      caption,
      for (final memory in memories) memory.id,
    ].join('|');
    final previous = _exported;
    if (previous != null &&
        previous.signature == signature &&
        await previous.file.exists()) {
      return previous.file;
    }
    if (!mounted) return null;
    final exporter = ref.read(storyExporterProvider);
    unawaited(_playback.pause());
    setState(() => _busy = true);
    try {
      final File? file;
      if (_video) {
        final film = _film(memories, caption: caption);
        file = await runStoryVideoExport(
          context,
          (context, onProgress, cancel) => exporter.exportVideo(
            context,
            film,
            music: _music,
            musicStart: _music == null
                ? Duration.zero
                : MusicTrimmer.clampStart(_music!, film.duration, _musicStart),
            onProgress: onProgress,
            cancel: cancel,
          ),
        );
      } else {
        file = await exporter.exportImage(
          context,
          StoryPage(
            template: _template,
            memories: memories,
            caption: caption,
            format: _format,
          ),
          size: _format.size,
        );
      }
      if (file != null) _exported = (signature: signature, file: file);
      return file;
    } catch (error) {
      AppLogger.event('story_export_failed');
      _showError(error);
      return null;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showToast(
      context.l10n.storyExportFailed('$error'),
      kind: ToastKind.error,
    );
  }
}

/// Shows the memory search bar from this many memories on.
const _searchFrom = 7;

/// Step one: choose up to [StorySelection.maxMemories] memories.
class _StoryMemoryPicker extends StatefulWidget {
  const _StoryMemoryPicker({
    required this.events,
    required this.selection,
    required this.onChanged,
    required this.onContinue,
  });

  final List<MemoryEvent> events;
  final StorySelection selection;
  final ValueChanged<StorySelection> onChanged;
  final VoidCallback onContinue;

  @override
  State<_StoryMemoryPicker> createState() => _StoryMemoryPickerState();
}

class _StoryMemoryPickerState extends State<_StoryMemoryPicker> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final events = widget.events;
    final selection = widget.selection;
    final onChanged = widget.onChanged;
    if (events.isEmpty) {
      // Not a dead end: one tap to the first memory.
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_stories_rounded, color: AppColors.gold, size: 44),
              const SizedBox(height: 14),
              Text(
                l10n.storyNoMemories,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => context.push(RouteNames.addMemory),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addAMemory),
              ),
            ],
          ),
        ),
      );
    }
    final sorted = [
      for (final event in events)
        if (storyMemoryMatches(event, _query)) event,
    ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return SafeArea(
      top: false,
      child: Column(
        children: [
          if (events.length >= _searchFrom)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: StorySearchField(
                onChanged: (query) => setState(() => _query = query),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.storyPickBody(StorySelection.maxMemories),
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
                Text(
                  l10n.storyPickCount(
                    selection.ids.length,
                    StorySelection.maxMemories,
                  ),
                  style: TextStyle(
                    color: AppColors.amber,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: sorted.isEmpty
                ? _NoMatch(query: _query)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      final event = sorted[index];
                      final order = selection.ids.indexOf(event.id);
                      return _PickerTile(
                        event: event,
                        order: order < 0 ? null : order + 1,
                        onTap: () {
                          if (order < 0 && selection.isFull) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showToast(
                                l10n.storyPickLimit(StorySelection.maxMemories),
                              );
                            return;
                          }
                          onChanged(selection.toggle(event.id));
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: CoachTarget(
                id: TourTargets.storyPickContinue,
                child: FilledButton(
                  key: const ValueKey('story-continue'),
                  onPressed: selection.isEmpty ? null : widget.onContinue,
                  child: Text(l10n.storyPickContinue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoMatch extends StatelessWidget {
  const _NoMatch({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          context.l10n.storySearchEmpty(query.trim()),
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, height: 1.4),
        ),
      ),
    );
  }
}

/// Picks one more memory for the story being edited; pops its id.
class _AddMemorySheet extends StatefulWidget {
  const _AddMemorySheet({required this.events});

  /// The memories not in the story yet.
  final List<MemoryEvent> events;

  @override
  State<_AddMemorySheet> createState() => _AddMemorySheetState();
}

class _AddMemorySheetState extends State<_AddMemorySheet> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final matches = [
      for (final event in widget.events)
        if (storyMemoryMatches(event, _query)) event,
    ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Text(
                l10n.storyAddMemoryTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (widget.events.length >= _searchFrom)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: StorySearchField(
                  onChanged: (query) => setState(() => _query = query),
                ),
              ),
            Expanded(
              child: widget.events.isEmpty
                  ? Center(
                      child: Text(
                        l10n.storyAllMemoriesAdded,
                        style: TextStyle(color: AppColors.muted),
                      ),
                    )
                  : matches.isEmpty
                  ? _NoMatch(query: _query)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      itemCount: matches.length,
                      itemBuilder: (context, index) => _PickerTile(
                        event: matches[index],
                        order: null,
                        onTap: () =>
                            Navigator.of(context).pop(matches[index].id),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.event,
    required this.order,
    required this.onTap,
  });

  final MemoryEvent event;
  final int? order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = order != null;
    final path = event.coverPhotoPath;
    final ImageProvider? thumbnail = path == null || path.isEmpty
        ? null
        : ResizeImage(
            path.startsWith('assets/')
                ? AssetImage(path)
                : FileImage(File(path)) as ImageProvider,
            width: 168,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: selected
            ? AppColors.gold.withValues(alpha: 0.16)
            : AppColors.panel.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox.square(
                    dimension: 56,
                    child: thumbnail == null
                        ? StoryPhotoPlaceholder(color: event.coverColor)
                        : Image(
                            image: thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                StoryPhotoPlaceholder(color: event.coverColor),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        storyMemoryDetail(context, event),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.gold : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.gold : AppColors.muted,
                      width: 1.6,
                    ),
                  ),
                  child: selected
                      ? Text(
                          '$order',
                          style: TextStyle(
                            color: AppColors.paperInk,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "0:42–1:02": the part of the song a [window]-long film uses.
String _range(Duration start, Duration window) {
  String clock(Duration value) =>
      '${value.inMinutes}:${(value.inSeconds % 60).toString().padLeft(2, '0')}';
  return '${clock(start)}–${clock(start + window)}';
}

/// A setting of the story that opens its own screen: Animation, Music.
class _EditorRow extends StatelessWidget {
  const _EditorRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.gold),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColors.amber, fontWeight: FontWeight.w700),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing!, style: TextStyle(color: AppColors.muted)),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

/// Picture or video, as two large segments.
class _ModeChooser extends StatelessWidget {
  const _ModeChooser({required this.video, required this.onChanged});

  final bool video;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget segment(bool isVideo, IconData icon, String label, Key key) {
      final selected = isVideo == video;
      return Expanded(
        child: Semantics(
          button: true,
          selected: selected,
          child: InkWell(
            key: key,
            borderRadius: BorderRadius.circular(14),
            onTap: onChanged == null ? null : () => onChanged!(isVideo),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: selected ? AppColors.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: selected ? AppColors.wallInk : AppColors.muted,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: selected ? AppColors.wallInk : AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          segment(
            false,
            Icons.image_rounded,
            l10n.storyModePicture,
            const ValueKey('story-mode-picture'),
          ),
          const SizedBox(width: 4),
          segment(
            true,
            Icons.movie_rounded,
            l10n.storyModeVideo,
            // Kept from the old switch, so tests and the tour find it.
            const ValueKey('story-video-switch'),
          ),
        ],
      ),
    );
  }
}

/// The story preview at the top of the editor: full size, shrinking to
/// [min] as the page scrolls.
class _PreviewHeader extends SliverPersistentHeaderDelegate {
  _PreviewHeader({required this.min, required this.max, required this.child});

  final double min;
  final double max;
  final Widget child;

  @override
  double get minExtent => min;

  @override
  double get maxExtent => max;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return ColoredBox(
      color: AppColors.wallInk,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Center(child: child),
      ),
    );
  }

  @override
  bool shouldRebuild(_PreviewHeader old) =>
      old.child != child || old.min != min || old.max != max;
}

/// The photos of one memory: tap one to use it in the story.
class _PhotoChoiceSheet extends StatelessWidget {
  const _PhotoChoiceSheet({
    required this.title,
    required this.photos,
    required this.selected,
  });

  final String title;
  final List<MemoryPhoto> photos;
  final String? selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.storyChoosePhoto,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 14),
            Flexible(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  for (final photo in photos)
                    GestureDetector(
                      key: ValueKey('story-photo-${photo.id}'),
                      onTap: () => Navigator.of(context).pop(photo.localPath),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: photo.localPath == selected
                                ? AppColors.gold
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image(
                            image: ResizeImage(
                              photo.localPath.startsWith('assets/')
                                  ? AssetImage(photo.localPath)
                                  : FileImage(File(photo.localPath))
                                        as ImageProvider,
                              width: 300,
                            ),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                ColoredBox(color: AppColors.panel),
                          ),
                        ),
                      ),
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

String _formatLabel(AppLocalizations l10n, StoryFormat format) =>
    switch (format) {
      StoryFormat.story => l10n.storyFormatStory,
      StoryFormat.post => l10n.storyFormatPost,
      StoryFormat.square => l10n.storyFormatSquare,
    };
