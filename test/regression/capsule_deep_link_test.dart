import 'dart:async';

import 'package:app_links_platform_interface/app_links_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_share_download_service.dart';
import 'package:life_threads/features/capsule/presentation/widgets/memory_capsule_deep_link_listener.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakeLinks extends AppLinksPlatform with MockPlatformInterfaceMixin {
  final controller = StreamController<Uri>.broadcast();
  @override
  Future<Uri?> getInitialLink() async => null;
  @override
  Stream<Uri> get uriLinkStream => controller.stream;
}

class _OfflineDownloads extends MemoryCapsuleShareDownloadService {
  _OfflineDownloads();
  int calls = 0;
  int checks = 0;
  @override
  bool isShareLink(Uri uri) {
    checks++;
    return super.isShareLink(uri);
  }

  @override
  Future<List<int>> downloadCapsule(Uri shareUri) async {
    calls++;
    throw const MemoryCapsuleShareDownloadException(
      'You appear to be offline.',
    );
  }
}

void main() {
  testWidgets('same share link can be retried after a failed import', (
    tester,
  ) async {
    final links = _FakeLinks();
    AppLinksPlatform.instance = links;
    final downloads = _OfflineDownloads();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoryCapsuleShareDownloadServiceProvider.overrideWithValue(
            downloads,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: MemoryCapsuleDeepLinkListener(child: SizedBox()),
          ),
        ),
      ),
    );
    await tester.pump();
    final link = Uri.parse('https://gkcoding.dev/lifethreads/share/abc123');

    expect(
      links.controller.hasListener,
      isTrue,
      reason: "listener not attached",
    );
    links.controller.add(link); // first tap: offline
    for (var i = 0; i < 5; i++) {
      tester.binding.scheduleFrame();
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(
      downloads.calls,
      1,
      reason:
          'checks=${downloads.checks} exc=${tester.takeException()} dialogs=${find.byType(AlertDialog).evaluate().length} texts=${tester.widgetList<Text>(find.byType(Text)).map((t) => t.data).toList()}',
    );

    links.controller.add(link); // user taps the same link again once online
    for (var i = 0; i < 5; i++) {
      tester.binding.scheduleFrame();
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(
      downloads.calls,
      2,
      reason: 'link stays in _handledLinks after failure; retry ignored',
    );
    await tester.pump(const Duration(seconds: 8)); // let snackbars expire
  });
}
