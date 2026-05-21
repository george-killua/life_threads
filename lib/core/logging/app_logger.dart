import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppLogger {
  AppLogger._();

  static const _maxEntries = 80;
  static final Queue<AppLogEntry> _entries = Queue<AppLogEntry>();

  static void installCrashHandlers() {
    final previousFlutterError = FlutterError.onError;
    FlutterError.onError = (details) {
      recordCrash(details.exception, details.stack);
      if (previousFlutterError != null) {
        previousFlutterError(details);
      } else {
        FlutterError.presentError(details);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      recordCrash(error, stack);
      return false;
    };
  }

  static void event(String name) {
    _add(AppLogEntry.event(name));
  }

  static void recordCrash(Object error, StackTrace? stackTrace) {
    _add(
      AppLogEntry.crash(
        errorType: error.runtimeType.toString(),
        stackHash: stackTrace == null
            ? 'none'
            : stackTrace.toString().hashCode.toString(),
      ),
    );
  }

  static List<AppLogEntry> recentEntries() {
    return List.unmodifiable(_entries);
  }

  @visibleForTesting
  static void clearForTesting() {
    _entries.clear();
  }

  static Future<String> betaDiagnostics() async {
    final info = await PackageInfo.fromPlatform();
    final buffer = StringBuffer()
      ..writeln('LifeThreads beta diagnostics')
      ..writeln('Version: ${info.version}+${info.buildNumber}')
      ..writeln('Package: ${info.packageName}')
      ..writeln(
        'Private content policy: no memory titles, stories, notes, photo paths, backup paths, or exact locations are logged.',
      )
      ..writeln('Recent app events:');

    if (_entries.isEmpty) {
      buffer.writeln('- none');
    } else {
      for (final entry in _entries) {
        buffer.writeln('- ${entry.toSafeLine()}');
      }
    }

    return buffer.toString();
  }

  static void _add(AppLogEntry entry) {
    if (_entries.length >= _maxEntries) {
      _entries.removeFirst();
    }
    _entries.add(entry);
    if (kDebugMode) {
      debugPrint(entry.toSafeLine());
    }
  }
}

class AppLogEntry {
  const AppLogEntry._({
    required this.type,
    required this.name,
    required this.timestamp,
    this.errorType,
    this.stackHash,
  });

  factory AppLogEntry.event(String name) {
    return AppLogEntry._(
      type: 'event',
      name: _safeName(name),
      timestamp: DateTime.now().toUtc(),
    );
  }

  factory AppLogEntry.crash({
    required String errorType,
    required String stackHash,
  }) {
    return AppLogEntry._(
      type: 'crash',
      name: 'uncaught_error',
      timestamp: DateTime.now().toUtc(),
      errorType: _safeName(errorType),
      stackHash: stackHash,
    );
  }

  final String type;
  final String name;
  final DateTime timestamp;
  final String? errorType;
  final String? stackHash;

  String toSafeLine() {
    final parts = [
      timestamp.toIso8601String(),
      type,
      name,
      if (errorType != null) 'errorType=$errorType',
      if (stackHash != null) 'stackHash=$stackHash',
    ];
    return parts.join(' | ');
  }

  static String _safeName(String value) {
    return value.replaceAll(RegExp('[^a-zA-Z0-9_.-]'), '_');
  }
}
