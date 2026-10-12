import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/music_track.dart';
import '../domain/story_film.dart';

/// Turns stories into files and hands them to the user. Shared by Create
/// Story and Thread of the Year.
final storyExporterProvider = Provider<StoryExporter>(
  (ref) => throw UnimplementedError('StoryExporter is not implemented yet.'),
);

abstract interface class StoryExporter {
  /// Renders [page] as a 1080×1920 PNG in the temporary directory.
  Future<File> exportImage(BuildContext context, Widget page);

  /// Renders [film] as a 1080×1920 MP4 in the temporary directory, with
  /// [music] trimmed to the film and faded out. [onProgress] gets 0..1.
  /// Throws [StoryExportCancelled] after [cancel] is triggered.
  Future<File> exportVideo(
    BuildContext context,
    StoryFilm film, {
    MusicTrack? music,
    void Function(double progress)? onProgress,
    StoryExportCancel? cancel,
  });

  /// Opens the system share sheet (Instagram, Facebook, Snapchat, ...).
  /// Returns true when the user picked a target.
  Future<bool> share(BuildContext context, File file, {String? text});

  /// Saves an exported image or video to the photo library.
  Future<void> saveToGallery(File file);
}

class StoryExportCancel {
  bool _cancelled = false;

  bool get isCancelled => _cancelled;

  void cancel() => _cancelled = true;
}

class StoryExportCancelled implements Exception {
  const StoryExportCancelled();
}
