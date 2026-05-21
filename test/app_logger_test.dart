import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/core/logging/app_logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  setUp(() {
    AppLogger.clearForTesting();
    PackageInfo.setMockInitialValues(
      appName: 'LifeThreads',
      packageName: 'dev.gkcoding.lifethreads',
      version: '0.1.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  test('crash logs do not include exception message content', () {
    AppLogger.recordCrash(
      Exception('private memory title should not be logged'),
      StackTrace.current,
    );

    final line = AppLogger.recentEntries().single.toSafeLine();

    expect(line, contains('crash'));
    expect(line, contains('errorType='));
    expect(line, isNot(contains('private memory title')));
  });

  test('beta diagnostics explain private content exclusion', () async {
    AppLogger.event('beta_feedback_opened');

    final diagnostics = await AppLogger.betaDiagnostics();

    expect(diagnostics, contains('0.1.0+1'));
    expect(diagnostics, contains('dev.gkcoding.lifethreads'));
    expect(diagnostics, contains('no memory titles'));
    expect(diagnostics, contains('beta_feedback_opened'));
  });
}
