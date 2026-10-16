import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/media/data/picked_memory_photo.dart';
import 'package:life_threads/features/memories/data/memory_draft_store.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/presentation/pages/add_memory_page.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _EmptyRepo extends MemoryRepository {
  @override
  Future<MemoryState> build() async => const MemoryState(
    events: [],
    connections: [],
    photos: [],
    people: [],
    wallItems: [],
  );
}

class _Free extends PremiumEntitlementController {
  @override
  Future<PremiumEntitlement> build() async =>
      const PremiumEntitlement(isPremium: false, isMockUnlocked: false);
}

Future<GoRouter> _pumpApp(WidgetTester tester) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('WALL')),
      ),
      GoRoute(
        path: RouteNames.addMemory,
        builder: (_, _) => const AddMemoryPage(),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        memoryRepositoryProvider.overrideWith(_EmptyRepo.new),
        premiumEntitlementProvider.overrideWith(_Free.new),
        // path_provider has no test implementation.
        memoryDraftStoreProvider.overrideWithValue(
          MemoryDraftStore(documentsPath: () async => '/documents'),
        ),
      ],
      child: MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();
  return router;
}

Future<void> _openAdd(WidgetTester tester, GoRouter router) async {
  router.push(RouteNames.addMemory);
  await tester.pumpAndSettle();
}

Future<void> _leave(WidgetTester tester, {bool expectKept = false}) async {
  await tester.tap(find.byTooltip('Back'));
  if (expectKept) {
    await tester.pumpAndSettle();
    expect(find.textContaining('Kept as a draft'), findsOneWidget);
  }
  // Past the autosave delay and the toast.
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle(const Duration(seconds: 10));
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('MemoryDraftStore', () {
    late Directory documents;

    setUp(() async {
      documents = await Directory.systemTemp.createTemp('draft_test');
    });
    tearDown(() => documents.delete(recursive: true));

    test('keeps a draft, with photo paths relative to documents', () async {
      final photoDir = Directory('${documents.path}/memory_photos')
        ..createSync();
      final kept = File('${photoDir.path}/a.jpg')..writeAsStringSync('x');
      final store = MemoryDraftStore(documentsPath: () async => documents.path);

      await store.save(
        MemoryDraft(
          savedAt: DateTime(2026, 10, 14),
          title: 'Beach day',
          feeling: MemoryFeeling.proud,
          step: 2,
          photos: [
            PickedMemoryPhoto(
              localPath: kept.path,
              capturedAt: DateTime(2026, 8, 1),
              width: 10,
              height: 20,
              hasCapturedDate: true,
              hasDimensions: true,
              latitude: 43.5,
              longitude: 16.4,
            ),
            PickedMemoryPhoto(
              localPath: '${photoDir.path}/gone.jpg',
              capturedAt: DateTime(2026, 8, 1),
              width: 10,
              height: 20,
              hasCapturedDate: true,
              hasDimensions: true,
            ),
          ],
          people: const [
            MemoryPersonDraft(name: 'Mia', relationship: 'Friend'),
          ],
        ),
      );
      final raw = (await SharedPreferences.getInstance()).getString(
        'add_memory_draft_v1',
      )!;
      expect(raw, contains('memory_photos/a.jpg'));
      expect(raw, isNot(contains(documents.path)));

      final draft = await store.load();
      expect(draft!.title, 'Beach day');
      expect(draft.feeling, MemoryFeeling.proud);
      expect(draft.step, 2);
      expect(draft.people.single.name, 'Mia');
      // The missing photo is left out.
      expect(draft.photos.map((p) => p.localPath), [kept.path]);
      expect(draft.photos.single.latitude, 43.5);
    });

    test('keeps the wall it was started for', () async {
      final store = MemoryDraftStore(documentsPath: () async => documents.path);
      await store.save(
        MemoryDraft(savedAt: DateTime(2026), title: 'Trip', toWall: 'w1'),
      );
      expect((await store.load())!.toWall, 'w1');
      await store.save(
        MemoryDraft(savedAt: DateTime(2026), title: 'Home', toWall: ''),
      );
      expect((await store.load())!.toWall, '');
    });

    test('an empty draft is not kept', () async {
      final store = MemoryDraftStore(documentsPath: () async => documents.path);
      await store.save(MemoryDraft(savedAt: DateTime(2026), title: 'x'));
      await store.save(MemoryDraft(savedAt: DateTime(2026)));
      expect(await store.load(), isNull);
    });

    test('a save still running when the memory is saved does not come '
        'back', () async {
      final store = MemoryDraftStore(documentsPath: () async => documents.path);
      // Not awaited: the debounced autosave is still writing.
      final pending = store.save(
        MemoryDraft(savedAt: DateTime(2026), title: 'Saved memory'),
      );
      await store.clear();
      await pending;
      expect(await store.load(), isNull);
    });

    test('start over keeps photos that saved memories use', () async {
      final shared = File('${documents.path}/shared.jpg')
        ..writeAsStringSync('x');
      final own = File('${documents.path}/own.jpg')..writeAsStringSync('x');
      PickedMemoryPhoto photo(File file) => PickedMemoryPhoto(
        localPath: file.path,
        capturedAt: DateTime(2026),
        width: 1,
        height: 1,
        hasCapturedDate: false,
        hasDimensions: false,
      );
      final store = MemoryDraftStore(documentsPath: () async => documents.path);
      final draft = MemoryDraft(
        savedAt: DateTime(2026),
        photos: [photo(shared), photo(own)],
      );
      await store.save(draft);
      await store.clear(deletePhotosOf: draft, keepPhotos: {shared.path});
      expect(shared.existsSync(), isTrue);
      expect(own.existsSync(), isFalse);
    });

    test('start over deletes the draft photo copies', () async {
      final photo = File('${documents.path}/p.jpg')..writeAsStringSync('x');
      final store = MemoryDraftStore(documentsPath: () async => documents.path);
      final draft = MemoryDraft(
        savedAt: DateTime(2026),
        photos: [
          PickedMemoryPhoto(
            localPath: photo.path,
            capturedAt: DateTime(2026),
            width: 1,
            height: 1,
            hasCapturedDate: false,
            hasDimensions: false,
          ),
        ],
      );
      await store.save(draft);
      await store.clear(deletePhotosOf: draft);
      expect(await store.load(), isNull);
      expect(photo.existsSync(), isFalse);
    });
  });

  testWidgets('an unsaved memory comes back with Continue', (tester) async {
    final router = await _pumpApp(tester);
    await _openAdd(tester, router);
    expect(find.text('Continue where you left off?'), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'Lisbon trip');
    await _leave(tester, expectKept: true);
    expect(find.text('WALL'), findsOneWidget);

    await _openAdd(tester, router);
    expect(find.text('Continue where you left off?'), findsOneWidget);
    expect(find.textContaining('“Lisbon trip”'), findsOneWidget);
    await tester.tap(find.text('Continue draft'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Lisbon trip'), findsOneWidget);
  });

  testWidgets('Start new clears the draft', (tester) async {
    final router = await _pumpApp(tester);
    await _openAdd(tester, router);
    await tester.enterText(find.byType(TextField).first, 'Old idea');
    await _leave(tester);

    await _openAdd(tester, router);
    await tester.tap(find.text('Start new'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Old idea'), findsNothing);
    await _leave(tester);

    await _openAdd(tester, router);
    expect(find.text('Continue where you left off?'), findsNothing);
  });
}
