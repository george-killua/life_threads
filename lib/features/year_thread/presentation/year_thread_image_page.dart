import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/localization/app_localizations_x.dart';
import '../../memories/presentation/memory_l10n.dart';
import '../domain/year_thread.dart';
import 'widgets/year_thread_visuals.dart';

/// "My year": one 9:16 story image (360×640 logical) with the year's photos
/// pinned in rows on the rope and its stats underneath.
class YearThreadImagePage extends StatelessWidget {
  const YearThreadImagePage({
    super.key,
    required this.stats,
    required this.memories,
  });

  final YearThreadStats stats;

  /// The film's memories (date order); photos are shown first.
  final List<YearThreadMemory> memories;

  static const maxTiles = 9;
  static const _columns = 3;
  static const _gap = 16.0;
  static const _rowPitch = 118.0;
  static const _gridTop = 142.0;
  static const _gridBottom = 492.0;

  /// Up to [maxTiles] memories, those with a photo first, each group in
  /// date order.
  static List<YearThreadMemory> tilesOf(List<YearThreadMemory> memories) => [
    ...memories.where((memory) => memory.hasPhoto),
    ...memories.where((memory) => !memory.hasPhoto),
  ].take(maxTiles).toList();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final tiles = tilesOf(memories);
    final rows = (tiles.length / _columns).ceil();
    final card = YearThreadCard.compactSize;
    final gridHeight = rows == 0 ? 0.0 : (rows - 1) * _rowPitch + card.height;
    final top = _gridTop + (_gridBottom - _gridTop - gridHeight) / 2;

    final pins = <Offset>[];
    final cards = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      final row = i ~/ _columns;
      final inRow = row == rows - 1 ? tiles.length - row * _columns : _columns;
      final column = i % _columns;
      final rowWidth = inRow * card.width + (inRow - 1) * _gap;
      final start = (360 - rowWidth) / 2;
      final slot = rtl ? inRow - 1 - column : column;
      final pin = Offset(
        start + slot * (card.width + _gap) + card.width / 2,
        top + row * _rowPitch + (column.isOdd ? 8 : 0),
      );
      pins.add(pin);
      cards.add(
        Positioned(
          left: pin.dx - card.width / 2,
          top: pin.dy,
          child: Transform.rotate(
            angle: ((i * 5) % 7 - 3) * 0.018,
            alignment: Alignment.topCenter,
            child: YearThreadCard(memory: tiles[i], compact: true),
          ),
        ),
      );
    }
    final mostFelt = stats.mostFelt;

    return Stack(
      children: [
        const Positioned.fill(child: YearThreadBackdrop()),
        Positioned.fill(
          child: CustomPaint(
            painter: YearThreadRopePainter(
              scale: 0.6,
              ropes: [
                for (var i = 0; i + 1 < pins.length; i++)
                  // One rope per row, as on the wall.
                  if (i ~/ _columns == (i + 1) ~/ _columns)
                    YearThreadRope(from: pins[i], to: pins[i + 1], sag: 22),
              ],
            ),
          ),
        ),
        ...cards,
        Positioned(
          left: 24,
          right: 24,
          top: 38,
          child: Column(
            children: [
              Text(
                l10n.yearThreadMyYear.toUpperCase(),
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              Text(
                '${stats.year}',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: AppColors.card,
                  fontSize: 64,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 48,
          child: Column(
            children: [
              Text(
                [
                  l10n.yearThreadMemories(stats.memoryCount),
                  if (stats.placeCount > 0)
                    l10n.yearThreadPlaces(stats.placeCount),
                  if (stats.peopleCount > 0)
                    l10n.yearThreadPeople(stats.peopleCount),
                  l10n.yearThreadMonths(stats.months.length),
                ].join(' · '),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (mostFelt != null) ...[
                const SizedBox(height: 9),
                YearThreadStatChip(
                  icon: mostFelt.icon,
                  color: mostFelt.color,
                  label: l10n.yearThreadMostFelt(mostFelt.localizedLabel(l10n)),
                ),
              ],
            ],
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Center(child: YearThreadMark()),
        ),
      ],
    );
  }
}
