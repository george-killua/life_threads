import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../memories/domain/memory_event.dart';
import '../../../premium/domain/premium_feature.dart';
import '../../../premium/presentation/premium_gate.dart';
import '../../data/music_catalog.dart';
import '../../data/music_preview.dart';
import '../../data/story_exporter.dart';
import '../../domain/music_track.dart';
import '../../domain/story_template.dart';
import '../story_template_film.dart';
import '../templates/story_templates.dart';
import '../templates/story_visuals.dart';
import '../widgets/music_trimmer.dart';
import '../widgets/story_export_progress_dialog.dart';
import '../widgets/story_memory_strip.dart';
import '../widgets/story_search_field.dart';

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

class _CreateStoryPageState extends ConsumerState<CreateStoryPage> {
  late StorySelection _selection;
  late bool _editing;
  final _caption = TextEditingController();
  var _captionEdited = false;
  var _captionReady = false;
  var _template = StoryTemplate.single;
  final _pages = PageController();
  var _video = false;
  MusicTrack? _music;

  /// Where the chosen song starts in the film (see [MusicTrimmer]).
  var _musicStart = Duration.zero;
  late final MusicPreview _preview;
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
  }

  /// Picks [track] (or no music) and plays the part the film would use:
  /// [window] long, from its loudest part.
  void _selectMusic(MusicTrack? track, {Duration? window}) {
    if (track == null) {
      setState(() => _music = null);
      unawaited(_preview.stop());
      return;
    }
    final length = window ?? track.length;
    final start = MusicTrimmer.suggestedStart(track, length);
    setState(() {
      _music = track;
      _musicStart = start;
    });
    unawaited(_preview.play(track, start: start, length: length));
  }

  /// The film length for [memories] as the story looks now.
  Duration _filmLength(List<MemoryEvent> memories) => StoryTemplateFilm(
    template: _template,
    memories: memories,
    caption: _caption.text,
  ).duration;

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
    unawaited(_preview.stop());
    _caption.dispose();
    _pages.dispose();
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
          if (_editing)
            TextButton.icon(
              onPressed: _busy ? null : () => setState(() => _editing = false),
              icon: const Icon(Icons.photo_library_rounded),
              label: Text(l10n.storyChangeMemories),
            ),
        ],
      ),
      body: memoryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (state) {
          final memories = _selection.resolve(state.events);
          if (_editing && memories.isNotEmpty) {
            // Started from a memory: its story is the first caption. Set
            // before the caption field exists, so no listener fires.
            if (!_captionReady) {
              _captionReady = true;
              _caption.text = defaultStoryCaption(memories);
            }
            return _buildEditor(context, memories, state.events);
          }
          return _StoryMemoryPicker(
            events: state.events,
            selection: _selection,
            onChanged: (selection) => setState(() => _selection = selection),
            onContinue: () => setState(() {
              if (!_captionEdited) {
                _caption.text = defaultStoryCaption(
                  _selection.resolve(state.events),
                );
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
    final caption = _caption.text;
    final filmLength = _filmLength(memories);
    final music = _music;
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 8),
              child: PageView.builder(
                controller: _pages,
                itemCount: StoryTemplate.values.length,
                onPageChanged: (index) =>
                    setState(() => _template = StoryTemplate.values[index]),
                itemBuilder: (context, index) {
                  final template = StoryTemplate.values[index];
                  return Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: _StoryPreview(
                        key: ValueKey('story-preview-${template.name}'),
                        template: template,
                        memories: memories,
                        caption: caption,
                        animate: _video && template == _template,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final template in StoryTemplate.values)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text(storyTemplateLabel(l10n, template)),
                      selected: template == _template,
                      onSelected: (_) => _pages.animateToPage(
                        template.index,
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          StoryMemoryStrip(
            memories: memories,
            canAdd: !_selection.isFull && memories.length < events.length,
            onReorder: (from, to) =>
                _changeSelection(_selection.move(from, to), events),
            onRemove: (id) => _changeSelection(_selection.remove(id), events),
            onAdd: () => _addMemory(events),
          ),
          Expanded(
            flex: 7,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              children: [
                TextField(
                  key: const ValueKey('story-caption'),
                  controller: _caption,
                  maxLength: 160,
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    labelText: l10n.storyCaptionLabel,
                    hintText: l10n.storyCaptionHint,
                  ),
                  onChanged: (_) => setState(() => _captionEdited = true),
                ),
                SwitchListTile.adaptive(
                  key: const ValueKey('story-video-switch'),
                  contentPadding: EdgeInsets.zero,
                  value: _video,
                  onChanged: _busy
                      ? null
                      : (value) {
                          setState(() => _video = value);
                          if (!value) _selectMusic(null);
                        },
                  title: Text(
                    l10n.storyVideoSwitch,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text(
                    l10n.storyVideoBody,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ),
                if (_video) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.storyMusicTitle,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.storyMusicNone),
                        selected: _music == null,
                        onSelected: (_) => _selectMusic(null),
                      ),
                      for (final track in bundledMusicTracks)
                        ChoiceChip(
                          avatar: const Icon(Icons.music_note_rounded),
                          label: Text(
                            '${track.title} · '
                            '${musicMoodLabel(l10n, track.mood)}',
                          ),
                          selected: _music?.id == track.id,
                          onSelected: (_) =>
                              _selectMusic(track, window: filmLength),
                        ),
                    ],
                  ),
                  if (music != null) ...[
                    const SizedBox(height: 14),
                    MusicTrimmer(
                      key: ValueKey('music-trimmer-${music.id}'),
                      track: music,
                      window: filmLength,
                      start: MusicTrimmer.clampStart(
                        music,
                        filmLength,
                        _musicStart,
                      ),
                      onChanged: (start) => setState(() => _musicStart = start),
                      onChangeEnd: (start) => unawaited(
                        _preview.play(music, start: start, length: filmLength),
                      ),
                    ),
                  ],
                  if (_music == null) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.storyMusicNoneHint,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
                if (!isPremium) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.workspace_premium_rounded,
                        color: AppColors.gold,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.storyPreviewFree,
                          style: const TextStyle(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey('story-save'),
                    onPressed: _busy ? null : () => _save(memories),
                    icon: const Icon(Icons.download_rounded),
                    label: Text(
                      l10n.storySaveToPhotos,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.amber,
                      side: const BorderSide(color: AppColors.line),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    key: _shareButtonKey,
                    onPressed: _busy ? null : () => _share(memories),
                    icon: _busy
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.ios_share_rounded),
                    label: Text(l10n.storyShare),
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
    if (!await requirePremium(context, _feature)) return;
    if (!mounted) return;
    final file = await _export(memories);
    if (file == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      await ref.read(storyExporterProvider).saveToGallery(file);
      messenger.showSnackBar(SnackBar(content: Text(l10n.storySaved)));
    } on StoryGalleryAccessDenied {
      messenger.showSnackBar(SnackBar(content: Text(l10n.storySaveDenied)));
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
    unawaited(_preview.stop());
    setState(() => _busy = true);
    try {
      final File? file;
      if (_video) {
        final film = StoryTemplateFilm(
          template: _template,
          memories: memories,
          caption: caption,
        );
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
          StoryPage(template: _template, memories: memories, caption: caption),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 7),
        content: Text(context.l10n.storyExportFailed('$error')),
      ),
    );
  }
}

String storyTemplateLabel(AppLocalizations l10n, StoryTemplate template) {
  return switch (template) {
    StoryTemplate.single => l10n.storyTemplateSingle,
    StoryTemplate.thread => l10n.storyTemplateThread,
    StoryTemplate.collage => l10n.storyTemplateCollage,
    StoryTemplate.quote => l10n.storyTemplateQuote,
  };
}

String musicMoodLabel(AppLocalizations l10n, MusicMood mood) {
  return switch (mood) {
    MusicMood.warm => l10n.storyMoodWarm,
    MusicMood.joyful => l10n.storyMoodJoyful,
    MusicMood.calm => l10n.storyMoodCalm,
    MusicMood.nostalgic => l10n.storyMoodNostalgic,
    MusicMood.epic => l10n.storyMoodEpic,
    MusicMood.emotional => l10n.storyMoodEmotional,
  };
}

/// A story page scaled into its box: the still image, or the film playing
/// in a loop when [animate] is on.
class _StoryPreview extends StatelessWidget {
  const _StoryPreview({
    super.key,
    required this.template,
    required this.memories,
    required this.caption,
    required this.animate,
  });

  final StoryTemplate template;
  final List<MemoryEvent> memories;
  final String caption;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final Widget page = animate
        ? _FilmPreview(
            film: StoryTemplateFilm(
              template: template,
              memories: memories,
              caption: caption,
            ),
          )
        : StoryPage(template: template, memories: memories, caption: caption);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: FittedBox(
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: SizedBox.fromSize(size: storySize, child: page),
          ),
        ),
      ),
    );
  }
}

class _FilmPreview extends StatefulWidget {
  const _FilmPreview({required this.film});

  final StoryTemplateFilm film;

  @override
  State<_FilmPreview> createState() => _FilmPreviewState();
}

class _FilmPreviewState extends State<_FilmPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.film.duration,
  )..repeat();

  @override
  void didUpdateWidget(covariant _FilmPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.film.duration != widget.film.duration) {
      _controller
        ..duration = widget.film.duration
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.film.buildFrame(
        context,
        widget.film.duration * _controller.value,
      ),
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            l10n.storyNoMemories,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.4),
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
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ),
                Text(
                  l10n.storyPickCount(
                    selection.ids.length,
                    StorySelection.maxMemories,
                  ),
                  style: const TextStyle(
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
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.storyPickLimit(
                                      StorySelection.maxMemories,
                                    ),
                                  ),
                                ),
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
              child: FilledButton(
                key: const ValueKey('story-continue'),
                onPressed: selection.isEmpty ? null : widget.onContinue,
                child: Text(l10n.storyPickContinue),
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
          style: const TextStyle(color: AppColors.muted, height: 1.4),
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
                        style: const TextStyle(color: AppColors.muted),
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
                        style: const TextStyle(
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
                          style: const TextStyle(
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
