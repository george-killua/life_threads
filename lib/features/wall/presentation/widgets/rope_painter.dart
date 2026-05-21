import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../memories/domain/memory_connection.dart';

enum RopeAnchorKind { memory, note, nail }

class RopeAnchor {
  const RopeAnchor({
    required this.point,
    required this.kind,
    required this.direction,
  });

  final Offset point;
  final RopeAnchorKind kind;
  final Offset direction;
}

class RopePainter extends CustomPainter {
  const RopePainter({
    required this.anchors,
    required this.connections,
    required this.windValue,
    required this.activeNodeId,
    this.paintAnchors = false,
  });

  final Map<String, RopeAnchor> anchors;
  final List<MemoryConnection> connections;
  final double windValue;
  final String? activeNodeId;
  final bool paintAnchors;

  @override
  void paint(Canvas canvas, Size size) {
    final drawable = <_DrawableRope>[];
    for (var index = 0; index < connections.length; index++) {
      final connection = connections[index];
      final start = anchors[connection.fromEventId];
      final end = anchors[connection.toEventId];
      if (start == null || end == null) continue;

      final isActive =
          activeNodeId == connection.fromEventId ||
          activeNodeId == connection.toEventId;
      drawable.add(
        _DrawableRope(
          connection: connection,
          start: start,
          end: end,
          index: index,
          isActive: isActive,
        ),
      );
    }

    final clutterFactor = _clutterFactor(drawable.length);
    for (final rope in drawable.where((rope) => !rope.isActive)) {
      _drawRope(canvas, rope, clutterFactor: clutterFactor);
    }
    for (final rope in drawable.where((rope) => rope.isActive)) {
      _drawRope(canvas, rope, clutterFactor: 1);
    }
  }

  void _drawRope(
    Canvas canvas,
    _DrawableRope rope, {
    required double clutterFactor,
  }) {
    final geometry = _RopeGeometry.from(
      rope: rope,
      windValue: windValue,
      clutterFactor: clutterFactor,
    );

    _drawRopeShadow(canvas, geometry.path, rope.isActive, clutterFactor);
    _drawRopeGlow(canvas, geometry.path, rope.isActive, clutterFactor);
    _drawRopeBody(canvas, geometry.path, rope.isActive, clutterFactor);
    _drawBraidedThreads(canvas, geometry.path, rope, clutterFactor);
    _drawSparkles(canvas, geometry.path, rope, clutterFactor);
    if (rope.isActive) {
      _drawActiveShimmer(canvas, geometry.path);
    }
    if (paintAnchors) {
      _drawAnchor(canvas, rope.start, rope.isActive, clutterFactor);
      _drawAnchor(canvas, rope.end, rope.isActive, clutterFactor);
    }
  }

  double _clutterFactor(int visibleRopes) {
    if (visibleRopes <= 7) return 1;
    if (visibleRopes <= 12) return 0.74;
    return 0.56;
  }

  void _drawRopeShadow(
    Canvas canvas,
    Path path,
    bool isActive,
    double clutterFactor,
  ) {
    canvas.drawPath(
      path.shift(Offset(0, isActive ? 8 : 6)),
      Paint()
        ..color = Colors.black.withValues(
          alpha: (isActive ? 0.44 : 0.28) * clutterFactor,
        )
        ..strokeWidth = isActive ? 12 : 9
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawRopeBody(
    Canvas canvas,
    Path path,
    bool isActive,
    double clutterFactor,
  ) {
    final bodyAlpha = (isActive ? 1.0 : 0.82) * clutterFactor;
    final width = isActive ? 8.4 : 6.2;
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF4A3425).withValues(alpha: bodyAlpha * 0.9)
        ..strokeWidth = width
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      path.shift(const Offset(-1.45, -1.0)),
      Paint()
        ..color = const Color(
          0xFFF1D79A,
        ).withValues(alpha: (isActive ? 0.88 : 0.58) * clutterFactor)
        ..strokeWidth = isActive ? 3.6 : 2.7
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      path.shift(const Offset(1.45, 1.0)),
      Paint()
        ..color = const Color(
          0xFF7F93B8,
        ).withValues(alpha: (isActive ? 0.72 : 0.44) * clutterFactor)
        ..strokeWidth = isActive ? 3.3 : 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawRopeGlow(
    Canvas canvas,
    Path path,
    bool isActive,
    double clutterFactor,
  ) {
    final alpha = (isActive ? 0.46 : 0.22) * clutterFactor;
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.amber.withValues(alpha: alpha)
        ..strokeWidth = isActive ? 26 : 18
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );
    canvas.drawPath(
      path.shift(const Offset(2, -2)),
      Paint()
        ..color = const Color(0xFF89A7D8).withValues(alpha: alpha * 0.55)
        ..strokeWidth = isActive ? 18 : 12
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  void _drawActiveShimmer(Canvas canvas, Path path) {
    final shimmerPaint = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.26)
      ..strokeWidth = 1.7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final metric in path.computeMetrics()) {
      for (double offset = 0; offset < metric.length; offset += 22) {
        final end = (offset + 8).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(offset, end), shimmerPaint);
      }
    }
  }

  void _drawBraidedThreads(
    Canvas canvas,
    Path path,
    _DrawableRope rope,
    double clutterFactor,
  ) {
    final isActive = rope.isActive;
    if (!isActive && clutterFactor < 0.7) return;

    final goldPaint = Paint()
      ..color = const Color(
        0xFFFFE2A5,
      ).withValues(alpha: (isActive ? 0.72 : 0.38) * clutterFactor)
      ..strokeWidth = isActive ? 1.35 : 1.05
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final bluePaint = Paint()
      ..color = const Color(
        0xFFAAB9D5,
      ).withValues(alpha: (isActive ? 0.62 : 0.32) * clutterFactor)
      ..strokeWidth = isActive ? 1.25 : 0.95
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final metric in path.computeMetrics()) {
      final step = isActive ? 12.0 : 15.0;
      for (double offset = 6; offset < metric.length - 6; offset += step) {
        final tangent = metric.getTangentForOffset(offset);
        if (tangent == null) continue;
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
        final phase = math.sin(offset * 0.16 + rope.index * 0.9);
        final start = tangent.position + normal * (phase * 4.2);
        final end = tangent.position - normal * (phase * 4.2);
        canvas.drawLine(start, end, phase > 0 ? goldPaint : bluePaint);
      }
    }
  }

  void _drawSparkles(
    Canvas canvas,
    Path path,
    _DrawableRope rope,
    double clutterFactor,
  ) {
    if (!rope.isActive && clutterFactor < 0.74) return;

    final count = rope.isActive ? 9 : 4;
    final glowPaint = Paint()
      ..color = AppColors.amber.withValues(
        alpha: (rope.isActive ? 0.46 : 0.2) * clutterFactor,
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
    final sparkPaint = Paint()
      ..color = const Color(
        0xFFFFF6D9,
      ).withValues(alpha: (rope.isActive ? 0.92 : 0.48) * clutterFactor);

    for (final metric in path.computeMetrics()) {
      if (metric.length < 90) continue;
      for (var index = 0; index < count; index++) {
        final seed =
            (index * 0.173 + rope.index * 0.119 + windValue * 0.18) % 1;
        final distance = (metric.length * (0.12 + seed * 0.76)).clamp(
          0,
          metric.length,
        );
        final tangent = metric.getTangentForOffset(distance.toDouble());
        if (tangent == null) continue;
        final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
        final flicker = math.sin(windValue * math.pi * 2 + index * 1.7);
        final point = tangent.position + normal * (10 + flicker * 5);
        final radius = rope.isActive ? 1.9 + flicker.abs() * 1.1 : 1.35;

        canvas.drawCircle(point, radius * 4.2, glowPaint);
        canvas.drawCircle(point, radius, sparkPaint);
      }
    }
  }

  void _drawAnchor(
    Canvas canvas,
    RopeAnchor anchor,
    bool isActive,
    double clutterFactor,
  ) {
    final point = anchor.point;
    if (anchor.kind == RopeAnchorKind.memory) {
      final alpha = isActive ? 1.0 : clutterFactor;
      canvas.drawCircle(
        point + const Offset(0, 3),
        9.8,
        Paint()..color = Colors.black.withValues(alpha: 0.28 * alpha),
      );
      canvas.drawCircle(
        point,
        8.6,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.35, -0.45),
            radius: 0.9,
            colors: [
              isActive ? AppColors.amber : const Color(0xFFFFD77D),
              const Color(0xFF9C6727),
            ],
          ).createShader(Rect.fromCircle(center: point, radius: 8.6)),
      );
      canvas.drawCircle(
        point,
        10.1,
        Paint()
          ..color = AppColors.card.withValues(alpha: 0.58 * alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
      canvas.drawCircle(
        point,
        3.0,
        Paint()..color = Colors.black.withValues(alpha: 0.2 * alpha),
      );
      return;
    }

    final radius = switch (anchor.kind) {
      RopeAnchorKind.memory => 8.8,
      RopeAnchorKind.note => 7.4,
      RopeAnchorKind.nail => 10.2,
    };
    final alpha = isActive ? 1.0 : clutterFactor;

    canvas.drawCircle(
      point + const Offset(0, 4),
      radius + 1.2,
      Paint()..color = Colors.black.withValues(alpha: 0.34 * alpha),
    );
    canvas.drawCircle(
      point,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            isActive ? AppColors.amber : const Color(0xFFFFD77D),
            const Color(0xFF9B6829),
          ],
        ).createShader(Rect.fromCircle(center: point, radius: radius)),
    );
    canvas.drawCircle(
      point,
      radius + 1.7,
      Paint()
        ..color = AppColors.card.withValues(alpha: 0.24 * alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.25,
    );
  }

  @override
  bool shouldRepaint(covariant RopePainter oldDelegate) {
    return oldDelegate.anchors != anchors ||
        oldDelegate.connections != connections ||
        oldDelegate.windValue != windValue ||
        oldDelegate.activeNodeId != activeNodeId ||
        oldDelegate.paintAnchors != paintAnchors;
  }
}

class _DrawableRope {
  const _DrawableRope({
    required this.connection,
    required this.start,
    required this.end,
    required this.index,
    required this.isActive,
  });

  final MemoryConnection connection;
  final RopeAnchor start;
  final RopeAnchor end;
  final int index;
  final bool isActive;
}

class _RopeGeometry {
  const _RopeGeometry({
    required this.start,
    required this.end,
    required this.path,
  });

  factory _RopeGeometry.from({
    required _DrawableRope rope,
    required double windValue,
    required double clutterFactor,
  }) {
    final rawVector = rope.end.point - rope.start.point;
    final rawDistance = rawVector.distance;
    final rawNormal = rawDistance == 0
        ? Offset.zero
        : Offset(-rawVector.dy / rawDistance, rawVector.dx / rawDistance);
    final lane = ((rope.index % 5) - 2) * 3.2 * clutterFactor;
    final start = rope.start.point + rawNormal * lane;
    final end = rope.end.point + rawNormal * -lane;
    final vector = end - start;
    final distance = vector.distance;
    final safeDistance = distance == 0 ? 1.0 : distance;
    final unit = vector / safeDistance;
    final normal = Offset(-unit.dy, unit.dx);
    final horizontal = vector.dx.abs();
    final vertical = vector.dy.abs();
    final wind = math.sin(windValue * math.pi * 2 + distance * 0.012);
    final sag = (horizontal * 0.12 + vertical * 0.035).clamp(
      rope.isActive ? 5.0 : 18.0,
      rope.isActive ? 30.0 : 86.0,
    );
    final sideBias = horizontal < 70 ? (rope.index.isEven ? 24.0 : -24.0) : 0.0;
    final sidePull =
        (lane + sideBias + wind * (rope.isActive ? 6 : 15)) * clutterFactor;
    final slack = Offset(0, sag);
    final control1 = start + vector * 0.34 + slack * 0.55 + normal * sidePull;
    final control2 = start + vector * 0.68 + slack + normal * (sidePull * 0.72);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        end.dx,
        end.dy,
      );

    return _RopeGeometry(start: start, end: end, path: path);
  }

  final Offset start;
  final Offset end;
  final Path path;
}
