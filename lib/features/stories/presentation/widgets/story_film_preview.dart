import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/story_film.dart';
import '../../domain/story_template.dart';
import '../story_template_film.dart';
import '../templates/story_templates.dart';
import '../templates/story_visuals.dart';

/// A story at phone size in a rounded frame: the film playing on its own
/// loop, the film at the moment [time] says (to run in step with the
/// music), or the still image when [animate] is off.
class StoryFilmPreview extends StatefulWidget {
  const StoryFilmPreview({
    super.key,
    required this.film,
    this.time,
    this.animate = true,
    this.radius = 18,
    this.shadow = true,
    this.format = StoryFormat.story,
  });

  /// The picture's shape, for a still (films are always stories).
  final StoryFormat format;

  final StoryFilm film;
  final ValueListenable<Duration>? time;
  final bool animate;
  final double radius;
  final bool shadow;

  @override
  State<StoryFilmPreview> createState() => _StoryFilmPreviewState();
}

class _StoryFilmPreviewState extends State<StoryFilmPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.film.duration,
  );

  bool get _ownLoop => widget.animate && widget.time == null;

  @override
  void initState() {
    super.initState();
    if (_ownLoop) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant StoryFilmPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.film.duration != widget.film.duration) {
      _controller.duration = widget.film.duration;
    }
    if (_ownLoop) {
      if (!_controller.isAnimating ||
          oldWidget.film.duration != widget.film.duration) {
        _controller.repeat();
      }
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final film = widget.film;
    final time = widget.time;
    final Widget page;
    if (!widget.animate) {
      page = film is StoryTemplateFilm
          ? StoryPage(
              template: film.template,
              memories: film.memories,
              caption: film.caption,
              format: widget.format,
            )
          : film.buildFrame(context, film.duration * 0.5);
    } else if (time != null) {
      page = ValueListenableBuilder<Duration>(
        valueListenable: time,
        builder: (context, value, _) => film.buildFrame(context, value),
      );
    } else {
      page = AnimatedBuilder(
        animation: _controller,
        builder: (context, _) =>
            film.buildFrame(context, film.duration * _controller.value),
      );
    }
    final radius = BorderRadius.circular(widget.radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          if (widget.shadow)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: FittedBox(
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: SizedBox.fromSize(
              size: widget.animate ? storySize : widget.format.size,
              child: RepaintBoundary(child: page),
            ),
          ),
        ),
      ),
    );
  }
}
