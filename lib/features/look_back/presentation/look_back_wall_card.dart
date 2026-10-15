import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/localization/app_localizations_x.dart';
import '../data/look_back_providers.dart';

/// "Your month in memories" on the wall in the first week of a month, for
/// the month before. Free.
class LookBackWallCard extends ConsumerWidget {
  const LookBackWallCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookBack = ref.watch(lookBackWallCardProvider);
    if (lookBack == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    final monthName = DateFormat.MMMM(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(DateTime(lookBack.year, lookBack.month));
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
          key: const ValueKey('look-back-wall-card'),
          borderRadius: BorderRadius.circular(22),
          onTap: () => context.push(
            RouteNames.lookBackFor(lookBack.year, lookBack.month),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(13, 8, 4, 8),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
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
                        l10n.lookBackWallCardTitle,
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
                        l10n.lookBackWallCardBody(
                          monthName,
                          lookBack.memories.length,
                        ),
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
                      .read(lookBackCardDismissalProvider.notifier)
                      .dismiss(lookBack.year, lookBack.month),
                  icon: Icon(
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
