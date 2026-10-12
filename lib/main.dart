import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/logging/app_logger.dart';
import 'features/backup/data/backup_service.dart';
import 'features/stories/data/story_files.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppLogger.installCrashHandlers();
    AppLogger.event('app_started');
    runApp(const ProviderScope(child: LifeThreadsApp()));
    // Archives shared in an earlier session are no longer needed: the
    // receiving app has its copy.
    unawaited(
      const BackupService().deleteExportedArchives().catchError(
        (Object error) => AppLogger.event('export_cleanup_failed'),
      ),
    );
    // Story images and videos likewise: shared or saved by now.
    unawaited(
      const StoryFiles().deleteExportedStories().catchError(
        (Object error) => AppLogger.event('story_cleanup_failed'),
      ),
    );
  }, AppLogger.recordCrash);
}
