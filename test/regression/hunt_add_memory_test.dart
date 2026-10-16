// Regression tests from the 2026-10-16 whole-codebase bug hunt: add memory.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/memories/domain/personal_wall.dart';
import 'package:life_threads/core/database/database_provider.dart';
import 'package:life_threads/features/memories/data/memory_draft_store.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/presentation/pages/add_memory_page.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Repo extends MemoryRepository {
  NewMemoryDraft? added;
  @override
  Future<MemoryState> build() async => MemoryState(
    events: const [],
    connections: const [],
    photos: const [],
    people: const [],
    wallItems: const [],
    walls: [
      PersonalWall(id: 'wallY', name: 'Family', createdAt: DateTime(2025)),
    ],
  );
}

class _CapturingRepo extends _Repo {
  @override
  Future<void> addMemory(NewMemoryDraft draft) async => added = draft;
}

class _Free extends PremiumEntitlementController {
  @override
  Future<PremiumEntitlement> build() async =>
      const PremiumEntitlement(isPremium: false, isMockUnlocked: false);
}

Future<void> _pump(
  WidgetTester tester,
  Widget page, {
  required MemoryRepository repo,
  MemoryDraftStore? store,
  List<Override> extra = const [],
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('WALL')),
      ),
      GoRoute(path: RouteNames.addMemory, builder: (_, _) => page),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        memoryRepositoryProvider.overrideWith(() => repo),
        premiumEntitlementProvider.overrideWith(_Free.new),
        memoryDraftStoreProvider.overrideWithValue(
          store ?? MemoryDraftStore(documentsPath: () async => '/documents'),
        ),
        ...extra,
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
  router.push(RouteNames.addMemory);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => '/tmp/m2_docs_unused',
        );
  });

  testWidgets('M2-01 failed save: the form stays usable for a retry', (
    tester,
  ) async {
    await _pump(
      tester,
      const AddMemoryPage(),
      repo: _Repo(),
      extra: [
        appDatabaseProvider.overrideWith(
          (ref) => throw StateError('disk full'),
        ),
      ],
    );
    await tester.enterText(find.byType(TextField).first, 'My wedding day');
    await tester.pump();
    await tester.tap(find.text('Save now'));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('WALL'), findsNothing);
    expect(
      find.textContaining('disk full'),
      findsNothing,
      reason: 'raw exception text replaces the form',
    );
    expect(
      find.widgetWithText(TextField, 'My wedding day'),
      findsOneWidget,
      reason: 'form replaced after a failed save; no way to retry',
    );
  });

  testWidgets('M2-02 continuing a draft from "Add a memory to 2023" keeps '
      'the year', (tester) async {
    final store = MemoryDraftStore(documentsPath: () async => '/documents');
    await store.save(
      MemoryDraft(savedAt: DateTime(2026, 10, 15), title: 'Old trip', step: 3),
    );
    final repo = _CapturingRepo();
    await _pump(
      tester,
      AddMemoryPage(initialDate: DateTime(2023, 6, 1), toWall: 'wallY'),
      repo: repo,
      store: store,
    );
    await tester.tap(find.text('Continue draft'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hang on wall'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(repo.added, isNotNull);
    expect(repo.added!.wallId, 'wallY');
    expect(
      repo.added!.occurredAt.year,
      2023,
      reason: 'memory meant for 2023 saved with today\'s date',
    );
  });
}
