import 'dart:math' as math;
import 'dart:ui';

/// Where cards hang on a wall: three columns with room for the ropes, the
/// middle column a little lower, so a wall reads like pictures hung by hand
/// rather than a grid. The demo wall uses it, and a new memory takes the
/// first free spot in it, never on top of another card.
abstract final class WallPlacement {
  /// A memory card's size on the wall (MemoryCard.visualSize).
  static const card = Size(190, 236);

  static const columns = 3;
  static const columnStep = 260.0;
  static const rowStep = 400.0;

  /// The middle column hangs this much lower.
  static const middleDrop = 80.0;

  /// Space kept clear around a card (pins, ropes, the sway).
  static const clearance = 34.0;

  /// The [index]th spot of the pattern, from its top left.
  static Offset slot(int index) {
    final column = index % columns;
    final row = index ~/ columns;
    final drop = column == 1 ? middleDrop : (column == 2 ? -10.0 : 0.0);
    return Offset(column * columnStep, row * rowStep + drop);
  }

  /// The first spot of the pattern not covered by a card at any of [taken]
  /// (their top left corners). The pattern starts where the wall's cards
  /// start, so it lines up with them.
  static Offset freeSpot(Iterable<Offset> taken) {
    final cards = taken.toList();
    if (cards.isEmpty) return slot(0);
    var minX = cards.first.dx;
    var minY = cards.first.dy;
    for (final position in cards) {
      if (position.dx < minX) minX = position.dx;
      if (position.dy < minY) minY = position.dy;
    }
    final origin = Offset(minX, minY + 10);
    final occupied = [
      for (final position in cards) (position & card).inflate(clearance / 2),
    ];
    for (var index = 0; ; index++) {
      final candidate = origin + slot(index);
      final rect = (candidate & card).inflate(clearance / 2);
      if (!occupied.any(rect.overlaps)) return candidate;
    }
  }

  /// The free spot closest to [near] (a card's top left), searching in
  /// growing circles; [near] itself when nothing is free close by.
  static Offset freeSpotNear(Iterable<Offset> taken, Offset near) {
    final occupied = [
      for (final position in taken) (position & card).inflate(clearance / 2),
    ];
    bool free(Offset spot) =>
        !occupied.any((spot & card).inflate(clearance / 2).overlaps);
    if (free(near)) return near;
    for (var ring = 1; ring <= 14; ring++) {
      final radius = ring * 70.0;
      final steps = 8 * ring;
      for (var i = 0; i < steps; i++) {
        final angle = i / steps * 2 * math.pi;
        final spot =
            near + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
        if (free(spot)) return spot;
      }
    }
    return near;
  }
}
