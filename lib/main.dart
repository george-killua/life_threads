import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/logging/app_logger.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    AppLogger.installCrashHandlers();
    AppLogger.event('app_started');
    runApp(const ProviderScope(child: LifeThreadsApp()));
  }, AppLogger.recordCrash);
}
