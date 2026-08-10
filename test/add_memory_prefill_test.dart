import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/media/data/picked_memory_photo.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/presentation/pages/add_memory_page.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _EmptyMemoryRepository extends MemoryRepository {
  @override
  Future<MemoryState> build() async {
    return const MemoryState(
      events: [],
      connections: [],
      photos: [],
      people: [],
      wallItems: [],
    );
  }
}

class _FreePremiumController extends PremiumEntitlementController {
  @override
  Future<PremiumEntitlement> build() async {
    return const PremiumEntitlement(
      isPremium: false,
      isMockUnlocked: false,
    );
  }
}

PickedMemoryPhoto _photo({
  required String path,
  String? title,
  DateTime? capturedAt,
}) {
  return PickedMemoryPhoto(
    localPath: path,
    capturedAt: capturedAt ?? DateTime(2024, 6, 15, 12),
    width: 1200,
    height: 900,
    hasCapturedDate: true,
    hasDimensions: true,
    title: title,
  );
}

Future<void> _pumpAddMemory(
  WidgetTester tester, {
  required List<PickedMemoryPhoto> photos,
}) async {
  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        memoryRepositoryProvider.overrideWith(_EmptyMemoryRepository.new),
        premiumEntitlementProvider.overrideWith(_FreePremiumController.new),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AddMemoryPage(initialPhotos: photos),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AddMemoryPage prefills captured photos', (tester) async {
    // Missing files hit Image.file errorBuilder; avoids decode hangs in tests.
    await _pumpAddMemory(
      tester,
      photos: [
        _photo(
          path: '/tmp/life_threads_missing_one.jpg',
          title: 'Beach walk',
        ),
        _photo(path: '/tmp/life_threads_missing_two.jpg'),
      ],
    );

    expect(find.text('Save a moment'), findsOneWidget);
    expect(find.text('Cover photo'), findsOneWidget);
    expect(find.text('2/2 dates'), findsOneWidget);
    expect(find.text('Add more'), findsOneWidget);
    expect(find.text('Pick'), findsNothing);

    // Title defaults from the first photo name after post-frame callback.
    await tester.pump();
    expect(find.text('Beach walk'), findsOneWidget);
  });

  testWidgets('router passes camera photos into AddMemoryPage', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final photos = [
      _photo(
        path: '/tmp/life_threads_missing_shot.jpg',
        title: 'Sunset',
      ),
    ];
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('home')),
        ),
        GoRoute(
          path: RouteNames.addMemory,
          builder: (context, state) {
            final extra = state.extra;
            final initialPhotos = extra is List<PickedMemoryPhoto>
                ? extra
                : const <PickedMemoryPhoto>[];
            return AddMemoryPage(initialPhotos: initialPhotos);
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoryRepositoryProvider.overrideWith(_EmptyMemoryRepository.new),
          premiumEntitlementProvider.overrideWith(_FreePremiumController.new),
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

    router.push(RouteNames.addMemory, extra: photos);
    await tester.pump();
    await tester.pump();

    expect(find.text('Cover photo'), findsOneWidget);
    expect(find.text('1/1 dates'), findsOneWidget);
    await tester.pump();
    expect(find.text('Sunset'), findsOneWidget);
  });

  testWidgets('AddMemoryPage without photos shows empty picker', (tester) async {
    await _pumpAddMemory(tester, photos: const []);

    expect(find.text('Cover photo'), findsNothing);
    expect(find.text('Pick'), findsOneWidget);
  });
}
