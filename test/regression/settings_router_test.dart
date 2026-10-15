// Router fallbacks, Clear All and feedback mail behaviour.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/app.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/app/router/app_router.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class FakeLauncher extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  final launched = <String>[];
  @override
  LinkDelegate? get linkDelegate => null;
  @override
  Future<bool> canLaunch(String url) async => true;
  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);
    return true;
  }
}

late Directory docs;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    docs = await Directory.systemTemp.createTemp('p10_docs_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => docs.path,
        );
    for (final ch in [
      'com.llfbandit.app_links/events',
      'com.llfbandit.app_links/messages',
    ]) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(ch), (call) async => null);
    }
  });
  tearDown(() async {
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  testWidgets('OS-delivered share link path must not dead-end on the '
      'router error page', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ProviderScope(child: LifeThreadsApp()));
    await tester.pump();
    await tester.pump();
    expect(find.text('Build your living wall.'), findsOneWidget);

    // What the iOS embedder sends for https://gkcoding.dev/lifethreads/share/abc
    // when FlutterDeepLinkingEnabled is not set to false.
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      SystemChannels.navigation.name,
      SystemChannels.navigation.codec.encodeMethodCall(
        const MethodCall('pushRouteInformation', {
          'location': '/lifethreads/share/abc',
          'state': null,
        }),
      ),
      (_) {},
    );
    await tester.pump();
    await tester.pump();
    expect(
      find.textContaining('Page Not Found'),
      findsNothing,
      reason: 'no errorBuilder/redirect: unknown path shows a dead-end page',
    );
  });

  testWidgets('/capsule/cinema without extra must not render a blank '
      'screen with no way back', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ProviderScope(child: LifeThreadsApp()));
    await tester.pump();
    await tester.pump();
    AppRouter.router.go('/capsule/cinema');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(
      find.byType(Scaffold),
      findsWidgets,
      reason: 'route builder returns SizedBox.shrink(): black, no back button',
    );
  });

  test('clearAllData ("permanently removes all local data") must '
      'also remove the display name and cloud sync key', () async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
      'user_display_name': 'George',
      'lifethreads.cloud_sync_key': 'lt_***_***',
    });
    final c = ProviderContainer();
    c.listen(memoryRepositoryProvider, (_, _) {});
    await c.read(memoryRepositoryProvider.future);
    await c.read(memoryRepositoryProvider.notifier).clearAllData();
    final prefs = await SharedPreferences.getInstance();
    final leftovers = {
      for (final k in ['user_display_name', 'lifethreads.cloud_sync_key'])
        if (prefs.containsKey(k)) k,
    };
    c.dispose();
    expect(leftovers, isEmpty);
  });

  testWidgets('feedback mailto body must keep spaces (no "+")', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': false});
    PackageInfo.setMockInitialValues(
      appName: 'LifeThreads',
      packageName: 'dev.test',
      version: '0.1.7',
      buildNumber: '1',
      buildSignature: '',
    );
    tester.view.physicalSize = const Size(800, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final launcher = FakeLauncher();
    UrlLauncherPlatform.instance = launcher;

    await tester.pumpWidget(const ProviderScope(child: LifeThreadsApp()));
    await tester.pump();
    await tester.pump();
    AppRouter.router.go(RouteNames.aboutHelp);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Send Feedback'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Feedback'),
      'wall drag is slow',
    );
    await tester.tap(find.text('Send'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(launcher.launched, hasLength(1));
    final url = launcher.launched.single;
    // RFC 6068: mail clients do not treat "+" as space.
    final rawBody = url.split('body=').last;
    expect(
      Uri.decodeComponent(rawBody),
      contains('wall drag is slow'),
      reason: 'launched: ${url.substring(0, 160)}',
    );
  });
}
