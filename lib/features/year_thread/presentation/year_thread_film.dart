import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../app/theme/app_colors.dart';
import '../../../core/localization/app_localizations_x.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../memories/presentation/memory_l10n.dart';
import '../../stories/domain/story_film.dart';
import '../domain/year_thread.dart';
import '../domain/year_thread_timeline.dart';
import 'widgets/year_thread_visuals.dart';

/// "2025 · 14 memories · 6 places" (places only when there are any; the
/// year left out where it is already shown large).
String yearThreadSummary(
  AppLocalizations l10n,
  YearThreadStats stats, {
  bool withYear = true,
}) => [
  if (withYear) '${stats.year}',
  l10n.yearThreadMemories(stats.memoryCount),
  if (stats.placeCount > 0) l10n.yearThreadPlaces(stats.placeCount),
].join(' · ');

/// The year as a short film: a title card, one shot per memory in date
/// order with the rope drawing from one memory to the next, month markers,
/// and a closing card with the year's stats.
class YearThreadFilm extends StoryFilm {
  YearThreadFilm({
    required this.stats,
    required List<YearThreadMemory> memories,
    this.cut = YearThreadCut.full,
  }) : memories = cut.pick(memories),
       assert(memories.isNotEmpty, 'A film needs at least one memory') {
    timeline = YearThreadTimeline.build(this.memories.length, cut);
  }

  /// The whole year's stats (not only the memories in the film).
  final YearThreadStats stats;

  /// The memories the film shows, in date order.
  final List<YearThreadMemory> memories;
  final YearThreadCut cut;
  late final YearThreadTimeline timeline;

  @override
  Duration get duration => timeline.total;

  @override
  List<ImageProvider> get images => [
    for (final memory in memories) ?yearThreadPhoto(memory),
  ];

  @override
  Widget buildFrame(BuildContext context, Duration time) =>
      YearThreadFrame(film: this, time: time);
}

/// One frame of a [YearThreadFilm], drawn from [time] alone.
class YearThreadFrame extends StatelessWidget {
  const YearThreadFrame({super.key, required this.film, required this.time});

  final YearThreadFilm film;
  final Duration time;

  // World layout: cards stand on a line, [_spacing] apart, and the camera
  // travels along it (to the left in right-to-left languages).
  static const _spacing = 300.0;
  static const _anchor = Offset(180, 150);
  static const _closingZoomIn = Duration(milliseconds: 1800);

  static double _ease(double t) =>
      Curves.easeInOutCubic.transform(t.clamp(0.0, 1.0));

  static double _ramp(Duration elapsed, int fromMs, int toMs) =>
      ((elapsed.inMicroseconds / 1000 - fromMs) / (toMs - fromMs)).clamp(
        0.0,
        1.0,
      );

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final timeline = film.timeline;
    final moment = timeline.at(time);
    final fadeStart = timeline.title - YearThreadTimeline.titleFadeOut;

    final children = <Widget>[
      const Positioned.fill(child: YearThreadBackdrop()),
    ];
    switch (moment.part) {
      case YearThreadPart.title:
        final overlay = time < fadeStart
            ? 1.0
            : 1 - _ease(_ramp(time - fadeStart, 0, 700));
        if (overlay < 1) {
          // The first shot shows through as the title fades.
          children.addAll(
            _shotLayers(
              context,
              const YearThreadMoment(
                part: YearThreadPart.shot,
                elapsed: Duration.zero,
                length: Duration(seconds: 1),
              ),
              rtl,
            ),
          );
        }
        children.add(
          Positioned.fill(
            child: Opacity(
              opacity: overlay,
              child: _TitleCard(film: film, elapsed: moment.elapsed),
            ),
          ),
        );
      case YearThreadPart.shot:
        children.addAll(_shotLayers(context, moment, rtl));
      case YearThreadPart.closing:
        children.addAll(_closingLayers(context, moment, rtl));
    }
    return ClipRect(child: Stack(children: children));
  }

  Offset _cardPoint(int index, bool rtl) =>
      Offset((rtl ? -1 : 1) * index * _spacing, index.isEven ? -8.0 : 14.0);

  double _cardTilt(int index) {
    final seconds = time.inMicroseconds / 1000000;
    return ((index * 37) % 7 - 3) * 0.011 +
        math.sin(seconds * 1.4 + index * 1.7) * 0.01;
  }

  List<Widget> _shotLayers(
    BuildContext context,
    YearThreadMoment moment,
    bool rtl,
  ) {
    final index = moment.index;
    final transition = YearThreadTimeline.transitionOf(moment.length);
    final arriving = index > 0 && moment.elapsed < transition;
    final travel = arriving
        ? _ease(moment.elapsed.inMicroseconds / transition.inMicroseconds)
        : 1.0;
    final camera = index > 0
        ? Offset.lerp(
            _cardPoint(index - 1, rtl),
            _cardPoint(index, rtl),
            travel,
          )!
        : _cardPoint(0, rtl);
    final ropes = <int, double>{
      // The lead-in rope from the year before reaches the first card.
      -1: index == 0 ? _ease(_ramp(moment.elapsed, 0, 900)) : 1,
      for (var i = 0; i < index; i++) i: i == index - 1 ? travel : 1,
    };
    // The caption follows once the camera has arrived.
    final arrivedAt = index > 0 ? transition.inMilliseconds : 0;
    final textOpacity = _ease(
      _ramp(moment.elapsed, arrivedAt + 150, arrivedAt + 700),
    );
    return [
      ..._world(
        camera: camera,
        zoom: 1,
        anchor: _anchor,
        ropes: ropes,
        rtl: rtl,
        focus: index,
        focusProgress: moment.progress,
        textOpacity: textOpacity,
      ),
      Positioned(
        left: 24,
        right: 24,
        top: 40,
        child: _MonthHeader(
          film: film,
          index: index,
          arriving: arriving ? travel : null,
        ),
      ),
      Positioned(
        left: 18,
        right: 18,
        bottom: 26,
        child: _MonthRibbon(
          months: {
            for (var i = 0; i <= index; i++)
              film.memories[i].event.occurredAt.month,
          },
          current: film.memories[index].event.occurredAt.month,
          year: film.stats.year,
        ),
      ),
    ];
  }

  List<Widget> _closingLayers(
    BuildContext context,
    YearThreadMoment moment,
    bool rtl,
  ) {
    final count = film.memories.length;
    final last = _cardPoint(count - 1, rtl);
    final first = _cardPoint(0, rtl);
    final centre = Offset((first.dx + last.dx) / 2, 0);
    final span = (last.dx - first.dx).abs() + YearThreadCard.size.width + 48;
    final fitZoom = math.min(1.0, 330 / span);
    final zoomIn = _ease(
      moment.elapsed.inMicroseconds / _closingZoomIn.inMicroseconds,
    );
    final zoom = 1 + (fitZoom - 1) * zoomIn;
    final camera = Offset.lerp(last, centre, zoomIn)!;
    // The whole thread settles in the upper half, above the stats.
    final closingAnchor = Offset(180, 250 - 165 * fitZoom);
    final anchor = Offset.lerp(_anchor, closingAnchor, zoomIn)!;
    final markers = 1 - _ease(_ramp(moment.elapsed, 0, 500));
    final panel = _ease(_ramp(moment.elapsed, 1200, 2000));
    return [
      ..._world(
        camera: camera,
        zoom: zoom,
        anchor: anchor,
        ropes: {for (var i = -1; i < count - 1; i++) i: 1},
        rtl: rtl,
        focus: count - 1,
        focusProgress: 1,
        textOpacity: 1,
      ),
      if (markers > 0)
        Positioned(
          left: 18,
          right: 18,
          bottom: 26,
          child: Opacity(
            opacity: markers,
            child: _MonthRibbon(
              months: film.stats.months.toSet(),
              current: film.memories.last.event.occurredAt.month,
              year: film.stats.year,
            ),
          ),
        ),
      if (panel > 0)
        Positioned(
          left: 22,
          right: 22,
          bottom: 30 - 16 * (1 - panel),
          child: Opacity(
            opacity: panel,
            child: _ClosingPanel(stats: film.stats),
          ),
        ),
    ];
  }

  /// The ropes and cards seen by a camera at [camera] (world) shown at
  /// [anchor] (screen), [zoom] times their size.
  List<Widget> _world({
    required Offset camera,
    required double zoom,
    required Offset anchor,
    required Map<int, double> ropes,
    required bool rtl,
    required int focus,
    required double focusProgress,
    required double textOpacity,
  }) {
    Offset screen(Offset world) => (world - camera) * zoom + anchor;
    final cardWidth = YearThreadCard.size.width * zoom;
    final ropeList = [
      for (final MapEntry(key: i, value: progress) in ropes.entries)
        if (progress > 0)
          YearThreadRope(
            from: screen(
              i < 0
                  ? _cardPoint(0, rtl) - Offset((rtl ? -1 : 1) * 260, 70)
                  : _cardPoint(i, rtl),
            ),
            to: screen(_cardPoint(i + 1, rtl)),
            progress: progress,
            sag: 64 * zoom,
          ),
    ];
    final cards = <Widget>[];
    for (var i = 0; i < film.memories.length; i++) {
      final pin = screen(_cardPoint(i, rtl));
      if (pin.dx + cardWidth / 2 < -20 || pin.dx - cardWidth / 2 > 380) {
        continue;
      }
      final isFocus = i == focus;
      // The photo drifts and zooms slowly through its shot, alternating
      // direction from memory to memory.
      final drift = isFocus ? focusProgress : (i < focus ? 1.0 : 0.0);
      final direction = i.isEven ? 1.0 : -1.0;
      cards.add(
        Positioned(
          left: pin.dx - YearThreadCard.size.width / 2,
          top: pin.dy,
          child: Transform.rotate(
            angle: _cardTilt(i),
            alignment: Alignment.topCenter,
            child: Transform.scale(
              scale: zoom,
              alignment: Alignment.topCenter,
              child: YearThreadCard(
                memory: film.memories[i],
                photoScale: 1.04 + 0.1 * drift,
                photoDrift: Offset(direction * 12 * (drift - 0.5), 0),
                textOpacity: isFocus ? textOpacity : 1,
              ),
            ),
          ),
        ),
      );
    }
    return [
      Positioned.fill(
        child: CustomPaint(
          painter: YearThreadRopePainter(ropes: ropeList, scale: zoom),
        ),
      ),
      ...cards,
    ];
  }
}

class _TitleCard extends StatelessWidget {
  const _TitleCard({required this.film, required this.elapsed});

  final YearThreadFilm film;
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appear = YearThreadFrame._ease(
      YearThreadFrame._ramp(elapsed, 0, 900),
    );
    final summary = YearThreadFrame._ease(
      YearThreadFrame._ramp(elapsed, 500, 1300),
    );
    final rope = YearThreadFrame._ease(
      YearThreadFrame._ramp(elapsed, 400, 2000),
    );
    const ropeFrom = Offset(28, 446);
    const ropeTo = Offset(332, 446);
    return Stack(
      children: [
        const Positioned.fill(child: YearThreadBackdrop()),
        Positioned.fill(
          child: CustomPaint(
            painter: YearThreadRopePainter(
              ropes: [
                YearThreadRope(
                  from: ropeFrom,
                  to: ropeTo,
                  progress: rope,
                  sag: 70,
                ),
              ],
            ),
          ),
        ),
        // Pins appear as the rope reaches them.
        for (final at in const [0.2, 0.5, 0.8])
          if (rope >= at)
            Positioned(
              left: _ropePoint(ropeFrom, ropeTo, 70, at).dx - 16,
              top: _ropePoint(ropeFrom, ropeTo, 70, at).dy - 12,
              width: 32,
              child: const Center(child: _SmallPin()),
            ),
        Positioned(
          left: 24,
          right: 24,
          top: 190,
          child: Opacity(
            opacity: appear,
            child: Column(
              children: [
                Text(
                  l10n.yearThreadTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 6),
                Transform.scale(
                  scale: 0.94 + 0.06 * appear,
                  child: Text(
                    '${film.stats.year}',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: AppColors.card,
                      fontSize: 100,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -3,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Opacity(
                  opacity: summary,
                  child: Text(
                    yearThreadSummary(l10n, film.stats, withYear: false),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 30,
          child: Center(child: YearThreadMark()),
        ),
      ],
    );
  }

  static Offset _ropePoint(Offset from, Offset to, double sag, double t) {
    final control = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2 + sag);
    final u = 1 - t;
    return from * (u * u) + control * (2 * u * t) + to * (t * t);
  }
}

class _SmallPin extends StatelessWidget {
  const _SmallPin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.38, -0.42),
          colors: [Color(0xFFE6C78A), Color(0xFFB89255), Color(0xFF4A3118)],
          stops: [0, 0.45, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(1, 3),
          ),
        ],
      ),
    );
  }
}

/// The month of the memory on screen; a new month slides in when the camera
/// travels into it.
class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.film,
    required this.index,
    required this.arriving,
  });

  final YearThreadFilm film;
  final int index;

  /// 0..1 while the camera travels to [index]; null once it has arrived.
  final double? arriving;

  @override
  Widget build(BuildContext context) {
    final date = film.memories[index].event.occurredAt;
    final travel = arriving;
    final previous = index > 0
        ? film.memories[index - 1].event.occurredAt
        : null;
    final changes = previous != null && previous.month != date.month;
    final showPrevious = travel != null && changes && travel < 0.5;
    final shown = showPrevious ? previous : date;
    final opacity = travel == null || !changes
        ? 1.0
        : (travel < 0.5 ? 1 - travel * 2 : travel * 2 - 1);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Column(
        children: [
          Text(
            '${film.stats.year}',
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat.MMMM(locale).format(shown),
            style: const TextStyle(
              color: AppColors.card,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Twelve month markers along a thread; months with memories so far light
/// up and the current one is named.
class _MonthRibbon extends StatelessWidget {
  const _MonthRibbon({
    required this.months,
    required this.current,
    required this.year,
  });

  final Set<int> months;
  final int current;
  final int year;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            right: 8,
            top: 7,
            child: Container(
              height: 1.6,
              color: AppColors.rope.withValues(alpha: 0.55),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var month = 1; month <= 12; month++)
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                        child: Center(
                          child: Container(
                            width: month == current ? 12 : 7,
                            height: month == current ? 12 : 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: month == current
                                  ? AppColors.amber
                                  : months.contains(month)
                                  ? AppColors.gold
                                  : AppColors.line,
                              boxShadow: month == current
                                  ? [
                                      BoxShadow(
                                        color: AppColors.amber.withValues(
                                          alpha: 0.6,
                                        ),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      if (month == current)
                        SizedBox(
                          height: 18,
                          child: OverflowBox(
                            maxWidth: 90,
                            child: Text(
                              DateFormat.MMM(
                                locale,
                              ).format(DateTime(year, month)),
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(
                                color: AppColors.amber,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClosingPanel extends StatelessWidget {
  const _ClosingPanel({required this.stats});

  final YearThreadStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mostFelt = stats.mostFelt;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${stats.year}',
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.yearThreadClosingLine,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.card,
            fontSize: 30,
            height: 1.1,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            YearThreadStatChip(
              icon: Icons.auto_stories_rounded,
              label: l10n.yearThreadMemories(stats.memoryCount),
            ),
            if (stats.placeCount > 0)
              YearThreadStatChip(
                icon: Icons.place_rounded,
                label: l10n.yearThreadPlaces(stats.placeCount),
              ),
            if (stats.peopleCount > 0)
              YearThreadStatChip(
                icon: Icons.people_alt_rounded,
                label: l10n.yearThreadPeople(stats.peopleCount),
              ),
            YearThreadStatChip(
              icon: Icons.calendar_month_rounded,
              label: l10n.yearThreadMonths(stats.months.length),
            ),
            if (mostFelt != null)
              YearThreadStatChip(
                icon: mostFelt.icon,
                color: mostFelt.color,
                label: l10n.yearThreadMostFelt(mostFelt.localizedLabel(l10n)),
              ),
          ],
        ),
        const SizedBox(height: 26),
        const YearThreadMark(),
      ],
    );
  }
}
