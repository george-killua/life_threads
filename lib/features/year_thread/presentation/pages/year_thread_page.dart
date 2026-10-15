import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/rendering/story_canvas.dart';
import '../../../memories/data/memory_repository.dart';
import '../../../premium/domain/premium_feature.dart';
import '../../../premium/presentation/premium_gate.dart';
import '../../../stories/data/music_preview.dart';
import '../../../stories/data/story_exporter.dart';
import '../../../stories/domain/music_track.dart';
import '../../../stories/presentation/widgets/music_trimmer.dart';
import '../../../wall/presentation/widgets/wall_background.dart';
import '../../data/year_thread_providers.dart';
import '../../domain/year_thread.dart';
import '../../domain/year_thread_timeline.dart';
import '../widgets/year_thread_player.dart';
import '../widgets/year_thread_visuals.dart';
import '../year_thread_film.dart';
import '../year_thread_image_page.dart';

/// Thread of the Year: pick a year, adjust the memories, watch the film
/// (free) and export it as a video or a "My year" image (Premium).
class YearThreadPage extends ConsumerStatefulWidget {
  const YearThreadPage({super.key, this.initialYear});

  final int? initialYear;

  @override
  ConsumerState<YearThreadPage> createState() => _YearThreadPageState();
}

class _YearThreadPageState extends ConsumerState<YearThreadPage> {
  int? _year;

  /// The memories the user chose; null while the suggestions are used.
  List<String>? _chosen;
  var _cut = YearThreadCut.full;
  MusicTrack? _music;

  /// Where the chosen song starts in the film (see [MusicTrimmer]).
  var _musicStart = Duration.zero;
  late final MusicPreview _musicPreview;
  var _exporting = false;

  @override
  void initState() {
    super.initState();
    _musicPreview = ref.read(musicPreviewProvider);
  }

  @override
  void dispose() {
    unawaited(_musicPreview.stop());
    super.dispose();
  }

  /// Picks [track] (or no music) and plays it so the user hears it.
  void _selectMusic(MusicTrack? track, {Duration? window}) {
    if (track == null) {
      setState(() => _music = null);
      unawaited(_musicPreview.stop());
      return;
    }
    final length = window ?? track.length;
    final start = MusicTrimmer.suggestedStart(track, length);
    setState(() {
      _music = track;
      _musicStart = start;
    });
    unawaited(_musicPreview.play(track, start: start, length: length));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final memoryState = ref.watch(memoryRepositoryProvider);
    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: memoryState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (state) {
              final years = YearThread.availableYears(state);
              final year = _resolveYear(years);
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).backButtonTooltip,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.yearThreadTitle,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (year == null)
                    _Panel(
                      child: Text(
                        l10n.yearThreadNoYears,
                        style: TextStyle(
                          color: AppColors.muted,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    ..._editor(context, years, YearThread.year(state, year)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  int? _resolveYear(List<int> years) {
    if (years.isEmpty) return null;
    final current = _year ?? widget.initialYear;
    return years.contains(current) ? current : years.first;
  }

  List<YearThreadMemory> _selection(YearThreadYear year) {
    final chosen = _chosen;
    if (chosen == null) return year.suggested;
    // Memories deleted in the meantime drop out.
    return [for (final id in chosen) ?year.find(id)]..sort(YearThread.byDate);
  }

  List<Widget> _editor(
    BuildContext context,
    List<int> years,
    YearThreadYear year,
  ) {
    final l10n = context.l10n;
    final selection = _selection(year);
    final ready = selection.length >= YearThread.minMemories;
    final film = ready
        ? YearThreadFilm(stats: year.stats, memories: selection, cut: _cut)
        : null;
    final fullSeconds = ready
        ? YearThreadTimeline.build(
            selection.length,
            YearThreadCut.full,
          ).total.inSeconds
        : 0;
    final others = [
      for (final memory in year.memories)
        if (!selection.any((chosen) => chosen.id == memory.id)) memory,
    ];
    final tracks = ref.watch(yearThreadMusicTracksProvider);

    return [
      _Label(l10n.yearThreadYear),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final option in years)
            ChoiceChip(
              label: Text('$option'),
              selected: option == year.year,
              onSelected: (_) => setState(() {
                _year = option;
                _chosen = null;
              }),
            ),
        ],
      ),
      const SizedBox(height: 18),
      _Panel(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: film == null
                      ? const YearThreadBackdrop()
                      : IgnorePointer(
                          child: FittedBox(
                            child: SizedBox.fromSize(
                              size: StoryCanvas.storyLogicalSize,
                              child: film.buildFrame(
                                context,
                                const Duration(milliseconds: 2200),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    yearThreadSummary(l10n, year.stats),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.yearThreadSettingsBody,
                    style: TextStyle(
                      color: AppColors.muted,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    key: const ValueKey('year-thread-preview'),
                    onPressed: film == null
                        ? null
                        : () => _preview(context, film),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(l10n.yearThreadPreview),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      _Label(l10n.yearThreadLength),
      SegmentedButton<YearThreadCut>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: YearThreadCut.full,
            icon: const Icon(Icons.movie_rounded),
            label: Text(l10n.yearThreadLengthFull(fullSeconds)),
          ),
          ButtonSegment(
            value: YearThreadCut.story,
            icon: const Icon(Icons.amp_stories_rounded),
            label: Text(l10n.yearThreadLengthStory),
          ),
        ],
        selected: {_cut},
        onSelectionChanged: (cut) => setState(() => _cut = cut.single),
      ),
      const SizedBox(height: 18),
      _Label(l10n.yearThreadMusic),
      _Panel(
        child: Row(
          children: [
            Icon(Icons.music_note_rounded, color: AppColors.gold),
            const SizedBox(width: 10),
            Expanded(
              child: tracks.isEmpty
                  ? Text(
                      l10n.yearThreadNoMusic,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    )
                  : DropdownButton<MusicTrack?>(
                      isExpanded: true,
                      value: tracks.contains(_music) ? _music : null,
                      underline: const SizedBox.shrink(),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(l10n.yearThreadNoMusic),
                        ),
                        for (final track in tracks)
                          DropdownMenuItem(
                            value: track,
                            child: Text('${track.title} · ${track.artist}'),
                          ),
                      ],
                      onChanged: (track) =>
                          _selectMusic(track, window: film?.duration),
                    ),
            ),
          ],
        ),
      ),
      if (_music case final music? when film != null) ...[
        const SizedBox(height: 12),
        MusicTrimmer(
          key: ValueKey('music-trimmer-${music.id}'),
          track: music,
          window: film.duration,
          start: MusicTrimmer.clampStart(music, film.duration, _musicStart),
          onChanged: (start) => setState(() => _musicStart = start),
          onChangeEnd: (start) => unawaited(
            _musicPreview.play(music, start: start, length: film.duration),
          ),
        ),
      ],
      const SizedBox(height: 18),
      Row(
        children: [
          Expanded(child: _Label(l10n.yearThreadInFilm)),
          Text(
            l10n.yearThreadInFilmCount(
              selection.length,
              YearThread.maxMemories,
            ),
            style: TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      for (final memory in selection)
        _MemoryRow(
          memory: memory,
          onSwap: others.isEmpty
              ? null
              : () => _swap(context, year, selection, others, memory),
          onRemove: () => setState(() {
            _chosen = [
              for (final chosen in selection)
                if (chosen.id != memory.id) chosen.id,
            ];
          }),
        ),
      if (!ready)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            l10n.yearThreadNeedMore(YearThread.minMemories),
            style: TextStyle(
              color: AppColors.rose,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      Wrap(
        spacing: 8,
        children: [
          TextButton.icon(
            onPressed:
                others.isEmpty || selection.length >= YearThread.maxMemories
                ? null
                : () => _add(context, year, selection, others),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.yearThreadAddMemory),
          ),
          if (_chosen != null)
            TextButton.icon(
              onPressed: () => setState(() => _chosen = null),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text(l10n.yearThreadUseSuggestions),
            ),
        ],
      ),
      const SizedBox(height: 18),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          FilledButton.icon(
            key: const ValueKey('year-thread-export-video'),
            onPressed: film == null || _exporting
                ? null
                : () => _exportVideo(context, film),
            icon: const Icon(Icons.movie_creation_rounded),
            label: Text(l10n.yearThreadExportVideo),
          ),
          FilledButton.tonalIcon(
            key: const ValueKey('year-thread-export-image'),
            onPressed: !ready || _exporting
                ? null
                : () => _exportImage(context, year, selection),
            icon: const Icon(Icons.image_rounded),
            label: Text(l10n.yearThreadExportImage),
          ),
        ],
      ),
    ];
  }

  Future<void> _preview(BuildContext context, YearThreadFilm film) async {
    for (final image in film.images) {
      unawaited(precacheImage(image, context, onError: (_, _) {}));
    }
    // The chosen part of the song plays with the preview.
    final music = _music;
    if (music != null) {
      unawaited(
        _musicPreview.play(
          music,
          start: MusicTrimmer.clampStart(music, film.duration, _musicStart),
          length: film.duration,
        ),
      );
    }
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.wallInk,
        insetPadding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: IconButton(
                  tooltip: context.l10n.close,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              Flexible(child: YearThreadPlayer(film: film)),
            ],
          ),
        ),
      ),
    );
    if (music != null) unawaited(_musicPreview.stop());
  }

  Future<String?> _pick(
    BuildContext context,
    YearThreadYear year,
    List<YearThreadMemory> others,
  ) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.panel,
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            children: [
              Text(
                context.l10n.yearThreadPickTitle('${year.year}'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              for (final memory in others)
                _MemoryRow(
                  memory: memory,
                  onTap: () => Navigator.of(context).pop(memory.id),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _add(
    BuildContext context,
    YearThreadYear year,
    List<YearThreadMemory> selection,
    List<YearThreadMemory> others,
  ) async {
    final id = await _pick(context, year, others);
    if (id == null || !mounted) return;
    setState(() => _chosen = [for (final memory in selection) memory.id, id]);
  }

  Future<void> _swap(
    BuildContext context,
    YearThreadYear year,
    List<YearThreadMemory> selection,
    List<YearThreadMemory> others,
    YearThreadMemory replaced,
  ) async {
    final id = await _pick(context, year, others);
    if (id == null || !mounted) return;
    setState(() {
      _chosen = [
        for (final memory in selection)
          memory.id == replaced.id ? id : memory.id,
      ];
    });
  }

  Future<void> _exportVideo(BuildContext context, YearThreadFilm film) async {
    final l10n = context.l10n;
    if (!await requirePremium(context, PremiumFeature.threadOfTheYear)) return;
    if (!context.mounted) return;
    final exporter = ref.read(storyExporterProvider);
    final cancel = StoryExportCancel();
    final progress = ValueNotifier<double?>(0);
    await _run(
      context,
      title: l10n.yearThreadMakingFilm,
      progress: progress,
      onCancel: cancel.cancel,
      readyTitle: l10n.yearThreadFilmReady,
      export: () => exporter.exportVideo(
        context,
        film,
        music: _music,
        musicStart: _music == null
            ? Duration.zero
            : MusicTrimmer.clampStart(_music!, film.duration, _musicStart),
        onProgress: (value) => progress.value = value,
        cancel: cancel,
      ),
    );
    progress.dispose();
  }

  Future<void> _exportImage(
    BuildContext context,
    YearThreadYear year,
    List<YearThreadMemory> selection,
  ) async {
    final l10n = context.l10n;
    if (!await requirePremium(context, PremiumFeature.threadOfTheYear)) return;
    if (!context.mounted) return;
    final exporter = ref.read(storyExporterProvider);
    final progress = ValueNotifier<double?>(null);
    await _run(
      context,
      title: l10n.yearThreadMakingImage,
      progress: progress,
      readyTitle: l10n.yearThreadImageReady,
      export: () => exporter.exportImage(
        context,
        YearThreadImagePage(stats: year.stats, memories: selection),
      ),
    );
    progress.dispose();
  }

  /// Exports with a progress dialog, then offers Share and Save. The file is
  /// temporary and removed once the user is done with it.
  Future<void> _run(
    BuildContext context, {
    required String title,
    required ValueNotifier<double?> progress,
    required String readyTitle,
    required Future<File> Function() export,
    VoidCallback? onCancel,
  }) async {
    final l10n = context.l10n;
    final navigator = Navigator.of(context, rootNavigator: true);
    unawaited(_musicPreview.stop());
    setState(() => _exporting = true);
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (context) => _ProgressDialog(
          title: title,
          progress: progress,
          onCancel: onCancel,
        ),
      ),
    );
    File? file;
    try {
      file = await export();
    } on StoryExportCancelled {
      // The user stopped it; nothing to report.
    } catch (_) {
      AppLogger.event('year_thread_export_failed');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.yearThreadExportFailed)));
      }
    } finally {
      navigator.pop();
      if (mounted) setState(() => _exporting = false);
    }
    if (file == null) return;
    AppLogger.event('year_thread_exported');
    if (context.mounted) {
      await _showResult(context, file, readyTitle);
    }
    try {
      if (file.existsSync()) file.deleteSync();
    } catch (_) {}
  }

  Future<void> _showResult(
    BuildContext context,
    File file,
    String title,
  ) async {
    final exporter = ref.read(storyExporterProvider);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.panel,
      builder: (sheetContext) {
        final l10n = sheetContext.l10n;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => exporter.share(sheetContext, file),
                  icon: const Icon(Icons.ios_share_rounded),
                  label: Text(l10n.yearThreadShare),
                ),
                const SizedBox(height: 10),
                FilledButton.tonalIcon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      await exporter.saveToGallery(file);
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.yearThreadSaved)),
                      );
                    } catch (_) {
                      AppLogger.event('year_thread_save_failed');
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.yearThreadExportFailed)),
                      );
                    }
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: Text(l10n.yearThreadSave),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProgressDialog extends StatelessWidget {
  const _ProgressDialog({
    required this.title,
    required this.progress,
    this.onCancel,
  });

  final String title;

  /// 0..1, or null while the progress is unknown.
  final ValueListenable<double?> progress;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(title),
        content: ValueListenableBuilder<double?>(
          valueListenable: progress,
          builder: (context, value, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: value),
              if (value != null) ...[
                const SizedBox(height: 10),
                Text(
                  '${(value * 100).round()} %',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (onCancel != null)
            TextButton(onPressed: onCancel, child: Text(context.l10n.cancel)),
        ],
      ),
    );
  }
}

class _MemoryRow extends StatelessWidget {
  const _MemoryRow({
    required this.memory,
    this.onTap,
    this.onSwap,
    this.onRemove,
  });

  final YearThreadMemory memory;
  final VoidCallback? onTap;
  final VoidCallback? onSwap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final photo = yearThreadPhoto(memory);
    return Card(
      color: AppColors.panelWarm.withValues(alpha: 0.86),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox.square(
                  dimension: 48,
                  child: photo == null
                      ? YearThreadPhotoPlaceholder(memory: memory)
                      : Image(
                          image: ResizeImage(photo, width: 144),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              YearThreadPhotoPlaceholder(memory: memory),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory.event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      yearThreadDate(context, memory.event.occurredAt),
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (onSwap != null)
                IconButton(
                  tooltip: l10n.yearThreadSwap,
                  onPressed: onSwap,
                  icon: const Icon(Icons.swap_horiz_rounded),
                ),
              if (onRemove != null)
                IconButton(
                  tooltip: l10n.yearThreadRemove,
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.gold,
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.panelWarm.withValues(alpha: 0.9),
            AppColors.panel.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
      ),
      child: child,
    );
  }
}
