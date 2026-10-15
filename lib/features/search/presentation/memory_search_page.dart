import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/localization/app_localizations_x.dart';
import '../../../core/widgets/top_bar_page.dart';
import '../../memories/data/memory_repository.dart';
import '../../memories/domain/memory_event.dart';
import '../../wall/presentation/widgets/wall_background.dart';
import '../memory_search.dart';

/// Finds memories by title, story, place, person or year, as you type.
class MemorySearchPage extends ConsumerStatefulWidget {
  const MemorySearchPage({super.key});

  @override
  ConsumerState<MemorySearchPage> createState() => _MemorySearchPageState();
}

class _MemorySearchPageState extends ConsumerState<MemorySearchPage> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(memoryRepositoryProvider).asData?.value;
    final results = state == null
        ? const <MemoryEvent>[]
        : searchMemories(state, _query.text);
    final typed = _query.text.trim().isNotEmpty;

    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: TopBarPage(
            title: l10n.searchTitle,
            body: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                TextField(
                  key: const ValueKey('memory-search-field'),
                  controller: _query,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: typed
                        ? IconButton(
                            tooltip: l10n.searchClear,
                            onPressed: () => setState(_query.clear),
                            icon: const Icon(Icons.close_rounded),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                // Before typing: suggestions from one's own memories.
                if (!typed && state != null)
                  _Suggestions(
                    suggestions: searchSuggestions(state),
                    onPick: (text) => setState(() {
                      _query.text = text;
                      _query.selection = TextSelection.collapsed(
                        offset: text.length,
                      );
                    }),
                  ),
                if (typed && results.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      children: [
                        Text(
                          l10n.searchNoResults,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => setState(_query.clear),
                          icon: const Icon(Icons.close_rounded),
                          label: Text(l10n.searchClear),
                        ),
                      ],
                    ),
                  )
                else if (typed)
                  Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        l10n.searchResultCount(results.length),
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                for (final event in results) _ResultTile(event: event),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.event});

  final MemoryEvent event;

  @override
  Widget build(BuildContext context) {
    final path = event.coverPhotoPath;
    final isAsset = path?.startsWith('assets/') ?? false;
    final exists = path != null && (isAsset || File(path).existsSync());
    final date = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(event.occurredAt);
    final place = event.locationDisplayLabel;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: AppColors.line),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.panelWarm.withValues(alpha: 0.88),
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: () => context.push('/memories/${event.id}'),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: !exists
                        ? ColoredBox(
                            color: event.coverColor,
                            child: Icon(event.feeling.icon),
                          )
                        : isAsset
                        ? Image.asset(path, fit: BoxFit.cover)
                        : Image.file(
                            File(path),
                            fit: BoxFit.cover,
                            cacheWidth: 200,
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        place.isEmpty ? date : '$date · $place',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.suggestions, required this.onPick});

  final List<String> suggestions;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.searchSuggestions,
          style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final suggestion in suggestions)
              ActionChip(
                label: Text(suggestion),
                avatar: Icon(
                  RegExp(r'^\d{4}$').hasMatch(suggestion)
                      ? Icons.calendar_month_rounded
                      : Icons.search_rounded,
                  size: 18,
                ),
                onPressed: () => onPick(suggestion),
              ),
          ],
        ),
      ],
    );
  }
}
