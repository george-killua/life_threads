import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/core/database/database_provider.dart';
import 'package:life_threads/features/media/data/picked_memory_photo.dart';
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

PickedMemoryPhoto _photo(String path, DateTime at) => PickedMemoryPhoto(
  localPath: path,
  capturedAt: at,
  width: 10,
  height: 10,
  hasCapturedDate: true,
  hasDimensions: true,
);

Future<GoRouter> _pump(
  WidgetTester tester,
  List<PickedMemoryPhoto> photos, {
  List<Override> extra = const [],
}) async {
  SharedPreferences.setMockInitialValues({});
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('WALL')),
      ),
      GoRoute(
        path: RouteNames.addMemory,
        builder: (_, _) => AddMemoryPage(initialPhotos: photos),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        memoryRepositoryProvider.overrideWith(_EmptyRepo.new),
        premiumEntitlementProvider.overrideWith(_Free.new),
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
  return router;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => '/tmp/p7_docs_unused',
        );
  });
  testWidgets('failed save keeps the user on the form', (tester) async {
    await _pump(
      tester,
      const [],
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
    // addMemory failed (repository state is AsyncError) -> draft must survive.
    expect(
      find.text('WALL'),
      findsNothing,
      reason: 'page popped to wall although the save failed; draft lost',
    );
  });

  testWidgets('removing the photo that set the date resets it', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pump(tester, [
      _photo('/tmp/p7_missing_a.jpg', DateTime(2019, 3, 2, 12)),
      _photo('/tmp/p7_missing_b.jpg', DateTime(2024, 6, 15, 12)),
    ]);
    await tester.tap(find.byIcon(Icons.close_rounded).first); // remove A
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(
      find.text('Mar 2, 2019'),
      findsNothing,
      reason: 'date still comes from the removed photo',
    );
    expect(find.text('Jun 15, 2024'), findsOneWidget);
  });

  testWidgets('photo dated after tomorrow: date picker opens', (tester) async {
    await _pump(tester, [
      _photo('/tmp/p7_missing_c.jpg', DateTime(2031, 1, 1)),
    ]);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jan 1, 2031'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
