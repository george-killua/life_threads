import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/memory_capsule_models.dart';
import '../capsule_cinema_controller.dart';
import '../capsule_cinema_script.dart';

enum CapsuleCinemaResult { addToWall, dismiss }

class CapsuleCinemaPage extends StatefulWidget {
  const CapsuleCinemaPage({super.key, required this.draft});

  final MemoryCapsuleImportDraft draft;

  @override
  State<CapsuleCinemaPage> createState() => _CapsuleCinemaPageState();
}

class _CapsuleCinemaPageState extends State<CapsuleCinemaPage>
    with TickerProviderStateMixin {
  CapsuleCinemaScript? _script;
  CapsuleCinemaController? _controller;
  AnimationController? _windController;
  var _completedLogged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_script != null) return;

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final script = CapsuleCinemaScript.fromDraft(
      widget.draft,
      reduceMotion: reduceMotion,
    );
    final controller = CapsuleCinemaController(
      script: script,
      onTick: () {
        if (mounted) setState(() {});
      },
    );
    final windController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    _script = script;
    _controller = controller;
    _windController = windController;
    AppLogger.event('capsule_cinema_started');
    controller.start(this);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _windController?.dispose();
    super.dispose();
  }

  void _skip() {
    AppLogger.event('capsule_cinema_skipped');
    _controller?.skipToInvite();
  }

  void _finish(CapsuleCinemaResult result) {
    if (!_completedLogged) {
      _completedLogged = true;
      AppLogger.event(
        result == CapsuleCinemaResult.addToWall
            ? 'capsule_cinema_add_to_wall'
            : 'capsule_cinema_dismissed',
      );
    }
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final script = _script;
    final controller = _controller;
    final wind = _windController;
    if (script == null || controller == null || wind == null) {
      return const Scaffold(
        backgroundColor: AppColors.wallInk,
        body: SizedBox.expand(),
      );
    }

    final beat = controller.currentBeat;
    final l10n = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.wallInk,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: controller.showingInvite ? null : _skip,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _CoverBackdrop(script: script, wind: wind),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: KeyedSubtree(
                  key: ValueKey(beat.kind),
                  child: _BeatContent(
                    script: script,
                    beat: beat,
                    wind: wind,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                _finish(CapsuleCinemaResult.dismiss),
                            icon: const Icon(Icons.close_rounded),
                            color: AppColors.text,
                          ),
                          const Spacer(),
                          if (!controller.showingInvite)
                            TextButton(
                              onPressed: _skip,
                              child: Text(l10n.cinemaSkip),
                            ),
                        ],
                      ),
                      const Spacer(),
                      if (controller.showingInvite ||
                          beat.kind == CapsuleCinemaBeatKind.invite)
                        _InviteBar(
                          onAdd: () => _finish(CapsuleCinemaResult.addToWall),
                          onDismiss: () =>
                              _finish(CapsuleCinemaResult.dismiss),
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
}

class _CoverBackdrop extends StatelessWidget {
  const _CoverBackdrop({required this.script, required this.wind});

  final CapsuleCinemaScript script;
  final Animation<double> wind;

  @override
  Widget build(BuildContext context) {
    final path = script.coverPhotoPath;
    final hasFile = path != null && File(path).existsSync();

    return Stack(
      fit: StackFit.expand,
      children: [
        if (hasFile)
          Image.file(
            File(path),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, _, _) => _ColorWash(script: script),
          )
        else
          _ColorWash(script: script),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.35),
                Colors.transparent,
                AppColors.wallInk.withValues(alpha: 0.94),
              ],
              stops: const [0, 0.4, 1],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomLeft,
              radius: 0.95,
              colors: [
                script.feeling.color.withValues(alpha: 0.34),
                Colors.transparent,
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: wind,
          builder: (context, _) {
            final sway = math.sin(wind.value * math.pi * 2) * 0.01;
            return Transform.translate(
              offset: Offset(sway * 24, 0),
              child: const SizedBox.expand(),
            );
          },
        ),
      ],
    );
  }
}

class _ColorWash extends StatelessWidget {
  const _ColorWash({required this.script});

  final CapsuleCinemaScript script;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(script.coverColorValue),
            AppColors.wallDeep,
            script.feeling.color.withValues(alpha: 0.7),
          ],
        ),
      ),
    );
  }
}

class _BeatContent extends StatelessWidget {
  const _BeatContent({
    required this.script,
    required this.beat,
    required this.wind,
  });

  final CapsuleCinemaScript script;
  final CapsuleCinemaBeat beat;
  final Animation<double> wind;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return switch (beat.kind) {
      CapsuleCinemaBeatKind.seal => _SealBeat(wind: wind),
      CapsuleCinemaBeatKind.cover => _FadeUp(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: script.feeling.color.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  script.feeling.label,
                  style: const TextStyle(
                    color: AppColors.wallInk,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                script.title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.cinemaSharedChapter,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      CapsuleCinemaBeatKind.story => _FadeUp(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 140),
          child: Text(
            script.story,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ),
      CapsuleCinemaBeatKind.place => _FadeUp(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 140),
          child: Row(
            children: [
              const Icon(Icons.place_rounded, color: AppColors.gold, size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  script.locationLabel,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      CapsuleCinemaBeatKind.thread => _FadeUp(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                l10n.cinemaConnectedThread,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              for (final title in script.relatedMemoryTitles.take(4)) ...[
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.rope,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
      CapsuleCinemaBeatKind.invite => const SizedBox.shrink(),
    };
  }
}

class _SealBeat extends StatelessWidget {
  const _SealBeat({required this.wind});

  final Animation<double> wind;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: wind,
      builder: (context, _) {
        final progress = Curves.easeOutCubic.transform(
          (wind.value * 2).clamp(0.0, 1.0),
        );
        return Center(
          child: Opacity(
            opacity: progress,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                  size: const Size(120, 48),
                  painter: _ThreadPainter(progress: progress),
                ),
                const SizedBox(height: 18),
                const Text(
                  'LifeThreads',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ThreadPainter extends CustomPainter {
  const _ThreadPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.rope
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * (0.1 + (1 - progress) * 0.4),
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * (0.9 - (1 - progress) * 0.3),
        size.width * progress,
        size.height * 0.45,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ThreadPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _FadeUp extends StatelessWidget {
  const _FadeUp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 18),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _InviteBar extends StatelessWidget {
  const _InviteBar({required this.onAdd, required this.onDismiss});

  final VoidCallback onAdd;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.cinemaInviteTitle,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onAdd, child: Text(l10n.addToWall)),
            const SizedBox(height: 8),
            TextButton(onPressed: onDismiss, child: Text(l10n.cinemaNotNow)),
          ],
        ),
      ),
    );
  }
}
