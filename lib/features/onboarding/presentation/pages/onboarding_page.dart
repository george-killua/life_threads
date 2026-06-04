import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../memories/data/memory_seed_data.dart';
import '../../onboarding_preferences.dart';
import '../widgets/lifethreads_tutorial.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  bool _isContinuing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.2,
            colors: [AppColors.wallPlum, AppColors.wallInk],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
            children: [
              const _BrandMark(),
              const SizedBox(height: 26),
              Text(
                l10n.onboardingHeadline,
                style: TextStyle(
                  fontSize: 40,
                  height: 1.02,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.onboardingBody,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 17,
                  height: 1.48,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.onboardingPrivacy,
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w900,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 26),
              const _DemoWallPreview(),
              const SizedBox(height: 28),
              const LifeThreadsTutorialSteps(),
              const SizedBox(height: 14),
              _StoryPoint(
                icon: Icons.lock_rounded,
                title: l10n.storyPrivacyTitle,
                text: l10n.onboardingPrivacy,
              ),
              _StoryPoint(
                icon: Icons.hub_rounded,
                title: l10n.storyConnectTitle,
                text: l10n.storyConnectText,
              ),
              _StoryPoint(
                icon: Icons.auto_awesome_rounded,
                title: l10n.storyWallTitle,
                text: l10n.storyWallText,
              ),
              const SizedBox(height: 26),
              FilledButton.icon(
                onPressed: _isContinuing
                    ? null
                    : () => _continue(useDemoWall: true),
                icon: _isContinuing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.preview_rounded),
                label: Text(l10n.previewDemoWall),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isContinuing
                    ? null
                    : () => _continue(useDemoWall: false),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.startFresh),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continue({required bool useDemoWall}) async {
    setState(() => _isContinuing = true);
    await ref
        .read(onboardingPreferencesProvider)
        .markCompleted(useDemoWall: useDemoWall);

    if (!mounted) return;
    setState(() => _isContinuing = false);
    context.go(RouteNames.wall);
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.38)),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.11),
                blurRadius: 32,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.gold,
            size: 34,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'LifeThreads',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _DemoWallPreview extends StatelessWidget {
  const _DemoWallPreview();

  @override
  Widget build(BuildContext context) {
    final demoEvents = MemorySeedData.localizedEvents(context.l10n);

    return Container(
      height: 270,
      decoration: BoxDecoration(
        color: AppColors.wallDeep.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _PreviewGridPainter())),
            Positioned.fill(
              child: CustomPaint(painter: _PreviewThreadPainter(demoEvents)),
            ),
            for (final event in demoEvents)
              _PreviewMemoryCard(
                title: event.title,
                color: event.coverColor,
                imagePath: event.coverPhotoPath,
                position: Offset(
                  event.wallPosition.dx * 0.34 + 18,
                  event.wallPosition.dy * 0.18 + 18,
                ),
                rotation: event.rotation,
              ),
            Positioned(
              left: 18,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.wallInk.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.18),
                  ),
                ),
                child: Text(
                  context.l10n.optionalDemoPreview,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
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

class _PreviewMemoryCard extends StatelessWidget {
  const _PreviewMemoryCard({
    required this.title,
    required this.color,
    required this.imagePath,
    required this.position,
    required this.rotation,
  });

  final String title;
  final Color color;
  final String? imagePath;
  final Offset position;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: 104,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.34),
                blurRadius: 20,
                offset: const Offset(0, 11),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 54,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: imagePath == null
                    ? null
                    : Image.asset(
                        imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.paperInk,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryPoint extends StatelessWidget {
  const _StoryPoint({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.panel.withValues(alpha: 0.58),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.gold, size: 22),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.muted,
                      height: 1.35,
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

class _PreviewGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.055)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 52) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 52) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PreviewThreadPainter extends CustomPainter {
  const _PreviewThreadPainter(this.events);

  final List<dynamic> events;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.rope.withValues(alpha: 0.42)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final points = [
      for (final event in events)
        Offset(
          event.wallPosition.dx * 0.34 + 70,
          event.wallPosition.dy * 0.18 + 48,
        ),
    ];
    for (var index = 0; index < points.length - 1; index++) {
      final start = points[index];
      final end = points[index + 1];
      final control = Offset(
        (start.dx + end.dx) / 2,
        (start.dy + end.dy) / 2 + 38,
      );
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
