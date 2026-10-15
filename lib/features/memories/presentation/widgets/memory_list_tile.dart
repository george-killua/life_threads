import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/memory_event.dart';

/// A memory in a list: photo, title, date and place; opens the memory.
class MemoryListTile extends StatelessWidget {
  const MemoryListTile({super.key, required this.event});

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
