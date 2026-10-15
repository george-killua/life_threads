import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/localization/app_localizations_x.dart';
import '../../../core/widgets/top_bar_page.dart';
import '../../memories/data/memory_repository.dart';
import '../../memories/presentation/widgets/memory_list_tile.dart';
import '../../wall/presentation/widgets/wall_background.dart';
import '../data/look_back_providers.dart';
import '../domain/month_look_back.dart';

/// "Your September": a month's memories, the people in them and the places,
/// with arrows to the months before and after.
class MonthLookBackPage extends ConsumerStatefulWidget {
  const MonthLookBackPage({super.key, this.year, this.month});

  /// The month shown first; by default the one the wall card offers, else
  /// the current month.
  final int? year;
  final int? month;

  @override
  ConsumerState<MonthLookBackPage> createState() => _MonthLookBackPageState();
}

class _MonthLookBackPageState extends ConsumerState<MonthLookBackPage> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = ref.read(lookBackClockProvider)();
    final fallback =
        MonthLookBack.cardMonth(now) ?? (year: now.year, month: now.month);
    final month = widget.month;
    final valid = widget.year != null && month != null && month >= 1;
    _year = valid ? widget.year! : fallback.year;
    _month = valid && month <= 12 ? month : fallback.month;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(memoryRepositoryProvider).asData?.value;
    final now = ref.watch(lookBackClockProvider)();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final monthName = DateFormat.yMMMM(locale).format(DateTime(_year, _month));
    final next = MonthLookBack.nextMonth(_year, _month);
    final hasNext =
        next.year < now.year ||
        (next.year == now.year && next.month <= now.month);
    final lookBack = state == null
        ? null
        : MonthLookBack.of(_year, _month, state);

    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: TopBarPage(
            title: l10n.lookBackTitle(monthName),
            actions: [
              IconButton(
                tooltip: l10n.lookBackPreviousMonth,
                onPressed: () => setState(() {
                  final previous = MonthLookBack.previousMonth(_year, _month);
                  _year = previous.year;
                  _month = previous.month;
                }),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              IconButton(
                tooltip: l10n.lookBackNextMonth,
                onPressed: hasNext
                    ? () => setState(() {
                        _year = next.year;
                        _month = next.month;
                      })
                    : null,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
            body: lookBack == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    children: lookBack.isEmpty
                        ? [_EmptyMonth(monthName: monthName)]
                        : _contents(context, lookBack),
                  ),
          ),
        ),
      ),
    );
  }

  List<Widget> _contents(BuildContext context, MonthLookBack lookBack) {
    final l10n = context.l10n;
    return [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _Stat(
            icon: Icons.photo_library_rounded,
            label: l10n.lookBackMemories(lookBack.memories.length),
          ),
          if (lookBack.people.isNotEmpty)
            _Stat(
              icon: Icons.people_alt_rounded,
              label: l10n.lookBackPeople(lookBack.people.length),
            ),
          if (lookBack.places.isNotEmpty)
            _Stat(
              icon: Icons.place_rounded,
              label: l10n.lookBackPlaces(lookBack.places.length),
            ),
        ],
      ),
      const SizedBox(height: 20),
      for (final event in lookBack.memories) MemoryListTile(event: event),
      if (lookBack.people.isNotEmpty) ...[
        _Heading(l10n.lookBackPeopleHeading),
        _Chips(icon: Icons.person_rounded, labels: lookBack.people),
      ],
      if (lookBack.places.isNotEmpty) ...[
        _Heading(l10n.lookBackPlacesHeading),
        _Chips(icon: Icons.place_rounded, labels: lookBack.places),
      ],
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: () => context.push(
          RouteNames.createStory,
          extra: lookBack.memories.first.id,
        ),
        icon: const Icon(Icons.auto_stories_rounded),
        label: Text(l10n.createStory),
      ),
    ];
  }
}

class _EmptyMonth extends StatelessWidget {
  const _EmptyMonth({required this.monthName});

  final String monthName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Icon(Icons.calendar_month_rounded, size: 44, color: AppColors.gold),
          const SizedBox(height: 14),
          Text(
            l10n.lookBackEmpty(monthName),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.lookBackEmptyHint,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => context.push(RouteNames.addMemory),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.addAMemory),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.panelWarm.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.gold),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Semantics(
        header: true,
        child: Text(
          text,
          style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips({required this.icon, required this.labels});

  final IconData icon;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final label in labels)
          Chip(avatar: Icon(icon, size: 18), label: Text(label)),
      ],
    );
  }
}
