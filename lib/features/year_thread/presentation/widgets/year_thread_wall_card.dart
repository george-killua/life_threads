import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../data/year_thread_providers.dart';

/// "Your year in memories" on the wall in December and January. Shown with
/// or without Premium: the screen it opens gates the export.
class YearThreadWallCard extends ConsumerWidget {
  const YearThreadWallCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(yearThreadWallCardYearProvider);
    if (year == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.panelWarm.withValues(alpha: 0.92),
            AppColors.wallInk.withValues(alpha: 0.84),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          key: const ValueKey('year-thread-wall-card'),
          borderRadius: BorderRadius.circular(22),
          onTap: () => context.push(RouteNames.yearThreadFor(year)),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(13, 8, 4, 8),
            child: Row(
              children: [
                Icon(
                  Icons.movie_filter_rounded,
                  color: AppColors.gold,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.yearThreadWallCardTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.yearThreadWallCardBody('$year'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.yearThreadDismiss,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => ref
                      .read(yearThreadCardDismissalProvider.notifier)
                      .dismiss(year),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.muted,
                    size: 20,
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
