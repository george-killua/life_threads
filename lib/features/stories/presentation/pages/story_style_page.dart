import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/data/memory_seed_data.dart';
import '../../../memories/domain/memory_event.dart';
import '../../../tour/app_tour.dart';
import '../../../tour/coach.dart';
import '../../domain/story_template.dart';
import '../story_template_film.dart';
import '../story_template_l10n.dart';
import '../widgets/story_film_preview.dart';

/// Choose how a story moves: every animation as a small preview. The one
/// tapped plays (the others show their still image, so ten films don't
/// run at once); Done returns it.
///
/// Previews use the story's own memories, or example memories with their
/// pictures when the story has fewer than three (an animation of one photo
/// shows too little of what it does).
class StoryStylePage extends StatefulWidget {
  const StoryStylePage({
    super.key,
    required this.selected,
    required this.memories,
    this.video = true,
    this.format = StoryFormat.story,
  });

  /// A picture's shape: the previews show it, and only layouts that fit it
  /// are offered.
  final StoryFormat format;

  /// Video animations, or picture layouts (every memory in one image).
  final bool video;

  final StoryTemplate selected;
  final List<MemoryEvent> memories;

  @override
  State<StoryStylePage> createState() => _StoryStylePageState();
}

class _StoryStylePageState extends State<StoryStylePage> {
  late var _selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final templates = [
      for (final template in StoryTemplate.forMode(video: widget.video))
        if (widget.video || template.fits(widget.format)) template,
    ];
    final examples = widget.memories.length < 3;
    final memories = examples
        ? MemorySeedData.localizedEvents(l10n).take(4).toList()
        : widget.memories;
    return Scaffold(
      backgroundColor: AppColors.wallInk,
      appBar: AppBar(
        title: Text(
          widget.video
              ? l10n.storyAnimationPageTitle
              : l10n.storyLayoutPageTitle,
        ),
        actions: [
          CoachTarget(
            id: TourTargets.storyStyleDone,
            child: TextButton(
              key: const ValueKey('story-style-done'),
              onPressed: () => Navigator.of(context).pop(_selected),
              child: Text(
                l10n.done,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          if (examples)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  l10n.storyAnimationExamples,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 18,
                crossAxisSpacing: 14,
                childAspectRatio: 0.44,
              ),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                final tile = _StyleTile(
                  video: widget.video,
                  format: widget.format,
                  template: template,
                  memories: memories,
                  selected: template == _selected,
                  onTap: () => setState(() => _selected = template),
                );
                return template == StoryTemplate.polaroid
                    ? CoachTarget(id: TourTargets.storyStyleTile, child: tile)
                    : tile;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StyleTile extends StatelessWidget {
  const _StyleTile({
    required this.video,
    required this.format,
    required this.template,
    required this.memories,
    required this.selected,
    required this.onTap,
  });

  /// A video animation plays when picked; a picture layout is a still.
  final bool video;
  final StoryFormat format;
  final StoryTemplate template;
  final List<MemoryEvent> memories;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      button: true,
      selected: selected,
      label: storyTemplateLabel(l10n, template),
      hint: storyTemplateHint(l10n, template),
      child: GestureDetector(
        key: ValueKey('story-style-${template.name}'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The preview takes what the texts leave, so large text never
            // runs out of the tile.
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: video ? 9 / 16 : format.aspectRatio,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: selected ? AppColors.gold : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        StoryFilmPreview(
                          film: StoryTemplateFilm(
                            template: template,
                            memories: memories,
                          ),
                          animate: video && selected,
                          format: video ? StoryFormat.story : format,
                          radius: 13,
                          shadow: false,
                        ),
                        if (video && !selected)
                          Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  storyTemplateIcon(template),
                  size: 16,
                  color: selected ? AppColors.gold : AppColors.muted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    storyTemplateLabel(l10n, template),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: selected ? AppColors.amber : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              storyTemplateHint(l10n, template),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
