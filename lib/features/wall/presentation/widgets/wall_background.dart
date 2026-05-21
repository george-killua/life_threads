import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../premium/data/premium_entitlement_controller.dart';
import '../../data/wall_theme_controller.dart';
import '../../domain/wall_theme.dart';

class WallBackground extends ConsumerWidget {
  const WallBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme =
        ref.watch(wallThemeProvider).asData?.value ??
        WallThemePreset.warmMemoryRoom;
    final isPremium =
        ref.watch(premiumEntitlementProvider).asData?.value.isPremium ?? false;
    final theme = selectedTheme.isPremium && !isPremium
        ? WallThemePreset.warmMemoryRoom
        : selectedTheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: theme.background),
      child: CustomPaint(
        painter: _MemoryRoomPainter(theme: theme),
        child: child,
      ),
    );
  }
}

class _MemoryRoomPainter extends CustomPainter {
  const _MemoryRoomPainter({required this.theme});

  final WallThemePreset theme;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.background, theme.depth, theme.surface],
          stops: const [0, 0.52, 1],
        ).createShader(rect),
    );

    _paintGlow(
      canvas,
      center: Offset(size.width * 0.2, size.height * 0.12),
      radius: size.shortestSide * 0.9,
      color: theme.secondaryGlow.withValues(alpha: 0.16),
    );
    _paintGlow(
      canvas,
      center: Offset(size.width * 0.92, size.height * 0.78),
      radius: size.shortestSide * 0.86,
      color: theme.accent.withValues(alpha: 0.12),
    );
    _paintGlow(
      canvas,
      center: Offset(size.width * 0.48, size.height * 0.5),
      radius: size.shortestSide * 0.74,
      color: theme.surface.withValues(alpha: 0.04),
    );

    _paintRoomTexture(canvas, size);
    _paintSubtleBoardGrid(canvas, size);
    _paintVignette(canvas, rect);
  }

  void _paintRoomTexture(Canvas canvas, Size size) {
    final warmFiber = Paint()
      ..color = theme.accent.withValues(alpha: 0.02)
      ..strokeWidth = 1;
    final coolFiber = Paint()
      ..color = theme.secondaryGlow.withValues(alpha: 0.014)
      ..strokeWidth = 1;

    for (double y = 10; y < size.height; y += 13) {
      final drift = math.sin(y * 0.021) * 11;
      canvas.drawLine(
        Offset(drift - 20, y),
        Offset(size.width + drift + 20, y + 1.8),
        y % 39 == 0 ? coolFiber : warmFiber,
      );
    }

    final speck = Paint()
      ..color = (theme.id == WallThemeId.softPaperWall
          ? AppColors.paperInk.withValues(alpha: 0.045)
          : Colors.white.withValues(alpha: 0.018));
    for (var i = 0; i < 150; i++) {
      final x = (i * 47) % size.width;
      final y = (i * 83) % size.height;
      final r = 0.45 + ((i * 13) % 5) * 0.08;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), r, speck);
    }
  }

  void _paintSubtleBoardGrid(Canvas canvas, Size size) {
    final line = Paint()
      ..color = theme.line.withValues(alpha: 0.16)
      ..strokeWidth = 1;
    final major = Paint()
      ..color = theme.accent.withValues(alpha: 0.06)
      ..strokeWidth = 1.2;

    final spacing = switch (theme.id) {
      WallThemeId.travelCorkboard => 92.0,
      WallThemeId.softPaperWall => 132.0,
      _ => 118.0,
    };
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }

    for (double x = spacing * 0.5; x < size.width; x += spacing * 2) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), major);
    }
  }

  void _paintGlow(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
  }) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  void _paintVignette(Canvas canvas, Rect rect) {
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.86,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.38)],
          stops: const [0.62, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _MemoryRoomPainter oldDelegate) {
    return oldDelegate.theme.id != theme.id;
  }
}
