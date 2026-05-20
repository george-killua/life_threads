import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../memories/domain/memory_connection.dart';

class RopePainter extends CustomPainter {
  const RopePainter({
    required this.anchors,
    required this.connections,
    required this.windValue,
    required this.activeNodeId,
  });

  final Map<String, Offset> anchors;
  final List<MemoryConnection> connections;
  final double windValue;
  final String? activeNodeId;

  @override
  void paint(Canvas canvas, Size size) {
    for (final connection in connections) {
      final start = anchors[connection.fromEventId];
      final end = anchors[connection.toEventId];
      if (start == null || end == null) continue;

      final isActive =
          activeNodeId == connection.fromEventId ||
          activeNodeId == connection.toEventId;
      final distance = (end - start).distance;
      final wind = math.sin(windValue * math.pi * 2 + distance * 0.013);
      final sag = isActive
          ? (distance * 0.045).clamp(10.0, 42.0)
          : (distance * 0.16).clamp(38.0, 120.0);
      final mid = Offset((start.dx + end.dx) / 2, math.max(start.dy, end.dy));
      final control = mid + Offset(wind * (isActive ? 5 : 14), sag);
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

      _drawRopeShadow(canvas, path, isActive);
      _drawRopeBody(canvas, path, isActive);
      if (isActive) _drawTensionLine(canvas, start, end);
      _drawTwist(canvas, path, isActive);
      _drawAnchor(canvas, start, isActive);
      _drawAnchor(canvas, end, isActive);
    }
  }

  void _drawRopeShadow(Canvas canvas, Path path, bool isActive) {
    canvas.drawPath(
      path.shift(Offset(0, isActive ? 8 : 6)),
      Paint()
        ..color = Colors.black.withValues(alpha: isActive ? 0.42 : 0.3)
        ..strokeWidth = isActive ? 12 : 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawRopeBody(Canvas canvas, Path path, bool isActive) {
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.rope.withValues(alpha: isActive ? 0.98 : 0.84)
        ..strokeWidth = isActive ? 5.8 : 4.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      path.shift(const Offset(-1.4, -1.1)),
      Paint()
        ..color = const Color(
          0xFFE2B873,
        ).withValues(alpha: isActive ? 0.72 : 0.48)
        ..strokeWidth = 1.25
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      path.shift(const Offset(1.7, 1.3)),
      Paint()
        ..color = const Color(0xFF5E371E).withValues(alpha: 0.35)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawTensionLine(Canvas canvas, Offset start, Offset end) {
    final dashPaint = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.2)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final vector = end - start;
    final distance = vector.distance;
    if (distance == 0) return;

    final direction = vector / distance;
    for (double offset = 0; offset < distance; offset += 18) {
      final segmentStart = start + direction * offset;
      final segmentEnd = start + direction * (offset + 8).clamp(0, distance);
      canvas.drawLine(segmentStart, segmentEnd, dashPaint);
    }
  }

  void _drawTwist(Canvas canvas, Path path, bool isActive) {
    final paint = Paint()
      ..color = const Color(
        0xFFFFD89C,
      ).withValues(alpha: isActive ? 0.55 : 0.32)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final metric in path.computeMetrics()) {
      const segment = 7.0;
      const gap = 13.0;
      for (double start = 0; start < metric.length; start += segment + gap) {
        final end = (start + segment).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(start, end), paint);
      }
    }
  }

  void _drawAnchor(Canvas canvas, Offset point, bool isActive) {
    canvas.drawCircle(
      point + const Offset(0, 4),
      9.4,
      Paint()..color = Colors.black.withValues(alpha: 0.35),
    );
    canvas.drawCircle(
      point,
      8.7,
      Paint()
        ..shader = RadialGradient(
          colors: [
            isActive ? AppColors.amber : const Color(0xFFFFD77D),
            const Color(0xFF9B6829),
          ],
        ).createShader(Rect.fromCircle(center: point, radius: 9)),
    );
    canvas.drawCircle(
      point,
      10.3,
      Paint()
        ..color = AppColors.card.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );
  }

  @override
  bool shouldRepaint(covariant RopePainter oldDelegate) {
    return oldDelegate.anchors != anchors ||
        oldDelegate.connections != connections ||
        oldDelegate.windValue != windValue ||
        oldDelegate.activeNodeId != activeNodeId;
  }
}
