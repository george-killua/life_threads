// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// memory detail, connections and people.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_cloud_share_service.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_service.dart';
import 'package:life_threads/features/capsule/domain/memory_capsule_models.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_connection.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_photo.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/memories/presentation/pages/manage_connections_page.dart';
import 'package:life_threads/features/memories/presentation/pages/memory_detail_page.dart';
import 'package:life_threads/features/memories/presentation/widgets/memory_people_editor.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

MemoryEvent ev(String id, String title, {bool hidden = false}) => MemoryEvent(
  id: id,
  title: title,
  description: 'Story',
  category: MemoryCategory.travel,
  memoryType: MemoryType.trip,
  feeling: MemoryFeeling.calm,
  occurredAt: DateTime(2024, 6, 12),
  createdAt: DateTime(2024, 6, 12),
  coverColor: const Color(0xFFD2A24A),
  wallPosition: Offset.zero,
  rotation: 0,
  locationLabel: '',
  hidden: hidden,
);

MemoryState stateWith({List<MemoryPhoto> photos = const []}) => MemoryState(
  events: [ev('a', 'Visible walk'), ev('b', 'SECRET hidden', hidden: true)],
  connections: const [
    MemoryConnection(id: 'c1', fromEventId: 'a', toEventId: 'b', label: ''),
  ],
  photos: photos,
  people: const [],
  wallItems: const [],
);

class FakeRepo extends MemoryRepository {
  FakeRepo(this.s);
  final MemoryState s;
  @override
  Future<MemoryState> build() async => s;
}

class InstantCapsule extends MemoryCapsuleService {
  @override
  Future<MemoryCapsuleExportResult> exportCapsule({
    required MemoryState state,
    required String memoryId,
    String? password,
  }) async => const MemoryCapsuleExportResult(
    path: '/x.ltcapsule',
    title: 't',
    photoCount: 0,
    noteCount: 0,
    connectionCount: 0,
    isEncrypted: true,
  );
}

class RecordingCloud extends MemoryCapsuleCloudShareService {
  RecordingCloud();
  int revoked = 0;
  @override
  Future<MemoryCapsuleCloudShareResult> uploadCapsule({
    required MemoryCapsuleExportResult capsule,
    int expiresInDays = 14,
  }) async => const MemoryCapsuleCloudShareResult(
    shareUrl: 'https://example.test/s/1',
    expiresAt: null,
    revokeToken: '***',
  );
  @override
  Future<void> revokeShare(MemoryCapsuleCloudShareResult share) async {
    revoked++;
  }
}

Widget app(
  Widget page, {
  MemoryState? state,
  Locale locale = const Locale('en'),
  List<Override> overrides = const [],
}) => ProviderScope(
  overrides: [
    memoryRepositoryProvider.overrideWith(() => FakeRepo(state ?? stateWith())),
    ...overrides,
  ],
  child: MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => page)),
            child: const Text('HOME'),
          ),
        ),
      ),
    ),
  ),
);

Future<void> open(WidgetTester tester, Widget w) async {
  await tester.binding.setSurfaceSize(const Size(800, 3000));
  await tester.pumpWidget(w);
  await tester.tap(find.text('HOME'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('M3-01a detail page of a visible memory must not reveal a '
      'hidden connected memory', (tester) async {
    await open(tester, app(const MemoryDetailPage(memoryId: 'a')));
    expect(find.text('Visible walk'), findsWidgets);
    expect(
      find.textContaining('SECRET hidden', skipOffstage: false),
      findsNothing,
      reason: 'hidden memory shown in Connected memories without Face ID',
    );
  });

  testWidgets('M3-01b manage connections must not list hidden memories', (
    tester,
  ) async {
    await open(tester, app(const ManageConnectionsPage(memoryId: 'a')));
    expect(
      find.textContaining('SECRET hidden', skipOffstage: false),
      findsNothing,
      reason: 'hidden memory listed as connection candidate',
    );
  });

  testWidgets('M3-02 iOS contact picker error shows a message and re-enables '
      'the button', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    const channel = MethodChannel('dev.gkcoding.lifethreads/contact_picker');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (call) async => throw PlatformException(code: 'contact_picker_busy'),
    );
    Object? uncaught;
    try {
      await runZonedGuarded(() async {
        await open(
          tester,
          app(
            Scaffold(
              body: MemoryPeopleEditor(people: const [], onChanged: (_) {}),
            ),
          ),
        );
        await tester.tap(find.text('Add person'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Choose from contacts'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      }, (e, _) => uncaught = e);
      expect(uncaught, isNull, reason: 'uncaught: $uncaught');
      expect(find.text('Could not open contacts.'), findsOneWidget);
      final btn = tester.widget<OutlinedButton>(
        find.ancestor(
          of: find.text('Choose from contacts'),
          matching: find.byWidgetPredicate((w) => w is OutlinedButton),
        ),
      );
      expect(btn.onPressed, isNotNull, reason: 'button stuck disabled');
    } finally {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      );
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('M3-03 toast Delete after leaving the detail page revokes the '
      'shared link', (tester) async {
    const share = MethodChannel('dev.fluttercommunity.plus/share');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      share,
      (call) async => 'dev.fluttercommunity.plus/share/unavailable',
    );
    final cloud = RecordingCloud();
    await open(
      tester,
      app(
        const MemoryDetailPage(memoryId: 'a'),
        overrides: [
          memoryCapsuleServiceProvider.overrideWithValue(InstantCapsule()),
          memoryCapsuleCloudShareServiceProvider.overrideWithValue(cloud),
        ],
      ),
    );
    await tester.tap(find.text('Share Memory Capsule').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'secret-pass');
    await tester.tap(find.text('Create Secure Share'));
    await tester.pumpAndSettle();
    expect(find.text('Delete'), findsOneWidget, reason: 'toast with Delete');
    // User goes back to the wall; the toast (9 s) stays on the messenger.
    final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
    nav.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(MemoryDetailPage), findsNothing);
    await tester.tap(find.text('Delete'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final error = tester.takeException();
    expect(error, isNull, reason: 'Delete threw: $error');
    expect(cloud.revoked, 1, reason: 'shared link was not revoked');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(share, null);
  });

  testWidgets('M3-04 photo preview titles are localized (de)', (tester) async {
    final photos = [
      for (final i in [1, 2])
        MemoryPhoto(
          id: 'p$i',
          eventId: 'a',
          localPath: '/nonexistent/p$i.jpg',
          capturedAt: DateTime(2024, 6, 12),
          width: 100,
          height: 100,
        ),
    ];
    await open(
      tester,
      app(
        const MemoryDetailPage(memoryId: 'a'),
        state: stateWith(photos: photos),
        locale: const Locale('de'),
      ),
    );
    await tester.tap(find.byIcon(Icons.broken_image_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('Photo 1'), findsNothing, reason: 'English in de UI');
  });
}
