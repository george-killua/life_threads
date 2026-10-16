// Regression: closing the "Continue where you left off?" dialog with the system
// back button (Android) was treated as "Start new" and deleted the draft.
// Expected: back just closes the dialog and keeps the draft for next time.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/memories/data/memory_draft_store.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
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

void main() {
  testWidgets('system back on the draft dialog keeps the draft', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final store = MemoryDraftStore(documentsPath: () async => '/documents');
    await store.save(
      MemoryDraft(savedAt: DateTime(2026, 10, 15), title: 'Half a thought'),
    );
    final router = GoRouter(
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
          memoryDraftStoreProvider.overrideWithValue(store),
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
    expect(find.text('Continue where you left off?'), findsOneWidget);

    // Android back button / predictive back gesture.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Continue where you left off?'), findsNothing);

    final kept = await store.load();
    expect(kept?.title, 'Half a thought', reason: 'the draft was deleted');
  });
}
